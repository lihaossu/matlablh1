function snake_change
% Have the rubik snake go through one iteration in a presentation.
  
  h = getappdata(gcf,'mysnake');
  
  shapes = rubiksnake('shapes');
  
  ns=shapes{ uint8(rand(1,1)*length(shapes)) };
  
  rubiksnake(h,ns,'once');