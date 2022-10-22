##================================================================================================##
#                                                                                                  #
#             ____                  _       __  ____       __                                      #
#            /  _/___  ____  ____ _(_)___  / /_/ __ \___  / /___  ____  ____                       #
#            / // __ \/ __ \/ __ `/ / __ \/ __/ / / / _ \/ / __ \/ __ `/ __ \                      #
#          _/ // / / / /_/ / /_/ / / / / / /_/ /_/ /  __/ / /_/ / /_/ / /_/ /                      #
#         /___/_/ /_/ .___/\__,_/_/_/ /_/\__/_____/\___/_/\____/\__, /\____/                       #
#                  /_/                                         /____/                              #
#                                                                                                  #
##================================================================================================##


#  InpaintDelogo is an advanced logo and watermark removal function using inpainting and deblending
# with an adjustable fine process to hide artifacts and get best delogo results.
# Can remove opaque, transparent, semi-transparent and some dynamic logos from video.
# Can be used to remove hardcoded subtitles or extract them to images for OCR.

#  Inpainting refers to the application of sophisticated algorithms to reconstruct of lost
# or deteriorated parts of images or videos.


##================================================================================================##
#   Version: 3.2                                                                                   #
##================================================================================================##


# Author       : VoodooFX

# Doom9 link   : https://forum.doom9.org/showthread.php?p=1883832
# GitHub link  : https://github.com/Purfview/InpaintDelogo


# Version 3.2  : 2022/10/22.  New feature: Conditional optimizations with "Optimize", enabled by default.
#                                          Up to ~1000% speed-up for slow "Inpaint" & "Interp" presets.
#                                          Additional auto "Interp" disabling.
#                             New feature: Negative "dPP"/"oPP", adds denoise, enabled by default [20%-50% slow down].
#                             Very slow inpainting preset: Turbo=-2.
#                             Quick masks dump with clean "outs": DumpMasks=2.
#                             Various other tweaks.
#                             FFT3DFilter plugin is required.
# Version 3.1  : 2022/10/11.  Fixed: "Deblend" with positive "Analyze" was unreliable on the colored logos.
# Version 3.00 : 2022/10/07.  Fixed: A frame selection scan result wasn't saved properly when "Automask=1" and "Inpaint" mode,
#                                    now the deblending masks generation is up to twice faster in this scenario.
#                             New feature: Easy use of the ebmp masks on other videos, you can input them directly with "Mask" parameter.
#                                          Ebmp format is changed, the masks from older versions are not compatible.
#                             New feature: Twice faster subtitles extraction with auto intermediate file.
#                                          It's activated by negative "Extract" values.
#                                          Requirements: LSMASH, TWriteAVI, x264vfw.
#                                          New params: "ReExtract", "FourCC".
#                             New feature: Adjustable subs detection window, useful if video has non-middle subs alignment.
#                                          New params: "DetWinPercW", "DetWinPercH", "DetWinHoPos".
#                                          With "Show=12" you can see the subs detection window and correlation coefficient [CorrTh/Corr].
#                             New: "Turbo=-1", it activates an inpainting preset more suitable for UHD - HD resolutions.
#                             New: "IntSpd=4", similar as above.
#                             Basemask change: Background should be less than full white, logo - full white.
#                             Swapped "Turbo" 1 & 3.
#                             Removed "rSize" parameter.
#                             Reworked "Show=2", alternative to "Show=1" for positive Analyze.
#                             New feature: Various parameters to manipulate the deblending masks from positive analyze [for the experts only]:
#                                          "YAlphaTweak", "UAlphaTweak", "VAlphaTweak",
#                                          "YAlphaSolidIns", "UAlphaSolidIns", "VAlphaSolidIns",
#                                          "YAlphaSolidOuts", "UAlphaSolidOuts", "VAlphaSolidOuts",
#                                          "YColorSolid", "UColorSolid", "VColorSolid",
#                                          "YColorSolidOuts", "UColorSolidOuts", "VColorSolidOuts",
#                                          "YColorSolidIns", "UColorSolidIns", "VColorSolidIns",
#                                          "YOffsetIns", "YOffsetOuts", "UVOffsetIns", "UVOffsetOuts", "ShiftMasksVe", "ShiftMasksHo",
#                                          "YAlphaExternal", "WholeDeblend", "TriggerDynamic", "DumpMasks".
#                             Various other tweaks.
#                             Avisynth+ v3.7.2 or later is required.
#
#---------------------------------------------------------------------------------------------------
#
# Version 2.17 : 2022/06/13.  Option for ranged luma mask with DynMask6.
# Version 2.16 : 2022/06/12.  Higher quality and faster "DynColor" mask when used with "DynLocUp".
#                             Faster "DynColor" alternative if parameter is string, and it supports multiple colors.
#                             TColorMask plugin is required.
# Version 2.15 : 2022/05/29.  Spaces are allowed in "Loc".
# Version 2.14 : 2022/05/22.  SubsMask2Img: New option to extract raw non-binarized images.
#                             Enabled by "Extract=2" in InpaintDelogo() or "Raw" in SubsMask2Img().
#                             New: "Raw", "RawAvr".
# Version 2.13 : 2022/05/21.  SubsMask2Img: Added average luma check to catch non-sub images.
#                             New: "SubMinLuma", "SubSusLuma".
#                             Renamed: "SubSuspect" to "SubSusDur".
# Version 2.12 : 2022/05/14.  Added generation of the dynamic mask by gradient magnitude map (aka "DynMask=7"/"DynTEdge").
#                             New: "DynTEdge", "DynTEdgeThY", "DynTEdgeInf", "DynTuneInf", Show=10, Show=11.
#                             vsTEdgeMask plugin is required.
# Version 2.11 : 2022/05/13.  Rewrite: "DynColor" ~30%-300% faster. New: "DynMask=6/"DynTune". Removed: "Show=10".
# Version 2.10 : 2022/05/02.  Added auto generation of the dynamic mask by color (aka "DynMask=5"/"DynColor").
#                             New: "DynColor", "DynColorTol", "DynColorInf", "Show=10".
#                             This dynamic mask by color can pre-patch video for other "DynMask" methods.
# Version 2.09 : 2022/04/08.  Positive "DynMaskUp" is supported with "DynMask=3".
#                             Improved "KillNoise".
# Version 2.08 : 2022/04/07.  Improved negative "KillBlobs".
# Version 2.07 : 2022/04/06.  Changed defaults of the sub-parameters for "DynMask=3" (no need to set the bunch of parameters anymore).
# Version 2.06 : 2022/04/06.  Fixed: "Show=3" was broken since v1.36.
# Version 2.05 : 2022/04/04.  Masktools2 v2.2.30 or later is required.
#                             Tweaked: "DynMask=4" and positive "DynMaskUp", should be a bit faster and no more glitches on SD sources.
#                             New: "DynLocUp" [Experimental WIP parameter for tests].
# Version 2.04 : 2022/02/11.  Improved deblend quality with positive "Analyze" when frames quantity to analyze is low.
#                             Tweaked: A/C masks filename from negative "Analyze" ('Deep' goes to the end of the filename).
#                             Tweaked: "iTune", "EdgeWide".
# Version 2.03 : 2021/12/13.  Tweaked "DynTune".
# Version 2.02 : 2021/12/10.  Fixed: "Analyze=1" bug.
#                             +11% deblend speed-up.
#                             Tweaked "aMix". "Analyze=2" is default. Adaptive "AnalyzeTh" default [16 or 30].
#                             Don't search frames for analyse if 'txt' file is present and ReAnalyze=0.
# Version 2.01 : 2021/12/05.  "Analyze" 3 option.
# Version 2.00 : 2021/12/04.  AviSynth+ v3.7.1 or later & FrameSel plugin is required.
#                             New: Old Deblend delogo is superceded by the new superior one.
#                             New: Smart frames selection for analyze using "AnalyzeTh" & "NoBorderAt" parameters.
#                             New: "Automask" adapted to the new stuff and it doesn't reanalyze when "aMix" is adjusted.
#                             New: "Show" 7/8/9.
#                             Note: Old Deblend is saved as negative "Analyze",
#                                   -3/-4 should be same as old, -1/-2 were augmented by the smart frames selection.
#
#---------------------------------------------------------------------------------------------------
#
# Version 1.48 : 2021/11/12.  Fixed: "Show=5" was broken since v1.36.
# Version 1.47 : 2021/11/11.  Fixed: "Double Gscript".
# Version 1.46 : 2021/11/11.  Support for AviSynth v2.6 [with the StainlessS's help].
# Version 1.45 : 2021/11/07.  Fixed: Automask wasn't working if coords were "0,0,0,0".
# Version 1.44 : 2021/11/05.  Refactored multipass deblending code.
# Version 1.43 : 2021/11/03.  Fixed: One pass Deblend didn't see A/C masks from multi pass. Changed: "Deep".
# Version 1.42 : 2021/11/03.  Fixed: A/C masks file name if coord is "-0".
# Version 1.41 : 2021/11/03.  Fixed: "Show=1" was broken with "Deblend" since v1.18.
# Version 1.40 : 2021/10/28.  Some speed optimizations. AvsInpaint v1.3 is required.
# Version 1.39 : 2021/10/23.  Various improvements.
# Version 1.38 : 2021/10/22.  Fixed: Bug with "SubSuspect" parameter.
# Version 1.37 : 2021/10/07.  New: "DynMaskUp" parameter.
# Version 1.36 : 2021/10/04.  Added auto generation of the dynamic mask for subtitles with halo (aka "DynMask=4").
#                             Updated: "KillNoise", and some other tweaks.
# Version 1.35 : 2021/09/23.  Fixed: Bug with "TuneH1".
# Version 1.34 : 2021/09/21.  New: "Extract" parameter to extract subtitles to images for OCR.
#                             New: 'SubsMask2Img()' func (mod of StainlessS's 'DetSub_Extract()').
#                             Note: This version needs AviSynth+.
# Version 1.33 : 2021/08/31.  New: "DynMask3H", "ModeSH", "TuneH1", TuneH2", "TuneH3", "KillNoiseH, "rePassH".
#                             Updated: "Show", "DynTune".
# Version 1.32 : 2021/08/25.  Fixed illogical Y8/YV12 conversions in the dynamic mask routines. ~20% faster.
#                             External dynamic mask expected to be Y8.
# Version 1.31 : 2021/08/22.  New: "KillBlobs", "preBlobs", "RePass". Updated: "DynInflate", "KillNoise".
# Version 1.30 : 2021/08/13.  Fixed TV levels in "Show" 5 mask.
# Version 1.29 : 2021/08/13.  "mShow" 9.
# Version 1.28 : 2021/08/13.  Changed "Dyn3Seq" & "ClpBlend" range limit. "Interp" 4.
# Version 1.27 : 2021/08/13.  "Show" 5 outputs full size Dynamic PP mask.
# Version 1.26 : 2021/08/13.  "DynInflate" up to 4px.
# Version 1.25 : 2021/08/13.  Fixed/expanded "DynTune".
# Version 1.24 : 2020/11/28.  Various tweaks. "Show" 3 & 4. Updated the manual with the new stuff.
# Version 1.23 : [non public] Added auto generation of a dynamic mask with ClipBlend (aka "DynMask=3").
#                             New parameters: "Dyn3Seq", "ClpBlend", "DynPostTune", "Dyn3buffer".
# Version 1.22 : [non public] Optimized speed for a dynamic mask, MaskTools2 required.
# Version 1.21 : [non public] Added support for the mask clips and a dynamic mask.
#                             Added basic auto generation of a dynamic mask (aka "DynMask=2").
#                             New parameters: "DynMask", "DynInflate", "DynTune", "KillNoise", "maskPatch".
# Version 1.20 : [non public] "Turbo" presets moved from soft to hard. iTune & Edge masks to "Show".
# Version 1.19 : [non public] New "IntSpd" parameter for "Interp" & the slow modes for "EdgePP".
# Version 1.18 : [non public] New "EdgePP", "EdgePos" & "EdgeWide" parameters. EdgeMask to "mShow".
# Version 1.17 : [non public] New "iTinflate" & "oTinflate" parameters. Interp/iTune mask to "mShow".
# Version 1.16 : [non public] New "diPP" & "diPPm" parameters.
# Version 1.15 : [non public] New mode for "InterpM", (-1) takes mask from new "iTune" parameter.
# Version 1.14 : [non public] "Fr1"/"Fr2" are renamed to "FrB"/"FrW". "GrainPP" is off by default.
# Version 1.13 : 2019/12/08.  Allow -ve LogoX,LogoY, and +ve LogoW,LogoH in Loc string (by StainlessS).
# Version 1.12 : 2019/09/06.  Various tweaks. New parameters. "Inflate" and "Deep" changed.
# Version 1.11 : 2019/08/31.  First public release.


##================================================================================================##
#   Requirements :                                                                                 #
##================================================================================================##


#   Core requirements:
#  AviSynth+ v3.7.2 or later ( https://github.com/AviSynth/AviSynthPlus ).
#  AvsInpaint v1.3 or later  ( https://github.com/pinterf/AvsInpaint ).

#   Other requirements:
#  MaskTools2    ( https://github.com/pinterf/masktools ).
#  RgTools       ( https://github.com/pinterf/RgTools ).
#  GRunT         ( https://github.com/pinterf/GRunT ).
#  RequestLinear ( https://github.com/pinterf/TIVTC ).
#  ClipBlend     ( http://avisynth.nl/index.php/ClipBlend ).
#  RT_Stats      ( http://avisynth.nl/index.php/RT_Stats ).
#  FrameSel      ( http://avisynth.nl/index.php/FrameSel ).
#  GrainFactory3 ( http://avisynth.nl/index.php/GrainFactory3 ).
#  vsTEdgeMask   ( https://github.com/Asd-g/AviSynth-vsTEdgeMask ).
#  TColorMask    ( https://github.com/Asd-g/AviSynth-tcolormask ).
#  FFT3DFilter   ( http://avisynth.nl/index.php/FFT3DFilter ).

#   Requirements for fast subtitles extraction:
#  LSMASH        ( http://avisynth.nl/index.php/LSMASHSource ).
#  TWriteAVI     ( https://github.com/Asd-g/AviSynth-TWriteAVI ).
#  x264vfw       ( https://sourceforge.net/projects/mpxplay/files/x264vfw ).


##================================================================================================##
#   InpaintLoc() manual:                                                                           #
##================================================================================================##


#  This function will help you to determine "Loc" values.

# string "Loc" :  Select a part of picture around the logo, it's similar as Crop().
#
#                Use ("Left,Top,-Right,-Bottom") or ("Left,Top, Width, Height") coordinates.
#
#                Use even(mod2) numbers.
#                Include 10(no less!) - ~20 pixel borders around logo! No less than 18 is recommended for HD-UHD.
#                Black or other borders shouldn't be present in the "Loc" area.
#                The selected area will be highlighted.


##================================================================================================##
#   InpaintDelogo()  manual:                                                                       #
##================================================================================================##


                 #=========================#
                 #    Short basic guide:   #
                 #=========================#

#     ( Things you need before starting delogo )
#
# 0)  Read help/manual(in the script) about parameters mentioned below.
# 1)  Run this function to get "Loc" values: InpaintLoc(Loc="100,100,-100,-100"). Adjust "Loc" crop parameters around logo (aka "Left,Top,-Right,-Bottom"). Use even(mod2) numbers.
# 2)  Prepare the "mask" manually, or start InpaintDelogo with "Automask=1" and "Analyze=2", automask result can be adjusted with"aMix".

#  Basic example for non-transparent logo:
/*

InpaintDelogo( mask="D:\mask.bmp", Automask=0, aMix=0, Loc="100,100,-100,-100", Mode="Inpaint")

*/

                 #=================#
                 #   Parameters:   #
                 #=================#

# String "Loc" :      Select a part of picture around the logo, it's similar as Crop().
#                     Use ("Left,Top,-Right,-Bottom") or ("Left,Top, Width, Height") coordinates.
#
#                     Use even(mod2) numbers.
#                     Include 10(no less!) - ~20 pixel borders around logo! No less than 18 is recommended for HD-UHD.
#                     Black or other borders shouldn't be present in the "Loc" area.


# val "mask"        : File based bmp mask:
#                     Full path to a basemask of logo, an image where Logo is full white and background is less than full white.
#                     Example: mask="C:\mymask.bmp".
#                     Resolution of the image must be same as video clip's frame.
#                     Don't include surrounding bleed of the logo, just exact logo.
#                      Actually script is not strict about a format of the picture, it will
#                     convert whatever you give to a Black/White mask.
#                      You can use "Automask" option to auto-generate the base mask.
#
#                     File based ebmp masks:
#                     Full path to ebmp file. [pre v3 ebmp's are incompatible]
#                     You can use ebmp deblending masks from other videos.
#                     Adjust logo position with "Loc"s Left & Top coord, other coords are ignored. ["ShiftMasksVe", "ShiftMasksHo" can be used to move 1px.]
#                     Ignored parameters: "Automask", "ReAnalyze", "Analyze", "Deep".
#                     Filename of ebmp file doesn't matter.
#
#                     Clip based mask:
#                     "mask" accepts clip input, resolution must be same as "Loc" area.
#                     Dynamic mask expected to be full range Y8 or will be converted.
#                     Static mask must be one frame clip otherwise it will be treated as a dynamic mask.


# Int "Automask"    :  It's like a different function when On, just generates the base mask
#                     of the logo, then you need to turn it off.
#                     "Analyze" and its sub-parameters, "aMix", "mask", "Loc", "ReAnalyze", "AnalyzeTh" & "NoBorderAt" parameters will be used.
#                     "Loc" would be best 10(no less) pixels from the logo edges.
#                     Needs "mask" defined with path to imaginary bmp picture, that's where
#                     the base mask will be generated.
#                     Best should be "Analyze" method "2".
#
#                     0 - Off (default).
#                     1 - On. Generates the base mask. Script doesn't do anything else when "On"!


# Int "aMix"        :  Parameter is only for "Automask=1" (from -50 to 5; default: 0).
#                     Lower values = "thinner" mask, higher = "thicker" mask.
#                     Adjust it to generate precise mask of the logo, sometimes it's not possible
#                     then create a mask manually with Photoshop ect..
#                     No need to include the surrounding bleed of the logo.


# Int "Inflate"     :  Inflates the base mask.
#
#                     0 - Disabled.
#                     1 - Inflate by 1 pixel  (default).
#                     2 - Inflate by 2 pixels.


# String "Mode"     :  Delogo mode (default: Inpaint; default if mask=...ebmp: Deblend).
#                     Inpaint - Use if logo is opaque/hardly transparent.
#                     Deblend - Use if logo is transparent.
#                     Both    - Use if logo is both: a logo has transparent and opaque/hardly transparent parts.


# Int "Analyze"     :  Analyze methods for deblend/transparent logo ("Deblend" & "Both" modes). (from -4 to 3)
#                     It creates Color & Alpha masks for deblending, ebmp filename will be unique with every "Analyze" setting in the filenames.
#                     Do "Analyze" and delogo only on frames with logo present! No animations too.
#                     Not MT compatible, don't use Prefetch() when doing analysis.
#                     Note: Clip is parsed ~few times when doing analysis, so keep that in mind if there is heavy filtering like QTGMC
#                           in a script before InpaintDelogo, then faster is to make an intermediate lossless encode before doing analysis and delogo.
#                     When "Automask=1" it creates the base mask, nothing else!!!
#                     (Adaptive default: 0 - forced for "Inpaint" mode; 2 - for other modes)
#
#                     0 - "Disabled". Not selectable.
#
#                     1 -  Smart auto selection of good frames to analyze.
#                         Scans whole clip and checks only pixels at the edges of the base mask (~2|3 pxs offset).
#                         Should be more precise than 2, but it can't be used for "Automask=1".
#
#                     2 -  Smart auto selection of good frames to analyze.
#                         Scans whole clip and checks only at the edges of the "Loc" (4 pxs offset).
#                         "NoBorderAt" parameter must be set accordingly.
#
#                     3 -  Analyzes all frames, doesn't run the selection of frames.
#
#
#                     # Old deprecated inferior deblend:
#                     # Still here for some exotic use cases, for example to deblend the image file or very short video...
#
#                    -1 - Mirrors frame selection of method 1, but it's not the same.
#
#                    -2 - Mirrors frame selection of method 2, but it's not the same.
#
#                    -3 -  Manual analysis.
#                         You need one frame where logo area is in a solid black/dark background and another one in a solid white/bright background.
#                         These two frames must be set with "FrB" & "FrW" parameters and optional "FrS".
#
#                    -4 -  Manual analysis.
#                         OK (in most cases) for the basemask generation with "Automask".
#                         For delogo it's not good, use only if there is no white/bright frame in video and methods "-1/-2" are worse.
#                         Use only on white logos, will not deblend colored parts of the logo.
#                         Setup is similar as method "-3", just without "FrW" (it will be ignored).


# Int "AnalyzeTh"   :   MinMax threshold. (from 1 to 255; Adaptive default: if clip is > ~30 mins then to 16 or 30)
#                      Parameter only for "Analyze" 1/2/-1/-2.
#                      Used to auto select the solid looking frames suitable for analysis.
#                      1 - very solid, 255 - usually almost all frames will be selected for analysis.
#                      Probably no need to touch it in the most cases.
#                      Analysis needs higher amount of various frames to create the better Color/Alpha masks, but non solid frames can introduce artifacts into masks.
#                      Txt file with found frames will be created (same filename as the Color/Alpha masks ebmp file).
#                      If there are less that ~1000 frames found then try to set to 30 or higher.
#                      "Show" 7/8/9 can be used to check stuff.


# String "NoBorderAt" :  Parameter only for "Analyze" 2/-2.
#                       Must be set accordingly if there is no border between logo and "Loc" border, or there is less than 10 pixels.
#                       Accepts: "top", "bottom", "left", "right" or "none" (default: "none")


# Int "ReAnalyze"   :  Repeats analysis on every script load. (default: 0)
#
#                     0 - Off. logo analysis is not computed if Color/Alpha masks and the selected frames txt files are present.
#                     1 - On. Logo analysis is always computed even when Color/Alpha masks and the selected frames txt files are present.


#   Parameters only for old (deprecated) Analyze methods:
#=============================================================================================================
# Int "Deep"        :  Multi pass deblending and analyze is activated with this option.
#                     Reduce discoloration artifacts, less logo remnants.
#                     Less transparent logo - bigger effect, sometimes no effect at all.
#
#                     1 - Disabled (1-pass).
#                     2 - 2-pass.
#                     3 - 3-pass (default).
#                     4 - 4-pass.
#                     5 - 5-pass.


# Int "FrB"        : Frame number of the black/dark frame for manual "Analyze" (default: 0).


# Int "FrW"        : Frame number of the white/bright frame for manual "Analyze" (default: 0).


# Int "FrS"        :  Extended sequences of the frames for manual "Analyze" (default: 0).
#                     ( 0 - disabled; 1 - 5 frames; 2 - 10 frames; 3 - 30 frames.)
#                     Sequences starts from "FrB" and "FrW" frames.
#                     More frames = better analysis = better delogo.
#                     Be sure that the logo in the sequences still will be in the same/static solid
#                     dark/bright background.

#   End of deprecated parameters
#=============================================================================================================


# Int "Interp"      :  Interpolation amount to reduce remnants/artifacts of the logo after deblend.
#                     Basically, a compromise between deblend artifacts and interpolation artifacts.
#                     Interpolation artifacts are most visible when logo is crossing high contrast areas.
#                     (0 - Disabled. Max - 4). (default: 2).


# Int "IntSpd"      :  Speed of "Interp". Higher values can reduce "Interp" artifacts.
#
#                     1 - Fastest (default).
#                     2 - Fast.
#                     3 - Slow.
#                     4 - Slower. Useful for UHD - HD resolutions.


# Int "InterpM"     :  Manipulation of the "Interp" mask.
#                      (1,2) - Amount of pixels around the inflated base mask affected by "Interp",
#                     helps to hide bleed of the logo, if there is any, higher can decrease quality a bit
#                     of "Interp" for the shapy logos. Basically prevents bleed going into interpolation.
#                     For "Deblend"/"Both" modes.
#
#                      (-1) - Interpolates only less trasparent parts of the logo. For "Deblend" mode.
#
#                    -1 - Enables a mask controlled by "iTune" parameter.
#                     0 - Disabled (default).
#                     1 - Adds 1 pixels to interp mask.
#                     2 - Adds 2 pixels to interp mask.


# Int "iTune"       :  Creates a mask for "Interp"/"InterpM". (from -10 to 10; default: 0).
#                     Creates mask for less transparent part of the logo.
#                      Useful if logo has different levels of transparency, and you don't need to
#                     interpolate very transparent parts as there will be almost no artifacts after deblend,
#                     instead you can "take" good pixels from a deblended very transparent area to do better
#                     interpolation on a less transparent area.
#                     0 - doesn't mean that it's disabled, it is just a datum-point.
#                     Higher values -> mask expands into more-transparent areas of the logo.


# Int "iTinflate"   :  Inflates the iTune mask.
#
#                     0 - Disabled  (default).
#                     1 - Inflate by 1 pixel.
#                     2 - Inflate by 2 pixels.
#                     3 - Inflate by 3 pixels.


# Int "oTune"       :  Creation of the mask for "Both" mode. (from -10 to 10; default: 0).
#                     Creates mask for opaque/hardly transparent part of the logo.
#                     0 - doesn't mean that it's disabled, it is just a datum-point.
#                     Higher values -> mask expands into more-transparent areas of the logo.


# Int "oTinflate"   :  Inflates the oTune mask.
#
#                     0 - Disabled  (default).
#                     1 - Inflate by 1 pixel.
#                     2 - Inflate by 2 pixels.
#                     3 - Inflate by 3 pixels.


# Int "Optimize"    :  Enables conditional optimizations (from 0 to 2; default: 2).
#                     Not made to work with the dynamic masks (likely there wouldn't be a lot of benefit).
#                     1 -  Optimizations for the slow "Turbo" & "IntSpd" presets [up to ~1000% speed-up].
#                         Enables auto switching to the faster presets on the frames where logo is in ~solid background.
#                     2 -  Enables additional optimization: Turns off "Interp" for frames where logo is in non-solid background.


                 #===================#
                 #   Dynamic mask:   #
                 #===================#

# Int "DynMask"     :  Delogo with a dynamic mask, currently not for "Deblend".
#                      All other "Inpaint" only parameters should work with it too.
#                      All masks are only for "Inpaint". Except DynMask2 works in "Both" too [but only "DynTune" mask].
#                      For subtitles extraction use "Show=4" view.
#                     (Adaptive default: 0 or 1, depends from "mask".)
#
#                    0 - Off - No dynamic mask. Auto-adaptive.
#
#                    1 - External dynamic mask, defined by "mask". Auto-adaptive.
#
#                    2 - Generation of the dynamic combo mask.
#                        Mix of essential DynMask6/"DynTune" mask + optional DynMask5/"DynColor and DynMask7/"DynTEdge" masks (logic 'and').
#
#                    3 - Generation of the dynamic temporaly averaged combo mask [DynMask2 + temporal average].
#                        Useful when Logo jumps location and stays there for some time (set by "Dyn3Seq").
#                        Averaging is controled by "ClpBlend".
#                        This mask generation must be done in a single thread [no Prefetch]!
#                        Source filter must be frame accurate [like LWLibAvVideoSource]!
#
#                        For fine tuning use "Show=3" mode as in it only steps mentioned below are processed:
#                        Internal succession: Clip > "Loc" > "DynTune"+"DynColor"+"DynTEdge" > "ClpBlend" > "DynPostTune" >...
#                        Start looking at the ~last frame with logo in a location before adjusting things in "Show=3",
#                        because at other places a logo mask should/may disappear (down the chain those are merged in).
#                        Read about "Dyn3buffer" and parameters mentioned above!
#
#                    4 - Generation of the dynamic mask for subtitles with halo.
#
#                    5 - Generation of the dynamic mask by color (only "DynColor").
#
#                    6 - Generation of the dynamic mask by brightness (only "DynTune").
#
#                    7 - Generation of the dynamic mask by gradient magnitude map (only "DynTEdge").


