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
addpath('C:\Local Matlab Data\Basic_Functions')


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
tf_rescrap_mat=0%1%0%1
tf_rescrap_shape=0%1%0%1%0
top_census_folder='C:\Local Matlab Data\Census_Blocks_2023'  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%'Needed to rescrap with the mid point of the block'


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

    str_header_array_keep=cell(9,1); %%%%%Name of headers we want the data from
    %%%%%%%%%%Strings that need to get converted to numbers.
    str_header_array_keep(1)={'STATEFP20'};
    str_header_array_keep(2)={'COUNTYFP20' };
    str_header_array_keep(3)={'TRACTCE20'  };
    str_header_array_keep(4)={'BLOCKCE20'  };
    str_header_array_keep(5)={'GEOID20'    };
    str_header_array_keep(6)={'POP20'      };
    str_header_array_keep(7)={'INTPTLAT20'};
    str_header_array_keep(8)={'INTPTLON20'};
    str_header_array_keep(9)={'UACE20'};               %%%%%%2020 Census urban area code

    %%%%%%%%%Cycle through each one
    num_subfolders=length(cell_subfolders)
    cell_block_data=cell(num_subfolders,2);
    tic;
    for sub_idx=1:1:num_subfolders
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

temp_conn_data=cell_block_data{7,2};
cell_block_data{7,1}
sum(temp_conn_data(:,6))

%%%%%%%%%%The Block Data is right for Connecticut: 3,605,944


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: Census Groups [Boundaries]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tf_rescrap_mat=0%1
tf_rescrap_shape=0%1%0
top_census_folder='C:\Local Matlab Data\Census_Block_Group_2023'  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(top_census_folder)
pause(0.1)


data_header='contour2023'
filename_block_group_cell=strcat(data_header,'_cell_block_group_contour.mat')
cd(top_census_folder)
pause(0.1)
var_exist_block_cell=exist(filename_block_group_cell,'file');
if tf_rescrap_mat==1
    var_exist_block_cell=0;
end

if var_exist_block_cell==2
    tic;
    load(filename_block_group_cell,'cell_block_group_contour')
    toc; %%%%%%%11 seconds for 775MB
else

    folder_info=dir(top_census_folder);
    cell_folder_info=struct2cell(folder_info)';
    folder_idx=find(~contains(cell_folder_info(:,1),'.'));
    cell_subfolders=cell_folder_info(folder_idx);

    str_header_geoid_keep=cell(1,1); %%%%%Name of headers we want the data from
    str_header_geoid_keep(1)={'GEOID'      };

    str_header_contour=cell(2,1);
    str_header_contour(1)={'X'          };
    str_header_contour(2)={'Y'          };

    num_subfolders=length(cell_subfolders);
    cell_block_group_contour=cell(num_subfolders,2);
    tic;
    for sub_idx=1:1:num_subfolders
        %%%%%%Subfunction: Go to the subfolder
        shape_folder=fullfile(top_census_folder,cell_subfolders{sub_idx});
        temp_split=str2double(strsplit(cell_subfolders{sub_idx},'_'));
        temp_split=temp_split(~isnan(temp_split))
        cell_block_group_contour{sub_idx,1}=temp_split(2);
        cell_block_group_contour{sub_idx,2}=generic_scrap_census_contour_rev1(app,shape_folder,tf_rescrap_shape,data_header,str_header_geoid_keep,str_header_contour);
    end
    
    cd(top_census_folder)
    pause(0.1)
    tic;
    save(filename_block_group_cell,'cell_block_group_contour')
    toc; %%%%%11 seconds: 5MB
end
size(cell_block_group_contour)
cd(folder1)
pause(0.1)

