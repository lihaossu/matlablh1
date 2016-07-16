function mlpf(filename)
% MLPF - View a MATLAB presentation
% MLPF(FILENAME) - View presentation FILENAME
%   FILENAME can be the name of a mat file that was
%   created with MLPDOODLE.
%   
% Keybindings:
% 
%   SPACE, n, f, Left Mouse - Next slide
%   BACKSPACE, b, p, Right Mouse - Previous slide
%   
%   g - Go into auto-next mode.
%   s - Stop auto-next mode
%   

% Copyright (C) 2005 Eric Ludlam, The MathWorks Inc.

  p = load(filename,'Presentation');
  presentation = p.Presentation;
  
  ps = load(filename,'PageStyle');
  pagestyle = ps.PageStyle;
  pagestyle.editmode = 'off';
  
  mlp(presentation, pagestyle);
  mlppresentationdir(gcf,filename);
