%%%%% README $$$$$$
% La descarga del modelo CFSv2 es de forma manual 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% descarga de vientos zonales  EFM modelos %%%%%%%%%%%%%%
clear all 
%%%%%%%%%%%%%%%%%%%%%%% Vientos Observados %%%%%%%%%%%%%%%
ini = 'Jan';
si = 0.5; %%%lead time inicial "0.5"
sf = 2.5; %%%lead time final
%%%%%%%%%%%%%%%%%%%%%%%%% ------------------ VIENTOS ZONALES  del CFSv2 ------------------- %%%%%%%%%%%%%%%%%%%%%
%%% CFSV2(24 enambles)
%hind (S-1982-2010)
ur1_3=char(strcat('http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.ENSEMBLE/.PGBF/.pressure_level/.UGRD/S/(0000%201%20',ini,...
'%201982-2010)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(200)/VALUES/M/1/24/RANGE/Y/(-7)/(-18)/RANGEEDGES/X/(280)/(300)/RANGEEDGES/%5BX/Y/%5Daverage/NaN/setmissing_value/data.ch'));
%frcst(S-2011-2020)
ur1_4=char(strcat('http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.REALTIME_ENSEMBLE/.PGBF/.pressure_level/.UGRD/S/(0000%201%20',ini,....
 '%202011-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(200)/VALUES/M/1/24/RANGE/Y/(-7)/(-18)/RANGEEDGES/X/(280)/(300)/RANGEEDGES/%5BX/Y/%5Daverage/NaN/setmissing_value/data.ch'));

ur1_1=char(strcat('http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.ENSEMBLE/.PGBF/.pressure_level/.UGRD/S/(0000%201%20',ini,...
'%201982-2010)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(200)/VALUES/M/1/24/RANGE/Y/(30)/(-30)/RANGEEDGES/X/(190)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/NaN/setmissing_value/data.ch'));
%frcst(S-2011-2020)
ur1_2=char(strcat('http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.REALTIME_ENSEMBLE/.PGBF/.pressure_level/.UGRD/S/(0000%201%20',ini,....
 '%202011-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(200)/VALUES/M/1/24/RANGE/Y/(30)/(-30)/RANGEEDGES/X/(190)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/NaN/setmissing_value/data.ch'));

%% Datos del CFSv2 reordenados y guradados para usar
model = xlsread('predata_ssr.xlsx','U2WIND200'); % información copiada en un archivo excel

for i= 1:size(model,1);
    Mdl((i*5-4):(i*5),:) = transpose(model(i,:));
end
Mdl = Mdl(1:size(model,1)*size(model,2),:);
CFSv2 = Mdl(~isnan(Mdl));

filename = 'CFSv21.xlsx';
xlswrite(filename,CFSv2)





