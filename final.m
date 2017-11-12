function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 10-Nov-2017 19:07:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using final.
 if strcmp(get(hObject,'Visible'),'off')
     plot(rand(5));
end

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im2;
[File_Name, Path_Name] = uigetfile();
% ...    
%     {'*.jpg; *.JPG; *.jpeg; *.JPEG; *.img; *.IMG; *.tif; *.TIF; *.tiff, *.TIFF','Supported Files (*.jpg,*.img,*.tiff,)'; ...
%     '*.jpg','jpg Files (*.jpg)';...
%     '*.JPG','JPG Files (*.JPG)';...
%     '*.jpeg','jpeg Files (*.jpeg)';...
%     '*.JPEG','JPEG Files (*.JPEG)';...
%     '*.img','img Files (*.img)';...
%     '*.IMG','IMG Files (*.IMG)';...
%     '*.tif','tif Files (*.tif)';...
%     '*.TIF','TIF Files (*.TIF)';...
%     '*.tiff','tiff Files (*.tiff)';...
%     '*.TIFF','TIFF Files (*.TIFF)'})
imagefilename = strcat(Path_Name,File_Name);
myImage=imread(imagefilename);
im=myImage;
im2=myImage;
im=im2double(im);
axes(handles.axes1);
imshow(myImage);     



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im imf rows columns channels;
%J = imresize(im,[row column]);
J = im;
sigr = 30;
sigd =1;
size1 = rows;
size2 = columns;
%Removing noise using bilateral filtering
N = J;
if channels>1
for c_i=1:channels
    for row_i=1:size1
        for col_i=1:size2
            w_sum=0;
            w_total = 0;
            ints=0;
            dis=0;
        for m=-10:10
            for n=-10:10
                if row_i+m>0 && col_i+n>0 && row_i+m<= size1 && col_i+n<= size2
                    ints = (J(row_i+m,col_i+n,c_i)-J(row_i,col_i,c_i))^2;
                    dis =  m^2+n^2;              
                    w_sum = w_sum + (exp(-1*ints/sigr)*exp(-1*dis/sigd))*J(row_i+m,col_i+n,c_i);
                 w_total = w_total + (exp(-1*ints/sigr)*exp(-1*dis/sigd));
                end
             end
         end

         N(row_i,col_i,c_i) = double(w_sum/w_total);
        end
    end
end
gs_N = rgb2gray(N);
gse_N = imadjust(gs_N);

for c_i=1:channels
    for row_i=1:size1
        for col_i=1:size2
            N(row_i,col_i,c_i) = N(row_i,col_i,c_i)*gse_N(row_i,col_i)/gs_N(row_i,col_i);
        end
    end
end
else
        for row_i=1:size1
            for col_i=1:size2
                w_sum=0;
                w_total = 0;
                dis =0;
                ints=0;
        for m=-10:10
            for n=-10:10
                if row_i+m>0 && col_i+n>0 && row_i+m<= size1 && col_i+n<= size2
                    ints = (J(row_i+m,col_i+n)-J(row_i,col_i))^2;
                    dis =  m^2+n^2;              
                    w_sum = w_sum + (exp(-1*ints/sigr)*exp(-1*dis/sigd))*J(row_i+m,col_i+n);
                 w_total = w_total + (exp(-1*ints/sigr)*exp(-1*dis/sigd));
                end
             end
         end

         N(row_i,col_i) = double(w_sum/w_total);
             end
       end
    N = imadjust(N);
end
I_filtered = N;
imf = N;
axes(handles.axes2);
imshow(I_filtered);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im2;
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    I = im2;
    %detecting eye
    BB = step(EyeDetect,I);
for l=1:size(BB,1)
    for i=BB(l,1):BB(l,1)+ BB(l,3)
     for j=BB(l,2): BB(l,2)+ BB(l,4)
         if I(j,i,1) > 50 && I(j,i,2)<85 && I(j,i,3)<115
             I(j,i,1) = 0;
         end
     end
    end
end
axes(handles.axes2);
imshow(I);
