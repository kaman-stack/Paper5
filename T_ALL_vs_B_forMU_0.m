clear all; close all; clc;

% Plot parameters
lineWidth = 2;
markerSize = 10;
FontSize = 16;

q1  = 0.4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = 1 %    0 dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1.5 % 1.76 dB
% theta = 1.9953 % 3dB
% theta = 3.1623 %    5 dB

loadParameters_d05;

% Data-center's availability
alpha = 0.7;


Mu = 5
qu = 1 - sum( p( 1: Mu) ) % user 2 requests files with probability qu
delta 

qR = 0.8;

F = 10 % Total files that the relay can hold both for cached and non-cached traffic
B = 0:F;

T_D = zeros( 1, length(B));
T_2 = zeros( 1, length(B));

b_idx=1;
for b = B
    b;
    ph = sum( p( Mu + 1: Mu + F - b ) );

     qr_idx = 1;
%     for qR = qRs
        
        
        [ ~, ~, ~, pNot0, qFull ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
        
        if 0==b 
            pNot0 =0
            qFull =1
        end
        T_D( qr_idx, b_idx) = ThroughputAtD( q1, qR, qu, ph, alpha, pNot0, qFull,...
                    P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR,...
                    P_1toR, P_1toRwhenBS, P_RtoDwhen1, P_RtoDwhenBSand1 );
    
        T_2( qr_idx, b_idx) = ThroughputAtUser2( q1, qR, qu, ph, pNot0, alpha, ...
                                      P_Rto2,  P_Rto2when1, ...
                                      P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1);  

%         qr_idx      = qr_idx + 1;
        clear pNot0  qFull;
%     end
    b_idx    = b_idx+1;
    
end

fig = figure(1);

h1 = plot( B, T_D(1,:), 'g-*'); hold on;  % T_D
h2 = plot( B, T_2(1,:), 'b-o'); hold on; % T_2
h3 = plot( B, T_D(1,:)+T_2(1,:), 'r-o'); hold on; % T_2

set([h1 h2 h3],'LineWidth', lineWidth ,'MarkerSize', markerSize);
grid on;
set(gca,'FontSize', FontSize);

axis([0 10 0 1]);

xlabel( sprintf('$B$: non-cacheable packets at relay''s queue $(F=%d)$',F),'interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
ylabel('throughput (pck/time-slot)','interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
title( sprintf('$M_U = %d$, $q_1 = %.1f$, $q_R=0.8$, $\\theta = %1.0f$ dB, $\\delta = %1.1f$', Mu, q1, 10*log(theta)/log(10), delta ), 'FontSize', FontSize,'FontWeight','bold', 'interpreter', 'latex');

legend( sprintf('$T_D$'), sprintf('$T_2$'),  'T',...
        'location', 'best','interpreter', 'latex', 'FontSize',FontSize, 'FontWeight','bold');
print('-depsc2', sprintf('T_ALL_vs_B_Mu_0_q1_%02d_theta_%1.0f_delta_%02d.eps', 10*q1, 10*log(theta)/log(10), 10*delta) );
disp('DONE ploting Throughput for User D vs Relay Queue Size B');