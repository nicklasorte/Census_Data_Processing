function [cell_data]=scrap_multi_folder_census_array_data_rev1(app,folder1,top_census_folder,filename_census_data,str_header_array_keep,data_header,tf_rescrap_shape,tf_rescrap_mat)


retry_cd=1;
while(retry_cd==1)
    try
        cd(top_census_folder)
        pause(0.1);
        retry_cd=0;
    catch
        retry_cd=1;
        pause(0.1)
    end
end


var_exist_block_cell=exist(filename_census_data,'file');
if tf_rescrap_mat==1
    var_exist_block_cell=0;
end

if var_exist_block_cell==2
     %%%%%%%%%%Load
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_census_data,'cell_data')
            toc; %%%%%%%1.4 seconds for 81MB
            pause(0.1);
            retry_load=0;
        catch
            retry_load=1
            pause(0.1)
        end
    end
else
    %%%%%%%Read in the shapefile
    tic;
    folder_info=dir(top_census_folder)
    cell_folder_info=struct2cell(folder_info)';
    folder_idx=find(~contains(cell_folder_info(:,1),'.'));
    cell_subfolders=cell_folder_info(folder_idx)

    %%%%%%%%%Cycle through each one
    num_subfolders=length(cell_subfolders)
    cell_data=cell(num_subfolders,2);
    tic;
    for sub_idx=1:1:num_subfolders
        %%%%%%Subfunction: Go to the subfolder
        shape_folder=fullfile(top_census_folder,cell_subfolders{sub_idx});
        temp_split=str2double(strsplit(cell_subfolders{sub_idx},'_'));
        temp_split=temp_split(~isnan(temp_split))
        cell_data{sub_idx,1}=temp_split(2);
        cell_data{sub_idx,2}=generic_scrap_census_array_data_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_array_keep);
        strcat(num2str(sub_idx/num_subfolders*100),'%')
    end
    toc;

    retry_cd=1;
    while(retry_cd==1)
        try
            cd(top_census_folder)
            pause(0.1);
            retry_cd=0;
        catch
            retry_cd=1;
            pause(0.1)
        end
    end

    %%%%%%%%%%Save
    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save(filename_census_data,'cell_data')
            toc; %%%%%11 seconds: 81MB
            pause(0.1);
            retry_save=0;
        catch
            retry_save=1
            pause(0.1)
        end
    end
end
size(cell_data)
retry_cd=1;
while(retry_cd==1)
    try
        cd(folder1)
        pause(0.1)
        retry_cd=0;
    catch
        retry_cd=1
        pause(0.1)
    end
end
end