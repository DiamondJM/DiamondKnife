function playerIdentity = retrievePlayerIdentity
    
    playerIdentity = input('Type 1 for human; 0 for computer. \n','s');
    while ~any(ismember(playerIdentity,{'1','0'}))
        fprintf('Incorrect input. \n')
        playerIdentity = input('Type 1 for human; 0 for computer. \n','s');
    end
    
    playerIdentity = logical(str2double(playerIdentity)); 
    
end