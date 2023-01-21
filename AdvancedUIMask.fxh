//=======================================================================================================
// AdvancedUIMask Header File by FoG
// Version - 1.0
//=======================================================================================================
/*  
*   Thanks to brussell for UIDetect.fx and luluco250 for UIMask.fx, without those shaders I wouldn't of
*   been able to make this.
*   
*   AdvancedUIMask takes methods and techniques used by both of those and combinds them, either you can 
*   have smart masks, that only gets applied when certain pixels are detected, or you can set
*   AdvancedUIMask_Combine to 1, which will apply masks when pixels are detected and disable all shaders
*   inbetween Before and After when pixels are not detected. (Essentially combining UIDetect and UIMask)
*
*   Setting AdvancedUIMask_JustDetectUI to 1 will add essentially base UIDetect, list the specified
*   pixels and their UI number and if they are detected the shaders inbetween Before and After will
*   be disabled, no UIMask
*   Note: Enabling this does not disable the use of UIMasks, but will take priority over applying a mask
*
*   Like UIDetect this has some requirements and drawbacks:
*   -the UI elements that should be detected must be opaque and static, meaning moving or transparent
*    UIs don't work with this shader
*   -changing graphical settings of the game most likely result in different UI pixel values,
*    so set up your game properly before using UIDetect (especially resolution and anti-aliasing)
*   
*   Following UIDetects recommendation for getting suitable pixel values, as quoted here:
*   Getting suitable UI pixel values:
*   -take a screenshot without any shaders when the UI is visible
*   -open the screenshot in an image processing tool
*   -look for a static and opaque area in the UI layer that is usually out of reach for user actions
*    like the mouse cursor, tooltips etc. (preferably somewhere in a corner of the screen)
*   -use a color picker tool and choose two, three or more pixels (the more the better), which are near
*    to each other but differ greatly in color and brightness, and note the pixels coordinates and RGB
*    values (thus choose pixels that  do not likely occur in non-UI game situations, so that effects
*    couldn't get toggled accidently when there is no UI visible)
*   -write the pixels coordinates and UI number into the array "UIPixelCoord_UINr"
*   -write the pixels RGB values into the array "UIPixelRGB"
*   -set the total number of pixels used via the "PIXELNUMBER" parameter
*
*   Of course with AdvancedUIMask UIPixelCoord_UINr is JustUIPixelCoord, OnePixelCoord, TwoPixelCoord etc.
*   UIPixelRGB is JustUIPixelRGB, OnePixelRGB, etc
*   and lastly PIXELNUMBER is DetectionJustUI, DetectionOnePixelNumber, etc
*
*   The major difference with AdvancedUIMask is that you can not only just disable or enable effects based
*   on pixel detection, but also apply masks (currently up to 5) based on pixel detection.
*   Because of this, there are multiple tables below, JustUI's table is for only disabling and enabling
*   effects on pixel detection, it will also override any masks that might overlap in pixel detection
*   The rest that have a number before PixelCoord (such as OnePixelCoord) are for masks, when their pixels
*   are detected a mask will be applied.
*   To increase the amount of Masks (or disable masking all together) change AdvancedUIMask_Amount
*
*   As far as creating mask images, I will quote UIMasks recommendation:
*	--To make a custom mask:
*
*	  1-Take a screenshot of your game with the HUD enabled,
*	   preferrably with any effects disabled for maximum visibility.
*
*	  2-Open the screenshot with your preferred image editor program, I use GIMP.
*
*	  3-Make a background white layer if there isn't one already.
*		Be sure to leave it behind your actual screenshot for the while.
*
*	  4-Make an empty layer for the mask itself, you can call it "mask".
*
*	  5-Having selected the mask layer, paint the places where HUD constantly is,
*		such as health bars, important messages, minimaps etc.
*
*	  6-Delete or make your screenshot layer invisible.
*
*	  7-Before saving your mask, let's do some gaussian blurring to improve it's look and feel:
*		For every step of blurring you want to do, make a new layer, such as:
*		Mask - Blur16x16
*		Mask - Blur8x8
*		Mask - Blur4x4
*		Mask - Blur2x2
*		Mask - NoBlur
*		You should use your image editor's default gaussian blurring filter, if there is one.
*		This avoids possible artifacts and makes the mask blend more easily on the eyes.
*		You may not need this if your mask is accurate enough and/or the HUD is simple enough.
*
*	  8-Now save the final image as "UIMask.png" in your textures folder and you're done!
*   
*   There really isnt much of a difference with AdvancedUIMask, the name of the file however should
*   correspond to the mask number, so for example: 
*   Mask One = AdvancedUIMaskOne.png or Mask Two = AdvancedUIMaskTwo.png 
*/  
//=======================================================================================================

#ifndef AdvancedUIMask_Amount               // How many mask images to use. Each comes with their own
    #define AdvancedUIMask_Amount 0        // PixelCoord and PixelRGB tables.
#endif                                      // [0 - 5]

#ifndef AdvancedUIMask_JustDetectUI         // Enables a table to just detect UI and if found disable
    #define AdvancedUIMask_JustDetectUI 0   // all shaders inbetween Before and After, no UIMask
#endif                                      // [0 - 1]

#ifndef AdvancedUIMask_Invert               // Inverts the masks, so black is masked space and white is
    #define AdvancedUIMask_Invert 0         // unmasked space
