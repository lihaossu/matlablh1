function mlpshowslide(viewer,page)
% Show in VIEWER a single presentation PAGE.
  
  set(viewer.Fig,'pointer','watch');
  drawnow;

  dm = getappdata(viewer.Fig,'deleteme');
  if ~isempty(dm)
    delete(dm);
  end
  setappdata(viewer.Fig,'deleteme',[]);
  
  set(viewer.Title,'string',notempty(page.Title));
  set(viewer.SubTitle,'string',notempty(page.SubTitle));
  
  setupText(viewer.Page, page.TextInterpreter, notempty(page.Page));

  eti = page.ExtraTextInterpreter;
  
  if strcmp(eti,'page')
    eti = page.TextInterpreter;
  end
  
  setupText(viewer.ExtraText, eti, notempty(page.ExtraText, 'Click to add text'));
  
  set(viewer.ExtraText,'visible','off');
  delete(get(viewer.Graphic,'children'));
  set(viewer.Graphic,'visible','off');
  delete(get(viewer.ScribeAxes,'children'));

  if isfield(page,'Demo') && ~isempty(page.Demo)
    set(viewer.DemoButton,'visible','on');
  else
    set(viewer.DemoButton,'visible','off');
  end
  
  try
    style = page.Style;
  catch
    style = [];
  end
  if isempty(style)
    style = 'Page';
  end

  et = page.ExtraTextColumn;
  
  switch style
   case 'Title'
    set(viewer.Fig,'toolbar','none');
    plotedit({'plotedittoolbar',viewer.Fig,'hide'});
    set(viewer.Page,'horizontalalign','center','pos',[.5 .5 0],'visible','on');
    set(viewer.SubTitle,'visible','on')
    adjustbackground(viewer.Background,'on');
   case 'Page'
    set(viewer.Fig,'toolbar','none');
    plotedit({'plotedittoolbar',viewer.Fig,'hide'});
    set(viewer.Page,'horizontalalign','left','pos',[.1 .5 0],'visible','on');
    set(viewer.SubTitle,'visible','off')
    positionPage(viewer, viewer.Page, et);
    adjustbackground(viewer.Background,'on');
   case 'Image'
    set(viewer.Fig,'toolbar','none');
    plotedit({'plotedittoolbar',viewer.Fig,'hide'});
    set(viewer.SubTitle,'visible','on')
    adjustbackground(viewer.Background,'off');
    set(viewer.Page,'visible','off');

    positionPage(viewer, viewer.Graphic, et);

    axes(viewer.Graphic);
    reset(viewer.Graphic);
    set(viewer.Graphic, 'visible','off','hittest','off');
    
    if isempty(page.PlotCommands)
      image;
      box on;
    else
      %disp(page.PlotCommands);
      try
        % Re-use PlotCommands field to contain the file name of the
        % image.
        [ rgb ] = imread([ viewer.presentationdir '/' page.PlotCommands]);
        image(rgb);
      catch
        if viewer.Editmode
          mlpeditgraphic(viewer,true);
        end
      end
    end
    axis('ij','off');
    daspect([1 1 1]);
    
    if viewer.Editmode
      set(viewer.EditGraphics,'string',page.PlotCommands);
      mlpeditgraphic(viewer);
    end
   case 'Graphic'
    set(viewer.Fig,'toolbar','none');
    plotedit({'plotedittoolbar',viewer.Fig,'hide'});
    set(viewer.SubTitle,'visible','on')
    adjustbackground(viewer.Background,'off');
    set(viewer.Page,'visible','off');

    positionPage(viewer, viewer.Graphic, et);
    
    axes(viewer.Graphic);
    reset(viewer.Graphic);
    set(viewer.Graphic, 'visible','off','hittest','off');
    
    if isempty(page.PlotCommands)
      newplot;
      box on;
    else
      % disp(page.PlotCommands);
      try
        p = path;
        addpath(viewer.presentationdir)
        eval(page.PlotCommands);
      catch
        if viewer.Editmode
          mlpeditgraphic(viewer,true);
        end
      end
      path(p);  % Restore the path.
    end

    if viewer.Editmode
      set(viewer.EditGraphics,'string',page.PlotCommands);
      mlpeditgraphic(viewer);
    end
   case 'Scribe'
    if viewer.Editmode
      set(viewer.Fig,'toolbar','figure');
      plotedit({'plotedittoolbar',viewer.Fig,'show'});
    end
    
    set(viewer.SubTitle,'visible','on')
    adjustbackground(viewer.Background,'off');
    set(viewer.Page,'visible','off');
    
    try
      s = page.ScribeStuff;
    catch
      s = [];
    end
    if ~isempty(s)
      struct2handle(s,viewer.ScribeAxes);
    
      %if viewer.Editmode
        %% COPIED FROM HGLOAD
        
        % run postdeserialize on any other figure children.
        % Currently this should include scribe layer,
        % legend and colorbar
        axlist = viewer.ScribeAxes;
        for k=1:length(axlist)
          ax = axlist(k);
          if isappdata(ax,'PostDeserializeFcn')
            feval(getappdata(ax,'PostDeserializeFcn'),ax,'load')
          elseif ismethod(handle(ax),'postdeserialize')
            try
              postdeserialize(handle(ax));
            end
          end
        end

      %end
    
    end
  end

  if viewer.Editmode
    set(viewer.PageIndexIndicator,'string',['Page: ' num2str(viewer.Index)]);
  end
  
  set(viewer.Fig,'pointer','arrow');

