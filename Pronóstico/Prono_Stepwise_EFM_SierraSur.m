%% -------------------------------------------- CODIGO DE PRONOSTICO SIERRA SUR ---------------------------------------
% Patricia del Pilar Rivera Giron - consultora CIIFEN
%%%% METODO STEPWISEFIT 
% Pronůstico de 3 componentes del SPI
% Predictores componete 1: vientos, ONI(EFM), PDO(EFM)
% Predictores componete 2: vientos, NAO(EFM)
% Predictores componete 3: vientos, NAO(EFM)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all 
close all
clc
%%%%%%%%%%%%%%%%%%%%%%% Vientos Observados %%%%%%%%%%%%%%%
ini = 'Jan'; % condiciones iniciales
load Winds.txt; % datos de vientos para ajuste
sig_o = nanstd(Winds);
u_o = nanmean(Winds);

si = 0.5; %%%lead time inicial "0.5"
sf = 2.5; %%%lead time final +2

%% %%%%%%%%%%%%%%%%%%% -------------------------- VIENTOS ZONALES ------------------------------ %%%%%%%%%%%%%%%%%%%%%%%
% El CFSv2 necesita una descarga externa; correr por separado
CFSv2 = xlsread('CFSv2_SSR.xlsx');
 zCFSv2 = CFSv2;
 
 z1CFSv2m = nanmean(reshape(zCFSv2(:,1),24,39));
 z2CFSv2m = nanmean(reshape(zCFSv2(:,2),24,39));
 z3CFSv2m = nanmean(reshape(zCFSv2(:,3),24,39));
 
 sig1_f0 = nanstd(z1CFSv2m);
 sig2_f0 = nanstd(z2CFSv2m);
 sig3_f0 = nanstd(z3CFSv2m);
  
 u1_f0 = nanmean(z1CFSv2m);
 u2_f0 = nanmean(z2CFSv2m);
 u3_f0 = nanmean(z3CFSv2m);

 z1CFSv2d =(z1CFSv2m-u1_f0)*(sig_o(:,2)/sig1_f0)+u_o(:,2);
 z2CFSv2d =(z2CFSv2m-u2_f0)*(sig_o(:,1)/sig2_f0)+u_o(:,1);
 z3CFSv2d =(z3CFSv2m-u3_f0)*(sig_o(:,3)/sig3_f0)+u_o(:,3);
 
 z1CFSv2p = zscore(z1CFSv2d);
 z2CFSv2p = zscore(z2CFSv2d);
 z3CFSv2p = zscore(z3CFSv2d);
 
%% Estos scrips se desacragan directamente, no necesitan ajuste
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CanCM4i(10 ensambles)
% ##################################################################### COMPONENTE 1
% hind(S-1981-2019)
ur2_1=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.HINDCAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(180)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,....
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));
% frcst(S-2020-2021)
ur2_2=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.FORECAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(180)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,....
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));

z1CanCM4ih = str2num(webread(ur2_1)); z1CanCM4if = str2num(webread(ur2_2));
z1CanCM4(1:size(z1CanCM4ih,1),:) = z1CanCM4ih; 
z1CanCM4(((size(z1CanCM4ih,1)+1):(size(z1CanCM4ih,1)+size(z1CanCM4if,1))),:) = z1CanCM4if;

% Ajuste
z1CanCM4m=nanmean(reshape(z1CanCM4(:,1),10,40));
sig1_f1=nanstd(z1CanCM4m); u1_f1=nanmean(z1CanCM4m);
z1CanCM4d=(z1CanCM4m - u1_f1)*(sig_o(:,2)/sig1_f1)+u_o(:,2);
z1CanCM4p = zscore(z1CanCM4d);

% ##################################################################### COMPONENTE 2
% hind(S-1981-2019)
ur2_3=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.HINDCAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(320)/(340)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,....
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));
% frcst(S-2020-2021)
ur2_4=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.FORECAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(320)/(340)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,....
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));

z2CanCM4ih = str2num(webread(ur2_3)); z2CanCM4if = str2num(webread(ur2_4));
z2CanCM4(1:size(z2CanCM4ih,1),:) = z2CanCM4ih; 
z2CanCM4(((size(z2CanCM4ih,1)+1):(size(z2CanCM4ih,1)+size(z2CanCM4if,1))),:) = z2CanCM4if;

