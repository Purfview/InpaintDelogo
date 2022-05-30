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
#   Version: 2.15                                                                                  #
##================================================================================================##


# Author       : VoodooFX

# Doom9 link   : https://forum.doom9.org/showthread.php?p=1883832
# GitHub link  : https://github.com/Purfview/InpaintDelogo


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
#  AviSynth+ v3.7.1 or later ( https://github.com/AviSynth/AviSynthPlus ).
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


##================================================================================================##
#   InpaintLoc() manual:                                                                           #
##================================================================================================##


#  This function will help you to determine "Loc" values.

# string "Loc" :  Select a part of picture around the logo.
#
#                Use same as Crop ("Left,Top,-Right,-Bottom") coordinates.
#                Example: Loc="100,100,-100,-100".
#
#                Or use -ve LogoX,LogoY, and +ve LogoW,LogoH coordinates.
#                [LogoX=Width-200, LogoY=Height-100, LogoX2=Width-30, LogoY2=Height-20]
#                Example: Loc="-200,-100,-30,-20".
#
#                Include 10(no less) - ~16 pixel borders around the logo!
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

# String "Loc"      :  Use InpaintLoc() function to find coordinates.
#                     Use even(mod2) numbers.
#                     Include 10(no less) - ~16 pixel borders around logo!
#                     Black or other borders shouldn't be present in the "Loc" area.


# val "mask"        : File based mask:
#                     Full path to the base mask of the logo, a binary image where Logo is full white and background is full black.
#                     Example: mask="C:\mymask.bmp".
#                     Resolution of the image must be same as video clip's frame.
#                     Don't include surrounding bleed of the logo, just exact logo.
#                      Actually script is not strict about a format of the picture, it will
#                     convert whatever you give to a Black/White mask.
#                      You can use "Automask" option to auto-generate the base mask.
#
#                      Clip based mask:
#                      "mask" accepts clip input, resolution must be same as "Loc" area.
#                      Dynamic mask expected to be full range Y8 or will be converted.
#                      Static mask must be one frame clip otherwise it will be treated as a dynamic mask.


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


# String "Mode"     :  Delogo mode (default: Inpaint):
#                     Inpaint - Use if logo is opaque/hardly transparent.
#                     Deblend - Use if logo is transparent.
#                     Both    - Use if logo is both: a logo has transparent and opaque/hardly transparent parts.


# Int "Analyze"     :  Analyze methods for deblend/transparent logo ("Deblend" & "Both" modes). (from -4 to 2)
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


# Int "IntSpd"      :  Speed of "Interp".
#
#                     1 - Fast (default).
#                     2 - Slow. Slight increase of quality.
#                     3 - Very slow. Slight increase of quality.


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


# Int "oTune"       :  Creation of the mask for "Both" mode. (from -10 to 5; default: 0).
#                     Creates mask for opaque/hardly transparent part of the logo.
#                     0 - doesn't mean that it's disabled, it is just a datum-point.
#                     Higher values -> mask expands into more-transparent areas of the logo.


# Int "oTinflate"   :  Inflates the oTune mask.
#
#                     0 - Disabled  (default).
#                     1 - Inflate by 1 pixel.
#                     2 - Inflate by 2 pixels.
#                     3 - Inflate by 3 pixels.


                 #===================#
                 #   Dynamic mask:   #
                 #===================#

# Int "DynMask"     :  Delogo with a dynamic mask, currently not for "Deblend".
#                      All other "Inpaint" only parameters should work with it too.
#                      All masks are only for "Inpaint". Except DynMask2 works in "Both" too [but only "DynTune" mask].
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


# Int "DynInflate"  :  Inflates the dynamic mask. Last in the filters chain (before "maskPatch" and "oPP").
#                      If few masks are mixed into combo then better use separate inflation parameters [like "DynTuneInf", etc.].
#
#                    -1 - Similar as 1 but lil weaker ('both' instead of 'square').
#                     0 - Disabled  (default).
#                     1 - Inflate by 1 pixel.
#                     2 - Inflate by 2 pixels.
#                     3 - Inflate by 3 pixels.
#                     4 - Inflate by 4 pixels.


#   DynMask=5.
#=============================================================================================================
# NOTES:             :  When "DynMask=5": "DynInflate" is auto hardset to 0.


# Int "DynColor"     :  Auto generation of the dynamic mask by color. (from 0[$000000] to $FFFFFF; default: 0).
#                      Color of logo/subtitle in RGB [hex value].
#                      Use AvsPmod to get color value ('CopyPixelinfo' macro can be used for a fast copy).
#                      0 - Disabled  (default).


# Int "DynColorTol"  :  Parameter for "DynColor". Color tolerance. (from 1 to 80; default: 10).


# Int "DynColorInf"  :  Inflates "DynColor" mask. (from 0 to 4; default: 1).
#=============================================================================================================


#   DynMask=6.
#=============================================================================================================
# NOTES:             :  When "DynMask=6": "DynInflate" is auto hardset to 0.


# Int "DynTune"      :  A dynamic mask for "DynMask=2/3/4/6". Binarization threshold [brighness level]. (from 1 to 254; default: 200).
#                      Lower values -> mask expands more into the darker areas of video.
#                      Set highest where logo/subtitle is still visible.

# Int "DynTuneInf"  :  Inflates "DynTune" mask. (from -1 to 4; default: 0).
#=============================================================================================================


#   DynMask=7.
#=============================================================================================================
# NOTES:             :  When "DynMask=7": "DynInflate" is auto hardset to 0.


# Int "DynTEdge"     :  Auto generation of the dynamic mask by gradient magnitude map. (from 0 to 1; default: 0).
#                      0 - Disabled  (default).


# Int "DynTEdgeThY"  :  Parameter for "DynTEdge". Magnitude threshold. (from 10 to 100; default: 20).
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


# Int "KillBlobs"   :  Removes thicker than logo/subs artifacts (from -7 to 7; default: 0).
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


# Int "Extract"     :  Extracts subtitles to images from a dynamic mask with SubsMask2Img() function.
#                     Works only with "DynMask" through "Show=4".
#                     When enabled the script will work till extraction is done, so use only after a dynamic mask is all set.
#                     It will pass SubsMask2Img() parameters from InpaintDelogo() func to SubsMask2Img().
#                     Makes stuff work in one go, but it's much slower than using SubsMask2Img() on a separate mask video.
#                     See SubsMask2Img() manual somewhere below!
#
#                     0 - Off (Default).
#                     1 - Extracts subtitles, black and white binarized images.
#                     2 - Extracts subtitles, black and white binarized images and raw non-binarized images.


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

# NOTES:            :  For subtitles with a dark halo.

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

