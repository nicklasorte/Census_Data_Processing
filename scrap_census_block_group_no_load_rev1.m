function []=scrap_census_block_group_no_load_rev1(app,shape_folder,tf_rescrap_shape,str_header_keep,str_header_array_keep)



    %%%%%%%%%%Function to go to the folder and pull the shp file. Save as mat file.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of function load census data
    cd(shape_folder)
    pause(0.1)

    folder_info=dir(shape_folder);
    x3=length(folder_info);
    file_name=cell(x3,1);
    for i=1:1:x3
        file_name{i}=folder_info(i).name;
    end
    shape_idx=find(endsWith(file_name,'.shp')==1); %%%%%%%%Search the folder for the .shp file name
    shape_file_label=file_name{shape_idx}
    temp_split=strsplit(shape_file_label,'.shp');

    tic;
    filename_cell_shape_mat=strcat('cell_',temp_split{1},'.mat');
    filename_array_shape_mat=strcat('array_',temp_split{1},'.mat');
    var_exist_cell_mat=exist(filename_cell_shape_mat,'file');
    var_exist_array_mat=exist(filename_array_shape_mat,'file');
    if tf_rescrap_shape==1
        var_exist_cell_mat=0;
    end

    if var_exist_cell_mat==2 && var_exist_array_mat==2
        %tic;
        %load(filename_cell_shape_mat,'cell_census_data')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load Later to
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%merge with
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Census
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%group/tracs
        %toc; %%%%%%%9 seconds for 7MB
    else
        %%%%%%%Read in the shapefile
        tic;
        temp_shapefile=shaperead(shape_file_label);
        toc;
        shape_cell=struct2cell(temp_shapefile);

        %%%%%%%Header Names
        struct_names=fieldnames(temp_shapefile)
        horzcat(struct_names,shape_cell(:,1))

        %%%%%%%Only keep this data
        num_keep=length(str_header_keep);
        keep_idx=NaN(num_keep,1);
        for col_idx=1:1:num_keep
            keep_idx(col_idx)=find(matches(struct_names,str_header_keep{col_idx}));
        end

        cell_census_data=vertcat(str_header_keep',shape_cell(keep_idx,:)');
        tic;
        save(filename_cell_shape_mat,'cell_census_data')  %%%%%%%20MB
        toc;

        %%%%%%%%Just the numbers?
        %%%%%%%Only keep this data
        num_keep2=length(str_header_array_keep);
        keep2_idx=NaN(num_keep2,1);
        for col_idx=1:1:num_keep2
            keep2_idx(col_idx)=find(matches(struct_names,str_header_array_keep{col_idx}));
        end

        temp_cell_data=shape_cell(keep2_idx,:)';
        [~,num_col]=size(temp_cell_data);
        cell_cell_temp=cell(1,num_col);
        for j=1:1:num_col
            if ischar(temp_cell_data{1,j})
                %%%Convert
                cell_cell_temp{1,j}=str2double(temp_cell_data(:,j));
            else
                 cell_cell_temp{1,j}=cell2mat(temp_cell_data(:,j));
            end
        end
        array_census_data=horzcat(cell_cell_temp{:});
        array_census_data(1,:)
        tic;
        save(filename_array_shape_mat,'array_census_data')
        toc;  %%%%0.3 seconds

    end
end