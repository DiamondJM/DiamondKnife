%%%%%%%%%%%%%%%
% Hit run!
%%%%%%%%%%%%%

clearvars
TTable = containers.Map('KeyType','uint32','ValueType','any');
zKeys = uint32(randperm(2^32,64*12+1+4+8));


currentObj = prepareFirstNode(zKeys);
currentGame = gameOrganizer;

while ~currentObj.gameOver
    subplot(1,2,1); 
    RenderBoard(currentObj.position); title('In-game position')
    [currentObj,TTable] = orchestrateMove(currentGame,currentObj,TTable,zKeys);
    
end


RenderBoard(currentObj.position)
disp('Game over! ');


