function newstr = mlpwiki(str)
% Convert STR into NEWSTR via simple wiki rules.

  % Compat problem.
  if iscell(str) && size(str{1},1) ~= 1
    str = str{1};
  end
  
  if ischar(str)

    newstr = { };
    
    for i=1:size(str,1)
      newstr{i} = str(i,:);
    end
    
  else
    newstr = str;
  end
  
  newstr = regexprep(newstr, '^\* ', '\\bullet ','ignorecase');
  newstr = regexprep(newstr, '^\*\* ', '   \\circ ','ignorecase');
  newstr = regexprep(newstr, '^\*\*\* ', '      \\cdot ','ignorecase');

  newstr = regexprep(newstr, '/([^/]+[^ ])/', '{\\it$1}','ignorecase');
  
  newstr = regexprep(newstr, '\*([^\*]+[^ ])\*', '{\\bf$1}','ignorecase');

  newstr = regexprep(newstr, '\#([^#]+[^ ])\#', '{\\fontname{courier}$1}','ignorecase');

  newstr = regexprep(newstr, '\(c\)', '\\copyright','ignorecase');
  
  newstr = regexprep(newstr, '[/~]=', '\\neq');

  newstr = regexprep(newstr, '\.\.\.', '\\ldots');
  
  newstr = regexprep(newstr, ' -> ', '\\rightarrow');
  newstr = regexprep(newstr, ' <- ', '\\leftarrow');
  newstr = regexprep(newstr, ' <-> ', '\\leftrightarrow');
  
  newstr = regexprep(newstr, ' +$', '');
  
%  if iscell(newstr)
%    disp (['New String is [' newstr{:} ']'])
%  else
%    disp (['New String is [' newstr ']'])
%  end