% This script plots time series of averaged values of some ecmwf parameters
% It is used for the report. 
% It is called by main.m



t1 = datetime(1987,01,1,0,0,0);
t2 = datetime(1988,01,31,23,59,59);
t = t1:t2;

subplot(3,1,1);

plot( t, T2M-273.15)
title('Air Temperature (C)')
xlim([t1 t2])
ylim([-5 35])
    hline = ones(1,size(t,2))*0;%mean(T2M-273.15);
hold on
plot( t , hline)
hold off

subplot(3,1,2);

plot( t, U10)
title('Wind velocity, x-component (m/s)')
xlim([t1 t2])
ylim([-6 6])
    hline = ones(1,size(t,2))*mean(U10);
hold on
plot( t , hline)
hold off

subplot(3,1,3);


plot( t, V10)
title('Wind velocity, y-component (m/s)')
xlim([t1 t2])
ylim([-6 6])
    hline = ones(1,size(t,2))*mean(V10);
hold on
plot( t , hline)
hold off

% sgtitle('My Subplot Grid Title')


