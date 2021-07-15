function F = gaussianFunc(param,xdata)

F = param(1)*exp(-((xdata-param(3)).*(xdata-param(3)))/(2*param(2)^2))+param(4);




%% FWHM=2.35482*c