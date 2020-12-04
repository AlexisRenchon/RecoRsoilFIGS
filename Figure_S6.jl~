# Time series, data vs. model
# 4 panels: 3 chambers Rsoil, 1 Reco

using DataFrames, CSV, AbstractPlotting, CairoMakie, Dates, AbstractPlotting.MakieLayout, UnicodeFun 
using PlotUtils: optimize_ticks

# Read input file
Data = CSV.read("AUCum_Reco_Rsoil_soilvars_2014_2017.csv", DataFrame, dateformat = "mm/dd/yyyy HH:MM")

# Trick until Makie.jl can work with datetime values
Dtime_all_rata = datetime2rata.(Data.DateTime)
dateticks = optimize_ticks(Data.DateTime[1],Data.DateTime[end])[1]

# Define layouting config
scene = Scene(resolution = (860, 950), camera=campixel!);
layout = GridLayout(
		    scene, 4, 1, 
		    colsizes = [Auto()],
		    rowsizes = [Auto(), Auto(), Auto(), Auto()],
		    alignmode = Outside(10, 10, 10, 10)
		    )

# Define axis
ax = Array{LAxis}(undef, 4)

# Define axis options
ax[1] = layout[1, 1] = LAxis(scene, ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"),xticklabelsvisible = false, xticksvisible = false, ygridvisible = false, xgridvisible = false);
ax[2] = layout[2, 1] = LAxis(scene, ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"),xticklabelsvisible = false, xticksvisible = false, ygridvisible = false, xgridvisible = false);
ax[3] = layout[3, 1] = LAxis(scene, ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"),xticklabelsvisible = false, xticksvisible = false, ygridvisible = false, xgridvisible = false);
ax[4] = layout[4, 1] = LAxis(scene, ylabel = to_latex("Reco (\\mumol m^{-2} s^{-1})"), xlabel="Date", ygridvisible = false, xgridvisible = false);

# Add plots inside axis
sR2_data = scatter!(ax[1], Dtime_all_rata[findall(!iszero, Data.Rsoil_R2_qc)], Data.Rsoil_R2[findall(!iszero, Data.Rsoil_R2_qc)], color = :blue, markersize = 2, strokewidth = 0); 
sR2_model = scatter!(ax[1], Dtime_all_rata[findall(iszero, Data.Rsoil_R2_qc)], Data.Rsoil_R2[findall(iszero, Data.Rsoil_R2_qc)], color = :red, markersize = 2, strokewidth = 0); 

sR3_data = scatter!(ax[2], Dtime_all_rata[findall(!iszero, Data.Rsoil_R3_qc)], Data.Rsoil_R3[findall(!iszero, Data.Rsoil_R3_qc)], color = :blue, markersize = 2, strokewidth = 0); 
sR3_model = scatter!(ax[2], Dtime_all_rata[findall(iszero, Data.Rsoil_R3_qc)], Data.Rsoil_R3[findall(iszero, Data.Rsoil_R3_qc)], color = :red, markersize = 2, strokewidth = 0); 

sR6_model = scatter!(ax[3], Dtime_all_rata[findall(!iszero, Data.Rsoil_R6_qc)], Data.Rsoil_R6[findall(!iszero, Data.Rsoil_R6_qc)], color = :blue, markersize = 2, strokewidth = 0); 
sR6_model = scatter!(ax[3], Dtime_all_rata[findall(iszero, Data.Rsoil_R6_qc)], Data.Rsoil_R6[findall(iszero, Data.Rsoil_R6_qc)], color = :red, markersize = 2, strokewidth = 0); 

sReco = scatter!(ax[4], Dtime_all_rata[1:end], Data.ERmodel[1:end], color = :red, markersize = 2, strokewidth = 0);


xlims!(ax[1], (Dtime_all_rata[1], Dtime_all_rata[end]))
xlims!(ax[2], (Dtime_all_rata[1], Dtime_all_rata[end]))
xlims!(ax[3], (Dtime_all_rata[1], Dtime_all_rata[end]))
xlims!(ax[4], (Dtime_all_rata[1], Dtime_all_rata[end]))

# Ticks as date
ax[1].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yy"))
ax[2].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yy"))
ax[3].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yy"))
ax[4].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yy"))

ylims!(ax[1], (0, 10))
ylims!(ax[2], (0, 10))
ylims!(ax[3], (0, 10))
ylims!(ax[4], (0, 10))

# Save figure
AbstractPlotting.save("fig.png",scene)




