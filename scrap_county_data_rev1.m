function [cell_county_data]=scrap_county_data_rev1(app,shape_folder,data_header,tf_rescrap_shape)


     %%%%%%%%%%Function to go to the folder and pull the shp file. Save as mat file.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of function load census data
    cd(shape_folder)
    pause(0.1)

    cell_county_filename=strcat('cell_county_data_',data_header,'.mat');
    [var_exist_input]=persistent_var_exist_with_corruption(app,cell_county_filename);
    if tf_rescrap_shape==1
        var_exist_input=0;
    end

if var_exist_input==2
    retry_load=1;
    while(retry_load==1)
        try
            load(cell_county_filename,'cell_county_data')
            pause(0.1)
            retry_load=0;
        catch
            retry_load=1;
            pause(1)
        end
    end
    pause(0.1)
else
    %%%%%%%%%%%%%%%%%%%%%%%%%Load in the Excel DCS location data

    %%%%%%The idea is to make a more general shapefile reader
    folder_info=dir(shape_folder);

    x3=length(folder_info);
    file_name=cell(x3,1);
    for i=1:1:x3
        file_name{i}=folder_info(i).name;
    end
    shape_idx=find(endsWith(file_name,'.shp')==1); %%%%%%%%Search the folder for the .shp file name
    shape_file_label=file_name{shape_idx};


    %%%%%%%Read in the shapefile
    temp_shapefile=shaperead(shape_file_label);
    shape_cell=struct2cell(temp_shapefile);

    %%%%%%%Find the X,Y,FullName, INTPTLAT, INTPTLON
    struct_names=fieldnames(temp_shapefile)



    lon_idx=find(contains(struct_names,'X')==1);
    lat_idx=find(contains(struct_names,'Y')==1);
    name_idx=find(contains(struct_names,'NAME')==1);
    geoid_idx=find(contains(struct_names,'GEOID')==1);
    lat_mid_idx=find(contains(struct_names,'INTPTLAT')==1);
    lon_mid_idx=find(contains(struct_names,'INTPTLON')==1);

      temp_shapefile(1)

    %%%Scrape All Lat/Lons
    [~,num_rows]=size(shape_cell);
    cell_county_data=cell(num_rows,5); %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Mid Lat/Lon
    tic;
    for i=1:1:num_rows
        cell_county_data{i,1}=shape_cell{name_idx,i};
        cell_county_data{i,2}=shape_cell{geoid_idx,i};
        cell_county_data{i,3}=shape_cell{lat_idx,i};
        cell_county_data{i,4}=shape_cell{lon_idx,i};
        cell_county_data{i,5}=horzcat(str2num(shape_cell{lat_mid_idx,i}),str2num(shape_cell{lon_mid_idx,i}));
    end
    toc;

    retry_save=1;
    while(retry_save==1)
        try
            save(cell_county_filename,'cell_county_data')    %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Mid Lat/Lon
            pause(0.1)
            retry_save=0;
        catch
            retry_save=1;
            pause(1)
        end
    end
    pause(0.1)
end


size(cell_county_data)

 %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Mid Lat/Lon