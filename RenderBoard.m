function RenderBoard(currentPosition,boardTitle)


cla

N = 8;

dSqColor = .7;
lSqColor = .9;


colorRange = lSqColor - dSqColor;
f = (-1).^((1:N)' + (1:N));
f = (f + 1) * colorRange / 2;
f = f + dSqColor;
f(1:4,1:4);

pixel_size = 60;
f = repelem(f,pixel_size,pixel_size);
f = repmat(f,1,1,3);
h = imshow(f,'InitialMagnification','fit');

h.XData = [0.5 N+0.5];
h.YData = [0.5 N+0.5];
axis([0.5 N+0.5 0.5 N+0.5])
axis on
xticks(1:8); yticks(1:8);
xticklabels({'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h'})
yticklabels([8 7 6 5 4 3 2 1])

      
pieceConvert = [10 9812;9 9813;5 9814;3 9815;2 9816;1 9817;...
    -10 9818;-9 9819;-5 9820;-3 9821;-2 9822;-1 9823];


for ii = 3:10
    for jj = 3:10 
        pChar = char(pieceConvert(pieceConvert(:,1)==currentPosition(ii,jj),2));
        pcharh = text(jj - 2, ii - 2, pChar);
        pcharh.FontSize=30;
        pcharh.HorizontalAlignment = 'center';
    end
end

if exist('boardTitle','var')
    title(boardTitle)
end

drawnow

end
