//=======================================================================================================
// AdvancedUIMask by FoG
// Version - 1.0
//=======================================================================================================

#include "ReShade.fxh"
#include "ReShadeUI.fxh"
#include "AdvancedUIMask.fxh"

//=======================================================================================================

uniform int infotext<
	ui_label = " ";
    ui_text =
		"Note:\n"
        "AdvancedUIMask is configured by editing the file\n"
        "AdvancedUIMask.fxh.";
	ui_type = "radio";
>;

//=======================================================================================================

texture texOriginalColor { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler OriginalColor { Texture = texOriginalColor; };

#if (AdvancedUIMask_JustDetectUI == 1)
    texture texJustDetectUI { Width = 1; Height = 1; Format = R8; };
    sampler JustDetectUI { Texture = texJustDetectUI; };
#endif
#if (AdvancedUIMask_Amount >= 1)
    texture texDetectUIOne { Width = 1; Height = 1; Format = R8; };
    sampler DetectUIOne { Texture = texDetectUIOne; };

    #if (AdvancedUIMask_RGBMasks == 0)
        texture texAUIMaskOne <source="AdvancedUIMaskOne.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R8; };
    #elif (AdvancedUIMask_RGBMasks == 1)
        texture texAUIMaskOne <source="AdvancedUIMaskOne.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };
    #endif
    sampler AUIMaskOne { Texture = texAUIMaskOne; };
#endif
#if (AdvancedUIMask_Amount >= 2)
    texture texDetectUITwo { Width = 1; Height = 1; Format = R8; };
    sampler DetectUITwo { Texture = texDetectUITwo; };

    #if (AdvancedUIMask_RGBMasks == 0)
        texture texAUIMaskTwo <source="AdvancedUIMaskTwo.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R8; };
    #elif (AdvancedUIMask_RGBMasks == 1)
        texture texAUIMaskTwo <source="AdvancedUIMaskTwo.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };
    #endif
    sampler AUIMaskTwo { Texture = texAUIMaskTwo; };
#endif
#if (AdvancedUIMask_Amount >= 3)
    texture texDetectUIThree { Width = 1; Height = 1; Format = R8; };
    sampler DetectUIThree { Texture = texDetectUIThree; };

    #if (AdvancedUIMask_RGBMasks == 0)
        texture texAUIMaskThree <source="AdvancedUIMaskThree.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R8; };
    #elif (AdvancedUIMask_RGBMasks == 1)
        texture texAUIMaskThree <source="AdvancedUIMaskThree.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };
    #endif
    sampler AUIMaskThree { Texture = texAUIMaskThree; };
#endif
#if (AdvancedUIMask_Amount >= 4)
    texture texDetectUIFour { Width = 1; Height = 1; Format = R8; };
    sampler DetectUIFour { Texture = texDetectUIFour; };

    #if (AdvancedUIMask_RGBMasks == 0)
        texture texAUIMaskFour <source="AdvancedUIMaskFour.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R8; };
    #elif (AdvancedUIMask_RGBMasks == 1)
        texture texAUIMaskFour <source="AdvancedUIMaskFour.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };
    #endif
    sampler AUIMaskFour { Texture = texAUIMaskFour; };
#endif
#if (AdvancedUIMask_Amount >= 5)
    texture texDetectUIFive { Width = 1; Height = 1; Format = R8; };
    sampler DetectUIFive { Texture = texDetectUIFive; };

    #if (AdvancedUIMask_RGBMasks == 0)
        texture texAUIMaskFive <source="AdvancedUIMaskFive.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R8; };
    #elif (AdvancedUIMask_RGBMasks == 1)
        texture texAUIMaskFive <source="AdvancedUIMaskFive.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };
    #endif
    sampler AUIMaskFive { Texture = texAUIMaskFive; };
#endif

//=======================================================================================================

#if (AdvancedUIMask_JustDetectUI == 1)
    float4 AdvancedUIMask_OnlyUIDetect(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
        float3 pixelColor, uiPixelColor, difference;
        float2 pixelCoord;
        float ui = 1;
        bool UIDetected = false;
        bool UINext = false;

        for (int i = 0; i < DetectionJustUI; i++) {
            [branch]
            if (JustUIPixelCoord[i].z - ui == 0) {
                if (UINext == false) {
                    pixelCoord = float2(JustUIPixelCoord[i].x + 0.5, JustUIPixelCoord[i].y + 0.5) * BUFFER_PIXEL_SIZE;
                    pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
                    uiPixelColor = JustUIPixelRGB[i].rgb;
                    difference = pixelColor - uiPixelColor;
                    if (!any(difference)) {
                        UIDetected = true;
                    }
                    else {
                        UIDetected = false;
                        UINext = true;
                    }
                }
            }
            else {
                if (UIDetected == true) {
                    return ui * 0.1;
                }
                else {
                    ui += 1;
                    UINext = false;
                    i -= 1;
                }
            }
        }
        return UIDetected * ui * 0.1;
    }
#endif
#if (AdvancedUIMask_Amount >= 1)
    float4 AUIMask_DetectUIOne(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
        float3 pixelColor, uiPixelColor, difference;
        float2 pixelCoord;
        float ui = 1;
        bool UIDetected = false;
        bool UINext = false;

        for (int i = 0; i < DetectionOnePixelNumber; i++) {
            [branch]
            if (OnePixelCoord[i].z - ui == 0) {
                if (UINext == false) {
                    pixelCoord = float2(OnePixelCoord[i].x + 0.5, OnePixelCoord[i].y + 0.5) * BUFFER_PIXEL_SIZE;
                    pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
                    uiPixelColor = OnePixelRGB[i].rgb;
                    difference = pixelColor - uiPixelColor;
                    if (!any(difference)) {
                        UIDetected = true;
                    }
                    else {
                        UIDetected = false;
                        UINext = true;
                    }
                }
            }
            else {
                if (UIDetected == true) {
                    return ui * 0.1;
                }
                else {
                    ui += 1;
                    UINext = false;
                    i -= 1;
                }
            }
        }
        return UIDetected * ui * 0.1;
    }
#endif
#if (AdvancedUIMask_Amount >= 2)
    float4 AUIMask_DetectUITwo(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
        float3 pixelColor, uiPixelColor, difference;
        float2 pixelCoord;
        float ui = 1;
        bool UIDetected = false;
        bool UINext = false;

        for (int i = 0; i < DetectionTwoPixelNumber; i++) {
            [branch]
            if (TwoPixelCoord[i].z - ui == 0) {
                if (UINext == false) {
                    pixelCoord = float2(TwoPixelCoord[i].x + 0.5, TwoPixelCoord[i].y + 0.5) * BUFFER_PIXEL_SIZE;
                    pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
                    uiPixelColor = TwoPixelRGB[i].rgb;
                    difference = pixelColor - uiPixelColor;
                    if (!any(difference)) {
                        UIDetected = true;
                    }
                    else {
                        UIDetected = false;
                        UINext = true;
                    }
                }
            }
            else {
                if (UIDetected == true) {
                    return ui * 0.1;
                }
                else {
                    ui += 1;
                    UINext = false;
                    i -= 1;
                }
            }
        }
        return UIDetected * ui * 0.1;
    }
#endif
#if (AdvancedUIMask_Amount >= 3)
    float4 AUIMask_DetectUIThree(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
        float3 pixelColor, uiPixelColor, difference;
        float2 pixelCoord;
        float ui = 1;
        bool UIDetected = false;
        bool UINext = false;

        for (int i = 0; i < DetectionThreePixelNumber; i++) {
            [branch]
            if (ThreePixelCoord[i].z - ui == 0) {
                if (UINext == false) {
                    pixelCoord = float2(ThreePixelCoord[i].x + 0.5, ThreePixelCoord[i].y + 0.5) * BUFFER_PIXEL_SIZE;
                    pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
                    uiPixelColor = ThreePixelRGB[i].rgb;
                    difference = pixelColor - uiPixelColor;
                    if (!any(difference)) {
                        UIDetected = true;
                    }
                    else {
                        UIDetected = false;
                        UINext = true;
                    }
                }
            }
            else {
                if (UIDetected == true) {
                    return ui * 0.1;
                }
                else {
                    ui += 1;
                    UINext = false;
                    i -= 1;
                }
            }
        }
        return UIDetected * ui * 0.1;
    }
#endif
#if (AdvancedUIMask_Amount >= 4)
    float4 AUIMask_DetectUIFour(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
        float3 pixelColor, uiPixelColor, difference;
        float2 pixelCoord;
        float ui = 1;
        bool UIDetected = false;
        bool UINext = false;

        for (int i = 0; i < DetectionFourPixelNumber; i++) {
            [branch]
            if (FourPixelCoord[i].z - ui == 0) {
                if (UINext == false) {
                    pixelCoord = float2(FourPixelCoord[i].x + 0.5, FourPixelCoord[i].y + 0.5) * BUFFER_PIXEL_SIZE;
                    pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
                    uiPixelColor = FourPixelRGB[i].rgb;
                    difference = pixelColor - uiPixelColor;
                    if (!any(difference)) {
                        UIDetected = true;
                    }
                    else {
                        UIDetected = false;
                        UINext = true;
                    }
                }
            }
            else {
                if (UIDetected == true) {
                    return ui * 0.1;
                }
                else {
                    ui += 1;
                    UINext = false;
                    i -= 1;
                }
            }
        }
        return UIDetected * ui * 0.1;
    }
#endif
#if (AdvancedUIMask_Amount >= 5)
    float4 AUIMask_DetectUIFive(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
        float3 pixelColor, uiPixelColor, difference;
        float2 pixelCoord;
        float ui = 1;
        bool UIDetected = false;
        bool UINext = false;

        for (int i = 0; i < DetectionFivePixelNumber; i++) {
            [branch]
            if (FivePixelCoord[i].z - ui == 0) {
                if (UINext == false) {
                    pixelCoord = float2(FivePixelCoord[i].x + 0.5, FivePixelCoord[i].y + 0.5) * BUFFER_PIXEL_SIZE;
                    pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
                    uiPixelColor = FivePixelRGB[i].rgb;
                    difference = pixelColor - uiPixelColor;
                    if (!any(difference)) {
                        UIDetected = true;
                    }
                    else {
                        UIDetected = false;
                        UINext = true;
                    }
                }
            }
            else {
                if (UIDetected == true) {
                    return ui * 0.1;
                }
                else {
                    ui += 1;
                    UINext = false;
                    i -= 1;
                }
            }
        }
        return UIDetected * ui * 0.1;
    }
#endif

float4 StoreOriginalColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
    return tex2D(ReShade::BackBuffer, texcoord);
}

