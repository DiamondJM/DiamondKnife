function dummyStruct = generateDummyArray

% 
% dummyStruct = struct('currentColor',{},...
%     'position',{},...
%     'caProm',{},...
%     'zobristKey',{},...
%     'moveIdentifier',{},...
%     'lostKing',{},...
%     'castleRights',{},...
%     'positionHistory',{},...
%     'gameOver',{},...
%     'targetFile',{},...
%     'children',{},...
%     'childLostKing',{},...
%     'winningEval',{});



dummyStruct = struct;

dummyStruct.position = zeros(12);
dummyStruct.currentColor = 0;
dummyStruct.castleRights = false(4);

dummyStruct.zobristKey = uint32(0);


positionHistory = uint32(0);
coder.varsize('positionHistory',[1 2]);
dummyStruct.positionHistory = positionHistory;

dummyStruct.gameOver = false;
dummyStruct.lostKing = 0;
dummyStruct.childLostKing = false;
dummyStruct.targetFile = 0;

dummyStruct.children = [];

dummyStruct.caProm = false;

dummyStruct.winningEval = int32(-999);
dummyStruct.moveIdentifier = zeros(1,5);






dummyStruct = repmat(dummyStruct,1,100);

end