% Ajuste
z2CanCM4m=nanmean(reshape(z2CanCM4(:,1),10,40));
sig2_f1=nanstd(z2CanCM4m); u2_f1=nanmean(z2CanCM4m);
z2CanCM4d=(z2CanCM4m - u2_f1)*(sig_o(:,1)/sig2_f1)+u_o(:,1);
z2CanCM4p = zscore(z2CanCM4d);

% ##################################################################### COMPONENTE 3
% hind(S-1981-2019)
ur2_5=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.HINDCAST/.MONTHLY/.ugrd/Y/(0)/(-10)/RANGEEDGES/X/(240)/(280)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,....
'%201981-2018)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));
% frcst(S-2020-2021)
ur2_6=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.FORECAST/.MONTHLY/.ugrd/Y/(0)/(-10)/RANGEEDGES/X/(240)/(280)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,....
'%202019-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));

z3CanCM4ih = str2num(webread(ur2_5)); z3CanCM4if = str2num(webread(ur2_6));
z3CanCM4(1:size(z3CanCM4ih,1),:) = z3CanCM4ih; 
z3CanCM4(((size(z3CanCM4ih,1)+1):(size(z3CanCM4ih,1)+ size(z3CanCM4if,1))),:) = z3CanCM4if;

% Ajuste
z3CanCM4m=nanmean(reshape(z3CanCM4(:,1),10,40));
sig3_f1=nanstd(z3CanCM4m); u3_f1=nanmean(z3CanCM4m);
z3CanCM4d = (z3CanCM4m - u3_f1)*(sig_o(:,3)/sig3_f1)+u_o(:,3);
z3CanCM4p = zscore(z3CanCM4d);

clear ur2_1 ur2_2 ur2_3 ur2_4 ur2_5 ur2_6 u1_f1 u2_f1 u3_f1 sig1_f1 sig2_f1 sig3_f1
clear z1CanCM4ih z1CanCM4if z2CanCM4ih z2CanCM4if z3CanCM4ih z3CanCM4if
clear z1CanCM4 z1CanCM4m z1CanCM4d z2CanCM4 z2CanCM4m z2CanCM4d z3CanCM4 z3CanCM4m z3CanCM4d

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GEN-NEMO(10 ensambles)
% ##################################################################### COMPONENTE 1
%hind(S-1981-2019)
ur3_1=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.HINDCAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(180)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));
%frcst(S-2020-2021)
ur3_2=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.FORECAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(180)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));

z1GEN_NEMOh=str2num(webread(ur3_1)); z1GEN_NEMOf=str2num(webread(ur3_2));
z1GEN_NEMO(1:size(z1GEN_NEMOh,1),:) = z1GEN_NEMOh;
z1GEN_NEMO(((size(z1GEN_NEMOh,1)+1):(size(z1GEN_NEMOh,1)+size(z1GEN_NEMOf,1))),:) = z1GEN_NEMOf;

% Ajuste
z1GEN_NEMOm=nanmean(reshape(z1GEN_NEMO(:,1),10,40));
sig1_f2=nanstd(z1GEN_NEMOm); u1_f2=nanmean(z1GEN_NEMOm);
z1GEN_NEMOd=(z1GEN_NEMOm-u1_f2)*(sig_o/sig1_f2)+u_o(:,2);
z1GEN_NEMOp = zscore(z1GEN_NEMOd);

% ##################################################################### COMPONENTE 2
%hind(S-1981-2019)
ur3_3=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.HINDCAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(320)/(340)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));
%frcst(S-2020-2021)
ur3_4=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.FORECAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(320)/(340)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));

z2GEN_NEMOh = str2num(webread(ur3_3)); z2GEN_NEMOf = str2num(webread(ur3_4));
z2GEN_NEMO(1:size(z2GEN_NEMOh,1),:) = z2GEN_NEMOh;
z2GEN_NEMO(((size(z2GEN_NEMOh,1)+1):(size(z2GEN_NEMOh,1)+size(z2GEN_NEMOf,1))),:) = z2GEN_NEMOf;

% Ajuste
z2GEN_NEMOm=nanmean(reshape(z2GEN_NEMO(:,1),10,40));
sig2_f2=nanstd(z2GEN_NEMOm); u2_f2=nanmean(z2GEN_NEMOm);
z2GEN_NEMOd=(z2GEN_NEMOm - u2_f2)*(sig_o(:,1)/sig2_f2)+u_o(:,1);
z2GEN_NEMOp = zscore(z2GEN_NEMOd);

