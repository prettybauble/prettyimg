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
  PngChunkKind* = enum
    pcIHDR = "IHDR",  ## 13 bytes total. must be the first chunk.
    pcPLTE = "PLTE",  ## contains the palette: a list of colors.
    pcIDAT = "IDAT",  ## contains the image, which may be split among multiple IDAT chunks.
    pcIEND = "IEND",  ## marks the image end
    pcbKGD = "bKGD",  ## Contains default background color
    pccHRM = "cHRM",  ## gives the chromaticity coordinates of the display primaries and white point.
    pcdSIG = "dSIG",  ## is for storing digital signatures.
    pceXIF = "eXIF",  ## stores Exif metadata.
    pcgAMA = "gAMA",  ## specifies gamma. The gAMA chunk contains only 4 bytes.
    pchIST = "hIST",  ## can store the histogram, or total amount of each color in the image.
    pciCCP = "iCCP",  ## is an ICC color profile.
    pciTXt = "iTXt",  ## contains a keyword and UTF-8 text, with encodings for possible compression and translations marked with language tag.
    pcpHYs = "pHYs",  ## holds the intended pixel size (or pixel aspect ratio)
    pcsBIT = "sBIT",  ## (significant bits) indicates the color-accuracy of the source data
    pcsPLT = "sPLT",  ## suggests a palette to use if the full range of colors is unavailable.
    pcsRGB = "sRGB",  ## indicates that the standard sRGB color space is used
    pcsTER = "sTER",  ## stereo-image indicator chunk for stereoscopic images.
    pctEXt = "tEXt",  ## can store text that can be represented in ISO/IEC 8859-1
    pctIME = "tIME",  ## stores the time that the image was last changed.
    pctRNS = "tRNS",  ## contains transparency information
    pczTXt = "zTXt"  ## contains compressed text (and a compression method marker) with the same limits as `tEXt`.
  IcoKind* = enum
    ikIco = 1,
    ikCur = 2
{.pop.}
