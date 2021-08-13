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

#  Inpainting refers to the application of sophisticated algorithms to reconstruct of lost
# or deteriorated parts of images or videos.


##================================================================================================##
#   Version: 1.29                                                                                  #
##================================================================================================##


# Author       : VoodooFX

# Link         : https://forum.doom9.org/showthread.php?p=1883832

# Version 1.11 : 2019/08/31.  First public release.
# Version 1.12 : 2019/09/06.  Various tweaks. New parameters. "Inflate" and "Deep" changed.
# Version 1.13 : 2019/12/08.  Allow -ve LogoX,LogoY, and +ve LogoW,LogoH in Loc string (by StainlessS).
# Version 1.14 : [non public] "Fr1"/"Fr2" are renamed to "FrB"/"FrW". "GrainPP" is off by default.
# Version 1.15 : [non public] New mode for "InterpM", (-1) takes mask from new "iTune" parameter.
# Version 1.16 : [non public] New "diPP" & "diPPm" parameters.
# Version 1.17 : [non public] New "iTinflate" & "oTinflate" parameters. Interp/iTune mask to "mShow".
# Version 1.18 : [non public] New "EdgePP", "EdgePos" & "EdgeWide" parameters. EdgeMask to "mShow".
# Version 1.19 : [non public] New "IntSpd" parameter for "Interp" & the slow modes for "EdgePP".
# Version 1.20 : [non public] "Turbo" presets moved from soft to hard. iTune & Edge masks to "Show".
# Version 1.21 : [non public] Added support for the mask clips and a dynamic mask.
#                             Added basic auto generation of a dynamic mask (aka "DynMask=2").
#                             New parameters: "DynMask", "DynInflate", "DynTune", "KillNoise", "maskPatch".
# Version 1.22 : [non public] Optimized speed for a dynamic mask, MaskTools2 required.
# Version 1.23 : [non public] Added auto generation of a dynamic mask with ClipBlend (aka "DynMask=3").
#                             New parameters: "Dyn3Seq", "ClpBlend", "DynPostTune", "Dyn3buffer".
# Version 1.24 : 2020/11/28.  Various tweaks. "Show" 3 & 4. Updated the manual with the new stuff.
# Version 1.25 : 2021/08/13.  Fixed/expanded "DynTune".
# Version 1.26 : 2021/08/13.  "DynInflate" up to 4px.
# Version 1.27 : 2021/08/13.  "Show" 5 outputs full size Dynamic PP mask.
# Version 1.28 : 2021/08/13.  Changed "Dyn3Seq" & "ClpBlend" range limit. "Interp" 4.
# Version 1.29 : 2021/08/13.  "mShow" 9.


##================================================================================================##
#   Requirements :                                                                                 #
##================================================================================================##


# Requirements   : Avisynth+ ( https://github.com/AviSynth/AviSynthPlus ) or Avisynth v2.6.
#                  AvsInpaint ( https://github.com/pinterf/AvsInpaint ).
#
# Optional requirements:
#                : GrainFactory3 (for "GrainPP", http://avisynth.nl/index.php/GrainFactory3 ).
#                : MaskTools2    (for "DynMask>0", https://github.com/pinterf/masktools ).
#                : ClipBlend     (for "DynMask=3", http://avisynth.nl/index.php/ClipBlend ).
#                : RequestLinear (for "DynMask=3", http://avisynth.nl/index.php/TIVTC ).


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
#   InpaintDelogo() manual:                                                                        #
##================================================================================================##


                 #=========================#
                 #    Short basic guide:   #
                 #=========================#

#     ( Things you need before starting InpaintDelogo() )
#
# 0)  Read help/manual(in script) about parameters mentioned below.
# 1)  Run this function to get "Loc" values: InpaintLoc(Loc="100,100,-100,-100") .
#     Adjust "Loc" crop parameters around logo (aka "Left,Top,-Right,-Bottom").
#     Use even(mod2) numbers.
# 2)  Get frames numbers for manual "Analyze" (you can skip it for slower & lower quality job).
# 3)  Prepare the "mask" manually, or start the function with "Automask=1".
# 4)  Now you can add this stuff from above to InpaintDelogo() function and run it.

#  Basic example:
/*

InpaintDelogo( mask="c:\test\mymask.bmp",
\ Automask=0, aMix=0, Loc="100,100,-100,-100",
\ Mode="Inpaint",
\ Analyze=1, FrB=0, FrW=0, FrS=0)

*/

                 #=================#
                 #   Parameters:   #
                 #=================#

# String "Loc"      :  Use InpaintLoc() function to find coordinates.
#                     Spaces are not allowed in "Loc" parameter.
#                     Use even(mod2) numbers.
#                     Include 10(no less) - ~16 pixel borders around logo!


# val "mask"        : File based mask:
#                     Full path to the base mask of the logo, a B/W picture (Logo -> white).
#                     Example: mask="C:\mymask.bmp".
#                     Resolution of the image must be same as video clip's frame.
#                     Don't include surrounding bleed of the logo, just exact logo.
#                      Actually script is not strict about a format of the picture, it will
#                     convert whatever you give to a Black/White mask.
#                      You can use "Automask" option to auto-generate the base mask.
#
#                      Clip based mask:
#                      "mask" accepts clip input, resolution must be same as "Loc" area.
#                      Dynamic mask expected to be full range YV12 with a mask in Y.
#                      Static mask must be one frame clip otherwise it will be treated as a dynamic mask.


# Int "Automask"    :  It's like a different function when On, just generates the base mask
#                     of the logo, then you need to turn it off.
#                     "Analyze" (and its sub-parameters, except "ReAnalyze"), "aMix", "mask" and
#                     "Loc" parameters will be used.
#                     "Loc" would be best 10(no less) pixels from the logo edges.
#                     Needs "mask" defined with path to imaginary bmp picture, that's where
#                     the base mask will be generated.
#                     Will re-analyze on every script load. Best & fast results are with "Analyze" method "3".
#                     In most cases "Analyze" method "4" will be good, and it's fastest to setup.
#
#                     0 - Off (default).
#                     1 - On. Generates the base mask. Script doesn't do anything else when "On"!


# Int "aMix"        :  Parameter is only for "Automask=1" (from -5 to 5; default: 0).
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


