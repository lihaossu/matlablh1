function varargout = flavia(varargin)

%%%  main function of leaf recognition program
%%%  three addtional.m file used:imagemd;getpts1;pcapnn;expsys
%%%  four database file used:net2;taxonomy;seg2;five
%%Programmed by Stephen Gang Wu<gwu827@gmail.com>  & Forrest Sheng Bao <http://forrest.bao.googlepages.com>
%%

clear;
global dat leaf dingdian classification_result; 
SoftInfo
sprintf('   A Leaf Recognition Algorithm/Program for Plant Classification using PNN (Probabilistic Neural Network) \n                              by \n            Stephen Gang Wu  <gwu827@gmail.com> \n                              & \n              Forrest Sheng Bao  <http://forrest.bao.googlepages.com> \n  \n Under the supervision of Prof. Xingjun Tian <tianxj@nju.edu.cn>, S. of Life Science, Nanjing University \n This research is supported by Dept. of Botany, S. of Life Science, Nanjing University \n \n This software is a free software licensed under GNU General Public License v.2 or later \n http://www.gnu.org/copyleft/gpl.html')

instruction_msg='Instructions: \n 1. Please select the image of the leaf to be recognized in the pop-up dialog box.\n 2. On the opened leaf image, select the two terminals of the main and longest venation of the leaf.\n    Click the points that you think they are such terminals. \n    Positions of the last two clicks will be recorded and considered as the terminal of the main and longest venation.\n    Press Enter to quit when you are done. \n 3. Wait the program processing the image and running PNN to recognize it.\n 4. The program will return you  the Latin name of the plant on a pop-up message box and MATLAB command window.\n   Remember, this is a system based on training, it may not recognize correctly. \n 5. You will also see the comparison of your leaf image and the image of the leaf in our database.' ;
sprintf(instruction_msg)

dingdian=zeros(1,4);

dat=zeros(1,12);
out=0;
[name,path]=uigetfile('*.*','Select leaf image'); 
%%%open the image file
leaf= imread([path,name]);
[y,x,z]=size(leaf);
if x>800 
   leaf=imresize(leaf,0.5);     
end
%figure(1);
hSelect=figure('MenuBar','none','Name','Please select the two terminals of the longest and main venation of the leaf');
p1=imshow(leaf);
text(0,0,'\newline Please select the two terminal of the longest and main venation of the leaf \newline Click the two terminals of the leaf. \newline You can click many times. The last two selections will be considered as terminals. \newline Press Enter to quit the selection when you are done','FontSize',12,'EdgeColor','red','FontWeight','bold')

%htext=impixelinfoval(gcf,p1);
%%%2% obtain vertex coordinates%%
%pause

pixval(p1);
%%%2% obtain vertex coordinates%%
%pause
[xi,yi] = getpts1(get(p1,'Parent'));
dimension=size(xi);
dingdian(1)=xi(dimension(1)-1,1);
dingdian(2)=yi(dimension(1)-1,1);
dingdian(3)=xi(dimension(1),1);
dingdian(4)=yi(dimension(1),1);
close all;
close all hidden;

%%%3% model covert to data%%%
dat=imagemd(leaf,dingdian);
%%%4% pca and pnn%%%
%t_start=cputime;

sprintf('recognition started at %s', datestr(now, 'mm dd, yyyy HH:MM:SS.FFF'))
tic
classification_result=pcapnn(dat)
toc
sprintf('recognition finished at %s', datestr(now, 'mm dd, yyyy HH:MM:SS.FFF'))

%t_stop=cputime;
%sprintf('recongnition costs time %d',t_stop-t_start)

load taxonomynocn.mat 
%disp ('the most similar is');
%disp ([taxonomy{1,classification_result}]);
%disp ([taxonomy{2,classification_result}]);

%msgresult=['Chinese name: ' taxonomy{1,classification_result} ',  ' 'Latin name:' taxonomy{2,classification_result}]
msgresult=['the Latin name of this plant is:' taxonomynocn{1,classification_result}]
msgbox(msgresult,'The most possible plant is','help');
%msgbox([taxonomy{1,classification_result}],'The most possible plant is','help');


standard=['standardleaves/' num2str(classification_result) '.jpg'];

if (fopen(standard)~=-1)
	standard2=imread(standard);

	h2=figure('MenuBar','none','Position',[220,70,800,600],'Name','Result');
 	f = uimenu('Label','More');
	    uimenu(f,'Label','Details about our algorithms','Callback','DetailInfo');
	    uimenu(f,'Label','Quit','Callback','exit',... 
        	   'Separator','on','Accelerator','Q');
	subplot(1,2,1);subimage(leaf);axis off; title('your leaf'); 
	subplot(1,2,2),subimage(standard2);axis off; title('the leaf image of the plant that most matches your leaf');
	hResult = uicontrol(h2,'Style', 'text',...
	'String', {'This plant most probably is '; taxonomynocn{1,classification_result} },...
	'FontSize',14, ...
	'FontAngle','italic', ...
	'Position',[100 10  600 40]);
else if (fopen(standard)==-1)
	msgbox('The program cannot find the standard leaf file in ./standardleaves/. So it is unable to display your leaf image and the image of standard leaf. Please download standard leaf files and put them in ./standardleaves/','Unable to find standard leaves','warning');
	end
end
%%%%%%%%%%
%test3;
%expsys(classification_result);%add on Sept.22
