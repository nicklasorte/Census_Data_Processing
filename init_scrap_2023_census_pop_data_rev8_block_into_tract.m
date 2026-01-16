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


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Urban Areas
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Shapefile Import
% shape_folder='C:\Local Matlab Data\Census_UA_2023\tl_2023_us_uac20';  %%%%%%%%%%2023
% tf_rescrap_shape=0%1%0
% data_header='uac2023'
% [cell_urban_area_data_slim]=scrap_urban_area_data_rev1(app,shape_folder,data_header,tf_rescrap_shape);
%  %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Cluster/Area, 6) Mid Lat/Lon
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Urban Areas
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
idx_str2num=horzcat(1,4,5,6);  %%%%%%%%Which index we want to convert from str2num, but leave in a cell.
str_header_keep=str_ua_header_keep;
%%[cell_urban_area_data]=generic_scrap_census_cell_data_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_keep);
[cell_urban_area_data]=generic_scrap_census_cell_data_header_rev2(app,shape_folder,tf_rescrap_shape,data_header,str_header_keep,idx_str2num);
cell_urban_area_data(1:10,:)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: States
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shape_folder='C:\Local Matlab Data\Census_State_2024\tl_2024_us_state';  %%%%%%%%%%2024
tf_rescrap_shape=0%1%0%1%0%1%0
data_header='state_2024'
%%%%%%%%%%%%%%%%%
%%%%%%%%%%Strings that need to get converted to numbers.
str_state_header_keep=cell(7,1); %%%%%Name of headers we want the data from
str_state_header_keep(1)={'NAME'};
str_state_header_keep(2)={'STATEFP'};
str_state_header_keep(3)={'GEOID'};
str_state_header_keep(4)={'STUSPS'};
str_state_header_keep(5)={'STATEFP'};
str_state_header_keep(6)={'X'};
str_state_header_keep(7)={'Y'}; 
str_header_keep=str_state_header_keep
idx_str2num=[2,3,5];  %%%%%%%%Which index we want to convert from str2num, but leave in a cell.
idx_str2num=idx_str2num(~isnan(idx_str2num));
[cell_state_data]=generic_scrap_census_cell_data_header_rev2(app,shape_folder,tf_rescrap_shape,data_header,str_header_keep,idx_str2num);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Blocks 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1%0%1%0%1
tf_rescrap_shape=0%1%0%1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Blocks_2023'  %%%%%%%%%%This is the folder where the census shapefiles are.
data_header='block2023' 
filename_block_cell=strcat(data_header,'_cell_block_data.mat')

%%%%%%%%%%Strings that need to get converted to numbers.
str_block_header_keep=cell(9,1); %%%%%Name of headers we want the data from
str_block_header_keep(1)={'STATEFP20'};
str_block_header_keep(2)={'COUNTYFP20'};
str_block_header_keep(3)={'TRACTCE20'};
str_block_header_keep(4)={'BLOCKCE20'};
str_block_header_keep(5)={'GEOID20'};
str_block_header_keep(6)={'POP20'};
str_block_header_keep(7)={'INTPTLAT20'};
str_block_header_keep(8)={'INTPTLON20'};
str_block_header_keep(9)={'UACE20'};               %%%%%%2020 Census urban area code
idx_str2num=horzcat(1,2,3,4,5,6,7,8,9);  %%%%%%%%Which index we want to convert from str2num, but leave in a cell.
str_header_keep=str_block_header_keep;
filename_census_data=filename_block_cell;
%%%%%%%%%%%%%%%%%Scrap Multi-State Folder Census Data
[cell_block_data]=scrap_multi_folder_census_array_data_rev1(app,folder1,top_census_folder,filename_census_data,str_header_keep,data_header,tf_rescrap_shape,tf_rescrap_mat);
%%%[cell_block_data]=scrap_multi_folder_census_data_header_rev2(app,folder1,top_census_folder,filename_census_data,str_header_keep,data_header,tf_rescrap_shape,tf_rescrap_mat,idx_str2num);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cell_block_data

