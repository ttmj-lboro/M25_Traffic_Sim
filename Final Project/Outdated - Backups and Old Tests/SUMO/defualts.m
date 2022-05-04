clear
close all
clc

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
fprintf('IDs of the lanes in the simulation:\n')
for i=1:length(lanes)
  fprintf('%s\n',lanes{i});
end

trafficlights = traci.trafficlights.getIDList();
fprintf('IDs of the traffic lights in the simulation:\n')
for i=1:length(trafficlights)
  fprintf('%s\n',trafficlights{i});
end

vehicletypes = traci.vehicletype.getIDList();
fprintf('IDs of the vehicle types in the simulation:\n')
for i=1:length(vehicletypes)
  fprintf('%s\n',vehicletypes{i});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
StartSpeed = ones(1,20)*70;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tracker = 0;
while traci.simulation.getMinExpectedNumber() > 0
    for i = 1:1000
    traci.simulationStep();
    end
    
    tracker = tracker + 1;
    defualt_vLeft(tracker) = traci.simulation.getMinExpectedNumber();   
    
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
            defualt_timeloss(vehicle) = str2num(TL);
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

fclose(fid);
   