float4 RestoreColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {
    float ui = 0;
    float mask = 0;
    float counter = 0;
    float3 MaskRGB;

    #if (AdvancedUIMask_Invert == 0)
        float4 colorOriginal = tex2D(OriginalColor, texcoord);
        float4 color = tex2D(ReShade::BackBuffer, texcoord);
    #elif (AdvancedUIMask_Invert == 1)
        float4 color = tex2D(OriginalColor, texcoord);
        float4 colorOriginal = tex2D(ReShade::BackBuffer, texcoord);
    #endif

    #if (AdvancedUIMask_JustDetectUI == 1)
        ui = tex2D(JustDetectUI, float2(0, 0)).x;
        if (ui != 0) {
            color = colorOriginal;
            return color;
        };
    #endif
    
    #if (AdvancedUIMask_Amount >= 1)
        ui = tex2D(DetectUIOne, float2(0, 0)).x;
        #if (AdvancedUIMask_RGBMasks == 0)
        if (ui != 0) {
            mask = tex2D(AUIMaskOne, texcoord).r;
            color = lerp(color, colorOriginal, mask);
        }
        #elif (AdvancedUIMask_RGBMasks == 1)
        MaskRGB = 1 - tex2D(AUIMaskOne, texcoord).rgb;
        if (ui > .39) {
            return color;
        }
        else if (ui > .29) {
            mask = MaskRGB.b;
        }
        else if (ui > .19) {
            mask = MaskRGB.g;
        }
        else if (ui > .09) {
            mask = MaskRGB.r;
        }
        #endif
        else {
            counter += 1;
        };
        #if (AdvancedUIMask_RGBMasks == 1)
            if (ui != 0) {
                color.rgb = lerp(colorOriginal.rgb, color.rgb, mask);
            };
        #endif
    #endif
    #if (AdvancedUIMask_Amount >= 2)
        ui = tex2D(DetectUITwo, float2(0, 0)).x;
        #if (AdvancedUIMask_RGBMasks == 0)
            if (ui != 0) {
                mask = tex2D(AUIMaskTwo, texcoord).r;
                color = lerp(color, colorOriginal, mask);
            }
        #elif (AdvancedUIMask_RGBMasks == 1)
            MaskRGB = 1 - tex2D(AUIMaskTwo, texcoord).rgb;
            if (ui > .39) {
                return color;
            }
            else if (ui > .29) {
                mask = MaskRGB.b;
            }
            else if (ui > .19) {
                mask = MaskRGB.g;
            }
            else if (ui > .09) {
                mask = MaskRGB.r;
            }
        #endif
        else {
            counter += 1;
        };
        #if (AdvancedUIMask_RGBMasks == 1)
            if (ui != 0) {
                color.rgb = lerp(colorOriginal.rgb, color.rgb, mask);
            };
        #endif
    #endif
    #if (AdvancedUIMask_Amount >= 3)
        ui = tex2D(DetectUIThree, float2(0, 0)).x;
        #if (AdvancedUIMask_RGBMasks == 0)
            if (ui != 0) {
                mask = tex2D(AUIMaskThree, texcoord).r;
                color = lerp(color, colorOriginal, mask);
            }
        #elif (AdvancedUIMask_RGBMasks == 1)
            MaskRGB = 1 - tex2D(AUIMaskThree, texcoord).rgb;
            if (ui > .39) {
                return color;
            }
            else if (ui > .29) {
                mask = MaskRGB.b;
            }
            else if (ui > .19) {
                mask = MaskRGB.g;
            }
            else if (ui > .09) {
                mask = MaskRGB.r;
            }
        #endif
        else {
            counter += 1;
        };
        #if (AdvancedUIMask_RGBMasks == 1)
            if (ui != 0) {
                color.rgb = lerp(colorOriginal.rgb, color.rgb, mask);
            };
        #endif
    #endif
    #if (AdvancedUIMask_Amount >= 4)
        ui = tex2D(DetectUIFour, float2(0, 0)).x;
        #if (AdvancedUIMask_RGBMasks == 0)
            if (ui != 0) {
                mask = tex2D(AUIMaskFour, texcoord).r;
                color = lerp(color, colorOriginal, mask);
            }
        #elif (AdvancedUIMask_RGBMasks == 1)
            MaskRGB = 1 - tex2D(AUIMaskThree, texcoord).rgb;
            if (ui > .39) {
                return color;
            }
            else if (ui > .29) {
                mask = MaskRGB.b;
            }
            else if (ui > .19) {
                mask = MaskRGB.g;
            }
            else if (ui > .09) {
                mask = MaskRGB.r;
            }
        #endif
        else {
            counter += 1;
        };
        #if (AdvancedUIMask_RGBMasks == 1)
            if (ui != 0) {
                color.rgb = lerp(colorOriginal.rgb, color.rgb, mask);
            };
        #endif
    #endif
    #if (AdvancedUIMask_Amount >= 5)
        ui = tex2D(DetectUIFive, float2(0, 0)).x;
        #if (AdvancedUIMask_RGBMasks == 0)
            if (ui != 0) {
                mask = tex2D(AUIMaskFive, texcoord).r;
                color = lerp(color, colorOriginal, mask);
            }
        #elif (AdvancedUIMask_RGBMasks == 1)
            MaskRGB = 1 - tex2D(AUIMaskThree, texcoord).rgb;
            if (ui > .39) {
                return color;
            }
            else if (ui > .29) {
                mask = MaskRGB.b;
            }
            else if (ui > .19) {
                mask = MaskRGB.g;
            }
            else if (ui > .09) {
                mask = MaskRGB.r;
            }
        #endif
        else {
            counter += 1;
        };
        #if (AdvancedUIMask_RGBMasks == 1)
            if (ui != 0) {
                color.rgb = lerp(colorOriginal.rgb, color.rgb, mask);
            };
        #endif
    #endif

    #if (AdvancedUIMask_Combine == 1)
        if (counter >= AdvancedUIMask_Amount) {
            color = colorOriginal;
        };
    #endif

    return color;
}

