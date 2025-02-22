function [cell_contour]=scrap_multi_folder_census_contours_rev1(app,folder1,top_census_folder,filename_contour,tf_rescrap_shape,data_header,str_header_geoid_keep,str_header_contour,tf_rescrap_mat)

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

var_exist_block_cell=exist(filename_contour,'file');
if tf_rescrap_mat==1
    var_exist_block_cell=0;
end

if var_exist_block_cell==2
    tic;
    load(filename_contour,'cell_contour')
    toc; %%%%%%%11 seconds for 775MB
else

    folder_info=dir(top_census_folder);
    cell_folder_info=struct2cell(folder_info)';
    folder_idx=find(~contains(cell_folder_info(:,1),'.'));
    cell_subfolders=cell_folder_info(folder_idx);

    num_subfolders=length(cell_subfolders);
    cell_contour=cell(num_subfolders,2);
    tic;
    for sub_idx=1:1:num_subfolders
        %%%%%%Subfunction: Go to the subfolder
        shape_folder=fullfile(top_census_folder,cell_subfolders{sub_idx});
        temp_split=str2double(strsplit(cell_subfolders{sub_idx},'_'));
        temp_split=temp_split(~isnan(temp_split))
        cell_contour{sub_idx,1}=temp_split(2);
        cell_contour{sub_idx,2}=generic_scrap_census_contour_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_geoid_keep,str_header_contour);
        strcat(num2str(sub_idx/num_subfolders*100),'%')
    end

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
            save(filename_contour,'cell_contour')
            toc; %%%%%11 seconds: 5MB
            pause(0.1);
            retry_save=0;
        catch
            retry_save=1
            pause(0.1)
        end
    end
end
size(cell_contour)
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