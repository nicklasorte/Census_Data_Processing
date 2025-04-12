clear;
clc;
close all;
app=NaN(1);  %%%%%%%%%This is to allow for Matlab Application integration.
format shortG
format longG
top_start_clock=clock;%datetime;
folder1='C:\Users\nlasorte\OneDrive - National Telecommunications and Information Administration\MATLAB2024\Census_Functions'; %%%%%Folder where all the matlab code is placed.
cd(folder1)
addpath(folder1)
pause(0.1)
addpath('C:\Users\nlasorte\OneDrive - National Telecommunications and Information Administration\MATLAB2024\Basic_Functions')



%%%%%%%%%%%%%%'Scrap the All the Census Tracts, Block Groups, Blocks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Pull in the STATE_FIP.xlsx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_repull_FIP=0%1%0
excel_state_fip_filename='STATE_FIP.xlsx';
[cell_state_fips]=pull_state_fips_rev1(app,excel_state_fip_filename,tf_repull_FIP);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Urban Areas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Shapefile Import
shape_folder='C:\Local Matlab Data\Census_UA_2023\tl_2023_us_uac20';  %%%%%%%%%%2023
tf_rescrap_shape=0%1%0
data_header='uac2023'
[cell_urban_area_data_slim]=scrap_urban_area_data_rev1(app,shape_folder,data_header,tf_rescrap_shape);
 %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Cluster/Area, 6) Mid Lat/Lon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Urban Area Data: Shapefile Import
shape_folder='C:\Local Matlab Data\Census_UA_2023\tl_2023_us_uac20';  %%%%%%%%%%2023
tf_rescrap_shape=0%1%0%1%0%1%0
data_header='UAcontour_2023'
%%%%%%%%%%%%%%%%%
str_ua_header_keep=cell(8,1); %%%%%Name of headers we want the data from
str_ua_header_keep(1)={'UACE20'};
str_ua_header_keep(2)={'NAME20' };
str_ua_header_keep(3)={'NAMELSAD20'};
str_ua_header_keep(4)={'ALAND20'  };
str_ua_header_keep(5)={'INTPTLAT20'};
str_ua_header_keep(6)={'INTPTLON20'};
str_ua_header_keep(7)={'X'};
str_ua_header_keep(8)={'Y'};
[cell_urban_area_data]=generic_scrap_census_cell_data_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_ua_header_keep);
size(cell_urban_area_data)
size(cell_urban_area_data_slim)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Blocks 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1%0%1
tf_rescrap_shape=0%1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Blocks_2023'  %%%%%%%%%%This is the folder where the census shapefiles are.
data_header='block2023' 
filename_block_cell=strcat(data_header,'_cell_block_data.mat')

%%%%%%%%%%Strings that need to get converted to numbers.
str_header_array_keep=cell(9,1); %%%%%Name of headers we want the data from
str_header_array_keep(1)={'STATEFP20'};
str_header_array_keep(2)={'COUNTYFP20'};
str_header_array_keep(3)={'TRACTCE20'};
str_header_array_keep(4)={'BLOCKCE20'};
str_header_array_keep(5)={'GEOID20'};
str_header_array_keep(6)={'POP20'};
str_header_array_keep(7)={'INTPTLAT20'};
str_header_array_keep(8)={'INTPTLON20'};
str_header_array_keep(9)={'UACE20'};               %%%%%%2020 Census urban area code

