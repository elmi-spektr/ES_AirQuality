function ES_plotAirData (S)
% UNDER DEVELOPMENT
% This function plots the air data in multiple ways
%
% Written by: Artoghrul Alishbayli for Elmi Spektr (2021)
%
% Note: This set of functions use scripts written by Bernhard Englitz
% see: https://bitbucket.org/benglitz/controller-dnp/ 

t1 = [0,0,0]*[3600,60,1]';
t2 = [23,59,0]*[3600,60,1]';
timeBins = [t1 : (5 * 60) : t2];
timeBins(2,:) = floor(timeBins(1,:)./3600);
timeBins(3,:) = floor((timeBins(1,:)-timeBins(2,:)*3600)/60);
for iT = 1:length(timeBins)
  TimeTick{iT} = [num2str(timeBins(2,iT)),':',num2str(timeBins(3,iT))];
end

%% DAY-WISE AVERAGES - For visually inspecting daily patterns
figure(2); clf;
DayNames = {'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'};
Days = unique([S.DayOfWeek]);
for iD = 1:length(Days)
  cInd = [S.DayOfWeek] == Days(iD);
  cPM10Data = vertcat([S(cInd).PM10])';
  cPM25Data = vertcat([S(cInd).PM25])';
  NPM10PointPerTimebin = sum(~isnan(cPM10Data),1);
  NPM25PointPerTimebin = sum(~isnan(cPM25Data),1);
  PM10MeanSEM = nanstd(cPM10Data,[],1)./sqrt(NPM10PointPerTimebin);
  PM25MeanSEM = nanstd(cPM25Data,[],1)./sqrt(NPM25PointPerTimebin);
  MeanPM10 = nanmean(cPM10Data,1);
  MeanPM25 = nanmean(cPM25Data,1);
  PM10h1=  errorhull(1:length(timeBins),MeanPM10,2*PM10MeanSEM,'Color',[1 0 0],'Alpha',0.25);
  PM10h2 = errorhull(1:length(timeBins),MeanPM10,PM10MeanSEM,'Color',[1 0 0]);
  PM25h1 = errorhull(1:length(timeBins),MeanPM25,2*PM25MeanSEM,'Color',[0 0 1],'Alpha',0.25);
  PM25h2 = errorhull(1:length(timeBins),MeanPM25,PM25MeanSEM,'Color',[0 0 1]);
  xticks(1:40:288); xticklabels(TimeTick(1:40:288)); ylim([0,100]);
  title(DayNames{iD}); pause; 
  clf;
end

%% AVERAGE SIGNAL
figure(1); clf;
cPM10Data = vertcat([S.PM10])';
cPM25Data = vertcat([S.PM25])';
NPM10PointPerTimebin = sum(~isnan(cPM10Data),1);
NPM25PointPerTimebin = sum(~isnan(cPM25Data),1);
PM10MeanSEM = nanstd(cPM10Data,[],1)./sqrt(NPM10PointPerTimebin);
PM25MeanSEM = nanstd(cPM25Data,[],1)./sqrt(NPM25PointPerTimebin);
MeanPM10 = nanmean(cPM10Data,1);
MeanPM25 = nanmean(cPM25Data,1);
PM10h1= errorhull(1:length(timeBins),MeanPM10,2*PM10MeanSEM,'Color',[1 0 0],'Alpha',0.25);
PM10h2 = errorhull(1:length(timeBins),MeanPM10,PM10MeanSEM,'Color',[1 0 0]);
PM25h1 = errorhull(1:length(timeBins),MeanPM25,2*PM25MeanSEM,'Color',[0 0 1],'Alpha',0.25);
PM25h2 = errorhull(1:length(timeBins),MeanPM25,PM25MeanSEM,'Color',[0 0 1]);
xticks(1:40:288); xticklabels(TimeTick(1:40:288));