# Int "dPP"         :  Blur amount applied to delogoed area to hide artifacts (default: 3).
#                     (0 - Disabled. Max - 8).


# Int "dPPm"        :  Adds smooth borders to the deblend mask, used for "dPP" post-process,
#                     it will blend in a deblended area into the surrounding.(default: 3/adaptive).
#
#                     0 - Disabled. Not selectable. Adaptive.
#                     1 - 3 smooth pixels added.
#                     2 - 5 smooth pixels added.
#                     3 - 7 smooth pixels added.


# Int "diPP"         :  Blur amount applied to Interp/iTune area to hide artifacts (default: 5).
#                     Auto disabled if  Interp = 0  or InterpM != -1.
#                     (0 - Disabled. Max - 8).


# Int "diPPm"        :  Adds smooth borders to the iTune mask, used for "diPP" (default: 3).
#
#                     0 - Disabled.
#                     1 - 3 smooth pixels added.
#                     2 - 5 smooth pixels added.
#                     3 - 7 smooth pixels added.


# Int "oPP"         :  Blur amount applied to inpainted(opaque) area to calm it down (default: 5).
#                     (0 - Disabled. Max - 8).


# Int "oPPm"        :  Adds smooth borders to the opaque mask, used for "oPP" post-process,
#                     it will blend in an inpainted area into the surrounding.(default: 3).
#                     Auto-disabled if "oPP"=0.
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

# int "Show"        :  Show some masks and steps of the delogo process in "rSize".
#
#                     0 - Disabled (default).
#                     1 - Various masks and steps.
#                     2 - a) Stacked Delogoed + PostProcessed steps (can show "mShow").
#                         b) With a dynamic mask:
#                             Delogoed + Dynamic mask
#                             PostProcessed + Dynamic PP mask
#                     3 - Only for "DynMask=3". For fine tuning. Pre TrimergageFX(). No resizing.
#                     4 - Outputs the DynamicMask (Loc area). No resizing.
#                     5 - Outputs full sized Dynamic PP mask in Y8. No resizing.
#                     6 - Outputs the "DynMask3H" & "DynMask4H" mask. For fine tuning.
#
#                     # Analyze. Dev stuff:
#                     7 - Shows the constructed clip used to select frames for Analyze (whole clip with MinMax stats).
#                     8 - Same as 7, except that it shows the selected frames by AnalyzeTh.
#                     9 - Shows original selected frames with the real frame number from source clip. No resizing.
#
#                     # For DynMask=2/5/6/7:
#                    10 - Stacked: Original | Overlayed black | Mask
#                    11 - Overlayed black


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


# Int "rSize"       :  Resolution of "Show" & "Automask" output. (Default: 4)
#                     1 - Min (original resolution) to 9 - Max.


                 #============================#
                 #   Parameters for Inpaint:  #
                 #============================#

# Note              : Parameters below are useful only if you prefer speed over quality.


# Int "Turbo"       : "Inpaint" and "Both" presets for very fast, less "alive", blurred, low quality inpainting.
#                     On - will not try to connect isophotes/inpaint shapes of the surrounding.
#                     Going from 1 to 3 will amplify: obtrusive, less blurred, slower.
#
#                    0 - Off (Default). Slowest. High quality inpainting.
#                    1 - Fastest. For HD video - "2"/"3" should be more suitable imo.
#                    2 - Faster.
#                    3 - Fast.


# Int "KillShape"   :  Reduces sponginess of the base/dynamic mask when preserves dimensions of the shape.
#                     Experimental parameter meant for "Turbo", to make inpainted area less "alive".
#                     Will kill any hole up to 6 pixels in diameter.
#                     Works only in "Inpaint" mode. (Default: 0)
#                     0 - Off.
#                     1 - On.


# Int "prePP"       :  Pre blurs Loc area for inpainting algo. (Default: 0)
#                     Experimental parameter meant for "Turbo" when in "Inpaint" mode.
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


##================================================================================================##
#   SubsMask2Img()  manual:                                                                        #
##================================================================================================##


# NOTES             : The subs detection looks only at the middle of video (10% width x 60% height)!
#                     Mask clip is expected to be full range Y8 or it will be converted [but there is no conversion to full range].


# Int "Extract"     :  This is only InpaintDelogo() parameter!!!
#                     Makes stuff work in one go, but it's much slower that using an intermediate mask file.
#                     It will pass SubsMask2Img() parameters from InpaintDelogo() func to SubsMask2Img().
#                     When enabled the script will work till extraction is done, so use only after a dynamic mask is all set.
#
#                     Fast extraction:  InpaintDelogo() ->  encode the mask to a lossless file -> SubsMask2Img().
#                     Good lossless x264 settings for a mask: "--preset ultrafast --range pc --cabac -q0".
#
#                    0 - Off (Default).
#                    1 - Extracts subtitles, black and white binarized images.
#                    2 - Extracts subtitles, black and white binarized images and raw non-binarized images.


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
#                     Probably no need to touch it.


# Int "SubTune"     :  Post-blend binarization threshold [subtitle range to a single frame] (from 100 to 254; default: 235).
#                     Max = maximum artifacts reduction, if there are, but parts of the letters can disappear too.
#                     Probably no need to touch it.


# Int "SubMinDur"   :  Minimum subtitle duration threshold in frames (from 1 to 30; default = 12).
#                     Images with duration below this threshold won't be extracted.


# Int "SubSusDur"   :  Suspicious subtitle duration threshold in frames (from 0 to 60; default: 0).
#                     Extracted images with duration below or equal to this threshold will have "_" prefix in the filenames.
#                     Parameter is for fast examination/detection of possible non-sub images or wrong splits.
#                     Recommended setting: 3 frames lower than FPS of video.


