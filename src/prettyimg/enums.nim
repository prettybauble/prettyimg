# author: Ethosa

{.push pure.}
type
  BitmapCompression* = enum
    bmBiRGB,  ## Most common
    bmBiRLE8,  ## Can be used only with 8-bit/pixel bitmaps
    bmBiRLE4,  ## Can be used only with 4-bit/pixel bitmaps
    bmBiBITFIELDS,  ## BITMAPV2INFOHEADER: RGB bit field masks, BITMAPV3INFOHEADER+: RGBA
    bmBiJPEG,  ## BITMAPV4INFOHEADER+: JPEG image for printing
    bmBiPNG,  ## BITMAPV4INFOHEADER+: PNG image for printing
    bmBiALPHABITFIELDS,  ## only Windows CE 5.0 with .NET 4.0 or later
    bmBiCMYK,  ## only Windows Metafile CMYK
    bmBiCMYKRLE8,  ## only Windows Metafile CMYK
    bmBiCMYKRLE4,  ## only Windows Metafile CMYK
{.pop.}
