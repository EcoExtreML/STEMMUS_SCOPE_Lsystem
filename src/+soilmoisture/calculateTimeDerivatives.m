function [RHS, HeatMatrices, boundaryFluxArray] = calculateTimeDerivatives(InitialValues, SoilVariables, HeatMatrices, Delt_t)
    %{
        Perform the finite difference of the time derivatives of the matrix
        equation as Equation 4.32 shows in 'STEMMUS Technical Notes', section 4.
    %}
    % Extract variables that are nedded in this fucntion
    C1 = HeatMatrices.C1;
    C2 = HeatMatrices.C2;
    C4 = HeatMatrices.C4;
    C5 = HeatMatrices.C5;
    C6 = HeatMatrices.C6;
    C7 = HeatMatrices.C7;
    C5_a = HeatMatrices.C5_a;
    C9 = HeatMatrices.C9;
    P_gg = InitialValues.P_gg;
    h = SoilVariables.h;
    T = SoilVariables.T;
    TT = SoilVariables.TT;

    % These are output
    boundaryFluxArray = InitialValues.SAVE;
    RHS = InitialValues.RHS;

    ModelSettings = io.getModelSettings();

    % n is the index of n_th item
    n = ModelSettings.NN;
    if ModelSettings.Thmrlefc && ~ModelSettings.Soilairefc
        RHS(1) = -C9(1) - C7(1) + (C1(1, 1) * h(1) + C1(1, 2) * h(2)) / Delt_t ...
            - (C2(1, 1) / Delt_t + C5(1, 1)) * TT(1) - (C2(1, 2) / Delt_t + C5(1, 2)) * TT(2) ...
            + (C2(1, 1) / Delt_t) * T(1) + (C2(1, 2) / Delt_t) * T(2);
        for i = 2:ModelSettings.NL
            ARG1 = C2(i - 1, 2) / Delt_t;
            ARG2 = C2(i, 1) / Delt_t;
            ARG3 = C2(i, 2) / Delt_t;

            RHS(i) = -C9(i) - C7(i) + (C1(i - 1, 2) * h(i - 1) + C1(i, 1) * h(i) + C1(i, 2) * h(i + 1)) / Delt_t ...
                - (ARG1 + C5(i - 1, 2)) * TT(i - 1) - (ARG2 + C5(i, 1)) * TT(i) - (ARG3 + C5(i, 2)) * TT(i + 1) ...
                + ARG1 * T(i - 1) + ARG2 * T(i) + ARG3 * T(i + 1);
        end
        RHS(n) = -C9(n) - C7(n) + (C1(n - 1, 2) * h(n - 1) + C1(n, 1) * h(n)) / Delt_t ...
          - (C2(n - 1, 2) / Delt_t + C5(n - 1, 2)) * TT(n - 1) - (C2(n, 1) / Delt_t + C5(n, 1)) * TT(n) ...
          + (C2(n - 1, 2) / Delt_t) * T(n - 1) + (C2(n, 1) / Delt_t) * T(n);
    elseif ~ModelSettings.Thmrlefc && ModelSettings.Soilairefc
        RHS(1) = -C9(1) - C7(1) + (C1(1, 1) * h(1) + C1(1, 2) * h(2)) / Delt_t ...
            - C6(1, 1) * P_gg(1) - C6(1, 2) * P_gg(2);
        for i = 2:ModelSettings.NL
            RHS(i) = -C9(i) - C7(i) + (C1(i - 1, 2) * h(i - 1) + C1(i, 1) * h(i) + C1(i, 2) * h(i + 1)) / Delt_t ...
                - C6(i - 1, 2) * P_gg(i - 1) - C6(i, 1) * P_gg(i) - C6(i, 2) * P_gg(i + 1);
        end
        RHS(n) = -C9(n) - C7(n) + (C1(n - 1, 2) * h(n - 1) + C1(n, 1) * h(n)) / Delt_t ...
            - C6(n - 1, 2) * P_gg(n - 1) - C6(n, 1) * P_gg(n);
    elseif ModelSettings.Thmrlefc && ModelSettings.Soilairefc
        RHS(1) = -C9(1) - C7(1) + (C1(1, 1) * h(1) + C1(1, 2) * h(2)) / Delt_t ...
            - (C2(1, 1) / Delt_t + C5(1, 1)) * TT(1) - (C2(1, 2) / Delt_t + C5(1, 2)) * TT(2) ...
            - C6(1, 1) * P_gg(1) - C6(1, 2) * P_gg(2) ...
            + (C2(1, 1) / Delt_t) * T(1) + (C2(1, 2) / Delt_t) * T(2);
        for i = 2:ModelSettings.NL
            ARG1 = C2(i - 1, 2) / Delt_t;
            ARG2 = C2(i, 1) / Delt_t;
            ARG3 = C2(i, 2) / Delt_t;

            RHS(i) = -C9(i) - C7(i) + (C1(i - 1, 2) * h(i - 1) + C1(i, 1) * h(i) + C1(i, 2) * h(i + 1)) / Delt_t ...
                - (ARG1 + C5_a(i - 1)) * TT(i - 1) - (ARG2 + C5(i, 1)) * TT(i) - (ARG3 + C5(i, 2)) * TT(i + 1) ...
                - C6(i - 1, 2) * P_gg(i - 1) - C6(i, 1) * P_gg(i) - C6(i, 2) * P_gg(i + 1) ...
                + ARG1 * T(i - 1) + ARG2 * T(i) + ARG3 * T(i + 1);
        end
        RHS(n) = -C9(n) - C7(n) + (C1(n - 1, 2) * h(n - 1) + C1(n, 1) * h(n)) / Delt_t ...
            - (C2(n - 1, 2) / Delt_t + C5_a(n - 1)) * TT(n - 1) - (C2(n, 1) / Delt_t + C5(n, 1)) * TT(n) ...
            - C6(n - 1, 2) * P_gg(n - 1) - C6(n, 1) * P_gg(n) ...
            + (C2(n - 1, 2) / Delt_t) * T(n - 1) + (C2(n, 1) / Delt_t) * T(n);
    else
        RHS(1) = -C9(1) - C7(1) + (C1(1, 1) * h(1) + C1(1, 2) * h(2)) / Delt_t;
        for i = 2:ModelSettings.NL
            RHS(i) = -C9(i) - C7(i) + (C1(i - 1, 2) * h(i - 1) + C1(i, 1) * h(i) + C1(i, 2) * h(i + 1)) / Delt_t;
        end
        RHS(n) = -C9(n) - C7(n) + (C1(n - 1, 2) * h(n - 1) + C1(n, 1) * h(n)) / Delt_t;
    end

    for i = 1:ModelSettings.NN
        for j = 1:ModelSettings.nD
            C4(i, j) = C1(i, j) / Delt_t + C4(i, j);
        end
    end

    boundaryFluxArray(1, 1, 1) = RHS(1);
    boundaryFluxArray(1, 2, 1) = C4(1, 1);
    boundaryFluxArray(1, 3, 1) = C4(1, 2);
    boundaryFluxArray(2, 1, 1) = RHS(n);
    boundaryFluxArray(2, 2, 1) = C4(n - 1, 2);
    boundaryFluxArray(2, 3, 1) = C4(n, 1);

    HeatMatrices.C4 = C4;
end
