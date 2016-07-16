function mlppresentationdir(fig, pfile)
% Setup the presentation directory for the figure FIG
% and the presentation file PFILE.
  
  viewer = get(fig,'userdata');

  f=fullfile(pwd, pfile);

  [ path ] = fileparts(f);
  
  viewer.presentationdir = path;
  
  
  if isempty(viewer.presentationdir)
    viewer.presentationdir = pwd;
  end
  
  set(gcf,'userdata',viewer);

  
  