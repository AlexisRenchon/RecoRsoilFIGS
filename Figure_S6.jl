# Time series, data vs. model
# 4 panels: 3 chambers Rsoil, 1 Reco

using DataFrames, CSV, AbstractPlotting, CairoMakie, Dates, AbstractPlotting.MakieLayout, UnicodeFun 
using PlotUtils: optimize_ticks

# Read input data and fit DAMM model
include("DAMM_LsqFit.jl");

# Trick until Makie.jl can work with datetime values
Dtime_all_rata = datetime2rata.(df.DateTime)
dateticks = optimize_ticks(df.DateTime[1],df.DateTime[end])[1]

# Define layouting config
scene = Scene(resolution = (860, 950), camera=campixel!);
layout = GridLayout(
		    scene, 4, 1, 
		    colsizes = [Auto()],
		    rowsizes = [Auto(), Auto(), Auto(), Auto()],
		    alignmode = Outside(5, 30, 5, 20)
		    )

# Define axis
ax = Array{LAxis}(undef, 5)

# Define axis options
ax[1] = layout[1, 1] = LAxis(scene, ylabel = "",xticklabelsvisible = false, xticksvisible = false, ygridvisible = false, xgridvisible = false);
ax[2] = layout[2, 1] = LAxis(scene, ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"),xticklabelsvisible = false, xticksvisible = false, ygridvisible = false, xgridvisible = false);
ax[3] = layout[3, 1] = LAxis(scene, ylabel = "",xticklabelsvisible = false, xticksvisible = false, ygridvisible = false, xgridvisible = false);
ax[4] = layout[4, 1] = LAxis(scene, ylabel = to_latex("Reco (\\mumol m^{-2} s^{-1})"), xlabel="Year", ygridvisible = false, xgridvisible = false);

# Add plots inside axis
sR2_data = scatter!(ax[1], Dtime_all_rata[findall(!iszero, df.Rsoil_R2_qc)], df.Rsoil_R2[findall(!iszero, df.Rsoil_R2_qc)], color = :blue, markersize = 2, strokewidth = 0); 
sR2_model = scatter!(ax[1], Dtime_all_rata, Modeled_data_R2, color = RGBAf0(1,0,0,.1), markersize = 2, strokewidth = 0); 

sR3_data = scatter!(ax[2], Dtime_all_rata[findall(!iszero, df.Rsoil_R3_qc)], df.Rsoil_R3[findall(!iszero, df.Rsoil_R3_qc)], color = :blue, markersize = 2, strokewidth = 0); 
sR3_model = scatter!(ax[2], Dtime_all_rata, Modeled_data_R3, color = RGBAf0(1,0,0,.1), markersize = 2, strokewidth = 0); 

sR6_data = scatter!(ax[3], Dtime_all_rata[findall(!iszero, df.Rsoil_R6_qc)], df.Rsoil_R6[findall(!iszero, df.Rsoil_R6_qc)], color = :blue, markersize = 2, strokewidth = 0); 
sR6_model = scatter!(ax[3], Dtime_all_rata, Modeled_data_R6, color = RGBAf0(1,0,0,.1), markersize = 2, strokewidth = 0); 

these = findall((df.qc .< 2) .& (df.qc_Sc .<0.5) .& (df.AGC_c .< 0.5) .& (df.daytime .< 0.5))
sReco_data = scatter!(ax[4], Dtime_all_rata[these], df.NEE[these], color = :blue, markersize = 2, strokewidth = 0);
sReco_model = scatter!(ax[4], Dtime_all_rata[1:end], df.ERmodel[1:end], color = RGBAf0(1,0,0,.1), markersize = 2, strokewidth = 0);


xlims!(ax[1], (Dtime_all_rata[1], Dtime_all_rata[end]))
xlims!(ax[2], (Dtime_all_rata[1], Dtime_all_rata[end]))
xlims!(ax[3], (Dtime_all_rata[1], Dtime_all_rata[end]))
xlims!(ax[4], (Dtime_all_rata[1], Dtime_all_rata[end]))

# Ticks as date
ax[1].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yyyy"))
ax[2].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yyyy"))
ax[3].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yyyy"))
ax[4].xticks[] = (datetime2rata.(dateticks), Dates.format.(dateticks, "yyyy"))

ylims!(ax[1], (0, 10))
ylims!(ax[2], (0, 10))
ylims!(ax[3], (0, 10))
ylims!(ax[4], (0, 10))

legends = layout[1, 1] = LLegend(scene, [sR2_data, sR2_model], ["Data", "Model"], orientation = :horizontal, tellheight = false, tellwidth = false, halign = :right, valign = :top); 
text_R2 = layout[1, 1] = LText(scene, "#2", textsize = 15, halign = :left, valign = :top, tellheight = false, tellwidth = false, padding = (5, 5, 5, 5)) 
text_R3 = layout[2, 1] = LText(scene, "#3", textsize = 15, halign = :left, valign = :top, tellheight = false, tellwidth = false, padding = (5, 5, 5, 5))
text_R6 = layout[3, 1] = LText(scene, "#6", textsize = 15, halign = :left, valign = :top, tellheight = false, tellwidth = false, padding = (5, 5, 5, 5))

# Save figure
AbstractPlotting.save("fig.png", scene, px_per_unit = 3)