# Int "DynInflate"  :  Inflates the dynamic mask by x pixels. Last in the filters chain (before "maskPatch" and "oPP"). (from 0 to 10; default: 0)
#                      If few masks are mixed into combo then better use separate inflation parameters [like "DynTuneInf", etc.].


#   DynMask=5.
#=============================================================================================================
# NOTES:             :  When "DynMask=5": "DynInflate" is auto hardset to 0.

# Val "DynColor"     :  Auto generation of the dynamic mask by color. (from $000000 to $FFFFFF; default: 0).
#                      Color of logo/subtitle in RGB [hex value].
#                      If value is string then faster alternative is used, TColorMask instead of ColorKeyMask, and it supports multiple colors. ["$000000 $FFFFFF"]
#                      Use preview in AvsPmod to get RGB color value, use ConvertToRGB24(matrix="Rec601 or 709"). ['CopyPixelinfo' macro can be used for a fast copy.]
#                      0 - Disabled  (default).

# Int "DynColorTol"  :  Parameter for "DynColor". Color tolerance. (from 1 to 140; default: 10).

# Int "DynColorInf"  :  Inflates "DynColor" mask. (from 0 to 4; default: 1).
#=============================================================================================================


#   DynMask=6.
#=============================================================================================================
# NOTES:             :  When "DynMask=6": "DynInflate" is auto hardset to 0.

# Val "DynTune"      :  A dynamic mask for "DynMask=2/3/4/6". Binarization threshold [luma/brighness level]. (from 1 to 254; default: 200).
#                      Lower values -> mask expands more into the darker areas of video.
#                      Set highest where logo/subtitle is still visible.
#                      Luma range mask can be made with string: "180 - 200".

# Int "DynTuneInf"  :  Inflates "DynTune" mask. (from -1 to 4; default: 0).
#=============================================================================================================


#   DynMask=7.
#=============================================================================================================
# NOTES:             :  When "DynMask=7": "DynInflate" is auto hardset to 0.

# Int "DynTEdge"     :  Auto generation of the dynamic mask by gradient magnitude map. (from 0 to 1; default: 0).
#                      0 - Disabled  (default).

# Int "DynTEdgeThY"  :  Parameter for "DynTEdge". Magnitude threshold. (from 2 to 100; default: 20).
#                       Adjust it where background brightness is similar to logo/subtitle text brightness.
#                       Aim is to get good edges then inflate till logo/subtitle is covered. Lower - more wrong edges.

# Int "DynTEdgeInf"  :  Inflates "DynTEdge" mask. (from 0 to 8; default: 2).
#=============================================================================================================


# String "maskPatch":  Full path to a patch image, a B/W picture in size of a "loc" area.
#                     Patches a dynamic mask with a custom static mask. Applies after "DynInflate".


# Int "KillNoise"   :  Undot, and eliminate up to 2px thick artifacts from the dynamic mask (from -5 to 5; default: 0).
#                     Negative pre-adds expand>inpand to reduce sponginess of a mask.
#                     It's after "KillBlobs" in the chain.
#
#                     0 - Disabled  (default).
#                     1 - Undot (RemoveGrain(2). Affects white and black spaces).
#                     2 - Two pass Undot.
#                     3 - Hysteresis (inpand>hysteresis to eliminate up to 2x2 white stray pixels).
#                     4 - Undot + Hysteresis.
#                     5 - Two pass Undot + Hysteresis.


# Int "KillBlobs"   :  Removes thicker than logo/subs artifacts (from -8 to 8; default: 0).
#                     Minus sign is to indicate a method.
#                     Two methods: Negative -> mt_inpand>mt_hysteresis,
#                                  Positive -> mt_inpand>mt_expand.
#                     Negative method removes blobs completely, but if artifact is touching logo/sub then it will be removed too.
#                     Positive method is safer, but leaves edges of the artifacts.
#                     Inner workings: Thicker logo/subs needs higher setting to make logo disappear, what is left is treated as artifact.
#                     Don't use Negative method if there is no thick halo.


# Int "preBlobs"    :  Reduce sponginess of the mask for "KillBlobs". (from -2 to 2; default: 0).
#                     Doesn't do anything if KillBlobs=0.
#                     Minus sign is to indicate a method.
#                     Two methods: Negative -> mt_expand> mt_inpand> KillBlobs,
#                                  Positive -> mt_expand> KillBlobs> mt_inpand (bit more effective).
#                     'Stronger' and 'more effective' is less safe for Negative "KillBlobs".
#                     Don't use if there is no thick halo.
#
#                     0 - Disabled  (default).
#                    -1 - 'both' mode.
#                    -2 - 'square' mode (bit stronger).
#                     1 - 'both' mode.
#                     2 - 'square' mode (bit stronger).


# Int "Extract"       :  See SubsMask2Img() manual somewhere below!
# Int "ReExtract"     :  See SubsMask2Img() manual somewhere below!
# String "FourCC"     :  See SubsMask2Img() manual somewhere below!
# Int "DetWinPercW"   :  See SubsMask2Img() manual somewhere below!
# Int "DetWinPercH"   :  See SubsMask2Img() manual somewhere below!
# Float "DetWinHoPos" :  See SubsMask2Img() manual somewhere below!


                 #   DynMask=3:   #
                 #================#

# Int "Dyn3Seq"     :  Parameter for "DynMask=3".
#                     Sets how many frames the logo is in a location (from 8 to 9999, default: 12).
#                     For subtitles set duration of the shortest subtitle or shorter subs will disappear from the mask.


# Int "ClpBlend"    :  Parameter for "DynMask=3".
#                     Sets how many frames will be blended to help to eliminate non-logo areas.
#                     More frames blended - more chance for non-logo areas to disappear from the mask.
#                     Disabling it disables "DynPostTune" automatically. Must be less than "Dyn3Seq"-1.
#                     Adaptive default: ["Dyn3Seq"-2] if Dyn3Seq is < 54, else: 52.
#                     0 = Disabled (for fine tuning with "Show=3").
#                     Note: No need to touch for subtitles.


# Int "DynPostTune" :  Parameter for "DynMask=3".
#                     Post-blend binarization threshold.  (from 0 to 5; default: 0 or 1)
#                     Higher values -> mask expands more into the brighter areas of video. (1=254, increments by -1)
#                     Safest setting is "1", higher will extend logo mask for few frames back and forth,
#                     and possibly some non-logo areas can appear in a mask, but logo mask will get in a lilbit better shape.
#                     If "ClpBlend" is disabled then this will be disabled automatically too.
#                     0 - Disabled, for fine tuning.
#                     Note: No need to touch for subtitles.


# Int "Dyn3buffer"  :  Parameter for "DynMask=3".
#                     Ignore this if "ClpBlend" is less than "53". ( https://forum.doom9.org/showthread.php?p=1928621 )
#                     Buffer for internal TrimergageFX(). Disable it for the script previewing or preview will be very slow.
#                     Enable it for encoding or AvS will work very slow, and it must go together
#                     with RequestLinear(rlim=ClpBlend+1,clim=ClpBlend+1) placed after the source filter.
#
#                     0 - Buffer disabled (default).
#                     1 - Buffer enabled.
#                     Note: No need to touch for subtitles.


# Int "RePass"      :  Parameter for "DynMask=3".
#                     Re-pass temporal+KillNoise routines to reduce artifacts. (from 0 to 2; default: 0).
#                     Useful if "KillBlobs" or "KillNoise" are on.
#
#                     0 - Disabled  (default).
#                     1 - Re-pass once.
#                     2 - Re-pass twice (bit less artifacts).


                 #   DynMask3H>0: #
                 #================#

# Int "DynMask3H"   :  Parameter for "DynMask=3". [Maybe better look at "DynMask=4" method]
#                     If subs has dark full halo then it can be used to remove artifacts. Binarization threshold (from 0 to 200; default: 0 - Disabled).
#                     This mask is used to refine a final "DynMask=3" mask using hysteresis.
#                     Is using "Dyn3Seq"/"ClpBlend" settings (don't change).
#                     As longs as there is a single pixel in a contiguous letter part - mask is good (letters can be partly missing).
#                     Artifacts outside subs area doesn't matter much, usually they won't coincide with "DynMask=3" artifacts.
#                     "RePass" wasn't found useful in the final result (on the short sample). After hysteresis there is non-optional repass.
#
#                     Use "Show=6" to finetune it, parameters are chained in sequence as they are in this help (except "ModeSH").
#                     At this step when "ModeSH=1 & TuneH1=0" - mask is shown pre-construct inverted, actual spatial mask is constructed when "TuneH1" is set.
#                     Set lowest where the subtitle halo masking is visible and clear.
#                     0 - Disabled  (default).


# Int "ModeSH"      :  Parameter for "DynMask3H".
#                     Temporal or spatial halo mask method selector (from 0 to 1; default: 1).
#                     0 - Temporal halo mask. Cons: Slower, doesn't remove some temporal artifacts. Pros: Unknown.
#                     1 - Spatial halo mask. Pros: Faster, removes temporal artifacts. Cons: Unknown.


# Int "TuneH1"      :  Parameter for "DynMask3H".
#                     Removes thicker than logo/subs artifacts (from 0 to 7; default: 0 - Disabled).
#                     Thicker logo/subs needs higher setting to make subs disappear, what is left is treated as artifact.
#                     Same as positive "KillBlobs" method.
#                     Increase till text is visible, small part of letter missing is ok.


# Int "TuneH2"      :  Parameter for "DynMask3H".
#                     Pre-diff expands (visibly after diff looks like inpands). (from 0 to 4; default: 0 - Disabled).
#                     Increase to reduce halo remnants from the mask, up to where it doesn't affect letters.


# Int "TuneH3"      :  Parameter for "DynMask3H".
#                     Post-diff inpands. (from 0 to 3; default: 0 - Disabled).
#                     Increase up to where letters doesn't disappear completely.


# Int "KillNoiseH"  :  Parameter for "DynMask3H".
#                     Undot, and eliminate up to 1x2px artifacts from the "DynMask3H" mask.
#                     Wasn't found useful in the final result (on the short sample).
#
#                     0 - Disabled  (default).
#                     1 - Undot (RemoveGrain(2). Affects white and black spaces).
#                     2 - Two pass Undot.


# Int "rePassH"     :  Parameter for "DynMask3H".
#                     Re-pass/pass temporal+KillNoiseH routines to reduce artifacts in "DynMask3H" mask. (0 - Disabled, 1 - Enabled; default: 0).
#                     Wasn't found useful in the final result (on the short sample).


                 #   DynMask=4:   #
                 #================#

# NOTES:            :  For subtitles with a dark halo. A mask made from "Dyntune" & "DynMask4H" parameters.

# Int "DynMask4H"   :  Parameter for "DynMask=4".
#                     Binarization threshold for the subtitles halo (from 1 to 200; default: 60).
#                     Set lowest where the subtitle halo masking is visible and clear. If too low then some letters can disappear.
#                     Use "Show=6" to finetune it.

# Int "DynMaskUp"   :  Parameter for "DynMask=4".
#                     Only to get a neat upsized subtitles mask on Show=4 output. (from -4 to 4; default: 0).
#                     Resolution is multiplied by parameter (-1/0/1 = Disabled).
#                     Positive: First set everything without this parameter as all filtering is done on a not-upsized mask, which is used to do hysteresis into the upsized mask.
#                     Negative: Does filtering on the upsized mask (experimental, WIP).

# Int "DynLocUp"   :  Experimental WIP parameter for tests, alternative to negative "DynMaskUp". Tested only with "DynMask=4", may work with other methods, may break things.
#                     Vs negative "DynMaskUp": ~50%-30% faster. Doesn't destroy slim characters [like hieroglyphs], but doesn't remove some noise.
#                     Only to get a neat upsized subtitles mask on Show=4 output. (from 1 to 4; default: 1).
#                     Resolution is multiplied by parameter.


                 #==================#
                 #   Post-process:  #
                 #==================#

# Int "dPP"         :  Blur amount applied to delogoed area to hide artifacts (from -8 to 8; default: -3).
#                     Blur strength. Negative adds denoise on top of blur.


# Int "dPPm"        :  Adds smooth borders to the deblend mask, used for "dPP" post-process,
#                     it will blend in a deblended area into the surrounding.(default: 3/adaptive).
#
#                     0 - Disabled. Not selectable. Adaptive.
#                     1 - 3 smooth pixels added.
#                     2 - 5 smooth pixels added.
#                     3 - 7 smooth pixels added.


# Int "diPP"         :  Blur amount applied to Interp/iTune area to hide artifacts  (from -8 to 8; default: -5).
#                     Auto disabled if  Interp = 0  or InterpM != -1.
#                     Blur strength. Negative adds denoise on top of blur.


# Int "diPPm"        :  Adds smooth borders to the iTune mask, used for "diPP" (default: 3).
#
#                     0 - Disabled.
#                     1 - 3 smooth pixels added.
#                     2 - 5 smooth pixels added.
#                     3 - 7 smooth pixels added.


# Int "oPP"         :  Blur amount applied to inpainted(opaque) area to calm it down (from -8 to 8; default: -5).
#                     Blur strength. Negative adds denoise on top of blur.


# Int "oPPm"        :  Adds smooth borders to the opaque mask, used for "oPP" post-process,
#                     it will blend in an inpainted area into the surrounding.(default: 3).
#                     Auto-disabled if "oPP=0".
#
#                     0 - Disabled.
#                     1 - 3 smooth pixels added.
#                     2 - 5 smooth pixels added.
#                     3 - 7 smooth pixels added.


# Int "GrainPP"     :  Adds grain, it will blend in an delogoed area into the noisy surrounding.
#                      Requires GrainFactory3. Use only if there is grain or similar noise in video.
#                     (0 - Disabled. 3 - Max noise). (default: 0)


# Int "EdgePP"      :  Creates the edgemask. Inpaints edges of the base or iTune mask.
#                     Useful on the bigger & hardly transparent logos if deblend left strong
#                     artifacts on the edges of the logo.
#                     It ignores "Inflate"/"iTinflate".
#
#                     0 - Disabled (default).
#                     1 - Enabled. Fast.
#                     2 - Enabled. Slow. Slight increase of quality .
#                     3 - Enabled. Very slow. Definitely will decrease speed.


# Int "EdgePos"     :  Position of the edgemask. (default: 0).
#
#                    -1 - 1px inwards from the initial position.
#                     0 - The initial position.
#                     1 - 1px outwards from the initial position.


# Int "EdgeWide"    :  Wideness of the edgemask (default: 1).
#
#                     0 - 2px wide mask.
#                     1 - 4px wide mask.
#                     2 - 6px wide mask.
#                     3 - 8px wide mask.


                 #=========================#
                 #   Pre-process helpers:  #
                 #=========================#

# int "Show"        :  Show some masks and steps of the delogo process.
#
#                     0 - Disabled (default).
#                     1 - Various masks and some delogo steps.
#                     2 - a) For positive analyze: Shows exact deblend masks [just ignore chroma], shows more delogo steps than "Show=1" (can show "mShow").
#                         b) If not positive analyze:
#                           b1) Stacked Delogoed + PostProcessed steps (can show "mShow").
#                           b2) If a dynamic mask:
#                               Delogoed      + Dynamic mask
#                               PostProcessed + Dynamic PP mask
#                     3 - Only for "DynMask=3". For fine tuning. Pre TrimergageFX().
#                     4 - Outputs the DynamicMask (Loc area). Can be used to extract subtitles.
#                     5 - Outputs full sized Dynamic PP mask in Y8.
#                     6 - Outputs the "DynMask3H" & "DynMask4H" mask. For fine tuning.
#
#                     # Analyze. Dev stuff:
#                     7 - Shows the constructed clip used to select frames for Analyze (whole clip with MinMax stats). 4x upsize.
#                     8 - Same as 7, except that it shows the selected frames by AnalyzeTh. 4x upsize.
#                     9 - Shows original selected frames with the real frame number from source clip.
#
#                     # For DynMask=2/5/6/7:
#                    10 - Stacked: Original | Overlayed black | Mask
#                    11 - Overlayed black
#
#                    12 - Debug initial subs scan. Shows subs detection window and correlation coefficient [CorrTh/Corr], Corr is calculated from whole frames. Only for DynMask > 0.


# Int "mShow"       :  Shows you selected mask. Overlays "black hole" over clip.
#                     Shows in "Show = 2" too.
#                     Dynamic mask (in "Inpaint" mode) should work with 2 and 9.
#
#                     0 - Disabled        (default).
#
#                       These, overlay on top of the processed clip:
#                     1 - Opaque mask      (actual mask for a inpainting job).
#                     2 - Opaque PP mask   (post-process mask for inpainted area).
#                     3 - Base mask.
#                     7 - Interp/iTune mask(not for "Inpaint" mode).
#                     8 - Edge mask        (not for "Inpaint" mode).
#
#                       These, overlay on top of the original clip:
#                     4 - Base mask.
#                     5 - Deblend PP mask  (post-process mask for deblend area).
#                     6 - oTune Mask       (not for "Inpaint" mode).
#                     9 - Opaque PP mask   (post-process mask for inpaint area).


                 #============================#
                 #   Parameters for Inpaint:  #
                 #============================#

# Int "Turbo"       : Inpainting presets. Only for "Inpaint" and "Both" modes (from -2 to 3; default: 0).
#                     Positive values are for very fast, less "alive", blurry, low quality inpainting.
#                     Positive values will not try to connect isophotes/inpaint shapes of the surrounding.
#                     Hard inpainting presets if not "0".
#                     Positive values activates the hard presets for "oPP".
#
#                   -2 - Very slow. High quality inpainting. More suitable for UHD - HD resolutions.
#                   -1 - Slower. High quality inpainting. More suitable for UHD - HD resolutions.
#                    0 - Slow. High quality inpainting defaults.
#                    1 - Fast. Low quality inpainting.
#                    2 - Faster. Low quality inpainting.
#                    3 - Fastest. Low quality inpainting. Less suitable for higher than SD resolutions.


# Int "KillShape"   :  Reduces sponginess of the base/dynamic mask when preserves dimensions of the shape.
#                     Experimental parameter meant for positive "Turbo", to make inpainted area less "alive".
#                     Will kill any hole up to 6 pixels in diameter.
#                     Works only in "Inpaint" mode. (Default: 0)
#                     0 - Off.
#                     1 - On.


# Int "prePP"       :  Pre blurs Loc area for inpainting algo. (Default: 0)
#                     Experimental parameter meant for positive "Turbo" when in "Inpaint" mode.
#                     0 - Off.
#                     1 - On.


                 #============================================#
                 #   Parameters of the Inpainting algorithm:  #
                 #============================================#

# Note              :  Default settings combo below is generally balanced, it's not recommended
#                     to change any of them if video is not static.
#                     It's in general a very hard task to find the good parameters combo (combo
#                     involves some settings above too. So there is endless combinations...).
#                     Making one scene to look better, will make another one worse.
#                     What is very good for one frame - very bad temporally on the whole clip.
#                      These parameters can be adjusted only when Turbo=0.


# Float "Radius"    :  Radius around a damaged pixel from where values are taken when the pixel
#                     is inpainted. Bigger values prevent isophotes being inpainted in the wrong
#                     direction, but also create more blur and increase CPU usage. (default: 8.0)


# Float "PreBlur"   :  Standard deviation of the blur which is applied to the image before
#                     the structure tensor is computed. Higher values help connecting isophotes
#                     which have been cut by the inpainting region, but also increase CPU usage.
#                     PreBlur=0.0 disables pre-blurring.  (default: 6.5)


# Float "PostBlur"  :  Standard deviation of the blur which is applied to the structure tensors
#                     before they are used to determine the inpainting direction. Higher values
#                     help gather more directional information when there are only few valid
#                     pixels available, but increases CPU usage.  (default: 4.0)


# Float "Sharpness" :  Describes how faithful the algorithm follows directional information
#                     contained in the structure tensor. Higher values can prevent blurring
#                     caused by high Radius values.
#                     (Default: 45.0)


                 #===========================================#
                 #   Parameters for the ebmp masks editing:  #
                 #===========================================#

# Notes              :  For the expert users only [Skip this section if you don't fully understand how deblending/AVSInpaint works].
#                      Only for the positive Analyze deblending masks. Use "Show=2" to see what you are doing.
#                      All YUV [YV12] channels are deblended separetely, so there are 3 alpha masks, 3 logo images and 1 basemask stored in ebmp.
#                      All masks are in Y8 ["Color" refers to "Colored logo image" from AVSInpaint's docs].


# Val YAlphaExternal    :  Custom Y Alpha clip.

# Int "YAlphaTweak",     "UAlphaTweak",     "VAlphaTweak"     :  Tweaks an alpha mask (from -10 to 10; default: 0 [Off]).
# Int "YAlphaSolidOuts", "UAlphaSolidOuts", "VAlphaSolidOuts" :  Paints an alpha mask outside logo (from -1 to 255; default: -1 [Off]).
# Int "YAlphaSolidIns",  "UAlphaSolidIns",  "VAlphaSolidIns"  :  Paints an alpha mask inside logo (from -1 to 255; default: -1 [Off]).

# Int "YColorSolid",     "UColorSolid",     "VColorSolid"     :  Paints whole logo image (from -1 to 255; default: -1 [Off]).
# Int "YColorSolidOuts", "UColorSolidOuts", "VColorSolidOuts" :  Paints a logo image outside logo (from -1 to 255; default: -1 [Off]).
# Int "YColorSolidIns",  "UColorSolidIns",  "VColorSolidIns"  :  Paints a logo image inside logo (from -1 to 255; default: -1 [Off]).

# Int "YOffsetIns"       :  Offset for Y  "...SolidIns"  parameters (from -4 to 0; default: -1).
# Int "YOffsetOuts"      :  Offset for Y  "...SolidOuts" parameters (from  0 to 4; default:  1).
# Int "UVOffsetIns"      :  Offset for UV "...SolidIns"  parameters (from -4 to 0; default: -2).
# Int "UVOffsetOuts"     :  Offset for UV "...SolidOuts" parameters (from  0 to 4; default:  2).

# Int "ShiftMasksVe"    :  Shifts masks by one pixel vertically, positive value moves logo up (from -1 to 1; default: 0 [Off]) [chroma shifts by sub-pixel].
# Int "ShiftMasksHo"    :  Shifts masks by one pixel horizontally, positive value moves logo left (from -1 to 1; default: 0 [Off]) [chroma shifts by sub-pixel].

# Int "WholeDeblend"    :  If enabled then deblend affects whole frame, it won't be isolated to logo (from 0 to 1; default: 0 [Off]).

# Int "TriggerDynamic"  :  Triggers dynamic deblending code in AVSInpaint on a static mask (from 0 to 1; default: 0 [Off]).

# Int "DumpMasks"       :  Meant to dump tweaked masks to ebmp file, "2" dumps with hard presets for ..SolidOuts. (from 0 to 2; default: 0 [Off]).


##================================================================================================##
#   SubsMask2Img()  manual:                                                                        #
##================================================================================================##


# NOTES             : Use "Show=4" and "DynMask" in InpaintDelogo() to get a mask of subtitles.
#                     Mask clip is expected to be full range Y8 or it will be converted [but there is no conversion to full range].


# Int "Extract"     :  This is only InpaintDelogo() parameter!!!
#                     Works only with "DynMask" through "Show=4".
#                     It will pass SubsMask2Img() parameters from InpaintDelogo() to SubsMask2Img() to extract subtitle images from a dynamic mask.
#
#                     Positive: Twice slower than negative mode. Extracts without using the intermediate file.
#
#                     Negative: Fast extraction. Extracts using the intermediate file.
#                     File is named "_InpaintDelogo_Intermediate_DynMask.avi", it will be overwritten on every run except when "ReExtract=1".
#                     Setup guide [do it once then you don't need to use "FourCC"]:
#                     Install TWriteAVI plugin and x264vfw codec, then you need to configure x264vfw:
#                     On your first extraction set "FourCC" to "" then you will see pop-up with menu:
#                       Select "Compressor: x264vfw" -> Press "Configure":
#                         In x264vfw configuration select:
#                           "Rate control: Lossless"
#                           "Debug: Log level: None"
#                           "Convert to YUV 4:0:0 (grey)"
#                           "Preset: Superfast" or "Preset: Ultrafast"
#                     Ultrafast preset is ~8% faster than Superfast but it produces ~5 times bigger file, usually less than 500 MB.
#
#                    0 - Off (Default).
#                    1 - Slow. Extracts subtitles, black and white binarized images.
#                   -1 - Fast. Extracts subtitles, black and white binarized images.
#                    2 - Slow. Extracts subtitles, black and white binarized images and raw non-binarized images.
#                   -2 - Fast. Extracts subtitles, black and white binarized images and raw non-binarized images.


# String "FourCC"   :  This is only InpaintDelogo() parameter!!!
#                     Codec selection for the intermediate file (Default: "X264").
#                     On your first extraction set it to "" to see the codec configuration menu,
#                     then you don't need to use this parameter anymore.


# Int "ReExtract"   :  This is only InpaintDelogo() parameter!!!
#                     It's meant for negative "Extract". (from 0 to 1; default: 0 [Off]).
#                     Repeats extraction from the existing intermediate file.
#                     Useful if you want to run different SubsMask2Img parameters on the same mask.


# Clip "Raw"        :  Enables extraction of raw non-binarized images from specified clip.
#                     Crop this clip with "Loc" values used to get a mask, for example: rawclip = LWLibAvVideoSource("D:\original_video.mkv").crop(20,200,-50,-36)
#                     This parameter can't be passed with InpaintDelogo(), there it's done automatically with "Extract=2" parameter.


# Int "RawAvr"      :  Enables raw image averaging. Should increase OCR accuracy.
#                     Maybe would decrease OCR accuracy on "jumpy" subtitles.
#
#                    0 - Disabled. Raw images not averaged.
#                    1 - Enabled. Raw images will be averaged (default).


# String "ImgDir"   :  Path to directory where black and white images are to be written. MUST be set to existing directory.
#                     Extracting raw iamges: Folder for raw images must exist with '_raw' at the end of foldername:
#                     For example: if ImgDir="D:\Images" then next to "Images" folder must exist "Images_raw" folder.


# Float "CorrTh"    :  Correlation threshold to detect where subtitles in adjacent frames are the same (from 0.5 to 0.95; default: 0.8).
#                     Used to detect where to split apart non similar subs.
#                     Higher - detection more sensitive to the changes in the frames.
#                     Probably no need to touch it. You can use "Show=12" to see correlation coefficient.
#                     If there are lots of artifacts in a mask then you can lower it a bit [E.g.: 0.7],
#                     that can reduce wrong splits, but higher risk of sub "disappearing" in rare scenario when same big artifact continues into multiple subs.


# Int "DetWinPercW" :  Adjusts width of the subs detection window. Percentage of clip's width (from 5 to 95; default: 10).
#                     No need to touch if video has usual middle subs alignment.
#                     Use "Show=12" to adjust (in InpaintDelogo()).


# Int "DetWinPercH" :  Adjusts height of the subs detection window. Percentage of clip's height (from 30 to 95; default: 60).
#                     No need to touch if video has usual middle subs alignment.
#                     Use "Show=12" to adjust (in InpaintDelogo()).


# Float "DetWinHoPos" :  Adjust vertical position of the subs detection window. (from -0.99 to 0.99; default: 0 [middle]).
#                     Positive values move window to the left. Not whole allowed range is legal, depends from "DetWinPercW".
#                     No need to touch if video has usual middle subs alignment.
#                     Use "Show=12" to adjust (in InpaintDelogo()).


# Int "SubTune"     :  Post-blend binarization threshold [subtitle range to a single frame] (from 100 to 254; default: 235).
#                     Max = maximum artifacts reduction, if there are, but parts of the letters can disappear too.
#                     Probably no need to touch it.


# Int "SubMinDur"   :  Minimum subtitle duration threshold in frames (from 1 to 30; default = 12).
#                     Images with duration below this threshold won't be extracted.