cell_block_group_contour



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
%%%%%%%%%%%%Find the population (in the block) per cenesus group
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Census Block Data
% %     str_header_array_keep=cell(9,1); %%%%%Name of headers we want the data from
% %     %%%%%%%%%%Strings that need to get converted to numbers.
% %     str_header_array_keep(1)={'STATEFP20'};
% %     str_header_array_keep(2)={'COUNTYFP20' };
% %     str_header_array_keep(3)={'TRACTCE20'  };
% %     str_header_array_keep(4)={'BLOCKCE20'  }; BLOCKCE20: 4 String 2020 Census tabulation block number
% %     str_header_array_keep(5)={'GEOID20'    };
% %     str_header_array_keep(6)={'POP20'      };
% %     str_header_array_keep(7)={'INTPTLAT20'};
% %     str_header_array_keep(8)={'INTPTLON20'};
% %     str_header_array_keep(9)={'UACE20'};               %%%%%%2020 Census urban area code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Census Block Group Data
% %     str_header_array_keep=cell(8,1); %%%%%Name of headers we want the data from
% %     str_header_array_keep(1)={'STATEFP'    };
% %     str_header_array_keep(2)={'COUNTYFP'   };
% %     str_header_array_keep(3)={'TRACTCE'    };
% %     str_header_array_keep(4)={'BLKGRPCE'   };
% %     str_header_array_keep(5)={'GEOID'      };
% %     str_header_array_keep(6)={'ALAND'      };
% %     str_header_array_keep(7)={'INTPTLAT'   };
% %     str_header_array_keep(8)={'INTPTLON'   };


%%%%%%%%%%%%%%%%Add the Urban Area Code, from the Block to the Block Group

temp_block_data=cell_block_data{2,2};
temp_block_data(1,:)

'start here'
pause;

tf_recalc_group_pop=0%1%0%1
data_header='pop2023'
filename_group_cell=strcat(data_header,'_cell_block_group_data.mat')
var_exist_group_cell=exist(filename_group_cell,'file');
if tf_recalc_group_pop==1
    var_exist_group_cell=0;
end

if var_exist_group_cell==2
    tic;
    load(filename_group_cell,'cell_block_group_data')
    toc; %%%%%%%0.08 seconds for 5MB
