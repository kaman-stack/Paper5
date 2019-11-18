close all, clear all, clc
% Plot parameters
lineWidth = 2;
markerSize = 10;
FontSize = 16;    

p = 4; % path-loss exponent
    n = 10^-11;

    % POWERS
    PWR_1   =   10^-3;       % User 1 transmitter power:         1   mW
    PWR_R   = 2*10^-3;       % User R transmitter power:         2 mW

    r1D = 100;
    rRD = 50*sqrt(2);

    theta = -5:10;
    
    P_1toD           = exp(-theta.*n*r1D^p/PWR_1);


    P_1toDwhenR      = P_1toD ./ (1+theta*(PWR_R/PWR_1)*(r1D/rRD)^p);   % from 1 to D when R interferes

    plot(theta, P_1toD, 'b-*');
    xlabel('$\\theta$','interpreter','latex','FontSize', FontSize,'FontWeight','bold');
    ylabel('$P_{succ}$','interpreter','latex','FontSize', FontSize,'FontWeight','bold');
    hold on;