# float "SubMinLuma":  Minimum average luma threshold for subtitle images (from 0 to 0.5; default = 0.5).
#                     Images with average luma below this threshold won't be extracted.
#                     Note: No need to touch it, unless you want to set it to 0.
#                     Note: Only the middle of frame is sampled.


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
#   Functions with all default parameters (for advanced users):                                            #
##================================================================================================##
/*

InpaintDelogo( mask="c:\test\mymask.bmp",
\ Automask=0, aMix=0, Loc="100,100,-100,-100", Mode="Inpaint",
\ Analyze=2, FrB=0, FrW=0, FrS=0, AnalyzeTh=30, NoBorderAt="none",
\ Inflate=1, Deep=3, ReAnalyze=0,
\ Interp=2, IntSpd=1, InterpM=0, iTune=0, iTinflate=0,
\ dPP=3, dPPm=3,
\ oPP=5, oPPm=3,
\ diPP=5, diPPm=3,
\ EdgePP=0, EdgePos=0, EdgeWide=1,
\ Turbo=0, prePP=0, KillShape=0, oTune=0, oTinflate=0,
\ DynMask=0, DynTune=200, DynTuneInf=0, DynInflate=0, maskPatch="",
\ DynColor=0, DynColorTol=10, DynColorInf=1,
\ DynTEdge=0, DynTEdgeThY=20, DynTEdgeInf=2,
\ KillBlobs=0, preBlobs=0, KillNoise=0, rePass=0,
\ Dyn3Seq=12, ClpBlend=10, DynPostTune=1, Dyn3buffer=0,
\ DynMask3H=0, ModeSH=1, TuneH1=0, TuneH2=0, TuneH3=0, KillNoiseH=0, rePassH=0,
\ DynMask4H=60, DynMaskUp=0, DynLocUp=1,
\ Extract=0,
\ GrainPP=0,
\ Sharpness=45, PreBlur=6.5, PostBlur=4.0, Radius=8.0,
\ Show=0, mShow=0, rSize=4)


SubsMask2Img( ImgDir="", CorrTh=0.8, SubTune=235, SubMinDur=12, SubSusDur=0,  SubMinLuma=0.5, SubSusLuma=0, ImgType="png", ImgInflate=0, ImgInvert=0, ImgSize=1, RawAvr=1 )

*/

##================================================================================================##
#   InpaintDelogo function:                                                                        #
##================================================================================================##


function InpaintDelogo ( clip clp, val "mask", string "Loc", string "Mode", int "Analyze",
\                        int "FrB", int "FrW", int "FrS", int "Interp", int "InterpM", int "Inflate",
\                        int "oTune", int "ReAnalyze", int "oPP", int "oPPm", int "dPPm", int "dPP",
\                        float "Radius", float "Sharpness", float "PreBlur", float"PostBlur",
\                        int "GrainPP", int "Automask", int "aMix", int "mShow", int "Show",
\                        int "Deep", int "rSize", int "prePP", int "KillShape", int "Turbo",
\                        int "iTune", int "iTinflate", int "oTinflate", int "diPPm", int "diPP",
\                        int "EdgePP", int"EdgePos", int"EdgeWide", int "IntSpd", int"DynMask",
\                        int "DynTune", int "DynInflate", int "KillNoise", string "maskPatch",
\                        int "ClpBlend", int "DynPostTune", int "Dyn3Seq", int "Dyn3buffer",
\                        int "KillBlobs", int "preBlobs", int "rePass",
\                        int "DynMask3H", int "ModeSH", int "TuneH1", int "TuneH2", int "TuneH3", int "rePassH", int "KillNoiseH",
\                        int "DynMask4H", int "DynMaskUp", int "DynLocUp",
\                        int "Extract", String "ImgDir", Float "CorrTh", Int "SubTune", Int "SubMinDur", Int "SubSusDur", Float "SubMinLuma", Float "SubSusLuma", String "ImgType", Int "ImgInflate", Int "ImgInvert", Int "ImgSize", Int "RawAvr",
\                        int "AnalyzeTh", String "NoBorderAt", float "AlphaTweak",
\                        int "DynColor", int "DynColorTol", int "DynColorInf",
\                        int "DynTEdge", int "DynTEdgeThY", int "DynTEdgeInf", int "DynTuneInf")

