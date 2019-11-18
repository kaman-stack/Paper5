clear all, close all, clc

lineWidth = 2;
markerSize = 14;
FontSize = 20;

q1 = 0.4
qR = 0.8;
% Data-center's availability
alpha = 0.7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1       ; %    0 dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta = 1.5   ; % 1.76 dB
% theta = 1.9953; %    3 dB

theta = 3.1623; %    5 dB

loadParameters_d05;

Mu1 = 5
qu = 1 - sum( p( 1: Mu1) ) % user 2 requests files with probability qu

F = 10; % Total files that the relay can hold both for cached and non-cached traffic
B = [1 5 F];
assert( min(B)>0 );

state05 = zeros( length(B), 1+length(B(end)));
  
b_idx=1;
for b = B
    b
    assert(b>0 && min(B)>0)
    ph = sum( p( Mu1 + 1: Mu1 + F - b ) )
    
    [ t0, rho, p0, ~, ~ ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
     
     state05(b_idx,1) = p0;
     for i = 1:b
        state05( b_idx, i+1) = rho^(i-1)*t0*p0;
     end

     assert( sum( state05(b_idx,:))-1.0< 10e-6);     
     b_idx    = b_idx+1; 
     
     clear pNot0  qFull;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loadParameters_d12;

Mu2 = 0
qu = 1 - sum( p( 1: Mu2) ) % user 2 requests files with probability qu

F = 10; % Total files that the relay can hold both for cached and non-cached traffic
B = [1 5 F];
assert( min(B)>0 );

state12 = zeros( length(B), 1+length(B(end)));
  
b_idx=1;
for b = B
    b
    assert(b>0 && min(B)>0)
    ph = sum( p( Mu2 + 1: Mu2 + F - b ) )
    
    [ t0, rho, p0, ~, ~ ] = statesProb(b, q1, qR, qu, ph, alpha,...
               P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
               P_1toR, P_1toRwhenBS, ...
               P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );
     
     state12(b_idx,1) = p0;
     for i = 1:b
        state12( b_idx, i+1) = rho^(i-1)*t0*p0;
     end

     assert( sum( state12(b_idx,:))-1.0< 10e-6);     
     b_idx    = b_idx+1; 
     
     clear pNot0  qFull;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = figure(2);
h1 = plot( 0:1,  state05(1,1:2), 'g-*'); hold on;  % B = 1
h4 = plot( 0:1,  state12(1,1:2), 'm-*'); hold on;  % B = 1

h2 = plot( 0:5,  state05(2,1:6), 'r-o'); hold on;  % B = 5
h5 = plot( 0:5,  state12(2,1:6), 'k-o'); hold on;  % B = 5

h3 = plot( 0:F,  state05(3,:), 'b-s'); hold on;  % B = F = 10 
h6 = plot( 0:F,  state12(3,:), 'c-s'); hold on;  % B = F = 10 

% set([h1 h2 h3 h4 h5 h6],'LineWidth', lineWidth,'MarkerSize', markerSize);
set([h1 h2 h3 h4 h5 h6],'LineWidth', lineWidth,'MarkerSize', markerSize);
grid on;
set(gca,'FontSize', FontSize);

axis([0 F 0 1]);

xlabel( sprintf('state $i$ (F=%d)',F),'interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
ylabel('$ \pi(i) $','interpreter', 'latex','FontSize', FontSize,'FontWeight','bold');
title( sprintf('$q_1 = %.2f$, $q_R = %.2f$, $\\theta = %1.0f$ dB', q1, qR, 10*log(theta)/log(10) ), 'FontSize', FontSize,'FontWeight','bold', 'interpreter', 'latex');
 leg_handle = legend(  sprintf('$ B =  %2d, ~\\delta = %1.1f, M_U = %d$',   1,  0.5, Mu1), sprintf('$ B =  %1.0f, ~\\delta = %1.1f, M_U = %d$',1, 1.2, Mu2),...
                       sprintf('$ B =  %2d, ~\\delta = %1.1f, M_U = %d$',   5,  0.5, Mu1), sprintf('$ B =  %1.0f, ~\\delta = %1.1f, M_U = %d$', 5, 1.2, Mu2),...
                       sprintf('$ B =  %2d,  \\delta = %1.1f, M_U = %d$',  10,  0.5, Mu1), sprintf('$ B =  %1.0f, \\delta = %1.1f, M_U = %d$',10, 1.2,Mu2),...
               'location', 'best','interpreter', 'latex', 'FontSize',FontSize, 'FontWeight','bold');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
print('-depsc2', sprintf('States_vs_i_Bs_q1_%02d_theta_%1.0f_2deltas.eps', 10*q1, 10*log(theta)/log(10) ) );
disp('DONE ploting State(i) vs i for different Bs');

