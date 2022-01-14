function [Rl] = Initial_root_biomass(RTB,DeltZ_R,rroot,ML)
global Ztot
%rri=zeros(1,45);
root_den = 250*1000; %% [gDM / m^3] Root density  Jackson et al., 1997 
R_C = 0.488; %% [gC/gDM] Ratio Carbon-Dry Matter in root   Jackson et al.,  1997 
beta = 0.993; %% ? is a plant-dependent root distribution parameter adopted from Jackson et al. (1996) 
Rltot = RTB/R_C/root_den/(pi*(rroot^2)); %% %% root length index [m root / m^2 PFT]
    %Ztot=DeltZ';
   % Ztot=flip(Ztot);
    Ztot=cumsum(DeltZ_R',1); 
    %Ztot=flip(Ztot);
for i=1:ML
    if i==1
        ri(i)=(1-beta.^(Ztot(i)/2));
    else
        ri(i)=beta.^(Ztot(i-1)-(DeltZ_R(i-1)/2))-beta.^(Ztot(i-1)+(DeltZ_R(i)/2));
    end
end
%for i=1:ML
%    if i==1
 %       rri(i)=ri(i)./2;
 %   else
  %      rri(i)=(ri(i)+ri(i-1))./2;
 %   end
%end
Rl=(ri.*Rltot./(DeltZ_R./100))';
Rl=flipud(Rl);
end