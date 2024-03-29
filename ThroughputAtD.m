function T_D = ThroughputAtD( q1, qR, qU, ph, alpha, qNot0, qIsFull,...
                    P_1toD, P_1toDwhenR, P_1toDwhenBS, P_1toDwhenBSandR,...
                    P_1toR, P_1toRwhenBS, P_RtoDwhen1, P_RtoDwhenBSand1 )
    
    T_1D = q1* qR * qNot0 * ...
            ( (1-qU)*P_1toDwhenR + qU * (1-ph) * alpha * P_1toDwhenBSandR + qU*(1-ph)*(1-alpha)*P_1toDwhenR)...
         + q1* (1 - qR * qNot0) ...
            *((1-qU)*P_1toD + qU* ph * P_1toDwhenR + qU * (1-ph) * alpha * P_1toDwhenBS + qU*(1-ph)*(1-alpha)*P_1toD );

          
    probQ_0 = 1- qNot0;
    p0toBMinus1 = qNot0-qIsFull;
    

    T_R = q1 * probQ_0 * ...
            ( (1-qU)* (1-P_1toD) *P_1toR + qU*ph*(1-P_1toDwhenR)*P_1toR +...
                qU*(1-ph)*alpha* (1-P_1toDwhenBS)* P_1toRwhenBS  +... 
                qU*(1-ph)*(1-alpha)*(1-P_1toD)*P_1toR)...
        ...
        + q1 * p0toBMinus1 * qR * ...
        ( (1-qU)*(1-P_1toDwhenR)*P_1toR  + qU * alpha * (1-P_1toDwhenBSandR)*P_1toRwhenBS + ...
            qU*(1-alpha)*(1-P_1toDwhenR)*P_1toR)...
        ...
         + q1 * p0toBMinus1 *(1-qR)* ...
        ( (1-qU)*(1-P_1toD)*P_1toR + qU*ph*(1-P_1toDwhenR)*P_1toR + ...
            qU *(1-ph) * alpha*(1-P_1toDwhenBS)*P_1toRwhenBS + ...
            qU *(1-ph) *(1-alpha)*(1-P_1toD)*P_1toR) ...
        ... 
         +q1 * qIsFull * qR * ...
            ( (1-qU)* P_RtoDwhen1 *(1-P_1toDwhenR)*P_1toR + ...
                 qU * alpha * P_RtoDwhenBSand1 * (1-P_1toDwhenBSandR) * P_1toRwhenBS + ...
                 qU * (1-alpha) * P_RtoDwhen1* (1-P_1toDwhenR) *P_1toR);

    if 0==qNot0
        disp('qNot0 == 0. Relay is not assisting')
        T_D = T_1D;
    else 
        T_D = T_1D + T_R;
    end

end



