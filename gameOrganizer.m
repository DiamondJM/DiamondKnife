classdef gameOrganizer
    
    properties
        
        whiteHuman = false;
        blackHuman = false;
                
        %currentObject
        
    end
    
    methods 
        
        function chessGame = gameOrganizer
            
            fprintf('Who plays white? \n');
            whitePlayer = retrievePlayerIdentity;
            
            fprintf('Who plays black? \n'); 
            blackPlayer = retrievePlayerIdentity; 
                        
            chessGame.whiteHuman = whitePlayer; 
            chessGame.blackHuman = blackPlayer; 
        end
        
        
    end
end

            
        
        
        