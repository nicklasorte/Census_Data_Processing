function [cell_ua_idx]=points_inside_urban_areas_rev1(app,ua_idx_filename,tf_recalc_inside,cell_urban_area_data,input_latlon)

[var_exist_input1]=persistent_var_exist_with_corruption(app,ua_idx_filename);
if tf_recalc_inside==1
    var_exist_input1=0;
end
if var_exist_input1==2 
    retry_load=1;
    while(retry_load==1)
        try
            load(ua_idx_filename,'cell_ua_idx')
            pause(0.1)
            retry_load=0;
        catch
            retry_load=1;
            pause(1)
        end
    end
    pause(0.1)
else
    [num_urban,~]=size(cell_urban_area_data)

    %%%%%%%%%%%For Each contour
    tic;
    cell_ua_idx=cell(num_urban,1);
    tic;
    for row_idx=1:1:num_urban
        row_idx/num_urban*100

        temp_con_lat=cell_urban_area_data{row_idx,3}';
        temp_con_lon=cell_urban_area_data{row_idx,4}';
        temp_latlon=horzcat(temp_con_lat,temp_con_lon);
        temp_latlon=temp_latlon(~isnan(temp_latlon(:,1)),:);
        k_idx=convhull(temp_latlon(:,2),temp_latlon(:,1));
        temp_contour=temp_latlon(k_idx,:);

% % %         close all;
% % %         figure;
% % %         hold on;
% % %         plot(temp_con_lon,temp_con_lat,'-k')
% % %         plot(temp_contour(:,2),temp_contour(:,1),'-r')

        %%%%%%%%%%Convex hull the Urban Area to simplify
        if ~isempty(temp_contour)
            %%%%%might Need to do the rough cut first to speed it up.
            min_lat=min(temp_contour(:,1));
            max_lat=max(temp_contour(:,1));
            min_lon=min(temp_contour(:,2));
            max_lon=max(temp_contour(:,2));

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            lon_idx1=find(min_lon<input_latlon(:,2));
            lon_idx2=find(max_lon>input_latlon(:,2));
            cut_lon_idx=intersect(lon_idx1,lon_idx2);

            lat_idx1=find(min_lat<input_latlon(:,1));
            lat_idx2=find(max_lat>input_latlon(:,1));
            cut_lat_idx=intersect(lat_idx1,lat_idx2);

            check_latlon_idx=intersect(cut_lon_idx,cut_lat_idx);

     
            if ~isempty(check_latlon_idx) 
                num_lat_check=length(check_latlon_idx);
                inside_idx=NaN(num_lat_check,1);
                for pos_idx=1:1:num_lat_check
                    tf_inside=inpolygon(input_latlon(check_latlon_idx(pos_idx),2),input_latlon(check_latlon_idx(pos_idx),1),temp_contour(:,2),temp_contour(:,1)); %Check to see if the points are in the polygon
                    if tf_inside==1
                        inside_idx(pos_idx)=pos_idx;
                    end
                end
                inside_idx=inside_idx(~isnan(inside_idx));

                if ~isempty(inside_idx) 
                    keep_latlon_idx=check_latlon_idx(inside_idx);
                    cell_ua_idx{row_idx}=horzcat(keep_latlon_idx,row_idx.*ones(size(keep_latlon_idx)));
                end
            end
        end
    end
    toc;
    save(ua_idx_filename,'cell_ua_idx')
end

end