{

    # AVS+ version check           #
    # Error for standalone AVS+    #
    #==============================#

    Assert(IsVersionOrGreater(3,7,1), "Install Avisynth+ v3.7.1 or later.")

    dll_loaded     = true
    try{dll_loaded = FunctionExists("ImageWriter")}
    catch(dummy){}
    Assert(dll_loaded == true, "Load 'ImageSeq.dll' with 'LoadPlugin' or install Avisynth+.")


    # Defaults #
    #==========#


    mask        = default (mask      , ""  )
    maskPatch   = default (maskPatch , ""  )
    loc         = default (loc       , ""  )
    mode        = default (mode , "inpaint")
    analyze     = default (analyze     , 2 )
    deep        = default (deep        , 3 )
    FrB         = default (FrB         , 0 )
    FrW         = default (FrW         , 0 )
    frs         = default (frs         , 0 )
    interp      = default (interp      , 2 )
    interpm     = default (interpm     , 0 )
    dpp         = default (dpp         , 3 )
    dppm        = default (dppm        , 3 )
    dipp        = default (dipp        , 5 )
    dippm       = default (dippm       , 3 )
    oppm        = default (oppm        , 3 )
    turbo       = default (turbo       , 0 )
    dynmask     = default (dynmask     , 0 )
    dyntune     = default (dyntune   , 200 )
    dyninflate  = default (dyninflate  , 0 )
    grainpp     = default (grainpp     , 0 )
    opp         = default (opp         , 5 )
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
    rsize       = default (rsize       , 4 )
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
    AlphaTweak  = default (AlphaTweak  , 1 )
    DynColor    = default (DynColor    , 0 )
    DynColorTol = default (DynColorTol ,10 )
    DynColorInf = default (DynColorInf , 1 )
    DynTEdge    = default (DynTEdge    , 0 )
    DynTEdgeThY = default (DynTEdgeThY ,20 )
    DynTEdgeInf = default (DynTEdgeInf , 2 )
    DynTuneInf  = default (DynTuneInf  , 0 )

    Extract     = Default(Extract     ,    0)
    CorrTh      = Default(CorrTh      ,  0.8)
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
    Assert (!(Extract  < 0  || Extract  >  2), """"Extract" value must be between 0 and 2.""")

    AnalyzeTh   = (clp.FrameCount < 45000) ? default (AnalyzeTh, 30) :
    \                                        default (AnalyzeTh, 16)
    NoBorderAt  = default (NoBorderAt , "none")


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
    bugdpp      = (dpp          < 0 || dpp          >  8) ? true : false
    bugdipp     = (dipp         < 0 || dipp         >  8) ? true : false
    bugopp      = (opp          < 0 || opp          >  8) ? true : false
    bugprepp    = (prepp        < 0 || prepp        >  1) ? true : false
    bugdppm     = (dppm         < 1 || dppm         >  3) ? true : false
    bugdippm    = (dippm        < 0 || dippm        >  3) ? true : false
    bugoppm     = (oppm         < 0 || oppm         >  3) ? true : false
    bugdynmask  = (dynmask      < 0 || dynmask      >  7) ? true : false
    bugdyntune  = (dyntune      < 1 || dyntune     > 254) ? true : false
    bugdynflate = (dyninflate  < -1 || dyninflate   >  4) ? true : false
    buggrainpp  = (grainpp      < 0 || grainpp      >  3) ? true : false
    buginflate  = (inflate      < 0 || inflate      >  2) ? true : false
    bugiInflate = (iTinflate    < 0 || iTinflate    >  3) ? true : false
    bugoInflate = (oTinflate    < 0 || oTinflate    >  3) ? true : false
    bugotune    = (otune      < -10 || otune        >  5) ? true : false
    bugitune    = (itune      < -10 || itune       >  10) ? true : false
    bugamix     = (amix       < -50 || amix         >  5) ? true : false
    bugshow     = (show         < 0 || show         > 11) ? true : false
    bugmshow    = (mshow        < 0 || mshow        >  9) ? true : false
    bugrsize    = (rsize        < 1 || rsize        >  9) ? true : false
    bugautomask = (automask     < 0 || automask     >  1) ? true : false
    bugkillshape= (killshape    < 0 || killshape    >  1) ? true : false
    bugkillnoise= (killnoise   < -5 || killnoise    >  5) ? true : false
    bugkillblobs= (killblobs   < -7 || killblobs    >  7) ? true : false
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
    bugturbo    = (turbo        < 0 || turbo        >  3) ? true : false
    bugedgepp   = (edgepp       < 0 || edgepp       >  3) ? true : false
    bugedgepos  = (edgepos     < -1 || edgepos      >  1) ? true : false
    bugedgewide = (edgewide     < 0 || edgewide     >  3) ? true : false
    bugintspd   = (intspd       < 1 || intspd       >  3) ? true : false
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
    bugAlphaTweak  = (AlphaTweak < -3.0 || AlphaTweak     > 3.0) ? true : false
    bugDynColor    = (DynColor     < 0 || DynColor   > 16777215) ? true : false
    bugDynColorTol = (DynColorTol  < 1 || DynColorTol      > 80) ? true : false
    bugDynColorInf = (DynColorInf  < 0 || DynColorInf       > 4) ? true : false
    bugDynTEdge    = (DynTEdge     < 0 || DynTEdge          > 1) ? true : false
    bugDynTEdgeThY = (DynTEdgeThY  <10 || DynTEdgeThY     > 100) ? true : false
    bugDynTEdgeInf = (DynTEdgeInf  < 0 || DynTEdgeInf       > 8) ? true : false
    bugDynTuneInf  = (DynTuneInf  < -1 || DynTuneInf        > 4) ? true : false


    assert        ( IsString(mask) || IsClip(mask), """"mask" only accepts string/path or clip input.""")
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
    assert        ( bugdpp            == false  , """"dPP" value must be between 0 and 8.""")
    assert        ( bugdipp           == false  , """"diPP" value must be between 0 and 8.""")
    assert        ( bugopp            == false  , """"oPP" value must be between 0 and 8.""")
    assert        ( bugprepp          == false  , """"prePP" value must be between 0 and 1.""")
    assert        ( bugdppm           == false  , """"dPPm" value must be between 1 and 3.""")
    assert        ( bugdippm          == false  , """"diPPm" value must be between 0 and 3.""")
    assert        ( bugoppm           == false  , """"oPPm" value must be between 0 and 3.""")
    assert        ( bugdynmask        == false  , """"DynMask" value must be between 0 and 7.""")
    assert        ( bugdyntune        == false  , """"DynTune" value must be between 1 and 254.""")
    assert        ( bugdynflate       == false  , """"DynInflate" value must be between -1 and 4.""")
    assert        ( buggrainpp        == false  , """"GrainPP" value must be between 0 and 3.""")
    assert        ( buginflate        == false  , """"Inflate" value must be between 0 and 2.""")
    assert        ( bugiInflate       == false  , """"iTinflate" value must be between 0 and 3.""")
    assert        ( bugoInflate       == false  , """"oTinflate" value must be between 0 and 3.""")
    assert        ( bugotune          == false  , """"oTune" value must be between -10 and 5.""")
    assert        ( bugitune          == false  , """"iTune" value must be between -10 and 10.""")
    assert        ( bugamix           == false  , """"aMix" value must be between -50 and 5.""")
    assert        ( bugshow           == false  , """"Show" value must be between 0 and 11.""")
    assert        ( bugmshow          == false  , """"mShow" value must be between 0 and 8.""")
    assert        ( bugrsize          == false  , """"rSize" value must be between 1 and 9.""")
    assert        ( bugautomask       == false  , """"Automask" value must be between 0 and 1.""")
    assert        ( bugkillshape      == false  , """"KillShape" value must be between 0 and 1.""")
    assert        ( bugkillnoise      == false  , """"KillNoise" value must be between -5 and 5.""")
    assert        ( bugkillblobs      == false  , """"KillBlobs" value must be between -7 and 7.""")
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
    assert        ( bugturbo          == false  , """"Turbo" value must be between 0 and 3.""")
    assert        ( bugedgepp         == false  , """"EdgePP" value must be between 0 and 3.""")
    assert        ( bugedgepos        == false  , """"EdgePos" value must be between -1 and 1.""")
    assert        ( bugedgewide       == false  , """"EdgeWide" value must be between 0 and 3.""")
    assert        ( bugintspd         == false  , """"IntSpd" value must be between 1 and 3.""")
    (automask == 1) ? assert ( revstr(mask).findstr("pmb.") == 1 , """Try bmp extension for "mask".""") : nop
    assert        ( bugDyn3Seq        == false  , """"Dyn3Seq" is out of the optimal range.""")
    (ClpBlend != 0) ? assert        ( bugClpBlend == false  , """"ClpBlend" is out of range.""") : nop
    assert        ( bugDynPostTune    == false  , """"DynPostTune" value must be between 0 and 5.""")
    assert        ( bugDyn3buffer     == false  , """"Dyn3buffer" value must be between 0 and 1.""")
    assert        ( bugAlphaTweak     == false  , """"AlphaTweak" value must be between -3.0 and 3.0.""")
    assert        ( bugDynColor       == false  , """"DynColor" value must be between $000000 and $FFFFFF.""")
    assert        ( bugDynColorTol    == false  , """"DynColorTol" value must be between 1 and 80.""")
    assert        ( bugDynColorInf    == false  , """"DynColorInf" value must be between 0 and 4.""")
    assert        ( bugDynTEdge       == false  , """"DynTEdge" value must be between 0 and 1.""")
    assert        ( bugDynTEdgeThY    == false  , """"DynTEdgeThY" value must be between 10 and 100.""")
    assert        ( bugDynTEdgeInf    == false  , """"DynTEdgeInf" value must be between 0 and 8.""")
    assert        ( bugDynTuneInf     == false  , """"DynTuneInf" value must be between -1 and 4.""")


    # Settings #
    #==========#


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
    sSize       = float(rSize)
    sSize       = round(sSize/2.5)
    HD          = (x > 576) ? true : false
    matrixID    = (HD == true) ? "Rec709" : "Rec601"
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
    dppm        = (dpp     ==  0      && interp   < 1 ) ? 0 : dppm
    dippm       = (dipp    ==  0                      ) ? 0 : dippm
    oppm        = (opp     ==  0                      ) ? 0 : oppm
    prepp       = (prepp   !=  0                      ) ? 3 : prepp

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

    cm_bugcombo0  = (DynColor       == 0 && DynMask       == 5) ? true : false
    cm_bugcombo1  = (DynColor        > 0 && DynMask        < 2) ? true : false
    assert        ( cm_bugcombo0   == false   , """Nothing to do for "DynMask=5" if "DynColor=0".""")
    assert        ( cm_bugcombo1   == false   , """"DynColor" can be used only with internal "DynMask" methods.""")

    # DynMask=6 / DynTune:
    DynInflate    = (DynMask ==  6                    ) ? 0 : DynInflate

    # DynMask=7 / DynTEdge:
    DynInflate    = (DynMask ==  7                    ) ? 0 : DynInflate

    te_bugcombo0  = (DynTEdge       == 0 && DynMask       == 7) ? true : false
    te_bugcombo1  = (DynTEdge        > 0 && DynMask        < 2) ? true : false
    assert        ( te_bugcombo0   == false   , """Nothing to do for "DynMask=7" if "DynTEdge=0".""")
    assert        ( te_bugcombo1   == false   , """"DynTEdge" can be used only with internal "DynMask" methods.""")

    # "Turbo" presets:
    opp         = (turbo == 1 && mode == "inpaint" ) ? 7 :
    \             (turbo == 2 && mode == "inpaint" ) ? 7 :
    \             (turbo == 3 && mode == "inpaint" ) ? 6 :
    \             (turbo != 0 && mode == "both"    ) ? 6 : opp
#    killshape   = (turbo != 0 && mode == "inpaint" ) ? 1 : killshape
#    prepp       = (turbo != 0 && mode == "inpaint" ) ? 1 : prepp
    radius      = (turbo == 1                      ) ? 2 :
    \             (turbo == 2                      ) ? 4 :
    \             (turbo == 3                      ) ? 6 : radius
    sharpness   = (turbo != 0                      ) ? 0 : sharpness
    preblur     = (turbo != 0                      ) ? 0 : preblur
    postblur    = (turbo != 0                      ) ? 0 : postblur


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
    c           = int(value(leftstr(rightstr(loc,long-posvirg2),posvirg3-posvirg2-1)))
    d           = int(value(rightstr(loc,long-posvirg3)))

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

    inRGB24     = clpLoc.ConvertToRGB24(matrix=matrixID)
    inRGB32     = clpLoc.ConvertToRGB32(matrix=matrixID)
    inYV12      = clpLoc.ConvertToYV12(matrix=matrixID)

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

    bugcombo98  = (dynmask == 1 && mode != "inpaint") ? true : false
    assert        (bugcombo98 == false, """"mask" as a dynamic mask works only in "Inpaint" mode.""")
    bugcombo99  = (dynmask == 1 && maskdynamic == false) ? true : false
    assert        (bugcombo99 == false, """"mask" is not a dynamic mask.""")
    bugcombo97  = (dynmask == 0 && maskdynamic == true) ? true : false
    assert        (bugcombo97 == false,  """"mask" is a dynamic mask when expected a static mask.""")
    bugcombo96  = (show == 3 && dynmask != 3) ? true : false
    assert        (bugcombo96 == false,  """"Show=3" is only for the "DynMask=3".""")
    bugcombo95  = (show == 4 && dynmask == 0) ? true : false
    assert        (bugcombo95 == false,  """"Show=4" is only for the dynamic masks.""")
    bugcombo94  = (show == 5 && dynmask == 0) ? true : false
    assert        (bugcombo95 == false,  """"Show=5" is only for the dynamic masks.""")

    Clipmask    = (maskClip == true) ? eval("""
                  Clipmask = (maskdynamic == true) ? mask.ConvertToY8(matrix="PC.709") : mask.ConvertToRGB32
                  return Clipmask """) : nop


    # LogoID #
    #========#


    MskName     = (IsString(mask)) ? mask : "Clip"
    MskName     = (mode == "inpaint") ? "Dummy" : MskName

    CoordsID    = string(a)+"-"+string(b)+"-"+string(abs(c))+"-"+string(abs(d))

    if(analyze == 3) {
        LogoID = MskName+"_InpaintDelogo2_"+CoordsID+"_A"+string(Analyze)
    } else if(analyze > 0) {
        LogoID = MskName+"_InpaintDelogo2_"+CoordsID+"_A"+string(Analyze)+"-"+string(AnalyzeTh)
    } else if(analyze == -1 || analyze == -2 ) {
        LogoID = MskName+"_InpaintDelogo2_"+CoordsID+"_A"+string(Analyze)+"-"+string(AnalyzeTh)+"_Deep1"
    } else {
        LogoID = MskName+"_InpaintDelogo2_"+CoordsID+"_A"+string(Analyze)+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs)+"_Deep1"
    }


    # Creation of the base mask. #
    #============================#


    DummyMsk    = blankblk.Subtitle("Dummy", text_color=color_white, align=5)

    Imgmask     = (Automask == 1                            ) ? DummyMsk :
    \             (dynmask  == 2 && mode == "both"          ) ? ImageSource(mask,0,0).Greyscale.ConvertToRGB32.Crop(a,b,c,d).Levels(127,1,128,0,255) :
    \             (dynmask   > 1                            ) ? DummyMsk :
    \             (maskClip == false                        ) ? ImageSource(mask,0,0).Greyscale.ConvertToRGB32.Crop(a,b,c,d).Levels(127,1,128,0,255) :
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
        wAutoClp  = (Loc == "0,0,-0,-0" || Loc == "0,0,0,0") ? BlankClip(clp,color=$FFFFFF,length=1).ConvertToRGB24.Crop(1,1,-1,-1) :
        \                                                      BlankClip(clp,color=$FFFFFF,length=1).ConvertToRGB24.Crop(a,b,c,d)
        aMerge    = (Loc == "0,0,-0,-0" || Loc == "0,0,0,0") ? bAutoClp.Overlay(wAutoClp,x=a+1,y=b+1).ConvertToRGB32 :
        \                                                      bAutoClp.Overlay(wAutoClp,x=a,y=b).ConvertToRGB32
        aMerge    = (Loc == "0,0,-0,-0" || Loc == "0,0,0,0") ? aMerge.ConvertToY8(matrix="PC.709").MTballoon2PX(-6).ConvertToRGB32(matrix="PC.709") :
        \                                                      aMerge.ConvertToY8(matrix="PC.709").MTballoon2PX(-7).ConvertToRGB32(matrix="PC.709")
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


    if(automask == 0) {
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
                YYY.AnalyzeLogo(mask=BasemaskY).Trim(0,-1)
                ScanY = last
                UUU.AnalyzeLogo(mask=BasemaskUV).Trim(0,-1)
                ScanU = last
                VVV.AnalyzeLogo(mask=BasemaskUV).Trim(0,-1)
                ScanV = last
                ScanUV = StackVertical(ScanU,ScanV)
                StackHorizontal(ScanY,ScanUV)
                ImageWriter(LogoID +"%.0d.ebmp",0,1,"ebmp").RT_YankChain(n=0)
                Logo = last
            }
        } else {
            if(reanalyze == 0 && Exist(LogoID +".ebmp")) {
                Logo = ImageSource(LogoID + "%.0d.ebmp",0,0)
            } else {
                if(Analyze == 0 || Analyze < -2) {
                    inRGB24.AnalyzeMethods(Analyze, blankwht=blankwht, FrB=FrB, FrW=FrW, FrS=FrS, frx=frx)
                } else if(Analyze == -1 || Analyze == -2) {
                    if(reanalyze == 1) {
                        RT_FileDelete(LogoID +".txt")
                    }
                    inRGB24.AnalyzeMethods(Analyze, mask=BasemaskP, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID)
                }
                last.Analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                ImageWriter(LogoID +"%.0d.ebmp",0,-1,"ebmp").RT_YankChain(n=0)
                Logo = last
            }
        }
    }


    # Have you weared your mask today? #
    #==================================#


    if(automask == 0) {
        InterpMask  = Basemask.balloonPX(interpmInfl)

        if(analyze > 0) {
            LogoColorY  = Logo.Crop(0,0,Logo.width/3*2,0).Crop(0,0,0,Logo.Height/2)
            LogoAlphaY  = Logo.Crop(0,0,Logo.Width/3*2,0).Crop(0,Logo.Height/2,0,0).Tweak(bright=AlphaTweak,coring=false)
            LogoColorU  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,0,0,Logo.Height/2).Crop(0,0,0,Logo.Height/4)
            LogoAlphaU  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,0,0,Logo.Height/2).Crop(0,Logo.Height/4,0,0)
            LogoColorV  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,Logo.Height/2,0,0).Crop(0,0,0,Logo.Height/4)
            LogoAlphaV  = Logo.Crop(Logo.Width/3*2,0,0,0).Crop(0,Logo.Height/2,0,0).Crop(0,Logo.Height/4,0,0)

            LogoColor   = CombinePlanes(LogoColorY, LogoColorU, LogoColorV, planes="YUV", source_planes="YYY", pixel_type="YV12").ConvertToRGB24(Matrix="Rec601") # just for Show
            LogoAlpha   = LogoAlphaY.ConvertToRGB32(Matrix="Rec601").Mask(LogoAlphaY.ConvertToRGB32(Matrix="Rec601"))
        } else {
            LogoColor   = Logo.Crop(0,0,0,Logo.Height/2).ConvertToRGB24
            LogoAlpha   = Logo.Crop(0,Logo.Height/2,0,0)
            LogoAlpha   = LogoAlpha.Mask(LogoAlpha)
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
            OutY        = inYV12Y.DeblendLogo(LogoColorY,  LogoAlphaY)
            OutU        = inYV12U.DeblendLogo(LogoColorU,  LogoAlphaU)
            OutV        = inYV12V.DeblendLogo(LogoColorV,  LogoAlphaV)
            LogoDeblPre = CombinePlanes(OutY, OutU, OutV, planes="YUV", source_planes="YYY", pixel_type="YV12")
        } else {
            if(deep != 1) {
                LogoDeblPre = inRGB24.MultiPassDeblendFX(Basemask,blankwht,a,b,c,d,MskName,Deep,FrB,FrW,frs,frx,BasemaskP,Analyze,Reanalyze,AnalyzeTh,NoBorderAt,LogoID,0).ConvertToYV12(matrix=matrixID)
            } else {
                LogoDeblPre = inRGB24.DeblendLogo(Logocolor,LogoAlpha).ConvertToYV12(matrix=matrixID)
            }
        }
        LogoInpaPre = (interpm == -1 && intspd == 1) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=2) :
        \             (interpm == -1 && intspd == 2) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=6) :
        \             (interpm == -1 && intspd == 3) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur=4,radius=8) :
        \             (                 intspd == 1) ? inYV12     .InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=2) :
        \             (                 intspd == 2) ? inYV12     .InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=6) :
        \             (                 intspd == 3) ? inYV12     .InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur=4,radius=8) : nop

        LogoDeblend = (interp != 0 ) ? LogoInpaPre.Overlay(LogoDeblPre, opacity=interp) :
        \                              LogoDeblPre
    }

    # DynTune  / DynMask6
    lvl_mask    = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 5 && DynMask != 7) ? eval("""
                  lvl_mask = inY8.mt_binarize(threshold=DynTune).MTballoonPX(DynTuneInf)
                  return lvl_mask """) : nop

    # DynColor / DynMask5
    col_mask    = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynColor > 0 && DynMask != 6 && DynMask != 7) ? eval("""
                  col_mask = inYV12a.ConvertToRGB32(matrix=matrixID).ColorKeyMask(DynColor, DynColorTol).ShowAlpha(Pixel_Type="Y8").invert.MTballoon2PX(DynColorInf)
                  return col_mask """) : nop

    # DynTEdge / DynMask7
    # "vsTEdgeMask(threshY=20.0, type=1, link=0)" result is almost same as "vsTCanny(sigmaY=0, mode=1, op=0).mt_binarize(40)" but ~twice faster
    tedge_mask  = (automask == 0 && mode == "inpaint" && DynMask > 1 && DynTEdge == 1 && DynMask != 5 && DynMask != 6) ? eval("""
                  tedge_mask = (DynTEdgeInf == 0) ? inY8.vsTEdgeMask (threshY=DynTEdgeThY, type=1, link=0) :
                  \                                 inY8.vsTEdgeMask (threshY=DynTEdgeThY, type=1, link=0).MTballoon2PX(DynTEdgeInf).mt_expand.mt_inpand
                  return tedge_mask """) : nop

    # Combo mask
    if (automask == 0 && mode == "inpaint" && DynMask > 1 && DynMask != 5 && DynMask != 6 && DynMask != 7) {
        if (DynColor > 0 && DynTEdge == 1) {
            combo_mask =   lvl_mask.mt_logic(  col_mask, mode="and")
            combo_mask = combo_mask.mt_logic(tedge_mask, mode="and")
        } else if (DynColor == 0 && DynTEdge == 1) {
            combo_mask =   lvl_mask.mt_logic(tedge_mask, mode="and")
        } else if (DynColor  > 0 && DynTEdge == 0) {
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
                  DynamicMask = (DynInflate != 0) ? DynamicMask.MTballoonPX(dyninflate) : DynamicMask
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


    LogoInpaint = (automask == 0 && mode == "inpaint" && Show < 3) ? eval("""
                  LogoInpaint = (DynMask != 0) ? inYV12.ppFX(prePP).InpaintLogo(DynamicMask, radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur) :
                  \                              inYV12.ppFX(prePP).InpaintLogo(OpaqueMask , radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur)
                  return LogoInpaint """) : nop


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
                  delogopp3 = (mode == "inpaint"            ) ? inYV12.Overlay(delogo   .ppFX(opp), Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \           (mode != "inpaint" && dPP != 0) ? inYV12.Overlay(delogopp2.ppFX(dpp), Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm != 0         && dPP == 0) ? inYV12.Overlay(delogopp2,           Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm == 0         && dPP == 0) ? inYV12.Overlay(delogopp2,           Mask=Basemask.  ConvertToY8(matrix="PC.709")) : nop
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
        w = int(rsize*width(last))
        h = int(rsize*height(last))
        PointResize(last,w,h)
        Autoalpha = Autoalpha.Spline16Resize(w,h)
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

        (rSize >= 4) ? Spline16Resize(last,sSize*width(last),sSize*height(last)):
        \              last.ConvertToRGB24

    } else if(show == 2) { # "Show" 2

        a1 = (DynMask != 0) ? StackVertical (delogo, helper) : nop
        a2 = (DynMask != 0) ? StackVertical (DynamicMask.ConvertToY8.ConvertToYV12, InpaintMpp.ConvertToY8.ConvertToYV12) : nop
        (DynMask != 0) ? StackHorizontal(a1, a2) :
        \                StackVertical(delogo, helper)
        w = int(rsize*width(last))
        h = int(rsize*height(last))
        Spline16Resize(last,w,h)

    } else if(show == 3) { # "Show" 3

        DynamicMsk3

    } else if(show == 4) { # "Show" 4

        (Extract == 0) ? DynamicMask :
      \ (Extract == 1) ? DynamicMask.SubsMask2Img(ImgDir=ImgDir, CorrTh=CorrTh, SubTune=SubTune, SubMinDur=SubMinDur, SubSusDur=SubSusDur, SubMinLuma=SubMinLuma, SubSusLuma=SubSusLuma, ImgType=ImgType, ImgInflate=ImgInflate, ImgInvert=ImgInvert, ImgSize=ImgSize, RawAvr=RawAvr) :
      \ (Extract == 2) ? DynamicMask.SubsMask2Img(ImgDir=ImgDir, CorrTh=CorrTh, SubTune=SubTune, SubMinDur=SubMinDur, SubSusDur=SubSusDur, SubMinLuma=SubMinLuma, SubSusLuma=SubSusLuma, ImgType=ImgType, ImgInflate=ImgInflate, ImgInvert=ImgInvert, ImgSize=ImgSize, RawAvr=RawAvr, Raw=inYV12) : nop

    } else if(show == 5) { # "Show" 5

        BlackClip = BlankClip(clp, Color_yuv=$000000, pixel_type="Y8")
        show5 = InpaintMpp.ConvertToY8
        show5out = (Loc == "-0,-0,-0,-0" || Loc == "0,0,-0,-0") ? show5 : BlackClip.Overlay(show5,x=a,y=b)
        show5out

    } else if(show == 6) { # "Show" 6

        (DynMask == 4) ? DynamicMsk4 : dMsk3Halo

    } else if(show == 7) { # "Show" 7

        (Analyze ==  1) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=3) :
      \ (Analyze ==  2) ? inYV12 .AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=3) :
      \ (Analyze == -1) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, mask=BasemaskP,        FramesLog=LogoID, Show=3) :
      \ (Analyze == -2) ? inRGB24.AnalyzeMethods(Analyze, AnalyzeTh=AnalyzeTh, NoBorderAt=NoBorderAt, FramesLog=LogoID, Show=3) : nop
        w = int(rsize*width(last))
        h = int(rsize*height(last))
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
        w = int(rsize*width(last))
        h = int(rsize*height(last))
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

    } else { # FinalOut

        finalout = (Loc == "-0,-0,-0,-0" || Loc == "0,0,-0,-0") ? helper : clp.Overlay(helper,x=a,y=b)
        finalout
    }
}


