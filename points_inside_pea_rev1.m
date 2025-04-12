function [array_pea_idx,cell_pea_idx]=points_inside_pea_rev1(app,cell_pea_idx_filename,pea_idx_filename,tf_pea_sort,input_latlon)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[var_exist_input1]=persistent_var_exist_with_corruption(app,cell_pea_idx_filename);
[var_exist_input2]=persistent_var_exist_with_corruption(app,pea_idx_filename);
if tf_pea_sort==1
    var_exist_input1=0;
end
if var_exist_input1==2 && var_exist_input2==2
    retry_load=1;
    while(retry_load==1)
        try
            load(cell_pea_idx_filename,'cell_pea_idx')
            load(pea_idx_filename,'array_pea_idx')
            pause(0.1)
            retry_load=0;
        catch
            retry_load=1;
            pause(1)
        end
    end
    pause(0.1)
else
    %%%%%%%%%%%%%%Look at it from a PEA perspective.
    load('cell_pea_census_data.mat','cell_pea_census_data') %%%%%1)PEA Name, 2)PEA Num, 3)PEA {Lat/Lon}, 4)PEA Pop, 5)PEA Centroid, 6)Census {Geo ID}, 7)Census{Population}, 8)Census{NLCD}, 9)Census Centroid
    [num_pea,~]=size(cell_pea_census_data)
    %%%%%%%%%%%For Each contour
    tic;
    cell_inside_pea_idx=cell(num_pea,1);
    tic;
    for row_idx=1:1:num_pea
        row_idx/num_pea*100
        temp_contour=cell_pea_census_data{row_idx,3};
        temp_contour=temp_contour(~isnan(temp_contour(:,1)),:);

        if ~isempty(temp_contour)
            %%%%%might Need to do the rough cut first to speed it up.
            min_lat=min(temp_contour(:,1));
            max_lat=max(temp_contour(:,1));
            min_lon=min(temp_contour(:,2));
            max_lon=max(temp_contour(:,2));

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
                     temp_pea_num=cell_pea_census_data{row_idx,2};
                    temp_bs_peak_idx=horzcat(keep_latlon_idx,temp_pea_num.*ones(size(keep_latlon_idx)));
                    cell_inside_pea_idx{row_idx}=temp_bs_peak_idx;
                end
            end
        end
    end
    toc;
    cell_pea_idx=cell_inside_pea_idx;
    array_pea_idx=vertcat(cell_pea_idx{:});
    size(array_pea_idx)
    save(pea_idx_filename,'array_pea_idx')
    save(cell_pea_idx_filename,'cell_pea_idx')
end
end