% % %%%%%%%Checking Connecticut because of the way Census does it.
% % temp_data=cell_block_data{1,2};
% % temp_data([1:2],:)'
% % temp_conn_data=cell_block_data{7,2};
% % cell_block_data{7,1}
% % sum(temp_conn_data(:,6))
% % %%%%%%%%%%The Block Data is right for Connecticut: 3,605,944
% % 
% % %%%%Texas FIPS 48
% % temp_texas_data=cell_block_data{44,2};
% % cell_block_data{44,1}
% % sum(temp_texas_data(:,6))  %%%%%%%%29,145,505: Population Good up to this point
% % find(temp_texas_data(:,5)==48445950300)  %%%%%No plainview Tx GEO ID: 4857980-->
% % %%%%'Need to check Texas population because of the Plainview Tx Error': Texas' population in the 2020 Census was 29,145,505
% % %%%%%914,231 Census Blocks, along with 5,265 Census Tracts and 15,811 Block Groups
% % 
% % %%%%%Find the unique number of geoid in texas?
% % size(unique(temp_texas_data(:,3)))  %%%%%%Only 5136 Tracts instead of 5265
% % size(unique(temp_texas_data(:,2)))
% % find(temp_texas_data(:,2)==579)
% % size(temp_texas_data)%%%%%%%Only 668,757 Blocks instead of 914,231
% % temp_texas_data(1:10,:)



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Tracts
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1%0%1
tf_rescrap_shape=0%1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Tracts_2023'
data_header='tract2023' %%%%%%%%'pop3'
filename_tract_cell=strcat(data_header,'_cell_tract_data.mat')
str_tract_header_keep=cell(7,1); %%%%%Name of headers we want the data from
str_tract_header_keep(1)={'STATEFP'    };
str_tract_header_keep(2)={'COUNTYFP'   };
str_tract_header_keep(3)={'TRACTCE'    };
str_tract_header_keep(4)={'GEOID'      };
str_tract_header_keep(5)={'ALAND'      };
str_tract_header_keep(6)={'INTPTLAT'   };
str_tract_header_keep(7)={'INTPTLON'   };
idx_str2num=horzcat(1,2,3,4,5,6,7);  %%%%%%%%Which index we want to convert from str2num, but leave in a cell.
filename_census_data=filename_tract_cell;
str_header_keep=str_tract_header_keep
%%%%%%%%%%%%%%%%%Scrap Multi-State Folder Census Data
[cell_tract_data]=scrap_multi_folder_census_array_data_rev1(app,folder1,top_census_folder,filename_census_data,str_header_keep,data_header,tf_rescrap_shape,tf_rescrap_mat);
%%%[cell_tract_data]=scrap_multi_folder_census_data_header_rev2(app,folder1,top_census_folder,filename_census_data,str_header_keep,data_header,tf_rescrap_shape,tf_rescrap_mat,idx_str2num);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cell_tract_data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Add Data to the Block Group
%%%%%%%%%%%%Find the population (in the block) per census block group
%%%%%%%%%%%%Add the Urban Area Code, from the Block to the Block Group
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_recalc_group_pop=0%1%0%1
data_header='Rev4_2023ua'
%[mod_cell_block_group_data]=mod_block_group_data_rev1(app,data_header,tf_recalc_group_pop,cell_block_data,cell_block_group_contour,cell_block_group_data,cell_state_fips);

%%%'have the inputs be the str_header for each'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Find the population (in the block) per cenesus tract 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Census Block Data
% %     str_header_array_keep(1)={'STATEFP20'};
% %     str_header_array_keep(2)={'COUNTYFP20' };
% %     str_header_array_keep(3)={'TRACTCE20'  };
% %     str_header_array_keep(4)={'BLOCKCE20'  }; BLOCKCE20: 4 String 2020 Census tabulation block number
% %     str_header_array_keep(5)={'GEOID20'    };
% %     str_header_array_keep(6)={'POP20'      };
% %     str_header_array_keep(7)={'INTPTLAT20'};
% %     str_header_array_keep(8)={'INTPTLON20'};
% %     str_header_array_keep(9)={'UACE20'};               %%%%%%2020 Census urban area code

