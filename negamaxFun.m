function [currentObj,TTable] = negamaxFun(currentObj,alpha,beta,depth,color,TTable,zKeys)


breakFlag = false;
tol = 0.0001;

%%%%%%
% Regarding tolerance 
% It's tricky what we're doing, but we're actually promoting cuts, not
% preventing them. 
% The point is that, if we _just barely_ decide to cut, and do so because
% of a floating point error, we actually don't lose much. We prevent one
% side from knowing that a _slightly_ better move exists. But the upside is
% that we save a lot of time. 
% A weird consequence of this, though, could be more re-searches. 


compareEval = -Inf; 

for ii = 1:length(currentObj.children)
    
    [currentObj.children(ii), TTable] = ...
        manageTranstable(currentObj.children(ii), -beta, -alpha, depth - 1, -color, TTable,zKeys);
    
    currentObj.children(ii).winningEval = -currentObj.children(ii).winningEval;
    if currentObj.children(ii).winningEval > compareEval
        compareEval = currentObj.children(ii).winningEval;
        currentObj.winningEval = compareEval;
    end
    
    alpha = max(alpha,compareEval);
    
    if beta <= alpha + tol
        breakFlag = true;
        break
    end
end


%%%%%%%%%%%%%%%%%
% Are we in a losing position? 
%%%%%%%%%%%%%%%%

if all([currentObj.children.childLostKing]) 
    if ~isInCheck(currentObj,zKeys)
        % Stalemate
        currentObj.winningEval = 0;
    end 
    currentObj.gameOver = true;
else
    if ~breakFlag
        evals = [currentObj.children.winningEval];
        [~,I] = max(evals);
        currentObj.children = currentObj.children(I);
    else
        currentObj.children = currentObj.children(ii);
    end
end


end
