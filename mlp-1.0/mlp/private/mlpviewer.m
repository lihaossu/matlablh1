function viewer = mlpviewer(pagestyle)
% Matlab Presentation Figure window constructor
  
  if strcmp(pagestyle.editmode,'on')
    editmode = true;
  else
    editmode = false;
  end
  
  ogld = opengl('data');
  vis = ogld.Visual;

  if ispc
    visprop = 'wvisual';
  else
    visprop = 'xvisual';
  end
  
  viewer.Fig = figure('color','white','toolbar','none',...
                      'numbertitle','off',...
                      visprop, vis);
  
  set(viewer.Fig,'menubar','none')
  
  drawnow;
  jf = get(viewer.Fig,'javaframe'); % undocumented property
  frame = javax.swing.SwingUtilities.getWindowAncestor(jf.getAxisComponent);
  frame.setExtendedState(frame.MAXIMIZED_BOTH)

  viewer.PageStyle = pagestyle;

  % Manage edit mode type stuff
  if editmode
    tec = [ .3 .3 .3 ];
  else
    tec = 'none';
  end

  viewer.Editmode = editmode;
  
  % set up the Fade Plane and Text Stuff
  viewer.TextAxes = axes('position',[0 0 1 1],'visible', 'off',...
                         'xlim',[0 1],'ylim',[0 1],'zlim',[-2 2],...
                         'hittest','off');
  viewer.FadePlane = surface('xdata',[0 1],'ydata',[0 1],'zdata',[-1 -1; -1 -1],...
                             'facecolor','w','facealpha',.8,'edgecolor','none',...
                             'hittest','off');
  if editmode
    viewer.PageIndexIndicator = text(1,1,'Page: 1','edgecolor','none',...
                                     'verticalalign','top',...
                                     'horizontalalign','right');
  end

  % Create the various visible parts of the presentation.
  viewer.Title = text('parent',viewer.TextAxes,...
                      'unit','data','position',[.5 .99 0],...
                      'horizontalalign','center',...
                      'verticalalign','top',...
                      'fontunit','norm',...
                      'fontweight','bold',...
                      'fontsize',.09,...
                      'edgecolor',tec);
  viewer.SubTitle = text('parent',viewer.TextAxes,...
                         'unit','data','position',[.5 .88 0],...
                         'horizontalalign','center',...
                         'verticalalign','top',...
                         'fontweight','bold',...
                         'fontunit','norm',...
                         'fontsize',.05,...
                         'edgecolor',tec);
  viewer.Page = text('parent',viewer.TextAxes,...
                     'unit','data','position',[.1 .5 0],...
                     'horizontalalign','left',...
                     'verticalalign','middle',...
                     'fontunit','norm',...
                     'fontsize',.04,...
                     'edgecolor',tec);
  
  viewer.ExtraText = text('parent',viewer.TextAxes,...
                          'unit','data','position',[.1 .5 0],...
                          'horizontalalign','left',...
                          'verticalalign','middle',...
                          'fontunit','norm',...
                          'fontsize',.04,...
                          'edgecolor',tec,...
                          'linestyle','--');
  
  viewer.graphicpos = [.05 .05 .9 .75];
  
  viewer.Graphic = axes('outerposition', viewer.graphicpos, 'visible','off','hittest','off');

  plotedit('on');
  viewer.ScribeAxes = getappdata(gcf,'Scribe_ScribeOverlay');
  plotedit('off');

  viewer.DemoButton = uicontrol('style','push',...
                                'string','Run Demo',...
                                'callback',{@runDemo viewer.Fig},...
                                'visible','off');
  

  viewer = changebackground(viewer);
  
  if editmode
    set(viewer.Fig,'windowbuttondownfcn', @buttondownedit);
    set(viewer.Fig,'keypressfcn', @keypressedit);
      
    viewer.EditGraphics = text('parent',viewer.TextAxes,...
                               'pos',[.05 .75 0],...
                               'fontsize',14,...
                               'string','',...
                               'horizontalalign','left',...
                               'verticalalign','top',...
                               'visible','off',...
                               'edgecolor',tec);
    
    viewer.figctxt = uicontextmenu('callback', {@ctxtCallback viewer.Fig});
    uimenu(viewer.figctxt,'label','New Slide','callback',{ @newslide viewer.Fig});
    uimenu(viewer.figctxt,'label','Delete Slide','callback',{ @deleteslide viewer.Fig});
    uimenu(viewer.figctxt,'label','Reshow Slide','callback',{ @reshow viewer.Fig});
    stylem = uimenu(viewer.figctxt,'label','Set Style','callback',{ @specifyStyle viewer.Fig});
    uimenu(stylem,'label','Title','callback',   { @setStyle viewer.Fig })
    uimenu(stylem,'label','Page','callback',    { @setStyle viewer.Fig })
    uimenu(stylem,'label','Graphic','callback', { @setStyle viewer.Fig })
    uimenu(stylem,'label','Image','callback', { @setStyle viewer.Fig })
    uimenu(stylem,'label','Scribe','callback', { @setStyle viewer.Fig })
    
    uimenu(viewer.figctxt,'label','Next Slide',  'separator','on','callback',{ @nextslide viewer.Fig});
    uimenu(viewer.figctxt,'label','Prev Slide',  'callback',{ @prevslide viewer.Fig});
    uimenu(viewer.figctxt,'label','First Slide',  'separator','on','callback',{ @firstslide viewer.Fig});
    uimenu(viewer.figctxt,'label','Last Slide',  'callback',{ @lastslide viewer.Fig});
    uimenu(viewer.figctxt,'label','Dump Summary',  'callback',{ @dump viewer.Fig});
    uimenu(viewer.figctxt,'label','Edit Graphic Code','callback',{ @mlpeditgraphiclocal viewer.Fig});
    uimenu(viewer.figctxt,'label','Edit Demo Code','callback',{ @editDemo viewer.Fig});
    viewer.InlineToggle = uimenu(viewer.figctxt,'label','Inline Demo','callback',{ @editDemoInline viewer.Fig});

    % Now replace the main menu:
    set(gcf,'menubar','none');
    viewer.figfile = uimenu('label','File');
    uimenu(viewer.figfile,'label','New Slide','callback',{ @newslide viewer.Fig});
    uimenu(viewer.figfile,'label','Delete Slide','callback',{ @deleteslide viewer.Fig});
    uimenu(viewer.figfile,'label','Refresh','callback',{ @reshow viewer.Fig});
    uimenu(viewer.figfile,'label','Save', 'separator','on','callback',{ @save viewer.Fig});
    uimenu(viewer.figfile,'label','Close','callback',{ @closefig viewer.Fig});
    uimenu(viewer.figfile,'label','Dump Summary',  'callback',{ @dump viewer.Fig});

    viewer.figedit = uimenu('label','Edit','callback', {@editCallback viewer.Fig});
    uimenu(viewer.figedit,'label','Graphic Code','callback',{ @mlpeditgraphiclocal viewer.Fig});
    uimenu(viewer.figedit,'label','Demo Code','callback',{ @editDemo viewer.Fig});
    viewer.InlineToggle(2) = uimenu(viewer.figedit,'label','Inline Demo','callback',{ @editDemoInline viewer.Fig});
    
    viewer.figfmt = uimenu('label','Format','callback', {@editCallback viewer.Fig});
    styleb = uimenu(viewer.figfmt,'label','Background Style', 'callback',{@backgroundCheck viewer.Fig});
    uimenu(styleb,'label','blank','callback',    { @specifyBackground viewer.Fig });
    uimenu(styleb,'label','bluebars','callback', { @specifyBackground viewer.Fig });
    uimenu(styleb,'label','halfframe','callback',{ @specifyBackground viewer.Fig });
    uimenu(styleb,'label','bluefade','callback', { @specifyBackground viewer.Fig });
    uimenu(styleb,'label','logo','callback',     { @specifyBackground viewer.Fig });

    stylem = uimenu(viewer.figfmt,'label','Page Style','callback',{ @specifyStyle viewer.Fig});
    uimenu(stylem,'label','Title','callback',   { @setStyle viewer.Fig })
    uimenu(stylem,'label','Page','callback',    { @setStyle viewer.Fig })
    uimenu(stylem,'label','Graphic','callback', { @setStyle viewer.Fig })
    uimenu(stylem,'label','Image','callback',   { @setStyle viewer.Fig })
    uimenu(stylem,'label','Scribe','callback',  { @setStyle viewer.Fig })

    textinterp = uimenu(viewer.figfmt,'label','Page Interpreter','callback',{ @specifyTextInterp viewer.Fig});
    uimenu(textinterp,'label','none','callback',  { @setTextInterp viewer.Fig })
    uimenu(textinterp,'label','wiki','callback',  { @setTextInterp viewer.Fig })
    uimenu(textinterp,'label','tex','callback',  { @setTextInterp viewer.Fig })
    uimenu(textinterp,'label','latex','callback',  { @setTextInterp viewer.Fig })
    
    extext = uimenu(viewer.figfmt,'label','Extra Text Column','callback',{ @specifyExtraText viewer.Fig});
    uimenu(extext,'label','none','callback',  { @setExtraText viewer.Fig })
    uimenu(extext,'label','right','callback', { @setExtraText viewer.Fig })
    uimenu(extext,'label','left','callback',  { @setExtraText viewer.Fig })
    uimenu(extext,'label','bottom','callback',{ @setExtraText viewer.Fig })
    uimenu(extext,'label','top','callback',   { @setExtraText viewer.Fig })

    etextinterp = uimenu(viewer.figfmt,'label','Extra Text Interpreter','callback',{ @specifyETextInterp viewer.Fig});
    uimenu(etextinterp,'label','page','callback',  { @setETextInterp viewer.Fig })
    uimenu(etextinterp,'label','none','callback',  { @setETextInterp viewer.Fig })
    uimenu(etextinterp,'label','wiki','callback',  { @setETextInterp viewer.Fig })
    uimenu(etextinterp,'label','tex','callback',  { @setETextInterp viewer.Fig })
    uimenu(etextinterp,'label','latex','callback',  { @setETextInterp viewer.Fig })
    
    
    viewer.fignav = uimenu('label','Navigate');
    uimenu(viewer.fignav,'label','Next Slide','callback',{ @nextslide viewer.Fig});
    uimenu(viewer.fignav,'label','Prev Slide',  'callback',{ @prevslide viewer.Fig});
    uimenu(viewer.fignav,'label','First Slide',  'separator','on','callback',{ @firstslide viewer.Fig});
    uimenu(viewer.fignav,'label','Last Slide',  'callback',{ @lastslide viewer.Fig});
    
    viewer.figslide = uimenu('label','Slide','callback',{ @slidelister viewer.Fig});
    
    viewer.fighelp = uimenu('label','Help');
    uimenu(viewer.fighelp,'label','Presentation Editor','callback','doc mlpdoodle');
    uimenu(viewer.fighelp,'label','Presentation Viewer','callback','doc mlpf');
    
    
  else
    set(viewer.Fig,'windowbuttondownfcn', {@buttondown viewer.Fig});
    set(viewer.Fig,'keypressfcn', {@keypress viewer.Fig});
  end

  set(viewer.Fig,'userdata',viewer);