% % str_tract_header_keep(1)={'STATEFP'    };
% % str_tract_header_keep(2)={'COUNTYFP'   };
% % str_tract_header_keep(3)={'TRACTCE'    };
% % str_tract_header_keep(4)={'GEOID'      };
% % str_tract_header_keep(5)={'ALAND'      };
% % str_tract_header_keep(6)={'INTPTLAT'   };
% % str_tract_header_keep(7)={'INTPTLON'   };



filename_group_cell=strcat(data_header,'_cell_tract_pop_ua_data.mat')
var_exist_group_cell=exist(filename_group_cell,'file');
if tf_recalc_group_pop==1
    var_exist_group_cell=0;
end

if var_exist_group_cell==2
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_group_cell,'cell_tract_pop_ua_data')
            toc; %%%%%%%0.08 seconds for 5MB
            pause(0.1);
            retry_load=0;
        catch
            retry_load=1
            pause(0.1)
        end
    end

else
    tic;
    array_state_block=cell2mat(cell_block_data(:,1));
    [num_states,~]=size(cell_tract_data)  %%%%%%%56 states and possessions
    calc_state_pop=NaN(num_states,1);
    cell_tract_pop_ua_data=cell(num_states,2);  %%%%%1)Array data and the 2) urban area data
    for state_idx=1:1:num_states  %%%%%%For each Tract
        tract_state=cell_tract_data{state_idx,1}
        temp_state_tract_data=cell_tract_data{state_idx,2};

        row_match_idx=find(array_state_block==tract_state);
        temp_state_block_data=cell_block_data{row_match_idx,2};

        cell_tract_data(state_idx)
        cell_block_data(row_match_idx)

        %%%%%%%The first digit of the census block number identifies the block group.
        % (0)10419635002
        % (0)10119522012029
        if tract_state==9  %%%%%Connecticut
            blocks_3col=temp_state_block_data(:,[1,3]);
            tracts_3col=temp_state_tract_data(:,[1,3]);
            % % %             %%%{[9]}:{'CONNECTICUT'}
            % % %             %%%%%As of 2020, Connecticut had 49,926 census blocks,census blocks, 2,585 block groups, and 833 census tracts
            % % %             %%%%%%%%%Connecticut went through a county numbering change.
            % % %

        else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Not Connecticut
            blocks_3col=temp_state_block_data(:,[1,2,3]);
            tracts_3col=temp_state_tract_data(:,[1,2,3]);
        end

            % Find mapping of every block to a tract index
            [lia, loc] = ismember(blocks_3col, tracts_3col, 'rows');

            % Preallocate result
            %array_tract_pop = zeros(size(tracts_3col,1),1);

            % Extract population vector
            pop_vec = temp_state_block_data(:,6);

            % Extract Urban Area vector
            ua_vec = temp_state_block_data(:,9);

            % Only keep indices where there *is* a match
            validIdx = find(lia);

            % Use accumarray to sum populations for each tract
            array_tract_pop = accumarray(loc(validIdx), pop_vec(validIdx), [size(tracts_3col,1) 1]);

            %%%'Need to find the UA vector (unique)(non-NAN)'

            temp_ua_block=temp_state_block_data(:,9);

            [num_rows,~]=size(temp_state_tract_data);

            % % cell_ua_idx=cell(num_rows,1);
            % % for i=1:1:num_rows
            % %     [Lia,~]= ismember(blocks_3col,tracts_3col(i,:),"rows");
            % %     lia_idx=find(Lia==1);
            % %     temp_ua=temp_ua_block(lia_idx);
            % %     temp_ua=temp_ua(~isnan(temp_ua));
            % %     temp_ua=unique(temp_ua);
            % %     if isempty(temp_ua)
            % %         temp_ua=NaN(1,1);
            % %     end
            % %     cell_ua_idx{i}=temp_ua;
            % % end

            % Match blocks to tracts
            [isMatch, tract_idx] = ismember(blocks_3col, tracts_3col, "rows");

            % Keep only matched blocks
            matched_ua     = temp_ua_block(isMatch);
            matched_tracts = tract_idx(isMatch);

            % Remove NaNs before grouping
            valid_idx      = ~isnan(matched_ua);
            matched_ua     = matched_ua(valid_idx);
            matched_tracts = matched_tracts(valid_idx);

            % Group unique UA values per tract
            cell_ua_idx = accumarray(matched_tracts,matched_ua,[num_rows 1], @(vals) {unique(vals)},{NaN});

            % %%%%%For those that have more than 1 urban area, keep both?
            % more_one_idx = find(cellfun(@numel, cell_ua_idx)>1);
            % cell_ua_idx{more_one_idx(1)}

            %%%%%%%%'Need to create the census data: geo id, lat, lon, pop'
            cell_tract_pop_ua_data{state_idx,1}=horzcat(temp_state_tract_data(:,[4,6,7]),array_tract_pop);
            cell_tract_pop_ua_data{state_idx,2}=cell_ua_idx;

            %%%%Block: GEOID20: 15 String :Census block identifier: a concatenation of 2020 Census state FIPS code, 2020 Census county FIPS code, 2020 Census tract code, and 2020 Census block number
            %%%%Group: GEOID:   12 String :Census block group identifier; a concatenation of the current state FIPS code, county FIPS code, census tract code, and block group number.


          %%%%%%3605944 3,605,944 (Conn Matches)
        %%%%%%5024279 (Alabama Pop Matches)
        %%%%%29145505 (Texas Pop Matches)
        calc_state_pop(state_idx,1)=sum(array_tract_pop);
    end
    sum(calc_state_pop) %%%%331,449,281  === 331,449,281 (50 + DC) Matches [2023]


    full_state_fips=cell2mat(cell_tract_data(:,1));
    state_fips51=cell2mat(cell_state_fips(:,1));
    [Lia1,Locb2]=ismember(full_state_fips,state_fips51, 'rows');
    keep_idx=find(Locb2~=0);
    sum(calc_state_pop(Locb2(keep_idx))) %%%%%%%331,449,281 matches
    horzcat(cell_state_fips,num2cell(calc_state_pop(Locb2(keep_idx))))

    temp_array_tract=vertcat(cell_tract_pop_ua_data{:,1});
    sum(temp_array_tract(:,4))  %%%%%335,073,176 vs 331,449,281. Includes outside the 50 states + DC

    %%%%%%%%%%Save
    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save(filename_group_cell,'cell_tract_pop_ua_data')
            toc; %%%%%1 seconds
            pause(0.1);
            retry_save=0;
        catch
            retry_save=1
            pause(0.1)
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cell_tract_pop_ua_data
temp_array_tract=vertcat(cell_tract_pop_ua_data{:,1});
size(temp_array_tract)

