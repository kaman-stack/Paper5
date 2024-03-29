function T_2 = ThroughputAtUser2( q1, qR, qU, ph, qNot0, a, ...
                                  P_Rto2,  P_Rto2when1, ...
                                  P_BSto2, P_BSto2whenR, P_BSto2when1, P_BSto2whenRand1) 

    T_2 = qU *  qR * qNot0    * (1-ph) * a * (q1 * P_BSto2whenRand1 + (1-q1) * P_BSto2whenR)...
        + qU * (1 - qR *qNot0)* q1     * ( ph*P_Rto2when1 + (1-ph)* a* P_BSto2when1)...
        + qU * (1 - qR *qNot0)* (1-q1) * ( ph*P_Rto2 + (1-ph)* a* P_BSto2) ;   
    
    
end

