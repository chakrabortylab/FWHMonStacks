clear, clc, close all
dataLocation=fullfile('test.tif');
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
step=2;
l=1;


for k=1:step:zdim-1 %% this loop runs over the number of images
   
V=imageVolume(k:k+step,:,:);
%%
close all
% clear FWHMx FWHMy FWHMz X2 X Y Y2
[zdim1,ydim2,x2]=size(V);
A=squeeze(max(V));

%
%%
cc = normxcorr2(B,A);
    
    % subplot 223, imshow(template,[])
    % subplot 224, plot(cc),shading interp;
    % figure(200),
    % surf(cc),shading interp;
    indmax = find(imregionalmax(cc));
    [peak,sortind]= sort(cc(indmax),1,'descend');
    % top2 = sortind(1:2);
    [yPosT, xPosT] = ind2sub(size(cc), indmax(sortind));
    
figure('Name', ['Stack Layer' num2str(l) ],'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);

imshow(A,[],'Border','tight');iptsetpref('ImshowAxesVisible','off'); 
op=peak(peak>.8 & peak<1);
for k=1:length(op)
    
%     h = drawrectangle('Position',[xPosT(k)-15,yPosT(k)-15,10,10],'Color','r');
    h = drawcircle('Center',[xPosT(k)-9,yPosT(k)-8],'Radius',10,'Color','yellow');
    hold on
end

l=l+1;
end