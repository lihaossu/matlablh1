function viewerout = mlp(presentation, viewer)
% Execute an MLP structure.

  if isstruct(presentation)

    if ~isfield(presentation, 'Style') || ~isfield(presentation, 'Title');
      error('Not a presentation.');
    end


    if nargin==2 && isstruct(viewer) && isfield(viewer,'editmode')
      
      pagestyle = viewer;
    
    else
      error('mlp created presentation must have a Page Style.');
    end
    
    % overwrite old viewer with a real one.
    viewer = mlpviewer(pagestyle);
    
    viewer.Presentation = presentation;
    viewer.Index = 1;

    set(viewer.Fig,'userdata',viewer);
    
    mlp('show',viewer);
    
  elseif ischar(presentation)

    switch presentation
     case 'go'
      mlprun(viewer,true);
     case 'stop'
      mlprun(viewer,false);
     case 'show'
      % mlpclear(viewer);
      % disp(['Show to page ' num2str(viewer.Index)]);
      mlpshowslide(viewer, viewer.Presentation(viewer.Index));
     case 'first'
      viewer = savepage(viewer);
      viewer.Index = 1;
      set(viewer.Fig,'userdata',viewer);      
      mlp('show',viewer);
     case 'last'
      viewer = savepage(viewer);
      viewer.Index = length(viewer.Presentation);
      set(viewer.Fig,'userdata',viewer);      
      mlp('show',viewer);
     case 'next'
      viewer = savepage(viewer);
      len = length(viewer.Presentation);
      viewer.Index = viewer.Index+1;
      if viewer.Index > len
        viewer.Index = 1;
      end
      set(viewer.Fig,'userdata',viewer);      
      mlp('show',viewer);
     case 'prev'
      viewer = savepage(viewer);
      viewer.Index = viewer.Index-1;
      if viewer.Index < 1
        viewer.Index = length(viewer.Presentation);
      end
      set(viewer.Fig,'userdata',viewer);      
      mlp('show',viewer);
     case 'delete'
      pageindex = viewer.Index;
      allpages = viewer.Presentation;
      len = length(viewer.Presentation);
      
      if len==1
        warndlg('Cannot delete only presentation page.');
      else
      
        if pageindex < len
          allpages(pageindex:end-1) = allpages(pageindex+1:end);
        else
          viewer.Index = pageindex-1;
        end
        allpages = allpages(1:end-1);
     
        viewer.Presentation = allpages;
        set(viewer.Fig,'userdata',viewer);      
        mlp('show',viewer);
      end
     case 'new'      
      pageindex = viewer.Index+1;
      allpages = viewer.Presentation;
      newpage.Style = 'Page';
      newpage.Title = 'Click for title';
      newpage.SubTitle = 'Click for subtitle';
      newpage.Page = { 'Click to add text' };
      newpage.ScribeStuff = [];
      newpage.PlotCommands = '';
      newpage.Demo = '';
      newpage.InPlaceDemo = false;
      newpage.ExtraText = { '' };
      newpage.ExtraTextColumn = 'none';
      newpage.TextInterpreter = 'wiki';
      newpage.ExtraTextInterpreter = 'page';

      allpages(pageindex+1:end+1) = allpages(pageindex:end);
      allpages(pageindex) = newpage;
      
      viewer.Presentation = allpages;
      set(viewer.Fig,'userdata',viewer);      
    
      mlp('next',viewer);

     case 'save'
      viewer = savepage(viewer);
      set(viewer.Fig,'userdata',viewer);      

     case 'rundemo'
      
      demo = viewer.Presentation(viewer.Index).Demo;
      inplace = viewer.Presentation(viewer.Index).InPlaceDemo;
      
      if inplace
        p = pwd;
        cd(viewer.presentationdir);
        try
          eval(demo{1})
        catch
          questdlg([ 'Demo "' demo{1} '" failed to run.'],'Ooops','Ok','Ok');
        end        
        cd(p);
      else
        oldshh = get(0,'showhiddenhandles');
        set(0,'showhiddenhandles','off');
        set(viewer.Fig,'handlevis','off');
        set(viewer.Fig,'nextplot','new');
        p = path;
        addpath(viewer.presentationdir)
        try
          eval(demo{1})
        catch
          questdlg([ 'Demo "' demo{1} '" failed to run.'],'Ooops','Ok','Ok');
        end
        path(p);
        set(viewer.Fig,'handlevis','on');
        set(viewer.Fig,'nextplot','add');
        set(0,'showhiddenhandles',oldshh);
      end
    end
    
  elseif isscalar(presentation)

    viewer = savepage(viewer);
    viewer.Index = presentation;
    set(viewer.Fig,'userdata',viewer);      
    mlp('show',viewer);
    
  end
  
  if nargout == 1
    viewerout = viewer;
  end

function viewer = savepage(viewer)
% Save the values of the visual representation of current page into
% the VIEWER
  
  if viewer.Editmode
    pageindex = viewer.Index;
    allpages = viewer.Presentation;
    allpages(pageindex).Title = get(viewer.Title,'string');
    allpages(pageindex).SubTitle = get(viewer.SubTitle,'string');
    allpages(pageindex).Page = getappdata(viewer.Page,'unfilteredstring');
    allpages(pageindex).ExtraText = getappdata(viewer.ExtraText,'unfilteredstring');
    
    % Handle graphics stuff
    if strcmp(allpages(pageindex).Style,'Scribe')
      hts = handle2struct(viewer.ScribeAxes);
      allpages(pageindex).ScribeStuff = hts.children;
    else
      allpages(pageindex).ScribeStuff = [];
    end

    if strcmp(allpages(pageindex).Style,'Graphic') || ...
          strcmp(allpages(pageindex).Style,'Image')
      allpages(pageindex).PlotCommands = get(viewer.EditGraphics, 'string');
    else
      allpages(pageindex).PlotCommands = [];
    end
    
    viewer.Presentation = allpages;
    
    n = getappdata(viewer.Fig,'presentationname');
    Presentation = allpages; %#ok
    PageStyle = viewer.PageStyle; %#ok
    tic
    save(n,'Presentation','PageStyle');
    toc
  end