% ##################################################################### COMPONENTE 3
%hind(S-1981-2019)
ur3_5=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.HINDCAST/.MONTHLY/.ugrd/Y/(0)/(-10)/RANGEEDGES/X/(240)/(280)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));
%frcst(S-2020-2021)
ur3_6=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.FORECAST/.MONTHLY/.ugrd/Y/(0)/(-10)/RANGEEDGES/X/(240)/(280)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/10/RANGE/NaN/setmissing_value/data.ch'));

z3GEN_NEMOh = str2num(webread(ur3_5)); z3GEN_NEMOf = str2num(webread(ur3_6));
z3GEN_NEMO(1:size(z3GEN_NEMOh,1),:) = z3GEN_NEMOh;
z3GEN_NEMO(((size(z3GEN_NEMOh,1)+1):(size(z3GEN_NEMOh,1)+size(z3GEN_NEMOf,1))),:) = z3GEN_NEMOf;

% Ajuste
z3GEN_NEMOm=nanmean(reshape(z3GEN_NEMO(:,1),10,40));
sig3_f2=nanstd(z3GEN_NEMOm); u3_f2=nanmean(z3GEN_NEMOm);
z3GEN_NEMOd=(z3GEN_NEMOm - u3_f2)*(sig_o(:,3)/sig3_f2)+u_o(:,3);
z3GEN_NEMOp = zscore(z3GEN_NEMOd);

clear ur3_1 ur3_2 ur3_3 ur3_4 ur3_5 ur3_6 u1_f2 u2_f2 u3_f2 sig1_f2 sig2_f2 sig3_f2
clear z1GEN_NEMOih z1GEN_NEMOif z2GEN_NEMOih z2GEN_NEMOif z3GEN_NEMOih z3GEN_NEMOif 
clear z1GEN_NEMO z1GEN_NEMOm z1GEN_NEMOd z2GEN_NEMO z2GEN_NEMOm z2GEN_NEMOd z3GEN_NEMO z3GEN_NEMOm z3GEN_NEMOd 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CanSIPSv2(20 ensambles)
% ##################################################################### COMPONENTE 1
%hind(S-1981-2018)
ur4_1=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.HINDCAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(180)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/20/RANGE/NaN/setmissing_value/data.ch'));
%frcst(S-2019-2020)
ur4_2=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.FORECAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(180)/(240)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/20/RANGE/NaN/setmissing_value/data.ch'));

z1CanSIPSv2h = str2num(webread(ur4_1)); z1CanSIPSv2f = str2num(webread(ur4_2));
z1CanSIPSv2(1:size(z1CanSIPSv2h,1),:) = z1CanSIPSv2h;
z1CanSIPSv2(((size(z1CanSIPSv2h,1)+1):(size(z1CanSIPSv2h,1)+size(z1CanSIPSv2f,1))),:) = z1CanSIPSv2f;

% Ajuste
z1CanSIPSv2m=nanmean(reshape(z1CanSIPSv2(:,1),20,40));
sig1_f3=nanstd(z1CanSIPSv2m); u1_f3=nanmean(z1CanSIPSv2m);
z1CanSIPSv2d=(z1CanSIPSv2m-u1_f3)*(sig_o(:,2)/sig1_f3)+u_o(:,2);
z1CanSIPSv2p = zscore(z1CanSIPSv2d);

% ##################################################################### COMPONENTE 2
%hind(S-1981-2018)
ur4_3=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.HINDCAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(320)/(340)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/20/RANGE/NaN/setmissing_value/data.ch'));
%frcst(S-2019-2020)
ur4_4=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.FORECAST/.MONTHLY/.ugrd/Y/(10)/(-10)/RANGEEDGES/X/(320)/(340)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/20/RANGE/NaN/setmissing_value/data.ch'));

z2CanSIPSv2h = str2num(webread(ur4_3)); z2CanSIPSv2f = str2num(webread(ur4_4));
z2CanSIPSv2(1:size(z2CanSIPSv2h,1),:) = z2CanSIPSv2h;
z2CanSIPSv2(((size(z2CanSIPSv2h,1)+1):(size(z2CanSIPSv2h,1)+size(z2CanSIPSv2f,1))),:) = z2CanSIPSv2f;

