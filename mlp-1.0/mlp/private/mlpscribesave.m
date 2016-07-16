function mlpscribesave()
% Save objects in the scribe layer into a file FILENAME.
  
  f=gcf;
  
  sa = findall(f,'tag','scribeOverlay');
  
  if isempty(sa)
    error('No scribe overlay to save.');
  end

  makemcode(sa);