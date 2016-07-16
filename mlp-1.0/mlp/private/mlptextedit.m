function mlptextedit(h)
% Put the text object H into edit mode for MLP.
% 
% 

  str = getappdata(h,'unfilteredstring');
  
  if isempty(str)
    
    set(h,'editing','on');
    
  else
    
    filter = getappdata(h,'filter');
    
    if ischar(str)
      str = { str };
    end
    
    set(h,'string',str);
    
    set(h,'editing','on');
    
    waitfor(h,'editing');
    
    newstr = get(h,'string');
    
    set(h,'string',filter(newstr));
    
    setappdata(h,'unfilteredstring',newstr);
    
  end