% Ajuste
z2CanSIPSv2m=nanmean(reshape(z2CanSIPSv2(:,1),20,40));
sig2_f3=nanstd(z2CanSIPSv2m); u2_f3=nanmean(z2CanSIPSv2m);
z2CanSIPSv2d=(z2CanSIPSv2m-u2_f3)*(sig_o(:,1)/sig2_f3)+u_o(:,1);
z2CanSIPSv2p = zscore(z2CanSIPSv2d);

% ##################################################################### COMPONENTE 3
%hind(S-1981-2018)
ur4_5=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.HINDCAST/.MONTHLY/.ugrd/Y/(0)/(-10)/RANGEEDGES/X/(240)/(280)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%201981-2019)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/20/RANGE/NaN/setmissing_value/data.ch'));
%frcst(S-2019-2020)
ur4_6=char(strcat('https://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.FORECAST/.MONTHLY/.ugrd/Y/(0)/(-10)/RANGEEDGES/X/(240)/(280)/RANGEEDGES/%5BX/Y/%5Daverage/S/(0000%201%20',ini,...
'%202020-2021)/VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/P/(850)/VALUES/M/1/20/RANGE/NaN/setmissing_value/data.ch'));

z3CanSIPSv2h = str2num(webread(ur4_5)); z3CanSIPSv2f = str2num(webread(ur4_6));
z3CanSIPSv2(1:size(z3CanSIPSv2h,1),:) = z3CanSIPSv2h;
z3CanSIPSv2(((size(z3CanSIPSv2h,1)+1):(size(z3CanSIPSv2h,1)+size(z3CanSIPSv2f,1))),:) = z3CanSIPSv2f;

% Ajuste
z3CanSIPSv2m=nanmean(reshape(z3CanSIPSv2(:,1),20,40));
sig3_f3=nanstd(z3CanSIPSv2m); u3_f3=nanmean(z3CanSIPSv2m);
z3CanSIPSv2d=(z3CanSIPSv2m-u3_f3)*(sig_o(:,3)/sig3_f3)+u_o(:,3);
z3CanSIPSv2p = zscore(z3CanSIPSv2d);

clear ur4_1 ur4_2 ur4_3 ur4_4 ur4_5 ur4_6 u1_f3 u2_f3 u3_f3 sig1_f3 sig1_f3 sig2_f3 sig3_f3 
clear z1CanSIPSv2ih z1CanSIPSv2if z2CanSIPSv2ih z2CanSIPSv2if z3CanSIPSv2ih z3CanSIPSv2if 
clear z1CanSIPSv2 z1CanSIPSv2m z1CanSIPSv2d z2CanSIPSv2 z2CanSIPSv2m z2CanSIPSv2d z3CanSIPSv2 z3CanSIPSv2m z3CanSIPSv2d 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% INDICES CLIMATICOS 
ini='Jan';
si = 0.5; %%%lead time inicial "0.5" = Jan
sf = 2.5; %%%lead time final

%hind(S-1981-2020) ONI-EFM
usea1_1 = char(strcat('http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.ERSST/.version4/.sst/Y/(5S)/(5N)/RANGEEDGES/X/(210)/(270E)/RANGEEDGES/T/',...
    '(Jan-Mar%201981-2019)/VALUES/T/(Jan-Mar)/seasonalAverage/%5BX/Y/%5Daverage/data.ch'));
ONIh = strsplit(webread(usea1_1));
ONIh = str2num(char(ONIh(:,2:end)));
%frcst(S-2020-2021) ONI-EFM
usea1_2 = char(strcat('http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.NASA-GEOSS2S/.FORECAST/.MONTHLY/.sst/S/(0000%201%20',ini,'%202020-2021)/',...
    'VALUES/L/',num2str(si),'/',num2str(sf),'/RANGE/%5BL%5D//keepgrids/average/M/1/10/RANGE/SOURCES/.WORLDBATH/.bath/%5BX/Y%5DregridLinear/0/maskgt/0/',...
    'mul/add/Y(-5)/(5)/RANGEEDGES/X/(210)/(270)/RANGEEDGES/%5BX/Y/%5Daverage/NaN/setmissing_value/data.ch'));

ONIf = strsplit(webread(usea1_2));
ONIf = str2num(char(ONIf));
ONIfm = nanmean(reshape(ONIf(:,1),10,2));

ONI(:,1:size(ONIh,1)) = (ONIh)';
ONI(:,40:41) = ONIfm;

ONIp = ONI - nanmean(ONI(:,1:30));

