clear;
clc;
close all;
app=NaN(1);  %%%%%%%%%This is to allow for Matlab Application integration.
format shortG
format longG
top_start_clock=clock;%datetime;
folder1='C:\Local Matlab Data\Census_Functions'; %%%%%Folder where all the matlab code is placed.
cd(folder1)
addpath(folder1)
pause(0.1)
addpath('C:\Local Matlab Data\Census_Functions')


%%%%%%%%%%%%%%'Scrap the All the Census Tracts, Block Groups, Blocks



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Pull in the STATE_FIP.xlsx
tf_repull_FIP=0
excel_state_fip_filename='STATE_FIP.xlsx'
[cell_state_fips]=pull_state_fips_rev1(app,excel_state_fip_filename,tf_repull_FIP);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Urban Areas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Shapefile Import
shape_folder='C:\Local Matlab Data\Census_UA_2023\tl_2023_us_uac20';  %%%%%%%%%%2023
tf_rescrap_shape=0%1%0
data_header='uac2023'
[cell_urban_area_data]=scrap_urban_area_data_rev1(app,shape_folder,data_header,tf_rescrap_shape);
 %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Cluster/Area, 6) Mid Lat/Lon




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Blocks [Finished]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=1%0%1
tf_rescrap_shape=1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Blocks_2023'  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


data_header='pop1'
filename_block_cell=strcat(data_header,'_cell_block_data.mat')
cd(top_census_folder)
pause(0.1)
var_exist_block_cell=exist(filename_block_cell,'file');
if tf_rescrap_mat==1
    var_exist_block_cell=0;
end

if var_exist_block_cell==2
    tic;
    load(filename_block_cell,'cell_block_data')
    toc; %%%%%%%1.4 seconds for 81MB
else
    %%%%%%%Read in the shapefile
    tic;
    folder_info=dir(top_census_folder)
    cell_folder_info=struct2cell(folder_info)';
    folder_idx=find(~contains(cell_folder_info(:,1),'.'));
    cell_subfolders=cell_folder_info(folder_idx)

    str_header_array_keep=cell(10,1); %%%%%Name of headers we want the data from
    %%%%%%%%%%Strings that need to get converted to numbers.
    str_header_array_keep(1)={'STATEFP20'};
    str_header_array_keep(2)={'COUNTYFP20' };
    str_header_array_keep(3)={'TRACTCE20'  };
    str_header_array_keep(4)={'BLOCKCE20'  };
    str_header_array_keep(5)={'GEOID20'    };
    str_header_array_keep(6)={'POP20'      };
% %     str_header_array_keep(7)={'INTPTLAT20'};
% %     str_header_array_keep(8)={'INTPTLON20'};
% %     str_header_array_keep(9)={'UR20'};          %%%%%%2020 Census urban/rural indicator
% %     str_header_array_keep(10)={'UACE20'};               %%%%%%2020 Census urban area code


    %%%%%%%%%Cycle through each one
    num_subfolders=length(cell_subfolders)
    cell_block_data=cell(num_subfolders,2);
    tic;
    for sub_idx=1%:1:num_subfolders
        %%%%%%Subfunction: Go to the subfolder
        shape_folder=fullfile(top_census_folder,cell_subfolders{sub_idx});
        temp_split=str2double(strsplit(cell_subfolders{sub_idx},'_'));
        temp_split=temp_split(~isnan(temp_split))
        cell_block_data{sub_idx,1}=temp_split(2);
        cell_block_data{sub_idx,2}=generic_scrap_census_array_data_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_array_keep);
    end
    toc;

    cd(top_census_folder)
    pause(0.1)
    tic;
    save(filename_block_cell,'cell_block_data')
    toc; %%%%%11 seconds: 81MB
end
size(cell_block_data)
cd(folder1)
pause(0.1)

temp_data=cell_block_data{1,2};
temp_data(1,:)'

'Needed to rescrap with the mid point of the block'


%%%%%%%%%%%%%%Pull the data for the census block group, (minus the X/Y
%%%%%%%%%%%%%%boundary) and merge with the block data.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Groups (Done)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1
tf_rescrap_shape=0%1%0
top_census_folder='C:\Local Matlab Data\Census_Block_Group_2023'  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(top_census_folder)
pause(0.1)


