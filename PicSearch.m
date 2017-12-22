function varargout = PicSearch(varargin)
% PICSEARCH MATLAB code for PicSearch.fig
%      PICSEARCH, by itself, creates a new PICSEARCH or raises the existing
%      singleton*.
%
%      H = PICSEARCH returns the handle to a new PICSEARCH or the handle to
%      the existing singleton*.
%
%      PICSEARCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICSEARCH.M with the given input arguments.
%
%      PICSEARCH('Property','Value',...) creates a new PICSEARCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PicSearch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PicSearch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PicSearch

% Last Modified by GUIDE v2.5 10-Dec-2017 22:05:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PicSearch_OpeningFcn, ...
                   'gui_OutputFcn',  @PicSearch_OutputFcn, ...
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


% --- Executes just before PicSearch is made visible.
function PicSearch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PicSearch (see VARARGIN)
M=imread('./res/title.jpg');
axes(handles.axes3);%axes1是坐标轴的标示
imshow(M);
M=imread('./res/bg1.jpg');
axes(handles.axes1);%axes1是坐标轴的标示
imshow(M);
M=imread('./res/bg1.jpg');
axes(handles.axes2);%axes1是坐标轴的标示
imshow(M);
% Choose default command line output for PicSearch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PicSearch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PicSearch_OutputFcn(hObject, eventdata, handles) 
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
db=uigetdir( '选择图库地址'); %选择图库
if db == 0
    msgbox('您没有正确选择文件夹！');
    return;
end
add=fullfile(db)
set(handles.edit1,'String',add);
drawnow;
tic
str=strcat('正在加载，请稍后。。。');
set(handles.text1,'String',str);
drawnow;
delete('./database/*') 
copyfile(db,'./database')
run ./matconvnet-1.0-beta25/matlab/vl_setupnn
net = load('./res/imagenet-vgg');
net=vl_simplenn_tidy(net);

path_imgDB = './database/';
addpath(path_imgDB);
addpath tools;

%% Step 2 LOADING IMAGE AND EXTRACTING FEATURE
imgFiles = dir(path_imgDB); %显示path_imgDB下所有文件以及文件夹
imgNamList = {imgFiles(~[imgFiles.isdir]).name}; %显示imgFiles里面所有非文件的名字存到数组（1x10）
clear imgFiles; %清除imgFiles
imgNamList = imgNamList'; %转置(10x1)

numImg = length(imgNamList); %获取imgNamList数组数量（图片数量）
t=round(numImg*0.08269231+2);
str=strcat('预计耗时  ',num2str(t),'  秒');
set(handles.text1,'String',str);
drawnow;
feat = []; %创建向量feat
rgbImgList = {}; %创建数组rgbImgList
[a,layersnum]=size(net.layers);

%parpool;