else
    tic;
    array_state_block=cell2mat(cell_block_data(:,1))
    [num_states,~]=size(cell_block_group_data)  %%%%%%%56 states and possessions
    array_state_group=cell2mat(cell_block_group_contour(:,1));
  
    calc_state_pop=NaN(num_states,1);
    for state_idx=1:1:num_states
        block_state=cell_block_group_data{state_idx,1}
        temp_state_group=cell_block_group_data{state_idx,2};

        row_match_idx=find(array_state_block==block_state);
        temp_state_block=cell_block_data{row_match_idx,2};

        temp_state_block_geoid20=temp_state_block(:,5);
        cell_block_geoid20=arrayfun(@num2str, temp_state_block_geoid20, 'UniformOutput', 0);
        temp_num_block=length(cell_block_geoid20);

        temp_state_group(1,:)'
        temp_state_block(1,:)'

        size(unique(temp_state_block(:,2)))
        size(unique(temp_state_group(:,2)))

        sum(temp_state_block(:,6))

        %%%%Block: GEOID20: 15 String :Census block identifier: a concatenation of 2020 Census state FIPS code, 2020 Census county FIPS code, 2020 Census tract code, and 2020 Census block number
        %%%%Group: GEOID:   12 String :Census block group identifier; a concatenation of the current state FIPS code, county FIPS code, census tract code, and block group number.

        %%%%%%%The first digit of the census block number identifies the block group.
        % (0)10419635002
        % (0)10119522012029


        if block_state==9  %%%%%Connecticut
            row_group_match_idx=find(array_state_group==block_state);
            temp_state_group_contour=cell_block_group_contour{row_group_match_idx,2};

            % %     str_header_array_keep(5)={'GEOID20'    };
            % %     str_header_array_keep(6)={'POP20'      };
            % %     str_header_array_keep(7)={'INTPTLAT20'};
            % %     str_header_array_keep(8)={'INTPTLON20'};
            array_temp_state_block=temp_state_block(:,[5,6,7,8]);

            sum(temp_state_block(:,6))
            array_temp_state_block(1,:)
            block_centroid_latlon=array_temp_state_block(:,[3,4]);

            %%%%%%%%%%%For each block group contour
            %%%%%%%%%Find the centroid census block inside it.

            tf_cacl_block_inside=0%1;
            filename_cell_block_idx_inside=strcat(data_header,'_cell_block_idx_inside_',num2str(block_state),'.mat');
            var_exist_block_idx=exist(filename_cell_block_idx_inside,'file');
            if tf_cacl_block_inside==1
                var_exist_block_idx=0;
            end

            if var_exist_block_idx==2
                tic;
                load(filename_cell_block_idx_inside,'cell_block_idx_inside')
                toc; %%%%%%
            else
                [num_groups,~]=size(temp_state_group_contour);
                cell_block_idx_inside=cell(num_groups,1);
                tic;
                for group_idx=1:1:num_groups
                    group_idx/num_groups*100

                    temp_contour=temp_state_group_contour{group_idx,2};
                    temp_contour=fliplr(temp_contour(~isnan(temp_contour(:,1)),:));
                    [inside_idx]=find_points_inside_contour(app,temp_contour,block_centroid_latlon);

                    % % % %                 close all;
                    % % % %                 figure;
                    % % % %                 hold on;
                    % % % %                 plot(block_centroid_latlon(:,2),block_centroid_latlon(:,1),'sm')
                    % % % %                  plot(temp_contour(:,2),temp_contour(:,1),'-b')
                    % % % %                 grid on

                    cell_block_idx_inside{group_idx}=inside_idx;
                end
                toc; %%%%%%27 seconds
                save(filename_cell_block_idx_inside,'cell_block_idx_inside')
            end

            size(horzcat(temp_state_group_contour(:,1),cell_block_idx_inside))
            size(temp_state_group)

            %%%%%%%%%%Line up the geoid in the temp_state_group and find
            %%%%%%%%%%the pop in each block group.

            temp_state_group(1,:)'
            temp_state_group_contour(1,1)
            temp_array_num_geoid=cellfun(@str2num, temp_state_group_contour(:,1));

            temp_num_groups=length(temp_array_num_geoid)
            [num_groups,~]=size(temp_state_group)
            
            if temp_num_groups~=num_groups
                'Error: Number of group off'
                pause;
            end

            %%%%%%%Find the Population of each Block Group
            if all(temp_state_group(:,5)==temp_array_num_geoid)
                group_pop=NaN(num_groups,1);
                for group_idx=1:1:temp_num_groups
                    sub_match_idx=cell_block_idx_inside{group_idx,1};
                    group_pop(group_idx)=sum(temp_state_block(sub_match_idx,6));
                end
            else
                'Error:Misaligned'
                pause;
            end

            %%%%%%%%%%Now make it similar to the other data: Adding the
            %%%%%%%%%%block group population to the ninth column in the temp_state_group --> cell_block_group_data
            temp_state_group(:,9)=group_pop;
            cell_block_group_data{state_idx,2}=temp_state_group;
            sum(temp_state_group(:,9))

            %%%%According to the 2020 US Census, Connecticut's population was 3,605,944
            size(unique(temp_state_group(:,5)))

            % % %             %%%{[9]}:{'CONNECTICUT'}
            % % %             %%%%%As of 2020, Connecticut had 49,926 census blocks,census blocks, 2,585 block groups, and 833 census tracts
            % % %             %%%%%%%%%Connecticut went through a country numbering change.
            % % %

        else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Not Connecticut
            %%%%%Convert each temp_state_block(:,3) into a string, remove the
            %%%%%last 3 digits to get the matching block group number.
            tic;
            for j=1:1:temp_num_block
                temp_geoid20=cell_block_geoid20{j};
                if strlength(temp_geoid20)==14 || strlength(temp_geoid20)==15
                    %%%Cut last 3 digits
                    cell_block_geoid20{j}=temp_geoid20(1:end-3);
                else
                    'Unknown string length'
                    pause;
                end
            end
            %%%%Back to a number
            temp_block_geoid=str2double(cell_block_geoid20);
            toc;
            sort_block_geoid=unique(temp_block_geoid);
            horzcat(min(sort_block_geoid),max(sort_block_geoid))
            horzcat(min(temp_state_group(:,[5])),max(temp_state_group(:,[5])))

            temp_table_block=array2table(temp_block_geoid);
            %%%%%Change the variable name
            temp_table_block.Properties.VariableNames={'Var1'};
            temp_table_group=array2table(temp_state_group(:,[5]));

            tic;
            [Lia,Locb]=ismember(temp_table_block,temp_table_group,'rows');
            toc;
            size(unique(Locb))
            size(Locb)
            size(temp_table_group)

        temp_table_block(1,:)
        temp_table_group(Locb(1),:)
        temp_table_group(1,:)

        %%%%%%%%Connecticut is the problem again
        %%%%%%%%%%%%%%%%See if there is more than
         size(unique(temp_table_group,'rows')) %%%This is a unique, number of block groups
        size(unique(temp_table_block,'rows')) %%%%%%For connecicut, this only aligns to the number of census tracts, not block group.

        %%%%%%%Find the Population of each Tract Group
        [num_groups,~]=size(temp_state_group);
        group_pop=NaN(num_groups,1);
        for group_idx=1:1:num_groups
            sub_match_idx=find(group_idx==Locb);
            group_pop(group_idx)=sum(temp_state_block(sub_match_idx,6));
        end
        temp_state_group(:,9)=group_pop;
        cell_block_group_data{state_idx,2}=temp_state_group;
        sum(temp_state_group(:,9))

        size(unique(temp_state_group(:,5)))
        end

        %%%%%%5024279 (Alabama Pop Matches)
        %%%%%29145505 (Texas Pop Matches)
        calc_state_pop(state_idx,1)=sum(temp_state_group(:,9));
    end
    sum(calc_state_pop) %%%%331,449,281  === 331,449,281 (50 + DC) Matches

    full_state_fips=cell2mat(cell_block_group_data(:,1));
    state_fips51=cell2mat(cell_state_fips(:,1));
    [Lia1,Locb2]=ismember(full_state_fips,state_fips51, 'rows');
    keep_idx=find(Locb2~=0);
    sum(calc_state_pop(Locb2(keep_idx)))
    horzcat(cell_state_fips,num2cell(calc_state_pop(Locb2(keep_idx))))
    tic;
    save(filename_group_cell,'cell_block_group_data')
    toc; %%%%%1 seconds
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp_connecticut=cell_block_group_data{7,2};
sum(temp_connecticut(:,9))

