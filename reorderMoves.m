function currentObj = reorderMoves(currentObj,myStruct,killerMoves,depth)
    
    %% Transposition table 
    
    bestMove = myStruct.bestMove;
    moveList = cat(1,currentObj.children.moveIdentifier);
    movelistIndex = find(all(moveList == bestMove,2),1);
    if movelistIndex > 1
        v = 1:length(currentObj.children);
        currentObj.children = currentObj.children([v(v == movelistIndex) v(v ~= movelistIndex)]);
    end
    
    %% Killer heuristic 
    
    killerList = killerMoves([depth * 2 - 1 depth * 2],:);
    placeIndex = killerList(:,1) == 0;
    
    if all(placeIndex); return; end
    
    [~,movelistIndex] = ismember(killerList,moveList,'rows');
    movelistIndex = movelistIndex'; 
    
    if ~any(movelistIndex > 2); return; end
    
    if any([currentObj.children.caProm])
        placeIndex = find([currentObj.children.caProm],1,'last');
        placeIndex = min(5,placeIndex);
    else
        placeIndex = 1; 
    end
    
    
    v = 1:length(currentObj.children);
    
    for ii = find(movelistIndex)
        tempIndex = movelistIndex(ii);
                
        if tempIndex <= placeIndex; continue; end  
        % Either duplicate position, if equal; 
        % Or we're actually moving the move backwards, if it's less. 
        if tempIndex == placeIndex + 1  % No effect of rearrangement
            if diff(movelistIndex) == 1
                return  % Basically in this circumstance our moves are already perfectly ordered.
            else
                placeIndex = placeIndex + 1;
                continue
            end
        end
        
        currentObj.children = currentObj.children([v(v <= placeIndex & v ~= tempIndex) v(v == tempIndex) v(v > placeIndex & v ~= tempIndex)]);
        placeIndex = placeIndex + 1;
    end
    
    % This works equivalently, I believe, but has some redundant activity.

    
    %% Alternative 
    
%     More elegant but redundant activity 

%     for ii = find(movelistIndex)
%         tempIndex = movelistIndex(ii);
%         
%         if tempIndex <= placeIndex; continue; end  % Duplicate position
%         currentObj.children = currentObj.children([v(1:placeIndex) v(v == tempIndex) v(v > placeIndex & v ~= tempIndex)]);
%         placeIndex = placeIndex + 1;
%     end
    

    
end
    
    
    
