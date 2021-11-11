<pre><code>##================================================================================================##
#                                                                                                  #
#             ____                  _       __  ____       __                                      #
#            /  _/___  ____  ____ _(_)___  / /_/ __ \___  / /___  ____  ____                       #
#            / // __ \/ __ \/ __ `/ / __ \/ __/ / / / _ \/ / __ \/ __ `/ __ \                      #
#          _/ // / / / /_/ / /_/ / / / / / /_/ /_/ /  __/ / /_/ / /_/ / /_/ /                      #
#         /___/_/ /_/ .___/\__,_/_/_/ /_/\__/_____/\___/_/\____/\__, /\____/                       #
#                  /_/                                         /____/                              #
#                                                                                                  #
##================================================================================================##

  InpaintDelogo is an advanced logo and watermark removal function using inpainting and deblending
 with an adjustable fine process to hide artifacts and get best delogo results.
 Can remove opaque, transparent, semi-transparent and some dynamic logos from video.
 Can be used to remove hardcoded subtitles or extract them to images for OCR.

  Inpainting refers to the application of sophisticated algorithms to reconstruct of lost
 or deteriorated parts of images or videos.
 </code></pre>
 
<pre><code> 
Core requirements:
AviSynth+ v3.6.2 or later ( https://github.com/AviSynth/AviSynthPlus ), or AviSynth v2.6.
AvsInpaint v1.3 or later  ( https://github.com/pinterf/AvsInpaint ).

Other requirements:
MaskTools2    ( https://github.com/pinterf/masktools ).
RgTools       ( https://github.com/pinterf/RgTools ).
GRunT         ( https://github.com/pinterf/GRunT ).
RequestLinear ( https://github.com/pinterf/TIVTC ).
ClipBlend     ( http://avisynth.nl/index.php/ClipBlend ).
RT_Stats      ( http://avisynth.nl/index.php/RT_Stats ).
GrainFactory3 ( http://avisynth.nl/index.php/GrainFactory3 )
 </code></pre>
 
 <pre><code> 
Notes for AviSynth v2.6 users:
Requirement: GScript ( http://avisynth.nl/index.php/GScript ).
"InpaintDelogo.avsi" needs to be renamed to "InpaintDelogo.avs",
and loaded manually in AviSynth script with: GImport("C:\AviSynth 2.5\plugins\InpaintDelogo.avs"),
or use AvsInit for autoloading ( https://forum.doom9.org/showthread.php?t=176749 ).
Subs extraction is up to 600% slower than with AviSynth+!
 </code></pre>
 
 https://forum.doom9.org/showthread.php?t=176860