# Int "Analyze"     :  Analyze methods for deblend/transparent logo ("Deblend" & "Both" modes).
#                     It creates Color & Alpha masks for deblending, filename will be unique with
#                     every "Analyze" setting in the filename.
#                     When "Automask=1" it creates the base mask, nothing else.
#                     Do "Analyze" and delogo only on frames with logo present!!! No animations too.
#
#                     (Adaptive default: 0 - forced for "Inpaint" mode; 1 - for other modes)
#
#                     0 -  "Disabled". Not selectable.
#
#                     1 -  Fast auto analysis (3% of all frames). In practice auto analysis doesn't
#                          produce good results as not all the frames are good for analysis.
#
#                     2 -  Slow auto analysis (all frames). More is not better... Placebo.
#
#                     3 -  Manual analysis. This method is the best.
#                         You need one frame where logo area is in a solid black/dark background and
#                         another one in a solid white/bright background.
#                         These two frames must be set with "FrB" & "FrW" parameters and optional "FrS".
#
#                     4 -   Manual analysis. Good (in most cases) for the basemask generation with "Automask".
#                          For delogo not good, use only if there is no white/bright frame in video and
#                          method "1" is worse. Will not deblend colored parts of the logo.
#                          Setup is similar as method "3", just without "FrW" (it will be ignored).


# Int "ReAnalyze"   :  Repeats analysis on every script load. (default: 0)
#
#                     0 - Off. logo analysis is not computed if Color/Alpha masks are present.
#                     1 - On. Logo analysis is always computed even when C/A masks are present.


# Int "Deep"        :  Multi pass deblending and analyze is activated with this option.
#                     Reduce discoloration artifacts, less logo remnants.
#                     Less transparent logo - bigger effect, sometimes no effect at all.
#
#                     0 - Disabled.
#                     1 - 2-pass.
#                     2 - 3-pass (default).
#                     3 - 4-pass.
#                     4 - 5-pass.


# Int "FrB"        : Frame number of the black/dark frame for manual "Analyze" (default: 0).


# Int "FrW"        : Frame number of the white/bright frame for manual "Analyze" (default: 0).


# Int "FrS"        :  Extended sequences of the frames for manual "Analyze" (default: 0).
#                     ( 0 - disabled; 1 - 5 frames; 2 - 10 frames; 3 - 30 frames.)
#                     Sequences starts from "FrB" and "FrW" frames.
#                     More frames = better analysis = better delogo.
#                     Be sure that the logo in the sequences still will be in the same/static solid
#                     dark/bright background.


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


# Int "iTune"       :  Creates a mask for "Interp"/"InterpM". (from -4 to 4; default: 0).
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


# Int "oTune"       :  Creation of the mask for "Both" mode. (from -4 to 4; default: 0).
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
#                     (Adaptive default: 0 or 1, depends from "mask".)
#
#                    0 - Off - No dynamic mask. Auto-adaptive.
#
#                    1 - External dynamic mask, defined by "mask". Auto-adaptive. Only for "Inpaint".
#
#                    2 - Auto generation of the dynamic mask, based on brightness. For "Inpaint" & "Both".
#                        Useful only if a dynamic logo is brighter than the rest of the video.
#
#                    3 - Auto generation of the dynamic mask, using ClipBlend. Only for "Inpaint".
#                        Useful when brightness of a logo is similar to the rest of video and non-animated Logo periodically
#                        jumps location, logo must stay at the location for consistent periods of time (set by "Dyn3Seq").
#                        ClipBlend is controled by "ClpBlend".
#                        This mask generation must be done in a single thread - no MT! Source filter must be frame accurate!
#
#                        For fine tuning use "Show=3" mode as in it only steps mentioned below are processed:
#                        Internal succession: Clip > "Loc" > "DynTune" > "ClpBlend" > "DynPostTune" >...
#                        Start looking at the ~last frame with logo in a location before adjusting things in "Show=3",
#                        because at other places a logo mask should/may disappear (down the chain those are merged in).
#                        Read about "Dyn3buffer" and parameters mentioned above!


# Int "DynInflate"  :  Inflates the dynamic mask.
#
#                     0 - Disabled  (default).
#                     1 - Inflate by 1 pixel.
#                     2 - Inflate by 2 pixels.
#                     3 - Inflate by 3 pixels.
#                     4 - Inflate by 4 pixels.


# Int "DynTune"     :  Tunes up a dynamic mask for "DynMask=2 & 3". Binarization threshold. (from -10 to 10; default: 0).
#                     Higher values -> mask expands more into the darker areas of video. (0=200, increments by -5/5)


# String "maskPatch":  Full path to a patch image, a B/W picture in size of a "loc" area.
#                     Patches a dynamic mask with a custom static mask. Applies after "DynInflate".


# Int "KillNoise"   :  The 2px thick white areas will be eliminated from the dynamic mask.
#                     Experimental parameter, doesn't do anything good.
#                     0 - Disabled  (default).
#                     1 - Enabled.


                 #   DynMask=3:   #
                 #================#

# Int "Dyn3Seq"     :  Parameter for "DynMask=3".  (from 10 to 9999)
#                     Sets how many frames the logo is in a location.
#                     For subtitles set duration of the shortest subtitle.


# Int "ClpBlend"    :  Parameter for "DynMask=3".
#                     Sets how many frames will be blended to help to eliminate non-logo areas.
#                     More frames blended - more chance for non-logo areas to disappear from the mask.
#                     Disabling it disables "DynPostTune" automatically. Must be less than "Dyn3Seq"-1.
#                     0 - Disabled (default), for fine tuning.


# Int "DynPostTune" :  Parameter for "DynMask=3".
#                     Post-blend binarization threshold.  (from 0 to 5; default: 0 or 1)
#                     Higher values -> mask expands more into the brighter areas of video. (1=254, increments by -1)
#                     Safest setting is "1", higher will extend logo mask for few frames back and forth,
#                     and possibly some non-logo areas can appear in a mask, but logo mask will get in a lilbit better shape.
#                     If "ClpBlend" is disabled then this will be disabled automatically too.
#                     0 - Disabled, for fine tuning.


