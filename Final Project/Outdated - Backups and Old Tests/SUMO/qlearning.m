
numA = 242
% modelling options as a binary system of actions
% pairs of junctions together to reduce calculation size
% largest option 1111111111 = 1024 possible actions over the system
numS = 5
%start        - no associated reward
%improved     - +1 associated reward
%consistant   - no associated reward
%worsened     - -1 associated reward
%end          - +25 associated reward
qtable = zeros(numS,numA)

gamma = 0.75 %discount factor
alpha = 0.9 %learning factor

StartSpeed = ones(1,10)*70;

actions = zeros(1,10);

Speed = StartSpeed
for c = 1:20
    
for i = 1:10
    if Speed(i) == 70
       PossibleActions(i) = 1 ;
    elseif Speed(i) == 40
        PossibleActions(i) = -1;
    end    
end

ActionTaken = zeros(1,10)
for i = 1:10
    ActionTaken(i) = randi(3,1)-2;
    while ActionTaken(i) == PossibleActions(i)  
    ActionTaken(i) = randi(3,1)-2;
    end
end
tracker = c;
Speed = Speed + ActionTaken*5 
ActionHistory(tracker) = string(num2str(ActionTaken))

end

