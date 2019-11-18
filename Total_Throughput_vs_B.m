clear all, close all, clc;

% theta = 1       ; %    0 dB
% theta = 1.5   ; % 1.76 dB
% theta = 1.9953; %    3 dB
theta = 3.1623  ; %    5 dB

loadParameters;

% Data-center's availability
alpha = 0.7;


Mu = 10
qu = 1 - sum( p( 1: Mu) ); % user 2 requests files with probability qu


q1  = 0.6
qRs = 0.6:0.2:1;

R = 30; % Total files that the relay can hold both for cached and non-cached traffic
B = 1:R-1;

T = zeros( length(qRs), length(B));

b_idx=1;
for b = B
    b;
    ph = sum( p( Mu+1: Mu+R-b) );
    
    qr_idx = 1;
    for qR = qRs
        
        
        [ ~, ~, ~, pNot0, qFull ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
           
        T_D = ThroughputAtD( q1, qR, qu, ph, alpha, pNot0, qFull,...
                    P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR,...
                    P_1toR, P_1toRwhenBS, P_RtoDwhen1, P_RtoDwhenBSand1 )

        T_2 = ThroughputAtUser2( q1, qR, qu, ph, pNot0, alpha, ...
                                      P_Rto2,  P_Rto2when1, ...
                                      P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1)    
        T( qr_idx, b_idx) = T_D + T_2;
        qr_idx      = qr_idx + 1;
        clear T_D T_2 pNot0  qFull;
    end
    b_idx    = b_idx+1;

    
end

FontSize = 16;
fig = figure(1);

h1 = plot( B, T(1,:), 'b-*'); hold on;  % qR = 0.6
h2 = plot( B, T(2,:), 'g-o'); hold on;  % qR = 0.8
h3 = plot( B, T(3,:), 'r-o'); hold off; % qR = 1.0

set([h1 h2 h3],'LineWidth', 1.5,'MarkerSize',9);
grid on;
set(gca,'FontSize', FontSize);

% axis([0 R 0.65 0.75]);
axis([0 R 0.4 0.5]);

xlabel( sprintf('$B$: relay queue size $(F=%d)$',R),'interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
ylabel('$T = T_D + T_2$: Total Throughput (pck/s)','interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');

title( sprintf('$ q_1 = %.1f,~\\theta = %1.0f$ dB', q1, 10*log(theta)/log(10) ), 'FontSize', FontSize,'FontWeight','bold', 'interpreter', 'latex');
leg_handle = legend('$ q_R = 0.2 $', '$ q_R = 0.6 $', '$ q_R = 1.0 $',...
       'location', 'best','interpreter', 'latex', 'FontSize',FontSize, 'FontWeight','bold');
print('-depsc2', sprintf('T_vs_B%02d_Theta_%1.0f_dB.eps', 10*q1, 10*log(theta)/log(10)));

disp('DONE ploting Total Throughput vs Relay Queue Size B');
