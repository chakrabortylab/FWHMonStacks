clear  
clc
close all
%%
pixX=.162;
pixZ=.162;
% 
% ydim=512; xdim=512;zdim=189;
% 
% %ydim=xdim;
%%
% dataDirectory=uigetdir;

% dataFilename=uigetfile([dataDirectory,'\']);
% dataLocation=fullfile(dataDirectory,dataFilename);
dataLocation=fullfile('S&POnly.tif');
B=double(imread('testCrop.tif'));

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

cc = normxcorr2(B,A);
indmax = find(imregionalmax(cc));
[peak,sortind]= sort(cc(indmax),1,'descend');
[yPosT, xPosT] = ind2sub(size(cc), indmax(sortind));
op=peak(peak>.78 & peak<1);
x1=round(xPosT-9);
y1=round(yPosT-8);
f=1;

for k=1:length(op)
    if x1(k)>16 && x1(k)<(xdim-16)
        if y1(k)>16 && y1(k)<(ydim-16)
            x(f)=x1(k);
            y(f)=y1(k);
%     h = drawrectangle('Position',[xPosT(k)-15,yPosT(k)-15,10,10],'Color','r');
    h = drawcircle('Center',[x1(k),y1(k)],'Radius',10,'Color','yellow');
    hold on
    f=f+1;
        end
    end
end
counter=(length(x));

temp=zeros(32,32);
AvPSF=zeros(30,30,30);
pause(1)
count=1;
for i=1:counter
SubWin=A(y(i)-10:y(i)+10,x(i)-10:x(i)+10);
[maxi, Indi]=max(SubWin(:));
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
[param,~,~] = lsqcurvefit(@gaussianFunc,param0,[1:21],lineX');
FWHMx(count)=param(2)*2.3548*pixX;

[param,resnorm,residual] = lsqcurvefit(@gaussianFunc,param0,[1:21],lineY);
FWHMy(count)=param(2)*2.3548*pixX;

count=count+1;
end
end
%%


% FWHMxIm(l)=mean(FWHMx(:));
% stdvX(l)=std(FWHMx(:));
l1=0.65;
m1=0.7;

FWHMxIm(l)=mean(FWHMx(FWHMx>l1 & FWHMx<m1));
stdvX(l)=std(FWHMx(FWHMx>l1 & FWHMx<m1));


FWHMyIm(l)=mean(FWHMy(FWHMy>l1 & FWHMy<m1));
stdvY(l)=std(FWHMy(FWHMy>l1 & FWHMy<m1));


FWHMxyIm1=((FWHMx(:)+FWHMy(:))/2);
FWHMxyIm(l)=mean(FWHMxyIm1(FWHMxyIm1>l1 & FWHMxyIm1<m1));

% stdvXY1=((FWHMx(:)+FWHMy(:))/2);
stdvXY(l)=std(FWHMxyIm1(FWHMxyIm1>l1 & FWHMxyIm1<m1));

candidates(:,l)=size(FWHMx(FWHMx>l1 & FWHMx<m1));

l=l+1;
end
%%
X=1:step:zdim-1;
figure(200)
subplot(3,1,1), errorbar(X,FWHMxIm,stdvX, 'x'), title('FWHM in X'),ylim([0.5,.8])
subplot(3,1,2), errorbar(X,FWHMyIm,stdvY, 'x'), title('FWHM in Y'), ylim([0.5,.8])
subplot(3,1,3),errorbar(X,FWHMxyIm,stdvXY, 'x'), title('FWHM in XY')

ylim([0.5,.8])




