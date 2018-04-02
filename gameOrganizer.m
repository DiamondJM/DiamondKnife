classdef gameOrganizer
    
    properties
        
        whiteHuman = false;
        blackHuman = false;
        
        whiteMove = true;
        
        %currentObject
        
    end
    
    methods 
        
        function chessGame = gameOrganizer
            
            whiteString = input('Who plays white? Type human or computer. ','s');
            while ~any(strcmpi(whiteString,{'human','computer'}))
                disp('Incorrect input.')
                whiteString = input('Who plays white? Type human or computer. ','s');
            end
            if strcmpi(whiteString,'human')
                chessGame.whiteHuman = true;
            end
            
            
            blackString = input('Who plays black? Type human or computer. ','s');
            while ~any(strcmpi(blackString,{'human','computer'}))
                disp('Incorrect input.')
                blackString = input('Who plays white? Type human or computer. ','s');
            end
            if strcmpi(blackString,'human')
                chessGame.blackHuman = true;
            end
            
          
        end
        

    end
end

            
        
        
        