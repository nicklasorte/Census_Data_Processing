function [cell_data]=generics_scrap_shapefile_geotable_rev1(app,shape_folder,tf_rescrap_shape,data_header)


%%%%%%%%%%Function to go to the folder and pull the shp file. Save as mat file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of function load census data
retry_cd=1;
while(retry_cd==1)
    try
        cd(shape_folder)
        pause(0.1)
        retry_cd=0;
    catch
        retry_cd=1
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
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_cell_shape_mat,'cell_data')
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
    temp_geotable=readgeotable(shape_file_label);
    toc;
    temp_table=geotable2table(temp_geotable,["Lat","Lon"]);
    shape_cell=table2cell(temp_table);
    size(shape_cell)
    shape_cell(1,:)'

    %%%%%%%Header Names
    struct_names=temp_table.Properties.VariableNames
    horzcat(struct_names',shape_cell(1,:)')
    cell_data=vertcat(struct_names,shape_cell);

    %%%%%%%%%%Save
    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save(filename_cell_shape_mat,'cell_data')
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