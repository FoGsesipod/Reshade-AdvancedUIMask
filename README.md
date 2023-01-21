# Reshade-AdvancedUIMask
UIDetect and UIMask in one, upgraded with more features.

For use I recommend reading UIDetect and UIMask's descriptions, as AdvancedUIMask basically combines both, and uses the exact same methods they do.
---

AdvancedUIMask uses UIDetects pixel detection and UIMasks masking methods in order to produce a all in one shader for all your UI needs, you can enable up to 5 masking images to use, each with there own pixel detection conditions, and you can enable RGB masks to get a total of 15 different conditions and masks. There is also a combined mode that makes it so when pixels are detected masks are applied, and when they are not detected it disables shaders. Like UIDetect it has a invert, and lastly has a specific table for overriding all options and just disabling shaders (useful for black screens or white screens, where you dont want masks and want to get rid of depth based effects).

Configuration is mainly handled in the AdvancedUIMask.fxh file, while enabling different functions is done via preprocessor definitions.
