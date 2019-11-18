clear all, close all, clc;

q1 = 0.6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = 1 %    0 dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1.5 % 1.76 dB
%  theta = 1.9953 % 3dB
% theta = 3.1623 %    0 dB

loadParameters2;

% Data-center's availability
alpha = 0.7;


Mu = 5
qu = 1 - sum( p( 1: Mu) ); % user 2 requests files with probability qu


qRs = 0.8:0.2:1;

F = 10 % Total files that the relay can hold both for cached and non-cached traffic
B = 0:F;
T_2 = zeros( length(qRs), length(B));

b_idx=1;
for b = B
    b;
    ph = sum( p( Mu + 1 : Mu + F - b) );

    qr_idx = 1;
    for qR = qRs
        
        
        [ ~, ~, ~, pNot0, qFull ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
           
        T_2( qr_idx, b_idx) = ThroughputAtUser2( q1, qR, qu, ph, pNot0, alpha, ...
                                      P_Rto2,  P_Rto2when1, ...
                                      P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1);    

        qr_idx      = qr_idx + 1;
        clear pNot0  qFull;
    end
    b_idx    = b_idx+1;
    
end

FontSize = 16;
fig = figure(2);

h1 = plot( B, T_2(1,:), 'b-*'); hold on;  % qR = 0.8
h2 = plot( B, T_2(2,:), 'r-o'); hold on; % qR = 1.0

set([h1 h2],'LineWidth', 1.5,'MarkerSize',9);
grid on;
set(gca,'FontSize', FontSize);

% axis([0 F 0.35 0.5]);  % theta =      1 (0 dB)
% axis([0 F 0.15 0.5]);     % theta = 3.1623 (5 dB)

xlabel( sprintf('$B:$ relay queue size $(F=%d)$',F),'interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
ylabel('$T_2$: throughput seen by user $U_2$ (pck/s)','interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
title( sprintf('$q_1 = %.1f$', q1), 'FontSize', FontSize,'FontWeight','bold', 'interpreter', 'latex');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = 3.1623 %    5 dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loadParameters2;
% 
% T_2 = zeros( length(qRs), length(B));
% b_idx=1;
% for b = B
%     b;
%     ph = sum( p( Mu + 1 : Mu + F - b) );
%     
%     qr_idx = 1;
%     for qR = qRs
%         
%         
%         [ ~, ~, ~, pNot0, qFull ] = statesProb(b, q1, qR, qu, ph, alpha,...
%                P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
%                P_1toR, P_1toRwhenBS, ...
%                P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
%            
%         T_2( qr_idx, F-b_idx) = ThroughputAtUser2( q1, qR, qu, ph, pNot0, alpha, ...
%                                       P_Rto2,  P_Rto2when1, ...
%                                       P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1);    
% 
%         qr_idx      = qr_idx + 1;
%         clear pNot0  qFull;
%     end
%     b_idx    = b_idx+1;
% 
%     
% end
% 
% FontSize = 16;
% figure(2);
% 
% h3 = plot( B, T_2(1,:), 'g-*'); hold on;  % qR = 0.8
% h4 = plot( B, T_2(2,:), 'k-o'); hold off; % qR = 1.0
% 
% 
% legend( sprintf('$q_R=0.8$, $\\theta=0$ dB'), sprintf('$q_R=1.0$, $\\theta=0$ dB'),...
%         sprintf('$q_R=0.8$, $\\theta=5$ dB'), sprintf('$q_R=1.0$, $\\theta=5$ dB'),...
%        'location', 'best','interpreter', 'latex', 'FontSize',FontSize, 'FontWeight','bold');
% 
% print('-depsc2', sprintf('T_2_vs_B_q1_%02d.eps', 10*q1 ));
% 
% disp('DONE ploting Throughput at User 2 vs cache size F-B');
