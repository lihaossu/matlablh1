function mlpclear(viewer)
% Clear the current slide off of FIG
  
  blank.Title = '';
  blank.SubTitle = '';
  blank.Page = '';
  
  mlpshowslide(viewer,blank);