temp_cell_tract_ua=vertcat(cell_tract_pop_ua_data{:,2});
size(temp_cell_tract_ua)

%%%%%For those that have more than 1 urban area, 
%%%'Next step, only keep 1 urban area, the lower number'
%%%%%%%%%%This cuts a handful of UA from the list:
% % 36568
% % 43227
% % 58429
% % 67313
% % 71629
% % 77618
% % 82701
% % 84655
% % 85779
% % 86830
% % 88327

more_one_idx = find(cellfun(@numel, temp_cell_tract_ua)>1);
num_mul=length(more_one_idx)
for i=1:1:num_mul
    temp_ua_idx=temp_cell_tract_ua{more_one_idx(i)};
    temp_cell_tract_ua{more_one_idx(i)}=min(temp_ua_idx);
end
array_tract_ua=cell2mat(temp_cell_tract_ua);
min(array_tract_ua)
max(array_tract_ua)
uni_array_tract_ua=unique(array_tract_ua);
uni_array_tract_ua=uni_array_tract_ua(~isnan(uni_array_tract_ua));


array_ua20=cell2mat(cell_urban_area_data([2:end],1));
[sort_ua_num,sort_idx]=sort(array_ua20);
ua_names=cell_urban_area_data([2:end],:);
sort_cell_urban_area_data=ua_names(sort_idx,:);
sort_cell_urban_area_data(1:10,:)




