function S = ES_analyzeAirData(Data, varargin)
% This function is the main analysis function
% It requires Data input retrieved from archive.sensor.community by ES_retrieveSDSAirData
% 
% Written by: Artoghrul Alishbayli for Elmi Spektr (2021)
%
% Note: This set of functions use scripts written by Bernhard Englitz
% see: https://bitbucket.org/benglitz/controller-dnp/ 

P = parsePairs(varargin);
checkField(P,'Analysis','DayOfWeek');
checkField(P,'DateTimeFormat','yyyy-mm-dd HH:MM:SS'); % The format in which air quality data is stored inside .csv files
checkField(P,'Interval',5); % The interval with which data is binned, increase or decrease to change the resolution

switch P.Analysis
  case 'DayOfWeek'
    t1 = [0,0,0]*[3600,60,1]';
    t2 = [23,59,0]*[3600,60,1]';
    timeBins = [t1 : (5 * 60) : t2]; % every five minutes
    uniqueDays = unique({Data.Day});
    tmpNaN = mat2cell(NaN*zeros(length(uniqueDays),1),ones(1,length(uniqueDays)),1)';
    S = struct('PM10',mat2cell(NaN*zeros(length(timeBins),length(uniqueDays)),length(timeBins),ones(1,length(uniqueDays))'),...
      'PM25',mat2cell(NaN*zeros(length(timeBins),length(uniqueDays)),length(timeBins),ones(1,length(uniqueDays))'),...
      'DayOfWeek',tmpNaN);
    
    for iDay = 1:length(uniqueDays)
      cDate = char(uniqueDays(iDay));
      printupdate(['Processing date: ',num2str(iDay),'/',num2str(length(uniqueDays))],iDay ==1);
      cYear = str2num(cDate(1:4));
      cMonth = str2num(cDate(6:7));
      cDay = str2num(cDate(9:10));
      cInd = contains({Data.Day},cDate);
      cData = Data(cInd);
      S(iDay).DayOfWeek = unique([cData.DayOfWeek]);
     
      for iT = 1:length(timeBins)-1
        cDataInd = [cData.TimePoint] >=  timeBins(iT) & [cData.TimePoint] <= timeBins(iT+1);
        if sum(cDataInd) >0
          S(iDay).PM10(iT,1) = mean([cData(cDataInd).P1]);
          S(iDay).PM25(iT,1) = mean([cData(cDataInd).P2]);
        else
          S(iDay).PM10(iT,1) = NaN;
          S(iDay).PM25(iT,1) = NaN;
        end
      end
    end    
end