% % [num_states_blocks,~]size(cell_block_group_data)
% % for i=1:1:







'check block group pop'
pause;

'Take this data and make the microcell deployment (in another mat file)'
'Block Group Contours and Block Group Population and Block Group Land Area to get the Block Group Population Density'



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Find the population (in the block) per cenesus tract (finsihed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Tract
%     str_header_array_keep(1)={'STATEFP'    };
%     str_header_array_keep(2)={'COUNTYFP'   };
%     str_header_array_keep(3)={'TRACTCE'    };
%     str_header_array_keep(4)={'GEOID'      };
%     str_header_array_keep(5)={'ALAND'      };
%     str_header_array_keep(6)={'INTPTLAT'   };
%     str_header_array_keep(7)={'INTPTLON'   };

tf_recalc_tract_pop=0%1%0%1
data_header='pop2023'
filename_tract_cell=strcat(data_header,'_cell_tract_data.mat')
var_exist_tract_cell=exist(filename_tract_cell,'file');
if tf_recalc_tract_pop==1
    var_exist_tract_cell=0;
end

if var_exist_tract_cell==2
    tic;
    load(filename_tract_cell,'cell_tract_data')
    toc; %%%%%%%0.08 seconds for 5MB
else
    tic;
    array_state_block=cell2mat(cell_block_data(:,1))
    [num_states,~]=size(cell_tract_data)  %%%%%%%56 states and possessions
    calc_state_pop=NaN(num_states,1);
    for state_idx=1:1:num_states
        tract_state=cell_tract_data{state_idx,1}
        temp_state_tract=cell_tract_data{state_idx,2};

        row_match_idx=find(array_state_block==tract_state);
        temp_state_block=cell_block_data{row_match_idx,2};

% % %         unique(temp_state_block(:,3))
% % %         size(unique(temp_state_tract(:,3)))
% % %          size(unique(temp_state_block(:,3)))
     
% % %         temp_table_block=array2table(temp_state_block(:,[1,2,3]));
% % %         temp_table_tract=array2table(temp_state_tract(:,[1,2,3]));

        temp_table_block=array2table(temp_state_block(:,[3]));
        temp_table_tract=array2table(temp_state_tract(:,[3]));

        tic;
        [Lia,Locb]=ismember(temp_table_block,temp_table_tract, 'rows');
        toc;
% % %             size(unique(Locb))
% % %             size(Locb)
% % %             size(temp_table_tract)

        %%%%%'Connecticut error is right here, no matches: Needed to reduce to just the 3rd row'
        %pause;

        % % %     temp_table_block(1,:)
        % % %     temp_table_tract(Locb(1),:)

        %%%%%%%Find the Population of each Tract
        [num_tracts,~]=size(temp_state_tract);
        tract_pop=NaN(num_tracts,1);
        for tract_idx=1:1:num_tracts
            sub_match_idx=find(tract_idx==Locb);
            tract_pop(tract_idx)=sum(temp_state_block(sub_match_idx,6));

            %%%%%%%%%%%%%%Block
            %     str_header_array_keep(6)={'POP20'      };
        end
        temp_state_tract(:,8)=tract_pop;
        cell_tract_data{state_idx,2}=temp_state_tract;
        sum(temp_state_tract(:,8))
        %%%%%%5024279 (Alabama Pop Matches)
        %%%%%29145505 (Texas Pop Matches)
        calc_state_pop(state_idx,1)=sum(temp_state_tract(:,8));
    end
    sum(calc_state_pop) %%%%331,449,281  === 331,449,281 (50 + DC) Matches

    full_state_fips=cell2mat(cell_tract_data(:,1));
    state_fips51=cell2mat(cell_state_fips(:,1));
    [Lia1,Locb2]=ismember(full_state_fips,state_fips51, 'rows');
    keep_idx=find(Locb2~=0);
    sum(calc_state_pop(Locb2(keep_idx)))
    horzcat(cell_state_fips,num2cell(calc_state_pop(Locb2(keep_idx))))
    tic;
    save(filename_tract_cell,'cell_tract_data')
    toc; %%%%%1 seconds
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[num_states2,~]=size(cell_tract_data)
   for state_idx=1%:1:num_states2
        tract_state=cell_tract_data{state_idx,1}
        temp_state_tract=cell_tract_data{state_idx,2};

   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%Finished Census Tract Pop



'Create the next Cascade_new_full_census_2020'
%%%load('Cascade_new_full_census_2010.mat','new_full_census_2010')%%%%%%%1) Geo Id, 2) Center Lat, 3) Center Lon,  4) NLCD (1-4), 5) Population
pause;