%parfor i = 1:numImg
for i = 1:numImg  %1到图片数量numImg
   oriImg = imread(imgNamList{i, 1});  %依次读取imgNamList中图片
   if size(oriImg, 3) == 3 %判断图片是否为真彩图,3真彩图.1索引图
       im_ = single(oriImg) ; % note: 255 range，转为单精度，必须为single或者double
       im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;%大小设置为224*224
       %imshow(im_);
       %im_ = im_-net.meta.normalization.averageImage ; %减去平均值？？？？
       %imshow(im_);
       res = vl_simplenn(net, im_) ;%evaluates the convnet NET on data X
       
       % viesion: matconvnet-1.0-beta17
       featVec = res(layersnum).x;%19-layer的输出值,res(20).x
       
       featVec = featVec(:); % 将featVec中的值变为一列，矩阵转换为向量
       feat = [feat; featVec'];%feat为空，featVec转置
       fprintf('extract %d image\n\n', i);
   else
       im_ = single(repmat(oriImg,[1 1 3])) ; % note: 255 range 转为三维图像
       im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;%大小设置为224*224
       im_ = im_ - net.meta.normalization.averageImage ;%减去平均值       
       res = vl_simplenn(net, im_) ;%evaluates the convnet NET on data X
       
       % viesion: matconvnet-1.0-beta17
       featVec = res(20).x;%19-layer的输出值,res(20).x
       
       featVec = featVec(:);%将featVec中的值变为一列，矩阵转换为向量
       feat = [feat; featVec'];%feat为空，featVec转置
       fprintf('extract %d image\n\n', i);%显示extract x image
   end
end

% reduce demension by PCA, recomend to reduce it to 128 dimension.
%[coeff, score, latent] = princomp(feat);
%feat = feat*coeff(:, 1:128);

feat_norm = normalize1(feat);%用tools的normalizel()函数进行归一化处理
save('./res/0.mat','feat','feat_norm', 'imgNamList', '-v7.3'); 
toc
str=strcat('加载成功！耗时 ',num2str(toc),' 秒,请点击选择图片！');
set(handles.text1,'String',str);
drawnow;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.jpg', '读取图片文件'); %选择图片文件
   pathfile=fullfile(pathname, filename);  %获得图片路径
   M=imread(pathfile);
   axes(handles.axes1);%axes1是坐标轴的标示
   imshow(M);
   drawnow
   copyfile(pathfile,'.\database\0.jpg')
run ./matconvnet-1.0-beta25/matlab/vl_setupnn
%加载图片数据库
db = './database/';%图片数据存入database文件夹
addpath(db);
addpath tools;
%加载预训练的模型
net = load('./res/imagenet-vgg');
net=vl_simplenn_tidy(net);
load ./res/0.mat
[a,layersnum]=size(net.layers);
%读取需要查询图片

   M= single(M);
   M = imresize(M, net.meta.normalization.imageSize(1:2)) ;%大小设置为224*224
   %M = M - net.meta.normalization.averageImage ; %减去平均值
   res = vl_simplenn(net, M) ;
   MVec = res(layersnum).x
   MVec = MVec(:)
   VEC = []; 
   VEC = [VEC; MVec'];
   feat_norm=normalize1([VEC;feat]);
   imgNamList=['0.jpg';imgNamList];
   save('./res/01.mat','feat_norm', 'imgNamList', '-v7.3');
   str=strcat('图像选择成功！请检索！');
   set(handles.text1,'String',str);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
    delete ('./result/*.jpg');
    str=strcat('检索中！请稍后！');
    set(handles.text1,'String',str);
    addpath('tools');%加载tools文件夹
    numRetrieval = 10;%查询显示图像数量
    load ./res/num.mat;
    load ./res/01.mat;
    path_imgDB = './database/';%路径设置为./database/
    addpath(path_imgDB);%添加路径path_imgDB（./database/）
    queryID = 1; %自定义查询第i张图片
%retrieval_virsulazation( queryID, numRetrieval, feat_norm, imgNamList);%tools中的函数，进行图片检索

%%retrieval_virsulazation
QueryVec = feat_norm(queryID, :);%读取featNorm第queryID行，即第queryID个图像
[n,d] = size(feat_norm);%读取featNorm行数n，列数d（n为图像数量）
score = zeros(n, 1);%建立n行1列的0矩阵
score = (QueryVec*feat_norm')';%QueryVec为1*d， featNorm'为d*n,score为n*1

[~, index] = sort(score, 'descend');%将score中的值降序排列（对每一列排序）,只取其queryID号
rank_image_ID = index;%将其降序后的id号顺序保存至rank_image_ID

I2 = uint8(zeros(100, 100, 3, numRetrieval)); % 32 and 32 are the size of the output image 建立100*100*3*numRetrieval矩阵
for i=1:numRetrieval %从1到numRetrieval
    imName = imgNamList{rank_image_ID(i, 1), 1}; %读取id为i的图片名称如BIRD1.JPG
    rename=strcat(num2str(i-1),'_',imName);
    add=strcat('./database/',imName);
    add2=strcat('./result/',rename);
    copyfile(add,add2);
    im = imread(imName);%读取imName图片
    im = imresize(im, [100 100]);%将该图片大小改为100*100
    I2(:, :, :, i) = im;%将图片按接近程度依次存入I2中
end

axes(handles.axes2);%axes1是坐标轴的标示
montage(I2(:, :, :, (2:numRetrieval)));%依次读取I2中numRetrieval个图像
toc;
str=strcat('检索耗时 ：  ',num2str(toc),'  秒');
set(handles.text1,'String',str);



% --------------------------------------------------------------------




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


% --------------------------------------------------------------------


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run 'model'


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run MatVideo;

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run resultui;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('./result');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('./database');
