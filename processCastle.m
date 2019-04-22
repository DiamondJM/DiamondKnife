function  outputObj = processCastle(currentObj,kingSide,zKeys)
%% Unpack


currentColor = currentObj.currentColor;
if currentColor == 1; whiteMove = true;
else; whiteMove = false;
end

currentPosition = currentObj.position;
zobristKey = currentObj.zobristKey;

castleRights = currentObj.castleRights;
positionHistory = currentObj.positionHistory;


%% Update castling rights

castleRights(1:4,1:2) = castleRights(1:4,3:4);
if whiteMove
    castleRights([1 2],4) = 0;
    if kingSide; castleRights(3,4) = 1;
    else; castleRights(4,4) = 1;
    end
else
    castleRights([1 2],3) = 0;
    if kingSide; castleRights(3,3) = 1;
    else; castleRights(4,3) = 1;
    end
end


%% Zobrist key

pieceConverter = [1 1; 2 2; 3 3; 5 4; 9 5; 10 6; -1 7; -2 8; -3 9; -5 10; -9 11; -10 12];

% Xor out king
if whiteMove
    currentSquare = [10 7];
    if kingSide; newSquare = [10 9];
    else; newSquare = [10 5];
    end
    currentPiece = 10;
    
else; currentSquare = [3 7];
    if kingSide; newSquare = [3 9];
    else; newSquare = [3 5];
    end
    currentPiece = -10;
end
moveIdentifier = [currentSquare - 2 newSquare - 2 currentPiece];

squareInd = sub2ind([8 8],currentSquare(1) - 2,currentSquare(2) - 2);
pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
pieceInd = pieceInd(1);
zobInd = sub2ind([64 12], squareInd, pieceInd);
zobInd = zKeys(zobInd);
zobristKey = bitxor(zobristKey, zobInd);

% Xor in king
squareInd = sub2ind([8 8],newSquare(1) - 2, newSquare(2) - 2);
% pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
zobInd = sub2ind([64 12], squareInd, pieceInd);
zobInd = zKeys(zobInd);
zobristKey = bitxor(zobristKey, zobInd);


% Xor out rook
if whiteMove
    if kingSide; currentSquare = [10 10]; newSquare = [10 8];
    else; currentSquare = [10 3]; newSquare = [10 6];
    end
    currentPiece = 5;
else
    if kingSide; currentSquare = [3 10]; newSquare = [3 8];
    else; currentSquare = [3 3]; newSquare = [3 6];
    end
    currentPiece = -5;
end
squareInd = sub2ind([8 8],currentSquare(1) - 2,currentSquare(2) - 2);
pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
pieceInd = pieceInd(1);
zobInd = sub2ind([64 12], squareInd, pieceInd);
zobInd = zKeys(zobInd);
zobristKey = bitxor(zobristKey, zobInd);

% Xor in king
squareInd = sub2ind([8 8],newSquare(1) - 2, newSquare(2) - 2);
% pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
zobInd = sub2ind([64 12], squareInd, pieceInd);
zobInd = zKeys(zobInd);
zobristKey = bitxor(zobristKey, zobInd);


% Factor in castling rights
castleChange = xor(castleRights(1:2,1:2),castleRights(1:2,3:4));
castleChangeInds = find(castleChange)';
for ii = 1:length(castleChangeInds)
    zobristKey = bitxor(zobristKey, zKeys(769 + castleChangeInds(ii)));
end



%% Execute move

if whiteMove
    if kingSide; currentPosition(10,7:10) = [0 5 10 0];
    else; currentPosition(10,3:7) = [0 0 10 5 0];
    end
else
    if kingSide; currentPosition(3,7:10) = -[0 5 10 0];
    else; currentPosition(3,3:7) = -[0 0 10 5 0];
    end
end

%% Pack up

outputObj = struct;

outputObj.position = currentPosition;
outputObj.currentColor = -currentColor;
outputObj.castleRights = castleRights;
outputObj.zobristKey = zobristKey;
outputObj.positionHistory = positionHistory;
outputObj.gameOver = false;
outputObj.lostKing = 0;
outputObj.childLostKing = false;
outputObj.targetFile = 0;
outputObj.children = [];

outputObj.caProm = false;

outputObj.winningEval = int32(0);
outputObj.moveIdentifier = moveIdentifier;









end