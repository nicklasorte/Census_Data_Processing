function [cell_state_fips]=pull_state_fips_rev1(app,excel_state_fip_filename,tf_repull_FIP)

filename_state_fip=strcat('STATE_FIP.mat');
[var_exist_fip]=persistent_var_exist_with_corruption(app,filename_state_fip);
if tf_repull_FIP==1
    var_exist_fip=0;
end

if var_exist_fip==2
    load(filename_state_fip,'cell_state_fips')
else
        tic;
        temp_excel_data=readcell(excel_state_fip_filename);
        toc; %%%%%%%%%4 seconds

        num_states=length(temp_excel_data);
        cell_state_fips=cell(num_states,2);
        for i=1:1:num_states
            temp_str=temp_excel_data{i};
            cell_state_fips{i,1}=str2double(temp_str(1:2));
            cell_state_fips{i,2}=strtrim(temp_str(3:end));
        end
    save(filename_state_fip,'cell_state_fips')
end
end