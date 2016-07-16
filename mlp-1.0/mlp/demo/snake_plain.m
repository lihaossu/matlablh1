function snake_plain
% Create a rubiksnake in the current figure, and save the handle.
  
  h = rubiksnake(gcf);
  % axis on;
  % set(gca,'color',[.7 .7 .7]);
  % set(gca,'xtick',[],'ytick',[]);
  setappdata(gcf,'mysnake',h);