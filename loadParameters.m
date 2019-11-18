
p = 4; % path-loss exponent
n = 10^-11;

% POWERS
PWR_1   =   10^-3;       % User 1 transmitter power:         1   mW
PWR_R   = 2*10^-3;       % User R transmitter power:         2 mW
PWR_BS  =   10^-2;       % Data center's DC transmitter power: 10 mW

% DISTANCES
r1D = 50*sqrt(2);
r1R = 50;
rRD = 50;
rR2 = 50;

rBS2 = 100;

r12  = sqrt( r1R^2 + rR2^2);
r1BS = sqrt( r12^2 + rBS2^2);
rBSD = sqrt( r12^2 + (100-r1D)^2);

rBSR = sqrt( (r12/2)^2 + (100-r1D/2)^2);
 
% LINK SUCCESS PROBABILITIES (assuming perfect self-interference
% cancellation (aka no self-interference) )

% 1->D
P_1toD           = exp(-theta*n*r1D^p/PWR_1)
P_1toDwhenR      = P_1toD       / (1+theta*(PWR_R/PWR_1)*(r1D/rRD)^p)    % from 1 to D when R interferes
P_1toDwhenBS     = P_1toD       / (1+theta*(PWR_BS/PWR_1)*(r1D/rBSD)^p)   % from 1 to D when R interferes
P_1toDwhenBSandR = P_1toDwhenBS / (1+theta*(PWR_R/PWR_1)*(r1D/rRD)^p)     % from 1 to D when both the BS and R interferes

% 1->R
P_1toR           = exp(-theta*n*r1R^p/PWR_1)
P_1toRwhenBS     = P_1toR      / (1+theta*(PWR_BS/PWR_1)*(r1R/rBSR)^p)

% R->D
P_RtoD           = exp(-theta*n*rRD^p/PWR_R)
P_RtoDwhen1      = P_RtoD / (1+theta*(PWR_1/PWR_R)*(rRD/r1D)^p)
P_RtoDwhenBS     = P_RtoD / (1+theta*(PWR_BS/PWR_R)*(rRD/rBSD)^p)
P_RtoDwhenBSand1 = P_RtoDwhenBS / (1+theta*(PWR_1/PWR_R)*(rRD/r1D)^p)

% BS->2
P_BSto2           =  exp(-theta*n*rBS2^p/PWR_BS)
P_BSto2when1      =  P_BSto2 / (1+theta*(PWR_1/PWR_BS)*(rBS2/r12)^p)
P_BSto2whenR      =  P_BSto2 / (1+theta*(PWR_R/PWR_BS)*(rBS2/rR2)^p)
P_BSto2whenRand1  =  P_BSto2whenR / (1+theta*(PWR_1/PWR_BS)*(rBS2/r12)^p)

% R->2
P_Rto2      = exp(-theta*n*rR2^p/PWR_R)
P_Rto2when1 = P_Rto2/ (1+theta*(PWR_1/PWR_R)*(rR2/r12)^p)

% [ rho, probState0, probStateNot0, probStateFull ] = statesProb( 50, 0.75, 0.5, ...
%     LINK_SUCC_RtoD, LINK_SUCC_RtoDwhen1, ...
%     LINK_SUCC_1toD, LINK_SUCC_1toDwhenR, ...
%     LINK_SUCC_1toR, LINK_SUCC_1toRwhenR)

% Cache parameters
N     = 10000; % Number of files
delta = 0.5;

a = zeros(1,N);
for j=1:N
    a(j) = j^-delta;
end

Omega = 1/sum(a);
p = zeros(1,N);
for i=1:N
    p(i) = Omega/i^delta;
end

% alpha = 0.7;
% 
% Mu = 200
% R = 20; % Total files that the relay can hold both for cached and non-cached traffic
% B  = 5; % Cache size
% assert(B<R);
%  
% qu = 1 - sum( p( 1: Mu) ) % user 2 requests files with probability qu
% ph = sum( p( Mu+1: Mu+R-B) );
%  
% q1 = 0.7;
% qR = 0.7;
% 
% [~, ~, pNot0, qFull ] = statesProb(B, q1, qR, qu, ph, alpha,...
%                 P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR, ... 
%                 P_1toR, P_1toRwhenR, P_1toRwhenBS, P_1toRwhenBSandR, ...
%                 P_RtoD, P_RtoDwhen1, P_RtoDwhenBS, P_RtoDwhenBSand1 );

           