% figure;
% plot(temp_array_tract(:,3),temp_array_tract(:,2),'ok')
% grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Go Through each census tract and find
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%those
new_full_census_2020=horzcat(temp_array_tract,array_tract_ua); %%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) Population 5)UA Number
% % % % % % % % 'Create the next Cascade_new_full_census_2020' with Urban Area Code
save('Cascade_new_full_census_2023_UA.mat','new_full_census_2020')%%%%%%%1) %%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) Population 5)UA Number
sum(new_full_census_2020(:,4))  %%%%%%Population Check


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setdiff(uni_array_tract_ua,array_ua20)
setdiff(array_ua20,uni_array_tract_ua)

%%%%%%%%%%This cuts a handful of UA from the list:
% % 36568
% % 43227
% % 58429
% % 67313
% % 71629
% % 77618
% % 82701
% % 84655
% % 85779
% % 86830
% % 88327
    % % 
    % % {'Johnson Lane, NV'                                        }    {[       0]}
    % % {'Snowmass Village, CO'                                    }    {[       0]}
    % % {'Treasure Lake, PA'                                       }    {[       0]}
    % % {'Hampshire, IL'                                           }    {[       0]}
    % % {'Stayton, OR'                                             }    {[       0]}
    % % {'Mont Belvieu, TX'                                        }    {[       0]}
    % % {'Tea, SD'                                                 }    {[       0]}
    % % {'Sunderland--South Deerfield, MA'                         }    {[       0]}
    % % {'Panther Valley, NJ'                                      }    {[       0]}
    % % {'St. James, NC'                                           }    {[       0]}
    % % {'Potala Pastillo, PR'                                     }    {[       0]}


%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the population of each Urban Area. (Census Tract), might have Zero for areas above.
%%%%%%%%%%%%%%Or could do it with the block data, but then it will have a
%%%%%%%%%%%%%%delta that is a bit off from the census tracts.
cell_urban_area_data(1:10,:)
[num_rows_ua,~]=size(cell_urban_area_data)
cell_ua_pop=cell(num_rows_ua,1);
for i=2:1:num_rows_ua
    uace20=cell_urban_area_data{i,1};
    temp_match_idx=find(new_full_census_2020(:,5)==uace20);

    if ~isempty(temp_match_idx)
        cell_ua_pop{i}=sum(new_full_census_2020(temp_match_idx,4));
    else
        cell_ua_pop{i}=0; %%%%%%%Need to fill empty with zero or it causes an error later.
    end
end
cell_ua_data_pop=horzcat(cell_urban_area_data,cell_ua_pop);
cell_ua_data_pop{1,9}='POP';
cell_ua_data_pop(1:10,:)
header=cell_ua_data_pop(1,:)
no_header=cell_ua_data_pop([2:end],:);
no_header(1:10,:)

array_ua_pop=cell2mat(no_header(:,9));
[~,sort_ua_idx]=sort(array_ua_pop,'descend');
cell_ua_sort_pop=no_header(sort_ua_idx,:);
cell_ua_sort_pop(1:10,:)
%cell_ua_sort_pop(:,[2,9])

cell_ua_data_pop_2020=vertcat(header,cell_ua_sort_pop);
tic;
save('cell_ua_data_pop_2020.mat','cell_ua_data_pop_2020')
toc;
% % str_ua_header_keep(1)={'UACE20'};
% % str_ua_header_keep(2)={'NAME20' };
% % str_ua_header_keep(3)={'NAMELSAD20'};
% % str_ua_header_keep(4)={'ALAND20'  };
% % str_ua_header_keep(5)={'INTPTLAT20'};
% % str_ua_header_keep(6)={'INTPTLON20'};
% % str_ua_header_keep(7)={'X'};
% % str_ua_header_keep(8)={'Y'};

array_geo_idx=new_full_census_2020(:,1);
mid_lat=new_full_census_2020(:,2);
mid_lon=new_full_census_2020(:,3);
tract_pop=new_full_census_2020(:,4);
census_ua_num=new_full_census_2020(:,5);
points_latlon=horzcat(mid_lat,mid_lon);

