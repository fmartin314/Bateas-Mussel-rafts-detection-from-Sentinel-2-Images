function varargout = BateasDEMO(varargin)
% BATEASDEMO MATLAB code for BateasDEMO.fig
%      BATEASDEMO, by itself, creates a new BATEASDEMO or raises the existing
%      singleton*.
%
%      H = BATEASDEMO returns the handle to a new BATEASDEMO or the handle to
%      the existing singleton*.
%
%      BATEASDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATEASDEMO.M with the given input arguments.
%
%      BATEASDEMO('Property','Value',...) creates a new BATEASDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BateasDEMO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BateasDEMO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BateasDEMO

% Last Modified by GUIDE v2.5 26-Jun-2024 12:16:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BateasDEMO_OpeningFcn, ...
                   'gui_OutputFcn',  @BateasDEMO_OutputFcn, ...
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


% --- Executes just before BateasDEMO is made visible.
function BateasDEMO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BateasDEMO (see VARARGIN)

% Choose default command line output for BateasDEMO
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% Mostrar logo
axes(handles.Logo)
imaux = imread('UVIGO-AtlantTIC.png');
image(imaux);
axis off;
axis image;
% Imagen vacia inicialmente
axes(handles.InputImage)
imaux = zeros(512,512,3);
image(imaux);
axis off;
axis image;
% Directorio de entrada
handles.InputDir = "";
guidata(hObject,handles);
% UIWAIT makes BateasDEMO wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BateasDEMO_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in InputFolder.
function InputFolder_Callback(hObject, eventdata, handles)
% hObject    handle to InputFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Cargar calibracion de color

% Cargar imagen
folder = uigetdir('.','Input folder selection');
if (folder~=0)
    % Guardarla
    handles.InputDir = folder;
    set(handles.InputFolderEdt,'string',folder);
    guidata(hObject,handles);
end


function InputFolderEdt_Callback(hObject, eventdata, handles)
% hObject    handle to InputFolderEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputFolderEdt as text
%        str2double(get(hObject,'String')) returns contents of InputFolderEdt as a double
saux = get(handles.InputFolderEdt,'string');
handles.InputDir = saux;
% Save data
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function InputFolderEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputFolderEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GoButton.
function GoButton_Callback(hObject, eventdata, handles)
% hObject    handle to GoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
%
if (strcmp(handles.InputDir,""))
    % No hay directorio
    msgbox('Select one valid folder','BateasDEMO');
    return;
end
%
% Resolución de la banda 2 (maxima)
resolution = 2;
% Ejecutar
[rgborig,finalmtg]=FindBateas(handles.InputDir,resolution);
% Representar original en ventana principal
axes(handles.InputImage)
image(rgborig);
axis off;
axis image;
% Y resultado en figura aparte
figure;imshow(finalmtg);title('Result (saved on result.jpg)');
