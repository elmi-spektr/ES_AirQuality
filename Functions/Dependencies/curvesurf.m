function [h,X,Y,C] = curvesurf(X1,Y1,X2,Y2,C,EC)
% Notes: 
% for compatibility with the Painters renderer, the 

if length(unique([length(X1),length(X2),length(X2),length(X2)]))~=1 
  error('Lengths of all Vectors have to agree!');
end
N = length(X1);

Renderer = get(gcf,'Renderer');
SC = size(horizontal(C));
if ~exist('EC','var') EC = C; end
switch lower(Renderer)
  case {'painters','none'}; % Do not use RGB color, just one color
    if SC ~= [1,3] error('In Painters mode, only one color can be given...');  end
  case 'opengl'; % Can use RGB (but crappy PDF output)
    if SC == [1,3]
      C = horizontal(C); C = repmat(C,(N-1)*2,1); tmpC(1,[1:size(C,1)],[1:size(C,2)]) = C; C = tmpC;
    end
  otherwise error(['Renderer ',Renderer,' not yet implemented!']);
end

X = zeros(3,(N-1)*2); Y = X; Z = X;
for i=1:N-1
  X(1:3,2*i-1) = [X1(i), X1(i+1), X2(i)];
  Y(1:3,2*i-1) = [Y1(i), Y1(i+1), Y2(i)];
  X(1:3,2*i) = [X2(i), X1(i+1), X2(i+1)];
  Y(1:3,2*i) = [Y2(i), Y1(i+1), Y2(i+1)];
end

h = patch(X,Y,Z,C,'EdgeColor',EC);
switch Renderer
  case 'painters';
  case 'opengl'; shading flat; 
end
