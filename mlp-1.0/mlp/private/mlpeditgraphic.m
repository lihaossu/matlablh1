function mlpeditgraphic(viewer, now)
% Convert the graphic location in MLP to be editable.
  
  set(viewer.Graphic,'buttondownfcn',{@editGraphicCommands viewer.Fig});

  if nargin == 2 && now
    editGraphicCommands([],[],viewer.Fig);
  end
  
function editGraphicCommands(src, evt, fig)
% Let the user edit the commands for making graphics
  
  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  
  if isempty(get(viewer.EditGraphics,'string'))
    set(viewer.EditGraphics,'string','Write Code Here');
  end
    
  set(viewer.EditGraphics,'edit','on');

  if true
    setappdata(viewer.EditGraphics,'EnableConversions',false);
    
    if isempty(getappdata(viewer.EditGraphics,'EditListener'))
      % We want the editgraphic text object to auto-refresh a page
      % after we type stuff in.
      th = handle(viewer.EditGraphics);
      tl = handle.listener(th,findprop(th,'String'),...
                           'PropertyPostSet',...
                           {@GraphicsChanged viewer.EditGraphics});
      
      setappdata(viewer.EditGraphics,'EditListener',tl);
    
    end
    
    setappdata(viewer.EditGraphics,'EnableConversions',true);
    
  end

function GraphicsChanged(src, event, h)
  
  event; %#ok
  src; %#ok

  if getappdata(h,'EnableConversions')

    disp('graphic text changed.');
    
    fig = ancestor(h,'figure');
    viewer = get(fig,'userdata');
    
    mlp('save',viewer);
    viewer = get(fig,'userdata');
    mlp('show',viewer);

    setappdata(h,'EnableConversions',false);
  end
    
  
  