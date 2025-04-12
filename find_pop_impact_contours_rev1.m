function [cell_data_contour_pop]=find_pop_impact_contours_rev1(app,cell_contours)


load('Cascade_new_full_census_2010.mat','new_full_census_2010')%%%%%%%Geo Id, Center Lat, Center Lon,  NLCD (1-4), Population

[num_rows,~]=size(cell_contours);
cell_contour_pop=cell(num_rows,2); %%%%%1) GeoId, 2) Total Pop

mid_lat=new_full_census_2010(:,2);
mid_lon=new_full_census_2010(:,3);
census_pop=new_full_census_2010(:,5);
census_geoid=new_full_census_2010(:,1);

%%%%%%%%%%%For Each contour
tic;
for row_idx=1:1:num_rows
    temp_contour=cell_contours{row_idx,2};

    if ~isempty(temp_contour)
        %%%%%might Need to do the rough cut first to speed it up.
        min_lat=min(temp_contour(:,1));
        max_lat=max(temp_contour(:,1));
        min_lon=min(temp_contour(:,2));
        max_lon=max(temp_contour(:,2));

        lon_idx1=find(min_lon<mid_lon);
        lon_idx2=find(max_lon>mid_lon);
        cut_lon_idx=intersect(lon_idx1,lon_idx2);

        lat_idx1=find(min_lat<mid_lat);
        lat_idx2=find(max_lat>mid_lat);
        cut_lat_idx=intersect(lat_idx1,lat_idx2);

        check_latlon_idx=intersect(cut_lon_idx,cut_lat_idx);

        if ~isempty(check_latlon_idx)
            num_lat_check=length(check_latlon_idx);
            inside_idx=NaN(num_lat_check,1);
            for pos_idx=1:1:num_lat_check
                tf_inside=inpolygon(mid_lon(check_latlon_idx(pos_idx)),mid_lat(check_latlon_idx(pos_idx)),temp_contour(:,2),temp_contour(:,1)); %Check to see if the points are in the polygon
                if tf_inside==1
                    inside_idx(pos_idx)=pos_idx;
                end
            end
            inside_idx=inside_idx(~isnan(inside_idx));

            if ~isempty(inside_idx)
                keep_latlon_idx=check_latlon_idx(inside_idx);
                cell_contour_pop{row_idx,1}=census_geoid(keep_latlon_idx);
                cell_contour_pop{row_idx,2}=sum(census_pop(keep_latlon_idx));

            else
                cell_contour_pop{row_idx,2}=0;
            end

        else
            cell_contour_pop{row_idx,2}=0;
        end
    else
        cell_contour_pop{row_idx,2}=0;
    end
end
toc;
cell_data_contour_pop=horzcat(cell_contours,cell_contour_pop)
end