#endif                                      // [0 - 1]

#ifndef AdvancedUIMask_Combine              // Smart masks which only apply when pixels are detected, or
    #define AdvancedUIMask_Combine 0        // smart masks and disable shaders when no pixels detected
#endif                                      // [0 - 1]

#ifndef AdvancedUIMask_RGBMasks             // Uses Red, Green, and Blue components of a image for masks
    #define AdvancedUIMask_RGBMasks 0       // allowing a single mask image to be 3 masks
#endif                                      // [0 - 1]

//=======================================================================================================

#if (AdvancedUIMask_JustDetectUI == 1)
    #define DetectionJustUI 36

    static const float3 JustUIPixelCoord[DetectionJustUI] =
    {
        //----------------Black Screen----------------//
        float3(0,0,2),              //Top Left
        float3(49,0,2),             //Top Left
        float3(0,49,2),             //Top Left
        //                                            //
        float3(1919,0,2),           //Top Right
        float3(1869,0,2),           //Top Right
        float3(1919,49,2),          //Top Right
        //                                            //
        float3(0,1079,2),           //Bottom Left
        float3(0,1029,2),           //Bottom Left
        float3(49,1079,2),          //Bottom Left
        //                                            //
        float3(1919,1079,2),        //Bottom Right
        float3(1919,1029,2),        //Bottom Right
        float3(1869,1079,2),        //Bottom Right
        //----------------White Screen----------------//
        float3(0,0,3),              //Top Left
        float3(49,0,3),             //Top Left
        float3(0,49,3),             //Top Left
        //                                            //
        float3(1919,0,3),           //Top Right
        float3(1869,0,3),           //Top Right
        float3(1919,49,3),          //Top Right
        //                                            //
        float3(0,1079,3),           //Bottom Left
        float3(0,1029,3),           //Bottom Left
        float3(49,1079,3),          //Bottom Left
        //                                            //
        float3(1919,1079,3),        //Bottom Right
        float3(1919,1029,3),        //Bottom Right
        float3(1869,1079,3),        //Bottom Right
        //--------------------------------------------//
    };

    static const float3 JustUIPixelRGB[DetectionJustUI] =
    {
        //----------------Black Screen----------------//
        float3(0,0,0),              //Top Left
        float3(0,0,0),              //Top Left
        float3(0,0,0),              //Top Left
        //                                            //
        float3(0,0,0),              //Top Right
        float3(0,0,0),              //Top Right
        float3(0,0,0),              //Top RIght
        //                                            //
        float3(0,0,0),              //Bottom Left
        float3(0,0,0),              //Bottom Left
        float3(0,0,0),              //Bottom Left
        //                                            //
        float3(0,0,0),              //Bottom Right
        float3(0,0,0),              //Bottom Right
        float3(0,0,0),              //Bottom Right
        //----------------White Screen----------------//
        float3(255,255,255),        //Top Left
        float3(255,255,255),        //Top Left
        float3(255,255,255),        //Top Left
        //                                            //
        float3(255,255,255),        //Top Right
        float3(255,255,255),        //Top Right
        float3(255,255,255),        //Top RIght
        //                                            //
        float3(255,255,255),        //Bottom Left
        float3(255,255,255),        //Bottom Left
        float3(255,255,255),        //Bottom Left
        //                                            //
        float3(255,255,255),        //Bottom Right
        float3(255,255,255),        //Bottom Right
        float3(255,255,255),        //Bottom Right
        //--------------------------------------------//
    };
#endif
#if (AdvancedUIMask_Amount >= 1)
    #define DetectionOnePixelNumber 12

    static const float3 OnePixelCoord[DetectionOnePixelNumber] = 
    {
        //--------------------------------------------//
        float3(0,0,1),
        //--------------------------------------------//
    };

    static const float3 OnePixelRGB[DetectionOnePixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,0),
        //--------------------------------------------//
    };
#endif
#if (AdvancedUIMask_Amount >= 2)
    #define DetectionTwoPixelNumber 1

    static const float3 TwoPixelCoord[DetectionTwoPixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,1),
        //--------------------------------------------//
    };

    static const float3 TwoPixelRGB[DetectionTwoPixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,0),
        //--------------------------------------------//
    };
#endif
#if (AdvancedUIMask_Amount >= 3)
    #define DetectionThreePixelNumber 1

    static const float3 ThreePixelCoord[DetectionThreePixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,1),
        //--------------------------------------------//
    };

    static const float3 ThreePixelRGB[DetectionThreePixelNumber] = 
    {
        //--------------------------------------------//
        float3(0,0,0),
        //--------------------------------------------//
    };
#endif
#if (AdvancedUIMask_Amount >= 4)
    #define DetectionFourPixelNumber 1

    static const float3 FourPixelCoord[DetectionFourPixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,1),
        //--------------------------------------------//
    };

    static const float3 FourPixelRGB[DetectionFourPixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,0),
        //--------------------------------------------//
    };
#endif
#if (AdvancedUIMask_Amount >= 5)
    #define DetectionFivePixelNumber 1

    static const float3 FivePixelCoord[DetectionFivePixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,1),
        //--------------------------------------------//
    };

    static const float3 FivePixelRGB[DetectionFivePixelNumber] =
    {
        //--------------------------------------------//
        float3(0,0,0),
        //--------------------------------------------//
    };
#endif