function [currentObj,TTable] = iterativeDeep(currentObj,maxDepth,TTable,zKeys)
        
    
    color = currentObj.currentColor;
    
    currentTime = 0;
    
    depthReached = 0;
    
    killerMoves = zeros(maxDepth * 2,5);
    for depth = 1:maxDepth
        tic;
        killerMoves = [zeros(2,5); killerMoves(1:end - 2,:)];
        [currentObj,TTable,killerMoves] = manageTranstable(currentObj,-Inf,Inf,depth,TTable,zKeys,killerMoves);
        
        
        currentEval = double(currentObj.winningEval * color) / 100;

        
        if depth > depthReached; [pv, depthReached] = pullPV(currentObj,TTable,zKeys); end
        currentTime = currentTime + toc;
        fprintf('%d: %.2f seconds, eval %.2f. \nPV: %s \n',depth,currentTime,currentEval,pv)
                
        if currentObj.gameOver; return;
        elseif currentTime * depth >= 20; return; 
        end
        
    end
    
end