function [mod_cell_block_group_data]=mod_block_group_data_rev1(app,data_header,tf_recalc_group_pop,cell_block_data,cell_block_group_contour,cell_block_group_data,cell_state_fips)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Add Data to the Block Group
%%%%%%%%%%%%Find the population (in the block) per census block group
%%%%%%%%%%%%Add the Urban Area Code, from the Block to the Block Group
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


filename_group_cell=strcat(data_header,'_mod_cell_block_group_data.mat')
var_exist_group_cell=exist(filename_group_cell,'file');
if tf_recalc_group_pop==1
    var_exist_group_cell=0;
end

if var_exist_group_cell==2
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_group_cell,'mod_cell_block_group_data')
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
    array_state_block=cell2mat(cell_block_data(:,1))

    mod_cell_block_group_data=cell_block_group_data;
    [num_states,~]=size(mod_cell_block_group_data)  %%%%%%%56 states and possessions
    array_state_group=cell2mat(cell_block_group_contour(:,1));
  
    calc_state_pop=NaN(num_states,1);
    for state_idx=1:1:num_states
        block_state=mod_cell_block_group_data{state_idx,1}
        temp_state_group=mod_cell_block_group_data{state_idx,2};

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
                temp_cell_block_group_ua=cell(num_groups,2); %%%%%%%%1) Block Group Geo ID, 2)UA code
                for group_idx=1:1:temp_num_groups
                    sub_match_idx=cell_block_idx_inside{group_idx,1};
                    group_pop(group_idx)=sum(temp_state_block(sub_match_idx,6));

                    temp_ua_code=temp_state_block(sub_match_idx,9);
                    temp_ua_code=temp_ua_code(~isnan(temp_ua_code));
                    if isempty(temp_ua_code)
                        temp_ua_code=NaN(1,1);
                    end
                    temp_cell_block_group_ua{group_idx,1}=temp_state_group(group_idx,5);
                    temp_cell_block_group_ua{group_idx,2}=temp_ua_code;
                end
            else
                'Error:Misaligned'
                pause;
            end

            %%%%%%%%%%Now make it similar to the other data: Adding the
            %%%%%%%%%%block group population to the ninth column in the temp_state_group --> cell_block_group_data
            temp_state_group(:,9)=group_pop;
            mod_cell_block_group_data{state_idx,2}=temp_state_group;
            sum(temp_state_group(:,9))

            %%%%According to the 2020 US Census, Connecticut's population was 3,605,944
            size(unique(temp_state_group(:,5)))

            %%%%%%%%%%%%%%%%Add the Urban Area Code, from the Block to the Block Group:
            %%%%%%%%%%%%%%%%cell_block_group_data{state_idx,3} with cell:
            %%%%%%%%%%%%%%%%Block Group ID and UA code

            mod_cell_block_group_data{state_idx,3}=temp_cell_block_group_ua;

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
            temp_cell_block_group_ua=cell(num_groups,2); %%%%%%%%1) Block Group Geo ID, 2)UA code
            for group_idx=1:1:num_groups
                sub_match_idx=find(group_idx==Locb);
                group_pop(group_idx)=sum(temp_state_block(sub_match_idx,6));

                temp_ua_code=temp_state_block(sub_match_idx,9);
                temp_ua_code=temp_ua_code(~isnan(temp_ua_code));
                if isempty(temp_ua_code)
                    temp_ua_code=NaN(1,1);
                end
                temp_cell_block_group_ua{group_idx,1}=temp_state_group(group_idx,5);
                temp_cell_block_group_ua{group_idx,2}=temp_ua_code;

            end
            temp_state_group(:,9)=group_pop;
            mod_cell_block_group_data{state_idx,2}=temp_state_group;
            sum(temp_state_group(:,9))

            size(unique(temp_state_group(:,5)))

            %%%%%%%%%%%%%%%%Add the Urban Area Code, from the Block to the Block Group:
            %%%%%%%%%%%%%%%%cell_block_group_data{state_idx,3} with cell:
            %%%%%%%%%%%%%%%%Block Group ID and UA code

            mod_cell_block_group_data{state_idx,3}=temp_cell_block_group_ua;
  
        end

        %%%%%%5024279 (Alabama Pop Matches)
        %%%%%29145505 (Texas Pop Matches)
        calc_state_pop(state_idx,1)=sum(temp_state_group(:,9));
    end
    sum(calc_state_pop) %%%%331,449,281  === 331,449,281 (50 + DC) Matches [2023]

    full_state_fips=cell2mat(mod_cell_block_group_data(:,1));
    state_fips51=cell2mat(cell_state_fips(:,1));
    [Lia1,Locb2]=ismember(full_state_fips,state_fips51, 'rows');
    keep_idx=find(Locb2~=0);
    sum(calc_state_pop(Locb2(keep_idx)))
    horzcat(cell_state_fips,num2cell(calc_state_pop(Locb2(keep_idx))))

    %%%%%%%%%%Save
    retry_save=1;
    while(retry_save==1)
        try
            tic;
            save(filename_group_cell,'mod_cell_block_group_data')
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
end