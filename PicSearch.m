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
axes(handles.axes3);%axes1��������ı�ʾ
imshow(M);
M=imread('./res/bg1.jpg');
axes(handles.axes1);%axes1��������ı�ʾ
imshow(M);
M=imread('./res/bg1.jpg');
axes(handles.axes2);%axes1��������ı�ʾ
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
db=uigetdir( 'ѡ��ͼ���ַ'); %ѡ��ͼ��
if db == 0
    msgbox('��û����ȷѡ���ļ��У�');
    return;
end
add=fullfile(db)
set(handles.edit1,'String',add);
drawnow;
tic
str=strcat('���ڼ��أ����Ժ󡣡���');
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
imgFiles = dir(path_imgDB); %��ʾpath_imgDB�������ļ��Լ��ļ���
imgNamList = {imgFiles(~[imgFiles.isdir]).name}; %��ʾimgFiles�������з��ļ������ִ浽���飨1x10��
clear imgFiles; %���imgFiles
imgNamList = imgNamList'; %ת��(10x1)

numImg = length(imgNamList); %��ȡimgNamList����������ͼƬ������
t=round(numImg*0.08269231+2);
str=strcat('Ԥ�ƺ�ʱ  ',num2str(t),'  ��');
set(handles.text1,'String',str);
drawnow;
feat = []; %��������feat
rgbImgList = {}; %��������rgbImgList
[a,layersnum]=size(net.layers);

%parpool;

%parfor i = 1:numImg
for i = 1:numImg  %1��ͼƬ����numImg
   oriImg = imread(imgNamList{i, 1});  %���ζ�ȡimgNamList��ͼƬ
   if size(oriImg, 3) == 3 %�ж�ͼƬ�Ƿ�Ϊ���ͼ,3���ͼ.1����ͼ
       im_ = single(oriImg) ; % note: 255 range��תΪ�����ȣ�����Ϊsingle����double
       im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;%��С����Ϊ224*224
       %imshow(im_);
       %im_ = im_-net.meta.normalization.averageImage ; %��ȥƽ��ֵ��������
       %imshow(im_);
       res = vl_simplenn(net, im_) ;%evaluates the convnet NET on data X
       
       % viesion: matconvnet-1.0-beta17
       featVec = res(layersnum).x;%19-layer�����ֵ,res(20).x
       
       featVec = featVec(:); % ��featVec�е�ֵ��Ϊһ�У�����ת��Ϊ����
       feat = [feat; featVec'];%featΪ�գ�featVecת��
       fprintf('extract %d image\n\n', i);
   else
       im_ = single(repmat(oriImg,[1 1 3])) ; % note: 255 range תΪ��άͼ��
       im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;%��С����Ϊ224*224
       im_ = im_ - net.meta.normalization.averageImage ;%��ȥƽ��ֵ       
       res = vl_simplenn(net, im_) ;%evaluates the convnet NET on data X
       
       % viesion: matconvnet-1.0-beta17
       featVec = res(20).x;%19-layer�����ֵ,res(20).x
       
       featVec = featVec(:);%��featVec�е�ֵ��Ϊһ�У�����ת��Ϊ����
       feat = [feat; featVec'];%featΪ�գ�featVecת��
       fprintf('extract %d image\n\n', i);%��ʾextract x image
   end
end

% reduce demension by PCA, recomend to reduce it to 128 dimension.
%[coeff, score, latent] = princomp(feat);
%feat = feat*coeff(:, 1:128);

feat_norm = normalize1(feat);%��tools��normalizel()�������й�һ������
save('./res/0.mat','feat','feat_norm', 'imgNamList', '-v7.3'); 
toc
str=strcat('���سɹ�����ʱ ',num2str(toc),' ��,����ѡ��ͼƬ��');
set(handles.text1,'String',str);
drawnow;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.jpg', '��ȡͼƬ�ļ�'); %ѡ��ͼƬ�ļ�
   pathfile=fullfile(pathname, filename);  %���ͼƬ·��
   M=imread(pathfile);
   axes(handles.axes1);%axes1��������ı�ʾ
   imshow(M);
   drawnow
   copyfile(pathfile,'.\database\0.jpg')
run ./matconvnet-1.0-beta25/matlab/vl_setupnn
%����ͼƬ���ݿ�
db = './database/';%ͼƬ���ݴ���database�ļ���
addpath(db);
addpath tools;
%����Ԥѵ����ģ��
net = load('./res/imagenet-vgg');
net=vl_simplenn_tidy(net);
load ./res/0.mat
[a,layersnum]=size(net.layers);
%��ȡ��Ҫ��ѯͼƬ

   M= single(M);
   M = imresize(M, net.meta.normalization.imageSize(1:2)) ;%��С����Ϊ224*224
   %M = M - net.meta.normalization.averageImage ; %��ȥƽ��ֵ
   res = vl_simplenn(net, M) ;
   MVec = res(layersnum).x
   MVec = MVec(:)
   VEC = []; 
   VEC = [VEC; MVec'];
   feat_norm=normalize1([VEC;feat]);
   imgNamList=['0.jpg';imgNamList];
   save('./res/01.mat','feat_norm', 'imgNamList', '-v7.3');
   str=strcat('ͼ��ѡ��ɹ����������');
   set(handles.text1,'String',str);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
    delete ('./result/*.jpg');
    str=strcat('�����У����Ժ�');
    set(handles.text1,'String',str);
    addpath('tools');%����tools�ļ���
    numRetrieval = 10;%��ѯ��ʾͼ������
    load ./res/num.mat;
    load ./res/01.mat;
    path_imgDB = './database/';%·������Ϊ./database/
    addpath(path_imgDB);%���·��path_imgDB��./database/��
    queryID = 1; %�Զ����ѯ��i��ͼƬ
%retrieval_virsulazation( queryID, numRetrieval, feat_norm, imgNamList);%tools�еĺ���������ͼƬ����

%%retrieval_virsulazation
QueryVec = feat_norm(queryID, :);%��ȡfeatNorm��queryID�У�����queryID��ͼ��
[n,d] = size(feat_norm);%��ȡfeatNorm����n������d��nΪͼ��������
score = zeros(n, 1);%����n��1�е�0����
score = (QueryVec*feat_norm')';%QueryVecΪ1*d�� featNorm'Ϊd*n,scoreΪn*1

[~, index] = sort(score, 'descend');%��score�е�ֵ�������У���ÿһ������,ֻȡ��queryID��
rank_image_ID = index;%���併����id��˳�򱣴���rank_image_ID

I2 = uint8(zeros(100, 100, 3, numRetrieval)); % 32 and 32 are the size of the output image ����100*100*3*numRetrieval����
for i=1:numRetrieval %��1��numRetrieval
    imName = imgNamList{rank_image_ID(i, 1), 1}; %��ȡidΪi��ͼƬ������BIRD1.JPG
    rename=strcat(num2str(i-1),'_',imName);
    add=strcat('./database/',imName);
    add2=strcat('./result/',rename);
    copyfile(add,add2);
    im = imread(imName);%��ȡimNameͼƬ
    im = imresize(im, [100 100]);%����ͼƬ��С��Ϊ100*100
    I2(:, :, :, i) = im;%��ͼƬ���ӽ��̶����δ���I2��
end

axes(handles.axes2);%axes1��������ı�ʾ
montage(I2(:, :, :, (2:numRetrieval)));%���ζ�ȡI2��numRetrieval��ͼ��
toc;
str=strcat('������ʱ ��  ',num2str(toc),'  ��');
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