data_header='pop2'
filename_block_group_cell=strcat(data_header,'_cell_block_group_data.mat')
cd(top_census_folder)
pause(0.1)
var_exist_block_cell=exist(filename_block_group_cell,'file');
if tf_rescrap_mat==1
    var_exist_block_cell=0;
end

if var_exist_block_cell==2
    tic;
    load(filename_block_group_cell,'cell_block_group_data')
    toc; %%%%%%%0.08 seconds for 5MB
else

    folder_info=dir(top_census_folder)
    cell_folder_info=struct2cell(folder_info)';
    folder_idx=find(~contains(cell_folder_info(:,1),'.'));
    cell_subfolders=cell_folder_info(folder_idx)

    str_header_array_keep=cell(8,1); %%%%%Name of headers we want the data from
    str_header_array_keep(1)={'STATEFP'    };
    str_header_array_keep(2)={'COUNTYFP'   };
    str_header_array_keep(3)={'TRACTCE'    };
    str_header_array_keep(4)={'BLKGRPCE'   };
    str_header_array_keep(5)={'GEOID'      };
    str_header_array_keep(6)={'ALAND'      };
    str_header_array_keep(7)={'INTPTLAT'   };
    str_header_array_keep(8)={'INTPTLON'   };

    num_subfolders=length(cell_subfolders)
    cell_block_group_data=cell(num_subfolders,2);
    tic;
    for sub_idx=1:1:num_subfolders
        %%%%%%Subfunction: Go to the subfolder
        shape_folder=fullfile(top_census_folder,cell_subfolders{sub_idx});
        temp_split=str2double(strsplit(cell_subfolders{sub_idx},'_'));
        temp_split=temp_split(~isnan(temp_split))
        cell_block_group_data{sub_idx,1}=temp_split(2);
        cell_block_group_data{sub_idx,2}=generic_scrap_census_array_data_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_array_keep);
    end
    
    cd(top_census_folder)
    pause(0.1)
    tic;
    save(filename_block_group_cell,'cell_block_group_data')
    toc; %%%%%11 seconds: 5MB
end
size(cell_block_group_data)
cd(folder1)
pause(0.1)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Tracts
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1%0%1
tf_rescrap_shape=0%1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Tracts_2023'  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(top_census_folder)
pause(0.1)

data_header='pop3'
filename_tract_cell=strcat(data_header,'_cell_tract_data.mat')
cd(top_census_folder)
pause(0.1)
var_exist_tract_cell=exist(filename_tract_cell,'file')
if tf_rescrap_mat==1
    var_exist_tract_cell=0;
end

if var_exist_tract_cell==2
    tic;
    load(filename_tract_cell,'cell_tract_data')
    toc; %%%%%%%0.08 seconds for 5MB
else

    folder_info=dir(top_census_folder)
    cell_folder_info=struct2cell(folder_info)';
    folder_idx=find(~contains(cell_folder_info(:,1),'.'));
    cell_subfolders=cell_folder_info(folder_idx)

    str_header_array_keep=cell(7,1); %%%%%Name of headers we want the data from
    str_header_array_keep(1)={'STATEFP'    };
    str_header_array_keep(2)={'COUNTYFP'   };
    str_header_array_keep(3)={'TRACTCE'    };
    str_header_array_keep(4)={'GEOID'      };
    str_header_array_keep(5)={'ALAND'      };
    str_header_array_keep(6)={'INTPTLAT'   };
    str_header_array_keep(7)={'INTPTLON'   };

    num_subfolders=length(cell_subfolders)
    cell_tract_data=cell(num_subfolders,2);
    tic;
    for sub_idx=1:1:num_subfolders
        %%%%%%Subfunction: Go to the subfolder
        shape_folder=fullfile(top_census_folder,cell_subfolders{sub_idx});
        temp_split=str2double(strsplit(cell_subfolders{sub_idx},'_'));
        temp_split=temp_split(~isnan(temp_split))
        cell_tract_data{sub_idx,1}=temp_split(2);
        cell_tract_data{sub_idx,2}=generic_scrap_census_array_data_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_array_keep);
    end
    
    cd(top_census_folder)
    pause(0.1)
    tic;
    save(filename_tract_cell,'cell_tract_data')
    toc; %%%%%11 seconds: 