# Int "SubSusDur"   :  Suspicious subtitle duration threshold in frames (from 0 to 60; default: 0).
#                     Extracted images with duration below or equal to this threshold will have "_" prefix in the filenames.
#                     Parameter is for fast examination/detection of possible non-sub images or wrong splits.
#                     Recommended setting: 3 frames lower than FPS of video.


# float "SubMinLuma":  Minimum average luma threshold for subtitle images (from 0 to 0.5; default = adaptive).
#                     If subs detection window is less than 2x default then SubMinLuma default = 0.5
#                     Images with average luma below this threshold won't be extracted.
#                     Note: No need to touch it, unless you want to set it to 0.


# Float "SubSusLuma":  Suspicious average luma threshold for subtitle images (from 0 to 5; default: 0).
#                     Extracted images with average luma below this threshold will have "_" prefix in the filenames.
#                     Parameter is for fast examination/detection of possible non-sub images.
#                     Recommended setting: 3.


# Int "ImgType"     :  Image type to write ("png", "tif" or "jpg"; default: "png").

# Int "ImgInflate"  :  Inflate sub mask by 1 pixel (goes after upsize). (from 0 to 1; default: 0).

# Int "ImgInvert"   :  Invert images. (from 0 to 1; default: 0).

# Int "ImgSize"     :  Upsize images by that multiplier. (from 1 to 4; default: 1).


##================================================================================================##
#   The simplified pseudo scheme of parameters logic (v1.20):                                      #
##================================================================================================##


#    InpaintLoc()-->[Loc]-->!loc!
#
#
#                  [mask]->[Loc]->[Analyze]---(if auto)--->[aMix]->[rSize]->!mask!
#                    |                |                      |
#              (if Automask=1)  (if manual)-------->[FrB]+[FrW]+[FrS]
#                    |
#    InpaintDelogo()-------->[mask]------>[Loc]->|
#                                                |
#                     (if Deblend or Both)<----[Mode]---------->(if Inpaint)
#                                 |                                    |
#                              [Inflate]                            [Turbo]
#                                 |                                    |
#                               [Deep]                            [KillShape]
#                                 |                                    |
#                             [ReAnalyze]->(if masks ok)---->|     [Inflate]
#                                 |                          |         |
#                              (if on)                       |         |
#                                 |                          |         |
#      |<------(if manual)<---[Analyze]--->(if auto)-------->|         |
#      |                                                     |         |
#      |-->[FrB]+[FrW]+[FrS]------>------------------------->|         |
#                                                            |         |
#                   [iTinflate]<--[iTune]<--[if InterpM=-1]<-|         |
#                         |                                  |         |
#                         |-------------->[Interp]<------[InterpM]     |
#                                            |                         |
#                                         [IntSpd]                     |
#                      |                     |                         |
#      |<-[dPP]<-[dPPm]<---(if Deblend)<-----|---->(if Both)-->|       |
#      |                         |                             |       |
#      |<-[diPP]<-[diPPm]<-(if InterpM=-1)                 [oTune]     |
#      |                                                       |       |
#      |<-[dPP]<-[dPPm]<-------(if Both)                [oTinflate]->[prePP]
#      |                           |                                   |
#      |-->(if Both)-->|       [Sharpness]++[PostBlur]++[PreBlur]++[Radius]
#      |               |           |
#      |<---[oPP]<--[oPPm]<--(if Inpaint)
#      |
#      |->(if not Inpaint)->[EdgePP]->[EdgePos]->[EdgeWide]
#      |                                              |
#      |<------------------------------------------<--|
#      |
#      |------->[GrainPP]----->[Show]-->[rSize]-->[mShow]----->!Delogoed Clip!


##================================================================================================##
#   Functions with all default parameters (for advanced users):                                    #
##================================================================================================##
/*

InpaintDelogo( mask="c:\test\mymask.bmp",
\ Automask=0, aMix=0, Loc="100,100,-100,-100", Mode="Inpaint",
\ Analyze=2, FrB=0, FrW=0, FrS=0, AnalyzeTh=30, NoBorderAt="none",
\ Inflate=1, Deep=3, ReAnalyze=0,
\ Interp=2, IntSpd=1, InterpM=0, iTune=0, iTinflate=0,
\ dPP=-3, dPPm=3,
\ oPP=-5, oPPm=3,
\ diPP=-5, diPPm=3,
\ EdgePP=0, EdgePos=0, EdgeWide=1,
\ Turbo=0, prePP=0, KillShape=0, oTune=0, oTinflate=0,
\ DynMask=0, DynTune=200, DynTuneInf=0, DynInflate=0, maskPatch="",
\ DynColor=0, DynColorTol=10, DynColorInf=1,
\ DynTEdge=0, DynTEdgeThY=20, DynTEdgeInf=2,
\ KillBlobs=0, preBlobs=0, KillNoise=0, rePass=0,
\ Dyn3Seq=12, ClpBlend=10, DynPostTune=1, Dyn3buffer=0,
\ DynMask3H=0, ModeSH=1, TuneH1=0, TuneH2=0, TuneH3=0, KillNoiseH=0, rePassH=0,
\ DynMask4H=60, DynMaskUp=0, DynLocUp=1,
\ Extract=0, ReExtract=0, FourCC="X264",
\ GrainPP=0,
\ Sharpness=45, PreBlur=6.5, PostBlur=4.0, Radius=8.0,
\ Show=0, mShow=0,
\ YAlphaTweak=0, UAlphaTweak=0, VAlphaTweak=0,
\ YColorSolid=-1, UColorSolid=-1, VColorSolid=-1,
\ YColorSolidOuts=-1, UColorSolidOuts=-1, VColorSolidOuts=-1,
\ YColorSolidIns=-1, UColorSolidIns=-1, VColorSolidIns=-1,
\ YAlphaSolidOuts=-1, UAlphaSolidOuts=-1, VAlphaSolidOuts=-1,
\ YAlphaSolidIns=-1, UAlphaSolidIns=-1, VAlphaSolidIns=-1,
\ YOffsetIns=-1, YOffsetOuts=1, UVOffsetIns=-2, UVOffsetOuts=2, ShiftMasksVe=0, ShiftMasksHo=0,
\ YAlphaExternal="", WholeDeblend=0, TriggerDynamic=0, DumpMasks=0)


SubsMask2Img( ImgDir="", CorrTh=0.8, SubTune=235, DetWinPercW=10, DetWinPercH=60, DetWinHoPos=0,
\ SubMinDur=12, SubSusDur=0,  SubMinLuma=0.5, SubSusLuma=0,
\ ImgType="png", ImgInflate=0, ImgInvert=0, ImgSize=1, RawAvr=1 )

*/

##================================================================================================##
#   InpaintDelogo function:                                                                        #
##================================================================================================##


function InpaintDelogo ( clip clp, val "mask", string "Loc", string "Mode", int "Analyze",
\                        int "FrB", int "FrW", int "FrS", int "Interp", int "InterpM", int "Inflate",
\                        int "oTune", int "ReAnalyze", int "oPP", int "oPPm", int "dPPm", int "dPP",
\                        float "Radius", float "Sharpness", float "PreBlur", float"PostBlur",
\                        int "GrainPP", int "Automask", int "aMix", int "mShow", int "Show",
\                        int "Deep", int "prePP", int "KillShape", int "Turbo",
\                        int "iTune", int "iTinflate", int "oTinflate", int "diPPm", int "diPP",
\                        int "EdgePP", int"EdgePos", int"EdgeWide", int "IntSpd", int"DynMask",
\                        val "DynTune", int "DynInflate", int "KillNoise", string "maskPatch",
\                        int "ClpBlend", int "DynPostTune", int "Dyn3Seq", int "Dyn3buffer",
\                        int "KillBlobs", int "preBlobs", int "rePass",
\                        int "DynMask3H", int "ModeSH", int "TuneH1", int "TuneH2", int "TuneH3", int "rePassH", int "KillNoiseH",
\                        int "DynMask4H", int "DynMaskUp", int "DynLocUp",
\                        int "Extract", val "ReExtract", string "FourCC", String "ImgDir", Float "CorrTh", Int "SubTune", Int "SubMinDur", Int "SubSusDur", Float "SubMinLuma", Float "SubSusLuma",
\                        String "ImgType", Int "ImgInflate", Int "ImgInvert", Int "ImgSize", Int "RawAvr", Int "DetWinPercW", Int "DetWinPercH", Float "DetWinHoPos",
\                        int "AnalyzeTh", String "NoBorderAt",
\                        val "DynColor", int "DynColorTol", int "DynColorInf",
\                        int "DynTEdge", int "DynTEdgeThY", int "DynTEdgeInf", int "DynTuneInf",
\                        int "YAlphaTweak", int "UAlphaTweak", int "VAlphaTweak",
\                        int "YColorSolid", int "UColorSolid", int "VColorSolid",
\                        int "YColorSolidOuts", int "UColorSolidOuts", int "VColorSolidOuts",
\                        int "YColorSolidIns", int "UColorSolidIns", int "VColorSolidIns",
\                        int "YAlphaSolidOuts", int "UAlphaSolidOuts", int "VAlphaSolidOuts",
\                        int "YAlphaSolidIns", int "UAlphaSolidIns", int "VAlphaSolidIns",
\                        int "YOffsetIns", int "YOffsetOuts", int "UVOffsetIns", int "UVOffsetOuts", int "ShiftMasksVe", int "ShiftMasksHo",
\                        val "YAlphaExternal", int "WholeDeblend", int "TriggerDynamic", int "DumpMasks",
\                        val "Optimize")