function out = notempty(str,blanktext)
% Make sure str is not empty.
  
  if (ischar(str) && isempty(str) ) || ...
        (iscell(str) &&  ischar(str{1}) && isempty(str{1}) ) || ...
        ~ischar(str) && ~iscell(str)
    if nargin ==2
      out = blanktext;
    else
      out = ' ';
    end
  else
    out = str;
  end
  
  if ischar(str)
    out = { out };
  end
  
function adjustbackground(bg, onoff)
% Turn the background BG ON or OFF.
  switch onoff
   case 'on'
    set(bg,'contentsvisible','on');
   case 'off'
    if getappdata(bg,'hidemeforgraphics')
      set(bg,'contentsvisible','off');
    end
  end

function setupText(to, interp, str)
  
  try

    if ischar(str)
      str = { str };
    end
    
    str = regexprep(str, ' +$', '');
  catch
    disp('Error deblanking string');
    str
  end

  filter = @char;
  
  try

    switch interp
     case 'wiki'
      filter = @mlpwiki;
      set(to,'interpreter', 'tex');
     otherwise
      set(to,'interpreter', interp);
    end
    
  catch
    set(to,'interpreter','tex');
  end

  setappdata(to,'filter',filter);
  
  set(to, 'string', filter(str))
  setappdata(to,'unfilteredstring',str);
  
function positionPage(viewer, handle, loc)
% Position in VIEWER, HANDLE and EXTRA on the current page at LOC.
%
% LOC value/behavior
% 'none' - handle takes up full space.
% 'left' - handle on right, extra on left.
% 'right' - extra on right, handle on left.
% 'top' - extra on top, handle on bottom.
% 'bottom' - handle on top, extra on bottom.
  
  if isempty(loc)
    loc = 'none';
  end

  lefttp = [.1 .45 0];
  righttp = [.5 .45 0];
  
  toptp = [.1 .7 0];
  bottomtp = [.1 .4 0];
  
  switch loc
   case 'none'
    switch get(handle,'type')
     case 'axes'
      set(handle, 'outerposition', viewer.graphicpos);
     case 'text'
      set(handle,'position',[.1 .45 0],...
                 'horizontalalign','left',...
                 'verticalalign','middle');
    end
   case 'left'
    switch get(handle,'type')
     case 'axes'
      p = viewer.graphicpos;
      gp = [ p(1)+(p(3)-p(1))/2 p(2) p(3)/2 p(4) ];
      set(handle, 'outerposition', gp);
     case 'text'
      set(handle,'position', righttp,...
                 'horizontalalign','left',...
                 'verticalalign','middle');
    end
    set(viewer.ExtraText,'position',lefttp,...
                      'horizontalalign','left',...
                      'verticalalign','middle',...
                      'visible','on');
   case 'right'
    switch get(handle,'type')
     case 'axes'
      p = viewer.graphicpos;
      gp = [ p(1) p(2) p(3)/2 p(4) ];
      set(handle, 'outerposition', gp);
     case 'text'
      set(handle,'position', lefttp,...
                 'horizontalalign','left',...
                 'verticalalign','middle');
    end
    set(viewer.ExtraText,'position',righttp,...
                      'horizontalalign','left',...
                      'verticalalign','middle',...
                      'visible','on');
   case 'top'
    switch get(handle,'type')
     case 'axes'
      p = viewer.graphicpos;
      gp = [ p(1) p(2)+.1 p(3) p(4)/2 ];
      set(handle, 'outerposition', gp);
     case 'text'
      set(handle,'position', bottomtp,...
                 'horizontalalign','left',...
                 'verticalalign','top');
    end
    set(viewer.ExtraText,'position',toptp,...
                      'horizontalalign','left',...
                      'verticalalign','top',...
                      'visible','on');
   case 'bottom'
    switch get(handle,'type')
     case 'axes'
      p = viewer.graphicpos;
      gp = [ p(1) p(2)+(p(4)-p(2))/2 p(3) p(4)/2 ];
      set(handle, 'outerposition', gp);
     case 'text'
      set(handle,'position', toptp,...
                 'horizontalalign','left',...
                 'verticalalign','top');
    end
    set(viewer.ExtraText,'position',bottomtp,...
                      'horizontalalign','left',...
                      'verticalalign','top',...
                      'visible','on');
  end