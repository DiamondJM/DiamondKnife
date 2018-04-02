function isThisRepeat = isRepeat(positionHistory)

isThisRepeat = sum(positionHistory(1:end-1) == positionHistory(end));
  
end