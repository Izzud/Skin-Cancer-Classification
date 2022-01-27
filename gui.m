function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 10-Apr-2016 19:09:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end %DO NOT EDIT


% End initialization code -
% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no out args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line out for gui
handles.output = hObject;
handles.groundtruth = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning out args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line out from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btinput.
function btinput_Callback(hObject, eventdata, handles)
% hObject    handle to btinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%reset semua axes untuk menampilkan input&out baru
cla(handles.inp,'reset');
set(handles.inp,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.pre,'reset');
set(handles.pre,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.seg,'reset');
set(handles.seg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
set(handles.txtkelas, 'String', '');
set(handles.txtarea, 'String', 'Area / Img = ');
set(handles.txtperim, 'String', 'Perim / Area = ');
set(handles.txtred, 'String', 'Color - R = ');
set(handles.txtgreen, 'String', 'Color - G = ');
set(handles.txtblue, 'String', 'Color - B = ');
set(handles.txtvariance, 'String', 'Color Variance = ');
set(handles.txtsymmetry, 'String', 'Image Symmetry = ');

[filename, pathname] = uigetfile('*.tif;*.jpg;*.png;*.bmp','Pick an Image File');
iminput = imread([pathname, filename]);

% if size(iminput,3) == 3
%     iminput = rgb2gray(iminput);
% end
iminput = im2double(iminput);
assignin('base', 'iminput', iminput);

set(handles.inp,'HandleVisibility', 'ON');
axes(handles.inp);
imshow(iminput);
handles.im_input = iminput;
guidata(hObject, handles);


% --- Executes on button press in btgt.
function btgt_Callback(hObject, eventdata, handles)
% hObject    handle to btgt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.gt,'reset');
set(handles.gt,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
% cla(handles.interactive,'reset');
% set(handles.interactive,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.pre,'reset');
set(handles.pre,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');
cla(handles.seg,'reset');
set(handles.seg,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w');

[filegt, pathgt] = uigetfile('*.tif;*.jpg;*.png;*.bmp','Pick an Image File');
imgt  = imread([pathgt, filegt]);
imgt = (im2bw(imgt)*255);

assignin('base', 'imgt', imgt);
set(handles.gt,'HandleVisibility', 'ON');
axes(handles.gt);
imshow(imgt);
handles.im_gt = imgt;
handles.groundtruth = 1;
guidata(hObject, handles);


% --- Executes on button press in btproses.
function btproses_Callback(hObject, eventdata, handles)
% hObject    handle to btproses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ori = handles.im_input;
if (handles.groundtruth == 1)
    gt = handles.im_gt;
end
% figure, imshow(ori);

%gambar gray
gray=rgb2gray(ori);

%gambar glpf
gray = im2double(gray);
[m, n] = size(gray);
[U, V] = dftuv(m, n);
dist = sqrt(U.^2 + V.^2);
cutoff = 7;
imFft = fft2(gray);

glpf = exp(-(dist.^2) ./ (2 *(cutoff.^2)));

imageGlpf = glpf .*imFft;
imResult = ifft2(imageGlpf);

set(handles.pre,'HandleVisibility', 'ON');
axes(handles.pre);
imshow(imResult, []);
handles.im_pre = imResult;
guidata(hObject, handles);

[T, s] = globalthresh(imResult);
assignin('base', 's', s);
assignin('base', 'T', T);

reg = zeros(size(imResult));
for i=1:size(s,1)
	reg = reg + regionGrowing(imResult, T, [s(i,1) s(i,2)], m, n);
end

reg = (reg>=1);
assignin('base', 'imout', reg);

figure, imshow(gray); hold on;
plot (s(:,2), s(:,1), 'r*'); hold off;

set(handles.seg,'HandleVisibility', 'ON');
axes(handles.seg);
imshow(reg);
handles.im_seg = reg;
guidata(hObject, handles);

if (handles.groundtruth == 1)
    gt = gt/255;
    [acc, sen, spe] = segmen_eval(gt,reg);
    set(handles.txtacc, 'String', ['Akurasi = ' num2str(acc*100) ' %']);
    set(handles.txtsen, 'String', ['Sensitivity = ' num2str(sen*100) ' %']);
    set(handles.txtspe, 'String', ['Specificity = ' num2str(spe*100) ' %']);
end

area = sum(reg(:)==1)/(size(reg,1)*size(reg,2));
[red, green, blue] = colorfeatures(ori, reg);
perim = bwperim(reg, 8);
perimeter = sum(perim(:)==1)/sum(reg(:)==1);
% figure, imshow(perim);


mask = logical(reg);
rgbMask = double(cat(3, reg, reg, reg));
inverted = imcomplement(rgbMask);
masked = imsubtract(ori, inverted);

imwrite(masked, 'masked_image.jpg')

variance = ColourVariance(ori,mask);
symmetry = ImageSymmetry(masked, mask);

%% please check these
set(handles.txtarea, 'String', ['Area / Img = ' num2str(area)]);
set(handles.txtperim, 'String', ['Perim / Area = ' num2str(perimeter)]);
set(handles.txtred, 'String', ['Color - R = ' num2str(red)]);
set(handles.txtgreen, 'String', ['Color - G = ' num2str(green)]);
set(handles.txtblue, 'String', ['Color - B = ' num2str(blue)]);
set(handles.txtvariance, 'String', ['Color Variance = ' num2str(variance)]);
set(handles.txtsymmetry, 'String', ['Image Symmetry = ' num2str(symmetry)]);

data_tes = [area, perimeter, red, green, blue, variance, symmetry];
%data_tes = [variance, symmetry, red, green, blue];

handles.data_tes = data_tes;
guidata(hObject, handles);


% --- Executes on button press in bttrain.
function bttrain_Callback(hObject, eventdata, handles)
% hObject    handle to btinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

program_folder = pwd;
train_folder = uigetdir('', 'Pilih folder data training');
set(handles.txttrain, 'String', train_folder);
cd(train_folder);
train = dir('*0_*.jpg');
num = length(train);
cd(program_folder);

% data train
data_train = zeros(2*num,7,'double');
kelas_train = zeros(2*num,1);
h = waitbar(0,'Training Process...');
steps = 2*num;

for im1=1:2
    for im2=1:num
        idx = (im1-1)*num + im2;
        waitbar(idx/steps)
        ori=imread(strcat(train_folder, '/',num2str(im1-1),'_',num2str(im2),'.jpg'));
        gray=rgb2gray(ori);
        gray = im2double(gray);
        [m, n] = size(gray);
        [U, V] = dftuv(m, n);
        dist = sqrt(U.^2 + V.^2);
        cutoff = 7;
        imFft = fft2(gray);
        glpf = exp(-(dist.^2) ./ (2 *(cutoff.^2)));
        imageGlpf = glpf .*imFft;
        imResult = ifft2(imageGlpf);

        [T, s] = globalthresh(imResult);
        reg = zeros(size(imResult));
        for i=1:size(s,1)
            reg = reg + regionGrowing(imResult, T, [s(i,1) s(i,2)], m, n);
        end
        reg = (reg>=1);
       
        %area
        area = sum(reg(:)==1)/(size(reg,1)*size(reg,2));
        %rgb
        [red, green, blue] = colorfeatures(ori, reg);
        %perimeter
        perim = bwperim(reg, 8);
        perimeter = sum(perim(:)==1)/sum(reg(:)==1);
        
        %% Variance and Symmetry
        ori = im2double(ori);
        mask = logical(reg);
        rgbMask = double(cat(3, reg, reg, reg));
        inverted = imcomplement(rgbMask);
        masked = imsubtract(ori, inverted);

        variance = ColourVariance(ori, mask);
        symmetry = ImageSymmetry(masked, mask);

        data_train(idx,:) = [area, perimeter, red, green, blue, variance, symmetry];
        kelas_train(idx) = im1-1;
    end
end
std_train = standardize(data_train);
training = [std_train, kelas_train];
assignin('base', 'data_training', training);
save data_training training;
set(handles.tbltrain, 'Data', training);

% ---------- Train SVM ----------
model = fitcsvm(data_train, kelas_train);
handles.model = model;
guidata(hObject, handles);
waitbar(1);
close(h);


% --- Executes on button press in bttest.
function bttest_Callback(hObject, eventdata, handles)
% hObject    handle to btinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model = handles.model;
data_tes = handles.data_tes;
%kelas_tes = ClassificationSVM(model, data_tes) ;
kelas_tes = predict(model, data_tes);

if (kelas_tes == 0)
    kelas = 'Benign';
else kelas = 'Malignant';
end
set(handles.txtkelas, 'String', kelas);