##================================================================================================##
#   MultiPassDeblendFX:                                                                            #
##================================================================================================##


function MultiPassDeblendFX(clip inRGB24, clip Basemask, clip blankwht, int a, int b, int c, int d, string MskName, int Deep, int FrB, int FrW, int frS, int frx, clip BasemaskP, int Analyze, int Reanalyze, int AnalyzeTh, string NoBorderAt, string LogoID, int Pass) {
    Pass = Pass +1

    if(analyze == -1 || analyze == -2) {
        DeepID = MskName+"_InpaintDelogo2_"+string(a)+"-"+string(b)+"-"+string(abs(c))+"-"+string(abs(d))+"_A"+string(Analyze)+"-"+string(AnalyzeTh)+"_Deep"+string(Pass)
    } else {
        DeepID = MskName+"_InpaintDelogo2_"+string(a)+"-"+string(b)+"-"+string(abs(c))+"-"+string(abs(d))+"_A"+string(Analyze)+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs)+"_Deep"+string(Pass)
    }
    ACmaskfile = DeepID + ".ebmp"

    if(Reanalyze == 0 && Exist(ACmaskfile)) {
        ImageSource(DeepID + "%.0d.ebmp",0,0)
        LogoColor = Crop(0,0,0,last.Height/2).ConvertToRGB24
        LogoAlpha = Crop(0,last.Height/2,0,0)
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
        ImageWriter(DeepID + "%.0d.ebmp",0,-1,"ebmp").RT_YankChain(n=0)
        LogoColor = Crop(0,0,0,last.Height/2).ConvertToRGB24
        LogoAlpha = Crop(0,last.Height/2,0,0)
        LogoAlpha = LogoAlpha.Mask(LogoAlpha)
        inRGB24.DeblendLogo(LogoColor, LogoAlpha)
    }
    out  = (Pass == Deep) ? Last : MultiPassDeblendFX(Last,Basemask,blankwht,a,b,c,d,MskName,Deep,FrB,FrW,frS,frx,BasemaskP,Analyze,Reanalyze,AnalyzeTh,NoBorderAt,LogoID, Pass)
    return out
}