%% Predictores: PDO 
uhpdo = ['http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.ERSST/.version4/.sst/T/%28Jan%201981%29%28Mar%202019%29RANGEEDGES/T/3/0.0/boxAverage/T', ...
    '/12/STEP/-999/setmissing_value/Y/88.0/-88.0/RANGE/Y/%2860N%29%2820N%29RANGEEDGES/X/%28120E%29%28120W%29RANGEEDGES/dods'];
sst1 = double(ncread(uhpdo,'sst')); 
lon = double(ncread(uhpdo,'X'));
lat = double(ncread(uhpdo,'Y'));

ufpdo = ['http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.NASA-GEOSS2S/.FORECAST/.MONTHLY/.sst/Y/%2820N%29/%2860N%29/RANGEEDGES/S',...
    '/%280000%201%20Jan%202020-2021%29/VALUES/X/%28120E%29/%28120W%29/RANGEEDGES/L/%281.5%29/%281.5%29/RANGEEDGES/%5BM+%5Daverage/dods'];
sst2 = double(ncread(ufpdo,'sst')); 
lati = double(ncread(ufpdo, 'Y'));
loni = double(ncread(ufpdo, 'X'));

[ilat, ilon] = meshgrid(lat,lon);
for i=1:2
    sst3(:,:,:,i) = single(interp2(lati,loni,sst2(:,:,:,i),ilat,ilon,'bilinear')); 
end

PDO = zeros(size(sst1,1),size(sst1,2),size(sst1,3),41);
PDO(:,:,:,1:size(sst1,4)) = sst1;
PDO(:,:,:,40:41) = sst3;
PDO = reshape(PDO,[size(PDO,1),size(PDO,2),size(PDO,4)]);

PDOmean = nanmean(PDO(:,:,1:30),3);

for t = 1:size(PDO,3)
   PDOAnm(:,:,t) = PDO(:,:,t) - PDOmean; 
end
PDOAnm(isnan(PDOAnm))= 0;

X=[ ];
for i=1:size(PDO,3)
 X = [X; reshape(squeeze(PDOAnm(:,:,i)),1,size(PDO,2)*size(PDO,1))];
end

inan=find(isnan(X(1,:))==1); %indices de posicion nan
ival=find(isnan(X(1,:))==0); %indices de posicion de valores
X(:,inan)=[];

Xcentered = bsxfun(@minus,X,mean(X));
 [U,S,COEFF] = svd(Xcentered, 'econ');
 SCORE = Xcentered*COEFF;
 
 PDOp = zscore(-SCORE(:,1));
 
%% Predictores: NAO 
uhnao = ['http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.MONTHLY/.Intrinsic/.PressureLevel/.phi/T/', ...
    '%28Jan%201981%29%28Mar%202020%29RANGEEDGES/T/3/0.0/boxAverage/T/12/STEP/P/%28500%29VALUES/-999/setmissing_value/Y/%2890N%29%280S%29RANGEEDGES/dods'];
phi1 = double(ncread(uhnao,'phi')); 
lat = double(ncread(uhnao, 'Y'));
lon = double(ncread(uhnao, 'X'));

ufnao = ['http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.NASA-GEOSS2S/.FORECAST/.MONTHLY/.h500/Y/%280S%29/%2890N%29/RANGEEDGES/S/', ...
    '%280000%201%20Jan%202020-2021%29/VALUES/L/%281.5%29/%281.5%29/RANGEEDGES/%5BM+%5Daverage/dods'];
ncdisp(ufnao)
phi2 = double(ncread(ufnao,'h500')); 
lati = double(ncread(ufnao, 'Y'));
loni = double(ncread(ufnao, 'X'));

[ilat, ilon] = meshgrid(lat,lon);
for i=1:2
    phi3(:,:,:,i) = single(interp2(lati,loni,phi2(:,:,:,i),ilat,ilon,'bilinear')); 
end

NAO = zeros(size(phi1,1),size(phi1,2),size(phi1,3),41);
NAO(:,:,:,1:size(phi1,4)) = phi1;
NAO(:,:,:,40:41) = phi3;
NAO = reshape(NAO,[size(NAO,1),size(NAO,2),size(NAO,4)]);
NAOmean = nanmean(NAO(:,:,1:30),3);

for t = 1:size(NAO,3)
   NAOAnm(:,:,t) = NAO(:,:,t) - NAOmean; 
