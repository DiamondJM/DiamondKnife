function chessObj = prepareFirstNode(zKeys)

startPosition = ones(12) * 99;
startPosition(3:10,3:10) = zeros(8,8);

%%%%%%
% Default
%%%%%%
startPosition(9,3:10) = ones(1,8);
startPosition(10,[3 10]) = 5;
startPosition(10,[4 9]) = 2;
startPosition(10,[5 8]) = 3;
startPosition(10,6) = 9;
startPosition(10,7) = 10;
startPosition([4 3],3:10) = - startPosition([9 10],3:10);

%%%%
% Promotion test
%%%%
%     startPosition(3,4) = -10;
%     startPosition(5,3) = 10;
%     startPosition(5,4) = 1;

%%%%
% Mating test
%%%%
%     startPosition(7,9) = -10;
%     startPosition(3,3) = 10;
%     startPosition(3,8) = 5;
%     startPosition(10,7) = 9;
%     startPosition(6,3) = -1;
%     startPosition(6,4) = -1;


%%%%
% Stalemate test
%%%%
%     startPosition(3,4) = 9;
%     startPosition(6,4) = 3;
%     startPosition(7,4) = 3;
%     startPosition(9,4) = 1;
%     startPosition(9,5) = 10;
%     startPosition(6,6) = -10;
%     startPosition(7,9) = 9;
%     startPosition(9,9) = 1;
%     startPosition(9,10) = 1;
%     startPosition(10,10) = 5;


%%%%
% Drawing test
%%%%%
%     startPosition(3,4) = 9;
%     startPosition(5,4) = 9;
%     startPosition(4,10) = -10;
%     startPosition(10,7) = -9;
%     startPosition(10,9) = 10;
%     startPosition(9,9) = 1;

%%%%
% Simplify test
%%%%%
%     startPosition(9,3:10) = ones(1,8);
%     startPosition(4,3:10) = - ones(1,8);
%     startPosition([4 9],[6 7]) = 0;
%
%     startPosition(3,[5 8]) = -5;
%     startPosition(10,[6 8]) = 5;
%     % startPosition(10,3) = 9;
%     startPosition(3,3) = -9;
%     startPosition(3,10) = -10;
%     startPosition(10,10) = 10;
%
chessObj = struct;

chessObj.position = startPosition;
chessObj.currentColor = 1;
chessObj.castleRights = [true(2,4);false(2,4)];

chessObj.zobristKey = keyGen(chessObj.position,zKeys);
chessObj.positionHistory = chessObj.zobristKey;
chessObj.gameOver = false;
chessObj.lostKing = 0;
chessObj.childLostKing = false;
chessObj.targetFile = 0;

chessObj.children = [];
% chessObj.childLostKing = false;
chessObj.caProm = false;

chessObj.winningEval = int32(0);
chessObj.moveIdentifier = zeros(1,5);





end