%%%%%%%%%%%%%%%%%Scrap Multi-State Folder Census Data
[cell_block_data]=scrap_multi_folder_census_array_data_rev1(app,folder1,top_census_folder,filename_block_cell,str_header_array_keep,data_header,tf_rescrap_shape,tf_rescrap_mat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%Checking Connecticut because of the way Census does it.
temp_data=cell_block_data{1,2};
temp_data(1,:)'
temp_conn_data=cell_block_data{7,2};
cell_block_data{7,1}
sum(temp_conn_data(:,6))
%%%%%%%%%%The Block Data is right for Connecticut: 3,605,944




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Block Groups 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1
tf_rescrap_shape=0%1%0
top_census_folder='C:\Local Matlab Data\Census_Block_Group_2023'  
data_header='blockgroup2023' 
filename_block_group_cell=strcat(data_header,'_cell_block_group_data.mat')

%%%%%%%%%%Strings that need to get converted to numbers.
str_header_array_keep=cell(9,1); %%%%%Name of headers we want the data from
str_header_array_keep(1)={'STATEFP'};
str_header_array_keep(2)={'COUNTYFP'};
str_header_array_keep(3)={'TRACTCE'};
str_header_array_keep(4)={'BLKGRPCE'};
str_header_array_keep(5)={'GEOID'};
str_header_array_keep(6)={'ALAND'};
str_header_array_keep(7)={'INTPTLAT'};
str_header_array_keep(8)={'INTPTLON'};
str_header_array_keep(9)={'AWATER'};
  

%%%%%%%%%%%%%%%%%Scrap Multi-State Folder Census Data
[cell_block_group_data]=scrap_multi_folder_census_array_data_rev1(app,folder1,top_census_folder,filename_block_group_cell,str_header_array_keep,data_header,tf_rescrap_shape,tf_rescrap_mat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Block Groups [Contours]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1
tf_rescrap_shape=0%1%0
top_census_folder='C:\Local Matlab Data\Census_Block_Group_2023'  
data_header='contour2023'
filename_block_group_contour=strcat(data_header,'_cell_block_group_contour.mat')
str_header_geoid_keep=cell(1,1); %%%%%Name of headers we want the data from
str_header_geoid_keep(1)={'GEOID'};
str_header_contour=cell(2,1);%%%%%%%%The Contour Headers
str_header_contour(1)={'X'};
str_header_contour(2)={'Y'};
[cell_block_group_contour]=scrap_multi_folder_census_contours_rev1(app,folder1,top_census_folder,filename_block_group_contour,tf_rescrap_shape,data_header,str_header_geoid_keep,str_header_contour,tf_rescrap_mat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Tracts
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1%0%1
tf_rescrap_shape=0%1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Tracts_2023'
data_header='tract2023' %%%%%%%%'pop3'
filename_tract_cell=strcat(data_header,'_cell_tract_data.mat')
str_header_array_keep=cell(7,1); %%%%%Name of headers we want the data from
str_header_array_keep(1)={'STATEFP'    };
str_header_array_keep(2)={'COUNTYFP'   };
str_header_array_keep(3)={'TRACTCE'    };
str_header_array_keep(4)={'GEOID'      };
str_header_array_keep(5)={'ALAND'      };
str_header_array_keep(6)={'INTPTLAT'   };
str_header_array_keep(7)={'INTPTLON'   };
%%%%%%%%%%%%%%%%%Scrap Multi-State Folder Census Data
[cell_tract_data]=scrap_multi_folder_census_array_data_rev1(app,folder1,top_census_folder,filename_tract_cell,str_header_array_keep,data_header,tf_rescrap_shape,tf_rescrap_mat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Add Data to the Block Group
%%%%%%%%%%%%Find the population (in the block) per census block group
%%%%%%%%%%%%Add the Urban Area Code, from the Block to the Block Group
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_recalc_group_pop=0%1%0%1
data_header='modblock2023ua'
[mod_cell_block_group_data]=mod_block_group_data_rev1(app,data_header,tf_recalc_group_pop,cell_block_data,cell_block_group_contour,cell_block_group_data,cell_state_fips);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp_connecticut=mod_cell_block_group_data{7,2};
sum(temp_connecticut(:,10))  %%%%%%%%%% 3,605,944: Test for Connecticut
%%%%https://data.census.gov/profile/Connecticut?g=040XX00US09


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Find the population (in the block) per cenesus tract (finsihed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_recalc_tract_pop=0%1%0%1
data_header='poptract2023'
[cell_tract_data_pop]=add_pop_tract_data_rev1(app,data_header,tf_recalc_tract_pop,cell_block_data,cell_tract_data,cell_state_fips)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp_connecticut_data=cell_tract_data_pop{7,2};
sum(temp_connecticut_data(:,8))  %%%%%%%%%% 3,605,944: Test for Connecticut


% % % % % % % % 'Create the next Cascade_new_full_census_2020'
full_array_census_data=vertcat(cell_tract_data_pop{:,2});
size(full_array_census_data)  %%%%84,414/85,529 census
new_full_census_2020=full_array_census_data(:,[4,6,7,8]);
save('Cascade_new_full_census_2020.mat','new_full_census_2020')%%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) Population
sum(new_full_census_2020(:,4))  %%%%%%Population Check


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
