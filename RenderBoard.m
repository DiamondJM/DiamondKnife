function RenderBoard(myposition)


cla

N = 8;

dark_square_color = .7;
light_square_color = .9;


color_range = light_square_color - dark_square_color;
f = (-1).^((1:N)' + (1:N));
f = (f + 1) * color_range / 2;
f = f + dark_square_color;
f(1:4,1:4);

pixel_size = 60;
f = repelem(f,pixel_size,pixel_size);
f = repmat(f,1,1,3);
h = imshow(f,'InitialMagnification','fit');

h.XData = [0.5 N+0.5];
h.YData = [0.5 N+0.5];
axis([0.5 N+0.5 0.5 N+0.5])
axis on
xticklabels({'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h'})
yticklabels([8 7 6 5 4 3 2 1])

      
piececonvert=[10 9812;9 9813;5 9814;3 9815;2 9816;1 9817;...
    -10 9818;-9 9819;-5 9820;-3 9821;-2 9822;-1 9823];


for i=3:10
    for j=3:10 
        pchar=char(piececonvert(piececonvert(:,1)==myposition(i,j),2));
        pcharh=text(j-2,i-2,pchar);
        pcharh.FontSize=30;
        pcharh.HorizontalAlignment='center';
    end
end

drawnow

end
