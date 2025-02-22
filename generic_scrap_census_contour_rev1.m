function [cell_census_data]=generic_scrap_census_contour_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_geoid_keep,str_header_contour)

        %%%%%%%%%%Function to go to the folder and pull the shp file. Save as mat file.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of function load census data
        retry_cd=1;
        while(retry_cd==1)
            try
                cd(shape_folder)
                pause(0.1)
                retry_cd=0;
            catch
                retry_cd=1;
                pause(0.1)
            end
        end

  

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
        filename_cell_shape_mat=strcat(data_header,'_cell_',temp_split{1},'.mat');
        var_exist_array_mat=exist(filename_cell_shape_mat,'file');
        if tf_rescrap_shape==1
            var_exist_array_mat=0;
        end

        if  var_exist_array_mat==2
            %%%%%%%%%%Load
            retry_load=1;
            while(retry_load==1)
                try
                    tic;
                    load(filename_cell_shape_mat,'cell_census_data')
                    toc; %%%%%
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
            temp_shapefile=shaperead(shape_file_label);
            toc;
            shape_cell=struct2cell(temp_shapefile);

            %%%%%%%Header Names
            struct_names=fieldnames(temp_shapefile)
            horzcat(struct_names,shape_cell(:,1))


            %%%%%%%Only keep this data: GEO ID: First Column in the Cell
            num_keep2=length(str_header_geoid_keep);
            keep2_idx=NaN(num_keep2,1);
            for col_idx=1:1:num_keep2
                keep2_idx(col_idx)=find(matches(struct_names,str_header_geoid_keep{col_idx}));
            end
            %keep2_idx


            %%%%%%%Only keep this data: Contour: Second Column in the Cell
            num_keep3=length(str_header_contour);
            keep3_idx=NaN(num_keep3,1);
            for col_idx=1:1:num_keep3
                keep3_idx(col_idx)=find(matches(struct_names,str_header_contour{col_idx}));
            end
            %keep3_idx

            temp_cell_data=shape_cell(keep2_idx,:)';

            %%%%%Merge the X/Y data contours into an array
            temp_cell_data2=shape_cell(keep3_idx,:)';
            [num_rows,~]=size(temp_cell_data2);
            [num_cols,~]=size(keep3_idx);
            temp_cell_contour=cell(num_rows,1);
            for j=1:1:num_rows
                temp_cell=cell(1,num_cols);
    
                for k=1:1:num_cols
                    temp_cell{1,k}=temp_cell_data2{j,k}';
                end
                temp_cell_contour{j}=horzcat(temp_cell{:});
            end
            cell_census_data=horzcat(temp_cell_data,temp_cell_contour);
            %%%%%%%%%%Save
            retry_save=1;
            while(retry_save==1)
                try
                    tic;
                    save(filename_cell_shape_mat,'cell_census_data')
                    toc;  %%%%0.3 seconds
                    pause(0.1);
                    retry_save=0;
                catch
                    retry_save=1
                    pause(0.1)
                end
            end

     

        end


end