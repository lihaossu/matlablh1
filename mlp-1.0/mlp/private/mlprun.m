function mlprun(viewer,go)
% Clear the current slide off of FIG
  
  runrun = false;
  setappdata(viewer.Fig,'runrun',runrun);
  
  if go
    yarun;
  end
  
  function norun()
    
    runrun = false;
    setappdata(viewer.Fig,'runrun',runrun);
    
    %disp stop
    
  end
  function yarun()
    
    runrun = true;
    setappdata(viewer.Fig,'runrun',runrun);
    % disp start
    
    while runrun
      
      viewer = get(viewer.Fig,'userdata');      
      
      % disp(viewer.Index)
      
      len = length(viewer.Presentation);
      if viewer.Index >= len
        mlp('first',viewer);
      else
        mlp('next',viewer');
      end
      
      viewer = get(viewer.Fig,'userdata');      

      if isempty(viewer.Presentation(viewer.Index).Demo)
        pause(10);
      else
        mlp('rundemo',viewer);
      end
      
      runrun = getappdata(viewer.Fig,'runrun');
      
    end
    
  end
end