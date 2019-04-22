function  outputObj = processMove(currentObj,currentSquare,newSquare,currentPiece,zKeys)
%% Unpack

currentPosition = currentObj.position;
zobristKey = currentObj.zobristKey;

currentColor = currentObj.currentColor;
if currentColor == 1; whiteMove = true;
else; whiteMove = false;
end

castleRights = currentObj.castleRights;
lostKing = 0;

caProm = false;

positionHistory = currentObj.positionHistory;

%% Identify current piece

if currentPiece < -50
    currentPiece = currentPosition(currentSquare(1),currentSquare(2));
else
    caProm = true;
end

%% Zobrist key

pieceConverter = [1 1; 2 2; 3 3; 5 4; 9 5; 10 6; -1 7; -2 8; -3 9; -5 10; -9 11; -10 12];

% Xor out
squareInd = sub2ind([8 8],currentSquare(1) - 2,currentSquare(2) - 2);
pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
pieceInd = pieceInd(1);
zobInd = sub2ind([64 12], squareInd, pieceInd);
zobInd = zKeys(zobInd);
zobristKey = bitxor(zobristKey, zobInd);

% Xor in
squareInd = sub2ind([8 8],newSquare(1) - 2, newSquare(2) - 2);
% pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
zobInd = sub2ind([64 12], squareInd, pieceInd);
zobInd = zKeys(zobInd);
zobristKey = bitxor(zobristKey, zobInd);

% Capture piece
capturePiece = currentPosition(newSquare(1), newSquare(2));
if capturePiece
    % squareInd = sub2ind([8 8],newSquare(1) - 2, newSquare(2) - 2);
    pieceInd = pieceConverter(pieceConverter(:,1) == capturePiece,2);
    pieceInd = pieceInd(1);
    zobInd = sub2ind([64 12], squareInd, pieceInd);
    zobInd = zKeys(zobInd);
    zobristKey = bitxor(zobristKey, zobInd);
end

% Xor out old target file
if currentObj.targetFile
    targetFile = currentObj.targetFile;
    zobristKey = bitxor(zobristKey,zKeys(773 + targetFile - 2));
end

% Change moving rights
zobristKey = bitxor(zobristKey,zKeys(769));


%% Castlethru

% While we're here, let's check and see if this current "move" is
% running through a castled square.

if ~any(castleRights([3 4], ~whiteMove + 1)) && any(castleRights([3 4], ~whiteMove + 3))
    % The opponent has castled RECENTLY.
    if castleRights(3, ~whiteMove + 3)  % The opponent castled K
        if whiteMove  % We're currently white. We're wondering if our piece can pass through black's has-castled.
            if isequal(newSquare, [3 7]) || isequal(newSquare,[3 8])
                lostKing = 2;
            end
        else  % We're black.
            if isequal(newSquare,[10 7])||isequal(newSquare,[10 8])
                lostKing = 2;
            end
        end
    else  % The opponent has castled Q.
        if whiteMove %We're currently white. We're wondering if our piece can pass through black's has-castled.
            if isequal(newSquare,[3 7])||isequal(newSquare,[3 6])
                lostKing = 2;
            end
        else  % We're black.
            if isequal(newSquare,[10 7])||isequal(newSquare,[10 6])
                lostKing = 2;
            end
        end
    end
end

% Let's use the value 2 to mean that it's a castle thru.
% It's tricky, but this needs to be handled separately by the transposition
% table. 
% We can have positions which are illegal, because the opponent castled
% through check. 
% But a TRANSPOSITION of that position may be perfectly legal, because the
% order of moves changed 


%% Update castling rights

castleRights(1:4,1:2) = castleRights(1:4,3:4);
% Now we have rights before this move; rights after this move.
% But rights AFTER this move may change later. Let's do this in the
% move-gen code.


%% Execute move

% Promotion, capture, and king taken

moveIdentifier = [currentSquare - 2 newSquare - 2 currentPiece];

if currentPosition(newSquare(1),newSquare(2))
    caProm = true;
    if abs(currentPosition(newSquare(1),newSquare(2))) == 10 %King is being taken
        lostKing = 1;
    end
end

currentPosition(currentSquare(1),currentSquare(2))= 0;
currentPosition(newSquare(1),newSquare(2)) = currentPiece;

%% Pack up

outputObj = struct;

outputObj.position = currentPosition;
outputObj.currentColor = -currentColor;
outputObj.castleRights = castleRights;

outputObj.zobristKey = zobristKey;
outputObj.positionHistory = positionHistory;
outputObj.gameOver = false;
outputObj.lostKing = lostKing;
outputObj.childLostKing = false;
outputObj.targetFile = 0;
outputObj.children = [];

outputObj.caProm = caProm;

outputObj.winningEval = int32(0);
outputObj.moveIdentifier = moveIdentifier;





end