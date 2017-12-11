function varargout = model(varargin)
% MODEL MATLAB code for model.fig
%      MODEL, by itself, creates a new MODEL or raises the existing
%      singleton*.
%
%      H = MODEL returns the handle to a new MODEL or the handle to
%      the existing singleton*.
%
%      MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL.M with the given input arguments.
%
%      MODEL('Property','Value',...) creates a new MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model

% Last Modified by GUIDE v2.5 09-Dec-2017 20:41:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_OpeningFcn, ...
                   'gui_OutputFcn',  @model_OutputFcn, ...
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


% --- Executes just before model is made visible.
function model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model (see VARARGIN)

% Choose default command line output for model
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_OutputFcn(hObject, eventdata, handles) 
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
str=strcat('正在保存设置...');
set(handles.text1,'String',str);
drawnow;
delete('./res/imagenet-vgg.mat');
copyfile('./res/imagenet-vgg-f.mat','./res/imagenet-vgg.mat');
str=strcat('保存成功！当前模型为“imagenet-vgg-f.mat”');
set(handles.text1,'String',str);
drawnow;
close;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=strcat('正在保存设置...');
set(handles.text1,'String',str);
drawnow;
delete('./res/imagenet-vgg.mat');
copyfile('./res/imagenet-vgg-verydeep-19.mat','./res/imagenet-vgg.mat');
str=strcat('保存成功！当前模型为“imagenet-vgg-verydeep-19.mat”');
set(handles.text1,'String',str);
drawnow;
close;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete('./res/imagenet-vgg.mat');
[filename, pathname] = uigetfile('*.mat', '读取模型'); %选择模型片文件
if [filename, pathname] == 0
    msgbox('您没有正确选择模型！');
    return;
end
add=fullfile(pathname,filename)
set(handles.edit1,'String',add);
drawnow;
str=strcat('正在保存设置...');
set(handles.text1,'String',str);
drawnow;
pathfile=fullfile(pathname, filename);  %获得图片路径
copyfile(pathfile,'./res/imagenet-vgg.mat')
str=strcat('保存成功！当前模型为自定义模型');
set(handles.text1,'String',str);
drawnow;
close;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=strcat('正在保存设置...');
set(handles.text1,'String',str);
drawnow;
delete('./res/imagenet-vgg.mat');
copyfile('./res/vgg-face.mat','./res/imagenet-vgg.mat');
str=strcat('保存成功！当前模型为“imagenet-vgg.mat”');
set(handles.text1,'String',str);
drawnow;
close;
