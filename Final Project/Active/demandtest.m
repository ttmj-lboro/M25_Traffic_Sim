clear
close all
clc
load('defualt.mat')

import traci.constants

% Get the filename of the example scenario
scenarioPath = './Copy_of_config.sumocfg ';

system(['sumo-gui -c ' '"' scenarioPath '"' ' --remote-port 8813 --start&']);
traci.init();
while traci.simulation.getMinExpectedNumber() > 0
    traci.simulationStep();
end
traci.close()