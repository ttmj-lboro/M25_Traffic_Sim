clear
close all
clc
load('defualt.mat')

import traci.constants

% Get the filename of the example scenario
scenarioPath = './config.sumocfg ';

system(['sumo-gui -c ' '"' scenarioPath '"' ' --remote-port 8813 --start&']);
traci.init();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

junctions = traci.junction.getIDList();
%fprintf('IDs of the junctions in the simulation:\n')
%for i=1:length(junctions)
%    fprintf('%s\n',junctions{i});
%end

lanes = traci.lane.getIDList();
%fprintf('IDs of the lanes in the simulation:\n')
%for i=1:length(lanes)
%  fprintf('%s\n',lanes{i});
%end

trafficlights = traci.trafficlights.getIDList();
%fprintf('IDs of the traffic lights in the simulation:\n')
%for i=1:length(trafficlights)
%  fprintf('%s\n',trafficlights{i});
%end

vehicletypes = traci.vehicletype.getIDList();
%fprintf('IDs of the vehicle types in the simulation:\n')
%for i=1:length(vehicletypes)
%  fprintf('%s\n',vehicletypes{i});
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
StartSpeed = ones(1,20)*70;

actions = zeros(1,20);

Speed = StartSpeed;

tolerance = 3;

progressionFactor = 5

memoryFactor = 2

influenceFactor = 0

deadEnd = 0;

defualt_vLeft(length(defualt_vLeft)+1) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 1:80
    laneID(c) = lanes(200+c);
end
for c = 1:60
    laneID2(c) = lanes(320+c);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tracker = 0;
while traci.simulation.getMinExpectedNumber() > 0
    for i = 1:1000
    traci.simulationStep();
    end
    
    tracker = tracker + 1;
    vLeft(tracker) = traci.simulation.getMinExpectedNumber();
    
    PossibleActions = ones(20,1)*2;
    
    for i = 1:20
    if Speed(i) == 70
       PossibleActions(i) = 1 ;
    elseif Speed(i) == 30
        PossibleActions(i) = -1;
    end
    end
    

for i = 1:20
    progression = randi(progressionFactor,1);
    if progression == 1
    ActionTaken(i) = randi(3,1)-2;
    while ActionTaken(i) == PossibleActions(i)  
    ActionTaken(i) = randi(3,1)-2;
    end
    else
       ActionTaken(i) = 0;
    end
end

Speed = Speed + ActionTaken*10;
SpeedHistory(tracker) = string(num2str(Speed));
    
 for c = 1:20
    for i = 1:4
        lane = char(laneID(c*(i-1)+i));
        traci.lane.setMaxSpeed(lane,Speed(c));
    end
    for i = 1:4
        lane = char(laneID(c*(i-1)+i));
        traci.lane.setMaxSpeed(lane,Speed(c));
    end
end   
      
    
end
traci.close()


fid = fopen('tripinfos.txt');
tline = fgetl(fid);
lineCounter = 1;
vehicle = 0;
while ischar(tline)
    for i = 1:length(tline)-20
        if tline(i:i+8) == 'timeLoss='
            SearchTerm = '"';
            con = 0;
            j = i+10;
            while con == 0
            if tline(j) == SearchTerm
                con = 1;
                vehicle= vehicle+1;
                TL = tline(i+10:j-1);
            timeloss(vehicle) = str2num(TL);
            else
                j = j+1;
            end
            end
        end   
    end
    % Read next line
    tline = fgetl(fid);
    lineCounter = lineCounter + 1;
end
mean(timeloss)
mean(defualt_timeloss)
fclose(fid);

p1 = 1:length(vLeft);
p2 = 1:length(defualt_vLeft);
plot(p1,vLeft,p2,defualt_vLeft)


while length(vLeft) ~= length(defualt_vLeft)
if length(vLeft) <= length(defualt_vLeft)
    vLeft(length(vLeft)+1) = 0;
else
   defualt_vLeft(length(defualt_vLeft)+1) = 0;
end
end
if length(vLeft) == length(defualt_vLeft)
    dif = vLeft - defualt_vLeft;
end


optimumSpeed = SpeedHistory;
bestSpeedHistory = SpeedHistory;

previousvLeft = vLeft;