function closefig(src,evt,fig)
  
  src; %#ok
  % viewer = get(fig,'userdata');

  save(src,evt,fig);
  close(fig);
  
function editCallback(src,evt,fig)

  evt;  %#ok
  ctxtCallback(src,fig)
  
function ctxtCallback(src, evt)

  src; %#ok
  fig = evt;
  viewer = get(fig,'userdata');

  p = viewer.Presentation;
  i = viewer.Index;

  onoff = p(i).InPlaceDemo;
  
  if onoff
    set(viewer.InlineToggle,'checked','on');
  else
    set(viewer.InlineToggle,'checked','off');
  end

function buttondown(src, evt, fig)

  evt;  %#ok
  st = get(src,'selectiontype');
  viewer = get(fig,'userdata');
  mlp('stop',viewer);
  
  switch st
   case 'normal'
    nextslide([],[],src);
   case 'alt'
    prevslide([],[],src);
  end
  
    
function keypress(src, evt, fig)

  viewer = get(fig,'userdata');

  switch (evt.Key)
   case 'space'
    nextslide([],[],src);
   case 'n'
    nextslide([],[],src);
   case 'f'
    nextslide([],[],src);
   case 'backspace'
    prevslide([],[],src);
   case 'b'
    prevslide([],[],src);
   case 'p'
    prevslide([],[],src);
   case 'g'
    mlp('go',viewer);
   case 's'
    mlp('stop',viewer);
   otherwise
  end

