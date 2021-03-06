function varargout = SoftInfo(varargin)

scrsz = get(0,'ScreenSize');
box_width=3*scrsz(3)/5;
%h1=figure('Position',[scrsz(3)/3 scrsz(4)/6 box_width scrsz(4)/3],'Name','Flavia');
h1=figure('MenuBar','none','Position',[400.3333  600  614.4000  256.0000+50],'Name','Flavia');

f = uimenu('Label','More');
	    uimenu(f,'Label','Details about our algorithms','Callback','DetailInfo');
	    uimenu(f,'Label','Quit','Callback','exit',... 
        	   'Separator','on','Accelerator','Q');

hTitle = uicontrol('Style', 'text',...
	'String', 'A Leaf Recognition Algorithm/Program for Plant Classification using PNN (Probabilistic Neural Network)',...
	'FontSize',22,...
	'Position',[0.0000  204.8000+50  614.4000   51.2000]);
%	'Position',[1 4*scrsz(4)/15  box_width scrsz(4)/15]);


HSubstitle=uicontrol('Style', 'text',...
	'String', {  'by Gang Wu<gwu827@gmail.com> & Forrest Sheng Bao<http://forrest.bao.googlepages.com>'; 'under the supervision of Prof. Xingjun Tian<tianxj@nju.edu.cn>, S. of Life Science, Nanjing University'; ''; 'This research is supported by Dept. of Botany, S. of Life Science, Nanjing University'; ''; 'This software is a free software licensed under GNU General Public License v.2 or later'; 'http://www.gnu.org/copyleft/gpl.html' },...
	'FontSize',13,...
	'Position',[0.0000  102.4000+50  614.4000  102.4000]);
%	'Position',[1 2*scrsz(4)/15 box_width 2*scrsz(4)/15]);



%hsp = uipanel('Title','Instructions:','FontSize',12,...
 %            'BackgroundColor','white',...
  %            'Position',[1 1 box_width 2*scrsz(4)/15]);
Instr_mssg={'Instructions:';'1. Please select image file of the leaf to be recognized in the pop-up dialog box.'; '2. On the opened leaf image, select the two terminals of the main and longest venation of the leaf.  Click to select points that you think they are such terminals. Press Enter to quit when you are done. Positions of the last two clicks will be recorded and considered as the terminal of the main and longest venation.'; ' 3. Wait scores of seconds. The program will return you  the Latin name of the plant on a pop-up message box and MATLAB command window.  Remember, this is a system based on training, it may not recognize correctly.';' 4. Side-by-side display of your leaf and standard leaf is available if you have downloaded standard leaves.';'To enable Step.4, please download the standard leaf archive and extract image files into PRESENT_PATH/sample_leaves. PRESENT_PATH is the directory where you start this program'};
%Instr_mssg=cellstr(Instr_mssg);

hIsp = uicontrol('Style','text',...
		'String',Instr_mssg,...
		'HorizontalAlignment','left',...
		'BackgroundColor','white',...
		'FontSize',11,...
              'Position',[0    0.0000  614.4000  102.4000+50]);


DetailB = uicontrol('Style', 'pushbutton', 'String', 'Details of this algorithm',...
		    'Position', [460 1 150 30], 'Callback', 'DetailInfo',...
			'HorizontalAlignment','left','FontSize',12);