'Next step: Find the population per census block group'
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


% % %        
% % % 
% % %             array_temp_state_block=temp_state_block(:,[1,3,4,5]);
% % %             array_temp_group=temp_state_group(:,[1,3,4,5]);
% % % 
% % %              for j=1:1:temp_num_block
% % %                 temp_block_geoid_num=array_temp_state_block(j,4);
% % %                 temp_string_block_geoid=num2str(temp_block_geoid_num);
% % % 
% % %     
% % %                 if strlength(temp_string_block_geoid)==14 
% % %                     %%%%Split the GEO
% % %                     %%%%Cut the county
% % %                     %%%Cut last 3 digits
% % %                     %%%Find the Block Group number (4th from the last)
% % %                     temp_derived_block_group=temp_string_block_geoid(end-4);
% % %                     array_temp_state_block(j,5)=str2num(temp_derived_block_group);
% % %                 elseif strlength(temp_string_block_geoid)==15
% % %                     'Need to fill out 15'
% % %                     pause
% % %                 else
% % %                     'Unknown string length'
% % %                     pause;
% % %                 end
% % %              end
% % %             %%%%%'Remove the last 3 digits from the block to get the block group number'
% % % 
% % %             array_temp_state_block(1,:)
% % %             array_temp_group(1,:)
% % % 
% % %                  %%%%%%%%%'convert to a table'
% % %             temp_table_block=array2table(array_temp_state_block(:,[1,2,5]));
% % %             temp_table_group=array2table(array_temp_group(:,[1,2,3]));
% % % 
% % %             'Try the knnsearch for the midpoints between the blocks and groups'
% % %             block_latlon=temp_state_block(:,[7,8]);
% % %             size(block_latlon)
% % %             group_latlon=temp_state_group(:,[7,8]);
% % %             size(group_latlon)
% % % 
% % %             [idx_knn]=knnsearch(group_latlon,block_latlon,'k',1); %%%Find Nearest Neighbor
% % %             size(idx_knn)
% % %             knn_group_latlon=group_latlon(idx_knn,:);
% % %             size(knn_group_latlon)
% % %             knn_dist_bound=deg2km(distance(knn_group_latlon(:,1),knn_group_latlon(:,2),block_latlon(:,1),block_latlon(:,2)));%%%%Calculate Distance
% % %             max_knn_dist=ceil(max(knn_dist_bound))
% % % 
% % %             close all;
% % %             figure;
% % %             histogram(knn_dist_bound)
% % %  
% % % 
% % %             %%%%%%Now see how the knn maps to the Locb,Lia
% % %             tic;
% % %             [Lia,Locb]=ismember(temp_table_block,temp_table_group,'rows');
% % %             toc;
% % %             size(unique(Locb))
% % %             size(Locb)
% % %             size(temp_table_group)
% % % 
% % %             temp_table_block(1,:)
% % %             temp_table_group(Locb(1),:)
% % %             temp_table_group(1,:)
% % % 
% % %                 temp_table_block(1,:)
% % %             temp_table_group(idx_knn(1),:)
% % %             temp_table_group(1,:)
% % % 
% % %             %%%%%%%Find the Population of each Tract
% % %             [num_groups,~]=size(temp_state_group);
% % %             group_pop=NaN(num_groups,1);
% % %             for group_idx=1:1:num_groups
% % %                 sub_match_idx=find(group_idx==Locb)
% % % 
% % % 
% % % 
% % %                 %%%%%Associate knn and pause a difference
% % %                 block_latlon(1,:)
% % %                 group_latlon(idx_knn(1),:)
% % % 
% % %                 knn_sub_match_idx=find(idx_knn==group_idx)
% % % 
% % %                 
% % % 
% % % 
% % %                 'start here'
% % %                 pause;
% % %                 group_pop(group_idx)=sum(temp_state_block(sub_match_idx,6));
% % %             end
% % %             temp_state_group(:,9)=group_pop;
% % %             cell_block_group_data{state_idx,2}=temp_state_group;
% % %             sum(temp_state_group(:,9))
% % % 
% % %             size(unique(temp_state_group(:,5)))
% % % 
% % %                   'start here:check connencticut'
% % %             pause;
% % %         
% % % 
% % %             'Need to find the mid point of each block in each block group'
% % %             pause;
% % % 
% % %             %%%%%%%%%%%%%Remove the country from the GEO ID
% % %             %%%%%'The county number of different for Connecticut, so that makes it funny for the GEO ID, need to split the GEO ID and not look at county.'
