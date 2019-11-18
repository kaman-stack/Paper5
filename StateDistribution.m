clear all, close all, clc

lineWidth = 2;
markerSize = 14;
FontSize = 16;

q1 = 0.4
qR = 0.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = 1       ; %    0 dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1.5   ; % 1.76 dB
% theta = 1.9953; %    3 dB
% theta = 3.1623; %    5 dB

loadParameters_d05;

% Data-center's availability
alpha = 0.7;

Mu = 5
qu = 1 - sum( p( 1: Mu) ) % user 2 requests files with probability qu

qRs = 0.8:0.2:1;

F = 10; % Total files that the relay can hold both for cached and non-cached traffic
B = [1 5 F];

state = zeros( length(B), 1+length(B(end)));
  
b_idx=1;
for b = B
    b
    assert(b>0 && min(B)>0)
    ph = sum( p( Mu + 1: Mu + F - b ) )
    
    [ t0, rho, p0, ~, ~ ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
     
     state(b_idx,1) = p0;
     for i = 1:b
        state( b_idx, i+1) = rho^(i-1)*t0*p0;
     end

     assert( sum( state(b_idx,:))-1.0< 10e-6);     
     b_idx    = b_idx+1; 
     
     clear pNot0  qFull;
end


fig = figure(4);

h1 = plot( 0:1,      state(1,1:2), 'g-*'); hold on;  % B = 1
% h2 = plot( 0:3,      state(2,1:4), 'b-o'); hold on;  % B = 
h2 = plot( 0:5,      state(2,1:6), 'r-*'); hold on;  % B = 5
h3 = plot( 0:F,      state(3,:), 'b-*'); hold on;  % B = F = 10 



set([h1  h2 h3],'LineWidth', lineWidth,'MarkerSize', markerSize);
grid on;
set(gca,'FontSize', FontSize);

axis([0 F 0 1]);

xlabel( sprintf('state $i$ (F=%d)',F),'interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
ylabel('$ \pi(i) $','interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
title( sprintf('$M_U = %d$, $q_1 = %.2f$, $q_R = %.2f$, $\\theta = %1.0f$ dB, $\\delta = %1.1f$', Mu, q1, qR, 10*log(theta)/log(10), delta ), 'FontSize', FontSize,'FontWeight','bold', 'interpreter', 'latex');

leg_handle = legend('$ B = 1$', '$ B = 5$', '$ B = 10$', ...
              'location', 'best','interpreter', 'latex', 'FontSize',FontSize, 'FontWeight','bold');



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 3.1623; %    5 dB
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % theta = 1       ; %    0 dB
% % theta = 1.5   ; % 1.76 dB
% % theta = 1.9953; %    3 dB
% 
% loadParameters;
% 
% 
% state = zeros( length(qRs), 1+length(B));
% ph = sum( p( Mu+1: Mu+F-B) );   
% qr_idx = 1;
% for qR = qRs
%         
%     [ t0, rho, p0, ~, ~ ] = statesProb(B, q1, qR, qu, ph, alpha,...
%                P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
%                P_1toR, P_1toRwhenBS, ...
%                P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
%      
%      state(qr_idx,1) = p0;
%      for i = 1:B
%         state( qr_idx, i+1) = rho^(i-1)*t0*p0;
%      end
% 
%      qr_idx      = qr_idx + 1;
%      clear pNot0  qFull;
% end
% 
% figure(4);
% h3 = plot( 0:B, state(1,:), 'g-*'); hold on;  % qR = 0.8
% h4 = plot( 0:B, state(2,:), 'k-o'); hold on;  % qR = 1.0
% 
% set([h3 h4],'LineWidth', 1.5,'MarkerSize',9);
% 
% 
% leg_handle = legend('$ q_R = 0.8$,  $\theta = 0$ dB', '$ q_R = 1.0$, $\theta = 0$ dB',...
%              '$ q_R = 0.8$,  $\theta = 5$ dB', '$ q_R = 1.0$, $\theta = 5$ dB',...
%              'location', 'best','interpreter', 'latex', 'FontSize',FontSize, 'FontWeight','bold');
% assert( sum( state(1,:))-1.0< 10e-6);
% assert( sum( state(2,:))-1.0< 10e-6);
% 
print('-depsc2', sprintf('States_vs_i_Bs_q1_%02d_theta_%1.0f_delta_%02d.eps', 10*q1, 10*log(theta)/log(10), 10*delta ) );
disp('DONE ploting State(i) vs i for different Bs');

