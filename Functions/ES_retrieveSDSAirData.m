function Data = ES_retrieveSDSAirData(varargin)
% Retrieves sds sensor data from archive.sensor.community
% 
% Written by: Artoghrul Alishbayli for Elmi Spektr (2021)
%
% Note: This set of functions use scripts written by Bernhard Englitz
% see: https://bitbucket.org/benglitz/controller-dnp/ 

P = parsePairs(varargin);
checkField(P,'SDSSensorID','sds011_sensor_60370'); % ID of the sensor you want to analyze
checkField(P,'BeginDate',[]); % Date from which you want to retrieve data 
checkField(P,'EndDate',[]); % Date until which you want to retrieve data
checkField(P,'Root','https://archive.sensor.community'); % Shouldn't be changed unless the address changes
checkField(P,'FileType','.csv'); % Default format in which the data is stored
checkField(P,'DateFormat','yyyy-mm-dd'); % The format in which you should specify BeginDate and EndDate
checkField(P,'DateTimeFormat','yyyy-mm-dd HH:MM:SS'); % The format in which air quality data is stored inside .csv files


BeginDate = datenum(P.BeginDate,P.DateFormat);
EndDate =  datenum(P.EndDate,P.DateFormat);
Dates = BeginDate:EndDate;
Data = [];
for iD = 1:length(Dates)
  printupdate(['Processing date: ',num2str(iD),'/',num2str(length(Dates))],iD ==1);
  cDate = datestr(Dates(iD),P.DateFormat);
  cPath = [P.Root,'/',cDate,'/',cDate,'_',P.SDSSensorID,P.FileType];
  cData = webread(cPath);
  Data = [Data;cData];
end

Data = table2struct(Data);

% Add day of the week field and convert time to duration for analysis further downstream.
fprintf('\nExtracting date information...\n')
for iD = 1:length(Data)
  Data(iD).Day = Data(iD).timestamp(1:10);
  Data(iD).Time = Data(iD).timestamp(12:end);
  Data(iD).DayOfWeek = weekday(Data(iD).Day,P.DateFormat);
  Data(iD).Datetime = datevec([Data(iD).Day,' ',Data(iD).Time], P.DateTimeFormat);
  Data(iD).TimePoint = Data(iD).Datetime(4)*60*60 + Data(iD).Datetime(5)*60 + Data(iD).Datetime(6);
end
    