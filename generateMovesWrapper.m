function currentObj = generateMovesWrapper(currentObj,zKeys)

tempStruct = diamondKnife_mex('generateMoves',currentObj, zKeys);

structEvals = nan(size(tempStruct));
for ii = 1:length(tempStruct)
    if tempStruct(ii).winningEval == -999
        break
    else
        tempStruct(ii).winningEval = diamondKnife_mex('positionEvaluator',tempStruct(ii).position,tempStruct(ii).castleRights,tempStruct(ii).currentColor);
        % tempStruct(ii).winningEval = positionEvaluator(tempStruct(ii).position,tempStruct(ii).castleRights,tempStruct(ii).currentColor);
        structEvals(ii) = tempStruct(ii).winningEval;
    end
end
[structEvals,sortInds] = sort(structEvals,'ascend');
sortInds = sortInds(~isnan(structEvals));

currentObj.children = tempStruct(sortInds);