# Int "Dyn3buffer"  :  Parameter for "DynMask=3".
#                     Buffer for internal TrimergageFX(). Disable it for the script previewing or preview will be very slow.
#                     Enable it for encoding or AvS will work very slow, and it must go together
#                     with RequestLinear(rlim=ClpBlend+1,clim=ClpBlend+1) placed after the source filter.
#
#                     0 - Buffer disabled.
#                     1 - Buffer enabled (default).


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
#                     5 - Outputs full sized Dynamic PP mask. No resizing.


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
#   Function with all parameters (for advanced users):                                             #
##================================================================================================##
/*

InpaintDelogo( mask="c:\test\mymask.bmp",
\ Automask=0, aMix=0, Loc="100,100,-100,-100",
\ Mode="Inpaint", Analyze=1, FrB=0, FrW=0, FrS=0,
\ Inflate=1, Deep=2, ReAnalyze=0,
\ Interp=2, IntSpd=1, InterpM=0, iTune=0, iTinflate=0,
\ dPP=3, dPPm=3,
\ oPP=5, oPPm=3,
\ diPP=5, diPPm=3,
\ EdgePP=0, EdgePos=0, EdgeWide=1,
\ Turbo=0, prePP=0, KillShape=0, oTune=0, oTinflate=0,
\ DynMask=0, DynTune=0, DynInflate=0, maskPatch="", KillNoise=0,
\ Dyn3Seq=300, ClpBlend=0, DynPostTune=0, Dyn3buffer=1,
\ GrainPP=0,
\ Sharpness=45, PreBlur=6.5, PostBlur=4.0, Radius=8.0,
\ Show=0, mShow=0, rSize=4)

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
\                        int "ClpBlend", int "DynPostTune", int "Dyn3Seq", int "Dyn3buffer")

{

    # Load AVSInpaint for non AVS+ #
    # Error for standalone AVS+    #
    #==============================#


    avsplus     = false
    try{avsplus = InternalFunctionExists("autoloadplugins")}
    catch(dummy){}
    (avsplus == true) ? nop : LoadCPlugin("AVSInpaint.dll")

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
    analyze     = default (analyze     , 1 )
    deep        = default (deep        , 2 )
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
    dyntune     = default (dyntune     , 0 )
    dyninflate  = default (dyninflate  , 0 )
    grainpp     = default (grainpp     , 0 )
    opp         = default (opp         , 5 )
    killshape   = default (killshape   , 0 )
    killnoise   = default (killnoise   , 0 )
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
    Dyn3Seq     = default (Dyn3Seq   , 300 )
    ClpBlend    = default (ClpBlend    , 0 )
    DynPostTune = (ClpBlend == 0) ? default (DynPostTune , 0 ) :
    \                               default (DynPostTune , 1 )
    Dyn3buffer  = default (Dyn3buffer  , 1 )


    # Terminador de cucarachas #
    #==========================#


    bugloc      = (loc          == ""                   ) ? true : false
    bugloc2     = (loc          == "100,100,-100,-100"  ) ? true : false
    buganalyze  = (analyze      < 1 || analyze      >  4) ? true : false
    bugreanalyze= (reanalyze    < 0 || reanalyze    >  1) ? true : false
    bugdeep     = (deep         < 0 || deep         >  4) ? true : false
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
    bugdynmask  = (dynmask      < 0 || dynmask      >  3) ? true : false
    bugdyntune  = (dyntune    < -10 || dyntune      > 10) ? true : false
    bugdynflate = (dyninflate   < 0 || dyninflate   >  4) ? true : false
    buggrainpp  = (grainpp      < 0 || grainpp      >  3) ? true : false
    buginflate  = (inflate      < 0 || inflate      >  2) ? true : false
    bugiInflate = (iTinflate    < 0 || iTinflate    >  3) ? true : false
    bugoInflate = (oTinflate    < 0 || oTinflate    >  3) ? true : false
    bugotune    = (otune       < -4 || otune        >  4) ? true : false
    bugitune    = (itune       < -4 || itune        >  4) ? true : false
    bugamix     = (amix        < -5 || amix         >  5) ? true : false
    bugshow     = (show         < 0 || show         >  5) ? true : false
    bugmshow    = (mshow        < 0 || mshow        >  9) ? true : false
    bugrsize    = (rsize        < 1 || rsize        >  9) ? true : false
    bugautomask = (automask     < 0 || automask     >  1) ? true : false
    bugkillshape= (killshape    < 0 || killshape    >  1) ? true : false
    bugkillnoise= (killnoise    < 0 || killnoise    >  1) ? true : false
    bugturbo    = (turbo        < 0 || turbo        >  3) ? true : false
    bugedgepp   = (edgepp       < 0 || edgepp       >  3) ? true : false
    bugedgepos  = (edgepos     < -1 || edgepos      >  1) ? true : false
    bugedgewide = (edgewide     < 0 || edgewide     >  1) ? true : false
    bugintspd   = (intspd       < 1 || intspd       >  3) ? true : false
    bugmode     = (mode         != "inpaint" && mode != "deblend" && mode != "both" ) ? true : false
    bugcombo1   = (mode         == "inpaint" && mshow   >  4 && mshow <  9) ? true : false
    bugcombo2   = (mode         != "inpaint" && analyze == 3 && FrB == FrW) ? true : false
    bugcombo3   = (mode         != "inpaint" && killshape == 1) ? true : false
    bugcombo4   = (IsString(mask) && dynmask==0) ? eval(""" bugcombo4 = (mask == "") ? true : false return bugcombo4 """) : false
    bugcombo5   = (IsString(mask) && dynmask==0) ? eval(""" bugcombo5 = (findstr(mask,":") == 0) ? true : false return bugcombo5 """) : false
    bugcombo6   = (ClpBlend   == 0 && show != 3 && dynmask == 3 || DynPostTune == 0 && show != 3 && dynmask == 3) ? true : false
    bugcombo7   = (mode   == "inpaint" && edgePP  !=  0        ) ? true : false
    bugDyn3Seq     = (Dyn3Seq     < 10 || Dyn3Seq  >       9999) ? true : false
    bugClpBlend    = (ClpBlend     < 8 || ClpBlend >= Dyn3Seq-1) ? true : false
    bugDynPostTune = (DynPostTune  < 0 || DynPostTune      >  5) ? true : false
    bugDyn3buffer  = (Dyn3buffer   < 0 || Dyn3buffer       >  1) ? true : false


    assert        ( findstr(loc," ")  == 0      , """Space character is not allowed in string "Loc".""")
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
    assert        ( buganalyze        == false  , """"Analyze" value must be between 1 and 4.""")
    assert        ( bugreanalyze      == false  , """"ReAnalyze" value must be between 0 and 1.""")
    assert        ( bugdeep           == false  , """"Deep" value must be between 0 and 4.""")
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
    assert        ( bugdynmask        == false  , """"DynMask" value must be between 0 and 3.""")
    assert        ( bugdyntune        == false  , """"DynTune" value must be between -10 and 10.""")
    assert        ( bugdynflate       == false  , """"DynInflate" value must be between 0 and 4.""")
    assert        ( buggrainpp        == false  , """"GrainPP" value must be between 0 and 3.""")
    assert        ( buginflate        == false  , """"Inflate" value must be between 0 and 2.""")
    assert        ( bugiInflate       == false  , """"iTinflate" value must be between 0 and 3.""")
    assert        ( bugoInflate       == false  , """"oTinflate" value must be between 0 and 3.""")
    assert        ( bugotune          == false  , """"oTune" value must be between -4 and 4.""")
    assert        ( bugitune          == false  , """"iTune" value must be between -4 and 4.""")
    assert        ( bugamix           == false  , """"aMix" value must be between -5 and 5.""")
    assert        ( bugshow           == false  , """"Show" value must be between 0 and 5.""")
    assert        ( bugmshow          == false  , """"mShow" value must be between 0 and 8.""")
    assert        ( bugrsize          == false  , """"rSize" value must be between 1 and 9.""")
    assert        ( bugautomask       == false  , """"Automask" value must be between 0 and 1.""")
    assert        ( bugkillshape      == false  , """"KillShape" value must be between 0 and 1.""")
    assert        ( bugkillnoise      == false  , """"KillNoise" value must be between 0 and 1.""")
    assert        ( bugturbo          == false  , """"Turbo" value must be between 0 and 3.""")
    assert        ( bugedgepp         == false  , """"EdgePP" value must be between 0 and 3.""")
    assert        ( bugedgepos        == false  , """"EdgePos" value must be between -1 and 1.""")
    assert        ( bugedgewide       == false  , """"EdgeWide" value must be between 0 and 1.""")
    assert        ( bugintspd         == false  , """"IntSpd" value must be between 1 and 3.""")
    (automask == 1) ? assert ( revstr(mask).findstr("pmb.") == 1 , """Try bmp extension for "mask".""") : nop
    assert        ( bugDyn3Seq        == false  , """"Dyn3Seq" is out of the optimal range.""")
    (ClpBlend != 0) ? assert        ( bugClpBlend == false  , """"ClpBlend" is out of range.""") : nop
    assert        ( bugDynPostTune    == false  , """"DynPostTune" value must be between 0 and 5.""")
    assert        ( bugDyn3buffer     == false  , """"Dyn3buffer" value must be between 0 and 1.""")


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
    dyntunelow  = int((-1*dyntune)*5+200)
    dyntunehigh = int((-1*dyntune)*5+201)
    sSize       = float(rSize)
    sSize       = round(sSize/2.5)
    HD          = (x > 576) ? true : false
    matrixID    = (HD == true) ? "Rec709" : "Rec601"
    mskPatch    = (maskPatch != "") ? 1 : 0

    # Hard overrides:
    reanalyze   = (Automask == 1                      ) ? 1 : reanalyze
    reanalyze   = (mode  == "inpaint" && dynmask  != 0) ? 1 : reanalyze
    deep        = (mode  == "inpaint" || automask == 1) ? 0 : deep
    dynmask     = (mode  == "deblend"                 ) ? 0 : dynmask
    analyze     = (mode  == "inpaint" && automask != 1) ? 0 : analyze
    interp      = (mode  == "inpaint"                 ) ? 0 : interp
    interpm     = (mode  == "inpaint"                 ) ? 0 : interpm
    interpm     = (mode  == "both"    && interpm == -1) ? 0 : interpm
    interpmInfl = (interpm == -1                      ) ? 0 : interpm
    FrW         = (analyze ==  4                      ) ? 0 : FrW
    dppm        = (dpp     ==  0      && interp   < 1 ) ? 0 : dppm
    dippm       = (dipp    ==  0                      ) ? 0 : dippm
    oppm        = (opp     ==  0                      ) ? 0 : oppm
    prepp       = (prepp   !=  0                      ) ? 3 : prepp

    # DynMask 3:
    DynPostTune = (ClpBlend ==  0                     ) ? 0 : DynPostTune
    Dyn3buffer  = (ClpBlend ==  0                     ) ? 0 : Dyn3buffer
    DynPostTuneLow = int(255-DynPostTune)

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

    inYV12      = clp.Crop(a,b,c,d).ConvertToYV12
    inRGB24     = clp.Crop(a,b,c,d).ConvertToRGB24(matrix=matrixID)
    inRGB32     = clp.Crop(a,b,c,d).ConvertToRGB32(matrix=matrixID)

    blankblk    = BlankClip(clp,length=1,pixel_type="RGB32").Crop(a,b,c,d)
    blankwht    = BlankClip(clp,color=$FFFFFF,length=30,pixel_type="RGB24").Crop(a,b,c,d)


    # Analyze methods. #
    #==================#


    TrimFix     = (analyze == 3) ? inRGB24.Trim(FrB,frx)+inRGB24.Trim(FrW,frx) :
    \                              inRGB24.Trim(FrB,frx)+blankwht.Trim(0,frx)

    Fix         = (FrS == 0) ? TrimFix.Loop(200) : (FrS == 1) ? TrimFix.Loop(150) : (FrS == 2) ? TrimFix.Loop(80) : TrimFix.Loop(40)

    Method      = (analyze == 0 ) ? inRGB24.Trim(0,-1)+inRGB24.Trim(0,-1)        :
    \             (analyze == 1 ) ? inRGB24.SelectRangeEvery(every=33, length=1) :
    \             (analyze == 2 ) ? inRGB24                                      : Fix


    # Auto-Generation of the logo mask. #
    #===================================#


    Autologo    = (Automask == 1) ? eval("""

                  AutoID    = LeftStr(mask,int(StrLen(mask)-4))

                  Blackclp  = BlankClip(clp,length=1).ConvertToRGB24
                  Whitecrop = BlankClip(clp,color=$FFFFFF,length=1).ConvertToRGB24.Crop(a,b,c,d)
                  Merge     = Blackclp.Overlay(Whitecrop,x=a,y=b).ConvertToRGB32
                  Merge     = Merge.Mask(Merge)
                  Merge     = Merge.balloonPX(-7).Crop(a,b,c,d)

                  Method.analyzelogo(Merge).Trim(0,-1).ConvertToRGB32
                  Crop(0,last.Height/2,0,0)
                  ImageWriter(AutoID  + "_temp%.0d.bmp",0,-1,"bmp")

                  Blackclp.Overlay(last,x=a,y=b).ConvertToRGB32

                  Levels(amixlow,1,amixhigh,0,255, coring=false)
                  ImageWriter(AutoID  + "%.0d.bmp",0,-1,"bmp")

                  return Last """) : nop


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
                  Clipmask = (maskdynamic == true) ? mask.ConvertToYV12(matrix="PC.709") : mask.ConvertToRGB32
                  return Clipmask """) : nop


    # Creation of the base mask. #
    #============================#


    DummyMsk    = blankblk.Subtitle("Dummy", text_color=color_white, align=5)

    Imgmask     = (Automask == 1                            ) ? Autologo.Crop(a,b,c,d).Levels(127,1,128,0,255) :
    \             (dynmask  == 2 && mode == "both"          ) ? ImageSource(mask,0,0).Greyscale.ConvertToRGB32.Crop(a,b,c,d).Levels(127,1,128,0,255) :
    \             (dynmask   > 1                            ) ? DummyMsk :
    \             (maskClip == false                        ) ? ImageSource(mask,0,0).Greyscale.ConvertToRGB32.Crop(a,b,c,d).Levels(127,1,128,0,255) :
    \             (maskClip == true  && maskdynamic == false) ? Clipmask :
    \                                                           DummyMsk
    Imgmask     = Imgmask.Mask(Imgmask)

    BasemaskP   = (Killshape == 0) ? Imgmask :
    \                                Imgmask.balloonPX(99)
    Basemask    = BasemaskP.balloonPX(inflate)


    # Inception of Total Recall (Deep) #
    #====================================#


    MskName     = (IsString(mask)) ? mask : "Clip"
    MskName     = (mode == "inpaint") ? "Dummy" : MskName

    IDXadapt    = string(int(deep+1))

    DeepID1     = (analyze <= 2) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep1" :
    \             (analyze >= 3) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep1"+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs) : nop
    DeepID2     = (analyze <= 2) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep2" :
    \             (analyze >= 3) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep2"+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs) : nop
    DeepID3     = (analyze <= 2) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep3" :
    \             (analyze >= 3) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep3"+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs) : nop
    DeepID4     = (analyze <= 2) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep4" :
    \             (analyze >= 3) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep4"+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs) : nop
    DeepIDX     = (analyze <= 2) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep"+string(IDXadapt) :
    \             (analyze >= 3) ? MskName+"_InpaintDelogo_"+ string(a)+"-"+string(b)+string(c)+string(d)+"_A"+string(analyze)+"_Deep"+string(IDXadapt)+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs) : nop


    inDeep1     = (deep >= 1 && reanalyze == 1) ? eval("""

                  # Pass 1 #
                  #========#

                  Method.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID1 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor1 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha1 = Crop(0,last.Height/2,0,0)
                  LogoAlpha1 = LogoAlpha1.Mask(LogoAlpha1)

                  inRGB24.DeblendLogo(LogoColor1, LogoAlpha1)


                  """) : (deep >= 1 && reanalyze == 0) ? eval("""

                  try
                  {ImageSource(DeepID1 + "%.0d.ebmp",0,0)

                  LogoColor1 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha1 = Crop(0,last.Height/2,0,0)
                  LogoAlpha1 = LogoAlpha1.Mask(LogoAlpha1)

                  inRGB24.DeblendLogo(LogoColor1, LogoAlpha1)}
                  catch(dummy)

                  {Method.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID1 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor1 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha1 = Crop(0,last.Height/2,0,0)
                  LogoAlpha1 = LogoAlpha1.Mask(LogoAlpha1)
                  inRGB24.DeblendLogo(LogoColor1, LogoAlpha1)}""") : nop


    inDeep2     = (deep >= 2 && reanalyze == 1) ? eval("""

                  # Pass 2 #
                  #========#

                  TrimFix1   = (analyze == 3 ) ? inDeep1.Trim(FrB,frx)+inDeep1.Trim(FrW,frx) :
                  \                              inDeep1.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix1       = (FrS == 0) ? TrimFix1.Loop(200) : (FrS == 1) ? TrimFix1.Loop(150) : (FrS == 2) ? TrimFix1.Loop(80) : TrimFix1.Loop(40)

                  Method1    = (analyze == 1 ) ? inDeep1.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep1                                      : Fix1

                  Method1.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID2 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor2 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha2 = Crop(0,last.Height/2,0,0)
                  LogoAlpha2 = LogoAlpha2.Mask(LogoAlpha2)

                  inDeep1.DeblendLogo(LogoColor2, LogoAlpha2)


                  """) : (deep >= 2 && reanalyze == 0) ? eval("""

                  try
                  {TrimFix1   = (analyze == 3 ) ? inDeep1.Trim(FrB,frx)+inDeep1.Trim(FrW,frx) :
                  \                               inDeep1.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix1       = (FrS == 0) ? TrimFix1.Loop(200) : (FrS == 1) ? TrimFix1.Loop(150) : (FrS == 2) ? TrimFix1.Loop(80) : TrimFix1.Loop(40)

                  Method1    = (analyze == 1 ) ? inDeep1.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep1                                      : Fix1

                  ImageSource(DeepID2 + "%.0d.ebmp",0,0)

                  LogoColor2 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha2 = Crop(0,last.Height/2,0,0)
                  LogoAlpha2 = LogoAlpha2.Mask(LogoAlpha2)

                  inDeep1.DeblendLogo(LogoColor2, LogoAlpha2)}
                  catch(dummy)

                  {TrimFix1   = (analyze == 3 ) ? inDeep1.Trim(FrB,frx)+inDeep1.Trim(FrW,frx) :
                  \                               inDeep1.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix1       = (FrS == 0) ? TrimFix1.Loop(200) : (FrS == 1) ? TrimFix1.Loop(150) : (FrS == 2) ? TrimFix1.Loop(80) : TrimFix1.Loop(40)

                  Method1    = (analyze == 1 ) ? inDeep1.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep1                                      : Fix1

                  Method1.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID2 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor2 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha2 = Crop(0,last.Height/2,0,0)
                  LogoAlpha2 = LogoAlpha2.Mask(LogoAlpha2)

                  inDeep1.DeblendLogo(LogoColor2, LogoAlpha2)} """) : nop


    inDeep3     = (deep >= 3 && reanalyze == 1) ? eval("""

                  # Pass 3 #
                  #========#

                  TrimFix2   = (analyze == 3 ) ? inDeep2.Trim(FrB,frx)+inDeep2.Trim(FrW,frx) :
                  \                              inDeep2.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix2       = (FrS == 0) ? TrimFix2.Loop(200) : (FrS == 1) ? TrimFix2.Loop(150) : (FrS == 2) ? TrimFix2.Loop(80) : TrimFix2.Loop(40)

                  Method2    = (analyze == 1 ) ? inDeep2.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep2                                      : Fix2

                  Method2.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID3 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor3 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha3 = Crop(0,last.Height/2,0,0)
                  LogoAlpha3 = LogoAlpha3.Mask(LogoAlpha3)

                  inDeep2.DeblendLogo(LogoColor3, LogoAlpha3)


                  """) : (deep >= 3 && reanalyze == 0) ? eval("""

                  try
                  {TrimFix2   = (analyze == 3 ) ? inDeep2.Trim(FrB,frx)+inDeep2.Trim(FrW,frx) :
                  \                               inDeep2.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix2       = (FrS == 0) ? TrimFix2.Loop(200) : (FrS == 1) ? TrimFix2.Loop(150) : (FrS == 2) ? TrimFix2.Loop(80) : TrimFix2.Loop(40)

                  Method2    = (analyze == 1 ) ? inDeep2.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep2                                      : Fix2

                  ImageSource(DeepID3 + "%.0d.ebmp",0,0)

                  LogoColor3 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha3 = Crop(0,last.Height/2,0,0)
                  LogoAlpha3 = LogoAlpha3.Mask(LogoAlpha3)

                  inDeep2.DeblendLogo(LogoColor3, LogoAlpha3)}
                  catch(dummy)

                  {TrimFix2   = (analyze == 3 ) ? inDeep2.Trim(FrB,frx)+inDeep2.Trim(FrW,frx) :
                  \                               inDeep2.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix2       = (FrS == 0) ? TrimFix2.Loop(200) : (FrS == 1) ? TrimFix2.Loop(150) : (FrS == 2) ? TrimFix2.Loop(80) : TrimFix2.Loop(40)

                  Method2    = (analyze == 1 ) ? inDeep2.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep2                                      : Fix2

                  Method2.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID3 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor3 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha3 = Crop(0,last.Height/2,0,0)
                  LogoAlpha3 = LogoAlpha3.Mask(LogoAlpha3)

                  inDeep2.DeblendLogo(LogoColor3, LogoAlpha3)}""") : nop


    inDeep4     = (deep >= 4 && reanalyze == 1) ? eval("""

                  # Pass 4 #
                  #========#

                  TrimFix3   = (analyze == 3 ) ? inDeep3.Trim(FrB,frx)+inDeep3.Trim(FrW,frx) :
                  \                              inDeep3.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix3       = (FrS == 0) ? TrimFix3.Loop(200) : (FrS == 1) ? TrimFix3.Loop(150) : (FrS == 2) ? TrimFix3.Loop(80) : TrimFix3.Loop(40)

                  Method3    = (analyze == 1 ) ? inDeep3.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep3                                      : Fix3

                  Method3.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID4 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor4 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha4 = Crop(0,last.Height/2,0,0)
                  LogoAlpha4 = LogoAlpha4.Mask(LogoAlpha4)

                  inDeep3.DeblendLogo(LogoColor4, LogoAlpha4)


                  """) : (deep >= 4 && reanalyze == 0) ? eval("""

                  try
                  {TrimFix3   = (analyze == 3 ) ? inDeep3.Trim(FrB,frx)+inDeep3.Trim(FrW,frx) :
                  \                               inDeep3.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix3       = (FrS == 0) ? TrimFix3.Loop(200) : (FrS == 1) ? TrimFix3.Loop(150) : (FrS == 2) ? TrimFix3.Loop(80) : TrimFix3.Loop(40)

                  Method3    = (analyze == 1 ) ? inDeep3.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep3                                      : Fix3

                  ImageSource(DeepID4 + "%.0d.ebmp",0,0)

                  LogoColor4 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha4 = Crop(0,last.Height/2,0,0)
                  LogoAlpha4 = LogoAlpha4.Mask(LogoAlpha4)

                  inDeep3.DeblendLogo(LogoColor4, LogoAlpha4)}
                  catch(dummy)

                  {TrimFix3   = (analyze == 3 ) ? inDeep3.Trim(FrB,frx)+inDeep3.Trim(FrW,frx) :
                  \                              inDeep3.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix3       = (FrS == 0) ? TrimFix3.Loop(200) : (FrS == 1) ? TrimFix3.Loop(150) : (FrS == 2) ? TrimFix3.Loop(80) : TrimFix3.Loop(40)

                  Method3    = (analyze == 1 ) ? inDeep3.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeep3                                      : Fix3

                  Method3.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepID4 + "%.0d.ebmp",0,-1,"ebmp")

                  LogoColor4 = Crop(0,0,0,last.Height/2).ConvertToRGB24
                  LogoAlpha4 = Crop(0,last.Height/2,0,0)
                  LogoAlpha4 = LogoAlpha4.Mask(LogoAlpha4)

                  inDeep3.DeblendLogo(LogoColor4, LogoAlpha4)}""") : nop


    # Analyze process (Color & Alpha masks creation). #
    #=================================================#


    ID          = (analyze <= 2) ? MskName + "_InpaintDelogo_"+string(a)+"-"+string(b)+string(c)+string(d)+"_A"+ string(analyze) :
    \             (analyze >= 3) ? MskName + "_InpaintDelogo_"+string(a)+"-"+string(b)+string(c)+string(d)+"_A"+ string(analyze)+"_"+string(FrB)+"-"+string(FrW)+"-"+string(frs) : nop

    inDeepX     = (deep == 1) ? inDeep1 : (deep == 2) ? inDeep2 : (deep == 3) ? inDeep3 : (deep == 4) ? inDeep4 : nop

    Logo        = (deep != 0 && reanalyze == 1) ? eval("""

                  # Pass X #
                  #========#

                  TrimFix5   = (analyze == 3 ) ? inDeepX.Trim(FrB,frx)+inDeepX.Trim(FrW,frx) :
                  \                              inDeepX.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix5       = (FrS == 0) ? TrimFix5.Loop(200) : (FrS == 1) ? TrimFix5.Loop(150) : (FrS == 2) ? TrimFix5.Loop(80) : TrimFix5.Loop(40)

                  Method5    = (analyze == 1 ) ? inDeepX.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeepX                                      : Fix5

                  Method5.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepIDX + "%.0d.ebmp",0,-1,"ebmp")


                  """) : (deep != 0 && reanalyze == 0) ? eval("""

                  try
                  {ImageSource(DeepIDX + "%.0d.ebmp",0,0)}
                  catch(dummy)

                  {TrimFix5   = (analyze == 3 ) ? inDeepX.Trim(FrB,frx)+inDeepX.Trim(FrW,frx) :
                  \                               inDeepX.Trim(FrB,frx)+blankwht.Trim(0,frx)

                  Fix5       = (FrS == 0) ? TrimFix5.Loop(200) : (FrS == 1) ? TrimFix5.Loop(150) : (FrS == 2) ? TrimFix5.Loop(80) : TrimFix5.Loop(40)

                  Method5    = (analyze == 1 ) ? inDeepX.SelectRangeEvery(every=33, length=1) :
                  \            (analyze == 2 ) ? inDeepX                                      : Fix5

                  Method5.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(DeepIDX + "%.0d.ebmp",0,-1,"ebmp")}


                  # Analyze (Deep=0) #
                  #==================#

                  """) : (deep == 0 && reanalyze == 1) ? eval("""

                  Method.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(ID +"%.0d.ebmp",0,-1,"ebmp")


                  """) : (deep == 0 && reanalyze == 0) ? eval("""

                  try
                  {ImageSource(ID + "%.0d.ebmp",0,0)}
                  catch(dummy)

                  {Method.analyzelogo(Basemask,DeviationWeight=0.5).Trim(0,-1).ConvertToRGB32
                  ImageWriter(ID + "%.0d.ebmp",0,-1,"ebmp")}""") : nop


    # Have you weared your mask today? #
    #==================================#


    InterpMask  = Basemask.balloonPX(interpmInfl)

    Phase1Logo  = (deep != 0) ? eval("""ImageSource(DeepID1 + "%.0d.ebmp",0,0)""") : nop
    Phase1Color = (deep != 0) ? Phase1Logo.Crop(0,0,0,Phase1Logo.Height/2).ConvertToRGB24 : nop
    Phase1Alpha = (deep != 0) ? Phase1Logo.Crop(0,Phase1Logo.Height/2,0,0) : nop
    Phase1Alpha = (deep != 0) ? Phase1Alpha.Mask(Phase1Alpha) : nop

    LogoColor   = Logo.Crop(0,0,0,Logo.Height/2).ConvertToRGB24
    LogoAlpha   = Logo.Crop(0,Logo.Height/2,0,0)
    LogoAlpha   = LogoAlpha.Mask(LogoAlpha)

    OpaqueTune  = (deep != 0) ? Phase1Alpha.Levels(tunelow,1,tunehigh,0,255) :
    \                           LogoAlpha.  Levels(tunelow,1,tunehigh,0,255)
    OpaqueTune  = OpaqueTune.balloonPX(oTinflate)

    InterpTuneP = (deep != 0) ? Phase1Alpha.Levels(itunelow,1,itunehigh,0,255) :
    \                           LogoAlpha.  Levels(itunelow,1,itunehigh,0,255)
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
                  EdgeMask    = (edgeWide == 0) ? EdgeMerge1.Mask(EdgeMerge1):
                  \                               EdgeMerge2.Mask(EdgeMerge2)
                  return EdgeMask """) : nop


    # Delogo process and Dynamic masks #
    #==================================#


    LogoDeblend = (automask == 0 && mode != "inpaint") ? eval("""

                  LogoDeblPre = (deep != 0   ) ? inDeepX.DeblendLogo(Logocolor,LogoAlpha).ConvertToYV12(matrix=matrixID) :
                  \                              inRGB24.DeblendLogo(Logocolor,LogoAlpha).ConvertToYV12(matrix=matrixID)

                  LogoInpaPre = (interpm == -1 && intspd == 1) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=2) :
                  \             (interpm == -1 && intspd == 2) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=6) :
                  \             (interpm == -1 && intspd == 3) ? LogoDeblPre.InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur=4,radius=8) :
                  \             (                 intspd == 1) ? inYV12     .InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=2) :
                  \             (                 intspd == 2) ? inYV12     .InpaintLogo(InterpMask, sharpness=1.5,preblur=  0,postblur=0,radius=6) :
                  \             (                 intspd == 3) ? inYV12     .InpaintLogo(InterpMask, sharpness= 45,preBlur=6.5,postBlur=4,radius=8) : nop

                  LogoDeblend = (interp != 0 ) ? LogoInpaPre.Overlay(LogoDeblPre, opacity=interp) :
                  \                              LogoDeblPre
                  return LogoDeblend """) : nop


    DynamicMsk3 = (automask == 0 && DynMask == 3 && mode == "inpaint") ? eval("""
                  DynamicMsk3 = inYV12.Greyscale.mt_binarize(threshold=dyntunelow).ConvertToY8

                  DynamicMsk3 = (ClpBlend    == 0) ? DynamicMsk3 :
                  \             (DynPostTune == 0) ? DynamicMsk3.ClipBlend(ClpBlend) :
                  \                                  DynamicMsk3.ClipBlend(ClpBlend).mt_binarize(threshold=DynPostTuneLow)

                  DynamicMsk3 = (Dyn3buffer == 0 || show == 3) ? DynamicMsk3 :
                  \                                              DynamicMsk3.RequestLinear(rlim=ClpBlend,clim=ClpBlend)
                  return DynamicMsk3 """) : nop


    DynamicMask = (automask == 0 && DynMask != 0) ? eval("""
                  DynamicMask = (mode == "inpaint" && DynMask == 1) ? Clipmask :
                  \             (mode == "both"    && DynMask == 2) ? LogoDeblend.Greyscale.mt_binarize(threshold=dyntunelow)  :
                  \             (mode == "inpaint" && DynMask == 2) ? inYV12     .Greyscale.mt_binarize(threshold=dyntunelow)  :
                  \             (mode == "inpaint" && DynMask == 3) ? DynamicMsk3.TrimergageFX(Seq=Dyn3Seq, ClpBlend=ClpBlend).ConvertToYV12 : nop
                  DynamicMask = (KillNoise == 1) ? DynamicMask.MTballoonPX(88) : DynamicMask
                  DynamicMask = (Killshape == 1) ? DynamicMask.MTballoonPX(99) : DynamicMask
                  DynamicMask = DynamicMask.MTballoonPX(dyninflate)
                  DynamicMask = (MskPatch  == 1) ? DynamicMask.PatchFuncFX(maskPatch) : DynamicMask
                  return DynamicMask """) : nop


    InpaintMpp  = (automask == 0 && DynMask != 0) ? eval("""
                  InpaintMpp  = DynamicMask.MTballoonGR(oppm)
                  return InpaintMpp """) : InpaintMpp


    LogoBoth    = (automask == 0 && mode != "inpaint") ? eval("""
                  LogoBoth    = (DynMask != 0) ? LogoDeblend.InpaintLogo(DynamicMask, radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur) :
                  \                              LogoDeblend.InpaintLogo(OpaqueMask , radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur)
                  return LogoBoth """) : nop


    LogoInpaint = (automask == 0 && mode == "inpaint") ? eval("""
                  LogoInpaint = (DynMask != 0) ? inYV12.ppFX(prePP).InpaintLogo(DynamicMask, radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur) :
                  \                              inYV12.ppFX(prePP).InpaintLogo(OpaqueMask , radius=radius,sharpness=sharpness,preblur=preblur,postblur=postblur)
                  return LogoInpaint """) : nop


    delogo      = (automask == 0) ? eval("""
                  delogo      = (mode == "inpaint") ? LogoInpaint :
                  \             (mode == "deblend") ? LogoDeblend :
                  \             (mode == "both"   ) ? LogoBoth    : nop
                  return delogo """) : nop


    # Delogo PP #
    #===========#


    # EdgePP:
    delogopp2   = (automask == 0) ? eval("""
                  delogopp2 =  (edgePP == 1 ) ? delogo.InpaintLogo(EdgeMask, sharpness= 1.5,preblur=0  ,postblur=0,radius=2 ) :
                  \            (edgePP == 2 ) ? delogo.InpaintLogo(EdgeMask, sharpness= 1.5,preblur=0  ,postblur=0,radius=6 ) :
                  \            (edgePP == 3 ) ? delogo.InpaintLogo(EdgeMask, sharpness=45  ,preBlur=6.5,postBlur=4,radius=8 ) :
                  \                             delogo
                  return delogopp2  """) : nop

    # dPP/oPP:
    delogopp3   = (automask == 0) ? eval("""
                  delogopp3 = (mode == "inpaint"            ) ? inYV12.Overlay(delogo   .ppFX(opp), Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \           (mode != "inpaint" && dPP != 0) ? inYV12.Overlay(delogopp2.ppFX(dpp), Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm != 0         && dPP == 0) ? inYV12.Overlay(delogopp2,           Mask=DeblendMpp.ConvertToY8(matrix="PC.709")) :
                  \           (dPPm == 0         && dPP == 0) ? inYV12.Overlay(delogopp2,           Mask=Basemask.  ConvertToY8(matrix="PC.709")) : nop
                  return delogopp3  """) : nop

    # iTune PP:
    delogopp4   = (automask == 0) ? eval("""
                  delogopp4 = (mode == "deblend" && InterpM == -1 && diPP != 0) ? delogopp3.Overlay(delogopp3.ppFX(dipp), Mask=iTunepp.ConvertToY8(matrix="PC.709")) :
                  \                                                               delogopp3
                  return delogopp4 """) : nop

    # Both/oTune PP:
    delogopp5   = (automask == 0) ? eval("""
                  delogopp5 = (mode == "both" && oPP != 0) ? delogopp4.Overlay(delogopp4.ppFX(opp), Mask=InpaintMpp.ConvertToY8(matrix="PC.709")) :
                  \                                          delogopp4
                  return delogopp5 """) : nop

    # Grain PP:
    delogopp9   = (automask == 0) ? eval("""
                  delogopp9 = (grainpp == 1) ? delogopp5.Overlay(delogopp5.Grainfactory3(1,0,0,temp_avg=60), Mask=GrainMaskpp.ConvertToY8(matrix="PC.709")) :
                  \           (grainpp == 2) ? delogopp5.Overlay(delogopp5.Grainfactory3(2,1,1,temp_avg=60), Mask=GrainMaskpp.ConvertToY8(matrix="PC.709")) :
                  \           (grainpp == 3) ? delogopp5.Overlay(delogopp5.Grainfactory3(2,2,2,temp_avg=60), Mask=GrainMaskpp.ConvertToY8(matrix="PC.709")) :
                  \                            delogopp5
                  return delogopp9  """) : nop


    # "mShow" #
    #=========#


    helper      = (automask == 0) ? eval("""
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


    (automask == 1) ? Eval("""


                  # Show Automask #
                  #===============#

                  Autologo.Crop(a,b,c,d)

                  Autoalpha = ImageSource(AutoID + "_temp%.0d.bmp",0,0)

                  w = int(rsize*width(last))
                  h = int(rsize*height(last))
                  PointResize(last,w,h)

                  Autoalpha = Autoalpha.Spline16Resize(w,h)

                  StackVertical(last, Autoalpha)

                  return last

                  """) : (show == 1) ? Eval("""


                  # "Show" 1 #
                  #==========#

                  Source    = inRGB32                 .Subtitle("source"   )
                  Delogo    = delogo.ConvertToRGB32   .Subtitle("delogo"   )
                  Delogopp  = delogopp9.ConvertToRGB32.Subtitle("delogo pp")

                  Logoalpha = (deep == 0) ? Logoalpha : Phase1Alpha
                  Logocolor = (deep == 0) ? Logocolor : Phase1color

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
                  \           (mode == "deblend"             ) ? edgemask                              .Subtitle("edge pp"     ) :
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
                  \              last

                  return last

                  """) : (show == 2) ? Eval("""


                  # "Show" 2 #
                  #==========#

                  a1 = (DynMask != 0) ? StackVertical (delogo, helper) : nop
                  a2 = (DynMask != 0) ? StackVertical (DynamicMask.ConvertToY8.ConvertToYV12, InpaintMpp.ConvertToY8.ConvertToYV12) : nop

                  (DynMask != 0) ? StackHorizontal(a1, a2) :
                  \                StackVertical(delogo, helper)

                  w = int(rsize*width(last))
                  h = int(rsize*height(last))
                  return Spline16Resize(last,w,h)

                  """) : (show == 3) ? Eval("""


                  # "Show" 3 #
                  #==========#

                  DynamicMsk3

                  """) : (show == 4) ? Eval("""


                  # "Show" 4 #
                  #==========#

                  DynamicMask.ConvertToY8.ConvertToYV12

                  """) : (show == 5) ? Eval("""


                  # "Show" 5 #
                  #==========#

                  BlackClip = BlankClip(clp)
                  show4 = InpaintMpp.ConvertToY8.ConvertToYV12
                  show4out = (Loc == "-0,-0,-0,-0" || Loc == "0,0,-0,-0") ? show4 : BlackClip.Overlay(show4,x=a,y=b)
                  return show4out """) : Eval("""


                  # FinalOut #
                  #==========#

                  finalout = (Loc == "-0,-0,-0,-0" || Loc == "0,0,-0,-0") ? helper : clp.Overlay(helper,x=a,y=b)
                  return finalout """)

}



##================================================================================================##
#   TrimergageFX:                                                                                     #
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
    WhiteClip   = BlankClip(clp,color=$FFFFFF, pixel_type="Y8").ColorYUV(levels="tv->pc")
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
    mode        = default (mode, 0)

    px1         = clp.mt_expand(mode="square",chroma="none")
    px2         = px1.mt_expand(mode="both",  chroma="none")
    px3         = px2.mt_expand(mode="both",  chroma="none")
    px4         = px3.mt_expand(mode="square",chroma="none")

    mpx1        = clp .mt_inpand(mode="square",chroma="none")
    mpx2        = mpx1.mt_inpand(mode="both",  chroma="none")
    mpx3        = mpx2.mt_inpand(mode="both",  chroma="none")
    mpx4        = mpx3.mt_inpand(mode="square",chroma="none")

    kill        = px3
    kill        = kill.mt_inpand(mode="square",chroma="none")
    kill        = kill.mt_inpand(mode="both",  chroma="none")
    kill        = kill.mt_inpand(mode="both",  chroma="none")

    kill2       = mpx1
    kill2       = kill2.mt_expand(mode="square",chroma="none")

    balloon     = (mode ==  0) ? clp  :
    \             (mode ==  1) ? px1  :
    \             (mode ==  2) ? px2  :
    \             (mode ==  3) ? px3  :
    \             (mode ==  4) ? px4  :
    \             (mode == 99) ? kill :
    \             (mode == 88) ? kill2:
    \             (mode == -1) ? mpx1 :
    \             (mode == -2) ? mpx2 :
    \             (mode == -3) ? mpx3 :
    \             (mode == -4) ? mpx4 : nop

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

    mpx7        = clp.DistanceFunction(-32).Levels(240,1,241,0,255)

    kill        = px3.DistanceFunction(-32).Levels(110,1,111,0,255)

    kill2       = mpx1.DistanceFunction(128).Levels(30,1,31,0,255)

    balloon     = (mode ==  0) ? clp  :
    \             (mode ==  1) ? px1  .ShowAlpha :
    \             (mode ==  2) ? px2  .ShowAlpha :
    \             (mode ==  3) ? px3  .ShowAlpha :
    \             (mode ==  4) ? px3  .ShowAlpha :
    \             (mode == 99) ? kill .ShowAlpha :
    \             (mode == 88) ? kill2.ShowAlpha :
    \             (mode == -1) ? mpx1 .ShowAlpha :
    \             (mode == -2) ? mpx2 .ShowAlpha :
    \             (mode == -7) ? mpx7 .ShowAlpha : nop

    return balloon
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

    assert        ( findstr(loc," ")  == 0      , """Space character is not allowed in string "Loc".""")
    assert        ( bugloc            == false  , """You must define "Loc".""")

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