cell_ua_data_pop_2020([1,2],:)'

    % %%%%%1)PEA Name, 2)PEA Num, 3)PEA {Lat/Lon}, 4)PEA Pop 2020, 5)PEA Centroid, 6)Census {Geo ID}, 7)Census{Population}, 8)Census{NLCD}, 9)Census Centroid

    % % % % 'Need to make a Urban Area cell similar to the PEA/Census'
    % % % % 'Remove the empty population Urban Areas'
    % % % % 'Use the PEA code to make the UA equivalent'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Make the Urban Area Data [DONE]

tf_recalc_group_pop=1%0%1%0
filename_group_cell_ua=strcat('cell_urbanarea_census_data_2020_2023.mat')%%%%%%%%Using the 2023 Census Tracts/PEA equivalent
var_exist_group_cell=exist(filename_group_cell_ua,'file');
if tf_recalc_group_pop==1
    var_exist_group_cell=0;
end

if var_exist_group_cell==2
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_group_cell_ua,'cell_ua_census_data_2020')
            toc; %%%%%%%0.08 seconds for 5MB
            pause(0.1);
            retry_load=0;
        catch
            retry_load=1
            pause(0.1)
        end
    end

else
    [num_ua,~]=size(cell_ua_data_pop_2020)
    cell_ua_census_data_2020=cell(num_ua,7);
    % %%%%%1)PEA Name, 2)PEA Num, 3)PEA {Lat/Lon}, 4)PEA Pop 2020, 5)PEA Centroid, 6)Census {Geo ID}, 7)Census{Population}, 8)Census{NLCD}, 9)Census Centroid
    cell_ua_data_pop_2020(1:10,:)

    cell_empty_ua_census=cell(num_ua,1);
    tic;
    for i=2:1:num_ua
        i/num_ua*100

        %%%%%%%%%Make each UA a polygon
        temp_lat=cell_ua_data_pop_2020{i,8}';
        temp_lon=cell_ua_data_pop_2020{i,7}';
        poly_contour=polyshape(temp_lon,temp_lat); %%%%%%%This takes a while, but we need it for the centroid.

        %%%%%%%%%%This is done with the census tract UA idx
        %[inside_idx]=find_points_inside_polygon(app,poly_contour,points_latlon);

         uace20=cell_ua_data_pop_2020{i,1};
         inside_idx=find(census_ua_num==uace20);

        if isempty(inside_idx)
            cell_empty_ua_census{i}=cell_ua_data_pop_2020{i,2};
            %cell_ua_data_pop_2020(i,:)
            'No census tracts inside'
            %pause;
            'Might need to do the full census tract/PEA overlap'
        end

        %horzcat(temp_lat,temp_lon)
        [cent_x,cent_y]=centroid(poly_contour);

        cell_ua_census_data_2020{i,1}=cell_ua_data_pop_2020{i,2};
        cell_ua_census_data_2020{i,2}=cell_ua_data_pop_2020{i,1};
        cell_ua_census_data_2020{i,3}=horzcat(temp_lat,temp_lon);
        cell_ua_census_data_2020{i,5}=horzcat(cent_y,cent_x);
        
        if ~isempty(inside_idx)
            cell_ua_census_data_2020{i,4}=sum(tract_pop(inside_idx));
            cell_ua_census_data_2020{i,6}=array_geo_idx(inside_idx);
            cell_ua_census_data_2020{i,7}=tract_pop(inside_idx);
            cell_ua_census_data_2020{i,9}=points_latlon(inside_idx);
        else
            %cell_ua_census_data_2020{i,4}=0;
            cell_ua_census_data_2020{i,6}=NaN(1,1);
            cell_ua_census_data_2020{i,7}=0;
            cell_ua_census_data_2020{i,9}=NaN(1,2);
        end
        
         % %%%%%1)PEA Name, 2)PEA Num, 3)PEA {Lat/Lon}, 4)PEA Pop 2020, 5)PEA Centroid, 6)Census {Geo ID}, 7)Census{Population}, 8)Census{NLCD}, 9)Census Centroid
    end
    toc;

    cell_ua_census_data_2020=cell_ua_census_data_2020(~cellfun(@isempty, cell_ua_census_data_2020(:,1)),:);
    cell_ua_census_data_2020=cell_ua_census_data_2020(~cellfun(@isempty, cell_ua_census_data_2020(:,4)),:);
    cell_ua_census_data_2020(1:10,:)

    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save('cell_urbanarea_census_data_2020_2023_contours.mat','cell_ua_census_data_2020') %%%%%%For plotting purposes
            toc; %%%%%%%0.08 seconds for 5MB
            pause(0.1);
            retry_save=0;
        catch
            retry_save=1
            pause(0.1)
        end
    end


    %%%%%%%'Remove the contours'
    empty_cell=cell(1,1);
    cell_ua_census_data_2020(:,3)=empty_cell;


    %%%%%%%%%%%%This is the slim version (No contours)

    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save(filename_group_cell_ua,'cell_ua_census_data_2020')
            toc; %%%%%%%0.08 seconds for 5MB
            pause(0.1);
            retry_save=0;
        catch
            retry_save=1
            pause(0.1)
        end
    end