function buttondownedit(src, evt)

  evt;  %#ok

  viewer = get(src,'userdata');
  
  st = get(src,'selectiontype');
  
  h = hittest(viewer.Fig);
  
  if isempty(h) || h == viewer.Fig
    % Basic stuff about the figure
    
    switch st
     case 'normal'
      % mlp('next',viewer);
     case 'alt'
      ctxtCallback(viewer.figctxt, viewer.Fig);
      set(viewer.figctxt,'position',get(viewer.Fig,'currentpoint'),'visible','on')
    end
  else
    % Some sort of edit on one of our objects.

    switch get(h,'type')
     case 'text'
      mlptextedit(h);
      % set(h,'edit','on');
    end
    
  end

function keypressedit(src, evt)

  viewer = get(src,'userdata');

  switch (evt.Key)
   case 'space'
    nextslide([],[],src);
   case 'backspace'
    prevslide([],[],src);
   case 'delete'
    response = questdlg('Delete Slide?');
    if strcmp(response,'Yes')
      deleteslide([],[],src);     
    end
   case 'n'
    if ~isempty(evt.Modifier) && strcmp(evt.Modifier{1}, 'control' )
      mlp('new',viewer);
    end
  end
    
function nextslide(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('next',viewer);

function prevslide(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('prev',viewer);

function firstslide(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('first',viewer);

function lastslide(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('last',viewer);

function deleteslide(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('delete',viewer);

function mlpeditgraphiclocal(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  mlpeditgraphic(viewer, true);
  
  
  
function save(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('save',viewer);  
  
function reshow(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('save',viewer);
  viewer = get(fig,'userdata');
  mlp('show',viewer);
  
function newslide(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('new',viewer);

function specifyStyle(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  p = viewer.Presentation;
  i = viewer.Index;
  style = p(i).Style;
  
  chil = get(src,'children');
  for idx = 1:length(chil)
    pgs = get(chil(idx),'label');
    if strcmp(pgs,style)
      set(chil(idx),'checked','on');
    else
      set(chil(idx),'checked','off');
    end
  end

function setStyle(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  mlp('save',viewer);
  viewer = get(fig,'userdata');
  
  p = viewer.Presentation;
  i = viewer.Index;
  
  p(i).Style = get(src,'label');
  viewer.Presentation = p;
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);

function specifyExtraText(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  p = viewer.Presentation;
  i = viewer.Index;
  style = p(i).ExtraTextColumn;
  
  chil = get(src,'children');
  for idx = 1:length(chil)
    pgs = get(chil(idx),'label');
    if strcmp(pgs,style)
      set(chil(idx),'checked','on');
    else
      set(chil(idx),'checked','off');
    end
  end

function setExtraText(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  mlp('save',viewer);
  viewer = get(fig,'userdata');
  
  p = viewer.Presentation;
  i = viewer.Index;
  
  s = p(i).Style;
  
  if strcmp(s,'Title') || strcmp(s,'Scribe')
    warndlg({'Extra Text does not apply to page of type' s});
  end
  
  p(i).ExtraTextColumn = get(src,'label');
  viewer.Presentation = p;
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);


function specifyTextInterp(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  p = viewer.Presentation;
  i = viewer.Index;
  style = p(i).TextInterpreter;
  
  chil = get(src,'children');
  for idx = 1:length(chil)
    pgs = get(chil(idx),'label');
    if strcmp(pgs,style)
      set(chil(idx),'checked','on');
    else
      set(chil(idx),'checked','off');
    end
  end

function setTextInterp(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  mlp('save',viewer);
  viewer = get(fig,'userdata');
  
  p = viewer.Presentation;
  i = viewer.Index;
  
  p(i).TextInterpreter = get(src,'label');
  viewer.Presentation = p;
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);

function specifyETextInterp(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  p = viewer.Presentation;
  i = viewer.Index;
  style = p(i).ExtraTextInterpreter;
  
  chil = get(src,'children');
  for idx = 1:length(chil)
    pgs = get(chil(idx),'label');
    if strcmp(pgs,style)
      set(chil(idx),'checked','on');
    else
      set(chil(idx),'checked','off');
    end
  end

function setETextInterp(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  mlp('save',viewer);
  viewer = get(fig,'userdata');
  
  p = viewer.Presentation;
  i = viewer.Index;
  
  p(i).ExtraTextInterpreter = get(src,'label');
  viewer.Presentation = p;
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);
  

function backgroundCheck(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');
  fcn = viewer.PageStyle.backgroundfcn;
  
  chil = get(src,'children');
  for idx = 1:length(chil)
    menubg = get(chil(idx),'label');
    if strcmp(menubg,fcn)
      set(chil(idx),'checked','on');
    else
      set(chil(idx),'checked','off');
    end
  end

function specifyBackground(src, evt, fig)
  
  src; %#ok
  evt; %#ok

  viewer = get(fig,'userdata');
  mlp('save',viewer);
  viewer = get(fig,'userdata');
  
  bg = get(src,'label');
  if strcmp(bg,'default (logo)')
    bg = 'default';
  end
  
  viewer.PageStyle.backgroundfcn = bg;
  
  viewer = changebackground(viewer);
  
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);
  
function runDemo(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp('rundemo',viewer);
  
function editDemo(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  p = viewer.Presentation;
  i = viewer.Index;
  demo = p(i).Demo;
  
  if ~iscell(demo) || isempty(demo)
    demo = { '' };
  end
  
  mlp('save',viewer);

  p(i).Demo = inputdlg('Enter code to run for a demo.','Demo Input',1,demo);
  
  viewer.Presentation = p;
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);

  function editDemoInline(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  p = viewer.Presentation;
  i = viewer.Index;
  demo = p(i).InPlaceDemo;
  
  if islogical(demo)
    if demo
      p(i).InPlaceDemo = false;
    else
      p(i).InPlaceDemo = true;
    end
  else
    p(i).InPlaceDemo = true;
  end  
    
  viewer.Presentation = p;
  set(fig,'userdata',viewer);
  mlp('show',viewer);
  mlp('save',viewer);

function slidelister(src,evt,fig)

  menu = src; %#ok
  evt;  %#ok

  delete(get(menu,'children'));
  
  viewer = get(fig,'userdata');
  p = viewer.Presentation;

  for i = 1:length(p)
    labelstr = p(i).Title;
    if iscell(labelstr)
      labelstr = labelstr{1};
    end
    
    uimenu(menu,'label',[num2str(i) ') ' labelstr],...
           'callback',{@jumpto viewer.Fig i});
  end
  
function jumpto(src,evt,fig,idx)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  mlp(idx,viewer);
  
function dump(src, evt, fig)

  src; %#ok
  evt;  %#ok

  viewer = get(fig,'userdata');

  p = viewer.Presentation;
  disp('---------------');
  for i = 1:length(p)
    
    t = p(i).Title;
    if iscell(t)
      t = t{1};
    end
    
    disp([num2str(i) ') ' t]);
  end

function viewer = changebackground(viewer)
  
  if isfield(viewer,'Background')
    delete(viewer.Background);
  end
  
  % Reset various things
  set(viewer.Title,'color','black','backgroundcolor','none');
  set(viewer.SubTitle,'color','black','backgroundcolor','none');
  set(viewer.Page,'color','black','backgroundcolor','none');
  try
    set(viewer.PageIndexIndicator,'color','black','backgroundcolor','none');
  end
  
  % Decide what to do.
  switch viewer.PageStyle.backgroundfcn
   case 'logo'
    viewer.Background = addbackground;
   case 'bluebars'
    viewer.Background = addbluebarbackground;
    set(viewer.Title,'color','white','backgroundcolor','blue');
    set(viewer.SubTitle,'color','white','backgroundcolor','blue');
    try
      set(viewer.PageIndexIndicator,'color','white', 'backgroundcolor','blue');
    end
   case 'halfframe'
    viewer.Background = addhalfframebackground;
   case 'bluefade'
    viewer.Background = addbluedriftbackground;
   otherwise % Same as the string 'blank'
    viewer.Background = addblankbackground;
  end
  
  % Force the background into the background
  chil = get(gcf,'children');
  
  notme = chil(chil ~= viewer.Background);
  
  set(gcf,'children', [notme ; viewer.Background]);
  
  if getappdata(viewer.Background,'needfade')
    set(viewer.FadePlane,'visible','on')
  else
    set(viewer.FadePlane,'visible','off')
  end
  
function h = addbackground
% Put MATLAB Logo in the background
  
  L = 40*membrane(1,25);

  h = axes('CameraPosition', [-193.4013 -265.1546  220.4819],...
           'CameraTarget',[26 26 10], ...
           'CameraUpVector',[0 0 1], ...
           'CameraViewAngle',12, ...
           'DataAspectRatio', [1 1 .9],...
           'Position',[0 0 1 1], ...
           'Visible','off', ...
           'XLim',[1 51], ...
           'YLim',[1 51], ...
           'ZLim',[-13 40],...
           'hittest','off');
  setappdata(h,'needfade',true);
  setappdata(h,'hidemeforgraphics',true);
  surface(L, ...
          'EdgeColor','none', ...
          'FaceColor',[0.9 0.2 0.2], ...
          'FaceLighting','phong', ...
          'AmbientStrength',0.3, ...
          'DiffuseStrength',0.6, ... 
          'Clipping','off',...
          'BackFaceLighting','lit', ...
          'SpecularStrength',1.1, ...
          'SpecularColorReflectance',1, ...
          'SpecularExponent',7,...
          'FaceAlpha',1,...
          'hittest','off');
  light('Position',[40 100 20], ...
        'Style','local', ...
        'Color',[0 0.8 0.8]);
  light('Position',[.5 -1 .4], ...
        'Color',[0.8 0.8 0]);

function h = addblankbackground
% Put a blank white background behind the presentation
  
% Sadly, we do need an exes so that things that
% turn the background on and off can operate.
  h = axes('visible','off');

function h = addbluebarbackground
% Put blue bars in the axes.
  
  h = axes('visible','off','pos',[0 0 1 1],...
           'xlim',[0 1],'ylim',[0 1]);
  
  rectangle('parent',h,...
            'facecolor','blue','edgecolor','none',...
            'pos',[0 .8 1 .2]);
  
function h = addhalfframebackground
% Put a half-frame on the top-left of the figure.
  
  h = axes('visible','off','pos',[0 0 1 1],...
           'xlim',[0 1],'ylim',[0 1]);

  v = [ .05 .1
        .05 .8
        .9 .8 
        nan nan ];
  
  fvc = [ 0 0 .5
          0 0 1
          0 0 .5
          nan nan nan ];
  
  f = 1:4;

  patch('parent',h,...
        'vertices',v,...
        'faces',f,...
        ... 'facevertexcdata',fvc,...
        'facecolor','none',...
        'edgecolor','blue',...
        'linewidth',5);
  line('parent',h,...
       'xdata',v(2,1),...
       'ydata',v(2,2),...
       'marker','square',...
       'markeredgecolor','none',...
       'markerfacecolor',fvc(2,:),...
       'markersize',20);
  
function h = addbluedriftbackground
% Put a pale blue drift background on the whole background.
  
  h = axes('visible','off','pos',[0 0 1 1],...
           'xlim',[0 1],'ylim',[0 1]);

  bb = [ .2 .2 1 ];
  db = [ 1 1 1 ];
  
  cdata(1,1,:) = db;
  cdata(1,2,:) = db;
  cdata(2,1,:) = bb;
  cdata(2,2,:) = db;
  
  surface('xdata',[ 0 1 ; 0 1], ...
          'ydata',[ 0 0 ; 1 1], ...
          'zdata',[ 0 0 ; 0 0], ...
          'cdata', cdata, ...
          'facecolor','interp',...
          'edgecolor','none');