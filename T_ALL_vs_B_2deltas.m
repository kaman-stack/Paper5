clear all; clc;

% Plot parameters
lineWidth = 2;
markerSize = 10;
FontSize = 24;

q1 = 0.8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1 %    0 dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1.5 % 1.76 dB
% theta = 1.9953 % 3dB
theta = 3.1623 %    5 dB

loadParameters_d05;

% Data-center's availability
alpha = 0.7;


Mu = 5
qu = 1 - sum( p( 1: Mu) ) % user 2 requests files with probability qu

qRs = 0.8

F = 10; 
B = 0:F;

T_D_05 = zeros( length(qRs), length(B));
T_2_05 = zeros( length(qRs), length(B));

b_idx=1;
for b = B
    b;
    ph = sum( p( Mu + 1: Mu + F - b ) );

    qr_idx = 1;
    for qR = qRs
        
        
        [ ~, ~, ~, pNot0, qFull ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
        
        if 0==b 
            pNot0 =0
            qFull =1
        end
        T_D_05( qr_idx, b_idx) = ThroughputAtD( q1, qR, qu, ph, alpha, pNot0, qFull,...
                    P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR,...
                    P_1toR, P_1toRwhenBS, P_RtoDwhen1, P_RtoDwhenBSand1 );
    
        T_2_05( qr_idx, b_idx) = ThroughputAtUser2( q1, qR, qu, ph, pNot0, alpha, ...
                                      P_Rto2,  P_Rto2when1, ...
                                      P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1);  

        qr_idx      = qr_idx + 1;
        clear pNot0  qFull;
    end
    b_idx    = b_idx+1;

    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theta
loadParameters_d12;

% Data-center's availability
alpha = 0.7;


Mu = 0
qu = 1 - sum( p( 1: Mu) ) % user 2 requests files with probability qu


F 
B 

T_D_12 = zeros( length(qRs), length(B));
T_2_12 = zeros( length(qRs), length(B));

b_idx=1;
for b = B
    b;
    ph = sum( p( Mu + 1: Mu + F - b ) );

    qr_idx = 1;
    for qR = qRs
        
        
        [ ~, ~, ~, pNot0, qFull ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
        
       if 0==b 
            pNot0 =0
            qFull =1
        end
        T_D_12( qr_idx, b_idx) = ThroughputAtD( q1, qR, qu, ph, alpha, pNot0, qFull,...
                    P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR,...
                    P_1toR, P_1toRwhenBS, P_RtoDwhen1, P_RtoDwhenBSand1 );
    
        T_2_12( qr_idx, b_idx) = ThroughputAtUser2( q1, qR, qu, ph, pNot0, alpha, ...
                                      P_Rto2,  P_Rto2when1, ...
                                      P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1);  

        qr_idx      = qr_idx + 1;
        clear pNot0  qFull;
    end
    b_idx    = b_idx+1;

    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = figure();
h1 = plot( B, T_D_05(1,:), 'g-*'); hold on;  % T_D
h4 = plot( B, T_D_12(1,:), 'm-*'); hold on;  % T_D

h2 = plot( B, T_2_05(1,:), 'b-o'); hold on; % T_2
h5 = plot( B, T_2_12(1,:), 'c-o'); hold on; % T_2

h3 = plot( B, T_D_05(1,:)+T_2_05(1,:), 'r-s'); hold on; % T_2
h6 = plot( B, T_D_12(1,:)+T_2_12(1,:), 'k-s'); hold on; % T_2

set([h1 h2 h3 h4 h5 h6],'LineWidth', lineWidth ,'MarkerSize', markerSize);
grid on;
set(gca,'FontSize', FontSize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axis([0 10 0 0.6]);

xlabel( sprintf('$B$: non-cacheable packets at relay''s queue $(F=%d)$',F),'interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
ylabel('throughput (pcks/time-slot)','interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
title( sprintf('$q_1 = %.1f$, $q_R=0.8$, $\\theta = %2.0f$ dB', q1, 10*log(theta)/log(10) ), 'FontSize', FontSize,'FontWeight','bold', 'interpreter', 'latex');

legend( sprintf('$T_D$ for $\\delta = 0.5, M_U = 5$'),  sprintf('$T_D$ for $\\delta = 1.2, M_U = 0$'),...
        sprintf('$T_2$ for $\\delta = 0.5, M_U = 5$ '),  sprintf('$T_2$ for $\\delta = 1.2, M_U = 0$ '),...
        sprintf('$T$ for $\\delta = 0.5, M_U = 5$'),    sprintf('$T$ for $\\delta = 1.2, M_U = 0$'),...    
        'location', 'best','interpreter', 'latex', 'FontSize',FontSize-4, 'FontWeight','bold');

    print('-depsc2', sprintf('T_ALL_vs_B_q1_%02d_theta_%1.0f_2deltas.eps', 10*q1, 10*log(theta)/log(10)) );
disp('DONE ploting Throughput for User D vs Relay Queue Size B');