{

    # AVS+ version check           #
    # Error for standalone AVS+    #
    #==============================#


    Assert(FunctionExists("IsVersionOrGreater"), "Install Avisynth+ v3.7.2 or later.")
    Assert(IsVersionOrGreater(3,7,2), "Install Avisynth+ v3.7.2 or later.")
    Assert(FunctionExists("GScriptClip"), "Install GRunT plugin.")
    Assert(FunctionExists("RT_Stats"), "Install RT_Stats plugin.")
    Assert(FunctionExists("mt_lutxyza"), "Install MaskTools2 plugin.")
    Assert(FunctionExists("ImageWriter"), "Load 'ImageSeq.dll' with 'LoadPlugin' or install Avisynth+.")


    # Defaults #
    #==========#


    mask        = default (mask      , ""  )    Assert (IsString(mask) || IsClip(mask), """"Mask" only accepts string/path or clip input.""")
    maskPatch   = default (maskPatch , ""  )
    loc         = default (loc       , ""  )
    mode        = (IsString(mask) && RightStr(mask, 4) == "ebmp") ? default (mode , "deblend") :
    \                                                               default (mode , "inpaint")
    analyze     = default (analyze     , 2 )
    deep        = default (deep        , 3 )
    FrB         = default (FrB         , 0 )
    FrW         = default (FrW         , 0 )
    frs         = default (frs         , 0 )
    interp      = default (interp      , 2 )
    interpm     = default (interpm     , 0 )
    dpp         = default (dpp         ,-3 )
    dppm        = default (dppm        , 3 )
    dipp        = default (dipp        ,-5 )
    dippm       = default (dippm       , 3 )
    oppm        = default (oppm        , 3 )
    turbo       = default (turbo       , 0 )
    dynmask     = default (dynmask     , 0 )
    dyntune     = default (dyntune   , 200 )
    dyninflate  = default (dyninflate  , 0 )
    grainpp     = default (grainpp     , 0 )
    opp         = default (opp         ,-5 )
    killshape   = default (killshape   , 0 )
    killnoise   = default (killnoise   , 0 )
    killblobs   = default (killblobs   , 0 )
    preblobs    = default (preblobs    , 0 )
    repass      = default (repass      , 0 )
    dynmask3h   = default (dynmask3h   , 0 )
    modesh      = default (modesh      , 1 )
    tuneh1      = default (tuneh1      , 0 )
    tuneh2      = default (tuneh2      , 0 )
    tuneh3      = default (tuneh3      , 0 )
    dynmask4h   = default (dynmask4h  , 60 )
    dynmaskup   = default (dynmaskup   , 0 )
    dynlocup    = default (dynlocup    , 1 )
    killnoiseh  = default (killnoiseh  , 0 )
    repassh     = default (repassh     , 0 )
    prepp       = default (prepp       , 0 )
    radius      = default (radius    , 8.0 )
    sharpness   = default (sharpness ,45.0 )
    preblur     = default (preblur   , 6.5 )
    postblur    = default (postblur  , 4.0 )
    show        = default (show        , 0 )
    otune       = default (otune       , 0 )
    itune       = default (itune       , 0 )
    amix        = default (amix        , 0 )
    mshow       = default (mshow       , 0 )
    inflate     = default (inflate     , 1 )
    iTinflate   = default (iTinflate   , 0 )
    oTinflate   = default (oTinflate   , 0 )
    automask    = default (automask    , 0 )
    reanalyze   = default (reanalyze   , 0 )
    edgepp      = default (edgepp      , 0 )
    edgepos     = default (edgepos     , 0 )
    edgewide    = default (edgewide    , 1 )
    intspd      = default (intspd      , 1 )
    Dyn3Seq     = default (Dyn3Seq    , 12 )
    ClpBlend    = (Dyn3Seq  < 54) ? default (ClpBlend, Dyn3Seq-2 ) :
    \                               default (ClpBlend, 52        )
    DynPostTune = (ClpBlend == 0) ? default (DynPostTune , 0 ) :
    \                               default (DynPostTune , 1 )
    Dyn3buffer  = default (Dyn3buffer  , 0 )
    DynColor    = default (DynColor    , 0 )
    DynColorTol = default (DynColorTol ,10 )
    DynColorInf = default (DynColorInf , 1 )
    DynTEdge    = default (DynTEdge    , 0 )
    DynTEdgeThY = default (DynTEdgeThY ,20 )
    DynTEdgeInf = default (DynTEdgeInf , 2 )
    DynTuneInf  = default (DynTuneInf  , 0 )

    Extract     = Default(Extract     ,    0)    Assert (!(Extract      <   -2 || Extract      >    2), """"Extract" value must be between -2 and 2.""")
    ReExtract   = Default(ReExtract   ,    0)    Assert (!(ReExtract    <    0 || ReExtract    >    1), """"ReExtract" value must be between -2 and 2.""")
    FourCC      = Default(FourCC    , "X264")
    CorrTh      = Default(CorrTh      ,  0.8)    Assert (!(CorrTh       <  0.5 || CorrTh       > 0.95), """"CorrTh" value must be between 0.5 and 0.95.""")
    DetWinPercW = Default(DetWinPercW ,   10)    Assert (!(DetWinPercW  <    5 || DetWinPercW  >   95), """"DetWinPercW" value must be between 5 and 95.""")
    DetWinPercH = Default(DetWinPercH ,   60)    Assert (!(DetWinPercH  <   30 || DetWinPercH  >   95), """"DetWinPercH" value must be between 30 and 95.""")
    DetWinHoPos = Default(DetWinHoPos ,    0)
    SubTune     = Default(SubTune     ,  235)
    SubMinDur   = Default(SubMinDur   ,   12)
    SubSusDur   = Default(SubSusDur   ,    0)
    SubMinLuma  = Default(SubMinLuma  ,  0.5)
    SubSusLuma  = Default(SubSusLuma  ,    0)
    ImgType     = Default(ImgType     ,"png")
    ImgInflate  = Default(ImgInflate  ,    0)
    ImgInvert   = Default(ImgInvert   ,    0)
    ImgSize     = Default(ImgSize     ,    1)
    ImgDir      = Default(ImgDir      ,   "")
    RawAvr      = Default(RawAvr      ,    1)

    AnalyzeTh   = (clp.FrameCount < 45000) ? default (AnalyzeTh, 30) :
    \                                        default (AnalyzeTh, 16)
    NoBorderAt  = default (NoBorderAt , "none")

    YAlphaExternal   = Default (YAlphaExternal  , "")    Assert (!(isInt(YAlphaExternal)  || isFloat(YAlphaExternal)), """"YAlphaExternal" must be clip.""")
                                                         if(isString(YAlphaExternal)) { Assert (!(YAlphaExternal != "") , """"YAlphaExternal" must be clip.""") }
    YAlphaTweak      = Default (YAlphaTweak     ,  0)    Assert (!(YAlphaTweak      < -10 || YAlphaTweak     >  10), """"YAlphaTweak" value must be between -10 and 10.""")
    UAlphaTweak      = Default (UAlphaTweak     ,  0)    Assert (!(UAlphaTweak      < -10 || UAlphaTweak     >  10), """"UAlphaTweak" value must be between -10 and 10.""")
    VAlphaTweak      = Default (VAlphaTweak     ,  0)    Assert (!(VAlphaTweak      < -10 || VAlphaTweak     >  10), """"VAlphaTweak" value must be between -10 and 10.""")
    YAlphaSolidOuts  = Default (YAlphaSolidOuts , -1)    Assert (!(YAlphaSolidOuts  <  -1 || YAlphaSolidOuts > 255), """"YAlphaSolidOuts" value must be between -1 and 255.""")
    UAlphaSolidOuts  = Default (UAlphaSolidOuts , -1)    Assert (!(UAlphaSolidOuts  <  -1 || UAlphaSolidOuts > 255), """"UAlphaSolidOuts" value must be between -1 and 255.""")
    VAlphaSolidOuts  = Default (VAlphaSolidOuts , -1)    Assert (!(VAlphaSolidOuts  <  -1 || VAlphaSolidOuts > 255), """"VAlphaSolidOuts" value must be between -1 and 255.""")
    YAlphaSolidIns   = Default (YAlphaSolidIns  , -1)    Assert (!(YAlphaSolidIns   <  -1 || YAlphaSolidIns  > 255), """"YAlphaSolidIns" value must be between -1 and 255.""")
    UAlphaSolidIns   = Default (UAlphaSolidIns  , -1)    Assert (!(UAlphaSolidIns   <  -1 || UAlphaSolidIns  > 255), """"UAlphaSolidIns" value must be between -1 and 255.""")
    VAlphaSolidIns   = Default (VAlphaSolidIns  , -1)    Assert (!(VAlphaSolidIns   <  -1 || VAlphaSolidIns  > 255), """"VAlphaSolidIns" value must be between -1 and 255.""")
    YColorSolid      = Default (YColorSolid     , -1)    Assert (!(YColorSolid      <  -1 || YColorSolid     > 255), """"YColorSolid" value must be between -1 and 255.""")
    UColorSolid      = Default (UColorSolid     , -1)    Assert (!(UColorSolid      <  -1 || UColorSolid     > 255), """"UColorSolid" value must be between -1 and 255.""")
    VColorSolid      = Default (VColorSolid     , -1)    Assert (!(VColorSolid      <  -1 || VColorSolid     > 255), """"VColorSolid" value must be between -1 and 255.""")
    YColorSolidOuts  = Default (YColorSolidOuts , -1)    Assert (!(YColorSolidOuts  <  -1 || YColorSolidOuts > 255), """"YColorSolidOuts" value must be between -1 and 255.""")
    UColorSolidOuts  = Default (UColorSolidOuts , -1)    Assert (!(UColorSolidOuts  <  -1 || UColorSolidOuts > 255), """"UColorSolidOuts" value must be between -1 and 255.""")
    VColorSolidOuts  = Default (VColorSolidOuts , -1)    Assert (!(VColorSolidOuts  <  -1 || VColorSolidOuts > 255), """"VColorSolidOuts" value must be between -1 and 255.""")
    YColorSolidIns   = Default (YColorSolidIns  , -1)    Assert (!(YColorSolidIns   <  -1 || YColorSolidIns  > 255), """"YColorSolidIns" value must be between -1 and 255.""")
    UColorSolidIns   = Default (UColorSolidIns  , -1)    Assert (!(UColorSolidIns   <  -1 || UColorSolidIns  > 255), """"UColorSolidIns" value must be between -1 and 255.""")
    VColorSolidIns   = Default (VColorSolidIns  , -1)    Assert (!(VColorSolidIns   <  -1 || VColorSolidIns  > 255), """"VColorSolidIns" value must be between -1 and 255.""")
    YOffsetIns       = Default (YOffsetIns      , -1)    Assert (!(YOffsetIns       <  -4 || YOffsetIns      >   0), """"YOffsetIns" value must be between -4 and 0.""")
    YOffsetOuts      = Default (YOffsetOuts     ,  1)    Assert (!(YOffsetOuts      <   0 || YOffsetOuts     >   4), """"YOffsetOuts" value must be between 0 and 4.""")
    UVOffsetIns      = Default (UVOffsetIns     , -2)    Assert (!(UVOffsetIns      <  -4 || UVOffsetIns     >   0), """"UVOffsetIns" value must be between -4 and 0.""")
    UVOffsetOuts     = Default (UVOffsetOuts    ,  2)    Assert (!(UVOffsetOuts     <   0 || UVOffsetOuts    >   4), """"UVOffsetOuts" value must be between 0 and 4.""")
    ShiftMasksVe     = Default (ShiftMasksVe    ,  0)    Assert (!(ShiftMasksVe     <  -1 || ShiftMasksVe    >   1), """"ShiftMasksVe" value must be between -1 and 1.""")
    ShiftMasksHo     = Default (ShiftMasksHo    ,  0)    Assert (!(ShiftMasksHo     <  -1 || ShiftMasksHo    >   1), """"ShiftMasksHo" value must be between -1 and 1.""")
    WholeDeblend     = Default (WholeDeblend    ,  0)    Assert (!(WholeDeblend     <   0 || WholeDeblend    >   1), """"WholeDeblend" value must be between 0 and 1.""")
                                                         if(WholeDeblend == 1) { Assert (Loc == "0,0,0,0" || Loc == "0,0,-0,-0" || Loc == "0, 0, 0, 0" || Loc == "0, 0, -0, -0", """"WholeDeblend" can be used only on a whole frame.""") }
    TriggerDynamic   = Default (TriggerDynamic  ,  0)    Assert (!(TriggerDynamic   <   0 || TriggerDynamic  >   1), """"TriggerDynamic" value must be between 0 and 1.""")
    DumpMasks        = Default (DumpMasks       ,  0)    Assert (!(DumpMasks        <   0 || DumpMasks       >   2), """"DumpMasks" value must be between 0 and 2.""")

    Optimize         = Default(Optimize         , (DynMask > 0 || Turbo > 0) ? 0 : 2)
                                                         Assert (!(Optimize         <   0 || Optimize        >   2), """"Optimize" value must be between 0 and 2.""")
                                                         Assert (!(Optimize         >   0 && Turbo           >   0), """"Optimize" can't be used with positive "Turbo".""")
                                                         Assert (!(Optimize         >   0 && DynMask        !=   0), """"Optimize" can't be used with "DynMask".""")
                                                         if(Optimize > 0) { Assert (!(sharpness != 45 || preBlur != 6.5 || postBlur != 4 || radius != 8), """"Optimize" can't be used with custom inpainting settings.""") }


    # Terminador de cucarachas #
    #==========================#


    bugloc      = (loc          == ""                   ) ? true : false
    bugloc2     = (loc          == "100,100,-100,-100"  ) ? true : false
    buganalyze  = (analyze     < -4 || analyze      >  3) ? true : false
    buganalyze2 = (analyze     == 0                     ) ? true : false
    bugreanalyze= (reanalyze    < 0 || reanalyze    >  1) ? true : false
    bugdeep     = (deep         < 1 || deep         >  5) ? true : false
    bugfrs      = (frs          < 0 || frs          >  3) ? true : false
    buginterp   = (interp       < 0 || interp       >  4) ? true : false
    buginterpm  = (interpm     < -1 || interpm      >  2) ? true : false
    bugdpp      = (dpp         < -8 || dpp          >  8) ? true : false
    bugdipp     = (dipp         <-8 || dipp         >  8) ? true : false
    bugopp      = (opp         < -8 || opp          >  8) ? true : false
    bugprepp    = (prepp        < 0 || prepp        >  1) ? true : false
    bugdppm     = (dppm         < 1 || dppm         >  3) ? true : false
    bugdippm    = (dippm        < 0 || dippm        >  3) ? true : false
    bugoppm     = (oppm         < 0 || oppm         >  3) ? true : false
    bugdynmask  = (dynmask      < 0 || dynmask      >  7) ? true : false
    bugdynflate = (dyninflate   < 0 || dyninflate   > 10) ? true : false
    buggrainpp  = (grainpp      < 0 || grainpp      >  3) ? true : false
    buginflate  = (inflate      < 0 || inflate      >  2) ? true : false
    bugiInflate = (iTinflate    < 0 || iTinflate    >  3) ? true : false
    bugoInflate = (oTinflate    < 0 || oTinflate    >  3) ? true : false
    bugotune    = (otune      < -10 || otune        > 10) ? true : false
    bugitune    = (itune      < -10 || itune        > 10) ? true : false
    bugamix     = (amix       < -50 || amix         >  5) ? true : false
    bugshow     = (show         < 0 || show         > 12) ? true : false
    bugmshow    = (mshow        < 0 || mshow        >  9) ? true : false
    bugautomask = (automask     < 0 || automask     >  1) ? true : false
    bugkillshape= (killshape    < 0 || killshape    >  1) ? true : false
    bugkillnoise= (killnoise   < -5 || killnoise    >  5) ? true : false
    bugkillblobs= (killblobs   < -8 || killblobs    >  8) ? true : false
    bugpreblobs = (preblobs    < -2 || preblobs     >  2) ? true : false
    bugrepass   = (repass       < 0 || repass       >  2) ? true : false
    bugdynmask3h= (dynmask3h    < 0 || dynmask3h  >  200) ? true : false
    bugmodesh   = (modesh       < 0 || modesh       >  1) ? true : false
    bugtuneh1   = (tuneh1       < 0 || tuneh1       >  7) ? true : false
    bugtuneh2   = (tuneh2       < 0 || tuneh2       >  4) ? true : false
    bugtuneh3   = (tuneh3       < 0 || tuneh3       >  3) ? true : false
    bugkillnoiseh= (killnoiseh  < 0 || killnoiseh   >  2) ? true : false
    bugrepassh  = (repassh      < 0 || repassh      >  1) ? true : false
    bugdynmask4h= (dynmask4h    < 1 || dynmask4h  >  200) ? true : false
    bugdynmaskup= (dynmaskup   < -4 || dynmaskup    >  4) ? true : false
    bugdynlocup = (dynlocup     < 1 || dynlocup     >  4) ? true : false
    bugturbo    = (turbo        <-2 || turbo        >  3) ? true : false
    bugedgepp   = (edgepp       < 0 || edgepp       >  3) ? true : false
    bugedgepos  = (edgepos     < -1 || edgepos      >  1) ? true : false
    bugedgewide = (edgewide     < 0 || edgewide     >  3) ? true : false
    bugintspd   = (intspd       < 1 || intspd       >  4) ? true : false
    bugmode     = (mode         != "inpaint" && mode != "deblend" && mode != "both" ) ? true : false
    bugcombo1   = (mode         == "inpaint" && mshow   >  4 && mshow <  9) ? true : false
    bugcombo2   = (mode         != "inpaint" && analyze == -3 && FrB == FrW) ? true : false
    bugcombo3   = (mode         != "inpaint" && killshape == 1) ? true : false
    bugcombo4   = (IsString(mask) && dynmask==0) ? eval(""" bugcombo4 = (mask == "") ? true : false return bugcombo4 """) : false
    bugcombo5   = (IsString(mask) && dynmask==0) ? eval(""" bugcombo5 = (findstr(mask,":") == 0) ? true : false return bugcombo5 """) : false
    bugcombo6   = (ClpBlend   == 0 && show != 3 && dynmask == 3 || DynPostTune == 0 && show != 3 && dynmask == 3) ? true : false
    bugcombo7   = (mode   == "inpaint" && edgePP  !=  0        ) ? true : false
    bugcombo8   = (dynmask   != 3      && repass  !=  0        ) ? true : false
    bugcombo9   = (dynmask3h == 0 && dynmask != 4  && show == 6) ? true : false
    bugcombo10  = (dynmask3h != 0      && dynmask !=  3        ) ? true : false
    bugcombo11  = (Extract   == 1      && show    !=  4        ) ? true : false
    bugcombo12  = (Automask  == 1 && Analyze == 1 || Automask == 1 && Analyze == -1) ? true : false
    bugcombo13  = ((Show == 7 || Show == 8 || Show == 9) && (Analyze == -3 || Analyze == -4 || Analyze == 0 || Analyze == 3)) ? true : false
    bugcombo14  = (mShow          == 8 && edgePP  ==  0        ) ? true : false
    bugcombo15  = (dynmaskup       < 0 && dynlocup  >  1       ) ? true : false
    bugDyn3Seq     = (Dyn3Seq      < 8 || Dyn3Seq  >       9999) ? true : false
    bugClpBlend    = (ClpBlend     < 6 || ClpBlend >= Dyn3Seq-1) ? true : false
    bugDynPostTune = (DynPostTune  < 0 || DynPostTune      >  5) ? true : false
    bugDyn3buffer  = (Dyn3buffer   < 0 || Dyn3buffer       >  1) ? true : false
    bugDynColorTol = (DynColorTol  < 1 || DynColorTol     > 140) ? true : false
    bugDynColorInf = (DynColorInf  < 0 || DynColorInf       > 4) ? true : false
    bugDynTEdge    = (DynTEdge     < 0 || DynTEdge          > 1) ? true : false
    bugDynTEdgeThY = (DynTEdgeThY  < 2 || DynTEdgeThY     > 100) ? true : false
    bugDynTEdgeInf = (DynTEdgeInf  < 0 || DynTEdgeInf       > 8) ? true : false
    bugDynTuneInf  = (DynTuneInf  < -1 || DynTuneInf        > 4) ? true : false


    assert        ( bugcombo4         == false  , """You have to define the "mask" string""")
    assert        ( bugcombo5         == false  , "Specify full path to the logo mask!")
    assert        ( bugcombo6         == false  , """There is nothing to do with these settings, fine tune this mask in "Show=3".""")
    assert        ( bugloc            == false  , """You must define "Loc".""")
    assert        ( bugloc2           == false  , """Use "InpaintLoc" function to get crop values for "Loc".""")
    assert        ( bugmode           == false  , """This mode doesn't exist. Change "Mode" value.""")
    assert        ( bugcombo1         == false  , "Calculating the meaning of life and everything. Meanwhile RTM.")
    assert        ( bugcombo2         == false  , "Calculating the meaning of life and everything. Meanwhile RTM.")
    assert        ( bugcombo3         == false  , """"KillShape" parameter is only for "Inpaint" mode.""")
    assert        ( bugcombo7         == false  , """"EdgePP" parameter is not for "Inpaint" mode.""")
    assert        ( bugcombo8         == false  , """"RePass" parameter is only for "DynMask=3" method.""")
    assert        ( bugcombo9         == false   , """"Show=6" parameter is only for "DynMask3H" & "DynMask=4" mask.""")
    assert        ( bugcombo10        == false   , """"DynMask3H" parameter is only for "DynMask=3" method.""")
    assert        ( bugcombo11        == false   , """Subtitles extraction works only with "Show=4" parameter.""")
    assert        ( bugcombo12        == false   , """"Analyze" 1 & -1 can't be used with "Automask=1".""")
    assert        ( bugcombo13        == false   , """Incompatible "Show" and "Analyze" parameters.""")
    assert        ( bugcombo14        == false   , """Incompatible "EdgePP" and "mShow" parameters.""")
    assert        ( bugcombo15        == false   , """Incompatible "DynMaskUp" and "DynLocUp" parameters.""")
    assert        ( buganalyze        == false  , """"Analyze" value must be between -4 and 3.""")
    assert        ( buganalyze2       == false  , """"Analyze" can't be 0.""")
    assert        ( bugreanalyze      == false  , """"ReAnalyze" value must be between 0 and 1.""")
    assert        ( bugdeep           == false  , """"Deep" value must be between 1 and 5.""")
    assert        ( bugfrs            == false  , """"FrS" value must be between 0 and 3.""")
    assert        ( buginterp         == false  , """"Interp" value must be between 0 and 4.""")
    assert        ( buginterpm        == false  , """"InterpM" value must be between -1 and 2.""")
    assert        ( bugdpp            == false  , """"dPP" value must be between -8 and 8.""")
    assert        ( bugdipp           == false  , """"diPP" value must be between -8 and 8.""")
    assert        ( bugopp            == false  , """"oPP" value must be between -8 and 8.""")
    assert        ( bugprepp          == false  , """"prePP" value must be between 0 and 1.""")
    assert        ( bugdppm           == false  , """"dPPm" value must be between 1 and 3.""")
    assert        ( bugdippm          == false  , """"diPPm" value must be between 0 and 3.""")
    assert        ( bugoppm           == false  , """"oPPm" value must be between 0 and 3.""")
    assert        ( bugdynmask        == false  , """"DynMask" value must be between 0 and 7.""")
    assert        ( bugdynflate       == false  , """"DynInflate" value must be between 0 and 10.""")
    assert        ( buggrainpp        == false  , """"GrainPP" value must be between 0 and 3.""")
    assert        ( buginflate        == false  , """"Inflate" value must be between 0 and 2.""")
    assert        ( bugiInflate       == false  , """"iTinflate" value must be between 0 and 3.""")
    assert        ( bugoInflate       == false  , """"oTinflate" value must be between 0 and 3.""")
    assert        ( bugotune          == false  , """"oTune" value must be between -10 and 10.""")
    assert        ( bugitune          == false  , """"iTune" value must be between -10 and 10.""")
    assert        ( bugamix           == false  , """"aMix" value must be between -50 and 5.""")
    assert        ( bugshow           == false  , """"Show" value must be between 0 and 12.""")
    assert        ( bugmshow          == false  , """"mShow" value must be between 0 and 8.""")
    assert        ( bugautomask       == false  , """"Automask" value must be between 0 and 1.""")
    assert        ( bugkillshape      == false  , """"KillShape" value must be between 0 and 1.""")
    assert        ( bugkillnoise      == false  , """"KillNoise" value must be between -5 and 5.""")
    assert        ( bugkillblobs      == false  , """"KillBlobs" value must be between -8 and 8.""")
    assert        ( bugpreblobs       == false  , """"preBlobs" value must be between -2 and 2.""")
    assert        ( bugrepass         == false  , """"RePass" value must be between 0 and 2.""")
    assert        ( bugdynmask3h      == false  , """"DynMask3H" value must be between 0 and 200.""")
    assert        ( bugmodesh         == false  , """"ModeSH" value must be between 0 and 1.""")
    assert        ( bugtuneh1         == false  , """"TuneH1" value must be between 0 and 7.""")
    assert        ( bugtuneh2         == false  , """"TuneH2" value must be between 0 and 4.""")
    assert        ( bugtuneh3         == false  , """"TuneH3" value must be between 0 and 3.""")
    assert        ( bugkillnoiseh     == false  , """"KillNoiseH" value must be between 0 and 2.""")
    assert        ( bugrepassh        == false  , """"RePassH" value must be between 0 and 1.""")
    assert        ( bugdynmask4h      == false  , """"DynMask4H" value must be between 1 and 200.""")
    assert        ( bugdynmaskup      == false  , """"DynMaskUp" value must be between -4 and 4.""")
    assert        ( bugdynlocup       == false  , """"DynLocUp" value must be between 1 and 4.""")
    assert        ( bugturbo          == false  , """"Turbo" value must be between -2 and 3.""")
    assert        ( bugedgepp         == false  , """"EdgePP" value must be between 0 and 3.""")
    assert        ( bugedgepos        == false  , """"EdgePos" value must be between -1 and 1.""")
    assert        ( bugedgewide       == false  , """"EdgeWide" value must be between 0 and 3.""")
    assert        ( bugintspd         == false  , """"IntSpd" value must be between 1 and 4.""")
    (automask == 1) ? assert ( revstr(mask).findstr("pmb.") == 1 , """Try bmp extension for "mask".""") : nop
    assert        ( bugDyn3Seq        == false  , """"Dyn3Seq" is out of the optimal range.""")
    (ClpBlend != 0) ? assert        ( bugClpBlend == false  , """"ClpBlend" is out of range.""") : nop
    assert        ( bugDynPostTune    == false  , """"DynPostTune" value must be between 0 and 5.""")
    assert        ( bugDyn3buffer     == false  , """"Dyn3buffer" value must be between 0 and 1.""")
    assert        ( bugDynColorTol    == false  , """"DynColorTol" value must be between 1 and 140.""")
    assert        ( bugDynColorInf    == false  , """"DynColorInf" value must be between 0 and 4.""")
    assert        ( bugDynTEdge       == false  , """"DynTEdge" value must be between 0 and 1.""")
    assert        ( bugDynTEdgeThY    == false  , """"DynTEdgeThY" value must be between 2 and 100.""")
    assert        ( bugDynTEdgeInf    == false  , """"DynTEdgeInf" value must be between 0 and 8.""")
    assert        ( bugDynTuneInf     == false  , """"DynTuneInf" value must be between -1 and 4.""")

    if(IsString(mask) && FindStr(mask, ".ebmp") > 0 || Automask == 0 && IsString(mask) && FindStr(mask, ".bmp") > 0) {Assert (mask.Exist, """"Mask" file not found!""")}


    # Settings #
    #==========#


    clp         = (ComponentSize(clp) == 1) ? clp : clp.ConvertBits(8)
    x           = width(clp)
    y           = height(clp)
    interp      = (interp == 1) ? 0.84 : (interp == 2) ? 0.73 : (interp == 3) ? 0.59 : (interp == 4) ? 0.40 :  0
    frx         = (frs    == 1) ?   -5 : (frs    == 2) ?  -10 : (frs    == 3) ?  -30 : -1
    tunelow     = int((-1*otune)*10+140)
    tunehigh    = int((-1*otune)*10+141)
    itunelow    = int((-1*itune)*10+140)
    itunehigh   = int((-1*itune)*10+141)
    amixlow     = int((-1*amix)*3+19)
    amixhigh    = int((-1*amix)*3+20)
    isHD        = (x > 576) ? true : false
    matrixID    = (isHD == true) ? "Rec709" : "Rec601"
    mskPatch    = (maskPatch != "") ? 1 : 0

    # Hard overrides:
    reanalyze   = (mode  == "inpaint" && dynmask  != 0) ? 1 : reanalyze
    deep        = (mode  == "inpaint" || automask == 1) ? 1 : deep
    dynmask     = (mode  == "deblend"                 ) ? 0 : dynmask
    analyze     = (mode  == "inpaint" && automask != 1) ? 0 : analyze
    interp      = (mode  == "inpaint"                 ) ? 0 : interp
    interpm     = (mode  == "inpaint"                 ) ? 0 : interpm
    interpm     = (mode  == "both"    && interpm == -1) ? 0 : interpm
    interpmInfl = (interpm == -1                      ) ? 0 : interpm
    FrW         = (analyze == -4                      ) ? 0 : FrW
    dppm        = (dpp     ==  0      && interp   < 1 ) ? 0 : dppm          # bug with interp here?????????????
    dippm       = (dipp    ==  0                      ) ? 0 : dippm
    oppm        = (opp     ==  0                      ) ? 0 : oppm
    prepp       = (prepp   !=  0                      ) ? 3 : prepp

    # DumpMasks=2
    YColorSolidOuts = (DumpMasks == 2) ?   0 : YColorSolidOuts
    UColorSolidOuts = (DumpMasks == 2) ? 128 : UColorSolidOuts
    VColorSolidOuts = (DumpMasks == 2) ? 128 : VColorSolidOuts
    YAlphaSolidOuts = (DumpMasks == 2) ?   0 : YAlphaSolidOuts
    UAlphaSolidOuts = (DumpMasks == 2) ?   0 : UAlphaSolidOuts
    VAlphaSolidOuts = (DumpMasks == 2) ?   0 : VAlphaSolidOuts

    # DynMask:
    KillNoise   = (killnoise ==  1                    ) ?  81 :
    \             (killnoise ==  2                    ) ?  82 :
    \             (killnoise ==  3                    ) ?  83 :
    \             (killnoise ==  4                    ) ?  84 :
    \             (killnoise ==  5                    ) ?  85 :
    \             (killnoise == -1                    ) ? -81 :
    \             (killnoise == -2                    ) ? -82 :
    \             (killnoise == -3                    ) ? -83 :
    \             (killnoise == -4                    ) ? -84 :
    \             (killnoise == -5                    ) ? -85 : killnoise
    KillNoiseH  = (killnoiseH == 1                    ) ?  81 :
    \             (killnoiseH == 2                    ) ?  82 : KillNoiseH

    # DynMask 3:
    DynPostTune = (ClpBlend ==  0                     ) ? 0 : DynPostTune
    Dyn3buffer  = (ClpBlend ==  0                     ) ? 0 : Dyn3buffer
    DynPostTuneLow = int(255-DynPostTune)

    # DynMask=5 / DynColor:
    DynInflate    = (DynMask ==  5                    ) ? 0 : DynInflate

    if (IsString(DynColor)) {
        ColorSwitch = 2
        assert(findstr(DynColor,"$") != 0, """Wrong "DynColor" value!""")
    } else if (IsInt(DynColor)) {
        if (DynColor == 0) {
            ColorSwitch = 0
            assert(!(DynMask == 5), """Nothing to do for "DynMask=5" if "DynColor=0".""")
        } else {
            ColorSwitch = 1
            assert(!(DynColor < 0 || DynColor > 16777215), """"DynColor" value must be between $000000 and $FFFFFF.""")
        }
    } else {
        assert(false, """Wrong "DynColor" value!""")
    }

    assert(!(ColorSwitch > 0 && DynMask < 2), """"DynColor" can be used only with internal "DynMask" methods.""")

    # DynMask=6 / DynTune:
    DynInflate    = (DynMask ==  6                    ) ? 0 : DynInflate

    if (IsString(DynTune)) {
        assert(findstr(DynTune," - ") != 0, """Wrong "DynTune" value!""")
        LumaSwitch = 2
        LumaMin    = Int(Value( LeftStr(DynTune, 3)))
        LumaMax    = Int(Value(RightStr(DynTune, 3)))
        assert(!(LumaMin >= LumaMax), """Wrong "DynTune" value!""")
        LumaExpr   = "x xxx > x yyy < & 255 0 ?"
        LumaExpr   = ReplaceStr(LumaExpr,"xxx", Format("{LumaMin}"))
        LumaExpr   = ReplaceStr(LumaExpr,"yyy", Format("{LumaMax}"))
        assert(!(LumaMin < 1 || LumaMin > 254), """"DynTune" values must be between 10 and 254.""")
        assert(!(LumaMax < 1 || LumaMax > 254), """"DynTune" values must be between 10 and 254.""")
        DynTune = LumaMin
    } else if (IsInt(DynTune)) {
        LumaSwitch = 1
        assert(!(DynTune < 1 || DynTune > 254), """"DynTune" value must be between 10 and 254.""")
    } else {
        assert(false, """Wrong "DynTune" value!""")
    }

    # DynMask=7 / DynTEdge:
    DynInflate    = (DynMask ==  7                    ) ? 0 : DynInflate

    te_bugcombo0  = (DynTEdge       == 0 && DynMask       == 7) ? true : false
    te_bugcombo1  = (DynTEdge        > 0 && DynMask        < 2) ? true : false
    assert        ( te_bugcombo0   == false   , """Nothing to do for "DynMask=7" if "DynTEdge=0".""")
    assert        ( te_bugcombo1   == false   , """"DynTEdge" can be used only with internal "DynMask" methods.""")

    # "Turbo" presets:
    opp         = (turbo ==  1 && mode == "inpaint") ?  6 :
    \             (turbo ==  2 && mode == "inpaint") ?  7 :
    \             (turbo ==  3 && mode == "inpaint") ?  7 :
    \             (turbo >   0 && mode == "both"   ) ?  6 : opp
#    killshape   = (turbo != 0 && mode == "inpaint" ) ? 1 : killshape
#    prepp       = (turbo != 0 && mode == "inpaint" ) ? 1 : prepp
    radius      = (turbo ==  1                     ) ?  6 :
    \             (turbo ==  2                     ) ?  4 :
    \             (turbo ==  3                     ) ?  2 :
    \             (turbo == -1                     ) ? 16 :
    \             (turbo == -2                     ) ? 16 : radius
    sharpness   = (turbo >   0                     ) ?  0 : sharpness
    preblur     = (turbo == -1                     ) ?  4 :
    \             (turbo == -2                     ) ?  4 :
    \             (turbo >   0                     ) ?  0 : preblur
    postblur    = (turbo == -1                     ) ?  8 :
    \             (turbo == -2                     ) ? 12 :
    \             (turbo >   0                     ) ?  0 : postblur


    # ebmp masks input #
    #==================#


    if(IsString(mask) && RightStr(mask, 4) == "ebmp") {
        ebmpMasks = ImageSource(mask,0,0)

        if(IsY(ebmpMasks)) {
            ebmpIn     = 1
            Automask   = 0
            Reanalyze  = 0
            Analyze    = (mode == "Inpaint") ? 0 : 2

            LogoColorY = ebmpMasks.Crop(0,0,ebmpMasks.width/3*2,0).Crop(0,0,0,ebmpMasks.Height/3)
            LogoAlphaY = ebmpMasks.Crop(0,0,ebmpMasks.Width/3*2,0).Crop(0,ebmpMasks.Height/3,0,0).Crop(0,0,0,ebmpMasks.Height/3)
            LogoColorU = ebmpMasks.Crop(ebmpMasks.Width/3*2,0,0,0).Crop(0,0,0,ebmpMasks.Height/3).Crop(0,0,0,ebmpMasks.Height/6)
            LogoAlphaU = ebmpMasks.Crop(ebmpMasks.Width/3*2,0,0,0).Crop(0,0,0,ebmpMasks.Height/3).Crop(0,ebmpMasks.Height/6,0,0)
            LogoColorV = ebmpMasks.Crop(ebmpMasks.Width/3*2,0,0,0).Crop(0,ebmpMasks.Height/3,0,0).Crop(0,0,0,ebmpMasks.Height/6)
            LogoAlphaV = ebmpMasks.Crop(ebmpMasks.Width/3*2,0,0,0).Crop(0,ebmpMasks.Height/2,0,0).Crop(0,0,0,ebmpMasks.Height/6)
            ebmpBase   = ebmpMasks.Crop(0,0,ebmpMasks.Width/3*2,0).Crop(0,Int(ebmpMasks.Height/1.5),0,0)

            ebmpW = ebmpBase.width
            ebmpH = ebmpBase.height

        } else if(IsRGB32(ebmpMasks)) {
            ebmpIn     = 2
            Automask   = 0
            Deep       = 1
            Reanalyze  = 0
            Analyze    = (mode == "Inpaint") ? 0 : -2

            LogoColor  = ebmpMasks.Crop(0,0,0,ebmpMasks.Height/3)
            LogoAlpha  = ebmpMasks.Crop(0,ebmpMasks.Height/3,0,0).Crop(0,0,0,ebmpMasks.Height/3)
            LogoAlpha  = LogoAlpha.Mask(LogoAlpha)
            ebmpBase   = ebmpMasks.Crop(0,Int(ebmpMasks.Height/1.5),0,0)

            ebmpW = ebmpBase.width
            ebmpH = ebmpBase.height

        } else {
            Assert (false, "Incompatible ebmp file.")
        }
    } else {
        ebmpIn = 0
    }


    # Crop #
    #======#


    loc         = ReplaceStr(loc," ","")
    long        = StrLen(loc)

    posvirg1    = findstr(loc, ",")
    posvirg2    = findstr(rightstr(loc,long-posvirg1), ",")
    posvirg2    = posvirg2+posvirg1
    posvirg3    = findstr(rightstr(loc,long-posvirg2), ",")
    posvirg3    = posvirg3 + posvirg2

    a           = int(value(leftstr(loc,posvirg1-1)))
    b           = int(value(leftstr(rightstr(loc,long-posvirg1),posvirg2-posvirg1-1)))
    c           = (ebmpIn > 0) ? ebmpW : int(value(leftstr(rightstr(loc,long-posvirg2),posvirg3-posvirg2-1)))
    d           = (ebmpIn > 0) ? ebmpH : int(value(rightstr(loc,long-posvirg3)))

    a           = (a < 0 ) ? x+a  : a         # ssS: Added, convert -ve logoX  to +ve LogoX
    b           = (b < 0 ) ? y+b  : b         # ssS: Added, convert -ve logoY  to +ve LogoY
    c           = (c > 0 ) ? a+c-x: c         # ssS: Added, convert +ve width  to -ve width
    d           = (d > 0 ) ? b+d-y: d         # ssS: Added, convert +ve height to -ve height

    Assert (c   <= 0 && d <= 0,"""Incorrect "Loc".""")
    Assert (a   >= 0 && b >= 0,"""Incorrect "Loc".""")
    Assert (a%2 == 0 && b%2 == 0 && c%2 == 0 && d%2 == 0,"""Use even numbers for "Loc".""")

    clpFC       = clp.framecount
    clpLoc      = clp.Crop(a,b,c,d)
    locW        = clpLoc.width
    locH        = clpLoc.height

    blankblk    = BlankClip(clp,length=1,pixel_type="RGB32").Crop(a,b,c,d)
    blankwht    = BlankClip(clp,color=$FFFFFF,length=30,pixel_type="RGB24").Crop(a,b,c,d)

    inRGB24     = IsRGB24(clp) ? clpLoc : clpLoc.ConvertToRGB24(matrix=matrixID)
    inRGB32     = IsRGB32(clp) ? clpLoc : clpLoc.ConvertToRGB32(matrix=matrixID)
    inYV12      = IsYV12( clp) ? clpLoc : clpLoc.ConvertToYV12(matrix=matrixID)

    inYV12a     = (DynLocUp < 2) ? inYV12 :
    \                              inYV12.SincResize(locW*DynLocUp, locH*DynLocUp, taps=2)

    inY8        = (DynLocUp < 2) ? inYV12.ExtractY :
    \                              inYV12.ExtractY.SincResize(locW*DynLocUp, locH*DynLocUp, taps=2)


    # Static or dynamic mask? Ect.. #
    #===============================#


    maskClip    = IsClip(mask)
    maskDynamic = (maskClip  == true) ? eval("""
                  maskDynamic  = (mask.FrameCount == 1) ? false : true
                  return maskDynamic """) : false

    dynmask     = (maskdynamic ==  true) ? 1 : dynmask

    Assert (!(dynmask == 1 && mode        != "inpaint"), """"mask" as a dynamic mask works only in "Inpaint" mode.""")
    Assert (!(dynmask == 1 && maskdynamic ==     false), """"mask" is not a dynamic mask.""")
    Assert (!(dynmask == 0 && maskdynamic ==      true), """"mask" is a dynamic mask when expected a static mask.""")
    Assert (!(show == 3    && dynmask     !=         3), """"Show=3" is only for the "DynMask=3".""")
    Assert (!(show == 4    && dynmask     ==         0), """"Show=4" is only for the dynamic masks.""")
    Assert (!(show == 5    && dynmask     ==         0), """"Show=5" is only for the dynamic masks.""")
    Assert (!(show == 5    && DynLocUp     >         1), """"Show=5" can't be used with "DynLocUp".""")
    Assert (!(show == 5    && DynMaskUp    >         1), """"Show=5" can't be used with "DynMaskUp".""")
    Assert (!(show == 10   && dynmask     ==         0), """"Show=10" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 10   && dynmask     ==         1), """"Show=10" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 10   && dynmask     ==         3), """"Show=10" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 10   && dynmask     ==         4), """"Show=10" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 11   && dynmask     ==         0), """"Show=11" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 11   && dynmask     ==         1), """"Show=11" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 11   && dynmask     ==         3), """"Show=11" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 11   && dynmask     ==         4), """"Show=11" is only for DynMask=2/5/6/7.""")
    Assert (!(show == 12   && dynmask     ==         0), """"Show=12" is only for the dynamic masks.""")

    Clipmask    = (maskClip == true) ? eval("""
                  Clipmask = (maskdynamic == true) ? mask.ConvertToY8(matrix="PC.709") : mask.ConvertToRGB32
                  return Clipmask """) : nop


    # LogoID #
    #========#


    MskName     = (IsString(mask)) ? mask : "Clip"
    CoordsID    = string(a)+"-"+string(b)+"-"+string(abs(c))+"-"+string(abs(d))

    if(analyze == 3) {
        LogoID = MskName+"_InpaintDelogo3_"+CoordsID+"_A"+string(Analyze)
    } else if(analyze > 0) {
        LogoID = MskName+"_InpaintDelogo3_"+CoordsID+"_A"+string(Analyze)+"-"+string(AnalyzeTh)
    } else if(analyze == -1 || analyze == -2 ) {
        LogoID = MskName+"_InpaintDelogo3_"+CoordsID+"_A"+string(Analyze)+"-"+string(AnalyzeTh)+"_Deep1"
    } else {
        LogoID = MskName+"_InpaintDelogo3_"+CoordsID+"_A"+string(Analyze)+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs)+"_Deep1"
    }


    # Creation of the basemask. #
    #===========================#


    DummyMsk    = blankblk.Subtitle("Dummy", text_color=color_white, align=5)

    Imgmask     = (ebmpIn    > 0                            ) ? ebmpBase.ConvertToRGB32(Matrix="PC.601") :
    \             (Automask == 1                            ) ? DummyMsk :
    \             (dynmask  == 2 && mode == "both"          ) ? ImageSource(mask,0,0).Greyscale.ConvertToRGB32.Crop(a,b,c,d).Levels(254,1,255,0,255) :
    \             (dynmask   > 1                            ) ? DummyMsk :
    \             (maskClip == false                        ) ? ImageSource(mask,0,0).Greyscale.ConvertToRGB32.Crop(a,b,c,d).Levels(254,1,255,0,255) :
    \             (maskClip == true  && maskdynamic == false) ? Clipmask : DummyMsk
    Imgmask     = Imgmask.Mask(Imgmask)

    BasemaskP   = (Killshape == 0) ? Imgmask :
    \                                Imgmask.balloonPX(99)
    Basemask    = BasemaskP.balloonPX(inflate)
    BasemaskY   = Imgmask.ConvertToY8(Matrix="PC.601").mt_expand().mt_expand()
    BasemaskUV  = BasemaskY.PointResize(LocW/2, LocH/2)

    Assert (!(LocW != Imgmask.width || LocH != Imgmask.height), """Clip and "mask" image must have same dimensions.""")


    # Auto-Generation of the base mask. #
    #===================================#


    if(Automask == 1) {
        MaskID = LeftStr(mask,int(StrLen(mask)-4))
        AutoID = LeftStr(mask,int(StrLen(mask)-4)) +"_AutomaskTemp_A"+string(Analyze)

        bAutoClp  = BlankClip(clp,length=1).ConvertToRGB24
        wAutoClp  = (Loc == "0,0,0,0" || Loc == "0,0,-0,-0" || Loc == "0, 0, 0, 0" || Loc == "0, 0, -0, -0") ? BlankClip(clp,color=$FFFFFF,length=1).ConvertToRGB24.Crop(1,1,-1,-1) :
        \                                                                                                      BlankClip(clp,color=$FFFFFF,length=1).ConvertToRGB24.Crop(a,b,c,d)
        aMerge    = (Loc == "0,0,0,0" || Loc == "0,0,-0,-0" || Loc == "0, 0, 0, 0" || Loc == "0, 0, -0, -0") ? bAutoClp.Overlay(wAutoClp,x=a+1,y=b+1).ConvertToRGB32 :
        \                                                                                                      bAutoClp.Overlay(wAutoClp,x=a,y=b).ConvertToRGB32
        aMerge    = (Loc == "0,0,0,0" || Loc == "0,0,-0,-0" || Loc == "0, 0, 0, 0" || Loc == "0, 0, -0, -0") ? aMerge.ConvertToY8(matrix="PC.709").MTballoon2PX(-6).ConvertToRGB32(matrix="PC.709") :
        \                                                                                                      aMerge.ConvertToY8(matrix="PC.709").MTballoon2PX(-7).ConvertToRGB32(matrix="PC.709")
        aMerge    = aMerge.Mask(aMerge).Crop(a,b,c,d)


        if(reanalyze == 0 && Exist(AutoID +".bmp")) {
            ImageSource(AutoID + "%.0d.bmp",0,0)
        } else {
            if(reanalyze == 1) {
                RT_FileDelete(LogoID +".txt")
            }
            if(Analyze == -3 || Analyze == -4 || Analyze == -2) {
                inRGB24.AnalyzeMethods(Analyze, blankwht=blankwht, FrB=FrB, FrW=FrW, FrS=FrS, frx=frx, FramesLog=LogoID)
                last.Analyzelogo(aMerge).Trim(0,-1).ConvertToRGB32
            } else if(Analyze == 2) {
                inYV12.AnalyzeMethods(Analyze, mask=BasemaskP, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID)
                last.ConvertToY8.Analyzelogo(aMerge).Trim(0,-1).ConvertToRGB32(matrix=matrixID)
            } else if(Analyze == 3) {
                inYV12.ConvertToY8.Analyzelogo(aMerge).Trim(0,-1).ConvertToRGB32(matrix=matrixID)
            }
            Crop(0,last.Height/2,0,0)
            ImageWriter(AutoID  + "%.0d.bmp",0,-1,"bmp").RT_YankChain(n=0)
        }

        bAutoClp.Overlay(last,x=a,y=b).ConvertToRGB32

        Levels(amixlow,1,amixhigh,0,255)
        ImageWriter(MaskID  + "%.0d.bmp",0,-1,"bmp").RT_YankChain(n=0)
        Autologo = Last
    }


    # Analyze process (Color & Alpha masks creation). #
    #=================================================#


    if(automask == 0 && ebmpIn == 0) {
        if(analyze > 0) {
            if(reanalyze == 0 && Exist(LogoID +".ebmp")) {
                Logo = ImageSource(LogoID + "%.0d.ebmp",0,0)
            } else {
                if(reanalyze == 1) {
                    RT_FileDelete(LogoID +".txt")
                }
                if(analyze == 3) {
                    if (clpFC < 10) {
                        inYV12.loop(200)
                    } else if (clpFC < 20) {
                        inYV12.loop(40)
                    } else if (clpFC < 40) {
                        inYV12.loop(20)
                    } else if (clpFC < 80) {
                        inYV12.loop(10)
                    } else if (clpFC < 160) {
                        inYV12.loop(5)
                    } else if (clpFC < 320) {
                        inYV12.loop(2)
                    } else {
                        inYV12
                    }
                } else {
                    inYV12.AnalyzeMethods(Analyze, mask=BasemaskP, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID)
                }
                YYY = last.ConvertToY8
                UUU = last.UToY8
                VVV = last.VToY8
                FFF = last
                YYYm   = YYY.AnalyzeLogo(mask=BasemaskY).Trim(0,-1)
                ScanY  = StackVertical(YYYm,Imgmask.ConvertToY8(Matrix="PC.601"))
                FFFm   = FFF.AnalyzeLogo(mask=BasemaskY).Trim(0,-1)
                CCCm   = FFFm.crop(0,0,0,locH)
                uvA    = FFFm.crop(0,locH,0,0).ConvertToY8.Spline36Resize(LocW/2, locH/2)
                ScanU  = StackVertical(CCCm.UToY8, uvA)
                ScanV  = StackVertical(CCCm.VToY8, uvA)
                ScanUV = StackVertical(ScanU,ScanV,BlankClip(ScanV))
                StackHorizontal(ScanY,ScanUV)
                ImageWriter(LogoID +"%.0d.ebmp",0,1,"ebmp").RT_YankChain(n=0)
                Logo = last
            }
        } else if(analyze < 0) {
            if(reanalyze == 0 && Exist(LogoID +".ebmp")) {
                Logo = ImageSource(LogoID + "%.0d.ebmp",0,0)
            } else {
                if(Analyze < -2) {
                    inRGB24.AnalyzeMethods(Analyze, blankwht=blankwht, FrB=FrB, FrW=FrW, FrS=FrS, frx=frx)
                } else if(Analyze == -1 || Analyze == -2) {
                    if(reanalyze == 1) {
                        RT_FileDelete(LogoID +".txt")
                    }
                    inRGB24.AnalyzeMethods(Analyze, mask=BasemaskP, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID)
                }
                last.Analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                StackVertical(last,Imgmask.ConvertToRGB24.ConvertToRGB32)
                ImageWriter(LogoID +"%.0d.ebmp",0,-1,"ebmp").RT_YankChain(n=0)
                Logo = last
            }
        }
    }


    # Have you weared your mask today? #
    #==================================#


    if(automask == 0) {
        InterpMask  = Basemask.balloonPX(interpmInfl)

        if(analyze > 0 || ebmpIn == 1) {
            if(ebmpIn == 0) {
                LogoColorY  = Logo.Crop(0,0,Logo.width/3*2,0).Crop(0,0,0,Logo.Height/3)
                LogoAlphaY  = Logo.Crop(0,0,Logo.Width/3*2,0).Crop(0,Logo.Height/3,0,0).Crop(0,0,0,Logo.Height/3)
                LogoColorU  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,0,0,Logo.Height/3).Crop(0,0,0,Logo.Height/6)
                LogoAlphaU  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,0,0,Logo.Height/3).Crop(0,Logo.Height/6,0,0)
                LogoColorV  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,Logo.Height/3,0,0).Crop(0,0,0,Logo.Height/6)
                LogoAlphaV  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,Logo.Height/2,0,0).Crop(0,0,0,Logo.Height/6)
            }

            # Customizing masks:
            if(IsClip(YAlphaExternal)) { Assert (YAlphaExternal.width == x || YAlphaExternal.height == y, """Wrong "YAlphaExternal" resolution.""") }
            LogoAlphaY  = (IsClip(YAlphaExternal)) ? YAlphaExternal.Trim(0,-1).ConvertToY8(matrix="PC.709") : LogoAlphaY

            LogoAlphaY  = (YAlphaTweak != 0) ? LogoAlphaY.Tweak(bright=YAlphaTweak,coring=false) : LogoAlphaY
            LogoAlphaU  = (UAlphaTweak != 0) ? LogoAlphaU.Tweak(bright=UAlphaTweak,coring=false) : LogoAlphaU
            LogoAlphaV  = (VAlphaTweak != 0) ? LogoAlphaV.Tweak(bright=VAlphaTweak,coring=false) : LogoAlphaV

            if(YColorSolid > -1) { LogoColorY = BlankClip(LogoColorY, Color_yuv=YColorSolid*65536, pixel_type="Y8") }
            if(UColorSolid > -1) { LogoColorU = BlankClip(LogoColorU, Color_yuv=UColorSolid*65536, pixel_type="Y8") }
            if(VColorSolid > -1) { LogoColorV = BlankClip(LogoColorV, Color_yuv=VColorSolid*65536, pixel_type="Y8") }

            if(YAlphaSolidOuts > -1 || YAlphaSolidIns > -1 || UAlphaSolidOuts > -1 || UAlphaSolidIns > -1 || VAlphaSolidOuts > -1 || VAlphaSolidIns > -1 || YColorSolidOuts > -1 || YColorSolidIns > -1 || UColorSolidOuts > -1 || UColorSolidIns > -1 || VColorSolidOuts > -1 || VColorSolidIns > -1) {
                BasemaskYo  = Imgmask.ConvertToY8(Matrix="PC.601").MTballoon2PX(YOffsetOuts)
                BasemaskYi  = Imgmask.ConvertToY8(Matrix="PC.601").MTballoon2PX(YOffsetIns )
                BasemaskUVo = Imgmask.ConvertToY8(Matrix="PC.601").MTballoon2PX(UVOffsetOuts).PointResize(LocW/2, LocH/2)
                BasemaskUVi = Imgmask.ConvertToY8(Matrix="PC.601").MTballoon2PX(UVOffsetIns ).PointResize(LocW/2, LocH/2)
            }

            if(YColorSolidOuts > -1 && YColorSolidIns > -1) {
                BlankYCSo  = BlankClip(LogoColorY, Color_yuv=YColorSolidOuts*65536, pixel_type="Y8")
                BlankYCSi  = BlankClip(LogoColorY, Color_yuv=ColorSolidIns *65536, pixel_type="Y8")
                YCSo       = BlankYCSo.Overlay(LogoColorY, mask=BasemaskYo)
                LogoColorY = YCSo.Overlay(BlankYCSi, mask=BasemaskYi)
            } else if(YColorSolidOuts > -1 && YColorSolidIns == -1) {
                BlankYCSo  = BlankClip(LogoColorY, Color_yuv=YColorSolidOuts*65536, pixel_type="Y8")
                LogoColorY = BlankYCSo.Overlay(LogoColorY, mask=BasemaskYo)
            } else if(YColorSolidOuts == -1 && YColorSolidIns > -1) {
                BlankYCSi  = BlankClip(LogoColorY, Color_yuv=YColorSolidIns *65536, pixel_type="Y8")
                LogoColorY = LogoColorY.Overlay(BlankYCSi, mask=BasemaskYi)
            }

            if(UColorSolidOuts > -1 && UColorSolidIns > -1) {
                BlankUCSo  = BlankClip(LogoColorU, Color_yuv=UColorSolidOuts*65536, pixel_type="Y8")
                BlankUCSi  = BlankClip(LogoColorU, Color_yuv=UColorSolidIns *65536, pixel_type="Y8")
                UCSo       = BlankUCSo.Overlay(LogoColorU, mask=BasemaskUVo)
                LogoColorU = UCSo.Overlay(BlankUCSi, mask=BasemaskUVi)
            } else if(UColorSolidOuts > -1 && UColorSolidIns == -1) {
                BlankUCSo  = BlankClip(LogoColorU, Color_yuv=UColorSolidOuts*65536, pixel_type="Y8")
                LogoColorU = BlankUCSo.Overlay(LogoColorU, mask=BasemaskUVo)
            } else if(UColorSolidOuts == -1 && UColorSolidIns > -1) {
                BlankUCSi  = BlankClip(LogoColorU, Color_yuv=UColorSolidIns *65536, pixel_type="Y8")
                LogoColorU = LogoColorU.Overlay(BlankUCSi, mask=BasemaskUVi)
            }

            if(VColorSolidOuts > -1 && VColorSolidIns > -1) {
                BlankVCSo  = BlankClip(LogoColorV, Color_yuv=VColorSolidOuts*65536, pixel_type="Y8")
                BlankVCSi  = BlankClip(LogoColorV, Color_yuv=VColorSolidIns *65536, pixel_type="Y8")
                VCSo       = BlankVCSo.Overlay(LogoColorV, mask=BasemaskUVo)
                LogoColorV = VCSo.Overlay(BlankVCSi, mask=BasemaskUVi)
            } else if(VColorSolidOuts > -1 && VColorSolidIns == -1) {
                BlankVCSo  = BlankClip(LogoColorV, Color_yuv=VColorSolidOuts*65536, pixel_type="Y8")
                LogoColorV = BlankVCSo.Overlay(LogoColorV, mask=BasemaskUVo)
            } else if(VColorSolidOuts == -1 && VColorSolidIns > -1) {
                BlankVCSi  = BlankClip(LogoColorV, Color_yuv=VColorSolidIns *65536, pixel_type="Y8")
                LogoColorV = LogoColorV.Overlay(BlankVCSi, mask=BasemaskUVi)
            }


            if(YAlphaSolidOuts > -1 && YAlphaSolidIns > -1) {
                BlankYASo  = BlankClip(LogoAlphaY, Color_yuv=YAlphaSolidOuts*65536, pixel_type="Y8")
                BlankYASi  = BlankClip(LogoAlphaY, Color_yuv=YAlphaSolidIns *65536, pixel_type="Y8")
                YASo       = BlankYASo.Overlay(LogoAlphaY, mask=BasemaskYo)
                LogoAlphaY = YASo.Overlay(BlankYASi, mask=BasemaskYi)
            } else if(YAlphaSolidOuts > -1 && YAlphaSolidIns == -1) {
                BlankYASo  = BlankClip(LogoAlphaY, Color_yuv=YAlphaSolidOuts*65536, pixel_type="Y8")
                LogoAlphaY = BlankYASo.Overlay(LogoAlphaY, mask=BasemaskYo)
            } else if(YAlphaSolidOuts == -1 && YAlphaSolidIns > -1) {
                BlankYASi  = BlankClip(LogoAlphaY, Color_yuv=YAlphaSolidIns *65536, pixel_type="Y8")
                LogoAlphaY = LogoAlphaY.Overlay(BlankYASi, mask=BasemaskYi)
            }

            if(UAlphaSolidOuts > -1 && UAlphaSolidIns > -1) {
                BlankUASo  = BlankClip(LogoAlphaU, Color_yuv=UAlphaSolidOuts*65536, pixel_type="Y8")
                BlankUASi  = BlankClip(LogoAlphaU, Color_yuv=UAlphaSolidIns *65536, pixel_type="Y8")
                UASo       = BlankUASo.Overlay(LogoAlphaU, mask=BasemaskUVo)
                LogoAlphaU = UASo.Overlay(BlankUASi, mask=BasemaskUVi)
            } else if(UAlphaSolidOuts > -1 && UAlphaSolidIns == -1) {
                BlankUASo  = BlankClip(LogoAlphaU, Color_yuv=UAlphaSolidOuts*65536, pixel_type="Y8")
                LogoAlphaU = BlankUASo.Overlay(LogoAlphaU, mask=BasemaskUVo)
            } else if(UAlphaSolidOuts == -1 && UAlphaSolidIns > -1) {
                BlankUASi  = BlankClip(LogoAlphaU, Color_yuv=UAlphaSolidIns *65536, pixel_type="Y8")
                LogoAlphaU = LogoAlphaU.Overlay(BlankUASi, mask=BasemaskUVi)
            }

            if(VAlphaSolidOuts > -1 && VAlphaSolidIns > -1) {
                BlankVASo  = BlankClip(LogoAlphaV, Color_yuv=VAlphaSolidOuts*65536, pixel_type="Y8")
                BlankVASi  = BlankClip(LogoAlphaV, Color_yuv=VAlphaSolidIns *65536, pixel_type="Y8")
                VASo       = BlankVASo.Overlay(LogoAlphaV, mask=BasemaskUVo)
                LogoAlphaV = VASo.Overlay(BlankVASi, mask=BasemaskUVi)
            } else if(VAlphaSolidOuts > -1 && VAlphaSolidIns == -1) {
                BlankVASo  = BlankClip(LogoAlphaV, Color_yuv=VAlphaSolidOuts*65536, pixel_type="Y8")
                LogoAlphaV = BlankVASo.Overlay(LogoAlphaV, mask=BasemaskUVo)
            } else if(VAlphaSolidOuts == -1 && VAlphaSolidIns > -1) {
                BlankVASi  = BlankClip(LogoAlphaV, Color_yuv=VAlphaSolidIns *65536, pixel_type="Y8")
                LogoAlphaV = LogoAlphaV.Overlay(BlankVASi, mask=BasemaskUVi)
            }

            LogoColor   = CombinePlanes(LogoColorY, LogoColorU, LogoColorV, planes="YUV", source_planes="YYY", pixel_type="YV12").ConvertToRGB24(Matrix="PC.601") # just for Show=1
            LogoAlpha   = LogoAlphaY.ConvertToRGB32(Matrix="PC.601").Mask(LogoAlphaY.ConvertToRGB32(Matrix="PC.601"))    # used for OpaqueTune|InterpTune

            if(ShiftMasksVe != 0 || ShiftMasksHo != 0) {
                LogoColorY = LogoColorY.Spline64Resize(LocW  , LocH  , ShiftMasksHo    , ShiftMasksVe    , LocW  , LocH  )
                LogoColorU = LogoColorU.Spline64Resize(LocW/2, LocH/2, ShiftMasksHo/2.0, ShiftMasksVe/2.0, LocW/2, LocH/2)
                LogoColorV = LogoColorV.Spline64Resize(LocW/2, LocH/2, ShiftMasksHo/2.0, ShiftMasksVe/2.0, LocW/2, LocH/2)
                LogoAlphaY = LogoAlphaY.Spline64Resize(LocW  , LocH  , ShiftMasksHo    , ShiftMasksVe    , LocW  , LocH  )
                LogoAlphaU = LogoAlphaU.Spline64Resize(LocW/2, LocH/2, ShiftMasksHo/2.0, ShiftMasksVe/2.0, LocW/2, LocH/2)
                LogoAlphaV = LogoAlphaV.Spline64Resize(LocW/2, LocH/2, ShiftMasksHo/2.0, ShiftMasksVe/2.0, LocW/2, LocH/2)
            }

            if(DumpMasks > 0) {
                ssCyuv = StackHorizontal(LogoColorY, StackVertical(LogoColorU, LogoAlphaU))
                ssAyuv = StackHorizontal(LogoAlphaY, StackVertical(LogoColorV, LogoAlphaV))
                ssBBB  = StackHorizontal(Imgmask.ConvertToY8(Matrix="PC.601"), BlankClip(StackVertical(LogoColorV, LogoAlphaV)))
                ssCAss = StackVertical(ssCyuv, ssAyuv, ssBBB).ImageWriter(LogoID +"%.0d_dump.ebmp",0,1,"ebmp")
                ssCAss.RT_YankChain(n=0)
            }

            if(TriggerDynamic == 1) {
                LogoColorY  = LogoColorY.Loop(2)
                LogoAlphaY  = LogoAlphaY.Loop(2)
                LogoColorU  = LogoColorU.Loop(2)
                LogoAlphaU  = LogoAlphaU.Loop(2)
                LogoColorV  = LogoColorV.Loop(2)
                LogoAlphaV  = LogoAlphaV.Loop(2)
            }
            #==================================#

        } else if(analyze < 0 || ebmpIn == 2) {
            if(ebmpIn == 0) {
                LogoColor = Logo.Crop(0,0,0,Logo.Height/3).ConvertToRGB24
                LogoAlpha = Logo.Crop(0,Logo.Height/3,0,0).Crop(0,0,0,Logo.Height/3)
                LogoAlpha = LogoAlpha.Mask(LogoAlpha)
            }
        } else {
            LogoAlpha = Imgmask # Dummy when Analyze=0 aka Inpaint
        }

        OpaqueTune  = LogoAlpha.Levels(tunelow,1,tunehigh,0,255)
        OpaqueTune  = OpaqueTune.balloonPX(oTinflate)

        InterpTuneP = LogoAlpha.Levels(itunelow,1,itunehigh,0,255)
        InterpTune  = InterpTuneP.balloonPX(iTinflate)

        InterpMask  = (interpm == -1) ? InterpTune :
        \                               InterpMask

        OpaqueMask  = (mode == "inpaint") ? Basemask :
        \                                   OpaqueTune

        DeblendMpp  = Basemask.balloonGR(dppm)
        InpaintMpp  = OpaqueMask.balloonGR(oppm)
        GrainMaskpp = Basemask.balloonGR(3)
        iTunepp     = InterpTune.balloonGR(dippm)

        EdgeMask    = (EdgePP != 0 && mode != "inpaint") ? eval("""
                      edgeSource  = (interpm < 0) ? InterpTuneP.balloonPX(edgePos):
                      \                             BasemaskP  .balloonPX(edgePos)
                      eBlackclp   = BlankClip(Basemask,length=1).ConvertToRGB24
                      EdgeMaskD1  = edgeSource.balloonPX(-1)
                      EdgeMaskI1  = edgeSource.balloonPX(1)
                      EdgeMerge1  = EdgeMaskI1.Overlay(eBlackclp, Mask=EdgeMaskD1)
                      EdgeMaskD2  = edgeSource.balloonPX(-2)
                      EdgeMaskI2  = edgeSource.balloonPX(2)
                      EdgeMerge2  = EdgeMaskI2.Overlay(eBlackclp, Mask=EdgeMaskD2)
                      EdgeMaskD3  = edgeSource.balloonPX(-3)
                      EdgeMaskI3  = edgeSource.balloonPX(3)
                      EdgeMerge3  = EdgeMaskI3.Overlay(eBlackclp, Mask=EdgeMaskD3)
                      EdgeMaskD4  = edgeSource.balloonPX(-4)
                      EdgeMaskI4  = edgeSource.balloonPX(4)
                      EdgeMerge4  = EdgeMaskI4.Overlay(eBlackclp, Mask=EdgeMaskD4)
                      EdgeMask    = (edgeWide == 0) ? EdgeMerge1.Mask(EdgeMerge1):
                      \             (edgeWide == 1) ? EdgeMerge2.Mask(EdgeMerge2):
                      \             (edgeWide == 2) ? EdgeMerge3.Mask(EdgeMerge3):
                      \                               EdgeMerge4.Mask(EdgeMerge4)
                      return EdgeMask """) : nop
    }


    # Delogo process and Dynamic masks #
    #==================================#


    if(automask == 0 && mode != "inpaint" && Show < 3) {
        if(analyze > 0) {
            inYV12Y     = inYV12.ConvertToY8
            inYV12U     = inYV12.UToY8
            inYV12V     = inYV12.VToY8
            OutY        = inYV12Y.DeblendLogo(LogoColorY, LogoAlphaY)
            OutU        = inYV12U.DeblendLogo(LogoColorU, LogoAlphaU)
            OutV        = inYV12V.DeblendLogo(LogoColorV, LogoAlphaV)
            LogoDeblPre = CombinePlanes(OutY, OutU, OutV, planes="YUV", source_planes="YYY", pixel_type="YV12")
        } else {
            if(deep != 1) {
                LogoDeblPre = inRGB24.MultiPassDeblendFX(Basemask,blankwht,a,b,c,d,MskName,Deep,FrB,FrW,frs,frx,BasemaskP,Analyze,Reanalyze,AnalyzeTh,NoBorderAt,LogoID,0).ConvertToYV12(matrix=matrixID)
            } else {
                LogoDeblPre = inRGB24.DeblendLogo(LogoColor,LogoAlpha).ConvertToYV12(matrix=matrixID)
            }
        }

        if(Interp > 0 && IntSpd > 2 && Optimize > 0) {
            opt2_v   = (WholeDeblend == 1 || interpm == -1) ? LogoDeblPre : inYV12
            opt2_bm  = InterpMask.ConvertToY8(matrix="PC.709").MTballoon2PX(2)
            opt2_m   = opt2_bm.MTballoon2PX(6).mt_makediff(opt2_bm).mt_binarize()
            opt2_mc  = opt2_m.PointResize(LocW/2, LocH/2)
            opt2_cb  = opt2_v.Blur(1.58)
            opt2_lm  = opt2_m .Loop(clpFC)
            opt2_lmc = opt2_mc.Loop(clpFC)
            opt2_Yc  = opt2_cb.ExtractY
            opt2_Uc  = opt2_cb.UtoY8
            opt2_Vc  = opt2_cb.VtoY8

            ooo1 = opt2_cb.InpaintLogo(opt2_bm   , sharpness=1.5,preblur=  0,postblur= 0,radius= 2)
            ooo2 = opt2_cb.InpaintLogo(opt2_bm   , sharpness=1.5,preblur=  0,postblur= 0,radius= 6)
            ooo3 = inYV12 .InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur= 4,radius= 8)
            ooo4 = inYV12 .InpaintLogo(InterpMask, sharpness= 45,preBlur=  4,postBlur= 8,radius=16)

            loPr3 = (IntSpd == 3) ? ooo3 : ConditionalFilter(inYV12, ooo3,  ooo4, "opt2_Yc.RT_YPlaneMinMaxDifference(mask=opt2_lm) < 60 && opt2_Uc.RT_YPlaneMinMaxDifference(mask=opt2_lmc) < 60 && opt2_Vc.RT_YPlaneMinMaxDifference(mask=opt2_lmc) < 60", args="opt2_Yc,opt2_Uc,opt2_Vc,opt2_lm,opt2_lmc")
            loPr2 =                        ConditionalFilter(inYV12, ooo2, loPr3, "opt2_Yc.RT_YPlaneMinMaxDifference(mask=opt2_lm) < 40 && opt2_Uc.RT_YPlaneMinMaxDifference(mask=opt2_lmc) < 40 && opt2_Vc.RT_YPlaneMinMaxDifference(mask=opt2_lmc) < 40", args="opt2_Yc,opt2_Uc,opt2_Vc,opt2_lm,opt2_lmc")
            LogoInpaPre =                  ConditionalFilter(inYV12, ooo1, loPr2, "opt2_Yc.RT_YPlaneMinMaxDifference(mask=opt2_lm) < 15 && opt2_Uc.RT_YPlaneMinMaxDifference(mask=opt2_lmc) < 15 && opt2_Vc.RT_YPlaneMinMaxDifference(mask=opt2_lmc) < 15", args="opt2_Yc,opt2_Uc,opt2_Vc,opt2_lm,opt2_lmc")

        } else if(Interp > 0){
            LogoInpaPre = (WholeDeblend == 1 && intspd == 1 || interpm == -1 && intspd == 1) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=2) :
            \             (WholeDeblend == 1 && intspd == 2 || interpm == -1 && intspd == 2) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=6) :
            \             (WholeDeblend == 1 && intspd == 3 || interpm == -1 && intspd == 3) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur=4,radius=8) :
            \             (WholeDeblend == 1 && intspd == 4 || interpm == -1 && intspd == 4) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness= 45,preBlur=  4,postBlur=8,radius=16) :
            \             (                                                     intspd == 1) ? inYV12     .InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=2) :
            \             (                                                     intspd == 2) ? inYV12     .InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=6) :
            \             (                                                     intspd == 3) ? inYV12     .InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur=4,radius=8) :
            \             (                                                     intspd == 4) ? inYV12     .InpaintLogo(InterpMask, sharpness= 45,preBlur=  4,postBlur=8,radius=16) : nop
        }

        if(Optimize == 2 && Interp != 0) {
            opt3_bm  = Imgmask.ConvertToY8(matrix="PC.709").MTballoon2PX(3)
            opt3_m   = opt3_bm.MTballoon2PX(6).mt_makediff(opt3_bm).mt_binarize()
            opt3_mc  = opt3_m.PointResize(LocW/2, LocH/2)
            opt3_cb  = inYV12.Blur(1.58)
            opt3_lm  = opt3_m .Loop(clpFC)
            opt3_lmc = opt3_mc.Loop(clpFC)
            opt3_Yc  = opt3_cb.ExtractY
            opt3_Uc  = opt3_cb.UtoY8
            opt3_Vc  = opt3_cb.VtoY8

            oooo1 = LogoInpaPre.Overlay(LogoDeblPre, opacity=interp)
            oooo2 = LogoDeblPre

            LogoDeblend = ConditionalFilter(inYV12, oooo1, oooo2, "opt3_Yc.RT_YPlaneMinMaxDifference(mask=opt3_lm) < 30 && opt3_Uc.RT_YPlaneMinMaxDifference(mask=opt3_lmc) < 30 && opt3_Vc.RT_YPlaneMinMaxDifference(mask=opt3_lmc) < 30", args="opt3_Yc,opt3_Uc,opt3_Vc,opt3_lm,opt3_lmc")

        } else {
            LogoDeblend = (interp != 0) ? LogoInpaPre.Overlay(LogoDeblPre, opacity=interp) :
            \                             LogoDeblPre
        }
    }

    # DynTune  / DynMask6
    if (LumaSwitch == 1) {
        lvl_mask    = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 5 && DynMask != 7) ? eval("""
                      lvl_mask = inY8.mt_binarize(threshold=DynTune).MTballoonPX(DynTuneInf)
                      return lvl_mask """) : nop
    } else if (LumaSwitch == 2) {
        lvl_mask    = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 5 && DynMask != 7) ? eval("""
                      lvl_mask = inYV12.ExtractY.BilinearResize(locW*DynLocUp, locH*DynLocUp).mt_lut(expr=LumaExpr).MTballoonPX(DynTuneInf)
                      return lvl_mask """) : nop
    }

    # DynColor / DynMask5
    if (ColorSwitch == 1) {
        col_mask    = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 6 && DynMask != 7) ? eval("""
                      col_mask = inRGB32.BilinearResize(locW*DynLocUp, locH*DynLocUp).ColorKeyMask(DynColor, DynColorTol).ShowAlpha(Pixel_Type="Y8").invert.MTballoon2PX(DynColorInf)
                      return col_mask """) : nop
    } else if (ColorSwitch == 2) {
        col_mask    = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 6 && DynMask != 7) ? eval("""
                      col_mask = inYV12.ConvertToYV24.BilinearResize(locW*DynLocUp, locH*DynLocUp).TColorMask(DynColor, tolerance=DynColorTol, bt601=!isHD, mt=false, onlyY=true).MTballoon2PX(DynColorInf)
                      return col_mask """) : nop
    }

    # DynTEdge / DynMask7
    # "vsTEdgeMask(threshY=20.0, type=1, link=0)" result is almost same as "vsTCanny(sigmaY=0, mode=1, op=0).mt_binarize(40)" but ~twice faster
    tedge_mask  = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynTEdge == 1 && DynMask != 5 && DynMask != 6) ? eval("""
                  tedge_mask = (DynTEdgeInf == 0) ? inY8.vsTEdgeMask (threshY=DynTEdgeThY, type=1, link=0) :
                  \                                 inY8.vsTEdgeMask (threshY=DynTEdgeThY, type=1, link=0).MTballoon2PX(DynTEdgeInf).mt_expand.mt_inpand
                  return tedge_mask """) : nop

    # Combo mask
    if (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 5 && DynMask != 6 && DynMask != 7) {
        if (ColorSwitch > 0 && DynTEdge == 1) {
            combo_mask =   lvl_mask.mt_logic(  col_mask, mode="and")
            combo_mask = combo_mask.mt_logic(tedge_mask, mode="and")
        } else if (ColorSwitch == 0 && DynTEdge == 1) {
            combo_mask =   lvl_mask.mt_logic(tedge_mask, mode="and")
        } else if (ColorSwitch  > 0 && DynTEdge == 0) {
            combo_mask =   lvl_mask.mt_logic(  col_mask, mode="and")
        } else {
            combo_mask = lvl_mask
        }
    }


    DynamicMsk3 = (automask == 0 && DynMask == 3 && mode == "inpaint") ? eval("""
                  DynamicMsk3 = combo_mask

                  DynamicMsk3 = (ClpBlend    == 0) ? DynamicMsk3 :
                  \             (DynPostTune == 0) ? DynamicMsk3.ClipBlend(ClpBlend) :
                  \                                  DynamicMsk3.ClipBlend(ClpBlend).mt_binarize(threshold=DynPostTuneLow)

                  DynamicMsk3 = (Dyn3buffer == 0 || show == 3) ? DynamicMsk3 :
                  \                                              DynamicMsk3.RequestLinear(rlim=ClpBlend,clim=ClpBlend)
                  return DynamicMsk3 """) : nop

    DynamicMsk3u = (automask == 0 && DynMask == 3 && mode == "inpaint" && DynMaskUp > 1) ? eval("""
                  DynamicMsk3u = inY8.SincResize(inY8.width*DynMaskUp, inY8.height*DynMaskUp, taps=2).mt_binarize(DynTune).ClipBlend(ClpBlend).mt_binarize(threshold=DynPostTuneLow).TrimergageFX(Seq=Dyn3Seq, ClpBlend=ClpBlend)
                  return DynamicMsk3u """) : nop


    DynamicMsk4 = (automask == 0 && DynMask == 4 && mode == "inpaint" && DynMaskUp > -2) ? eval("""
                  wMsk4       = inY8.mt_binarize(DynTune)
                  bMsk4       = inY8.mt_binarize(DynMask4H)#.mt_inpand(mode="square").mt_expand(mode="both")  # inp/exp to destroy corner connections between background and text # v2.05 replaced with corners=false.
                  bBoxMsk4    = BlankClip(inY8, width=inY8.width-16, height=inY8.height-16, Color_yuv=$000000).AddBorders(8,8,8,8,$FFFFFF)
                  bMsk4Cln1   = bBoxMsk4.mt_hysteresis(bMsk4, corners=false)
                  DynamicMsk4 = (Show == 6) ? bMsk4 : wMsk4.mt_makediff(bMsk4Cln1).mt_binarize()
                  return DynamicMsk4 """) : nop


    DynamicMsk4u = (automask == 0 && DynMask == 4 && mode == "inpaint" && DynMaskUp > 1) ? eval("""
                  DynamicMsk4u = inY8.SincResize(inY8.width*DynMaskUp, inY8.height*DynMaskUp, taps=2).mt_binarize(DynTune)
                  # v2.05. No idea why it's here, maybe to reduce sponginess, or maybe for killblobs/killnoise or to connect parts of the letters for better OCR [then move it to the extractor]
                  #DynamicMsk4u = DynamicMsk4u.mt_expand(mode="both").mt_expand(mode="both").mt_inpand(mode="both").mt_inpand(mode="both")
                  return DynamicMsk4u """) : nop

    DynamicMsk4uf = (automask == 0 && DynMask == 4 && mode == "inpaint" && DynMaskUp < -1) ? eval("""
                  inSyncMsk4uf1  = inY8. SincResize(inY8.width*Abs(DynMaskUp), inY8.height*Abs(DynMaskUp), taps=2)
                  inSyncMsk4uf2  = inSyncMsk4uf1.mt_binarize(DynTune).mt_expand(mode="both").mt_inpand(mode="both")
                  inSplineMsk4uf = inY8.RemoveGrain(2).RemoveGrain(2).Spline16Resize(inY8.width*Abs(DynMaskUp), inY8.height*Abs(DynMaskUp)).mt_binarize(DynTune).RemoveGrain(2).RemoveGrain(2).mt_inpand(mode="both").mt_inpand(mode="square")
                  wMsk4uf        = inSplineMsk4uf.mt_hysteresis(inSyncMsk4uf2)
                  bMsk4uf        = inSyncMsk4uf1.mt_binarize(DynMask4H)
                  bBoxMsk4uf     = BlankClip(inSyncMsk4uf1, width=inSyncMsk4uf1.width-32, height=inSyncMsk4uf1.height-32, Color_yuv=$000000).AddBorders(16,16,16,16,$FFFFFF)
                  bMsk4Cln1uf    = bBoxMsk4uf.mt_hysteresis(bMsk4uf)
                  DynamicMsk4uf  = (Show == 6) ? bMsk4uf : wMsk4uf.mt_makediff(bMsk4Cln1uf).mt_binarize().mt_expand(mode="square").mt_expand(mode="square").mt_inpand(mode="square").mt_inpand(mode="square")
                  return DynamicMsk4uf """) : nop


    dMsk3HaloS  = (automask == 0 && DynMask == 3 && mode == "inpaint" && DynMask3H != 0 && ModeSH == 1) ? eval("""
                  wMsk3HS    = inY8.mt_binarize(DynTune).MTballoon2PX(TuneH1)
                  bMsk3HS    = inY8.mt_binarize(DynMask3H).Invert
                  halo3HS    = bMsk3HS.mt_logic(wMsk3HS, mode="and")
                  white3HS   = BlankClip(inY8, Color_yuv=$FFFFFF)
                  dMsk3HaloS = (TuneH1 == 0) ? bMsk3HS : halo3HS.mt_logic(white3HS, mode="xor")
                  return dMsk3HaloS """) : nop


    dMsk3Halo   = (automask == 0 && DynMask == 3 && mode == "inpaint" && DynMask3H != 0) ? eval("""
                  dMsk3Halo = (ModeSH     == 1) ? dMsk3HaloS : inY8.mt_binarize(threshold= DynMask3H).ClipBlend(ClpBlend).mt_binarize(254).TrimergageFX(Seq=Dyn3Seq, ClpBlend=ClpBlend)
                  dMsk3Halo = (TuneH1     != 0) ? dMsk3Halo.KillBalloonFX(TuneH1, 0, TuneH2, TuneH3) : dMsk3Halo
                  dMsk3Halo = (KillNoiseH != 0) ? dMsk3Halo.MTballoonPX(KillNoiseH) : dMsk3Halo
                  dMsk3Halo = (RePassH    == 1) ? dMsk3Halo.DynRePassFX(Dyn3Seq, ClpBlend, KillNoiseH) : dMsk3Halo
                  return dMsk3Halo """) : nop


    DynamicMask = (automask == 0 && DynMask  != 0) ? eval("""
                  DynamicMask = (mode == "inpaint" && DynMask == 1                  ) ? Clipmask :
                  \             (mode == "both"    && DynMask == 2                  ) ? LogoDeblend.ExtractY.mt_binarize(threshold=DynTune) :
                  \             (mode == "inpaint" && DynMask == 2                  ) ? combo_mask :
                  \             (mode == "inpaint" && DynMask == 3                  ) ? DynamicMsk3.TrimergageFX(Seq=Dyn3Seq, ClpBlend=ClpBlend) :
                  \             (mode == "inpaint" && DynMask == 4 && DynMaskUp > -2) ? DynamicMsk4 :
                  \             (mode == "inpaint" && DynMask == 4 && DynMaskUp < -1) ? DynamicMsk4uf :
                  \             (mode == "inpaint" && DynMask == 5                  ) ? col_mask :
                  \             (mode == "inpaint" && DynMask == 6                  ) ? lvl_mask :
                  \             (mode == "inpaint" && DynMask == 7                  ) ? tedge_mask : nop
                  DynamicMask = (KillBlobs  != 0) ? DynamicMask.KillBalloonFX(KillBlobs, preBlobs) : DynamicMask
                  DynamicMask = (KillNoise  != 0) ? DynamicMask.MTballoonPX(KillNoise) : DynamicMask
                  DynamicMask = (RePass     == 1 && DynMask == 3) ? DynamicMask.DynRePassFX(Dyn3Seq, ClpBlend, KillNoise) : DynamicMask
                  DynamicMask = (RePass     == 2 && DynMask == 3) ? DynamicMask.DynRePassFX(Dyn3Seq, ClpBlend, KillNoise).DynRePassFX(Dyn3Seq, ClpBlend, KillNoise) : DynamicMask
                  DynamicMask = (DynMask3H  != 0 && DynMask == 3) ? dMsk3Halo.mt_hysteresis(DynamicMask).DynRePassFX(Dyn3Seq, ClpBlend) : DynamicMask
                  DynamicMask = (Killshape  == 1) ? DynamicMask.MTballoonPX(99) : DynamicMask
                  DynamicMask = (DynInflate != 0) ? DynamicMask.MTballoon2PX(dyninflate) : DynamicMask
                  DynamicMask = (MskPatch   == 1) ? DynamicMask.PatchFuncFX(maskPatch)  : DynamicMask

                  DynamicMask = (DynMaskUp   > 1 && DynMask == 3) ? DynamicMask.PointResize(inY8.width*Abs(DynMaskUp), inY8.height*Abs(DynMaskUp)).mt_hysteresis(DynamicMsk3u, corners=false) : DynamicMask
                  DynamicMask = (DynMaskUp   > 1 && DynMask == 4) ? DynamicMask.PointResize(inY8.width*Abs(DynMaskUp), inY8.height*Abs(DynMaskUp)).mt_hysteresis(DynamicMsk4u, corners=false) : DynamicMask
                  return DynamicMask """) : nop


    InpaintMpp  = (automask == 0 && DynMask != 0 && Show != 4 && Show < 6) ? eval("""
                  InpaintMpp  = DynamicMask.MTballoonGR(oppm)
                  return InpaintMpp
                  """) : (automask == 0 && Show < 3) ? Eval("""
                  return InpaintMpp
                  """) : nop


    LogoBoth    = (automask == 0 && mode != "inpaint" && Show < 3) ? eval("""
                  LogoBoth    = (DynMask != 0) ? LogoDeblend.InpaintLogo(DynamicMask, radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur) :
                  \                              LogoDeblend.InpaintLogo(OpaqueMask , radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur)
                  return LogoBoth """) : nop


    # Inpaint:
    if(automask == 0 && mode == "inpaint" && Show < 3 && Optimize == 0) {

        LogoInpaint = (DynMask != 0) ? inYV12.ppFX(prePP).InpaintLogo(DynamicMask, radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur) :
        \                              inYV12.ppFX(prePP).InpaintLogo(OpaqueMask , radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur)

    } else if(automask == 0 && mode == "inpaint" && Show < 3 && Optimize > 0) {

        opt_bm  = Imgmask.ConvertToY8(matrix="PC.709").MTballoon2PX(3)
        opt_m   = opt_bm.MTballoon2PX(6).mt_makediff(opt_bm).mt_binarize()
        opt_mc  = opt_m.PointResize(LocW/2, LocH/2)
        opt_cb  = inYV12.Blur(1.58)
        opt_lm  = opt_m .Loop(clpFC)
        opt_lmc = opt_mc.Loop(clpFC)
        opt_Yc  = opt_cb.ExtractY
        opt_Uc  = opt_cb.UtoY8
        opt_Vc  = opt_cb.VtoY8

        oo1 = opt_cb.InpaintLogo(opt_bm    , sharpness=1.5,preblur=  0,postblur= 0,radius= 2)
        oo2 = opt_cb.InpaintLogo(opt_bm    , sharpness=1.5,preblur=  0,postblur= 0,radius= 4)
        oo3 = opt_cb.InpaintLogo(opt_bm    , sharpness=1.5,preblur=  0,postblur= 0,radius= 6)
        oo4 = inYV12.InpaintLogo(OpaqueMask, sharpness= 45,preBlur=6.5,postBlur= 4,radius= 8)
        oo5 = inYV12.InpaintLogo(OpaqueMask, sharpness= 45,preBlur=  4,postBlur= 8,radius=16)
        oo6 = inYV12.InpaintLogo(OpaqueMask, sharpness= 45,preBlur=  4,postBlur=12,radius=16)

        loIn5 = (Turbo == -1) ? oo5 : ConditionalFilter(inYV12, oo5,   oo6, "opt_Yc.RT_YPlaneMinMaxDifference(mask=opt_lm) < 45 && opt_Uc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 45 && opt_Vc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 45", args="opt_Yc,opt_Uc,opt_Vc,opt_lm,opt_lmc")
        loIn4 = (Turbo ==  0) ? oo4 : ConditionalFilter(inYV12, oo4, loIn5, "opt_Yc.RT_YPlaneMinMaxDifference(mask=opt_lm) < 35 && opt_Uc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 35 && opt_Vc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 35", args="opt_Yc,opt_Uc,opt_Vc,opt_lm,opt_lmc")
        loIn3 =                       ConditionalFilter(inYV12, oo3, loIn4, "opt_Yc.RT_YPlaneMinMaxDifference(mask=opt_lm) < 20 && opt_Uc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 20 && opt_Vc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 20", args="opt_Yc,opt_Uc,opt_Vc,opt_lm,opt_lmc")
        loIn2 =                       ConditionalFilter(inYV12, oo2, loIn3, "opt_Yc.RT_YPlaneMinMaxDifference(mask=opt_lm) < 10 && opt_Uc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 10 && opt_Vc.RT_YPlaneMinMaxDifference(mask=opt_lmc) < 10", args="opt_Yc,opt_Uc,opt_Vc,opt_lm,opt_lmc")
        LogoInpaint  =                ConditionalFilter(inYV12, oo1, loIn2, "opt_Yc.RT_YPlaneMinMaxDifference(mask=opt_lm) <  6 && opt_Uc.RT_YPlaneMinMaxDifference(mask=opt_lmc) <  6 && opt_Vc.RT_YPlaneMinMaxDifference(mask=opt_lmc) <  6", args="opt_Yc,opt_Uc,opt_Vc,opt_lm,opt_lmc")
    }


    delogo      = (automask == 0 && Show < 3) ? eval("""
                  delogo      = (mode == "inpaint") ? LogoInpaint :
                  \             (mode == "deblend") ? LogoDeblend :
                  \             (mode == "both"   ) ? LogoBoth    : nop
                  return delogo """) : nop


    # Delogo PP #
    #===========#


    # EdgePP:
    delogopp2   = (automask == 0 && Show != 3 && Show != 4 && Show < 6) ? eval("""
                  delogopp2 =  (edgePP == 1 ) ? delogo.InpaintLogo(EdgeMask, sharpness= 1.5,preblur=0  ,postblur=0,radius=2 ) :
                  \            (edgePP == 2 ) ? delogo.InpaintLogo(EdgeMask, sharpness= 1.5,preblur=0  ,postblur=0,radius=6 ) :
                  \            (edgePP == 3 ) ? delogo.InpaintLogo(EdgeMask, sharpness=45  ,preBlur=6.5,postBlur=4,radius=8 ) :
                  \                             delogo
                  return delogopp2  """) : nop

    # dPP/oPP:
    delogopp3   = (automask == 0 && Show < 3) ? eval("""
                  delogopp3 = (mode == "inpaint"                                 ) ? inYV12.Overlay(delogo   .ppFX(opp), Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \           (mode != "inpaint" && dPP != 0 && WholeDeblend == 0) ? inYV12.Overlay(delogopp2.ppFX(dpp), Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm != 0         && dPP == 0 && WholeDeblend == 0) ? inYV12.Overlay(delogopp2,           Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm == 0         && dPP == 0 && WholeDeblend == 0) ? inYV12.Overlay(delogopp2,           Mask=Basemask.  ConvertToY8(matrix="PC.709")) :
                  \           (mode != "inpaint" && dPP != 0 && WholeDeblend == 1) ? delogopp2.Overlay(delogopp2.ppFX(dpp), Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm != 0         && dPP == 0 && WholeDeblend == 1) ? delogopp2 :
                  \           (dPPm == 0         && dPP == 0 && WholeDeblend == 1) ? delogopp2 : nop
                  return delogopp3  """) : nop

    # iTune PP:
    delogopp4   = (automask == 0 && Show < 3) ? eval("""
                  delogopp4 = (mode == "deblend" && InterpM == -1 && diPP != 0) ? delogopp3.Overlay(delogopp3.ppFX(dipp), Mask=iTunepp.ConvertToY8(matrix="PC.709")) :
                  \                                                               delogopp3
                  return delogopp4 """) : nop

    # Both/oTune PP:
    delogopp5   = (automask == 0 && Show < 3) ? eval("""
                  delogopp5 = (mode == "both" && oPP != 0) ? delogopp4.Overlay(delogopp4.ppFX(opp), Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \                                          delogopp4
                  return delogopp5 """) : nop

    # Grain PP:
    delogopp9   = (automask == 0 && Show < 3) ? eval("""
                  delogopp9 = (grainpp == 1) ? delogopp5.Overlay(delogopp5.Grainfactory3(1,0,0,temp_avg=60), Mask=GrainMaskpp.ConvertToY8(matrix="PC.709")) :
                  \           (grainpp == 2) ? delogopp5.Overlay(delogopp5.Grainfactory3(2,1,1,temp_avg=60), Mask=GrainMaskpp.ConvertToY8(matrix="PC.709")) :
                  \           (grainpp == 3) ? delogopp5.Overlay(delogopp5.Grainfactory3(2,2,2,temp_avg=60), Mask=GrainMaskpp.ConvertToY8(matrix="PC.709")) :
                  \                            delogopp5
                  return delogopp9  """) : nop


    # "mShow" #
    #=========#


    helper      = (automask == 0 && Show < 3) ? eval("""
                  helper = (mshow == 0) ? delogopp9 :
                  \        (mshow == 1) ? delogopp9.Overlay(blankblk, Mask=OpaqueMask.ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 2) ? delogopp9.Overlay(blankblk, Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 3) ? delogopp9.Overlay(blankblk, Mask=Basemask.  ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 4) ? inYV12.   Overlay(blankblk, Mask=Basemask.  ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 5) ? inYV12.   Overlay(blankblk, Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 6) ? inYV12.   Overlay(blankblk, Mask=OpaqueTune.ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 7) ? delogopp9.Overlay(blankblk, Mask=InterpMask.ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 8) ? delogopp9.Overlay(blankblk, Mask=EdgeMask  .ConvertToY8(matrix="PC.709")) :
                  \        (mshow == 9) ? inYV12.   Overlay(blankblk, Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \                       delogopp9
                  return helper """) : nop


    # Endpoints #
    #===========#


    if(automask == 1) { # Show Automask

        Autologo.Crop(a,b,c,d)
        Autoalpha = ImageSource(AutoID + "%.0d.bmp",0,0)
        StackVertical(last, Autoalpha)
        return last

    } else if(show == 1) { # "Show" 1

        Source    = inRGB32                 .Subtitle("source"   )
        Delogo    = delogo.ConvertToRGB32   .Subtitle("delogo"   )
        Delogopp  = delogopp9.ConvertToRGB32.Subtitle("delogo pp")

        mask1     = (mode == "inpaint") ? Imgmask   .Subtitle("base mask" ) :
        \                                 Logoalpha .Subtitle("logo alpha")

        mask2     = (mode == "deblend") ? DeblendMpp                           .Subtitle("deblend pp") :
        \           (mode == "inpaint") ? InpaintMpp.ConvertToY8.ConvertToRGB32.Subtitle("opaque pp" ) :
        \                                 DeblendMpp                           .Subtitle("deblend pp")

        mask3     = (mode == "deblend"                ) ? InterpMask                            .Subtitle("interp"      ) :
        \           (mode == "inpaint" && DynMask == 0) ? OpaqueMask                            .Subtitle("opaque mask" ) :
        \           (mode == "inpaint" && DynMask != 0) ? DynamicMask.ConvertToY8.ConvertToRGB32.Subtitle("dynamic mask") :
        \                                                 InpaintMpp .ConvertToY8.ConvertToRGB32.Subtitle("opaque pp"   )

        mask4     = (mode == "inpaint") ? blankblk  .Subtitle("disabled"  ) :
        \                                 Logocolor .Subtitle("logo color").ConvertToRGB32

        mask5     = (mode == "inpaint") ? blankblk  .Subtitle("disabled"  ) :
        \                                 Basemask  .Subtitle("base mask" )

        mask6     = (mode == "both" && DynMask == 0) ? OpaqueMask                            .Subtitle("otune mask"  ) :
        \           (mode == "both" && DynMask != 0) ? DynamicMask.ConvertToY8.ConvertToRGB32.Subtitle("dynamic mask") :
        \           (EdgePP != 0                   ) ? edgemask                              .Subtitle("edge pp"     ) :
        \                                              blankblk                              .Subtitle("disabled"    )

        mask7     = blankblk.Subtitle("disabled")

        mask8     = (mode == "both" && interp != 0) ? InterpMask.Subtitle("interp on" ) :
        \                                             blankblk  .Subtitle("interp off")

        mask9     = blankblk.Subtitle("disabled")

        a1        = StackHorizontal( Source, Delogo, Delogopp)
        a2        = StackHorizontal(  mask1,  mask2,    mask3)
        a3        = StackHorizontal(  mask4,  mask5,    mask6)
        a4        = StackHorizontal(  mask7,  mask8,    mask9)

        (mode == "deblend") ? StackVertical (a1,a2,a3   ) :
        \  (mode == "both") ? StackVertical (a1,a2,a3,a4) :
        \                     StackVertical (a1,a2      )

        last.ConvertToRGB24(matrix=matrixID)

    } else if(show == 2) { # "Show" 2

        if(Analyze > 0) {
            sourceClp   =                inYV12           .Subtitle("0: source"                 ,x=4,size=14).AddBorders(0,0,2,2,$b7b715)
            deblendClp  =                LogoDeblPre      .Subtitle("1: deblend"                ,x=4,size=14).AddBorders(0,0,2,2,$b7b715)
            interpClp   = (interp > 0) ? LogoInpaPre      .Subtitle("2: IntSpd="+ string(IntSpd),x=4,size=14).AddBorders(0,0,2,2,$b7b715) :
            \                            BlankClip(inYV12).Subtitle("2: Interp Off"             ,x=4,size=14).AddBorders(0,0,2,2,$b7b715)

            delogoClp   = delogo.Subtitle("3: pre-PP",x=4,size=14).AddBorders(0,0,2,2,$b7b715)
            finalClp    = helper.Subtitle("4: final" ,x=4,size=14).AddBorders(0,0,2,2,$b7b715)
            MergeCLogo  = CombinePlanes(LogoColorY, LogoColorU, LogoColorV, planes="YUV", source_planes="YYY", pixel_type="YV12").Subtitle("logo demo",x=4,size=14).AddBorders(0,0,2,2,$b7b715)

            LogoAYClp   = LogoAlphaY.ConvertToYV12.Subtitle("Y alpha",x=4,size=14).AddBorders(0,0,2,2,$b7b715)
            LogoCYClp   = LogoColorY.ConvertToYV12.Subtitle("Y color",x=4,size=14).AddBorders(0,0,2,2,$b7b715)
            stackedUclp = StackVertical(LogoColorU.Subtitle("U c"    ,x=2,size=10).AddBorders(0,0,2,1,$FFFFFF),LogoAlphaU.Subtitle("U a",x=2,size=10).AddBorders(0,0,2,1,$FFFFFF))
            stackedVclp = StackVertical(LogoColorV.Subtitle("V c"    ,x=2,size=10).AddBorders(0,0,0,1,$FFFFFF),LogoAlphaV.Subtitle("V a",x=2,size=10).AddBorders(0,0,0,1,$FFFFFF))
            chromaClp   = StackHorizontal(stackedUclp, stackedVclp).ConvertToYV12

            basemaskClp = Imgmask   .ConvertToYV12(matrix="PC.601").Subtitle("basemask"   ,x=4,size=14).AddBorders(0,0,2,0,$b7b715)
            InterpMclp  = InterpMask.ConvertToYV12(matrix="PC.601").Subtitle("interp mask",x=4,size=14).AddBorders(0,0,2,0,$b7b715)
            OpaqueMclp  = (mode == "Both") ? OpaqueMask.ConvertToYV12(matrix="PC.601").Subtitle("oTune mask" ,x=4,size=14).AddBorders(0,0,2,0,$b7b715) :
            \                                BlankClip(inYV12)                        .Subtitle("disabled"   ,x=4,size=14).AddBorders(0,0,2,0,$b7b715)

            sRow1       = StackHorizontal(sourceClp, deblendClp, interpClp)
            sRow2       = StackHorizontal(finalClp,  delogoClp,  MergeCLogo)
            sRow3       = StackHorizontal(LogoAYClp, LogoCYClp, chromaClp)
            sRow4       = StackHorizontal(basemaskClp, InterpMclp, OpaqueMclp)
            StackVertical(sRow1, sRow2, sRow3, sRow4)

        } else {
            a1 = (DynMask != 0) ? StackVertical (delogo, helper) : nop
            a2 = (DynMask != 0) ? StackVertical (DynamicMask.ConvertToY8.ConvertToYV12, InpaintMpp.ConvertToY8.ConvertToYV12) : nop
            (DynMask != 0) ? StackHorizontal(a1, a2) : StackVertical(delogo, helper)
        }

    } else if(show == 3) { # "Show" 3

        DynamicMsk3

    } else if(show == 4) { # "Show" 4

        if(Extract < 0) {
            StartTime   = TimerFX()
            IntFileName = "_InpaintDelogo_Intermediate_DynMask.avi"
            if(ReExtract == 0) {
                DynamicMask.TWriteAvi(IntFileName, Overwrite=true, FourCC=FourCC).ForceProcessAVI()
            }
            MaskInter = LWLibAvVideoSource(IntFileName)
        }

        (Extract ==  0) ? DynamicMask :
      \ (Extract ==  1) ? DynamicMask.SubsMask2Img(ImgDir=ImgDir, CorrTh=CorrTh, DetWinPercW=DetWinPercW, DetWinPercH=DetWinPercH, DetWinHoPos=DetWinHoPos, SubTune=SubTune, SubMinDur=SubMinDur, SubSusDur=SubSusDur, SubMinLuma=SubMinLuma, SubSusLuma=SubSusLuma, ImgType=ImgType, ImgInflate=ImgInflate, ImgInvert=ImgInvert, ImgSize=ImgSize, RawAvr=RawAvr) :
      \ (Extract == -1) ? MaskInter  .SubsMask2Img(ImgDir=ImgDir, CorrTh=CorrTh, DetWinPercW=DetWinPercW, DetWinPercH=DetWinPercH, DetWinHoPos=DetWinHoPos, SubTune=SubTune, SubMinDur=SubMinDur, SubSusDur=SubSusDur, SubMinLuma=SubMinLuma, SubSusLuma=SubSusLuma, ImgType=ImgType, ImgInflate=ImgInflate, ImgInvert=ImgInvert, ImgSize=ImgSize, RawAvr=RawAvr, StartIn=StartTime) :
      \ (Extract ==  2) ? DynamicMask.SubsMask2Img(ImgDir=ImgDir, CorrTh=CorrTh, DetWinPercW=DetWinPercW, DetWinPercH=DetWinPercH, DetWinHoPos=DetWinHoPos, SubTune=SubTune, SubMinDur=SubMinDur, SubSusDur=SubSusDur, SubMinLuma=SubMinLuma, SubSusLuma=SubSusLuma, ImgType=ImgType, ImgInflate=ImgInflate, ImgInvert=ImgInvert, ImgSize=ImgSize, RawAvr=RawAvr, Raw=inYV12) :
      \ (Extract == -2) ? MaskInter  .SubsMask2Img(ImgDir=ImgDir, CorrTh=CorrTh, DetWinPercW=DetWinPercW, DetWinPercH=DetWinPercH, DetWinHoPos=DetWinHoPos, SubTune=SubTune, SubMinDur=SubMinDur, SubSusDur=SubSusDur, SubMinLuma=SubMinLuma, SubSusLuma=SubSusLuma, ImgType=ImgType, ImgInflate=ImgInflate, ImgInvert=ImgInvert, ImgSize=ImgSize, RawAvr=RawAvr, Raw=inYV12, StartIn=StartTime) : nop

    } else if(show == 5) { # "Show" 5

        BlackClip = BlankClip(clp, Color_yuv=$000000, pixel_type="Y8")
        show5 = InpaintMpp.ConvertToY8
        show5out = (Loc == "0,0,0,0" || Loc == "0,0,-0,-0" || Loc == "0, 0, 0, 0" || Loc == "0, 0, -0, -0") ? show5 : BlackClip.Overlay(show5,x=a,y=b)
        show5out

    } else if(show == 6) { # "Show" 6

        (DynMask == 4) ? DynamicMsk4 : dMsk3Halo

    } else if(show == 7) { # "Show" 7

        (Analyze ==  1) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=3) :
      \ (Analyze ==  2) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=3) :
      \ (Analyze == -1) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=3) :
      \ (Analyze == -2) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=3) : nop
        w = int(4*width(last))
        h = int(4*height(last))
        PointResize(last,w,h)

        if(Analyze > 0) {
            last.ScriptClip( function [] () {
                Y=PlaneMinMaxStats(plane=0)
                U=PlaneMinMaxStats(plane=1)
                V=PlaneMinMaxStats(plane=2)
                subtitle("Y=" +string(int(Y[1]-Y[0])) +" U=" +String(int(U[1]-U[0])) +" V=" +String(int(V[1]-V[0])))
            } , local = true)
        } else {
            last.ScriptClip( function [] () {
                R=PlaneMinMaxStats(plane=0)
                G=PlaneMinMaxStats(plane=1)
                B=PlaneMinMaxStats(plane=2)
                subtitle("R=" +string(int(R[1]-R[0])) +" G=" +String(int(G[1]-G[0])) +" B=" +String(int(B[1]-B[0])))
            } , local = true)
        }

    } else if(show == 8) { # "Show" 8

        (Analyze ==  1) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=2) :
      \ (Analyze ==  2) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=2) :
      \ (Analyze == -1) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=2) :
      \ (Analyze == -2) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=2) : nop
        w = int(4*width(last))
        h = int(4*height(last))
        PointResize(last,w,h)

        if(Analyze > 0) {
            last.ScriptClip( function [] () {
                Y=PlaneMinMaxStats(plane=0)
                U=PlaneMinMaxStats(plane=1)
                V=PlaneMinMaxStats(plane=2)
                subtitle("Y=" +string(int(Y[1]-Y[0])) +" U=" +String(int(U[1]-U[0])) +" V=" +String(int(V[1]-V[0])))
            } , local = true)
        } else {
            last.ScriptClip( function [] () {
                R=PlaneMinMaxStats(plane=0)
                G=PlaneMinMaxStats(plane=1)
                B=PlaneMinMaxStats(plane=2)
                subtitle("R=" +string(int(R[1]-R[0])) +" G=" +String(int(G[1]-G[0])) +" B=" +String(int(B[1]-B[0])))
            } , local = true)
        }

    } else if(show == 9) { # "Show" 9

        (Analyze ==  1) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=1) :
      \ (Analyze ==  2) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=1) :
      \ (Analyze == -1) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=1) :
      \ (Analyze == -2) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=1) : nop

    } else if(show == 10) { # "Show" 10

        black10 = BlankClip(inYV12a, Color_yuv=$000000, pixel_type="Y8")
        (DynMask ==  2) ? Stackvertical(inYV12a, inYV12a.Overlay(black10, Mask=combo_mask.invert).AddBorders(0,2,0,0,$F0F080), combo_mask.ConvertToYV12.AddBorders(0,2,0,0,$F0F080)) :
      \ (DynMask ==  5) ? Stackvertical(inYV12a, inYV12a.Overlay(black10, Mask=  col_mask.invert).AddBorders(0,2,0,0,$F0F080),   col_mask.ConvertToYV12.AddBorders(0,2,0,0,$F0F080)) :
      \ (DynMask ==  6) ? Stackvertical(inYV12a, inYV12a.Overlay(black10, Mask=  lvl_mask.invert).AddBorders(0,2,0,0,$F0F080),   lvl_mask.ConvertToYV12.AddBorders(0,2,0,0,$F0F080)) :
      \ (DynMask ==  7) ? Stackvertical(inYV12a, inYV12a.Overlay(black10, Mask=tedge_mask.invert).AddBorders(0,2,0,0,$F0F080), tedge_mask.ConvertToYV12.AddBorders(0,2,0,0,$F0F080)) : nop

    } else if(show == 11) { # "Show" 11

         black11 = BlankClip(inYV12a, Color_yuv=$000000, pixel_type="Y8")
        (DynMask ==  2) ? inYV12a.Overlay(black11, Mask=combo_mask.invert) :
      \ (DynMask ==  5) ? inYV12a.Overlay(black11, Mask=  col_mask.invert) :
      \ (DynMask ==  6) ? inYV12a.Overlay(black11, Mask=  lvl_mask.invert) :
      \ (DynMask ==  7) ? inYV12a.Overlay(black11, Mask=tedge_mask.invert) : nop

    } else if(show == 12) { # "Show" 12

        DetWinPercW = 1 - DetWinPercW * 0.01
        DetWinPercH = 1 - DetWinPercH * 0.01
        Assert (!(DetWinPercW - abs(DetWinHoPos) < 0.01), """"DetWinHoPos" out of boundary.""")

        clp     = DynamicMask
        VW      = clp.Width
        VH      = clp.Height
        coordL  = int((VW / 2) *DetWinPercW)
        coordT  = int((VH / 2) *DetWinPercH)
        coordW  = VW - (coordL*2)
        coordH  = VH - (coordT*2)

        ARGS="VW, coordT, coordW, coordH, CorrTh, DetWinPercW, DetWinHoPos"
        clp.ScriptClip("ID_VFX3("+args+")", local=true, args=ARGS, after_frame=true)

    } else { # FinalOut

        if(Loc == "0,0,0,0" || Loc == "0,0,-0,-0" || Loc == "0, 0, 0, 0" || Loc == "0, 0, -0, -0") {
            if(ebmpIn > 0 && x != ebmpW && y != ebmpH) {
                clp.Overlay(helper,x=a,y=b)
            } else {
                helper
            }
        } else {
            clp.Overlay(helper,x=a,y=b)
        }
    }
}


##================================================================================================##
#   MultiPassDeblendFX:                                                                            #
##================================================================================================##


function MultiPassDeblendFX(clip inRGB24, clip Basemask, clip blankwht, int a, int b, int c, int d, string MskName, int Deep, int FrB, int FrW, int frS, int frx, clip BasemaskP, int Analyze, int Reanalyze, int AnalyzeTh, string NoBorderAt, string LogoID, int Pass) {
    Pass = Pass +1

    if(analyze == -1 || analyze == -2) {
        DeepID = MskName+"_InpaintDelogo3_"+string(a)+"-"+string(b)+"-"+string(abs(c))+"-"+string(abs(d))+"_A"+string(Analyze)+"-"+string(AnalyzeTh)+"_Deep"+string(Pass)
    } else {
        DeepID = MskName+"_InpaintDelogo3_"+string(a)+"-"+string(b)+"-"+string(abs(c))+"-"+string(abs(d))+"_A"+string(Analyze)+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs)+"_Deep"+string(Pass)
    }
    ACmaskfile = DeepID + ".ebmp"

    if(Reanalyze == 0 && Exist(ACmaskfile)) {
        ImageSource(DeepID + "%.0d.ebmp",0,0)
        LogoColor = Crop(0,0,0,last.Height/3).ConvertToRGB24
        LogoAlpha = Crop(0,last.Height/3,0,0).Crop(0,0,0,last.Height/3)
        LogoAlpha = LogoAlpha.Mask(LogoAlpha)
        inRGB24.DeblendLogo(LogoColor, LogoAlpha)
    } else {
        if(Analyze < -2) {
            inRGB24.AnalyzeMethods(Analyze, blankwht=blankwht, FrB=FrB, FrW=FrW, FrS=FrS, frx=frx)
            last.Analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
        } else {
            inRGB24.AnalyzeMethods(Analyze, mask=BasemaskP, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID)
            last.Analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
        }
        StackVertical(last,BlankClip(BasemaskP))
        ImageWriter(DeepID + "%.0d.ebmp",0,-1,"ebmp").RT_YankChain(n=0)
        LogoColor = Crop(0,0,0,last.Height/3).ConvertToRGB24
        LogoAlpha = Crop(0,last.Height/3,0,0).Crop(0,0,0,last.Height/3)
        LogoAlpha = LogoAlpha.Mask(LogoAlpha)
        inRGB24.DeblendLogo(LogoColor, LogoAlpha)
    }
    out  = (Pass == Deep) ? Last : MultiPassDeblendFX(Last,Basemask,blankwht,a,b,c,d,MskName,Deep,FrB,FrW,frS,frx,BasemaskP,Analyze,Reanalyze,AnalyzeTh,NoBorderAt,LogoID, Pass)
    return out
}


##================================================================================================##
#   AnalyzeMethods:                                                                                #
##================================================================================================##


Function ID_VFX2(clip mask, string Analyze5DB) {
    Status = (mask.RT_YInRangeLocate(Baffle=1,lo=255,hi=255)) ? 1 : 2
    if(Status==1) {
        RT_DBaseSet(Analyze5DB,0,Status,YIRL_X,YIRL_Y,YIRL_W,YIRL_H)
    } else {
        RT_DBaseSetField(Analyze5DB,0,0,Status)
    }
    return Last
}


function AnalyzeMethods(clip clp, int Analyze, val "blankwht", int "FrB", int "FrW", int "FrS", int "frx", val "mask", int "AnalyzeTh", string "NoBorderAt", string "FramesLog", int "Show") {
    # Analyze -3 & -4 params
    blankwht   = default (blankwht   , "")
    FrB        = default (FrB        ,  0)
    FrW        = default (FrW        ,  0)
    FrS        = default (FrS        ,  0)
    frx        = default (frx        ,  0)

    # Analyze 1/2/-1/-2 params
    mask       = default (mask       , "")
    AnalyzeTh  = default (AnalyzeTh  , 30)
    NoBorderAt = default (NoBorderAt , "none")
    Show       = default (Show       ,  0)
    FramesLog  = default (FramesLog  , "")

    Assert (!(AnalyzeTh      < 1 || AnalyzeTh      > 255), """"AnalyzeTh" value must be between 1 and 255.""")
    Assert (!(Show           < 0 || Show           >   3), """"Show" value must be between 0 and 3.""")
    Assert ((NoBorderAt == "top" || NoBorderAt == "bottom" || NoBorderAt == "left" || NoBorderAt == "right" || NoBorderAt == "none"), """"NoBorderAt" string must be 'top', 'bottom', 'left', 'right' or 'none'.""")

    TrimFix     = (analyze == -3) ? clp.Trim(FrB,frx)+clp.Trim(FrW,frx)    :
    \             (analyze == -4) ? clp.Trim(FrB,frx)+blankwht.Trim(0,frx) : nop

    Fix         = (FrS == 0 && (analyze == -3 || analyze == -4)) ? TrimFix.Loop(200) :
    \             (FrS == 1 && (analyze == -3 || analyze == -4)) ? TrimFix.Loop(150) :
    \             (FrS == 2 && (analyze == -3 || analyze == -4)) ? TrimFix.Loop(80)  :
    \             (FrS == 3 && (analyze == -3 || analyze == -4)) ? TrimFix.Loop(40)  : nop

    Method      = (analyze ==  0) ? clp.Trim(0,-1)+clp.Trim(0,-1) :
    \             (analyze == -3) ? Fix                           :
    \             (analyze == -4) ? Fix                           : clp

    if(analyze == 1 || analyze == 2 || analyze == -1 || analyze == -2) {
        clp  = Method
        VW   = clp.Width
        VH   = clp.Height
        Th   = AnalyzeTh
        mask = (IsClip(mask)) ? mask.ConvertToY8(matrix="PC.709").MTballoon2PX(2) : nop
        clpS = clp.ScriptClip("subtitle(string(current_frame))")

        # Construct a clip to check thresholds (for deblending analysis) #
        #================================================================#

        if(analyze == 1 || analyze == -1) {
            # Get coords of the logo mask
            Analyze5DB = ("~InpaintDelogo_Analyze5_"+RT_LocalTimeString+".DB").RT_GetFullPathName
            RT_DBaseAlloc(Analyze5DB,1,"iiiii")
            ARGS="Analyze5DB"
            Parse = mask.ScriptClip("ID_VFX2("+args+")", local=true, args=ARGS, after_frame=true)
            Parse.RT_YankChain(n=0)

            Assert (!(RT_DBaseGetField(Analyze5DB,0,0) == 2), "Mask image is invalid.")
            mX = RT_DBaseGetField(Analyze5DB,0,1)
            mY = RT_DBaseGetField(Analyze5DB,0,2)
            mW = RT_DBaseGetField(Analyze5DB,0,3)
            mH = RT_DBaseGetField(Analyze5DB,0,4)
            RT_FileDelete(Analyze5DB)

            # Convert X,Y,W,H coords to L,T,-R,-B coords
            mL = mX
            mT = mY
            mR = -VW + mW + mX
            mB = -VH + mY + mH
            Assert (!(mL < 8 && -1*mR < 8 || mT < 8 && -1*mB < 8), "Mask image or Loc is invalid.")

            # Coords mod2 round up
            mL = mL + (mL % 2)
            mT = mT + (mT % 2)
            mR = mR - (mR % 2)
            mB = mB - (mB % 2)

            # Crop 2x2 pxs area from above or below the logo and make a background from it
            mid = (VW-mL+mR)/2+mL
            mid = mid + (mid % 2)
            clp2x2 = (mT >= -1*mB) ? clp.crop(mid-2, mT-2, -1*(VW-mid), -VH+mT) : clp.crop(mid-2, VH+mB, -1*(VW-mid), mB+2)
            clpB = clp2x2.PointResize(VW, VH)

            Msk1 = mask.MTballoon2PX(2).mt_logic(mask, mode="xor")  # 2px wide mask around logo (+2|3 px offset from the base mask)
            clp5 = clpB.Overlay(clp, mask=Msk1)

        } else if(analyze == 2 || analyze == -2){

            # Construct a clip to check thresholds (for Automask=1 and deblending analysis) #
            #===============================================================================#

            cT = clp.crop(4, 4, -4, -1*(VH-6))
            cB = clp.crop(4, VH-6, -4, -4)
            cL = clp.crop(4, 4, -1*(VW-6), -4)
            cR = clp.crop(VW-6, 4, -4, -4)

            if(NoBorderAt == "top") {
              cT = cB
            } else if (NoBorderAt == "bottom") {
              cB = cT
            } else if (NoBorderAt == "left") {
              cL = cR
            } else if (NoBorderAt == "right") {
              cR = cL
            }

            wc = StackHorizontal(cr,cl).TurnLeft
            hc = StackVertical(ct,cb)

            if(wc.width > hc.width) {
              hc  = hc.PointResize(wc.width, hc.height)
              out = StackVertical(wc,hc)
              } else if(wc.width < hc.width) {
                  wc  = wc.PointResize(hc.width, wc.height)
                  out = StackVertical(wc,hc)
              } else {
                  out = StackVertical(wc,hc)
              }
            clp5 = (Show == 2 || Show == 3) ? out.PointResize(VW, VH) : out
        }

        # Delete frames above thresholds (that leaves us with the suitable frames for analysis) #
        #=======================================================================================#

        # Mod of Gavino's DeleteFrames() - https://forum.doom9.org/showthread.php?t=163107
        clp5
        fc  = FrameCount()
        res = BlankClip(clp, length=0)
        if(Analyze > 0) {
            condition = "YPlaneMinMaxDifference >" +String(Th)+ " || UPlaneMinMaxDifference >" +String(Round(Th/2))+ " || VPlaneMinMaxDifference >" +String(Round(Th/2))
        } else {
            condition = "RPlaneMinMaxDifference >" +String(Th)+ " || GPlaneMinMaxDifference >" +String(Th)+ " || BPlaneMinMaxDifference >" +String(Th)
        }
        current_frame = 0
        FramesLog = FramesLog + ".txt"

        if(Show == 3) { # show whole clip, not selected frames
            return clp5
        }

        if(FramesLog.Exist) {
            clpSel = (Show == 1) ? clpS : (Show == 2) ? clp5 : clp
            clpSel = clpSel.FrameSel(cmd=FramesLog)
            return clpSel
        }

        while (current_frame < fc) {
          while (Eval(condition) && current_frame < fc) {
            current_frame = current_frame+1
          }
          if (current_frame < fc) { # not at end
            start = current_frame # start of wanted section
            while (!Eval(condition) && current_frame < fc) {
              current_frame = current_frame+1
            }
            # 1: Selected frames + original frameNo, 2: Constructed clips (analyze=2 clip is upsized for show) Else: Selected frames
            clpX = (Show == 1) ? clpS : (Show == 2) ? clp5 : clp
            res  = res + clpX.Trim(start, start-current_frame)
            RT_WriteFile(FramesLog,"%d,%d",start,start-current_frame,Append=true)
          }
        }
        Assert (!(res.FrameCount < 2), """No frames found to analyze, increase "AnalyzeTh".""")
        Preamble = "# Total frames to analyze: " +string(res.FrameCount)
        S=RT_ReadTxtFromFile(FramesLog)
        RT_WriteFile(FramesLog,"%s\n%s",Preamble,S)
        if (res.FrameCount < 10) {
          res = res.loop(200)
        } else if (res.FrameCount < 20) {
          res = res.loop(40)
        } else if (res.FrameCount < 40) {
          res = res.loop(20)
        } else if (res.FrameCount < 80) {
          res = res.loop(10)
        } else if (res.FrameCount < 160) {
          res = res.loop(5)
        } else if (res.FrameCount < 320) {
          res = res.loop(2)
        }
    }

    out = (analyze == -3 || analyze == -4) ? method : res
    return out
}


##================================================================================================##
#   TrimergageFX:                                                                                  #
##================================================================================================##


function TrimergageFX(clip clp, int "Seq", int "ClpBlend", int "left") {
    Seq        = default (Seq, 0)
    ClpBlend   = default (ClpBlend, 0)
    left       = default (left, 0)

    trimy      = (left == 0                     ) ? Seq-ClpBlend : (Seq <= left) ? Seq : left
    trimy      = (left == 0 && Seq/2 >= ClpBlend) ?     ClpBlend : trimy

    left       = (left == 0) ? ClpBlend - trimy : left - trimy

    trm     = clp.Trim(trimy, 999999)
    merged  = clp.MergeLuma(trm, 0.5).mt_binarize(threshold=20)
    final   = (left > 0 ) ? merged.TrimergageFX(Seq=trimy*2, left=left) : merged
    return final
}


##================================================================================================##
#   Mask Patching:                                                                                 #
##================================================================================================##


function PatchFuncFX(clip clp, string "patch") {
    patch       = default (patch, "")

    ImgmaskFX   = ImageSource(patch,0,0).Levels(127,1,128,0,255).ConvertToY8(matrix="PC.709")
    WhiteClip   = BlankClip(clp, Color_yuv=$FFFFFF, pixel_type="Y8")
    PatchFX     = clp.mt_merge(WhiteClip, ImgmaskFX, chroma="none")
    return PatchFX
}


##================================================================================================##
#   MT Balloons simulator:                                                                         #
##================================================================================================##


function MTballoonGR(clip clp, int "mode") {
    mode        = default (mode, 0)

    balloon     = (mode == 1) ? clp.mt_expand(thY=170, mode="square",chroma="none")
    \                              .mt_inflate().mt_inflate().mt_inflate() :
    \             (mode == 2) ? clp.mt_expand(thY=180, mode="square",chroma="none")
    \                              .mt_inflate().mt_inflate().mt_inflate().mt_inflate()
    \                              .mt_inflate().mt_inflate().mt_inflate().mt_inflate() :
    \             (mode == 3) ? clp.mt_expand(thY=190, mode="square",chroma="none")
    \                              .mt_inflate().mt_inflate().mt_inflate().mt_inflate()
    \                              .mt_inflate().mt_inflate().mt_inflate().mt_inflate()
    \                              .mt_inflate().mt_inflate().mt_inflate().mt_inflate()
    \                              .mt_inflate().mt_inflate().mt_inflate().mt_inflate() : clp
    return balloon
}


##================================================================================================##
#   MT Balloons emulator:                                                                          #
##================================================================================================##


function MTballoonPX(clip clp, int "mode") {
    mode  = default (mode, 0)

    clp   = (mode < -1) ? clp.mt_expand(mode="both").mt_inpand(mode="both") : clp

    px0   = clp.mt_expand(mode="both",  chroma="none")
    px1   = clp.mt_expand(mode="square",chroma="none")
    px2   = px1.mt_expand(mode="both",  chroma="none")
    px3   = px2.mt_expand(mode="both",  chroma="none")
    px4   = px3.mt_expand(mode="square",chroma="none")

    mpx0  = clp .mt_inpand(mode="both",  chroma="none")
    mpx1  = clp .mt_inpand(mode="square",chroma="none")
    mpx2  = mpx1.mt_inpand(mode="both",  chroma="none")
    mpx3  = mpx2.mt_inpand(mode="both",  chroma="none")
    mpx4  = mpx3.mt_inpand(mode="square",chroma="none")

    kill  = px3
    kill  = kill.mt_inpand(mode="square",chroma="none")
    kill  = kill.mt_inpand(mode="both",  chroma="none")
    kill  = kill.mt_inpand(mode="both",  chroma="none")

    kill1 = clp.RemoveGrain(2)
    kill2 = clp.RemoveGrain(2).RemoveGrain(2)
    kill3 = mpx0.mt_hysteresis(clp, corners=false)
    kill4 = kill1.mt_inpand(mode="both", chroma="none").mt_hysteresis(kill1, corners=false)
    kill5 = kill2.mt_inpand(mode="both", chroma="none").mt_hysteresis(kill2, corners=false)

    out   = (mode ==                 0) ? clp   :
    \       (mode ==                 1) ? px1   :
    \       (mode ==                 2) ? px2   :
    \       (mode ==                 3) ? px3   :
    \       (mode ==                 4) ? px4   :
    \       (mode ==                99) ? kill  :
    \       (mode == 81 || mode == -81) ? kill1 :
    \       (mode == 82 || mode == -82) ? kill2 :
    \       (mode == 83 || mode == -83) ? kill3 :
    \       (mode == 84 || mode == -84) ? kill4 :
    \       (mode == 85 || mode == -85) ? kill5 :
    \       (mode ==                -1) ? px0   : nop
    return out
}


function MTballoon2PX(clip clp, int "mode") {
    mode = default (mode, 0)

    px1 = clp.mt_expand(mode="square", chroma="none")
    px2 = px1.mt_expand(mode="square", chroma="none")
    px3 = px2.mt_expand(mode="square", chroma="none")
    px4 = px3.mt_expand(mode="square", chroma="none")
    px5 = px4.mt_expand(mode="square", chroma="none")
    px6 = px5.mt_expand(mode="square", chroma="none")
    px7 = px6.mt_expand(mode="square", chroma="none")
    px8 = px7.mt_expand(mode="square", chroma="none")
    px9 = px8.mt_expand(mode="square", chroma="none")
    px10= px9.mt_expand(mode="square", chroma="none")

    px1m =  clp.mt_inpand(mode="square", chroma="none")
    px2m = px1m.mt_inpand(mode="square", chroma="none")
    px3m = px2m.mt_inpand(mode="square", chroma="none")
    px4m = px3m.mt_inpand(mode="square", chroma="none")
    px5m = px4m.mt_inpand(mode="square", chroma="none")
    px6m = px5m.mt_inpand(mode="square", chroma="none")
    px7m = px6m.mt_inpand(mode="square", chroma="none")
    px8m = px7m.mt_inpand(mode="square", chroma="none")
    px9m = px8m.mt_inpand(mode="square", chroma="none")
    px10m= px9m.mt_inpand(mode="square", chroma="none")

    balloon = (mode ==  0) ? clp  :
    \         (mode ==  1) ? px1  :
    \         (mode ==  2) ? px2  :
    \         (mode ==  3) ? px3  :
    \         (mode ==  4) ? px4  :
    \         (mode ==  5) ? px5  :
    \         (mode ==  6) ? px6  :
    \         (mode ==  7) ? px7  :
    \         (mode ==  8) ? px8  :
    \         (mode ==  9) ? px9  :
    \         (mode == 10) ? px10 :
    \         (mode == -1) ? px1m :
    \         (mode == -2) ? px2m :
    \         (mode == -3) ? px3m :
    \         (mode == -4) ? px4m :
    \         (mode == -5) ? px5m :
    \         (mode == -6) ? px6m :
    \         (mode == -7) ? px7m :
    \         (mode == -8) ? px8m :
    \         (mode == -9) ? px9m :
    \         (mode ==-10) ? px10m: nop
    return balloon
}


##================================================================================================##
#   Balloons simulator:                                                                            #
##================================================================================================##


function balloonGR(clip clp, int "mode") {
    mode        = default (mode, 0)

    balloon     = (mode == 1) ? clp.DistanceFunction(64).ShowAlpha :
    \             (mode == 2) ? clp.DistanceFunction(44).ShowAlpha :
    \             (mode == 3) ? clp.DistanceFunction(32).ShowAlpha : clp

    return balloon
}


##================================================================================================##
#   Balloons emulator:                                                                             #
##================================================================================================##


function balloonPX(clip clp, int "mode") {
    mode        = default (mode, 0)

    px1         = clp.DistanceFunction(128).Levels(30,1,31,0,255)
    px2         = clp.DistanceFunction(64) .Levels(70,1,71,0,255)
    px3         = clp.DistanceFunction(48) .Levels(70,1,71,0,255)
    px4         = clp.DistanceFunction(38) .Levels(70,1,71,0,255)

    mpx1        = clp .DistanceFunction(-96).Levels(150,1,151,0,255)
    mpx2        = mpx1.DistanceFunction(-96).Levels(150,1,151,0,255)
    mpx3        = mpx2.DistanceFunction(-96).Levels(150,1,151,0,255)
    mpx4        = mpx3.DistanceFunction(-96).Levels(150,1,151,0,255)

    mpx7        = clp.DistanceFunction(-32).Levels(240,1,241,0,255)

    kill        = px3.DistanceFunction(-32).Levels(110,1,111,0,255)

    kill2       = mpx1.DistanceFunction(128).Levels(30,1,31,0,255)

    balloon     = (mode ==  0) ? clp  :
    \             (mode ==  1) ? px1  .ShowAlpha :
    \             (mode ==  2) ? px2  .ShowAlpha :
    \             (mode ==  3) ? px3  .ShowAlpha :
    \             (mode ==  4) ? px4  .ShowAlpha :
    \             (mode == 99) ? kill .ShowAlpha :
    \             (mode == 88) ? kill2.ShowAlpha :
    \             (mode == -1) ? mpx1 .ShowAlpha :
    \             (mode == -2) ? mpx2 .ShowAlpha :
    \             (mode == -3) ? mpx3 .ShowAlpha :
    \             (mode == -4) ? mpx4 .ShowAlpha :
    \             (mode == -7) ? mpx7 .ShowAlpha : nop
    return balloon
}


##================================================================================================##
#   KillBalloonFX function:                                                                        #
##================================================================================================##


function KillBalloonFX(clip c, int "mode", int "pre", int "h2", int "h3") {
    mode = default(mode, 0)
    pre  = default(pre, 0)
    h2   = default(h2, 0)
    h3   = default(h3, 0)

    clp = (pre ==  0) ? c :
    \     (pre ==  1) ? c.mt_expand(mode="both",   chroma="none") :
    \     (pre ==  2) ? c.mt_expand(mode="square", chroma="none") :
    \     (pre == -1) ? c.mt_expand(mode="both",   chroma="none").mt_inpand(mode="both",   chroma="none") :
    \     (pre == -2) ? c.mt_expand(mode="square", chroma="none").mt_inpand(mode="square", chroma="none") : nop

    mpx1 = clp .mt_inpand(mode="square", chroma="none")
    mpx2 = mpx1.mt_inpand(mode="square", chroma="none")
    mpx3 = mpx2.mt_inpand(mode="square", chroma="none")
    mpx4 = mpx3.mt_inpand(mode="square", chroma="none")
    mpx5 = mpx4.mt_inpand(mode="square", chroma="none")
    mpx6 = mpx5.mt_inpand(mode="square", chroma="none")
    mpx7 = mpx6.mt_inpand(mode="square", chroma="none")
    mpx8 = mpx7.mt_inpand(mode="square", chroma="none")

    in = (mode  < 1) ? clp  :
    \    (mode == 1) ? mpx1 :
    \    (mode == 2) ? mpx2 :
    \    (mode == 3) ? mpx3 :
    \    (mode == 4) ? mpx4 :
    \    (mode == 5) ? mpx5 :
    \    (mode == 6) ? mpx6 :
    \    (mode == 7) ? mpx7 :
    \    (mode == 8) ? mpx8 : nop

    px1 = in .mt_expand(mode="square", chroma="none")
    px2 = px1.mt_expand(mode="square", chroma="none")
    px3 = px2.mt_expand(mode="square", chroma="none")
    px4 = px3.mt_expand(mode="square", chroma="none")
    px5 = px4.mt_expand(mode="square", chroma="none")
    px6 = px5.mt_expand(mode="square", chroma="none")
    px7 = px6.mt_expand(mode="square", chroma="none")
    px8 = px7.mt_expand(mode="square", chroma="none")

    hx1 = mpx1.mt_hysteresis(clp, corners=false)
    hx2 = mpx2.mt_hysteresis(clp, corners=false)
    hx3 = mpx3.mt_hysteresis(clp, corners=false)
    hx4 = mpx4.mt_hysteresis(clp, corners=false)
    hx5 = mpx5.mt_hysteresis(clp, corners=false)
    hx6 = mpx6.mt_hysteresis(clp, corners=false)
    hx7 = mpx7.mt_hysteresis(clp, corners=false)
    hx8 = mpx8.mt_hysteresis(clp, corners=false)

    msk = (mode ==  0) ? clp :
    \     (mode == -1) ? hx1 :
    \     (mode == -2) ? hx2 :
    \     (mode == -3) ? hx3 :
    \     (mode == -4) ? hx4 :
    \     (mode == -5) ? hx5 :
    \     (mode == -6) ? hx6 :
    \     (mode == -7) ? hx7 :
    \     (mode == -8) ? hx8 :
    \     (mode ==  1) ? px1 :
    \     (mode ==  2) ? px2 :
    \     (mode ==  3) ? px3 :
    \     (mode ==  4) ? px4 :
    \     (mode ==  5) ? px5 :
    \     (mode ==  6) ? px6 :
    \     (mode ==  7) ? px7 :
    \     (mode ==  8) ? px8 : nop

    msk = (h2 == 0) ? msk :
    \     (h2 == 1) ? msk.mt_expand(mode="square") :
    \     (h2 == 2) ? msk.mt_expand(mode="square").mt_expand(mode="square") :
    \     (h2 == 3) ? msk.mt_expand(mode="square").mt_expand(mode="square").mt_expand(mode="square") :
    \     (h2 == 4) ? msk.mt_expand(mode="square").mt_expand(mode="square").mt_expand(mode="square").mt_expand(mode="square") : nop

    # Replaced v1.33, few % faster.
    #blk = BlankClip(clp, Color_yuv=$000000, pixel_type="Y8")
    #ooo = clp.Overlay(blk, mask=msk)
    ooo = clp.mt_makediff(msk).mt_binarize()

    out = (pre == 1) ? ooo.mt_inpand(mode="both",   chroma="none") :
    \     (pre == 2) ? ooo.mt_inpand(mode="square", chroma="none") :
    \     (h3  == 1) ? ooo.mt_inpand(mode="square") :
    \     (h3  == 2) ? ooo.mt_inpand(mode="square").mt_inpand(mode="square") :
    \     (h3  == 3) ? ooo.mt_inpand(mode="square").mt_inpand(mode="square").mt_inpand(mode="square") : ooo
    return out
}


##================================================================================================##
#   DynRePassFX function:                                                                          #
##================================================================================================##


function DynRePassFX(clip clp, int "Dyn3Seq", int "ClpBlend", int "KillNoise") {
    Dyn3Seq   = default (Dyn3Seq, 0)
    ClpBlend  = default (ClpBlend, 0)
    KillNoise = default (KillNoise, 0)

    re = clp.ClipBlend(ClpBlend).mt_binarize(254).TrimergageFX(Seq=Dyn3Seq, ClpBlend=ClpBlend)
    out = (KillNoise != 0) ? re.MTballoonPX(KillNoise) : re
    return out
}


##================================================================================================##
#   ppFX function:                                                                                 #
##================================================================================================##


function ppFX(clip clp, int "x") {
    x           = default (x, 0)
    mode        = abs(x)

    pp          = (mode == 1) ? clp.Blur(0.3 ) :
    \             (mode == 2) ? clp.Blur(0.7 ) :
    \             (mode == 3) ? clp.Blur(1.58) :
    \             (mode == 4) ? clp.Blur(1.00).Blur(1.58) :
    \             (mode == 5) ? clp.Blur(1.58).Blur(1.58).Blur(1.58) :
    \             (mode == 6) ? clp.Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58) :
    \             (mode == 7) ? clp.Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58) :
    \             (mode == 8) ? clp.Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58)
    \                              .Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58).Blur(1.58) : clp

    return (x < -4) ? pp.FFT3DFilter(sigma=8, plane=4) : (x < 0) ? pp.FFT3DFilter(sigma=4, plane=4) : pp
}


##================================================================================================##
#   InpaintLoc function:                                                                           #
##================================================================================================##


function InpaintLoc ( clip clp, string "loc")
{
    loc         = default (loc,  "")
    x           = width   (clp)
    y           = height  (clp)

    bugloc      = (loc == "" ) ? true : false

    assert        ( bugloc            == false  , """You must define "Loc".""")

    loc         = ReplaceStr(loc," ","")
    long        = StrLen(loc)
    posvirg1    = findstr(loc, ",")
    posvirg2    = findstr(rightstr(loc,long-posvirg1), ",")
    posvirg2    = posvirg2+posvirg1
    posvirg3    = findstr(rightstr(loc,long-posvirg2), ",")
    posvirg3    = posvirg3 + posvirg2

    a           = int(value(leftstr(loc,posvirg1-1)))
    b           = int(value(leftstr(rightstr(loc,long-posvirg1),posvirg2-posvirg1-1)))
    c           = int(value(leftstr(rightstr(loc,long-posvirg2),posvirg3-posvirg2-1)))
    d           = int(value(rightstr(loc,long-posvirg3)))

    a           = (a < 0 ) ? x+a   : a         # ssS: Added, convert -ve logoX  to +ve LogoX
    b           = (b < 0 ) ? y+b   : b         # ssS: Added, convert -ve logoY  to +ve LogoY
    c           = (c > 0 ) ? a+c-x : c         # ssS: Added, convert +ve width  to -ve width
    d           = (d > 0 ) ? b+d-y : d         # ssS: Added, convert +ve height to -ve height

    Assert (c   <= 0 && d <= 0,"""Incorrect "Loc".""")
	Assert (a   >= 0 && b >= 0,"""Incorrect "Loc".""")
	Assert (a%2 == 0 && b%2 == 0 && c%2 == 0 && d%2 == 0,"""Use even numbers for "Loc".""")

    hightlight  = blankclip(width=x-a+c,height=y-b+d,color=$96ff2d).converttoRGB32

    out         = clp.converttoRGB32.layer(hightlight.Mask(blankclip(hightlight, color=$444444)),x=a,y=b)
    return out
}


##================================================================================================##
#   Subtitles Extractor functions:                                                                 #
##================================================================================================##


Function ID_VFX1(clip c, string FrameDB, int VW, int coordLp, int coordT, int coordW, int coordH) {
        c
        n = current_frame
        Status = RT_DBaseGetField(FrameDB,n,0)
        if(Status == 0) {  # Unknown Status
            Status = crop(coordLp, coordT, coordW, coordH).AverageLuma.Sign
            if(Status == 1) { RT_DBaseSet(FrameDB,n,Status) }
        }
        Return Last
}

# Mod of StainlessS's 'DetSub_Extract.avs' - https://forum.doom9.org/showthread.php?p=1950193
Function SubsMask2Img(clip clp, clip "Raw", String "ImgDir", Float "CorrTh", Int "SubTune", Int "SubMinDur", Int "SubSusDur", Float "SubMinLuma", Float "SubSusLuma",
\                     String "ImgType", Int "ImgInflate", Int "ImgInvert", Int "ImgSize", Int "RawAvr", Int "StartIn", Int "DetWinPercW", Int "DetWinPercH", Float "DetWinHoPos")

{
    CorrTh      = Default(CorrTh      ,  0.8)
    DetWinPercW = Default(DetWinPercW ,   10)    Assert (!(DetWinPercW  <    5 || DetWinPercW  >   95), """"DetWinPercW" value must be between 5 and 95.""")
    DetWinPercW = 1 - DetWinPercW * 0.01
    DetWinPercH = Default(DetWinPercH ,   60)    Assert (!(DetWinPercH  <   30 || DetWinPercH  >   95), """"DetWinPercH" value must be between 30 and 95.""")
    DetWinPercH = 1 - DetWinPercH * 0.01
    DetWinHoPos = Default(DetWinHoPos ,    0)    Assert (!(DetWinPercW - abs(DetWinHoPos)      < 0.01), """"DetWinHoPos" out of boundary.""")
    SubTune     = Default(SubTune     ,  235)
    SubMinDur   = Default(SubMinDur   ,   12)
    SubSusDur   = Default(SubSusDur   ,    0)
    SubSusLuma  = Default(SubSusLuma  ,    0)
    ImgType     = Default(ImgType     ,"png")
    ImgInflate  = Default(ImgInflate  ,    0)
    ImgInvert   = Default(ImgInvert   ,    0)
    ImgSize     = Default(ImgSize     ,    1)
    ImgDir      = Default(ImgDir      ,   "")
    RawAvr      = Default(RawAvr      ,    1)
    StartIn     = Default(StartIn     ,    0)
    StartTime   = (StartIn == 0) ? TimerFX() : StartIn

    Assert(FunctionExists("GScriptClip"), "Install GRunT plugin.")

    Assert (!(CorrTh      <   0.5 || CorrTh      >  0.95), """"CorrTh" value must be between 0.5 and 0.95.""")
    Assert (!(SubTune     <   100 || SubTune     >   254), """"SubTune" value must be between 200 and 254.""")
    Assert (!(SubMinDur   <     1 || SubMinDur   >    30), """"SubMinDur" value must be between 1 and 20.""")
    Assert (!(SubSusDur   <     0 || SubSusDur   >    60), """"SubSusDur" value must be between 0 and 40.""")
    Assert (!(SubSusLuma  <     0 || SubSusLuma  >     5), """"SubSusLuma" value must be between 0 and 5.""")
    Assert ( (ImgType    == "png" || ImgType    == "tif" || ImgType    == "jpg"), """"ImgType" string must be 'png', 'tif' or 'jpg'.""")
    Assert (!(ImgInflate   <    0 || ImgInflate  >     1), """"ImgInflate" value must be between 0 and 1.""")
    Assert (!(ImgInvert    <    0 || ImgInvert   >     1), """"ImgInvert" value must be between 0 and 1.""")
    Assert (!(ImgSize      <    1 || ImgSize     >     4), """"ImgSize" value must be between 1 and 4.""")
    Assert (!(RawAvr       <    0 || RawAvr      >     1), """"RawAvr" value must be between 0 and 1.""")

    Assert (ImgDir!="","""Specify "ImgDir" (folder must exist)!"""+Chr(10)+"""Can use '.\' for current directory.""")
    ImgDir = RT_GetFullPathname(ImgDir)
    ImgDir = ImgDir.RevStr
    while  (ImgDir.FindStr("\")==1 || ImgDir.FindStr("/")==1) { ImgDir=ImgDir.MidStr(2)}
    ImgDir = ImgDir.RevStr
    Assert (ImgDir.Exist,""""ImgDir" folder not found!""")

    ImgDirRaw = ImgDir + "_raw"
    RawClip   = (IsClip(Raw) == true) ? 1 : 0

    if (RawClip == 1) {
       Assert (ImgDirRaw!=".\_raw","""Specify "ImgDir" (folder must exist)!""")
       ImgDirRaw = RT_GetFullPathname(ImgDirRaw)
       ImgDirRaw = ImgDirRaw.RevStr
       while  (ImgDirRaw.FindStr("\")==1 || ImgDirRaw.FindStr("/")==1) { ImgDirRaw=ImgDirRaw.MidStr(2)}
       ImgDirRaw = ImgDirRaw.RevStr
       Assert (ImgDirRaw.Exist,"""Folder for the raw images not found!""")
    }

    RangeDB = ("~SubsMask2Img_RangeDB_"+RT_LocalTimeString+".DB").RT_GetFullPathName
    FrameDB = ("~SubsMask2Img_FrameDB_"+RT_LocalTimeString+".DB").RT_GetFullPathName
    FC      = clp.FrameCount
    VW      = clp.Width
    VH      = clp.Height
    coordL  = int((VW / 2) *DetWinPercW)
    coordT  = int((VH / 2) *DetWinPercH)
    coordW  = VW - (coordL*2)
    coordH  = VH - (coordT*2)
    coordLp = int((VW / 2) *(DetWinPercW-DetWinHoPos))
    inY8    = clp.ConvertToY8()

    # adaptive SubMinLuma:
    coordLa  = int((VW / 2) *0.90)
    coordTa  = int((VH / 2) *0.40)
    coordWa  = VW - (coordLa*2)
    coordHa  = VH - (coordTa*2)
    resA     = coordWa * coordHa
    resO     = coordW * coordH
    SubMinLuma  = (resO/2 < resA) ? Default(SubMinLuma, 0.5) : (resO/10 < resA) ? Default(SubMinLuma, 0.25) : (resO/50 < resA) ? Default(SubMinLuma, 0.05) : Default(SubMinLuma, 0.02)
    Assert (!(SubMinLuma  <     0 || SubMinLuma  >   0.5), """"SubMinLuma" value must be between 0 and 0.5.""")

    # Detect if sub is on individual frames, and write FrameDB: #
    #===========================================================#

    RT_DBaseAlloc(FrameDB,FC,"i")
    ARGS="FrameDB, VW, coordLp, coordT, coordW, coordH"
    Parse = inY8.ScriptClip("ID_VFX1("+args+")", local=true, args=ARGS, after_frame=true)
    Parse.RT_ForceProcess


    # Split contiguous subs, and write RangeDB: #
    #===========================================#

    RT_DBaseAlloc(RangeDB,0,"ii")   # fields, 0=StartFrameNo, 1=EndFrameNo
    SplitCnt = 0
    MultiSubStart = -1               # Not currently within Subtitle range

    Corr_BelowTh_Max    = -1.0
    Corr_BelowTh_Max_Fr = -1
    Corr_AboveTh_Min    = 1.0
    Corr_AboveTh_Min_Fr = -1

    for(n=0,FC) {                    # Scan & split Subtitle ranges [might not have clean frames between them]
        Status = (n >= FC) ? 0 : RT_DBaseGetField(FrameDB,n,0)
        Close  = (MultiSubStart >= 0 && Status != 1)   # If we were scanning subs sequence but this one is invalid, then we will close.
        CloseCorr = False
        if(Status == 1) {            # Valid Subtitle Frame ?
            if(MultiSubStart < 0) {  # n new MultiSub : New start of possibly non-separated sub
                MultiSubStart = n
            } else {                 # already inside MultiSub sequence
                Corr  = RT_LumaCorrelation(inY8, inY8, n=n-1, n2=n)
                Close = (Corr < CorrTh)
                CloseCorr = (Corr < CorrTh)
                if(CloseCorr) {
                    checkA = Corr_BelowTh_Max
                    Corr_BelowTh_Max=Max(Corr_BelowTh_Max,Corr)
                    if(checkA != Corr_BelowTh_Max) {
                        Corr_BelowTh_Max_Fr = n
                    }
                } else {
                    checkB = Corr_AboveTh_Min
                    Corr_AboveTh_Min=Min(Corr_AboveTh_Min,Corr)
                    if(checkB != Corr_AboveTh_Min) {
                        Corr_AboveTh_Min_Fr = n
                    }
                }
            }
        }
        if(Close) {                  # We were scanning sequence and either, this frame is not sub OR sub split found.
            RT_DBaseAppend(RangeDB, MultiSubStart, n-1)    # n is start of next new or split sequence or end of clip
            MultiSubStart = (Status==1) ? n : -1
        }
    }


    # Extracting images: #
    #====================#

    NSubs = RT_DBaseRecords(RangeDB) # Number of SEPARATE INDIVIDUAL Subtitles
    ESubs = NSubs
    ESubs2= NSubs
    SSubs = 0
    SSubs2= 0
    fps   = clp.FrameRate

    for(i=0,NSubs-1) {
        SubStart = RT_DBaseGetField(RangeDB,i,0)
        SubEnd   = RT_DBaseGetField(RangeDB,i,1)
        SubDur   = SubEnd - SubStart + 1
        if(SubDur >= SubMinDur && SubDur > SubSusDur) {
            FNam  = Frame2TimeFX(SubStart,fps) +"__"+ Frame2TimeFX(SubEnd+1,fps)
            One0  = inY8.Trim(SubStart,SubEnd).ClipBlend.Trim(SubEnd-SubStart+1,-1)
            avgL  = One0.crop(coordLp, coordT, coordW, coordH).mt_binarize(254).AverageLuma
            if(avgL >= SubMinLuma && avgL >= SubSusLuma) {
                OneF1 = One0.mt_binarize(SubTune)
                OneF2 = (ImgType == "png") ? OneF1 : OneF1.ConvertToRGB24
                OneF3 = (ImgSize ==     1) ? OneF2 : OneF2.PointResize(VW*ImgSize,VH*ImgSize)
                OneF4 = (ImgInflate ==  0) ? OneF3 : OneF3.mt_expand(mode="square")
                OneF5 = (ImgInvert  ==  0) ? OneF4 : OneF4.Invert
                OneF5.ImageWriter(ImgDir+"\"+FNam+"%.0d.%s",0,-1,ImgType).RT_YankChain(n=0)
                if(RawClip == 1){
                    if(RawAvr == 1){
                        Raw0 = Raw.Trim(SubStart,SubEnd).ClipBlend.Trim(SubEnd-SubStart+1,-1).ConvertToRGB24
                    } else {
                        Raw0 = Raw.Trim(SubStart,SubEnd).Trim(abs(SubEnd-SubStart+1)/2,-1).ConvertToRGB24
                    }
                    Raw0.ImageWriter(ImgDirRaw+"\"+FNam+"%.0d.%s",0,-1,ImgType).RT_YankChain(n=0)
                }
            } else if(avgL >= SubMinLuma) {
                  OneF1 = One0.mt_binarize(SubTune)
                  OneF2 = (ImgType == "png") ? OneF1 : OneF1.ConvertToRGB24
                  OneF3 = (ImgSize ==     1) ? OneF2 : OneF2.PointResize(VW*ImgSize,VH*ImgSize)
                  OneF4 = (ImgInflate ==  0) ? OneF3 : OneF3.mt_expand(mode="square")
                  OneF5 = (ImgInvert  ==  0) ? OneF4 : OneF4.Invert
                  OneF5.ImageWriter(ImgDir+"\_"+FNam+"%.0d.%s",0,-1,ImgType).RT_YankChain(n=0)
                  SSubs2 = SSubs2+1
                  if(RawClip == 1){
                      if(RawAvr == 1){
                          Raw0 = Raw.Trim(SubStart,SubEnd).ClipBlend.Trim(SubEnd-SubStart+1,-1).ConvertToRGB24
                      } else {
                          Raw0 = Raw.Trim(SubStart,SubEnd).Trim(abs(SubEnd-SubStart+1)/2,-1).ConvertToRGB24
                      }
                      Raw0.ImageWriter(ImgDirRaw+"\_"+FNam+"%.0d.%s",0,-1,ImgType).RT_YankChain(n=0)
                  }
            } else {
                  ESubs2 = ESubs2-1
            }
        } else if(SubDur >= SubMinDur) {
              FNam  = Frame2TimeFX(SubStart,fps) +"__"+ Frame2TimeFX(SubEnd+1,fps)
              One0  = inY8.Trim(SubStart,SubEnd).ClipBlend.Trim(SubEnd-SubStart+1,-1)
              avgL  = One0.crop(coordLp, coordT, coordW, coordH).mt_binarize(254).AverageLuma
              if(avgL >= SubMinLuma) {
                  OneF1 = One0.mt_binarize(SubTune)
                  OneF2 = (ImgType == "png") ? OneF1 : OneF1.ConvertToRGB24
                  OneF3 = (ImgSize ==     1) ? OneF2 : OneF2.PointResize(VW*ImgSize,VH*ImgSize)
                  OneF4 = (ImgInflate ==  0) ? OneF3 : OneF3.mt_expand(mode="square")
                  OneF5 = (ImgInvert  ==  0) ? OneF4 : OneF4.Invert
                  OneF5.ImageWriter(ImgDir+"\_"+FNam+"%.0d.%s",0,-1,ImgType).RT_YankChain(n=0)
                  SSubs = SSubs+1
                  if(RawClip == 1){
                      if(RawAvr == 1){
                          Raw0 = Raw.Trim(SubStart,SubEnd).ClipBlend.Trim(SubEnd-SubStart+1,-1).ConvertToRGB24
                      } else {
                          Raw0 = Raw.Trim(SubStart,SubEnd).Trim(abs(SubEnd-SubStart+1)/2,-1).ConvertToRGB24
                      }
                      Raw0.ImageWriter(ImgDirRaw+"\_"+FNam+"%.0d.%s",0,-1,ImgType).RT_YankChain(n=0)
                  }
              } else {
                  ESubs2 = ESubs2-1
              }
        } else {
            ESubs = ESubs-1
        }
    }

    TSubs = NSubs - ESubs
    TSubs2= NSubs - ESubs2
    ESsum = ESubs + ESubs2 - NSubs
    RT_FileDelete(FrameDB)
    RT_FileDelete(RangeDB)
    RunTime = TimerFX(StartTime)

    out = Messageclip(RT_String("""            Possible subtitles detected        : %04d             """+
                              \ """\n            Suspicious ('SubSusDur'=%02d)    : %04d             """+
                              \ """\n            Suspicious ('SubSusLuma'=%02g) : %04d             """+
                              \ """\n            Trash ('SubMinDur'=%02d)              : %04d             """+
                              \ """\n            Trash ('SubMinLuma'=%02g)          : %04d             """+
                              \ """\n            Subtitle images extracted           : %04d             """+
                              \ """\n=========================================="""+
                              \ """\nMin Correlation Above Th. : %f"""+
                              \ """\nSet Correlation Threshold : %f"""+
                              \ """\nMax Correlation Below Th. : %f"""+
                              \ """\n=========================================="""+
                              \ """\nFrame No. of Min Correlation Above Th. : %d"""+
                              \ """\nFrame No. of Max Correlation Below Th. : %d"""+
                              \ """\n=========================================="""+
                              \ """\nTime elapsed: %s""", NSubs,SubSusDur,SSubs,SubSusLuma,SSubs2,SubMinDur,TSubs,SubMinLuma,TSubs2,ESsum,Corr_AboveTh_Min,CorrTh,Corr_BelowTh_Max,Corr_AboveTh_Min_Fr,Corr_BelowTh_Max_Fr,RunTime), text_color=color_goldenrod)
    return out
}


function Frame2TimeFX(int frame, float fps) {
     msTime = round(frame * 1000 / fps)

    _s  = msTime / 1000
    _ms = msTime % 1000
    _m  = _s / 60
    _s  = _s % 60
    _h  = _m / 60
    _m  = _m % 60

    hh  = string(_h,  "%02.0f")
    mm  = string(_m,  "%02.0f")
    ss  = string(_s,  "%02.0f")
    ms  = string(_ms, "%03.0f")

    timeStr = hh+"_"+mm+"_"+ss+"_"+ms
    return timeStr
}


function TimerFX(int "startTime") {
    startTime = default(startTime, 0)

    a = Value(Time("%#S"))
    b = Value(Time("%#M")) *60
    c = Value(Time("%#H")) *3600
    x = int(a+b+c)

    s = (startTime == 0) ? x : x - startTime
    s = (s < 0) ? 86400 - startTime + x : s

    hours   = floor(s /3600)
    s1      = s - hours *3600
    minutes = floor(s1 /60)
    seconds = s1 - minutes *60

    hh = String(hours,   "%02.0f")
    mm = String(minutes, "%02.0f")
    ss = String(seconds, "%02.0f")

    timeMs  = x
    timeStr = hh+":"+mm+":"+ss
    out = (startTime == 0) ? timeMs : timeStr
    return out
}


Function ID_VFX3(clip c, int VW, int coordT, int coordW, int coordH, float CorrTh, float DetWinPercW, float DetWinHoPos) {
    c
    n      = current_frame
    coordL = int((VW / 2) *(DetWinPercW-DetWinHoPos))
    xClp   = BlankClip(c, Color_yuv=$666666).crop(coordL, coordT, coordW, coordH)
    Status = crop(coordL, coordT, coordW, coordH).AverageLuma.Sign
    Corr   = RT_LumaCorrelation(c, c, n=n-1, n2=n)
    isSub  = (Status == 0) ? "Possible subtitle: No " : "Possible subtitle: Yes"
    isNew  = (Corr < CorrTh && Status == 1) ? "Possible start of new subtitle: Yes" : "Possible start of new subtitle: No "
    Overlay(xClp, x=coordL, y=coordT, opacity=0.5)
    subtitle(isSub +"\n" +isNew+"\n" +"CorrTh="+String(CorrTh)+" | "+ "Corr="+String(Corr), lsp = 0)
    return Last
}
