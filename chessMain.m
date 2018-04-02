%%%%%%%%%%%%%%%
% Hit run!
%%%%%%%%%%%%%

clearvars

startPosition = zeros(12,'int8');


for ii = 3:10 %Set up chessboard 
    startPosition(4,ii)=-1;
    startPosition(9,ii)=1;
end
for ii = 1:12
    if ii==3 || ii==10
        startPosition(3,ii)=-5;
        startPosition(10,ii)=5;
    elseif ii==4 || ii==9
        startPosition(3,ii)=-2;
        startPosition(10,ii)=2;
    elseif ii==5 || ii==8
        startPosition(3,ii)=-3;
        startPosition(10,ii)=3;
    elseif ii==6
        startPosition(3,ii)=-9;
        startPosition(10,ii)=9;
    elseif ii==7
        startPosition(3,ii)=-10;
        startPosition(10,ii)=10;
    end
end
for ii = [1 2 11 12]
    startPosition(ii,:) = 99;
end
for ii = [1 2 11 12]
    startPosition(:,ii) = 99;
end


%%%%
% The below line resets our zobrist keys.
chessboard_zob.getInstanceZob(true);
%%%%



chessboard_zob.getInstance(2);
chessboard_zob.getInstance(1);


currentObject = chessboard_zob(startPosition);
currentGame = gameOrganizer;

while ~currentObject.gameOver
    
    RenderBoard(currentObject.position)
    
    if (currentObject.wmove && ~currentGame.whiteHuman)...
            || (~currentObject.wmove && ~currentGame.blackHuman)
        
        currentObject = computerMove(currentObject);
    else        
        currentObject = humanMove(currentObject);
    end
    
    
end

RenderBoard(currentObject.position)
disp('Game over! ');


function currentObject = computerMove(currentObject)

gameOverFlag = false;

searchDepth = 12;

currentObject=iterative_deep(currentObject,searchDepth);


currentObject = listofmoves(currentObject);
TRANSTABLE = currentObject.getInstance;
mymove = TRANSTABLE(currentObject.zobrist).bestmove;
movelist = cat(1,currentObject.children.oldnew);
index = find(all(movelist == mymove,2));
%currentObject.children(index).position

if currentObject.gameOver;gameOverFlag = true; end

currentObject = currentObject.children(index);

if gameOverFlag; currentObject.gameOver = 1; end
end


function currentObject = humanMove(currentObject)
currentObject = listofmoves(currentObject);

moveList = cell(1,length(currentObject.children));
for ii = 1:length(moveList)
    moveList{ii} = squares2string(currentObject.children(ii).oldnew,...
        currentObject.children(ii).promotion);
end

movechoice = input('Please provide move. For instructions, press 1. ','s');

if isequal(movechoice,'1')
    fprintf(['Give move as from square and to square. \n' ...
        'For instance, e4d5. \n' ...
        'For promotions, format as b2a1=N. \n' ...
        'For castling, give o-o or o-o-o. \n'])
    
else
    if isequal(movechoice,'o-o') % The opponent castled. Are they white or black?
        if ~currentObject.wmove
            movechoice = 'e8g8';
        else
            movechoice = 'e1g1';
        end
    elseif isequal(movechoice,'o-o-o')
        if ~currentObject.wmove
            movechoice = 'e8c8';
        else
            movechoice = 'e1c1';
        end
    end

    index = strcmpi(movechoice,moveList);
    if ~any(index)
        disp('Incorrect move. ');
        currentObject = humanMove(currentObject);
    else
        currentObject = currentObject.children(index);
    end
end
currentObject = humanMateCheck(currentObject,2);


end