end
NAOAnm = zscore(NAOAnm);

Y=[ ];
for i=1:size(NAO,3)
 Y = [Y; reshape(squeeze(NAOAnm(:,:,i)),1,size(NAO,2)*size(NAO,1))];
end

 inan=find(isnan(Y(1,:))==1); %indices de posicion nan
 ival=find(isnan(Y(1,:))==0); %indices de posicion de valores
 Y(:,inan)=[];
 
  Ycentered = bsxfun(@minus,Y,mean(Y));
  [U,S,COEFF] = svd(Ycentered, 'econ');
  SCORE = Ycentered*COEFF;
  RSCORE = rotatefactors(SCORE(:,1:3));
  NAOp = zscore(-SCORE(:,1));
  
 %% Predictores de SPI
t = 1; % Trimestre a trabajar
Trim = {'EFM', 'AMJ', 'JAS', 'OND'};
trim = {'03','06','19','12'};
file = char(strcat('C:\Users\PATRICIA\Documents\AA-SENAMHI\AA_PRNOSTICO\Trabajo\PCA_SPI',trim(t),'.xlsx'));
pre = xlsread(file,char(strcat('PCA_SPI',trim(t))));
y = pre(17:end,1:3);
spi = pre(17:end,4:end);

 bs1 = [-0.1097 0.7938 -0.4695 0.4033]'; % valores constantes para la ecuaciůn 1 componente
 bs2 = [0.5857 -0.7325 -0.4927]';        % valores constantes para la ecuaciůn 2 componente
 bs3 = [0.1016 -0.4654 -0.2924]';        % valores constantes para la ecuaciůn 3 componente
 
%% Pronostico 
% Componente 1 del SPI
figure 
subplot(3,1,1)
    plot(zscore(y(:,1),1),'b--o')
    hold on 
     plot(40.5,[ones(1,1) ONIp(end) PDOp(end) z2CFSv2p(end)]* bs1,'k--o','MarkerSize',9,'MarkerFaceColor', rgb('MediumBlue'))
     plot(41,[ones(1,1) ONIp(end) PDOp(end) z2CanCM4p(end)]* bs1,'k--d','MarkerSize',9,'MarkerFaceColor', rgb('DarkCyan'))
     plot(41.5,[ones(1,1) ONIp(end) PDOp(end) z2GEN_NEMOp(end)]* bs1,'k--s','MarkerSize',9,'MarkerFaceColor', rgb('Crimson'))
     plot(42,[ones(1,1) ONIp(end) PDOp(end) z2CanSIPSv2p(end)]* bs1,'k--p','MarkerSize',9,'MarkerFaceColor', rgb('DarkOrange'))
     hold on 
    x1=0;   y1=0; x2=42;   y2=0; X=[x1 x2]; Y=[y1 y2]; line(X,Y,'Color','black','LineStyle','-','LineWidth',1)
    hold on 
    ylabel('std.SCORES','Fontsize',9)
    %xlabel('TIEMPO','Fontsize',8)
    set(gca,'XTick',[1:2:44],'Fontsize',9)
    set(gca,'YTick',[-4:2:4],'Fontsize',9)
    set(gca,'XTickLabel',[1981:2:2025],'Fontsize',9)
    xlim([0 44])
    ylim([-4 4])
    grid on
    title('STPW: Pronůstico PC1 - SPI para EFM Sierra Sur (ic Ene)','FontSize',19,'FontWeight','bold')
    legend('PC-SPI','CFSv2', 'CanCM4I','GEN NEMO','CANSIPv2')
    
