function varargout = Iris(varargin)
% IRIS MATLAB code for Iris.fig
%      IRIS, by itself, creates a new IRIS or raises the existing
%      singleton*.
%
%      H = IRIS returns the handle to a new IRIS or the handle to
%      the existing singleton*.
%
%      IRIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IRIS.M with the given input arguments.
%
%      IRIS('Property','Value',...) creates a new IRIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the IRIS before Iris_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Iris_OpeningFcn via varargin.
%
%      *See IRIS Options on GUIDE's Tools menu.  Choose "IRIS allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Iris

% Last Modified by GUIDE v2.5 20-May-2017 23:09:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Iris_OpeningFcn, ...
                   'gui_OutputFcn',  @Iris_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = Iris_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Iris is made visible.
function Iris_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Iris (see VARARGIN)

% Choose default command line output for Iris
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
init_HMAX;
axes(handles.axes1);
imshow(255);

% UIWAIT makes Iris wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Iris_OutputFcn(hObject, eventdata, handles) 
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
[FileName,PathName] = uigetfile({'*.jpg'; '*.png'},'Selectionner une image d''iris');
path = fullfile(PathName, FileName);
irisImg = imread(path);
handles.irisPath = path;

guidata(hObject,handles);
axes(handles.axes1);
imshow(irisImg);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
irisImg = handles.irisPath;
segImg = extractIris(irisImg, 24, 240);

handles.segImg = segImg;
guidata(hObject,handles);

axes(handles.axes1);
imshow(segImg);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
segImg = handles.segImg;
gabor = gaborFilter(segImg);
[id, distance] = searchIris(gabor, 1, 36);
set(handles.Affichage, 'String', ['id = ' num2str(id) ' distance : ' num2str(distance)]);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
imshow(255);
handles.irisPath = 0;
handles.segImg = 0;
guidata(hObject,handles);
set(handles.Affichage, 'String', '');
