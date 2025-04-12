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


%%%%%%%%%%%%%%'Scrap the All the Countries




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load the Shape Files: County
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Shapefile Import
shape_folder='C:\Local Matlab Data\Census_County_2024\tl_2023_us_county';  %%%%%%%%%%2023
tf_rescrap_shape=0%1%
data_header='uac2023'
[cell_county_data]=scrap_county_data_rev1(app,shape_folder,data_header,tf_rescrap_shape);


size(cell_county_data)
   %%%1) Name, 2) Name2, 3) Lat, 4) Lon, 5) Mid Lat/Lon