##================================================================================================##
#   AnalyzeMethods:                                                                                #
##================================================================================================##


Function VFX2(clip mask, string Analyze5DB) {
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
            Parse = mask.ScriptClip("VFX2("+args+")", local=true, args=ARGS, after_frame=true)
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

            # Construct a clip to check thresholds (for Automask=1) #
            #=======================================================#

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

    out = (analyze == -3 || analyze == -4 || analyze == 0) ? method : res
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

    px1m =  clp.mt_inpand(mode="square", chroma="none")
    px2m = px1m.mt_inpand(mode="square", chroma="none")
    px3m = px2m.mt_inpand(mode="square", chroma="none")
    px4m = px3m.mt_inpand(mode="square", chroma="none")
    px5m = px4m.mt_inpand(mode="square", chroma="none")
    px6m = px5m.mt_inpand(mode="square", chroma="none")
    px7m = px6m.mt_inpand(mode="square", chroma="none")
    px8m = px7m.mt_inpand(mode="square", chroma="none")

    balloon = (mode ==  0) ? clp  :
    \         (mode ==  1) ? px1  :
    \         (mode ==  2) ? px2  :
    \         (mode ==  3) ? px3  :
    \         (mode ==  4) ? px4  :
    \         (mode ==  5) ? px5  :
    \         (mode ==  6) ? px6  :
    \         (mode ==  7) ? px7  :
    \         (mode ==  8) ? px8  :
    \         (mode == -1) ? px1m :
    \         (mode == -2) ? px2m :
    \         (mode == -3) ? px3m :
    \         (mode == -4) ? px4m :
    \         (mode == -5) ? px5m :
    \         (mode == -6) ? px6m :
    \         (mode == -7) ? px7m :
    \         (mode == -8) ? px8m : nop
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

    in = (mode  < 1) ? clp  :
    \    (mode == 1) ? mpx1 :
    \    (mode == 2) ? mpx2 :
    \    (mode == 3) ? mpx3 :
    \    (mode == 4) ? mpx4 :
    \    (mode == 5) ? mpx5 :
    \    (mode == 6) ? mpx6 :
    \    (mode == 7) ? mpx7 : nop

    px1 = in .mt_expand(mode="square", chroma="none")
    px2 = px1.mt_expand(mode="square", chroma="none")
    px3 = px2.mt_expand(mode="square", chroma="none")
    px4 = px3.mt_expand(mode="square", chroma="none")
    px5 = px4.mt_expand(mode="square", chroma="none")
    px6 = px5.mt_expand(mode="square", chroma="none")
    px7 = px6.mt_expand(mode="square", chroma="none")

    hx1 = mpx1.mt_hysteresis(clp, corners=false)
    hx2 = mpx2.mt_hysteresis(clp, corners=false)
    hx3 = mpx3.mt_hysteresis(clp, corners=false)
    hx4 = mpx4.mt_hysteresis(clp, corners=false)
    hx5 = mpx5.mt_hysteresis(clp, corners=false)
    hx6 = mpx6.mt_hysteresis(clp, corners=false)
    hx7 = mpx7.mt_hysteresis(clp, corners=false)

    msk = (mode ==  0) ? clp :
    \     (mode == -1) ? hx1 :
    \     (mode == -2) ? hx2 :
    \     (mode == -3) ? hx3 :
    \     (mode == -4) ? hx4 :
    \     (mode == -5) ? hx5 :
    \     (mode == -6) ? hx6 :
    \     (mode == -7) ? hx7 :
    \     (mode ==  1) ? px1 :
    \     (mode ==  2) ? px2 :
    \     (mode ==  3) ? px3 :
    \     (mode ==  4) ? px4 :
    \     (mode ==  5) ? px5 :
    \     (mode ==  6) ? px6 :
    \     (mode ==  7) ? px7 : nop

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


function ppFX(clip clp, int "mode") {
    mode        = default (mode, 0)

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
    return pp
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


Function VFX1(clip c, string FrameDB, int CropW, int CropH) {
        c
        n = current_frame
        Status = RT_DBaseGetField(FrameDB,n,0)
        if(Status == 0) {  # Unknown Status
            Status = crop(CropW,CropH,-1*CropW,-1*CropH).AverageLuma.Sign
            if(Status == 1) { RT_DBaseSet(FrameDB,n,Status) }
        }
        Return Last
}

# Mod of StainlessS's 'DetSub_Extract.avs' - https://forum.doom9.org/showthread.php?p=1950193
Function SubsMask2Img(clip clp, clip "Raw", String "ImgDir", Float "CorrTh", Int "SubTune", Int "SubMinDur", Int "SubSusDur", Float "SubMinLuma", Float "SubSusLuma",
\                     String "ImgType", Int "ImgInflate", Int "ImgInvert", Int "ImgSize", Int "RawAvr")

{
    StartTime   = TimerFX()
    CorrTh      = Default(CorrTh      ,  0.8)
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

    Assert (!(CorrTh      <   0.5 || CorrTh      >  0.95), """"CorrTh" value must be between 0.5 and 0.95.""")
    Assert (!(SubTune     <   100 || SubTune     >   254), """"SubTune" value must be between 200 and 254.""")
    Assert (!(SubMinDur   <     1 || SubMinDur   >    30), """"SubMinDur" value must be between 1 and 20.""")
    Assert (!(SubSusDur   <     0 || SubSusDur   >    60), """"SubSusDur" value must be between 0 and 40.""")
    Assert (!(SubMinLuma  <     0 || SubMinLuma  >   0.5), """"SubMinLuma" value must be between 0 and 0.5.""")
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
    CropW   = int((VW / 2) *0.90)
    CropH   = int((VH / 2) *0.40)
    inY8    = clp.ConvertToY8()


    # Detect if sub is on individual frames, and write FrameDB: #
    #===========================================================#

    RT_DBaseAlloc(FrameDB,FC,"i")
    ARGS="FrameDB,CropW,CropH"
    Parse = inY8.ScriptClip("VFX1("+args+")", local=true, args=ARGS, after_frame=true)
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
            avgL  = One0.crop(CropW,CropH,-1*CropW,-1*CropH).mt_binarize(254).AverageLuma
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
              avgL  = One0.crop(CropW,CropH,-1*CropW,-1*CropH).mt_binarize(254).AverageLuma
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

