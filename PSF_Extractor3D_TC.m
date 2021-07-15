clear  
clc
close all
%%
pixX=160;
pixZ=160;
% 
% ydim=512; xdim=512;zdim=189;
% 
% %ydim=xdim;
%%
% dataDirectory=uigetdir;

% dataFilename=uigetfile([dataDirectory,'\']);
% dataLocation=fullfile(dataDirectory,dataFilename);
dataLocation=fullfile('POnly.tif');

imageInfo=imfinfo(dataLocation);
ydim=imageInfo(1).Height;

xdim=imageInfo(1).Width;

zdim=length(imageInfo);

imageVolume=zeros(zdim,ydim,xdim);

imageVolume=zeros(zdim,ydim,xdim);

for i=1:zdim
    imageVolume(i,:,:)=double((imread(dataLocation,i)));
    %V(i,:,:)=double(imread([dataP '/deconEDFpsf160b4.tif'],i));
end
%%
step=10;
l=1;
for k=1:step:zdim-1 %% this loop runs over the number of images
   
V=imageVolume(k:k+step,:,:);
%%
close all
% clear FWHMx FWHMy FWHMz X2 X Y Y2
[zdim1,ydim2,x2]=size(V);
A=squeeze(max(V));
layer=0;
figure('Name', ['Stack Layer' num2str(layer) ],'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

imshow(A,[],'Border','tight');iptsetpref('ImshowAxesVisible','off'); 

[x,y]=getpts;

x=round(x);
y=round(y);

%Yav=(y(1)+y(2))/2;

counter=(length(x));

temp=zeros(32,32);
AvPSF=zeros(30,30,30);

count=1;
for i=1:counter
   

SubWin=A(y(i)-10:y(i)+10,x(i)-10:x(i)+10);
[maxi Indi]=max(SubWin(:));
[ypeak,xpeak]= ind2sub (size(SubWin),Indi);

xpeak=round(x(i)-11+xpeak); 
ypeak=round(y(i)-11+ypeak);

[maxi2,zpeak]=max(V(:,ypeak,xpeak));

% if zpeak>26 && zpeak < zdim1-26 && xpeak>15 && xpeak< xdim-15 && ypeak>15 && ypeak< ydim2-15
if xpeak>15 && xpeak< xdim-15 && ypeak>15 && ypeak< ydim2-15

% lineZ=V(zpeak-25:zpeak+25,ypeak,xpeak);
lineX=squeeze(V(zpeak,ypeak,xpeak-10:xpeak+10));
lineY=squeeze(V(zpeak,ypeak-10:ypeak+10,xpeak));

% lineZ=lineZ-min(lineZ); lineZ=lineZ/max(lineZ);
lineX=lineX-min(lineX); lineX=lineX/max(lineX);
lineY=lineY-min(lineY); lineY=lineY/max(lineY);
%figure;plot(lineZ)
param0=[1,4,10,0];
paramZ=[1,2,25,0];
%%
% [param,resnorm,residual] = lsqcurvefit(@gaussianFunc,paramZ,[1:51],lineZ');
% FWHMz(k,count)=param(2)*2.3548*pixZ;
%%

%figure;plot(gaussianFunc(param,[1:21]));hold on;plot(lineZ,'r')
[param,resnorm,residual] = lsqcurvefit(@gaussianFunc,param0,[1:21],lineX');
FWHMx(count)=param(2)*2.3548*pixX;

[param,resnorm,residual] = lsqcurvefit(@gaussianFunc,param0,[1:21],lineY);
FWHMy(count)=param(2)*2.3548*pixX;

% Z(count)=zpeak;
% X(count)=xpeak;
% Y(count)=ypeak;
% AvPSF=AvPSF+V(zpeak-15:zpeak+14,ypeak-15:ypeak+14,xpeak-15:xpeak+14);
%figure;plot(gaussianFunc(param,[1:21]));hold on;plot(lineZ,'r')
count=count+1;
end
end

FWHMxIm(l)=mean(FWHMx(:));
stdvX(l)=std(FWHMx(:));

FWHMyIm(l)=mean(FWHMy(:));
stdvY(l)=std(FWHMy(:));

FWHMxyIm(l)=mean(FWHMy(:)+FWHMx(:));
stdvXY(l)=std(FWHMy(:)+FWHMx(:));
l=l+1;
end
%%
X=1:step:zdim-1;
% errorbar(X,FWHMxIm,stdvX, 'x')
% errorbar(X,FWHMyIm,stdvY, 'x')
errorbar(X,FWHMxyIm,stdvXY, 'x')






