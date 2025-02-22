function [cell_tract_data_pop]=add_pop_tract_data_rev1(app,data_header,tf_recalc_tract_pop,cell_block_data,cell_tract_data,cell_state_fips)

%%%%%%%%%%%%%%%%%Tract
%     str_header_array_keep(1)={'STATEFP'    };
%     str_header_array_keep(2)={'COUNTYFP'   };
%     str_header_array_keep(3)={'TRACTCE'    };
%     str_header_array_keep(4)={'GEOID'      };
%     str_header_array_keep(5)={'ALAND'      };
%     str_header_array_keep(6)={'INTPTLAT'   };
%     str_header_array_keep(7)={'INTPTLON'   };

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


filename_tract_cell=strcat(data_header,'_cell_tract_data_pop.mat')
var_exist_tract_cell=exist(filename_tract_cell,'file');
if tf_recalc_tract_pop==1
    var_exist_tract_cell=0;
end

if var_exist_tract_cell==2
    retry_load=1;
    while(retry_load==1)
        try
            tic;
            load(filename_tract_cell,'cell_tract_data_pop')
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
    cell_tract_data_pop=cell_tract_data;
    [num_states,~]=size(cell_tract_data_pop)  %%%%%%%56 states and possessions
    calc_state_pop=NaN(num_states,1);
    for state_idx=1:1:num_states
        tract_state=cell_tract_data_pop{state_idx,1}
        temp_state_tract=cell_tract_data_pop{state_idx,2};

        row_match_idx=find(array_state_block==tract_state);
        temp_state_block=cell_block_data{row_match_idx,2};

         %%%%%'Connecticut error is right here, no matches: Needed to reduce to just the 3rd row'
        temp_table_block=array2table(temp_state_block(:,[3]));
        temp_table_tract=array2table(temp_state_tract(:,[3]));

        tic;
        [Lia,Locb]=ismember(temp_table_block,temp_table_tract, 'rows');
        toc;
      
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
        cell_tract_data_pop{state_idx,2}=temp_state_tract;
        sum(temp_state_tract(:,8))
        %%%%%%5024279 (Alabama Pop Matches)
        %%%%%29145505 (Texas Pop Matches)
        calc_state_pop(state_idx,1)=sum(temp_state_tract(:,8));
    end
    sum(calc_state_pop) %%%%331,449,281  === 331,449,281 (50 + DC) Matches

    full_state_fips=cell2mat(cell_tract_data_pop(:,1));
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
            save(filename_tract_cell,'cell_tract_data_pop')
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