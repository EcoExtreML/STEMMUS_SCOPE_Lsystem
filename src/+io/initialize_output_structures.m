function [rad,thermal,fluxes] = initialize_output_structures(spectral)

[    fluxes.Rntot,     fluxes.lEtot,      fluxes.Htot,   fluxes.Atot            ,...
    fluxes.Rnctot,    fluxes.lEctot,     fluxes.Hctot,  fluxes.Actot           ,...
    fluxes.Rnstot,    fluxes.lEstot,     fluxes.Hstot,  fluxes.Gtot,   fluxes.Resp    ,...
    thermal.Tcave,    thermal.Tsave   ,...
    thermal.raa,      thermal.rawc,       thermal.raws,   thermal.ustar           ,...
    rad.Lout,      rad.Loutt ,  rad.Eoutte, rad.PAR  ]      =   deal(NaN);
thermal.Ts                             =        NaN(2,1);
%Fc                                 =   deal(NaN(nl,1));

[rad.LoF_      ,...
    rad.Fhem_]           = deal(NaN(size(spectral.wlF,1),1));

[rad.Eouto, rad.Eout ] = deal(NaN);
[rad.Lout_,rad.Lo_]                   =   deal(NaN(size(spectral.wlS,1)),1);
thermal.Ta = NaN;