% Componente 2 del SPI
subplot(3,1,2)
    plot(zscore(y(:,2),1),'b--o')
    hold on 
     plot(40.5,  [ones(1,1) z1CFSv2p(end) NAOp(end)]*bs2,'k--o','MarkerSize',9,'MarkerFaceColor', rgb('MediumBlue'))
     plot(41,    [ones(1,1) z1CanCM4p(end) NAOp(end)]*bs2,'k--d','MarkerSize',9,'MarkerFaceColor', rgb('DarkCyan'))
     plot(41.5,  [ones(1,1) z1GEN_NEMOp(end) NAOp(end)]*bs2,'k--s','MarkerSize',9,'MarkerFaceColor', rgb('Crimson'))
     plot(42,    [ones(1,1) z1CanSIPSv2p(end) NAOp(end)]*bs2,'k--p','MarkerSize',9,'MarkerFaceColor', rgb('DarkOrange'))
  
    hold on 
    x1=0;   y1=0; x2=42;   y2=0; X=[x1 x2]; Y=[y1 y2]; line(X,Y,'Color','black','LineStyle','-','LineWidth',1)
    hold on
    ylabel('std.SCORES','Fontsize',9)
    %xlabel('TIEMPO','Fontsize',8)
    set(gca,'XTick',[1:2:44],'Fontsize',9)
    set(gca,'YTick',[-4:2:4],'Fontsize',9)
    set(gca,'XTickLabel',[1981:2:2025],'Fontsize',9)
    xlim([0 44])
    ylim([-4 4])
    grid on
    title('STPW: Pronůstico PC2 - SPI para EFM Sierra Sur (ic Ene)','FontSize',19,'FontWeight','bold')
   
% Componente 3 del SPI
subplot(3,1,3)
    plot(zscore(y(:,3),1),'b--o')
    hold on 
     plot(40.5,  [ones(1,1) NAOp(end) z3CFSv2p(end)]*bs3,'k--o','MarkerSize',9,'MarkerFaceColor', rgb('MediumBlue'))
     plot(41,    [ones(1,1) NAOp(end) z3CanCM4p(end)]*bs3,'k--d','MarkerSize',9,'MarkerFaceColor', rgb('DarkCyan'))
     plot(41.5,  [ones(1,1) NAOp(end) z3GEN_NEMOp(end)]*bs3,'k--s','MarkerSize',9,'MarkerFaceColor', rgb('Crimson'))
     plot(42,    [ones(1,1) NAOp(end) z3CanSIPSv2p(end)]*bs3,'k--p','MarkerSize',9,'MarkerFaceColor', rgb('DarkOrange'))
    hold on 
    x1=0;   y1=0; x2=42;   y2=0; X=[x1 x2]; Y=[y1 y2]; line(X,Y,'Color','black','LineStyle','-','LineWidth',1)
    hold on
    ylabel('std.SCORES','Fontsize',9)
    xlabel('TIEMPO','Fontsize',9)
    set(gca,'XTick',[1:2:44],'Fontsize',9)
    set(gca,'YTick',[-4:2:4],'Fontsize',9)
    set(gca,'XTickLabel',[1981:2:2025],'Fontsize',9)
    xlim([0 44])
    ylim([-4 4])
    grid on
    title('STPW: Pronůstico PC3 - SPI para EFM Sierra Sur (ic Ene)','FontSize',19,'FontWeight','bold')
    
    %% Pronostico de la PC1 SPI
    
    PC1CFSv2      =  [ones(1,1) ONIp(end) PDOp(end) z2CFSv2p(end)]*bs1;
    PC1CanCM4     =  [ones(1,1) ONIp(end) PDOp(end) z2CanCM4p(end)]*bs1;
    PC1GEN_NEMO   =  [ones(1,1) ONIp(end) PDOp(end) z2GEN_NEMOp(end)]*bs1;
    PC1CanSIPS    =  [ones(1,1) ONIp(end) PDOp(end) z2CanSIPSv2p(end)]*bs1;
    
    PC2CFSv2      =  [ones(1,1) z1CFSv2p(end) NAOp(end)]*bs2;
    PC2CanCM4     =  [ones(1,1) z1CanCM4p(end) NAOp(end)]*bs2;
    PC2GEN_NEMO   =  [ones(1,1) z1GEN_NEMOp(end) NAOp(end)]*bs2;
    PC2CanSIPS    =  [ones(1,1) z1CanSIPSv2p(end) NAOp(end)]*bs2;
    
    PC3CFSv2    =  [ones(1,1) NAOp(end) z3CFSv2p(end)]*bs3;
    PC3CanCM4   =  [ones(1,1) NAOp(end) z3CanCM4p(end)]*bs3;
    PC3GEN_NEMO =  [ones(1,1) NAOp(end) z3GEN_NEMOp(end)]*bs3;
    PC3CanSIPS  =  [ones(1,1) NAOp(end) z3CanSIPSv2p(end)]*bs3;
  
    name = {'CFSv2','CanCM4','GEN-NEMO','CanSIPS'};
    PRONO  = [PC1CFSv2 PC1CanCM4 PC1GEN_NEMO PC1CanSIPS; PC2CFSv2 PC2CanCM4 PC2GEN_NEMO PC2CanSIPS; PC3CFSv2 PC3CanCM4 PC3GEN_NEMO PC3CanSIPS]';

    ORIGN = sum(y,2); 
    SERIE = sum(PRONO,2);
       