end
cell_ua_census_data_2020(1:10,:)
%cell_ua_census_data_2020(:,[1,4])

'check for no contours'
pause;





%%%%%%%%%%%%%%%Make the PEA Data (Done)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: PEA
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shape_folder='C:\Users\nlasorte\OneDrive - National Telecommunications and Information Administration\MATLAB2024\Census_Functions\FCC_PEAs_Website';  %%%%%%%%%%2023
tf_rescrap_shape=0%1%0%1%0
data_header='PEA_2025'
%%%%%%%%%%%%%%%%%
str_ua_header_keep=cell(5,1); %%%%%Name of headers we want the data from
str_ua_header_keep(1)={'PEA_Name'};
str_ua_header_keep(2)={'PEA_Num'};
str_ua_header_keep(3)={'POPs_2010'};
str_ua_header_keep(4)={'X'};
str_ua_header_keep(5)={'Y'};
idx_str2num=horzcat(2,3,4,5);  %%%%%%%%Which index we want to convert from str2num, but leave in a cell.
str_header_keep=str_ua_header_keep;
[cell_pea_data_2020]=generic_scrap_census_cell_data_header_rev2(app,shape_folder,tf_rescrap_shape,data_header,str_header_keep,idx_str2num);
cell_pea_data_2020(1:10,:)
size(cell_pea_data_2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(folder1)
pause(0.1)

tf_recalc_poly=0
filename_cell=strcat('cell_pea_data_2020_rev1.mat')
var_exist_cell=exist(filename_cell,'file');
if tf_recalc_poly==1
    var_exist_cell=0;
end

if var_exist_cell==2
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_cell,'cell_pea_data_2020')
            toc; %%%%%%%
            pause(0.1);
            retry_load=0;
        catch
            retry_load=1
            pause(0.1)
        end
    end

else
    %%%%%%%%%%Make a polyshape out of the X/Y --> Add to 6th Column
    [num_peas,~]=size(cell_pea_data_2020)
    for i=2:1:num_peas
        temp_lon=cell_pea_data_2020{i,4};
        temp_lat=cell_pea_data_2020{i,5};
        temp_poly=polyshape(temp_lon,temp_lat);
        cell_pea_data_2020{i,6}=temp_poly;
        % close all;
        % plot(temp_poly)
        % grid on;
        % pause(0.1)
        % pause;
    end

    save(filename_cell,'cell_pea_data_2020')
end
cell_pea_data_2020(1:10,:)
size(cell_pea_data_2020)


cd(folder1)
pause(0.1)
%%%load('Cascade_new_full_census_2020.mat','new_full_census_2020')%%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) Population
load('Cascade_new_full_census_2023_UA.mat','new_full_census_2020')%%%%%%%1) %%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) Population 5)UA Number