end
size(cell_tract_data)
cd(folder1)
pause(0.1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Find the population (in the block) per cenesus tract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%Tract
%     str_header_array_keep(1)={'STATEFP'    };
%     str_header_array_keep(2)={'COUNTYFP'   };
%     str_header_array_keep(3)={'TRACTCE'    };
%     str_header_array_keep(4)={'GEOID'      };
%     str_header_array_keep(5)={'ALAND'      };
%     str_header_array_keep(6)={'INTPTLAT'   };
%     str_header_array_keep(7)={'INTPTLON'   };


%%%%%%%%%%%%%%Block
%     str_header_array_keep(1)={'STATEFP20'};
%     str_header_array_keep(2)={'COUNTYFP20' };
%     str_header_array_keep(3)={'TRACTCE20'  };
%     str_header_array_keep(4)={'BLOCKCE20'  };
%     str_header_array_keep(5)={'GEOID20'    };
%     str_header_array_keep(6)={'POP20'      };

array_state_block=cell2mat(cell_block_data(:,1))
[num_states,~]=size(cell_tract_data)
for state_idx=1%:1:num_states
    tract_state=cell_tract_data{state_idx,1}
    temp_state_tract=cell_tract_data{state_idx,2};

    row_match_idx=find(array_state_block==tract_state)
    temp_state_block=cell_block_data{row_match_idx,2};

    temp_table_block=array2table(temp_state_block(:,[1,2,3]));
    temp_table_tract=array2table(temp_state_tract(:,[1,2,3]));

    'Need to match them up'
    pause;

%     [Lia,Locb]=ismember(temp_state_block(:,[1,2,3]),temp_state_tract(:,[1,2,3]), 'rows');
% 
%     size(unique(Lia))
%     size(Lia)
%     size(Locb)


% %     Lia = ismember(A,B)
% % Lia = ismember(A,B,"rows")

temp_state_tract(1,[1,2,3])
temp_state_block(1,[1,2,3])

    temp_state_tract(1,:)'
    temp_state_block(1,:)'


end





'Next step: Find the population per census tract'
'Create the next'
%%%load('Cascade_new_full_census_2010.mat','new_full_census_2010')%%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) NLCD (1-4), 5) Population
pause;





size(cell_block_group_data)
size(cell_block_data)












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%'Next step: Find the Block group centroid within each Urban area.'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Points inside Urban Area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
size(cell_urban_area_data)

array_block_group=cell2mat(cell_block_group_data(:,2));
size(array_block_group)
input_latlon=array_block_group(:,[7,8]);

tf_recalc_inside=0%1
ua_idx_filename=strcat('cell_block_group_ua_idx.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Points inside Urban Area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[cell_ua_idx]=points_inside_urban_areas_rev1(app,ua_idx_filename,tf_recalc_inside,cell_urban_area_data,input_latlon);

size(cell_ua_idx)
array_block_group_ua_idx=cell2mat(cell_ua_idx);






                    'start here'
                    pause;




'Remove any non-state fips numbers'

'Create a cell for each state FIPS number.'
'Then the next step is adding the population for each census block to the census tract and create the: GeoId, Population, MidLat, MidLon data file.'
'For another file, we find the population for each census block group.'

': Next step, pull the census tract data, minus the x/y boundary'

'One proudct will be the census: GeoId,Pop,MidLat,MidLon'


'start here'

pause;













'Remove any non-state fips numbers'

'Create a cell for each state FIPS number.'
'Then the next step is adding the population for each census block to the census tract and create the: GeoId, Population, MidLat, MidLon data file.'
'For another file, we find the population for each census block group.'












end_clock=clock;
total_clock=end_clock-top_start_clock;
total_seconds=total_clock(6)+total_clock(5)*60+total_clock(4)*3600+total_clock(3)*86400;
total_mins=total_seconds/60;
total_hours=total_mins/60;
if total_hours>1
    strcat('Total Hours:',num2str(total_hours))
elseif total_mins>1
    strcat('Total Minutes:',num2str(total_mins))
else
    strcat('Total Seconds:',num2str(total_seconds))
end
'Done'