%% Datos de SPI por estaciůn 
file='C:\Users\PATRICIA\Documents\AA-SENAMHI\AA_PRNOSTICO\Trabajo\SPI_SierraSur.xlsx';
var = xlsread(file,'SPI');
spi = var(4:12:670,:);

file2='C:\Users\PATRICIA\Documents\AA-SENAMHI\AA_PRNOSTICO\Trabajo\Coord_SPI_SierraSur.xlsx';
coor = xlsread(file2,'Coor');
PLon = coor(:,4);
PLat = coor(:,5);

LON = NaN(82,1);
LON(1:78,1)= PLon; LON(79,1)= -73.05; LON(80,1)= -72.45; LON(81,1)= -72.05; LON(82,1)= -71.65;

LAT = NaN(35,1);
LAT(1:78,1)= PLat; LAT(79,1)= -14.05; LAT(80,1)= -14.15; LAT(81,1)= -14.65; LAT(82,1)= -15.05;

file_pp='C:\Users\PATRICIA\Documents\AA-SENAMHI\AA_PRNOSTICO\Trabajo\SPI_SSUR_EFM.nc';  % Precipitaciůn Norte
ncdisp(file_pp); 

z=double(ncread(file_pp,'SPI')); 
lon=double(ncread(file_pp,'Lon'));
lat=double(ncread(file_pp,'Lat'));

% Puntos agregados para uniformizar la distribuciůn de la componente
p1 = z(83,151,:); p1 = reshape(p1, [39,1]);
p2 = z(89,152,:); p2 = reshape(p2, [39,1]);
p3 = z(93,157,:); p3 = reshape(p3, [39,1]);
p4 = z(97,161,:); p4 = reshape(p4, [39,1]); 

SPI = NaN(56,82);
SPI(1:56,1:78)= spi;
SPI(17:55,79)= p1; SPI(17:55,80)= p2; SPI(17:55,81)= p3; SPI(17:55,82)= p4;

Mean = nanmean(SPI,1);
[row, col] = find(isnan(SPI));

for i = 1:length(row)
   SPI(row(i),col(i)) = Mean(1,col(i));
end

%% Pronůstico por punto de estaciůn 
 [U,S,COEFF] = svd(SPI, 'econ');
 SCORE = SPI*COEFF;
 
for t = 1:4;
    Uno(:,:,t) = PRONO(t,1)*(COEFF');
    Dos(:,:,t) = PRONO(t,2)*(COEFF');
    Tres(:,:,t) = PRONO(t,3)*(COEFF');
    Cuatro = Uno(1,:,:) + Dos(2,:,:) + Tres(3,:,:);
    Pron(:,t) = reshape(Cuatro(:,:,t), [size(Cuatro,2) 1]);
end
 
figure
shape='C:\Users\PATRICIA\Documents\AA-SENAMHI\SHAPES\SierraSur.shp'; 
M = shaperead(shape); sh=[M.X;M.Y];
[gLon,gLat] = meshgrid(LON,LAT);
hold on
for k = 1:4
subplot(2,2,k)
f2 = colormap(cbrewer('div','RdBu',20));
sz = 100;
plot(sh(1,:)',sh(2,:)','color',[0.3 0.3 0.3],'MarkerSize',4,'LineWidth',1);
hold on
g1 = scatter(LON,LAT,sz,zscore(Pron(:,k)),'filled');
title({'STPW: Escenario de SPI pronosticado', name{k}} ,'FontSize',12,'FontWeight','bold')
colormap(f2)
colorbar
caxis([-2 2])
legend 

set(gca,'ylim',[-18.5 -12.75],'xlim',[-76.5 -68.5])
set(gca,'XTick',[-75.5 -73.5 -71.5 -69.5])
set(gca,'YTick',[-17 -15 -13])
set(gca,'FontSize',12,'FontWeight','bold');
set(gca,'XTickLabel',{'-75.5','-73.5','-71.5','-69.5'},'FontSize',12,'FontWeight','bold');
set(gca,'YTickLabel',{'-17','-15','-13'},'FontSize',12,'FontWeight','bold');
set(gcf, 'PaperPosition', [0 0 4 5]);
grid on
end