//=======================================================================================================

technique AdvancedUIMask
{
    #if (AdvancedUIMask_JustDetectUI == 1)
        pass
        {
            VertexShader = PostProcessVS;
            PixelShader = AdvancedUIMask_OnlyUIDetect;
            RenderTarget = texJustDetectUI;
            ClearRenderTargets = true;
        }
    #endif
    #if (AdvancedUIMask_Amount >= 1)
        pass
        {
            VertexShader = PostProcessVS;
            PixelShader = AUIMask_DetectUIOne;
            RenderTarget = texDetectUIOne;
            ClearRenderTargets = true;
        }
    #endif
    #if (AdvancedUIMask_Amount >= 2)
        pass
        {
            VertexShader = PostProcessVS;
            PixelShader = AUIMask_DetectUITwo;
            RenderTarget = texDetectUITwo;
            ClearRenderTargets = true;
        }
    #endif
    #if (AdvancedUIMask_Amount >= 3)
        pass
        {
            VertexShader = PostProcessVS;
            PixelShader = AUIMask_DetectUIThree;
            RenderTarget = texDetectUIThree;
            ClearRenderTargets = true;
        }
    #endif
    #if (AdvancedUIMask_Amount >= 4)
        pass
        {
            VertexShader = PostProcessVS;
            PixelShader = AUIMask_DetectUIFour;
            RenderTarget = texDetectUIFour;
            ClearRenderTargets = true;
        }
    #endif
    #if (AdvancedUIMask_Amount >= 5)
        pass
        {
            VertexShader = PostProcessVS;
            PixelShader = AUIMask_DetectUIFive;
            RenderTarget = texDetectUIFive;
            ClearRenderTargets = true;
        }
    #endif
}

technique AdvancedUIMask_RTGI_Bloom
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = StoreOriginalColor;
        RenderTarget = texOriginalColor;
        ClearRenderTargets = true;
    }
}

technique AdvancedUIMask_AfterRTGI_Bloom
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = RestoreColor;
        ClearRenderTargets = true;
    }
}
