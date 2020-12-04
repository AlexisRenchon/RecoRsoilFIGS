# Least square error fit of the DAMM model to data
using LsqFit, CSV, DataFrames

# Load fixed param
#EaSx = 53 
R = 8.314472*10^-3 # Universal gas constant
Dl = 3.17 # Diffusion coeff of substrate in liquid phase
Sxt = 0.0125 # Soil C content
p = 2.4*10^-2 # Fraction of soil C that is considered soluble
Dgas = 1.67 # Diffusion coefficient of oxygen in air
# Db = 1.53 # Soil bulk density !! DAMM complex if SWC > 0.365. old 1.5396
Db = 1.43
Dp = 2.52 # Soil particle density

# DAMM model, !for the algorithm to work, Param are scaled to be of similar magnitude
@. multimodel(Ind_var, Param) = (1e8*Param[1]*exp(-Param[2]/(R*(273.15+Ind_var[:, 1]))))* 
(((p*Sxt)*Dl*Ind_var[:, 2]^3)/(1e-8*Param[3]+((p*Sxt)*Dl*Ind_var[:, 2]^3)))* 
((Dgas*0.209*(1-Db/Dp-Ind_var[:, 2])^(4/3))/ 
 (1e-3*Param[4]+(Dgas*0.209*(1-Db/Dp-Ind_var[:, 2])^(4/3))))* 
10000*10/1000/12*1e6/60/60 

# Example
Param = Param_ini = [1.0, 62.0, 3.46, 2.0] # Scaled Param, as explained above. AlphaSx, EaSx, kMsx, kMo2
Ind_var = [15.0 0.3; 8 0.3]
multimodel(Ind_var, Param)

# Load data
df = CSV.read("AUCum_Reco_Rsoil_soilvars_2014_2017.csv", DataFrame, dateformat="mm/dd/yyyy HH:MM")
Rsoil2 = Dep_var2 = df.Rsoil_R2[findall(!iszero, df.Rsoil_R2_qc)]
Rsoil3 = Dep_var3 = df.Rsoil_R3[findall(!iszero, df.Rsoil_R3_qc)]
Rsoil6 = Dep_var6 = df.Rsoil_R6[findall(!iszero, df.Rsoil_R6_qc)]
Ind_var2 = hcat(df.Ts_R2[findall(!iszero, df.Rsoil_R2_qc)], df.SWC_R2[findall(!iszero, df.Rsoil_R2_qc)])
Ind_var3 = hcat(df.Ts_R3[findall(!iszero, df.Rsoil_R3_qc)], df.SWC_R3[findall(!iszero, df.Rsoil_R3_qc)])
Ind_var6 = hcat(df.Ts_R6[findall(!iszero, df.Rsoil_R6_qc)], df.SWC_R6[findall(!iszero, df.Rsoil_R6_qc)])


# Fit DAMM to data

Db = 1.64
fit = curve_fit(multimodel, Ind_var2, Dep_var2, Param_ini) # For DAMM, Ind_var is Tsoil and SWC, Dep_var is Rsoil
Param_fit = coef(fit)
Modeled_data_R2 = multimodel(hcat(df.Ts_R2, df.SWC_R2),Param_fit)

Db = 1.64
fit = curve_fit(multimodel, Ind_var3, Dep_var3, Param_ini) # For DAMM, Ind_var is Tsoil and SWC, Dep_var is Rsoil
Param_fit = coef(fit)
Modeled_data_R3 = multimodel(hcat(df.Ts_R3, df.SWC_R3),Param_fit)

Db = 1.52
fit = curve_fit(multimodel, Ind_var6, Dep_var6, Param_ini) # For DAMM, Ind_var is Tsoil and SWC, Dep_var is Rsoil
Param_fit = coef(fit)
Modeled_data_R6 = multimodel(hcat(df.Ts_R6, df.SWC_R6),Param_fit)


