function mlpdoodle(name)
% MLPDOODLE - Edit a presentation
%   
% MLPDOODLE(NAME) - Edit a presentation with NAME.
%   This will create NAME.mat to store the presentation.
%   
% Edit A Presentation:
% 
%   Use the menu items or context menu to navigate or add slides.
% 
%   File
%     New      - Create a new slide after the current slide.
%     Delete   - Delete the current slide
%     Refresh  - Refresh this slide
%     
%     Save     - Force this slide to be saved (See navigation note)
%     Close    - Save and close
%     Dump Summary
%   
%   Edit
%     Set Style - Change the style of this slide
%       Title   - A title page.  Title & Subtitle.  Authors
%       Page    - A Page with text in the middle
%       Graphic - A page with MATLAB graphics in the middle
%       Image   - A page with one big image.
%       Scribe  - A page with scribe annotations.
%     Edit Graphics Code
%           - Edit code that contributes to a Graphic page style.
%     Edit Demo Code
%           - Edit code that goes behind a "Demo" button.
%     Inline Demo
%           - Specify that the "Demo" button is embedded in the
%             slide, or pops up a new window
%             
%   Navigate
%     When navigating, mlpdoodle will save the current presentation
%     before moving to the next slide.
%     
%     Next Slide  - Go to the next slide
%     Prev Slide  - Go to the previous slide
%     First Slide - Go to the first slide
%     Last Slide  - Go to the last slide
%     
%   Slide
%     This menu lets you select a specific page and jump to that
%     page.
%   
%   
% Edit A Slide:
% 
%   While a slide is active, you can edit the contents.  Any text
%   object with a box around it can be clicked on.  This will allow
%   you to edit that text.
%   
%   To make a bulleted list, you can type text like this:
%   
%   * First
%   * Second
%   ** Sub Bullet
%
%   View the mlp demo to learn more about the wiki/tex hybrid
%   syntax.
%
%   mlpf demo/mlp
%   
% Keybindings:
%   
%   SPACE     - Go to next slide
%   BACKSPACE - Go to previous slide
%   DELETE    - Delete the current slide.
% 

% Copyright (C) 2005 Eric Ludlam, The MathWorks Inc.

  if nargin == 0
    name = input('Type in name of presentation: ','s');
  end
  
  try
    p = load(name,'Presentation');
    presentation = upgrade(p.Presentation);
  catch
    presentation = [];
  end
  
  if isempty(presentation)
    presentation = newpage;
  end

  try
    ps = load(name,'PageStyle');
    pagestyle = upgradepagestyle(ps.PageStyle);
  catch
    pagestyle = [];
  end
  
  if isempty(pagestyle)
    pagestyle = newpagestyle;
  end
  
  viewer = mlp(presentation,pagestyle);

  setappdata(viewer.Fig,'presentationname',name);

  mlppresentationdir(viewer.Fig,name);

function presentation = newpage
% Create a new page.  Display it.

  presentation(1).Style = 'Title';
  presentation(1).Title = 'Click for title';
  presentation(1).SubTitle = 'Click for subtitle';
  presentation(1).Page = 'Click to add text';
  
  presentation = upgrade(presentation);
  
function presentation = upgrade(in)
% Upgrade a presentation

% Add new stuff here when new struct parts are added.
  
  presentation = in;
  
  if ~isfield(presentation,'ScribeStuff')
    presentation(1).ScribeStuff = [];
  end

  if ~isfield(presentation,'PlotCommands')
    presentation(1).PlotCommands = [];
  end

  if ~isfield(presentation,'Demo')
    presentation(1).Demo = {};
  end
  
  if ~isfield(presentation, 'InPlaceDemo')
    presentation(1).InPlaceDemo = false;
  end
  
  if ~isfield(presentation, 'ExtraText')
    presentation(1).ExtraText = '';
  end

  if ~isfield(presentation, 'ExtraTextColumn')
    presentation(1).ExtraTextColumn = 'none';
  end

  if ~isfield(presentation, 'TextInterpreter')
    presentation(1).TextInterpreter = 'wiki';
  end

  if ~isfield(presentation, 'ExtraTextInterpreter')
    presentation(1).ExtraTextInterpreter = 'wiki';
  end

  
function pagestyle = newpagestyle()
% Create a new page style.
  
  pagestyle.backgroundfcn = 'blank';

  pagestyle = upgradepagestyle(pagestyle);
  
function pagestyle = upgradepagestyle(pagestyle)
% Upgrade a new page style
  
  pagestyle.editmode = 'on';
  