new_full_census_2020(1:10,:)
array_geo_idx=new_full_census_2020(:,1);
mid_lat=new_full_census_2020(:,2);
mid_lon=new_full_census_2020(:,3);
tract_pop=new_full_census_2020(:,4);
points_latlon=horzcat(mid_lat,mid_lon);
%%%%%%%%%Next, find the Census GEO Id in each Urban Area.



tf_recalc_group_pop=0%1%0
filename_group_cell=strcat('cell_pea_census_data_2020_2023.mat')%%%%%%%%Using the 2023 Census Tracts
var_exist_group_cell=exist(filename_group_cell,'file');
if tf_recalc_group_pop==1
    var_exist_group_cell=0;
end

if var_exist_group_cell==2
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_group_cell,'cell_pea_census_data_2020')
            toc; %%%%%%%0.08 seconds for 5MB
            pause(0.1);
            retry_load=0;
        catch
            retry_load=1
            pause(0.1)
        end
    end

else
    [num_pea,~]=size(cell_pea_data_2020)
    cell_pea_census_data_2020=cell(num_pea,7);
    % %%%%%1)PEA Name, 2)PEA Num, 3)PEA {Lat/Lon}, 4)PEA Pop 2020, 5)PEA Centroid, 6)Census {Geo ID}, 7)Census{Population}, 8)Census{NLCD}, 9)Census Centroid
    cell_pea_data_2020(1:10,:)
    cell_empty_pea_census=cell(num_pea,1)
    tic;
    for i=2:1:num_pea
        i/num_pea*100

        % % %%%%%%%%%Make each UA a polygon
        % % temp_lat=cell_urban_area_data{i,8}';
        % % temp_lon=cell_urban_area_data{i,7}';
        % % poly_contour=polyshape(temp_lon,temp_lat);
        poly_contour=cell_pea_data_2020{i,6};
        [inside_idx]=find_points_inside_polygon(app,poly_contour,points_latlon);

        if isempty(inside_idx)
            cell_empty_pea_census{i}=cell_pea_data_2020{i,2};
            cell_pea_data_2020(i,:)
            'No census tracts inside'
            %pause;
            'Might need to do the full census tract/PEA overlap'
        end

        temp_lat=cell_pea_data_2020{i,5}';
        temp_lon=cell_pea_data_2020{i,4}';
        %horzcat(temp_lat,temp_lon)
        [cent_x,cent_y]=centroid(poly_contour);

        cell_pea_census_data_2020{i,1}=cell_pea_data_2020{i,1};
        cell_pea_census_data_2020{i,2}=cell_pea_data_2020{i,2};
        cell_pea_census_data_2020{i,3}=horzcat(temp_lat,temp_lon);
        cell_pea_census_data_2020{i,4}=sum(tract_pop(inside_idx));
        cell_pea_census_data_2020{i,5}=horzcat(cent_y,cent_x);
        cell_pea_census_data_2020{i,6}=array_geo_idx(inside_idx);
        cell_pea_census_data_2020{i,7}=tract_pop(inside_idx);
        cell_pea_census_data_2020{i,9}=points_latlon(inside_idx);
    end
    toc;

    cell_pea_census_data_2020 = cell_pea_census_data_2020(~cellfun(@isempty, cell_pea_census_data_2020(:,1)),:);
    cell_pea_census_data_2020(1:10,:)

    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save(filename_group_cell,'cell_pea_census_data_2020')
            toc; %%%%%%%0.08 seconds for 5MB
            pause(0.1);
            retry_save=0;
        catch
            retry_save=1
            pause(0.1)
        end
    end
end
cell_pea_census_data_2020(1:10,:)
cell_pea_census_data_2020(:,[1,4])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'In the 6th column of census tract data, put the PEA number'


cell_pea_census_data_2020(1:10,:) %%%%6)Census {Geo ID},
size(unique(vertcat(cell_pea_census_data_2020{:,6})))
size(new_full_census_2020)

%%%%%%%Missing a few Census Tracts. That's ok. Probably outside of USP.
'This is the next step.'


















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