if mean(timeloss) < mean(defualt_timeloss)
    for i = 1+memoryFactor:length(optimumSpeed)
    if dif(i) > 0
        optimumSpeed(i-memoryFactor:i-influenceFactor) = SpeedHistory(i-memoryFactor:i-influenceFactor);
    end
    end
    
end

TLMap(1) = mean(defualt_timeloss);
TLMap(2) = mean(timeloss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for x = 2:500

import traci.constants

% Get the filename of the example scenario
scenarioPath = './config.sumocfg ';

system(['sumo-gui -c ' '"' scenarioPath '"' ' --remote-port 8813 --start&']);
traci.init();

tracker = 0;
while traci.simulation.getMinExpectedNumber() > 0
    for i = 1:1000
    traci.simulationStep();
    end
    
    tracker = tracker + 1;
    vLeft(tracker) = traci.simulation.getMinExpectedNumber();
    try
tempspeed = str2num(optimumSpeed(tracker));
    catch
    end    
    PossibleActions = ones(20,1)*2;
    
   for i = 1:20
    progression = randi(progressionFactor,1);
    if progression == 1
    ActionTaken(i) = randi(3,1)-2;
    while ActionTaken(i) == PossibleActions(i)  
    ActionTaken(i) = randi(3,1)-2;
    end
    else
       ActionTaken(i) = 0;
    end
end
    

for i = 1:20
    ActionTaken(i) = randi(3,1)-2;
   while ActionTaken(i) == PossibleActions(i)  
    ActionTaken(i) = randi(3,1)-2;
    end
end

Speed = tempspeed + ActionTaken*10;
SpeedHistory(tracker) = string(num2str(Speed));
    
 for c = 1:20
    for i = 1:4
        lane = char(laneID(c*(i-1)+i));
        traci.lane.setMaxSpeed(lane,Speed(c));
    end
    for i = 1:3
        lane = char(laneID(c*(i-1)+i));
        traci.lane.setMaxSpeed(lane,Speed(c));
    end
end   
end
traci.close();
fid = fopen('tripinfos.txt');
tline = fgetl(fid);
lineCounter = 1;
vehicle = 0;
while ischar(tline)
    for i = 1:length(tline)-20
        if tline(i:i+8) == 'timeLoss='
            SearchTerm = '"';
            con = 0;
            j = i+10;
            while con == 0
            if tline(j) == SearchTerm
                con = 1;
                vehicle= vehicle+1;
                TL = tline(i+10:j-1);
            timeloss(vehicle) = str2num(TL);
            else
                j = j+1;
            end
            end
        end   
    end
    % Read next line
    tline = fgetl(fid);
    lineCounter = lineCounter + 1;
    
    c1 = length(vLeft);
    c2 = length(previousvLeft);
    if c1 == c2
    dif = vLeft - previousvLeft;
    else 
        vLeft(length(vLeft)+1)= 0;
    end
      
    
end

mean(timeloss);
fclose(fid);
fprintf('iteration %i  \n', x+1)
percent = (mean(defualt_timeloss)-mean(timeloss))/(mean(defualt_timeloss))*100;
fprintf('percentage improvement is %d %% \n', percent)

p1 = 1:length(vLeft);
p2 = 1:length(defualt_vLeft);
plot(p1,vLeft,p2,defualt_vLeft)


while length(vLeft) ~= length(defualt_vLeft)
if length(vLeft) <= length(defualt_vLeft)
    vLeft(length(vLeft)+1) = 0;
else
    defualt_vLeft(length(defualt_vLeft)+1) = 0;
end
end
if length(vLeft) == length(defualt_vLeft)
    dif = vLeft - defualt_vLeft;
end



TLMap(x+1) = mean(timeloss);

plot(TLMap)

if mean(timeloss) <= min(TLMap)
   bestvLeft = vLeft;
   bestSpeedHistory = SpeedHistory;
   deadEnd = 0;
else
   deadEnd = deadEnd + 1
end
    previousvLeft = vLeft;
if TLMap(x+1) < min(TLMap) + tolerance   
    for n = 1+memoryFactor:length(optimumSpeed)
    if dif(n) > 0
        optimumSpeed(n-memoryFactor:n-influenceFactor) = SpeedHistory(n-memoryFactor:n-influenceFactor);
    end
    end
    
end

if deadEnd == 10
    optimumSpeed = bestSpeedHistory;
    fprintf('dead end reached')
    deadEnd = 0;
end

 end
