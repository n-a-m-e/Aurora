#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

#libraries for ZebraZC300Printer
chmod +x /usr/lib/cups/filter/rastertojg
chmod +x /usr/lib/cups/filter/pdftojgpdf
chmod +x /usr/lib64/libtinyxml.so.2.6.2
chmod +x /usr/lib64/libzmjxml.so
chmod +x /usr/lib64/libudev_64bit.so.1

cat <<'EOF' > "/usr/share/cups/model/ZebraZC300Printer.ppd"
*PPD-Adobe: "4.3"
*%
*% Zebra Jaguar Card Printer PPD for Common UNIX Printing System (CUPS).
*% Zebra Technologies
*% 

*FormatVersion: "4.3"
*FileVersion: "1.0.0.1"
*PCFileName: "ZC300.PPD"
*Product: "(Card Printer)"
*LanguageVersion: English
*LanguageEncoding: ISOLatin1
*Manufacturer: "Zebra"
*ModelName: "ZC300"
*ShortNickName: "ZC300"
*NickName: "ZC300"
*PSVersion: "(3010.000) 550"
*LanguageLevel: "2"
*ColorDevice: True
*DefaultColorSpace: RGB
*FileSystem: False
*Throughput: "3"
*LandscapeOrientation: Any
*TTRasterizer: Type42
*cupsModelNumber: "1"
*Product: "(Card Printer)"
*VariablePaperSize: False
*cupsVersion: 1.4
*cupsModelNumber: "1"
*cupsManualCopies: False

*cupsPreFilter:"application/pdf 10 /usr/lib/cups/filter/pdftojgpdf"
*cupsFilter: "application/vnd.cups-raster 50 /usr/lib/cups/filter/rastertojg"

*% Changeable only through the command line or by application interfaces.
*Copies: 1

*EnableLog: 0
*EachDayLogFile: 0
*Separator:"|"
*FileName:"ZTCLog"
*StaticText:""
*Time: 0
*Date: 0
*SerialNumber: 0
*IPAddress: 0
*UserName: 0
*JobID: 0
*MTrack1: 0
*MTrack2: 0
*MTrack3: 0
*PrinterSerialNo:""
*PrinterIPAddress:""
*SettingsChanged:0
*RibbonChanged:0

*MagEncoderVerification:1
*CardTypeNo:1
*MagHex:0
*PrintAndEncodeOnSameSide:0

*%***********YMCOptimization*********%*
*Brightness:0
*Contrast:0
*SharpFilter:2
*PreHeat:0
*IntensityYellow:100
*IntensityMagenta:100
*IntensityCyan:100
*IntensityKDye:100
*YMCRatio:1
*%*****************KOptimzation****************%*
*%MonochromeConversion:0
*%ThresholdK:128
*%BrightnessK:0
*%ContrastK:0
*%PreheatK:0
*%IntensityK:0
*%MonoOpt:0

*%*****************Front KOptimzation****************%*
*FrontMonochromeConversion:1
*FrontThresholdK:128
*FrontBrightnessK:0
*FrontContrastK:0
*FrontPreheatK:0
*FrontIntensityK:100
*FrontOptK:2
*%*****************Back KOptimzation****************%*
*BackMonochromeConversion:1
*BackThresholdK:128
*BackBrightnessK:0
*BackContrastK:0
*BackPreheatK:0
*BackIntensityK:100
*BackOptK:2

*%********************** Overlay Extraction******************%*
*FrontOvType:1
*FrontOvBMP:""
*FrontOvRotate:0
*FrontOvInvert:0
*FrontOvIntensity:0
*BackOvType:1
*BackOvBMP:""
*BackOvRotate:0
*BackOvInvert:0
*BackOvIntensity:0

*%********************** Laminate settings ******************%*
*FrontLType:1
*FrontLBMP:""
*FrontLRotate:0
*FrontLInvert:0
*FrontLIntensity:100
*BackLType:1
*BackLBMP:""
*BackLRotate:0
*BackLInvert:0
*BackLIntensity:100
*%********************** Sr Extraction******************%*
*FrontSrType:5
*FrontSrBMP:""
*FrontSrIntensity:100
*BackSrType:5
*BackSrBMP:""
*BackSrIntensity:100
*%********************** P Extraction******************%*
*FrontPType:5
*FrontPBMP:""
*FrontPRotate:0
*FrontPInvert:0
*BackPType:5
*BackPBMP:""
*BackPRotate:0
*BackPInvert:0
*%********************** K Extraction******************%*
*FrontKType:9
*FrontRextract:0
*FrontGextract:0
*FrontBextract:0
*BackKType:9
*BackRextract:0
*BackGextract:0
*BackBextract:0
*%********************** Half panel******************%*
*FrontHalfType:0
*FrontOffset:0
*FrontColorThreshold:10
*BackHalfType:0
*BackOffset:0
*BackColorThreshold:10
*%***************************************

*%********************** Custom Encoding ******************%*
*Track1Type:0
*Track1Density:1
*Track1ChrSize:4
*Track1LRC:0
*Track1Start:"%"
*Track1SentinelOffset:0
*Track1End:"?"

*Track2Type:0
*Track2Density:0
*Track2ChrSize:2
*Track2LRC:0
*Track2Start:";"
*Track2SentinelOffset:0
*Track2End:"?"

*Track3Type:0
*Track3Density:1
*Track3ChrSize:2
*Track3LRC:0
*Track3Start:";"
*Track3SentinelOffset:0
*Track3End:"?"
*%***************************************%*

*OpenGroup: CardOptions/Card Setup

*OpenUI *CardSource/Card Source: PickOne
*OrderDependency: 10 AnySetup *CardSource
*DefaultCardSource: 1Feeder
*CardSource 0Manual/Manual Feed Slot: ""
*CardSource 1Feeder/Input Hopper: ""
*CardSource 3Auto/Auto feed: ""
*CardSource 2InPrinter/Already in printer: ""
*CloseUI: *CardSource

*OpenUI *CardDestination/Card Destination: PickOne
*OrderDependency: 10 AnySetup *CardDestination
*DefaultCardDestination: 0Hopper
*CardDestination 0Hopper/Output hopper: ""
*CardDestination 1Reject/Reject tray: ""
*CardDestination 2InPrinter/Leave in printer:""
*CloseUI: *CardDestination

*OpenUI *ImageSize/Image Size: PickOne
*OrderDependency: 10 AnySetup *ImageSize
*DefaultImageSize: 0Default
*ImageSize 0Default/Default size (1006 x 640 pixels): "<</PageSize[241.5 153.6]/ImagingBBox null>>setpagedevice"
*%ImageSize 1Compatibility/ZXP S3 Compatibility (1024 x 640 pixels):"<</PageSize[245.8 153.6]/ImagingBBox null>>setpagedevice"
*%ImageSize 2Compatibility/ZXP S9 Compatibility (1024 x 648 pixels):"<</PageSize[245.8 155.5]/ImagingBBox null>>setpagedevice"
*CloseUI: *ImageSize

*OpenUI *PageSize: PickOne
*OrderDependency: 10 AnySetup *PageSize
*DefaultPageSize: CR80
*PageSize CR80/CR80: "<</PageSize[241.5 153.6]/ImagingBBox null>>setpagedevice"
*PageSize CR81/CR81: "<</PageSize[245.8 153.6]/ImagingBBox null>>setpagedevice"
*PageSize CR82/CR82: "<</PageSize[245.8 155.5]/ImagingBBox null>>setpagedevice"
*CloseUI: *PageSize

*OpenUI *PageRegion: PickOne
*OrderDependency: 10 AnySetup *PageRegion
*DefaultPageRegion: CR80
*PageRegion CR80/CR80: "<</PageSize[241.5 153.6]/ImagingBBox null >>setpagedevice"
*PageRegion CR81/CR81: "<</PageSize[245.8 153.6]/ImagingBBox null >>setpagedevice"
*PageRegion CR82/CR82: "<</PageSize[245.8 155.5]/ImagingBBox null >>setpagedevice"
*CloseUI: *PageRegion

*DefaultImageableArea: CR80
*ImageableArea CR80/CR80: "0 0 241.5 153.6"
*ImageableArea CR81/CR81: "0 0 245.8 153.6"
*ImageableArea CR82/CR82: "0 0 245.8 155.5"

*DefaultPaperDimension: CR80
*PaperDimension CR80/CR80: "241.5 153.6"
*PaperDimension CR81/CR81: "245.8 153.6"
*PaperDimension CR82/CR82: "245.8 155.5"

*RequiresPageRegion All: true

*OpenUI *DualSidePrinting/Print On Both Sides: PickOne
*OrderDependency: 10 AnySetup *DualSidePrinting
*DefaultDualSidePrinting: 1true
*DualSidePrinting 0false/No: ""
*DualSidePrinting 1true/Yes: ""
*CloseUI: *DualSidePrinting

*OpenUI *Orientation/Orientation: PickOne
*OrderDependency: 10 AnySetup *Orientation
*DefaultOrientation: 0Landscape
*Orientation 0Landscape/Landscape: "setpagedevice"
*Orientation 1Portrait/Portrait: "setpagedevice"
*CloseUI: *Orientation

*OpenUI *Rotation/Rotate 180 Degree: PickOne
*OrderDependency: 10 AnySetup *Rotation
*DefaultRotation: 0None
*Rotation 0None/None: "setpagedevice"
*Rotation 1Front/Front: "setpagedevice"
*Rotation 2Back/Back: "setpagedevice"
*Rotation 3Both/Both: "setpagedevice"
*CloseUI: *Rotation

*OpenUI *PrintFrontimageOnBackSide/Print front image on back Side: PickOne
*OrderDependency: 10 AnySetup *PrintFrontimageOnBackSide
*DefaultPrintFrontimageOnBackSide: 0no
*PrintFrontimageOnBackSide 0no/No: ""
*PrintFrontimageOnBackSide 1yes/Yes: ""
*CloseUI: *PrintFrontimageOnBackSide

*OpenUI *ColorMatching/Color Matching: PickOne
*OrderDependency: 10 AnySetup *ColorMatching
*DefaultColorMatching: System
*ColorMatching System/System Color Management: "<</cupsColorOrder 0/cupsColorSpace 1/cupsBitsPerColor 8/HWResolution[300 300]>>setpagedevice"
*CloseUI: *ColorMatching

*% -----------------------------------------------------------------------*%
*% --------------------Ribbon Information Page----------------------------*%
*% -----------------------------------------------------------------------*%

*OpenUI *RibbonName/Ribbon Name: PickOne
*OrderDependency: 10 AnySetup *RibbonName
*DefaultRibbonName: 0YMCKO

*RibbonName 0YMCKO/YMCKO:""
*RibbonName 1YMCKOK/YMCKOK:""
*RibbonName 2HalfYMCKO/1/2 YMCKO:""
*RibbonName 3HalfYMCKOKO/1/2 YMCKOKO:""
*RibbonName 4YMCPKO/YMCPKO:""
*RibbonName 5KdO/KdO:""
*RibbonName 6KrO/KrO:""
*RibbonName 7Black/Black:""
*RibbonName 8White/White:""
*RibbonName 9Red/Red:""
*RibbonName 10Blue/Blue:""
*RibbonName 11Gold/Gold:""
*RibbonName 12Silver/Silver:""
*RibbonName 13YMCKLL/YMCKLL:""
*RibbonName 14SDYMCKO/SDYMCKO:""
*RibbonName 15Hologram/Hologram:""
*CloseUI: *RibbonName

*OpenUI *RibbonCombination/Ribbon Combination: PickOne
*OrderDependency: 10 AnySetup *RibbonCombination
*DefaultRibbonCombination: 2FrontYmcoBackK

*RibbonCombination 0FrontYmcko/Front YMCKO:""
*RibbonCombination 1FrontYmckoBackYmcko/Front YMCKO, Back YMCKO:""
*RibbonCombination 2FrontYmcoBackK/Front YMCO, Back K:""
*RibbonCombination 4FrontYmckoBackK/Front YMCKO, Back K:""
*RibbonCombination 5FrontYmckoBackKo/Front YMCKO, Back KO:""
*RibbonCombination 6FrontYmckll/Front YMCKLL:""
*RibbonCombination 7FrontYmckllBackYmckll/Front YMCKLL, Back YMCKLL:""
*RibbonCombination 8FrontYmclBackKl/Front YMCL, Back KL:""
*RibbonCombination 9FrontYmcpko/Front YMCPKO:""
*RibbonCombination 10FrontYmcpkoBackYmcpko/Front YMCPKO, Back YMCPKO:""
*RibbonCombination 11FrontYmcpoBackK/Front YMCPO, Back K:""
*RibbonCombination 12FrontMono/Front MONO:""
*RibbonCombination 13FrontMonoBackMono/Front MONO , Back MONO:""
*RibbonCombination 14FrontKrO/Front KrO:""
*RibbonCombination 15FrontKrOBackKrO/Front KrO,Back KrO:""
*RibbonCombination 16FrontKdO/Front KdO:""
*RibbonCombination 17FrontKdOBackKdO/Front KdO,Back KdO:""
*RibbonCombination 18FrontYmcllBackK/Front YMCLL,Back K:""
*RibbonCombination 19FrontSrDYmcko/Front SrDYMCKO:""
*RibbonCombination 20FrontSrDYmcoBackK/Front SrDYMCO,Back K:""
*RibbonCombination 21FrontSrDYmckoBackSrdYmcko/Front SrDYMCKO,Back SrDYMCKO:""
*RibbonCombination 22FrontO/Front O:""
*RibbonCombination 23FrontOBackO/Front O,Back O:""

*RibbonCombination 24BackYmcko/Back YMCKO:""
*RibbonCombination 25BackYmckoFrontYmcko/Back YMCKO, Front YMCKO:""
*RibbonCombination 26BackYmcoFrontK/Back YMCO, Front K:""
*RibbonCombination 28BackYmckoFrontK/Back YMCKO, Front K:""
*RibbonCombination 29BackYmckoFrontKo/Back YMCKO, Front KO:""
*RibbonCombination 30BackYmckll/Back YMCKLL:""
*RibbonCombination 31BackYmckllFrontYmckll/Back YMCKLL, Front YMCKLL:""
*RibbonCombination 32BackYmclFrontKl/Back YMCL, Front KL:""
*RibbonCombination 33BackYmcpko/Back YMCPKO:""
*RibbonCombination 34BackYmcpkoFrontYmcpko/Back YMCPKO, Front YMCPKO:""
*RibbonCombination 35BackYmcpoFrontK/Back YMCPO, Front K:""
*RibbonCombination 36BackMono/Back MONO:""
*RibbonCombination 37BackMonoFrontMono/Back MONO , Front MONO:""
*RibbonCombination 38BackKrO/Back KrO:""
*RibbonCombination 39BackKrOFrontKrO/Back KrO,Front KrO:""
*RibbonCombination 40BackKdO/Back KdO:""
*RibbonCombination 41BackKdOFrontKdO/Back KdO,Front KdO:""
*RibbonCombination 42BackYmcllFrontK/Back YMCLL,Front K:""
*RibbonCombination 43BackSrDYmcko/Back SrDYMCKO:""
*RibbonCombination 44BackSrDYmcoFrontK/Back SrDYMCO,Front K:""
*RibbonCombination 45BackSrDYmckoFrontSrdYmcko/Back SrDYMCKO,Front SrDYMCKO:""
*RibbonCombination 46BackO/Back O:""
*RibbonCombination 47BackOFrontO/Back O,Front O:""

*CloseUI: *RibbonCombination

*CloseGroup: CardOptions

*OpenGroup: MagEncodingOption/Magnetic Encoding options

*OpenUI *DisableMagEncoding/Magnetic Encoding: PickOne
*OrderDependency: 10 AnySetup *DisableMagEncoding
*DefaultDisableMagEncoding: 0no
*DisableMagEncoding 0no/Enabled: "setpagedevice"
*DisableMagEncoding 1yes/Disabled: "setpagedevice"
*CloseUI: *DisableMagEncoding

*OpenUI *Coercivity/Coercivity: PickOne
*OrderDependency: 10 AnySetup *Coercivity
*DefaultCoercivity: 2High
*Coercivity 0None/None: "setpagedevice"
*Coercivity 1Low/Low: "setpagedevice"
*Coercivity 2High/High: "setpagedevice"
*CloseUI: *Coercivity

*OpenUI *EncodingType/Encoding Type: PickOne
*OrderDependency: 10 AnySetup *EncodingType
*DefaultEncodingType: 1iso
*EncodingType 0none/None: "setpagedevice"
*EncodingType 1iso/ISO: "setpagedevice"
*EncodingType 2aamva/AAMVA: "setpagedevice"
*EncodingType 3binary/BINARY: "setpagedevice"
*EncodingType 4custom/CUSTOM: "setpagedevice"
*%%EncodingType 5jis/JIS: "setpagedevice"
*CloseUI: *EncodingType

*OpenUI *EncodingOnly/Encoding Only: PickOne
*OrderDependency: 10 AnySetup *EncodingOnly
*DefaultEncodingOnly: 0no
*EncodingOnly 0no/No: "setpagedevice"
*EncodingOnly 1yes/Yes: "setpagedevice"
*CloseUI: *EncodingOnly

*OpenUI *EncoderVerification/Encoder Verification: PickOne
*OrderDependency: 10 AnySetup *EncoderVerification
*DefaultEncoderVerification: 0no
*EncoderVerification 0no/No: "setpagedevice"
*EncoderVerification 1yes/Yes: "setpagedevice"
*CloseUI: *EncoderVerification

*CloseGroup: MagEncodingOption

*%-----------------------------------------------------------------------*%
*%--------------------UI Constrains Information Page---------------------*%
*%-----------------------------------------------------------------------*%

*%---------------------------YMCKO---------------------------------*%
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 0YMCKO *RibbonCombination 47BackOFrontO
*%---------------------------YMCKOK---------------------------------*%
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 46BackO
*UIConstraints: *RibbonName 1YMCKOK *RibbonCombination 47BackOFrontO

*%---------------------------1/2 YMCKO---------------------------------*%
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 2HalfYMCKO *RibbonCombination 47BackOFrontO

*%---------------------------1/2 YMCKOKO---------------------------------*%
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 3HalfYMCKOKO *RibbonCombination 47BackOFrontO

*%---------------------------YMCPKO---------------------------------*%
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 4YMCPKO *RibbonCombination 47BackOFrontO

*%---------------------------KdO---------------------------------*%
*UIConstraints: *RibbonName 5KdO *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 5KdO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 5KdO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 5KdO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 5KdO *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 5KdO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 5KdO *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 5KdO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 5KdO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 5KdO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 5KdO *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 5KdO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 5KdO *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 5KdO *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 5KdO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 5KdO *RibbonCombination 47BackOFrontO
*%---------------------------KrO---------------------------------*%
*UIConstraints: *RibbonName 6KrO *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 6KrO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 6KrO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 6KrO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 6KrO *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 6KrO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 6KrO *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 6KrO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 6KrO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 6KrO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 6KrO *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 6KrO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 6KrO *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 6KrO *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 6KrO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 6KrO *RibbonCombination 47BackOFrontO

*%---------------------------Black---------------------------------*%
*UIConstraints: *RibbonName 7Black *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 7Black *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 7Black *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 7Black *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 7Black *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 7Black *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 7Black *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 7Black *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 7Black *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 7Black *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 7Black *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 7Black *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 7Black *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 7Black *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 7Black *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 7Black *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 7Black *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 7Black *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 7Black *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 7Black *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 7Black *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 7Black *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 7Black *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 7Black *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 7Black *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 7Black *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 7Black *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 7Black *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 7Black *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 7Black *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 7Black *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 7Black *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 7Black *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 7Black *RibbonCombination 46BackO
*UIConstraints: *RibbonName 7Black *RibbonCombination 47BackOFrontO

*%---------------------------White---------------------------------*%
*UIConstraints: *RibbonName 8White *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 8White *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 8White *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 8White *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 8White *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 8White *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 8White *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 8White *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 8White *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 8White *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 8White *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 8White *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 8White *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 8White *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 8White *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 8White *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 8White *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 8White *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 8White *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 8White *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 8White *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 8White *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 8White *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 8White *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 8White *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 8White *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 8White *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 8White *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 8White *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 8White *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 8White *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 8White *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 8White *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 8White *RibbonCombination 46BackO
*UIConstraints: *RibbonName 8White *RibbonCombination 47BackOFrontO
*%---------------------------Red---------------------------------*%
*UIConstraints: *RibbonName 9Red *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 9Red *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 9Red *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 9Red *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 9Red *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 9Red *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 9Red *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 9Red *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 9Red *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 9Red *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 9Red *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 9Red *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 9Red *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 9Red *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 9Red *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 9Red *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 9Red *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 9Red *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 9Red *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 9Red *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 9Red *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 9Red *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 9Red *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 9Red *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 9Red *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 9Red *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 9Red *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 9Red *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 9Red *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 9Red *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 9Red *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 9Red *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 9Red *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 9Red *RibbonCombination 46BackO
*UIConstraints: *RibbonName 9Red *RibbonCombination 47BackOFrontO

*%---------------------------Blue---------------------------------*%
*UIConstraints: *RibbonName 10Blue *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 10Blue *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 10Blue *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 10Blue *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 10Blue *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 10Blue *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 10Blue *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 10Blue *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 10Blue *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 10Blue *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 10Blue *RibbonCombination 46BackO
*UIConstraints: *RibbonName 10Blue *RibbonCombination 47BackOFrontO

*%---------------------------Gold---------------------------------*%
*UIConstraints: *RibbonName 11Gold *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 11Gold *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 11Gold *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 11Gold *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 11Gold *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 11Gold *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 11Gold *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 11Gold *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 11Gold *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 11Gold *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 11Gold *RibbonCombination 46BackO
*UIConstraints: *RibbonName 11Gold *RibbonCombination 47BackOFrontO

*%---------------------------Silver---------------------------------*%
*UIConstraints: *RibbonName 12Silver *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 12Silver *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 12Silver *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 12Silver *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 12Silver *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 12Silver *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 12Silver *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 12Silver *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 12Silver *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 12Silver *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 12Silver *RibbonCombination 46BackO
*UIConstraints: *RibbonName 12Silver *RibbonCombination 47BackOFrontO

*%---------------------------YMCKLL---------------------------------*%
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 46BackO
*UIConstraints: *RibbonName 13YMCKLL *RibbonCombination 47BackOFrontO

*%---------------------------SDYMCKO---------------------------------*%
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 22FrontO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 23FrontOBackO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 46BackO
*UIConstraints: *RibbonName 14SDYMCKO *RibbonCombination 47BackOFrontO

*%---------------------------Hologram Overlay---------------------------------*%
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 0FrontYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 6FrontYmckll
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 9FrontYmcpko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 12FrontMono
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 14FrontKrO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 16FrontKdO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 24BackYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 30BackYmckll
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 33BackYmcpko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 36BackMono
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 38BackKrO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 40BackKdO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 43BackSrDYmcko
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *RibbonName 15Hologram *RibbonCombination 45BackSrDYmckoFrontSrdYmcko

*%==== *DualSidePrinting UI Constraints With Ribbon Combination====
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 23FrontOBackO
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *DualSidePrinting 0false *RibbonCombination 47BackOFrontO

*UIConstraints: *DualSidePrinting 1true *RibbonCombination 0FrontYmcko
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 6FrontYmckll
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 9FrontYmcpko
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 12FrontMono
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 14FrontKrO
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 16FrontKdO
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 22FrontO
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 24BackYmcko
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 30BackYmckll
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 33BackYmcpko
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 36BackMono
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 38BackKrO
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 40BackKdO
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 43BackSrDYmcko
*UIConstraints: *DualSidePrinting 1true *RibbonCombination 46BackO

*%==== *DualSidePrinting UI Constraints With Rotation====

*UIConstraints: *DualSidePrinting 0false *Rotation 2Back
*UIConstraints: *DualSidePrinting 0false *Rotation 3Both

*%==== *Coercivity UI Constraints With Mag Encdoing Disable options====

*UIConstraints: *DisableMagEncoding 1yes *Coercivity 1Low
*UIConstraints: *DisableMagEncoding 1yes *Coercivity 2High

*UIConstraints: *DisableMagEncoding 0no *Coercivity 0None

*%==== *EncodingType UI Constraints With Mag Encdoing Disable options====

*UIConstraints: *DisableMagEncoding 1yes *EncodingType 1iso
*UIConstraints: *DisableMagEncoding 1yes *EncodingType 2aamva
*UIConstraints: *DisableMagEncoding 1yes *EncodingType 3binary
*UIConstraints: *DisableMagEncoding 1yes *EncodingType 4custom

*UIConstraints: *DisableMagEncoding 0no *EncodingType 0none

*%=======================*PrintFrontimageOnBackSide UI Constraints With RibbonCombination options====

*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 0FrontYmcko
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 1FrontYmckoBackYmcko
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 2FrontYmcoBackK
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 4FrontYmckoBackK
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 5FrontYmckoBackKo
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 6FrontYmckll
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 7FrontYmckllBackYmckll
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 8FrontYmclBackKl
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 9FrontYmcpko
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 10FrontYmcpkoBackYmcpko
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 11FrontYmcpoBackK
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 12FrontMono
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 13FrontMonoBackMono
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 14FrontKrO
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 15FrontKrOBackKrO
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 16FrontKdO
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 17FrontKdOBackKdO
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 18FrontYmcllBackK
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 19FrontSrDYmcko
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 20FrontSrDYmcoBackK
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 21FrontSrDYmckoBackSrdYmcko
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 22FrontO
*UIConstraints: *PrintFrontimageOnBackSide  1yes *RibbonCombination 23FrontOBackO

*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 24BackYmcko
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 25BackYmckoFrontYmcko
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 26BackYmcoFrontK
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 28BackYmckoFrontK
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 29BackYmckoFrontKo
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 30BackYmckll
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 31BackYmckllFrontYmckll
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 32BackYmclFrontKl
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 33BackYmcpko
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 34BackYmcpkoFrontYmcpko
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 35BackYmcpoFrontK
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 36BackMono
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 37BackMonoFrontMono
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 38BackKrO
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 39BackKrOFrontKrO
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 40BackKdO
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 41BackKdOFrontKdO
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 42BackYmcllFrontK
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 43BackSrDYmcko
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 44BackSrDYmcoFrontK
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 45BackSrDYmckoFrontSrdYmcko
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 46BackO
*UIConstraints: *PrintFrontimageOnBackSide  0no *RibbonCombination 47BackOFrontO
EOF

cat <<'EOF' > "/usr/share/cups/model/brother_ql820nwb_printer_en.ppd"
*PPD-Adobe: "4.3"

*%================================================
*%	Copyright(C) 2005-2016 Brother Industries, Ltd.
*%	"Brother QL-820NWB CUPS"
*%================================================

*%==== General Information Keywords ========================
*FormatVersion: "4.3"
*FileVersion: "1.00"
*LanguageVersion: English
*LanguageEncoding: ISOLatin1
*PCFileName: "QL820NWB.PPD"
*Manufacturer: "Brother"
*Product: "(QL-820NWB)"
*1284DeviceID: "MFG: Brother;MDL: QL-820NWB"
*cupsVersion: 1.1
*cupsManualCopies: False
*cupsFilter: "application/vnd.cups-postscript 0 brother_lpdwrapper_ql820nwb"
*cupsFilter: "application/vnd.cups-pdf 0 brother_lpdwrapper_ql820nwb"
*cupsModelNumber: 1
*ModelName: "Brother QL-820NWB"
*ShortNickName: "Brother QL-820NWB"
*NickName: "Brother QL-820NWB CUPS"
*PSVersion: "(3010.106) 3"

*%==== Basic Device Capabilities =============
*LanguageLevel: "3"
*ColorDevice: False
*DefaultColorSpace: Gray
*FileSystem: False
*Throughput: "12"
*LandscapeOrientation: Plus90
*VariablePaperSize: False
*TTRasterizer: Type42
*FreeVM: "1700000"

*%DefaultOutputOrder: Reverse

*%==== UI Constraints ======================
*% BrTrimtape/PageSize

*%==== Media Selection ======================
*OpenGroup: Basic

*OpenUI *PageSize/Media Size: PickOne
*OrderDependency: 11 AnySetup *PageSize
*DefaultPageSize: 29x90
*PageSize 17x54/17mmx54mm(0.66"x2.1"):	"          "
*PageSize 17x87/17mmx87mm(0.66"x3.4"):	"          "
*PageSize 23x23/23mmx23mm(0.9"x0.9"):	"          "
*PageSize 29x42/29mmx42mm(1.1"x1.6"):	"          "
*PageSize 29x90/29mmx90mm(1.1"x3.5"):	"          "
*PageSize 38x90/38mmx90mm(1.4"x3.5"):	"          "
*PageSize 39x48/39mmx48mm(1.4"x1.8"):	"          "
*PageSize 52x29/52mmx29mm(2"x1.1"):		"          "
*PageSize 54x29/54mmx29mm(2.12"x1.14"):			"          "
*PageSize 60x86/60mmx86mm(2.3"x3.4"):			"          "
*PageSize 62x29/62mmx29mm(2.3"x1.1"):			"          "
*PageSize 62x100/62mmx100mm(2.4"x3.9"):			"          "
*PageSize 12Dia/12mm(0.47")Dia:					"          "
*PageSize 24Dia/24mm(0.94")Dia:					"          "
*PageSize 58Dia/58mm(2.2")Dia:					"          "
*PageSize 12X1/12mm(0.47"):						"          "
*PageSize 29X1/29mm(1.1"):						"          "
*PageSize 38X1/38mm(1.4"):						"          "
*PageSize 50X1/50mm(1.9"):						"          "
*PageSize 54X1/54mm(2.1"):						"          "
*PageSize 62X1/62mm(2.4"):						"          "
*PageSize 12X2/12mmx2(0.47"x2):					"          "
*PageSize 29X2/29mmx2(1.1"x2):					"          "
*PageSize 38X2/38mmx2(1.4"x2):					"          "
*PageSize 50X2/50mmx2(1.9"x2):					"          "
*PageSize 54X2/54mmx2(2.1"x2):					"          "
*PageSize 62X2/62mmx 2(2.4"x2):					"          "
*PageSize 12X3/12mmx3(0.47"x3):					"          "
*PageSize 29X3/29mmx3(1.1"x3):					"          "
*PageSize 38X3/38mmx3(1.4"x3):					"          "
*PageSize 50X3/50mmx3(1.9"x3):					"          "
*PageSize 54X3/54mmx3(2.1"x3):					"          "
*PageSize 62X3/62mmx3(2.4"x3):					"          "
*PageSize 12X4/12mmx4(0.47"x4):					"          "
*PageSize 29X4/29mmx4(1.1"x4):					"          "
*PageSize 38X4/38mmx4(1.4"x4):					"          "
*PageSize 50X4/50mmx4(1.9"x4):					"          "
*PageSize 54X4/54mmx4(2.1"x4):					"          "
*PageSize 62X4/62mmx4(2.4"x4):					"          "
*CloseUI: *PageSize

*OpenUI *PageRegion: PickOne
*OrderDependency: 12 AnySetup *PageRegion
*DefaultPageRegion: 29x90
*PageRegion 17x54/17mmx54mm(0.66"x2.1"):		"          "
*PageRegion 17x87/17mmx87mm(0.66"x3.4"):		"          "
*PageRegion 23x23/23mmx23mm(0.9"x0.9"):			"          "
*PageRegion 29x42/29mmx42mm(1.1"x1.6"):			"          "
*PageRegion 29x90/29mmx90mm(1.1"x3.5"):			"          "
*PageRegion 38x90/38mmx90mm(1.4"x3.5"):			"          "
*PageRegion 39x48/39mmx48mm(1.4"x1.8"):			"          "
*PageRegion 52x29/52mmx29mm(2"x1.1"):			"          "
*PageRegion 54x29/54mmx29mm(2.12"x1.14"):		"          "
*PageRegion 60x86/60mmx86mm(2.3"x3.4"):			"          "
*PageRegion 62x29/62mmx29mm(2.3"x1.1"):			"          "
*PageRegion 62x100/62mmx100mm(2.4"x3.9"):		"          "
*PageRegion 12Dia/12mm(0.47")Dia:					"          "
*PageRegion 24Dia/24mm(0.94")Dia:					"          "
*PageRegion 58Dia/58mm(2.2")Dia:					"          "
*PageRegion 12X1/12mm(0.47"):						"          "
*PageRegion 29X1/29mm(1.1"):						"          "
*PageRegion 38X1/38mm(1.4"):						"          "
*PageRegion 50X1/50mm(1.9"):						"          "
*PageRegion 54X1/54mm(2.1"):						"          "
*PageRegion 62X1/62mm(2.4"):						"          "
*PageRegion 12X2/12mmx2(0.47"x2):					"          "
*PageRegion 29X2/29mmx2(1.1"x2):					"          "
*PageRegion 38X2/38mmx2(1.4"x2):					"          "
*PageRegion 50X2/50mmx2(1.9"x2):					"          "
*PageRegion 54X2/54mmx2(2.1"x2):					"          "
*PageRegion 62X2/62mmx 2(2.4"x2):					"          "
*PageRegion 12X3/12mmx3(0.47"x3):					"          "
*PageRegion 29X3/29mmx3(1.1"x3):					"          "
*PageRegion 38X3/38mmx3(1.4"x3):					"          "
*PageRegion 50X3/50mmx3(1.9"x3):					"          "
*PageRegion 54X3/54mmx3(2.1"x3):					"          "
*PageRegion 62X3/62mmx3(2.4"x3):					"          "
*PageRegion 12X4/12mmx4(0.47"x4):					"          "
*PageRegion 29X4/29mmx4(1.1"x4):					"          "
*PageRegion 38X4/38mmx4(1.4"x4):					"          "
*PageRegion 50X4/50mmx4(1.9"x4):					"          "
*PageRegion 54X4/54mmx4(2.1"x4):					"          "
*PageRegion 62X4/62mmx4(2.4"x4):					"          "
*CloseUI: *PageRegion

*DefaultImageableArea: 29x90
*ImageableArea 17x54/17mmx54mm(0.66"x2.1"):			"4.32 8.4  43.92  144.24"
*ImageableArea 17x87/17mmx87mm(0.66"x3.4"):			"4.32 8.4  43.92  237.84"
*ImageableArea 23x23/23mmx23mm(0.9"x0.9"):			"4.32 8.4  60.96  56.88"
*ImageableArea 29x42/29mmx42mm(1.1"x1.6"):			"4.32 8.4  77.76  110.64"
*ImageableArea 29x90/29mmx90mm(1.1"x3.5"):			"4.32 8.4  77.76  246.24"
*ImageableArea 38x90/38mmx90mm(1.4"x3.5"):			"4.32 8.4  103.44 246.24"
*ImageableArea 39x48/39mmx48mm(1.4"x1.8"):			"4.32 8.4  106.32 127.20"
*ImageableArea 52x29/52mmx29mm(2"x1.1"):			"4.32 8.4  143.14 73.44"
*ImageableArea 54x29/54mmx29mm(2.12"x1.14"):		"4.32 8.4  147.36 73.44"
*ImageableArea 60x86/60mmx86mm(2.3"x3.4"):			"4.32 8.4  165.6  234.96"
*ImageableArea 62x29/62mmx29mm(2.3"x1.1"):			"4.32 8.4  171.36 73.44"
*ImageableArea 62x100/62mmx100mm(2.4"x3.9"):		"4.32 8.4  171.36 274.56"
*ImageableArea 12Dia/12mm(0.47")Dia:				"5.76 5.76 28.32  28.32"
*ImageableArea 24Dia/24mm(0.94")Dia:				"5.76 5.76 62.4   62.4"
*ImageableArea 58Dia/58mm(2.2")Dia:					"8.4  8.4  156.72 156.72"
*ImageableArea 12X1/12mm(0.47"):					"4.32 8.4  29.76  275.06"
*ImageableArea 29X1/29mm(1.1"):					"4.32 8.4  77.76  275.06"
*ImageableArea 38X1/38mm(1.4"):					"4.32 8.4  103.44 275.04"
*ImageableArea 50X1/50mm(1.9"):					"4.32 8.4  137.28 274.8"
*ImageableArea 54X1/54mm(2.1"):					"5.76 8.4  147.36 275.04"
*ImageableArea 62X1/62mm(2.4"):					"4.32 8.4  171.36 274.06"
*ImageableArea 12X2/12mmx2(0.47"x2):			"4.32 8.4  55.20  275.06"
*ImageableArea 29X2/29mmx2(1.1"x2):				"4.32 8.4  151.20 275.06"
*ImageableArea 38X2/38mmx2(1.4"x2):				"4.32 8.4  202.56 275.04"
*ImageableArea 50X2/50mmx2(1.9"x2):				"4.32 8.4  270.24 274.8"
*ImageableArea 54X2/54mmx2(2.1"x2):				"5.76 8.4  288.96 275.04"
*ImageableArea 62X2/62mmx 2(2.4"x2):			"4.32 8.4  338.40 275.06"
*ImageableArea 12X3/12mmx3(0.47"x3):			"4.32 8.4  80.64  275.06"
*ImageableArea 29X3/29mmx3(1.1"x3):				"4.32 8.4  224.64 275.06"
*ImageableArea 38X3/38mmx3(1.4"x3):				"4.32 8.4  301.68 275.04"
*ImageableArea 50X3/50mmx3(1.9"x3):				"4.32 8.4  403.2  274.8"
*ImageableArea 54X3/54mmx3(2.1"x3):				"5.76 8.4  430.56 275.04"
*ImageableArea 62X3/62mmx3(2.4"x3):				"4.32 8.4  505.44 275.06"
*ImageableArea 12X4/12mmx4(0.47"x4):			"4.32 8.4  106.80 275.06"
*ImageableArea 29X4/29mmx4(1.1"x4):				"4.32 8.4  298.08 275.06"
*ImageableArea 38X4/38mmx4(1.4"x4):				"4.32 8.4  400.80 275.04"
*ImageableArea 50X4/50mmx4(1.9"x4):				"4.32 8.4  536.16 274.8"
*ImageableArea 54X4/54mmx4(2.1"x4):				"5.76 8.4  572.16 275.04"
*ImageableArea 62X4/62mmx4(2.4"x4):				"4.32 8.4  672.48 275.06"

*%==== Information About Media Sizes ========
*DefaultPaperDimension: 29x90
*PaperDimension 17x54/17mmx54mm(0.66"x2.1"):			"48.24  152.64"
*PaperDimension 17x87/17mmx87mm(0.66"x3.4"):			"48.24  246.24"
*PaperDimension 23x23/23mmx23mm(0.9"x0.9"):				"65.28  65.28"
*PaperDimension 29x42/29mmx42mm(1.1"x1.6"):				"82.08 118.80"
*PaperDimension 29x90/29mmx90mm(1.1"x3.5"):				"82.08  254.64"
*PaperDimension 38x90/38mmx90mm(1.4"x3.5"):				"107.76 254.64"
*PaperDimension 39x48/39mmx48mm(1.4"x1.8"):				"110.64 135.60"
*PaperDimension 52x29/54mmx29mm(2.12"x1.14"):			"147.4  81.84"
*PaperDimension 54x29/54mmx29mm(2.12"x1.14"):			"153.0  81.84"
*PaperDimension 60x86/60mmx86mm(2.3"x3.4"):				"169.92 243.36"
*PaperDimension 62x29/62mmx29mm(2.3"x1.1"):				"175.68 81.84"
*PaperDimension 62x100/62mmx100mm(2.4"x3.9"):			"175.68 282.96"
*PaperDimension 12Dia/12mm(0.47")Dia:					"34.08  34.08"
*PaperDimension 24Dia/24mm(0.94")Dia:					"68.16  68.16"
*PaperDimension 58Dia/58mm(2.2")Dia:					"165.12 165.12"
*PaperDimension 12X1/12mm(0.47"):						"34.08  283.46"
*PaperDimension 29X1/29mm(1.1"):						"82.08  283.46"
*PaperDimension 38X1/38mm(1.4"):						"107.76 283.44"
*PaperDimension 50X1/50mm(1.9"):						"141.6  283.44"
*PaperDimension 54X1/54mm(2.1"):						"153.12 283.44"
*PaperDimension 62X1/62mm(2.4"):						"175.68 282.46"
*PaperDimension 12X2/12mmx2(0.47"x2):					"59.52  283.46"
*PaperDimension 29X2/29mmx2(1.1"x2):					"155.52 283.46"
*PaperDimension 38X2/38mmx2(1.4"x2):					"206.88 283.44"
*PaperDimension 50X2/50mmx2(1.9"x2):					"274.56 283.44"
*PaperDimension 54X2/54mmx2(2.1"x2):					"294.72 283.44"
*PaperDimension 62X2/62mmx 2(2.4"x2):					"342.72 283.46"
*PaperDimension 12X3/12mmx3(0.47"x3):					"84.96  283.46"
*PaperDimension 29X3/29mmx3(1.1"x3):					"228.96 283.46"
*PaperDimension 38X3/38mmx3(1.4"x3):					"306.00 283.44"
*PaperDimension 50X3/50mmx3(1.9"x3):					"407.52 283.44"
*PaperDimension 54X3/54mmx3(2.1"x3):					"436.32 283.44"
*PaperDimension 62X3/62mmx3(2.4"x3):					"509.76 283.46"
*PaperDimension 12X4/12mmx4(0.47"x4):					"110.40 283.46"
*PaperDimension 29X4/29mmx4(1.1"x4):					"302.40 283.46"
*PaperDimension 38X4/38mmx4(1.4"x4):					"405.12 283.44"
*PaperDimension 50X4/50mmx4(1.9"x4):					"540.48 283.44"
*PaperDimension 54X4/54mmx4(2.1"x4):					"577.92 283.44"
*PaperDimension 62X4/62mmx4(2.4"x4):					"676.80 283.46"

*OpenUI *BrMargin/Feed(invalid for Die-Cut tape): PickOne
*OrderDependency: 23 AnySetup  *BrMargin
*DefaultBrMargin: 3
*BrMargin 3/3 mm(0.12"): "          "
*BrMargin 4/4 mm(0.16"): "          "
*BrMargin 5/5 mm(0.2"): "          "
*BrMargin 6/6 mm(0.24"): "          "
*BrMargin 7/7 mm(0.27"): "          "
*BrMargin 8/8 mm(0.31"): "          "
*BrMargin 9/9 mm(0.35"): "          "
*BrMargin 10/10 mm(0.39"): "          "
*BrMargin 11/11 mm(0.43"): "          "
*BrMargin 12/12 mm(0.47"): "          "
*BrMargin 13/13 mm(0.51"): "          "
*BrMargin 14/14 mm(0.55"): "          "
*BrMargin 15/15 mm(0.59"): "          "
*BrMargin 16/16 mm(0.63"): "          "
*BrMargin 17/17 mm(0.67"): "          "
*BrMargin 18/18 mm(0.71"): "          "
*BrMargin 19/19 mm(0.75"): "          "
*BrMargin 20/20 mm(0.79"): "          "
*BrMargin 21/21 mm(0.83"): "          "
*BrMargin 22/22 mm(0.87"): "          "
*BrMargin 23/23 mm(0.91"): "          "
*BrMargin 24/24 mm(0.94"): "          "
*BrMargin 25/25 mm(0.98"): "          "
*BrMargin 26/26 mm(1.02"): "          "
*BrMargin 27/27 mm(1.06"): "          "
*BrMargin 28/28 mm(1.1"): "          "
*BrMargin 29/29 mm(1.14"): "          "
*BrMargin 30/30 mm(1.18"): "          "
*CloseUI: *BrMargin

*OpenUI *BrPriority/Quality: PickOne
*OrderDependency: 22 AnySetup  *BrPriority
*DefaultBrPriority: BrSpeed
*BrPriority BrSpeed/Give priority to print speed 300*300dpi: "          "
*BrPriority BrQuality/Give priority to print quality 300*300dpi: "          "
*CloseUI: *BrPriority

*OpenUI *BrCompress/Start printing: PickOne
*OrderDependency: 23 AnySetup  *BrCompress
*DefaultBrCompress: OFF
*BrCompress OFF/Immediately after starting to receive data: "          "
*BrCompress ON/After one page of data is received: "          "
*CloseUI: *BrCompress

*CloseGroup: Basic


*OpenGroup: Cut Option
*OpenUI *BrCutLabel/Cut every: PickOne
*OrderDependency: 23 AnySetup  *BrCutLabel
*DefaultBrCutLabel: 1
*BrCutLabel 0/OFF: "          "
*BrCutLabel 1/1 label: "          "
*BrCutLabel 2/2 labels: "          "
*BrCutLabel 3/3 labels: "          "
*BrCutLabel 4/4 labels: "          "
*BrCutLabel 5/5 labels: "          "
*BrCutLabel 6/6 labels: "          "
*BrCutLabel 7/7 labels: "          "
*BrCutLabel 8/8 labels: "          "
*BrCutLabel 9/9 labels: "          "
*BrCutLabel 10/10 labels: "          "
*BrCutLabel 11/11 labels: "          "
*BrCutLabel 12/12 labels: "          "
*BrCutLabel 13/13 labels: "          "
*BrCutLabel 14/14 labels: "          "
*BrCutLabel 15/15 labels: "          "
*BrCutLabel 16/16 labels: "          "
*BrCutLabel 17/17 labels: "          "
*BrCutLabel 18/18 labels: "          "
*BrCutLabel 19/19 labels: "          "
*BrCutLabel 20/20 labels: "          "
*BrCutLabel 21/21 labels: "          "
*BrCutLabel 22/22 labels: "          "
*BrCutLabel 23/23 labels: "          "
*BrCutLabel 24/24 labels: "          "
*BrCutLabel 25/25 labels: "          "
*BrCutLabel 26/26 labels: "          "
*BrCutLabel 27/27 labels: "          "
*BrCutLabel 28/28 labels: "          "
*BrCutLabel 29/29 labels: "          "
*BrCutLabel 30/30 labels: "          "
*CloseUI: *BrCutLabel



*OpenUI *BrCutAtEnd/Cut at end: PickOne
*OrderDependency: 21 AnySetup  *BrCutAtEnd
*DefaultBrCutAtEnd: ON
*BrCutAtEnd OFF/OFF: "          "
*BrCutAtEnd ON/ON: "          "
*CloseUI: *BrCutAtEnd

*OpenUI *BrTrimtape/Trim tape: PickOne
*OrderDependency: 21 AnySetup  *BrTrimtape
*DefaultBrTrimtape: ON
*BrTrimtape OFF/OFF: "          "
*BrTrimtape ON/ON: "          "
*CloseUI: *BrTrimtape


*OpenUI *BrMirror/Mirror Printing: PickOne
*OrderDependency: 21 AnySetup  *BrMirror
*DefaultBrMirror: OFF
*BrMirror OFF/OFF: "          "
*BrMirror ON/ON: "          "
*CloseUI: *BrMirror

*OpenUI *BrPrintArea/Offset tape: PickOne
*OrderDependency: 21 AnySetup  *BrPrintArea
*DefaultBrPrintArea: 0
*BrPrintArea 0/OFF: "          "
*BrPrintArea 1/1: "          "
*BrPrintArea 2/2: "          "
*CloseUI: *BrPrintArea

*CloseGroup: Cut Option


*OpenGroup: Advanced

*OpenUI *BrHalftonePattern/Halftone: PickOne
*OrderDependency: 24 AnySetup  *BrHalftonePattern
*DefaultBrHalftonePattern: BrErrorDiffusion
*BrHalftonePattern BrBinary/Binary: "          "
*BrHalftonePattern BrDither/Dither: "          "
*BrHalftonePattern BrErrorDiffusion/Error Diffusion: "          "
*CloseUI: *BrHalftonePattern

*OpenUI *BrBrightness/Brightness: PickOne
*OrderDependency: 25 AnySetup  *BrBrightness
*DefaultBrBrightness: 0
*BrBrightness 50/50: "          "
*BrBrightness 49/49: "          "
*BrBrightness 48/48: "          "
*BrBrightness 47/47: "          "
*BrBrightness 46/46: "          "
*BrBrightness 45/45: "          "
*BrBrightness 44/44: "          "
*BrBrightness 43/43: "          "
*BrBrightness 42/42: "          "
*BrBrightness 41/41: "          "
*BrBrightness 40/40: "          "
*BrBrightness 39/39: "          "
*BrBrightness 38/38: "          "
*BrBrightness 37/37: "          "
*BrBrightness 36/36: "          "
*BrBrightness 35/35: "          "
*BrBrightness 34/34: "          "
*BrBrightness 33/33: "          "
*BrBrightness 32/32: "          "
*BrBrightness 31/31: "          "
*BrBrightness 30/30: "          "
*BrBrightness 29/29: "          "
*BrBrightness 28/28: "          "
*BrBrightness 27/27: "          "
*BrBrightness 26/26: "          "
*BrBrightness 25/25: "          "
*BrBrightness 24/24: "          "
*BrBrightness 23/23: "          "
*BrBrightness 22/22: "          "
*BrBrightness 21/21: "          "
*BrBrightness 20/20: "          "
*BrBrightness 19/19: "          "
*BrBrightness 18/18: "          "
*BrBrightness 17/17: "          "
*BrBrightness 16/16: "          "
*BrBrightness 15/15: "          "
*BrBrightness 14/14: "          "
*BrBrightness 13/13: "          "
*BrBrightness 12/12: "          "
*BrBrightness 11/11: "          "
*BrBrightness 10/10: "          "
*BrBrightness 9/9: "          "
*BrBrightness 8/8: "          "
*BrBrightness 7/7: "          "
*BrBrightness 6/6: "          "
*BrBrightness 5/5: "          "
*BrBrightness 4/4: "          "
*BrBrightness 3/3: "          "
*BrBrightness 2/2: "          "
*BrBrightness 1/1: "          "
*BrBrightness 0/0: "          "
*BrBrightness -1/-1: "          "
*BrBrightness -2/-2: "          "
*BrBrightness -3/-3: "          "
*BrBrightness -4/-4: "          "
*BrBrightness -5/-5: "          "
*BrBrightness -6/-6: "          "
*BrBrightness -7/-7: "          "
*BrBrightness -8/-8: "          "
*BrBrightness -9/-9: "          "
*BrBrightness -10/-10: "          "
*BrBrightness -11/-11: "          "
*BrBrightness -12/-12: "          "
*BrBrightness -13/-13: "          "
*BrBrightness -14/-14: "          "
*BrBrightness -15/-15: "          "
*BrBrightness -16/-16: "          "
*BrBrightness -17/-17: "          "
*BrBrightness -18/-18: "          "
*BrBrightness -19/-19: "          "
*BrBrightness -20/-20: "          "
*BrBrightness -21/-21: "          "
*BrBrightness -22/-22: "          "
*BrBrightness -23/-23: "          "
*BrBrightness -24/-24: "          "
*BrBrightness -25/-25: "          "
*BrBrightness -26/-26: "          "
*BrBrightness -27/-27: "          "
*BrBrightness -28/-28: "          "
*BrBrightness -29/-29: "          "
*BrBrightness -30/-30: "          "
*BrBrightness -31/-31: "          "
*BrBrightness -32/-32: "          "
*BrBrightness -33/-33: "          "
*BrBrightness -34/-34: "          "
*BrBrightness -35/-35: "          "
*BrBrightness -36/-36: "          "
*BrBrightness -37/-37: "          "
*BrBrightness -38/-38: "          "
*BrBrightness -39/-39: "          "
*BrBrightness -40/-40: "          "
*BrBrightness -41/-41: "          "
*BrBrightness -42/-42: "          "
*BrBrightness -43/-43: "          "
*BrBrightness -44/-44: "          "
*BrBrightness -45/-45: "          "
*BrBrightness -46/-46: "          "
*BrBrightness -47/-47: "          "
*BrBrightness -48/-48: "          "
*BrBrightness -49/-49: "          "
*BrBrightness -50/-50: "          "
*CloseUI: *BrBrightness

*OpenUI *BrContrast/Contrast: PickOne
*OrderDependency: 26 AnySetup  *BrContrast
*DefaultBrContrast: 0
*BrContrast 50/50: "          "
*BrContrast 49/49: "          "
*BrContrast 48/48: "          "
*BrContrast 47/47: "          "
*BrContrast 46/46: "          "
*BrContrast 45/45: "          "
*BrContrast 44/44: "          "
*BrContrast 43/43: "          "
*BrContrast 42/42: "          "
*BrContrast 41/41: "          "
*BrContrast 40/40: "          "
*BrContrast 39/39: "          "
*BrContrast 38/38: "          "
*BrContrast 37/37: "          "
*BrContrast 36/36: "          "
*BrContrast 35/35: "          "
*BrContrast 34/34: "          "
*BrContrast 33/33: "          "
*BrContrast 32/32: "          "
*BrContrast 31/31: "          "
*BrContrast 30/30: "          "
*BrContrast 29/29: "          "
*BrContrast 28/28: "          "
*BrContrast 27/27: "          "
*BrContrast 26/26: "          "
*BrContrast 25/25: "          "
*BrContrast 24/24: "          "
*BrContrast 23/23: "          "
*BrContrast 22/22: "          "
*BrContrast 21/21: "          "
*BrContrast 20/20: "          "
*BrContrast 19/19: "          "
*BrContrast 18/18: "          "
*BrContrast 17/17: "          "
*BrContrast 16/16: "          "
*BrContrast 15/15: "          "
*BrContrast 14/14: "          "
*BrContrast 13/13: "          "
*BrContrast 12/12: "          "
*BrContrast 11/11: "          "
*BrContrast 10/10: "          "
*BrContrast 9/9: "          "
*BrContrast 8/8: "          "
*BrContrast 7/7: "          "
*BrContrast 6/6: "          "
*BrContrast 5/5: "          "
*BrContrast 4/4: "          "
*BrContrast 3/3: "          "
*BrContrast 2/2: "          "
*BrContrast 1/1: "          "
*BrContrast 0/0: "          "
*BrContrast -1/-1: "          "
*BrContrast -2/-2: "          "
*BrContrast -3/-3: "          "
*BrContrast -4/-4: "          "
*BrContrast -5/-5: "          "
*BrContrast -6/-6: "          "
*BrContrast -7/-7: "          "
*BrContrast -8/-8: "          "
*BrContrast -9/-9: "          "
*BrContrast -10/-10: "          "
*BrContrast -11/-11: "          "
*BrContrast -12/-12: "          "
*BrContrast -13/-13: "          "
*BrContrast -14/-14: "          "
*BrContrast -15/-15: "          "
*BrContrast -16/-16: "          "
*BrContrast -17/-17: "          "
*BrContrast -18/-18: "          "
*BrContrast -19/-19: "          "
*BrContrast -20/-20: "          "
*BrContrast -21/-21: "          "
*BrContrast -22/-22: "          "
*BrContrast -23/-23: "          "
*BrContrast -24/-24: "          "
*BrContrast -25/-25: "          "
*BrContrast -26/-26: "          "
*BrContrast -27/-27: "          "
*BrContrast -28/-28: "          "
*BrContrast -29/-29: "          "
*BrContrast -30/-30: "          "
*BrContrast -31/-31: "          "
*BrContrast -32/-32: "          "
*BrContrast -33/-33: "          "
*BrContrast -34/-34: "          "
*BrContrast -35/-35: "          "
*BrContrast -36/-36: "          "
*BrContrast -37/-37: "          "
*BrContrast -38/-38: "          "
*BrContrast -39/-39: "          "
*BrContrast -40/-40: "          "
*BrContrast -41/-41: "          "
*BrContrast -42/-42: "          "
*BrContrast -43/-43: "          "
*BrContrast -44/-44: "          "
*BrContrast -45/-45: "          "
*BrContrast -46/-46: "          "
*BrContrast -47/-47: "          "
*BrContrast -48/-48: "          "
*BrContrast -49/-49: "          "
*BrContrast -50/-50: "          "
*CloseUI: *BrContrast

*CloseGroup: Advanced

*DefaultFont: Courier
*Font AvantGarde-Book: Standard "(001.006S)" Standard ROM
*Font AvantGarde-BookOblique: Standard "(001.006S)" Standard ROM
*Font AvantGarde-Demi: Standard "(001.007S)" Standard ROM
*Font AvantGarde-DemiOblique: Standard "(001.007S)" Standard ROM
*Font Bookman-Demi: Standard "(001.004S)" Standard ROM
*Font Bookman-DemiItalic: Standard "(001.004S)" Standard ROM
*Font Bookman-Light: Standard "(001.004S)" Standard ROM
*Font Bookman-LightItalic: Standard "(001.004S)" Standard ROM
*Font Courier: Standard "(002.004S)" Standard ROM
*Font Courier-Bold: Standard "(002.004S)" Standard ROM
*Font Courier-BoldOblique: Standard "(002.004S)" Standard ROM
*Font Courier-Oblique: Standard "(002.004S)" Standard ROM
*Font Helvetica: Standard "(001.006S)" Standard ROM
*Font Helvetica-Bold: Standard "(001.007S)" Standard ROM
*Font Helvetica-BoldOblique: Standard "(001.007S)" Standard ROM
*Font Helvetica-Narrow: Standard "(001.006S)" Standard ROM
*Font Helvetica-Narrow-Bold: Standard "(001.007S)" Standard ROM
*Font Helvetica-Narrow-BoldOblique: Standard "(001.007S)" Standard ROM
*Font Helvetica-Narrow-Oblique: Standard "(001.006S)" Standard ROM
*Font Helvetica-Oblique: Standard "(001.006S)" Standard ROM
*Font NewCenturySchlbk-Bold: Standard "(001.009S)" Standard ROM
*Font NewCenturySchlbk-BoldItalic: Standard "(001.007S)" Standard ROM
*Font NewCenturySchlbk-Italic: Standard "(001.006S)" Standard ROM
*Font NewCenturySchlbk-Roman: Standard "(001.007S)" Standard ROM
*Font Palatino-Bold: Standard "(001.005S)" Standard ROM
*Font Palatino-BoldItalic: Standard "(001.005S)" Standard ROM
*Font Palatino-Italic: Standard "(001.005S)" Standard ROM
*Font Palatino-Roman: Standard "(001.005S)" Standard ROM
*Font Times-Bold: Standard "(001.007S)" Standard ROM
*Font Times-BoldItalic: Standard "(001.009S)" Standard ROM
*Font Times-Italic: Standard "(001.007S)" Standard ROM
*Font Times-Roman: Standard "(001.007S)" Standard ROM
*Font ZapfChancery-MediumItalic: Standard "(001.007S)" Standard ROM
*Font ZapfDingbats: Special "(001.004S)" Special ROM
*Font Symbol: Special "(001.007S)" Special ROM
*Font Alaska: Standard "(001.005)" Standard ROM
*Font AlaskaExtrabold: Standard "(001.005)" Standard ROM
*Font AntiqueOakland: Standard "(001.005)" Standard ROM
*Font AntiqueOakland-Bold: Standard "(001.005)" Standard ROM
*Font AntiqueOakland-Oblique: Standard "(001.005)" Standard ROM
*Font ClevelandCondensed: Standard "(001.005)" Standard ROM
*Font Connecticut: Standard "(001.005)" Standard ROM
*Font Guatemala-Antique: Standard "(001.005)" Standard ROM
*Font Guatemala-Bold: Standard "(001.005)" Standard ROM
*Font Guatemala-Italic: Standard "(001.005)" Standard ROM
*Font Guatemala-BoldItalic: Standard "(001.005)" Standard ROM

*Font LetterGothic: Standard "(001.005)" Standard ROM
*Font LetterGothic-Bold: Standard "(001.005)" Standard ROM
*Font LetterGothic-Oblique: Standard "(001.005)" Standard ROM
*Font Maryland: Standard "(001.005)" Standard ROM
*Font Oklahoma: Standard "(001.005)" Standard ROM
*Font Oklahoma-Bold: Standard "(001.005)" Standard ROM
*Font Oklahoma-Oblique: Standard "(001.005)" Standard ROM
*Font Oklahoma-BoldOblique: Standard "(001.005)" Standard ROM
*Font Utah: Standard "(001.005)" Standard ROM
*Font Utah-Bold: Standard "(001.005)" Standard ROM
*Font Utah-Oblique: Standard "(001.005)" Standard ROM
*Font Utah-BoldOblique: Standard "(001.005)" Standard ROM
*Font UtahCondensed: Standard "(001.005)" Standard ROM
*Font UtahCondensed-Bold: Standard "(001.005)" Standard ROM
*Font UtahCondensed-Oblique: Standard "(001.004)" Standard ROM
*Font UtahCondensed-BoldOblique: Standard "(001.005)" Standard ROM
*Font BermudaScript: Standard "(001.005)" Standard ROM
*Font Germany: Standard "(001.005)" Standard ROM
*Font SanDiego: Standard "(001.005)" Standard ROM
*Font US-Roman: Standard "(001.005)" Standard ROM
EOF

cat <<'EOF' > "/usr/share/cups/model/KOC751iUX.ppd"
*PPD-Adobe: "4.3"
*cupsLanguages: "en"
*FormatVersion: "4.3"
*LanguageVersion: English
*LanguageEncoding: ISOLatin1
*FileVersion: "40002.0007"
*% Linux Version

*Manufacturer: "KONICA MINOLTA"
*ModelName: "KONICA MINOLTA C751iSeriesPS/P"
*ShortNickName: "KONICA MINOLTA C751i"
*NickName: "KONICA MINOLTA C751iSeriesPS(P)"
*PCFileName: "KOC751iUX.ppd"
*Product: "(KONICA MINOLTA C751i)"
*PSVersion: "(3016.102) 1"

*% === Device Capabilities ============
*LanguageLevel: "3"

*ColorDevice: True
*DefaultColorSpace: CMYK

*Protocols: TBCP

*LandscapeOrientation: Plus90

*ScreenFreq: "70.0"
*ScreenAngle: "45.0"
*DefaultScreenProc: Dot
*ScreenProc Dot: "{180 mul cos exch 180 mul cos add 2 div}"
*ScreenProc Line: "{ pop }"
*ScreenProc Ellipse: "{ dup 5 mul 8 div mul exch dup mul exch add sqrt 1 exch sub}"

*Throughput: "75"

*DefaultResolution: 600dpi

*%
*% === Begin Interpreter Header Common  ============
*%
*SuggestedJobTimeout: "0"
*SuggestedWaitTimeout: "300"
*RequiresPageRegion All: True
*DefaultOutputOrder: Normal
*DefaultTransfer: Null
*Transfer Null: "{ }"
*Transfer Null.Inverse: "{ 1 exch sub }"

*%
*% === Begin Emepror Header Functions  ============
*%
*TTRasterizer: Type42
*?TTRasterizer: "
 save
 42 /FontType resourcestatus
 { pop pop (Type42)} {pop pop (None)} ifelse = flush
 restore"
*End

*FileSystem: True
*?FileSystem: "
 save
 statusdict /diskonline get exec {(True)}{(False)} ifelse = flush
 restore"
*End

*Password: "0"

*ExitServer: "
 count 0 eq
 { false } { true exch startjob } ifelse
 not { 
 (WARNING : Cannot perform the exitserver command.) = 
 (Password supplied is not valid.) = 
 (Please contact the author of this software.) = flush quit
 } if"
*End

*Reset: "
 count 0 eq
 { false } { true exch startjob } ifelse
 not {
 (WARNING: Cannot reset printer.) =
 (Missing or invalid password.) =
 (Please contact the author of this software.) = flush quit
 } if
 systemdict /quit get exec
 (WARNING : Printer Reset Failed.) = flush"
*End

*%
*% === Begin Custom Header Function ============
*%
*FreeVM: "12883968"

*%
*% === Begin Installable Options ============
*%
*OpenGroup: InstallableOptions/Options Installed
*OpenUI *PaperSources/Paper Source Unit: PickOne
*OrderDependency: 1 AnySetup *PaperSources
*DefaultPaperSources: None
*PaperSources None/None:  ""
*PaperSources LU207/LU-207:  ""
*PaperSources LU302/LU-302:  ""
*PaperSources LU205/LU-205:  ""
*PaperSources LU303/LU-303:  ""
*PaperSources PC116/PC-116:  ""
*PaperSources PC116+LU207/PC-116+LU-207:  ""
*PaperSources PC116+LU302/PC-116+LU-302:  ""
*PaperSources PC118/PC-118:  ""
*PaperSources PC216/PC-216:  ""
*PaperSources PC216+LU207/PC-216+LU-207:  ""
*PaperSources PC216+LU302/PC-216+LU-302:  ""
*PaperSources PC218/PC-218:  ""
*PaperSources PC416/PC-416:  ""
*PaperSources PC416+LU207/PC-416+LU-207:  ""
*PaperSources PC416+LU302/PC-416+LU-302:  ""
*PaperSources PC417/PC-417:  ""
*PaperSources PC417+LU207/PC-417+LU-207:  ""
*PaperSources PC417+LU302/PC-417+LU-302:  ""
*PaperSources PC418/PC-418:  ""
*PaperSources PFP13T2/Tray2:  ""
*PaperSources PFP13T23/Tray2+3:  ""
*PaperSources PFP13T234/Tray2+3+4:  ""
*CloseUI: *PaperSources

*OpenUI *Finisher/Finisher: PickOne
*OrderDependency: 1 AnySetup *Finisher
*DefaultFinisher: None
*Finisher None/None:  ""
*Finisher FS533/FS-533:  ""
*Finisher FS539/FS-539:  ""
*Finisher JS506/JS-506:  ""
*Finisher JS508/JS-508:  ""
*Finisher FS540/FS-540:  ""
*Finisher FS540JS602/FS-540+JS-602:  ""
*Finisher FS542/FS-542:  ""
*CloseUI: *Finisher

*OpenUI *KOPunch/Punch Unit: PickOne
*OrderDependency: 1 AnySetup *KOPunch
*DefaultKOPunch: None
*KOPunch None/None:  ""
*KOPunch PK519/PK-519 (2-Hole):  ""
*KOPunch PK519-3/PK-519 (2/3-Hole):  ""
*KOPunch PK519-4/PK-519 (2/4-Hole):  ""
*KOPunch PK519-SWE4/PK-519 (SWE 4-Hole):  ""
*KOPunch PK524/PK-524 (2-Hole):  ""
*KOPunch PK524-3/PK-524 (2/3-Hole):  ""
*KOPunch PK524-4/PK-524 (2/4-Hole):  ""
*KOPunch PK524-SWE4/PK-524 (SWE 4-Hole):  ""
*KOPunch PK526/PK-526 (2-Hole):  ""
*KOPunch PK526-3/PK-526 (2/3-Hole):  ""
*KOPunch PK526-4/PK-526 (2/4-Hole):  ""
*KOPunch PK526-SWE4/PK-526 (SWE 4-Hole):  ""
*KOPunch PK527/PK-527 (2-Hole):  ""
*KOPunch PK527-3/PK-527 (2/3-Hole):  ""
*KOPunch PK527-4/PK-527 (2/4-Hole):  ""
*KOPunch PK527-SWE4/PK-527 (SWE 4-Hole):  ""
*CloseUI: *KOPunch

*OpenUI *ZFoldUnit/Z-Fold Unit: PickOne
*OrderDependency: 1 AnySetup *ZFoldUnit
*DefaultZFoldUnit: None
*ZFoldUnit None/None:  ""
*ZFoldUnit ZU609/ZU-609:  ""
*CloseUI: *ZFoldUnit

*OpenUI *PostInserter/Post Inserter: PickOne
*OrderDependency: 1 AnySetup *PostInserter
*DefaultPostInserter: None
*PostInserter None/None:  ""
*PostInserter PI507/PI-507:  ""
*CloseUI: *PostInserter

*OpenUI *SaddleUnit/Saddle Kit: PickOne
*OrderDependency: 1 AnySetup *SaddleUnit
*DefaultSaddleUnit: None
*SaddleUnit None/None:  ""
*SaddleUnit SD511/SD-511:  ""
*SaddleUnit SD512/SD-512:  ""
*CloseUI: *SaddleUnit

*OpenUI *PrinterHDD/Storage: PickOne
*OrderDependency: 1 AnySetup *PrinterHDD
*DefaultPrinterHDD: HDD
*PrinterHDD None/None:  ""
*PrinterHDD HDD/Installed:  ""
*CloseUI: *PrinterHDD

*OpenUI *Model/Model: PickOne
*OrderDependency: 1 AnySetup *Model
*DefaultModel: C751i
*Model C751i/C751i:  ""
*Model C651i/C651i:  ""
*Model C551i/C551i:  ""
*Model C451i/C451i:  ""
*Model C361i/C361i:  ""
*Model C301i/C301i:  ""
*Model C251i/C251i:  ""
*Model C4051i/C4051i:  ""
*Model C3351i/C3351i:  ""
*Model C4001i/C4001i:  ""
*Model C3301i/C3301i:  ""
*Model C3321i/C3321i:  ""
*Model C750i/C750i:  ""
*Model C650i/C650i:  ""
*Model C550i/C550i:  ""
*Model C450i/C450i:  ""
*Model C360i/C360i:  ""
*Model C300i/C300i:  ""
*Model C250i/C250i:  ""
*Model C287i/C287i:  ""
*Model C257i/C257i:  ""
*Model C227i/C227i:  ""
*Model C286i/C286i:  ""
*Model C266i/C266i:  ""
*Model C226i/C226i:  ""
*Model C4050i/C4050i:  ""
*Model C3350i/C3350i:  ""
*Model C4000i/C4000i:  ""
*Model C3300i/C3300i:  ""
*Model C3320i/C3320i:  ""
*CloseUI: *Model

*CloseGroup: InstallableOptions

*%
*% === Begin Print Quality & Effects ============
*%
*OpenUI *Collate/Collate: Boolean
*OrderDependency: 1 AnySetup *Collate
*DefaultCollate: True
*Collate False/Off:  "<< /Collate false >> setpagedevice"
*Collate True/On:  "<< /Collate true >> setpagedevice"
*CloseUI: *Collate

*OpenUI *InputSlot/Paper Tray: PickOne
*OrderDependency: 50 AnySetup *InputSlot
*DefaultInputSlot: AutoSelect
*InputSlot AutoSelect/Auto:  ""
*InputSlot Tray1/Tray1:  "<< /ManualFeed false /MediaPosition 0 /TraySwitch false >> setpagedevice"
*InputSlot Tray2/Tray2:  "<< /ManualFeed false /MediaPosition 1 /TraySwitch false >> setpagedevice"
*InputSlot Tray3/Tray3:  "<< /ManualFeed false /MediaPosition 2 /TraySwitch false >> setpagedevice"
*InputSlot Tray4/Tray4:  "<< /ManualFeed false /MediaPosition 3 /TraySwitch false >> setpagedevice"
*InputSlot LCT/LCT:  "<< /ManualFeed false /MediaPosition 4 /TraySwitch false >> setpagedevice"
*InputSlot ManualFeed/Bypass Tray:  "<< /ManualFeed true /TraySwitch false >> setpagedevice"
*CloseUI: *InputSlot

*OpenUI *MediaType/Paper Type: PickOne
*OrderDependency: 65 AnySetup *MediaType
*DefaultMediaType: Plain
*MediaType Plain/Plain Paper:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Plain(2nd)/Plain Paper(Side2):  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType PlainPlus/Plain Paper+:  "<< /KMMediaType (PlainPlus) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType PlainPlus(2nd)/Plain Paper+(Side2):  "<< /KMMediaType (PlainPlus) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick1/Thick 1:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick1(2nd)/Thick 1(Side2):  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick1Plus/Thick 1+:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thickplus) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick1Plus(2nd)/Thick 1+(Side2):  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thickplus) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick2/Thick 2:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick2) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick2(2nd)/Thick 2(Side2):  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick2) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick3/Thick 3:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick3) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick3(2nd)/Thick 3(Side2):  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick3) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick4/Thick 4:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick4) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thick4(2nd)/Thick 4(Side2):  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thick4) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Thin/Thin Paper:  "<< /KMMediaType (Plain) /KMMediaColor (None) /KMMediaWeight (Thin) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Envelope/Envelope:  "<< /KMMediaType (Envelope) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Transparency/Transparency:  "<< /KMMediaType (Transparency) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Color/Colored Paper:  "<< /KMMediaType (Plain) /KMMediaColor (Other) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType SingleSidedOnly/Single Side Only:  "<< /KMMediaType (SingleSidedOnly) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType TAB/TAB:  "<< /KMMediaType (Tab) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Letterhead/Letterhead:  "<< /KMMediaType (Letterhead) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Special/Special Paper:  "<< /KMMediaType (Special) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Recycled/Recycled:  "<< /KMMediaType (UserCustomType20) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Recycled(2nd)/Recycled(Side2):  "<< /KMMediaType (UserCustomType20) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Labels/Label:  "<< /KMMediaType (Labels) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Postcard/Postcard:  "<< /KMMediaType (Postcard) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Glossy/Glossy 1:  "<< /KMMediaType (Gloss) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType GlossyPlus/Glossy 1+:  "<< /KMMediaType (GlossPlus) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType Glossy2/Glossy 2:  "<< /KMMediaType (Gloss2) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User1/User1(Plain Paper):  "<< /KMMediaType (CustomType) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User1(2nd)/User1(Plain. Side2):  "<< /KMMediaType (CustomType) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User2_1/User2(Plain Paper):  "<< /KMMediaType (CustomType2) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User2(2nd)_1/User2(Plain. Side2):  "<< /KMMediaType (CustomType2) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User2/User2(Plain Paper+):  "<< /KMMediaType (CustomType2) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User2(2nd)/User2(Plain.+ Side2):  "<< /KMMediaType (CustomType2) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User3/User3(Thick 1):  "<< /KMMediaType (CustomType3) /KMMediaColor (None) /KMMediaWeight (Thick) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User3(2nd)/User3(Thick 1 Side2):  "<< /KMMediaType (CustomType3) /KMMediaColor (None) /KMMediaWeight (Thick) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User4/User4(Thick 1+):  "<< /KMMediaType (CustomType4) /KMMediaColor (None) /KMMediaWeight (Thickplus) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User4(2nd)/User4(Thick 1+ Side2):  "<< /KMMediaType (CustomType4) /KMMediaColor (None) /KMMediaWeight (Thickplus) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User5/User5(Thick 2):  "<< /KMMediaType (CustomType5) /KMMediaColor (None) /KMMediaWeight (Thick2) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User5(2nd)/User5(Thick 2 Side2):  "<< /KMMediaType (CustomType5) /KMMediaColor (None) /KMMediaWeight (Thick2) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User6/User6(Thick 3):  "<< /KMMediaType (CustomType6) /KMMediaColor (None) /KMMediaWeight (Thick3) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User6(2nd)/User6(Thick 3 Side2):  "<< /KMMediaType (CustomType6) /KMMediaColor (None) /KMMediaWeight (Thick3) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User7/User7:  "<< /KMMediaType (CustomType7) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted false /MediaPrepunched false >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType User7(2nd)/User7(Side2):  "<< /KMMediaType (CustomType7) /KMMediaColor (None) /KMMediaWeight (Normal) /MediaTabType (None) /MediaPreprinted true /MediaPrepunched false >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType PrinterDefault/Not Specified:  "<< /KMMediaType (NoSet) /KMMediaColor (NoSet) /KMMediaWeight (NoSet) >> 
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType1/<3C>Custom 1<3E>:  "<< /KMMediaType (UserCustomType1) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType1(2nd)/<3C>Custom 1<3E>(Side2):  "<< /KMMediaType (UserCustomType1) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType2/<3C>Custom 2<3E>:  "<< /KMMediaType (UserCustomType2) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType2(2nd)/<3C>Custom 2<3E>(Side2):  "<< /KMMediaType (UserCustomType2) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType3/<3C>Custom 3<3E>:  "<< /KMMediaType (UserCustomType3) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType3(2nd)/<3C>Custom 3<3E>(Side2):  "<< /KMMediaType (UserCustomType3) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType4/<3C>Custom 4<3E>:  "<< /KMMediaType (UserCustomType4) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType4(2nd)/<3C>Custom 4<3E>(Side2):  "<< /KMMediaType (UserCustomType4) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType5/<3C>Custom 5<3E>:  "<< /KMMediaType (UserCustomType5) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType5(2nd)/<3C>Custom 5<3E>(Side2):  "<< /KMMediaType (UserCustomType5) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType6/<3C>Custom 6<3E>:  "<< /KMMediaType (UserCustomType6) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType6(2nd)/<3C>Custom 6<3E>(Side2):  "<< /KMMediaType (UserCustomType6) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType7/<3C>Custom 7<3E>:  "<< /KMMediaType (UserCustomType7) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType7(2nd)/<3C>Custom 7<3E>(Side2):  "<< /KMMediaType (UserCustomType7) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType8/<3C>Custom 8<3E>:  "<< /KMMediaType (UserCustomType8) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType8(2nd)/<3C>Custom 8<3E>(Side2):  "<< /KMMediaType (UserCustomType8) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType9/<3C>Custom 9<3E>:  "<< /KMMediaType (UserCustomType9) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType9(2nd)/<3C>Custom 9<3E>(Side2):  "<< /KMMediaType (UserCustomType9) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType10/<3C>Custom 10<3E>:  "<< /KMMediaType (UserCustomType10) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType10(2nd)/<3C>Custom 10<3E>(Side2):  "<< /KMMediaType (UserCustomType10) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType11/<3C>Custom 11<3E>:  "<< /KMMediaType (UserCustomType11) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType11(2nd)/<3C>Custom 11<3E>(Side2):  "<< /KMMediaType (UserCustomType11) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType12/<3C>Custom 12<3E>:  "<< /KMMediaType (UserCustomType12) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType12(2nd)/<3C>Custom 12<3E>(Side2):  "<< /KMMediaType (UserCustomType12) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType13/<3C>Custom 13<3E>:  "<< /KMMediaType (UserCustomType13) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType13(2nd)/<3C>Custom 13<3E>(Side2):  "<< /KMMediaType (UserCustomType13) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType14/<3C>Custom 14<3E>:  "<< /KMMediaType (UserCustomType14) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType14(2nd)/<3C>Custom 14<3E>(Side2):  "<< /KMMediaType (UserCustomType14) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType15/<3C>Custom 15<3E>:  "<< /KMMediaType (UserCustomType15) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType15(2nd)/<3C>Custom 15<3E>(Side2):  "<< /KMMediaType (UserCustomType15) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType16/<3C>Custom 16<3E>:  "<< /KMMediaType (UserCustomType16) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType16(2nd)/<3C>Custom 16<3E>(Side2):  "<< /KMMediaType (UserCustomType16) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType17/<3C>Custom 17<3E>:  "<< /KMMediaType (UserCustomType17) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType17(2nd)/<3C>Custom 17<3E>(Side2):  "<< /KMMediaType (UserCustomType17) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType18/<3C>Custom 18<3E>:  "<< /KMMediaType (UserCustomType18) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType18(2nd)/<3C>Custom 18<3E>(Side2):  "<< /KMMediaType (UserCustomType18) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType19/<3C>Custom 19<3E>:  "<< /KMMediaType (UserCustomType19) >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*MediaType UserCustomType19(2nd)/<3C>Custom 19<3E>(Side2):  "<< /KMMediaType (UserCustomType19) /MediaPreprinted true >>
 /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *MediaType

*OpenUI *PageSize/Paper Size: PickOne
*OrderDependency: 60 AnySetup *PageSize
*DefaultPageSize: Letter
*PageSize A3/A3:  "<< /PageSize [842 1191] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A4/A4:  "<< /PageSize [595 842] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A5/A5:  "<< /PageSize [420 595] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A6/A6:  "<< /PageSize [297 420] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize B4/B4:  "<< /PageSize [729 1032] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize B5/B5:  "<< /PageSize [516 729] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize B6/B6:  "<< /PageSize [363 516] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize SRA3/SRA3:  "<< /PageSize [907 1276] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 220mmx330mm/220mmx330mm:  "<< /PageSize [624 935] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 12x18/12x18:  "<< /PageSize [864 1296] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize Tabloid/11x17:  "<< /PageSize [792 1224] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize Legal/8 1/2x14:  "<< /PageSize [612 1008] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize Letter/8 1/2x11:  "<< /PageSize [612 792] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize LetterPlus/8 1/2x12 11/16:  "<< /PageSize [612 914] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize Statement/5 1/2x8 1/2:  "<< /PageSize [396 612] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8x13/8x13:  "<< /PageSize [576 936] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8.5x13/8 1/2x13:  "<< /PageSize [612 936] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8.5x13.5/8 1/2x13 1/2:  "<< /PageSize [612 972] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8.25x13/8 1/4x13:  "<< /PageSize [594 936] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8.125x13.25/8 1/8x13 1/4:  "<< /PageSize [585 954] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8x10/8x10:  "<< /PageSize [576 720] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8x10.5/8x10 1/2:  "<< /PageSize [576 756] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize Executive/7 1/4x10 1/2:  "<< /PageSize [522 756] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 8K/8K:  "<< /PageSize [765 1105] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 16K/16K:  "<< /PageSize [553 765] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvISOB5/Envelope B5:  "<< /PageSize [499 709] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvC4/Envelope C4:  "<< /PageSize [649 918] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvC5/Envelope C5:  "<< /PageSize [459 649] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvC6/Envelope C6:  "<< /PageSize [323 459] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvChou3/Envelope Nagagata3:  "<< /PageSize [340 666] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvChou4/Envelope Nagagata4:  "<< /PageSize [255 581] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvYou3/Envelope Yougata3:  "<< /PageSize [278 420] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvYou4/Envelope Yougata4:  "<< /PageSize [298 666] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvKaku1/Envelope Kakugata1:  "<< /PageSize [765 1083] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvKaku2/Envelope Kakugata2:  "<< /PageSize [680 941] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvKaku3/Envelope Kakugata3:  "<< /PageSize [612 785] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvDL/Envelope DL:  "<< /PageSize [312 624] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize EnvMonarch/Envelope Monarch:  "<< /PageSize [279 540] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize Env10/Envelope Com10:  "<< /PageSize [297 684] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize JapanesePostCard/Postcard:  "<< /PageSize [284 419] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize 4x6_PostCard/4x6 Postcard:  "<< /PageSize [288 432] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize DoublePostcardRotated/Double Postcard:  "<< /PageSize [420 567] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A3Extra/A3W:  "<< /PageSize [856 1205] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A4Extra/A4W:  "<< /PageSize [610 856] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A5Extra/A5W:  "<< /PageSize [434 610] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize B4Extra/B4W:  "<< /PageSize [743 1046] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize B5Extra/B5W:  "<< /PageSize [530 743] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize TabloidExtra/11x17W:  "<< /PageSize [806 1238] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize LetterExtra/8 1/2x11W:  "<< /PageSize [626 806] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize StatementExtra/5 1/2x8 1/2W:  "<< /PageSize [410 626] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize LetterTab-F/8 1/2x11 Tab:  "<< /PageSize [656 792] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageSize A4Tab-F/A4 Tab:  "<< /PageSize [639 842] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *PageSize


*%
*% === Begin Functions Section ============
*%
*OpenGroup: Finishing/Finishing Options
*OpenUI *KMDuplex/Print Type: PickOne
*OrderDependency: 15 AnySetup *KMDuplex
*DefaultKMDuplex: 2Sided
*KMDuplex 1Sided/1-Sided:  "<< /Duplex false >> setpagedevice"
*KMDuplex 2Sided/2-Sided:  "<< /Duplex true >> setpagedevice"
*CloseUI: *KMDuplex

*OpenUI *Staple/Staple: PickOne
*OrderDependency: 2 AnySetup *Staple
*DefaultStaple: None
*Staple None/Off:  "<< /Finish 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Staple 1StapleAuto(Left)/Left Corner (Auto):  "<< /Finish 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Staple 1StapleZeroLeft/Left Corner (0 degrees):  "<< /Finish 5 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Staple 1StapleAuto(Right)/Right Corner (Auto):  "<< /Finish 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Staple 1StapleZeroRight/Right Corner (0 degrees):  "<< /Finish 6 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Staple 2Staples/2 Position:  "<< /Finish 4 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *Staple

*OpenUI *Punch/Punch: PickOne
*OrderDependency: 1 AnySetup *Punch
*DefaultPunch: None
*Punch None/Off:  "<< /PunchMode false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Punch 2holes/2-Hole:  "<< /PunchMode true /PunchNum 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Punch 3holes/3-Hole:  "<< /PunchMode true /PunchNum 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Punch 4holes/4-Hole:  "<< /PunchMode true /PunchNum 4 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *Punch

*OpenUI *Fold/Fold: PickOne
*OrderDependency: 3 AnySetup *Fold
*DefaultFold: None
*Fold None/Off:  "<< /FoldType (Off) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Fold Stitch/Center Staple and Fold:  "<< /Collate true >> setpagedevice
 << /FoldType (CenterFoldIn) /StitchType true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*Fold HalfFold/Half-Fold:  "<< /Collate true >> setpagedevice
 << /FoldType (CenterFoldIn) /StitchType false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*Fold TriFold/Tri-Fold:  "<< /Collate true >> setpagedevice
 << /FoldType (LetterFoldIn) /StitchType false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*Fold ZFold1/Z-Fold(A3,B4,11x17,8K):  "<< /FoldType (ZFold) /FeedDirection 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Fold ZFold2/Z-Fold(8 1/2x14):  "<< /FoldType (ZFold) /FeedDirection 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *Fold

*OpenUI *SelectColor/Select Color: PickOne
*OrderDependency: 10 AnySetup *SelectColor
*DefaultSelectColor: Auto
*SelectColor Auto/Auto Color:  "<< /HWResolution [600 600] >> setpagedevice
 <</ProcessColorModel /DeviceCMYK>> setpagedevice
 << /KMColorSelect 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec
 << /DriverColorSelect 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*SelectColor Color/Full Color:  "<< /HWResolution [600 600] >> setpagedevice
 <</ProcessColorModel /DeviceCMYK>> setpagedevice
 << /KMColorSelect 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec
 << /DriverColorSelect 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*SelectColor Grayscale/Gray Scale:  "<< /HWResolution [600 600] >> setpagedevice
 <</ProcessColorModel /DeviceGray>> setpagedevice
 << /KMColorSelect 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec
 << /DriverColorSelect 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *SelectColor

*OpenUI *GlossyMode/Glossy Mode: Boolean
*OrderDependency: 10 AnySetup *GlossyMode
*DefaultGlossyMode: False
*GlossyMode False/Off:  "<< /GlossyMode false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GlossyMode True/On:  "<< /GlossyMode true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *GlossyMode

*OpenUI *Offset/Offset: Boolean
*OrderDependency: 10 AnySetup *Offset
*DefaultOffset: False
*Offset False/Off:  "<< /Jog 0 >> setpagedevice
 << /HWResolution [600 600] >> setpagedevice"
*End
*Offset True/On:  "<< /Jog 3 >> setpagedevice
 << /HWResolution [600 600] >> setpagedevice"
*End
*CloseUI: *Offset

*OpenUI *OutputBin/Output Tray: PickOne
*OrderDependency: 40 AnySetup *OutputBin
*DefaultOutputBin: Default
*OutputBin Default/Default:  "<< /OutputType (Default) >> setpagedevice"
*OutputBin Tray1/Tray1:  "<< /OutputType (Bin2) >> setpagedevice"
*OutputBin Tray2/Tray2:  "<< /OutputType (Bin1) >> setpagedevice"
*OutputBin Tray3/Tray3:  "<< /OutputType (Bin3) >> setpagedevice"
*OutputBin Tray4/Tray4:  "<< /OutputType (Bin4) >> setpagedevice"
*CloseUI: *OutputBin

*OpenUI *Binding/Binding Position: PickOne
*OrderDependency: 15 AnySetup *Binding
*DefaultBinding: LeftBinding
*Binding LeftBinding/Left Bind:  "<< /Binding 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Binding TopBinding/Top Bind:  "<< /Binding 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Binding RightBinding/Right Bind:  "<< /Binding 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *Binding

*OpenUI *Combination/Combination: PickOne
*OrderDependency: 30 AnySetup *Combination
*DefaultCombination: None
*Combination None/Off:  "<< /Layout 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*Combination Booklet/Booklet:  "<< /Collate true >> setpagedevice
 << /Layout 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *Combination

*OpenUI *FrontCoverPage/Front Cover: PickOne
*OrderDependency: 30 AnySetup *FrontCoverPage
*DefaultFrontCoverPage: None
*FrontCoverPage None/Off:  "<< /FrontCover 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*FrontCoverPage Printed/Print:  "<< /Collate true >> setpagedevice
 << /FrontCover 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*FrontCoverPage Blank/Blank:  "<< /Collate true >> setpagedevice
 << /FrontCover 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *FrontCoverPage

*OpenUI *FrontCoverTray/Front Cover Tray: PickOne
*OrderDependency: 31 AnySetup *FrontCoverTray
*DefaultFrontCoverTray: None
*FrontCoverTray None/Off:  ""
*FrontCoverTray Tray1/Tray1:  "<< /FrontCoverTray 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*FrontCoverTray Tray2/Tray2:  "<< /FrontCoverTray 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*FrontCoverTray Tray3/Tray3:  "<< /FrontCoverTray 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*FrontCoverTray Tray4/Tray4:  "<< /FrontCoverTray 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*FrontCoverTray LCT/LCT:  "<< /FrontCoverTray 4 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*FrontCoverTray BypassTray/Bypass Tray:  "<< /FrontCoverTray 40 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *FrontCoverTray

*OpenUI *BackCoverPage/Back Cover: PickOne
*OrderDependency: 32 AnySetup *BackCoverPage
*DefaultBackCoverPage: None
*BackCoverPage None/Off:  "<< /BackCover 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BackCoverPage Printed/Print:  "<< /Collate true >> setpagedevice
 << /BackCover 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*BackCoverPage Blank/Blank:  "<< /Collate true >> setpagedevice
 << /BackCover 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *BackCoverPage

*OpenUI *BackCoverTray/Back Cover Tray: PickOne
*OrderDependency: 33 AnySetup *BackCoverTray
*DefaultBackCoverTray: None
*BackCoverTray None/Off:  ""
*BackCoverTray Tray1/Tray1:  "<< /BackCoverTray 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BackCoverTray Tray2/Tray2:  "<< /BackCoverTray 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BackCoverTray Tray3/Tray3:  "<< /BackCoverTray 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BackCoverTray Tray4/Tray4:  "<< /BackCoverTray 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BackCoverTray LCT/LCT:  "<< /BackCoverTray 4 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BackCoverTray BypassTray/Bypass Tray:  "<< /BackCoverTray 40 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *BackCoverTray

*OpenUI *PIFrontCover/Front Cover from Post Inserter: PickOne
*OrderDependency: 10 AnySetup *PIFrontCover
*DefaultPIFrontCover: None
*PIFrontCover None/Off:  ""
*PIFrontCover PITray1/PI Tray 1:  "<< /Collate true >> setpagedevice
 << /PIFrontTray 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PIFrontCover PITray2/PI Tray 2:  "<< /Collate true >> setpagedevice
 << /PIFrontTray 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *PIFrontCover

*OpenUI *PIBackCover/Back Cover from Post Inserter: PickOne
*OrderDependency: 10 AnySetup *PIBackCover
*DefaultPIBackCover: None
*PIBackCover None/Off:  ""
*PIBackCover PITray1/PI Tray 1:  "<< /Collate true >> setpagedevice
 << /PIBackTray 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PIBackCover PITray2/PI Tray 2:  "<< /Collate true >> setpagedevice
 << /PIBackTray 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *PIBackCover

*OpenUI *TransparencyInterleave/Transparency Interleave: PickOne
*OrderDependency: 66 AnySetup *TransparencyInterleave
*DefaultTransparencyInterleave: None
*TransparencyInterleave None/Off:  "<< /OHPInterleave 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TransparencyInterleave Blank/Blank:  "<< /Collate true >> setpagedevice
 << /OHPInterleave 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *TransparencyInterleave

*OpenUI *OHPOpTray/Interleave Tray: PickOne
*OrderDependency: 66 AnySetup *OHPOpTray
*DefaultOHPOpTray: None
*OHPOpTray None/Off:  ""
*OHPOpTray Tray1/Tray1:  "<< /OHPOpTray 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OHPOpTray Tray2/Tray2:  "<< /OHPOpTray 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OHPOpTray Tray3/Tray3:  "<< /OHPOpTray 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OHPOpTray Tray4/Tray4:  "<< /OHPOpTray 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OHPOpTray LCT/LCT:  "<< /OHPOpTray 4 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *OHPOpTray

*OpenUI *WaitMode/Output Method: PickOne
*OrderDependency: 22 AnySetup *WaitMode
*DefaultWaitMode: None
*WaitMode None/Print:  "<< /WaitMode 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*WaitMode ProofMode/Proof Print:  "<< /Collate true >> setpagedevice
 << /WaitMode 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *WaitMode

*OpenUI *OriginalImageType/Image Quality Setting: PickOne
*OrderDependency: 10 AnySetup *OriginalImageType
*DefaultOriginalImageType: Document-Photo
*OriginalImageType Document-Photo/Document/Photo:  "<< /Exposure 9 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OriginalImageType Document/Document:  "<< /Exposure 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OriginalImageType Photo/Photo:  "<< /Exposure 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*OriginalImageType CAD/CAD:  "<< /Exposure 5 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *OriginalImageType

*OpenUI *AutoTrapping/Auto Trapping: Boolean
*OrderDependency: 10 AnySetup *AutoTrapping
*DefaultAutoTrapping: False
*AutoTrapping False/Off:  "<< /AutoTrapMode false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*AutoTrapping True/On:  "<< /AutoTrapMode true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *AutoTrapping

*OpenUI *BlackOverPrint/Black Over Print: PickOne
*OrderDependency: 10 AnySetup *BlackOverPrint
*DefaultBlackOverPrint: Off
*BlackOverPrint Off/Off:  "<< /BopMode 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BlackOverPrint Text/Text:  "<< /BopMode 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*BlackOverPrint TextGraphic/Text/Figure:  "<< /BopMode 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *BlackOverPrint

*OpenUI *TextColorMatching/Color Matching (Text): PickOne
*OrderDependency: 10 AnySetup *TextColorMatching
*DefaultTextColorMatching: Auto
*TextColorMatching Auto/Auto:  "<< /QualityAdjustMode 1 /ColorMatching1 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextColorMatching ColorEmphasis/Color Highlight(Vivid):  "<< /QualityAdjustMode 1 /ColorMatching1 9 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextColorMatching Sharp/Color Priority(Sharp):  "<< /QualityAdjustMode 1 /ColorMatching1 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextColorMatching Colorimetric/Colorimetric(Natural):  "<< /QualityAdjustMode 1 /ColorMatching1 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *TextColorMatching

*OpenUI *TextPureBlack/Pure Black (Text): PickOne
*OrderDependency: 10 AnySetup *TextPureBlack
*DefaultTextPureBlack: Auto
*TextPureBlack Auto/Auto:  "<< /Neugray1 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextPureBlack Off/Off:  "<< /Neugray1 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextPureBlack On/On:  "<< /Neugray1 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *TextPureBlack

*OpenUI *TextScreen/Screen (Text): PickOne
*OrderDependency: 10 AnySetup *TextScreen
*DefaultTextScreen: Auto
*TextScreen Auto/Auto:  "<< /Screen1 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextScreen Gradation/Gradation:  "<< /Screen1 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextScreen Resolution/Resolution:  "<< /Screen1 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TextScreen HighResolution/High Resolution:  "<< /Screen1 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *TextScreen

*OpenUI *PhotoColorMatching/Color Matching (Photo): PickOne
*OrderDependency: 10 AnySetup *PhotoColorMatching
*DefaultPhotoColorMatching: Auto
*PhotoColorMatching Auto/Auto:  "<< /ColorMatching2 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoColorMatching ColorEmphasis/Color Highlight(Vivid):  "<< /ColorMatching2 9 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoColorMatching Sharp/Color Priority(Sharp):  "<< /ColorMatching2 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoColorMatching Colorimetric/Colorimetric(Natural):  "<< /ColorMatching2 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *PhotoColorMatching

*OpenUI *PhotoPureBlack/Pure Black (Photo): PickOne
*OrderDependency: 10 AnySetup *PhotoPureBlack
*DefaultPhotoPureBlack: Auto
*PhotoPureBlack Auto/Auto:  "<< /Neugray2 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoPureBlack Off/Off:  "<< /Neugray2 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoPureBlack On/On:  "<< /Neugray2 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *PhotoPureBlack

*OpenUI *PhotoScreen/Screen (Photo): PickOne
*OrderDependency: 10 AnySetup *PhotoScreen
*DefaultPhotoScreen: Auto
*PhotoScreen Auto/Auto:  "<< /Screen2 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoScreen Gradation/Gradation:  "<< /Screen2 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoScreen Resolution/Resolution:  "<< /Screen2 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoScreen HighResolution/High Resolution:  "<< /Screen2 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *PhotoScreen

*OpenUI *PhotoSmoothing/Smoothing (Photo): PickOne
*OrderDependency: 10 AnySetup *PhotoSmoothing
*DefaultPhotoSmoothing: Auto
*PhotoSmoothing Auto/Auto:  "<< /Smoothing2 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoSmoothing None/Off:  "<< /Smoothing2 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoSmoothing Dark/Dark:  "<< /Smoothing2 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoSmoothing Medium/Medium:  "<< /Smoothing2 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*PhotoSmoothing Light/Light:  "<< /Smoothing2 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *PhotoSmoothing

*OpenUI *GraphicColorMatching/Color Matching (Graphic): PickOne
*OrderDependency: 10 AnySetup *GraphicColorMatching
*DefaultGraphicColorMatching: Auto
*GraphicColorMatching Auto/Auto:  "<< /ColorMatching3 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicColorMatching ColorEmphasis/Color Highlight(Vivid):  "<< /ColorMatching3 9 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicColorMatching Sharp/Color Priority(Sharp):  "<< /ColorMatching3 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicColorMatching Colorimetric/Colorimetric(Natural):  "<< /ColorMatching3 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *GraphicColorMatching

*OpenUI *GraphicPureBlack/Pure Black (Graphic): PickOne
*OrderDependency: 10 AnySetup *GraphicPureBlack
*DefaultGraphicPureBlack: Auto
*GraphicPureBlack Auto/Auto:  "<< /Neugray3 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicPureBlack Off/Off:  "<< /Neugray3 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicPureBlack On/On:  "<< /Neugray3 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *GraphicPureBlack

*OpenUI *GraphicScreen/Screen (Graphic): PickOne
*OrderDependency: 10 AnySetup *GraphicScreen
*DefaultGraphicScreen: Auto
*GraphicScreen Auto/Auto:  "<< /Screen3 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicScreen Gradation/Gradation:  "<< /Screen3 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicScreen Resolution/Resolution:  "<< /Screen3 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicScreen HighResolution/High Resolution:  "<< /Screen3 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *GraphicScreen

*OpenUI *GraphicSmoothing/Smoothing (Graphic): PickOne
*OrderDependency: 10 AnySetup *GraphicSmoothing
*DefaultGraphicSmoothing: Auto
*GraphicSmoothing Auto/Auto:  "<< /Smoothing3 10 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicSmoothing None/Off:  "<< /Smoothing3 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicSmoothing Dark/Dark:  "<< /Smoothing3 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicSmoothing Medium/Medium:  "<< /Smoothing3 2 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*GraphicSmoothing Light/Light:  "<< /Smoothing3 3 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *GraphicSmoothing

*OpenUI *TonerSave/Toner Save: Boolean
*OrderDependency: 10 AnySetup *TonerSave
*DefaultTonerSave: False
*TonerSave False/Off:  "<< /TonerSave 0 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*TonerSave True/On:  "<< /TonerSave 1 >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *TonerSave

*OpenUI *String4Pt/Edge Enhancement: PickOne
*OrderDependency: 10 AnySetup *String4Pt
*DefaultString4Pt: Weak
*String4Pt False/None:  "<< /Point4Character false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*String4Pt Weak/Weak:  "<< /Point4Character true >> /KMOptions /ProcSet findresource /setKMoptions get exec
 << /Point4CharacterType (Low) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*String4Pt Normal/Medium:  "<< /Point4Character true >> /KMOptions /ProcSet findresource /setKMoptions get exec
 << /Point4CharacterType (Middle) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*String4Pt Strong/Strong:  "<< /Point4Character true >> /KMOptions /ProcSet findresource /setKMoptions get exec
 << /Point4CharacterType (High) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *String4Pt

*OpenUI *LineWidthAdjustment/Line Width Adjustment: PickOne
*OrderDependency: 10 AnySetup *LineWidthAdjustment
*DefaultLineWidthAdjustment: Printers
*LineWidthAdjustment Printers/Machine Setting:  ""
*LineWidthAdjustment Thin/Thin:  "<< /LineWidth (Thin) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*LineWidthAdjustment SlightlyThin/Slightly Thin:  "<< /LineWidth (SlightlyThin) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*LineWidthAdjustment Normal/Normal:  "<< /LineWidth (Normal) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*LineWidthAdjustment SlightlyThick/Slightly Thick:  "<< /LineWidth (SlightlyThick) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*LineWidthAdjustment Thick/Thick:  "<< /LineWidth (Thick) >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*CloseUI: *LineWidthAdjustment

*CloseGroup: Finishing

*%
*% === Begin Page Section ============
*%
*OpenUI *PageRegion: PickOne
*OrderDependency: 60 AnySetup *PageRegion
*DefaultPageRegion: Letter
*PageRegion A3/A3:  "<< /PageSize [842 1191] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A4/A4:  "<< /PageSize [595 842] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A5/A5:  "<< /PageSize [420 595] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A6/A6:  "<< /PageSize [297 420] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion B4/B4:  "<< /PageSize [729 1032] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion B5/B5:  "<< /PageSize [516 729] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion B6/B6:  "<< /PageSize [363 516] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion SRA3/SRA3:  "<< /PageSize [907 1276] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 220mmx330mm/220mmx330mm:  "<< /PageSize [624 935] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 12x18/12x18:  "<< /PageSize [864 1296] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion Tabloid/11x17:  "<< /PageSize [792 1224] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion Legal/8 1/2x14:  "<< /PageSize [612 1008] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion Letter/8 1/2x11:  "<< /PageSize [612 792] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion LetterPlus/8 1/2x12 11/16:  "<< /PageSize [612 914] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion Statement/5 1/2x8 1/2:  "<< /PageSize [396 612] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8x13/8x13:  "<< /PageSize [576 936] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8.5x13/8 1/2x13:  "<< /PageSize [612 936] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8.5x13.5/8 1/2x13 1/2:  "<< /PageSize [612 972] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8.25x13/8 1/4x13:  "<< /PageSize [594 936] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8.125x13.25/8 1/8x13 1/4:  "<< /PageSize [585 954] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8x10/8x10:  "<< /PageSize [576 720] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8x10.5/8x10 1/2:  "<< /PageSize [576 756] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion Executive/7 1/4x10 1/2:  "<< /PageSize [522 756] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 8K/8K:  "<< /PageSize [765 1105] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 16K/16K:  "<< /PageSize [553 765] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvISOB5/Envelope B5:  "<< /PageSize [499 709] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvC4/Envelope C4:  "<< /PageSize [649 918] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvC5/Envelope C5:  "<< /PageSize [459 649] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvC6/Envelope C6:  "<< /PageSize [323 459] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvChou3/Envelope Nagagata3:  "<< /PageSize [340 666] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvChou4/Envelope Nagagata4:  "<< /PageSize [255 581] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvYou3/Envelope Yougata3:  "<< /PageSize [278 420] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvYou4/Envelope Yougata4:  "<< /PageSize [298 666] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvKaku1/Envelope Kakugata1:  "<< /PageSize [765 1083] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvKaku2/Envelope Kakugata2:  "<< /PageSize [680 941] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvKaku3/Envelope Kakugata3:  "<< /PageSize [612 785] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvDL/Envelope DL:  "<< /PageSize [312 624] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion EnvMonarch/Envelope Monarch:  "<< /PageSize [279 540] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion Env10/Envelope Com10:  "<< /PageSize [297 684] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion JapanesePostCard/Postcard:  "<< /PageSize [284 419] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion 4x6_PostCard/4x6 Postcard:  "<< /PageSize [288 432] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion DoublePostcardRotated/Double Postcard:  "<< /PageSize [420 567] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A3Extra/A3W:  "<< /PageSize [856 1205] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A4Extra/A4W:  "<< /PageSize [610 856] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A5Extra/A5W:  "<< /PageSize [434 610] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion B4Extra/B4W:  "<< /PageSize [743 1046] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion B5Extra/B5W:  "<< /PageSize [530 743] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion TabloidExtra/11x17W:  "<< /PageSize [806 1238] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion LetterExtra/8 1/2x11W:  "<< /PageSize [626 806] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion StatementExtra/5 1/2x8 1/2W:  "<< /PageSize [410 626] /ImagingBBox null >> setpagedevice
 << /WideMode true /FullBleed true >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion LetterTab-F/8 1/2x11 Tab:  "<< /PageSize [656 792] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*PageRegion A4Tab-F/A4 Tab:  "<< /PageSize [639 842] /ImagingBBox null >> setpagedevice
 << /WideMode false /FullBleed false >> /KMOptions /ProcSet findresource /setKMoptions get exec"
*End
*CloseUI: *PageRegion

*DefaultPaperDimension: Letter
*PaperDimension A3/A3:  "842 1191"
*PaperDimension A4/A4:  "595 842"
*PaperDimension A5/A5:  "420 595"
*PaperDimension A6/A6:  "297 420"
*PaperDimension B4/B4:  "729 1032"
*PaperDimension B5/B5:  "516 729"
*PaperDimension B6/B6:  "363 516"
*PaperDimension SRA3/SRA3:  "907 1276"
*PaperDimension 220mmx330mm/220mmx330mm:  "624 935"
*PaperDimension 12x18/12x18:  "864 1296"
*PaperDimension Tabloid/11x17:  "792 1224"
*PaperDimension Legal/8 1/2x14:  "612 1008"
*PaperDimension Letter/8 1/2x11:  "612 792"
*PaperDimension LetterPlus/8 1/2x12 11/16:  "612 914"
*PaperDimension Statement/5 1/2x8 1/2:  "396 612"
*PaperDimension 8x13/8x13:  "576 936"
*PaperDimension 8.5x13/8 1/2x13:  "612 936"
*PaperDimension 8.5x13.5/8 1/2x13 1/2:  "612 972"
*PaperDimension 8.25x13/8 1/4x13:  "594 936"
*PaperDimension 8.125x13.25/8 1/8x13 1/4:  "585 954"
*PaperDimension 8x10/8x10:  "576 720"
*PaperDimension 8x10.5/8x10 1/2:  "576 756"
*PaperDimension Executive/7 1/4x10 1/2:  "522 756"
*PaperDimension 8K/8K:  "765 1105"
*PaperDimension 16K/16K:  "553 765"
*PaperDimension EnvISOB5/Envelope B5:  "499 709"
*PaperDimension EnvC4/Envelope C4:  "649 918"
*PaperDimension EnvC5/Envelope C5:  "459 649"
*PaperDimension EnvC6/Envelope C6:  "323 459"
*PaperDimension EnvChou3/Envelope Nagagata3:  "340 666"
*PaperDimension EnvChou4/Envelope Nagagata4:  "255 581"
*PaperDimension EnvYou3/Envelope Yougata3:  "278 420"
*PaperDimension EnvYou4/Envelope Yougata4:  "298 666"
*PaperDimension EnvKaku1/Envelope Kakugata1:  "765 1083"
*PaperDimension EnvKaku2/Envelope Kakugata2:  "680 941"
*PaperDimension EnvKaku3/Envelope Kakugata3:  "612 785"
*PaperDimension EnvDL/Envelope DL:  "312 624"
*PaperDimension EnvMonarch/Envelope Monarch:  "279 540"
*PaperDimension Env10/Envelope Com10:  "297 684"
*PaperDimension JapanesePostCard/Postcard:  "284 419"
*PaperDimension 4x6_PostCard/4x6 Postcard:  "288 432"
*PaperDimension DoublePostcardRotated/Double Postcard:  "420 567"
*PaperDimension A3Extra/A3W:  "856 1205"
*PaperDimension A4Extra/A4W:  "610 856"
*PaperDimension A5Extra/A5W:  "434 610"
*PaperDimension B4Extra/B4W:  "743 1046"
*PaperDimension B5Extra/B5W:  "530 743"
*PaperDimension TabloidExtra/11x17W:  "806 1238"
*PaperDimension LetterExtra/8 1/2x11W:  "626 806"
*PaperDimension StatementExtra/5 1/2x8 1/2W:  "410 626"
*PaperDimension LetterTab-F/8 1/2x11 Tab:  "656 792"
*PaperDimension A4Tab-F/A4 Tab:  "639 842"

*DefaultImageableArea: Letter
*ImageableArea A3/A3:  "12 12 830 1179"
*ImageableArea A4/A4:  "12 12 583 830"
*ImageableArea A5/A5:  "12 12 408 583"
*ImageableArea A6/A6:  "12 12 285 408"
*ImageableArea B4/B4:  "12 12 717 1020"
*ImageableArea B5/B5:  "12 12 504 717"
*ImageableArea B6/B6:  "12 12 351 504"
*ImageableArea SRA3/SRA3:  "19 19 888 1257"
*ImageableArea 220mmx330mm/220mmx330mm:  "12 12 612 923"
*ImageableArea 12x18/12x18:  "12 12 852 1284"
*ImageableArea Tabloid/11x17:  "12 12 780 1212"
*ImageableArea Legal/8 1/2x14:  "12 12 600 996"
*ImageableArea Letter/8 1/2x11:  "12 12 600 780"
*ImageableArea LetterPlus/8 1/2x12 11/16:  "12 12 600 902"
*ImageableArea Statement/5 1/2x8 1/2:  "12 12 384 600"
*ImageableArea 8x13/8x13:  "12 12 564 924"
*ImageableArea 8.5x13/8 1/2x13:  "12 12 600 924"
*ImageableArea 8.5x13.5/8 1/2x13 1/2:  "12 12 600 960"
*ImageableArea 8.25x13/8 1/4x13:  "12 12 582 924"
*ImageableArea 8.125x13.25/8 1/8x13 1/4:  "12 12 573 942"
*ImageableArea 8x10/8x10:  "12 12 564 708"
*ImageableArea 8x10.5/8x10 1/2:  "12 12 564 744"
*ImageableArea Executive/7 1/4x10 1/2:  "12 12 510 744"
*ImageableArea 8K/8K:  "12 12 753 1093"
*ImageableArea 16K/16K:  "12 12 541 753"
*ImageableArea EnvISOB5/Envelope B5:  "12 12 487 697"
*ImageableArea EnvC4/Envelope C4:  "12 12 637 906"
*ImageableArea EnvC5/Envelope C5:  "12 12 447 637"
*ImageableArea EnvC6/Envelope C6:  "12 12 311 447"
*ImageableArea EnvChou3/Envelope Nagagata3:  "12 12 328 654"
*ImageableArea EnvChou4/Envelope Nagagata4:  "12 12 243 569"
*ImageableArea EnvYou3/Envelope Yougata3:  "12 12 266 408"
*ImageableArea EnvYou4/Envelope Yougata4:  "12 12 286 654"
*ImageableArea EnvKaku1/Envelope Kakugata1:  "12 12 753 1071"
*ImageableArea EnvKaku2/Envelope Kakugata2:  "12 12 668 929"
*ImageableArea EnvKaku3/Envelope Kakugata3:  "12 12 600 773"
*ImageableArea EnvDL/Envelope DL:  "12 12 300 612"
*ImageableArea EnvMonarch/Envelope Monarch:  "12 12 267 528"
*ImageableArea Env10/Envelope Com10:  "12 12 285 672"
*ImageableArea JapanesePostCard/Postcard:  "12 12 272 407"
*ImageableArea 4x6_PostCard/4x6 Postcard:  "12 12 276 420"
*ImageableArea DoublePostcardRotated/Double Postcard:  "12 12 408 555"
*ImageableArea A3Extra/A3W:  "7 7 849 1198"
*ImageableArea A4Extra/A4W:  "7 7 603 849"
*ImageableArea A5Extra/A5W:  "7 7 427 603"
*ImageableArea B4Extra/B4W:  "7 7 736 1039"
*ImageableArea B5Extra/B5W:  "7 7 523 736"
*ImageableArea TabloidExtra/11x17W:  "7 7 799 1231"
*ImageableArea LetterExtra/8 1/2x11W:  "7 7 619 799"
*ImageableArea StatementExtra/5 1/2x8 1/2W:  "7 7 403 619"
*ImageableArea LetterTab-F/8 1/2x11 Tab:  "12 12 644 780"
*ImageableArea A4Tab-F/A4 Tab:  "12 12 627 830"

*%
*% === Begin Constraints Section ============
*%
*UIConstraints: *Offset True *MediaType Envelope
*UIConstraints: *Offset True *MediaType Transparency
*UIConstraints: *Offset True *MediaType TAB
*UIConstraints: *Offset True *PageSize EnvISOB5
*UIConstraints: *Offset True *PageSize EnvC4
*UIConstraints: *Offset True *PageSize EnvC5
*UIConstraints: *Offset True *PageSize EnvC6
*UIConstraints: *Offset True *PageSize EnvChou3
*UIConstraints: *Offset True *PageSize EnvChou4
*UIConstraints: *Offset True *PageSize EnvYou3
*UIConstraints: *Offset True *PageSize EnvYou4
*UIConstraints: *Offset True *PageSize EnvKaku1
*UIConstraints: *Offset True *PageSize EnvKaku2
*UIConstraints: *Offset True *PageSize EnvKaku3
*UIConstraints: *Offset True *PageSize EnvDL
*UIConstraints: *Offset True *PageSize EnvMonarch
*UIConstraints: *Offset True *PageSize Env10
*UIConstraints: *Offset True *PageSize JapanesePostCard
*UIConstraints: *Offset True *PageSize 4x6_PostCard
*UIConstraints: *Offset True *PageSize LetterTab-F
*UIConstraints: *Offset True *PageSize A4Tab-F
*UIConstraints: *Offset True *OutputBin Tray4
*UIConstraints: *Offset True *Staple 1StapleAuto(Left)
*UIConstraints: *Offset True *Staple 1StapleZeroLeft
*UIConstraints: *Offset True *Staple 1StapleAuto(Right)
*UIConstraints: *Offset True *Staple 1StapleZeroRight
*UIConstraints: *Offset True *Staple 2Staples
*UIConstraints: *Offset True *Fold Stitch
*UIConstraints: *Offset True *Fold HalfFold
*UIConstraints: *Offset True *Fold TriFold
*UIConstraints: *Offset True *TransparencyInterleave Blank
*UIConstraints: *Offset True *Model C4051i
*UIConstraints: *Offset True *Model C3351i
*UIConstraints: *Offset True *Model C4001i
*UIConstraints: *Offset True *Model C3301i
*UIConstraints: *Offset True *Model C3321i
*UIConstraints: *Offset True *Model C4050i
*UIConstraints: *Offset True *Model C3350i
*UIConstraints: *Offset True *Model C4000i
*UIConstraints: *Offset True *Model C3300i
*UIConstraints: *Offset True *Model C3320i
*UIConstraints: *InputSlot Tray1 *MediaType Plain(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType PlainPlus(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType Thick1(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType Thick1Plus(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType Thick2(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType Thick3(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType Thick4
*UIConstraints: *InputSlot Tray1 *MediaType Thick4(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType Transparency
*UIConstraints: *InputSlot Tray1 *MediaType TAB
*UIConstraints: *InputSlot Tray1 *MediaType Recycled(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User1(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User2(2nd)_1
*UIConstraints: *InputSlot Tray1 *MediaType User2(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User3(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User4(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User5(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User6(2nd)
*UIConstraints: *InputSlot Tray1 *MediaType User7
*UIConstraints: *InputSlot Tray1 *MediaType User7(2nd)
*UIConstraints: *InputSlot Tray1 *PageSize SRA3
*UIConstraints: *InputSlot Tray1 *PageSize 12x18
*UIConstraints: *InputSlot Tray1 *PageSize LetterPlus
*UIConstraints: *InputSlot Tray1 *PageSize LetterTab-F
*UIConstraints: *InputSlot Tray1 *PageSize A4Tab-F
*UIConstraints: *InputSlot Tray2 *MediaType Plain(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType PlainPlus(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Thick1(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Thick1Plus(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Thick2(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Thick3(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Thick4
*UIConstraints: *InputSlot Tray2 *MediaType Thick4(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Envelope
*UIConstraints: *InputSlot Tray2 *MediaType Transparency
*UIConstraints: *InputSlot Tray2 *MediaType TAB
*UIConstraints: *InputSlot Tray2 *MediaType Recycled(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType Labels
*UIConstraints: *InputSlot Tray2 *MediaType Postcard
*UIConstraints: *InputSlot Tray2 *MediaType Glossy
*UIConstraints: *InputSlot Tray2 *MediaType GlossyPlus
*UIConstraints: *InputSlot Tray2 *MediaType Glossy2
*UIConstraints: *InputSlot Tray2 *MediaType User1(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType User2(2nd)_1
*UIConstraints: *InputSlot Tray2 *MediaType User2(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType User3(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType User4(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType User5(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType User6(2nd)
*UIConstraints: *InputSlot Tray2 *MediaType User7
*UIConstraints: *InputSlot Tray2 *MediaType User7(2nd)
*UIConstraints: *InputSlot Tray2 *PageSize LetterPlus
*UIConstraints: *InputSlot Tray2 *PageSize 8x10
*UIConstraints: *InputSlot Tray2 *PageSize 8x10.5
*UIConstraints: *InputSlot Tray2 *PageSize EnvISOB5
*UIConstraints: *InputSlot Tray2 *PageSize EnvC4
*UIConstraints: *InputSlot Tray2 *PageSize EnvC5
*UIConstraints: *InputSlot Tray2 *PageSize EnvC6
*UIConstraints: *InputSlot Tray2 *PageSize EnvChou3
*UIConstraints: *InputSlot Tray2 *PageSize EnvChou4
*UIConstraints: *InputSlot Tray2 *PageSize EnvYou3
*UIConstraints: *InputSlot Tray2 *PageSize EnvYou4
*UIConstraints: *InputSlot Tray2 *PageSize EnvKaku1
*UIConstraints: *InputSlot Tray2 *PageSize EnvKaku2
*UIConstraints: *InputSlot Tray2 *PageSize EnvKaku3
*UIConstraints: *InputSlot Tray2 *PageSize EnvDL
*UIConstraints: *InputSlot Tray2 *PageSize EnvMonarch
*UIConstraints: *InputSlot Tray2 *PageSize Env10
*UIConstraints: *InputSlot Tray2 *PageSize JapanesePostCard
*UIConstraints: *InputSlot Tray2 *PageSize 4x6_PostCard
*UIConstraints: *InputSlot Tray2 *PageSize DoublePostcardRotated
*UIConstraints: *InputSlot Tray2 *PageSize LetterTab-F
*UIConstraints: *InputSlot Tray2 *PageSize A4Tab-F
*UIConstraints: *InputSlot Tray3 *MediaType Plain(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType PlainPlus(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Thick1(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Thick1Plus(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Thick2(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Thick3(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Thick4
*UIConstraints: *InputSlot Tray3 *MediaType Thick4(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Envelope
*UIConstraints: *InputSlot Tray3 *MediaType Transparency
*UIConstraints: *InputSlot Tray3 *MediaType TAB
*UIConstraints: *InputSlot Tray3 *MediaType Recycled(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType Labels
*UIConstraints: *InputSlot Tray3 *MediaType Postcard
*UIConstraints: *InputSlot Tray3 *MediaType Glossy
*UIConstraints: *InputSlot Tray3 *MediaType GlossyPlus
*UIConstraints: *InputSlot Tray3 *MediaType Glossy2
*UIConstraints: *InputSlot Tray3 *MediaType User1(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType User2(2nd)_1
*UIConstraints: *InputSlot Tray3 *MediaType User2(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType User3(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType User4(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType User5(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType User6(2nd)
*UIConstraints: *InputSlot Tray3 *MediaType User7
*UIConstraints: *InputSlot Tray3 *MediaType User7(2nd)
*UIConstraints: *InputSlot Tray3 *PageSize SRA3
*UIConstraints: *InputSlot Tray3 *PageSize 12x18
*UIConstraints: *InputSlot Tray3 *PageSize LetterPlus
*UIConstraints: *InputSlot Tray3 *PageSize 8x10
*UIConstraints: *InputSlot Tray3 *PageSize 8x10.5
*UIConstraints: *InputSlot Tray3 *PageSize EnvISOB5
*UIConstraints: *InputSlot Tray3 *PageSize EnvC4
*UIConstraints: *InputSlot Tray3 *PageSize EnvC5
*UIConstraints: *InputSlot Tray3 *PageSize EnvC6
*UIConstraints: *InputSlot Tray3 *PageSize EnvChou3
*UIConstraints: *InputSlot Tray3 *PageSize EnvChou4
*UIConstraints: *InputSlot Tray3 *PageSize EnvYou3
*UIConstraints: *InputSlot Tray3 *PageSize EnvYou4
*UIConstraints: *InputSlot Tray3 *PageSize EnvKaku1
*UIConstraints: *InputSlot Tray3 *PageSize EnvKaku2
*UIConstraints: *InputSlot Tray3 *PageSize EnvKaku3
*UIConstraints: *InputSlot Tray3 *PageSize EnvDL
*UIConstraints: *InputSlot Tray3 *PageSize EnvMonarch
*UIConstraints: *InputSlot Tray3 *PageSize Env10
*UIConstraints: *InputSlot Tray3 *PageSize JapanesePostCard
*UIConstraints: *InputSlot Tray3 *PageSize 4x6_PostCard
*UIConstraints: *InputSlot Tray3 *PageSize DoublePostcardRotated
*UIConstraints: *InputSlot Tray3 *PageSize LetterTab-F
*UIConstraints: *InputSlot Tray3 *PageSize A4Tab-F
*UIConstraints: *InputSlot Tray3 *PaperSources LU207
*UIConstraints: *InputSlot Tray3 *PaperSources LU302
*UIConstraints: *InputSlot Tray3 *PaperSources PFP13T2
*UIConstraints: *InputSlot Tray3 *Model C3300i
*UIConstraints: *InputSlot Tray3 *Model C3320i
*UIConstraints: *InputSlot Tray4 *MediaType Plain(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType PlainPlus(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Thick1(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Thick1Plus(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Thick2(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Thick3(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Thick4
*UIConstraints: *InputSlot Tray4 *MediaType Thick4(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Envelope
*UIConstraints: *InputSlot Tray4 *MediaType Transparency
*UIConstraints: *InputSlot Tray4 *MediaType TAB
*UIConstraints: *InputSlot Tray4 *MediaType Recycled(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType Labels
*UIConstraints: *InputSlot Tray4 *MediaType Postcard
*UIConstraints: *InputSlot Tray4 *MediaType Glossy
*UIConstraints: *InputSlot Tray4 *MediaType GlossyPlus
*UIConstraints: *InputSlot Tray4 *MediaType Glossy2
*UIConstraints: *InputSlot Tray4 *MediaType User1(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType User2(2nd)_1
*UIConstraints: *InputSlot Tray4 *MediaType User2(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType User3(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType User4(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType User5(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType User6(2nd)
*UIConstraints: *InputSlot Tray4 *MediaType User7
*UIConstraints: *InputSlot Tray4 *MediaType User7(2nd)
*UIConstraints: *InputSlot Tray4 *PageSize SRA3
*UIConstraints: *InputSlot Tray4 *PageSize 12x18
*UIConstraints: *InputSlot Tray4 *PageSize LetterPlus
*UIConstraints: *InputSlot Tray4 *PageSize 8x10
*UIConstraints: *InputSlot Tray4 *PageSize 8x10.5
*UIConstraints: *InputSlot Tray4 *PageSize EnvISOB5
*UIConstraints: *InputSlot Tray4 *PageSize EnvC4
*UIConstraints: *InputSlot Tray4 *PageSize EnvC5
*UIConstraints: *InputSlot Tray4 *PageSize EnvC6
*UIConstraints: *InputSlot Tray4 *PageSize EnvChou3
*UIConstraints: *InputSlot Tray4 *PageSize EnvChou4
*UIConstraints: *InputSlot Tray4 *PageSize EnvYou3
*UIConstraints: *InputSlot Tray4 *PageSize EnvYou4
*UIConstraints: *InputSlot Tray4 *PageSize EnvKaku1
*UIConstraints: *InputSlot Tray4 *PageSize EnvKaku2
*UIConstraints: *InputSlot Tray4 *PageSize EnvKaku3
*UIConstraints: *InputSlot Tray4 *PageSize EnvDL
*UIConstraints: *InputSlot Tray4 *PageSize EnvMonarch
*UIConstraints: *InputSlot Tray4 *PageSize Env10
*UIConstraints: *InputSlot Tray4 *PageSize JapanesePostCard
*UIConstraints: *InputSlot Tray4 *PageSize 4x6_PostCard
*UIConstraints: *InputSlot Tray4 *PageSize DoublePostcardRotated
*UIConstraints: *InputSlot Tray4 *PageSize LetterTab-F
*UIConstraints: *InputSlot Tray4 *PageSize A4Tab-F
*UIConstraints: *InputSlot Tray4 *PaperSources LU207
*UIConstraints: *InputSlot Tray4 *PaperSources LU302
*UIConstraints: *InputSlot Tray4 *PaperSources PC116
*UIConstraints: *InputSlot Tray4 *PaperSources PC116+LU207
*UIConstraints: *InputSlot Tray4 *PaperSources PC116+LU302
*UIConstraints: *InputSlot Tray4 *PaperSources PC118
*UIConstraints: *InputSlot Tray4 *PaperSources PC416
*UIConstraints: *InputSlot Tray4 *PaperSources PC416+LU207
*UIConstraints: *InputSlot Tray4 *PaperSources PC416+LU302
*UIConstraints: *InputSlot Tray4 *PaperSources PC418
*UIConstraints: *InputSlot Tray4 *PaperSources PFP13T2
*UIConstraints: *InputSlot Tray4 *PaperSources PFP13T23
*UIConstraints: *InputSlot Tray4 *Model C3321i
*UIConstraints: *InputSlot Tray4 *Model C4050i
*UIConstraints: *InputSlot Tray4 *Model C3350i
*UIConstraints: *InputSlot Tray4 *Model C4000i
*UIConstraints: *InputSlot Tray4 *Model C3300i
*UIConstraints: *InputSlot Tray4 *Model C3320i
*UIConstraints: *InputSlot LCT *MediaType Plain(2nd)
*UIConstraints: *InputSlot LCT *MediaType PlainPlus(2nd)
*UIConstraints: *InputSlot LCT *MediaType Thick1(2nd)
*UIConstraints: *InputSlot LCT *MediaType Thick1Plus(2nd)
*UIConstraints: *InputSlot LCT *MediaType Thick2(2nd)
*UIConstraints: *InputSlot LCT *MediaType Thick3(2nd)
*UIConstraints: *InputSlot LCT *MediaType Thick4
*UIConstraints: *InputSlot LCT *MediaType Thick4(2nd)
*UIConstraints: *InputSlot LCT *MediaType Envelope
*UIConstraints: *InputSlot LCT *MediaType Transparency
*UIConstraints: *InputSlot LCT *MediaType TAB
*UIConstraints: *InputSlot LCT *MediaType Recycled(2nd)
*UIConstraints: *InputSlot LCT *MediaType User1(2nd)
*UIConstraints: *InputSlot LCT *MediaType User2(2nd)
*UIConstraints: *InputSlot LCT *MediaType User3(2nd)
*UIConstraints: *InputSlot LCT *MediaType User4(2nd)
*UIConstraints: *InputSlot LCT *MediaType User5(2nd)
*UIConstraints: *InputSlot LCT *MediaType User6(2nd)
*UIConstraints: *InputSlot LCT *MediaType User7
*UIConstraints: *InputSlot LCT *MediaType User7(2nd)
*UIConstraints: *InputSlot LCT *PageSize A6
*UIConstraints: *InputSlot LCT *PageSize B5
*UIConstraints: *InputSlot LCT *PageSize B6
*UIConstraints: *InputSlot LCT *PageSize 220mmx330mm
*UIConstraints: *InputSlot LCT *PageSize 8x13
*UIConstraints: *InputSlot LCT *PageSize 8.5x13
*UIConstraints: *InputSlot LCT *PageSize 8.5x13.5
*UIConstraints: *InputSlot LCT *PageSize 8.25x13
*UIConstraints: *InputSlot LCT *PageSize 8.125x13.25
*UIConstraints: *InputSlot LCT *PageSize Executive
*UIConstraints: *InputSlot LCT *PageSize 8K
*UIConstraints: *InputSlot LCT *PageSize 16K
*UIConstraints: *InputSlot LCT *PageSize EnvISOB5
*UIConstraints: *InputSlot LCT *PageSize EnvC4
*UIConstraints: *InputSlot LCT *PageSize EnvC5
*UIConstraints: *InputSlot LCT *PageSize EnvC6
*UIConstraints: *InputSlot LCT *PageSize EnvChou3
*UIConstraints: *InputSlot LCT *PageSize EnvChou4
*UIConstraints: *InputSlot LCT *PageSize EnvYou3
*UIConstraints: *InputSlot LCT *PageSize EnvYou4
*UIConstraints: *InputSlot LCT *PageSize EnvKaku1
*UIConstraints: *InputSlot LCT *PageSize EnvKaku2
*UIConstraints: *InputSlot LCT *PageSize EnvKaku3
*UIConstraints: *InputSlot LCT *PageSize EnvDL
*UIConstraints: *InputSlot LCT *PageSize EnvMonarch
*UIConstraints: *InputSlot LCT *PageSize Env10
*UIConstraints: *InputSlot LCT *PageSize JapanesePostCard
*UIConstraints: *InputSlot LCT *PageSize 4x6_PostCard
*UIConstraints: *InputSlot LCT *PageSize A3Extra
*UIConstraints: *InputSlot LCT *PageSize A4Extra
*UIConstraints: *InputSlot LCT *PageSize A5Extra
*UIConstraints: *InputSlot LCT *PageSize B4Extra
*UIConstraints: *InputSlot LCT *PageSize B5Extra
*UIConstraints: *InputSlot LCT *PageSize TabloidExtra
*UIConstraints: *InputSlot LCT *PageSize LetterExtra
*UIConstraints: *InputSlot LCT *PageSize StatementExtra
*UIConstraints: *InputSlot LCT *PageSize LetterTab-F
*UIConstraints: *InputSlot LCT *PageSize A4Tab-F
*UIConstraints: *InputSlot LCT *PaperSources None
*UIConstraints: *InputSlot LCT *PaperSources PC116
*UIConstraints: *InputSlot LCT *PaperSources PC216
*UIConstraints: *InputSlot LCT *PaperSources PC416
*UIConstraints: *InputSlot LCT *PaperSources PC417
*UIConstraints: *InputSlot LCT *Model C4051i
*UIConstraints: *InputSlot LCT *Model C3351i
*UIConstraints: *InputSlot LCT *Model C4001i
*UIConstraints: *InputSlot LCT *Model C3301i
*UIConstraints: *InputSlot LCT *Model C3321i
*UIConstraints: *InputSlot LCT *Model C287i
*UIConstraints: *InputSlot LCT *Model C257i
*UIConstraints: *InputSlot LCT *Model C227i
*UIConstraints: *InputSlot LCT *Model C286i
*UIConstraints: *InputSlot LCT *Model C266i
*UIConstraints: *InputSlot LCT *Model C226i
*UIConstraints: *InputSlot LCT *Model C4050i
*UIConstraints: *InputSlot LCT *Model C3350i
*UIConstraints: *InputSlot LCT *Model C4000i
*UIConstraints: *InputSlot LCT *Model C3300i
*UIConstraints: *InputSlot LCT *Model C3320i
*UIConstraints: *InputSlot ManualFeed *MediaType Thin
*UIConstraints: *MediaType Plain *PageSize LetterTab-F
*UIConstraints: *MediaType Plain *PageSize A4Tab-F
*UIConstraints: *MediaType Plain *TransparencyInterleave Blank
*UIConstraints: *MediaType Plain(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Plain(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Plain(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Plain(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Plain(2nd) *InputSlot LCT
*UIConstraints: *MediaType Plain(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Plain(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Plain(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Plain(2nd) *Combination Booklet
*UIConstraints: *MediaType Plain(2nd) *Fold Stitch
*UIConstraints: *MediaType Plain(2nd) *Fold HalfFold
*UIConstraints: *MediaType Plain(2nd) *Fold ZFold1
*UIConstraints: *MediaType Plain(2nd) *Fold ZFold2
*UIConstraints: *MediaType Plain(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType PlainPlus *PageSize LetterTab-F
*UIConstraints: *MediaType PlainPlus *PageSize A4Tab-F
*UIConstraints: *MediaType PlainPlus *Fold ZFold1
*UIConstraints: *MediaType PlainPlus *Fold ZFold2
*UIConstraints: *MediaType PlainPlus *TransparencyInterleave Blank
*UIConstraints: *MediaType PlainPlus *Model C287i
*UIConstraints: *MediaType PlainPlus *Model C257i
*UIConstraints: *MediaType PlainPlus *Model C227i
*UIConstraints: *MediaType PlainPlus *Model C286i
*UIConstraints: *MediaType PlainPlus *Model C266i
*UIConstraints: *MediaType PlainPlus *Model C226i
*UIConstraints: *MediaType PlainPlus(2nd) *InputSlot Tray1
*UIConstraints: *MediaType PlainPlus(2nd) *InputSlot Tray2
*UIConstraints: *MediaType PlainPlus(2nd) *InputSlot Tray3
*UIConstraints: *MediaType PlainPlus(2nd) *InputSlot Tray4
*UIConstraints: *MediaType PlainPlus(2nd) *InputSlot LCT
*UIConstraints: *MediaType PlainPlus(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType PlainPlus(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType PlainPlus(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType PlainPlus(2nd) *Combination Booklet
*UIConstraints: *MediaType PlainPlus(2nd) *Fold Stitch
*UIConstraints: *MediaType PlainPlus(2nd) *Fold HalfFold
*UIConstraints: *MediaType PlainPlus(2nd) *Fold TriFold
*UIConstraints: *MediaType PlainPlus(2nd) *Fold ZFold1
*UIConstraints: *MediaType PlainPlus(2nd) *Fold ZFold2
*UIConstraints: *MediaType PlainPlus(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType PlainPlus(2nd) *Model C287i
*UIConstraints: *MediaType PlainPlus(2nd) *Model C257i
*UIConstraints: *MediaType PlainPlus(2nd) *Model C227i
*UIConstraints: *MediaType PlainPlus(2nd) *Model C286i
*UIConstraints: *MediaType PlainPlus(2nd) *Model C266i
*UIConstraints: *MediaType PlainPlus(2nd) *Model C226i
*UIConstraints: *MediaType Thick1 *PageSize LetterTab-F
*UIConstraints: *MediaType Thick1 *PageSize A4Tab-F
*UIConstraints: *MediaType Thick1 *Fold ZFold1
*UIConstraints: *MediaType Thick1 *Fold ZFold2
*UIConstraints: *MediaType Thick1 *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick1 *GlossyMode True
*UIConstraints: *MediaType Thick1(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Thick1(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Thick1(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Thick1(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Thick1(2nd) *InputSlot LCT
*UIConstraints: *MediaType Thick1(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Thick1(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Thick1(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Thick1(2nd) *Combination Booklet
*UIConstraints: *MediaType Thick1(2nd) *Fold Stitch
*UIConstraints: *MediaType Thick1(2nd) *Fold HalfFold
*UIConstraints: *MediaType Thick1(2nd) *Fold TriFold
*UIConstraints: *MediaType Thick1(2nd) *Fold ZFold1
*UIConstraints: *MediaType Thick1(2nd) *Fold ZFold2
*UIConstraints: *MediaType Thick1(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick1(2nd) *GlossyMode True
*UIConstraints: *MediaType Thick1Plus *PageSize LetterTab-F
*UIConstraints: *MediaType Thick1Plus *PageSize A4Tab-F
*UIConstraints: *MediaType Thick1Plus *Fold TriFold
*UIConstraints: *MediaType Thick1Plus *Fold ZFold1
*UIConstraints: *MediaType Thick1Plus *Fold ZFold2
*UIConstraints: *MediaType Thick1Plus *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick1Plus *GlossyMode True
*UIConstraints: *MediaType Thick1Plus(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Thick1Plus(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Thick1Plus(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Thick1Plus(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Thick1Plus(2nd) *InputSlot LCT
*UIConstraints: *MediaType Thick1Plus(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Thick1Plus(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Thick1Plus(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Thick1Plus(2nd) *Combination Booklet
*UIConstraints: *MediaType Thick1Plus(2nd) *Fold Stitch
*UIConstraints: *MediaType Thick1Plus(2nd) *Fold HalfFold
*UIConstraints: *MediaType Thick1Plus(2nd) *Fold TriFold
*UIConstraints: *MediaType Thick1Plus(2nd) *Fold ZFold1
*UIConstraints: *MediaType Thick1Plus(2nd) *Fold ZFold2
*UIConstraints: *MediaType Thick1Plus(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick1Plus(2nd) *GlossyMode True
*UIConstraints: *MediaType Thick2 *PageSize LetterTab-F
*UIConstraints: *MediaType Thick2 *PageSize A4Tab-F
*UIConstraints: *MediaType Thick2 *Fold TriFold
*UIConstraints: *MediaType Thick2 *Fold ZFold1
*UIConstraints: *MediaType Thick2 *Fold ZFold2
*UIConstraints: *MediaType Thick2 *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick2 *GlossyMode True
*UIConstraints: *MediaType Thick2(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Thick2(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Thick2(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Thick2(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Thick2(2nd) *InputSlot LCT
*UIConstraints: *MediaType Thick2(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Thick2(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Thick2(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Thick2(2nd) *Combination Booklet
*UIConstraints: *MediaType Thick2(2nd) *Fold Stitch
*UIConstraints: *MediaType Thick2(2nd) *Fold HalfFold
*UIConstraints: *MediaType Thick2(2nd) *Fold TriFold
*UIConstraints: *MediaType Thick2(2nd) *Fold ZFold1
*UIConstraints: *MediaType Thick2(2nd) *Fold ZFold2
*UIConstraints: *MediaType Thick2(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick2(2nd) *GlossyMode True
*UIConstraints: *MediaType Thick3 *PageSize LetterTab-F
*UIConstraints: *MediaType Thick3 *PageSize A4Tab-F
*UIConstraints: *MediaType Thick3 *Fold Stitch
*UIConstraints: *MediaType Thick3 *Fold HalfFold
*UIConstraints: *MediaType Thick3 *Fold TriFold
*UIConstraints: *MediaType Thick3 *Fold ZFold1
*UIConstraints: *MediaType Thick3 *Fold ZFold2
*UIConstraints: *MediaType Thick3 *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick3 *GlossyMode True
*UIConstraints: *MediaType Thick3 *Model C4051i
*UIConstraints: *MediaType Thick3 *Model C3351i
*UIConstraints: *MediaType Thick3 *Model C4001i
*UIConstraints: *MediaType Thick3 *Model C3301i
*UIConstraints: *MediaType Thick3 *Model C3321i
*UIConstraints: *MediaType Thick3 *Model C4050i
*UIConstraints: *MediaType Thick3 *Model C3350i
*UIConstraints: *MediaType Thick3 *Model C4000i
*UIConstraints: *MediaType Thick3 *Model C3300i
*UIConstraints: *MediaType Thick3 *Model C3320i
*UIConstraints: *MediaType Thick3(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Thick3(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Thick3(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Thick3(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Thick3(2nd) *InputSlot LCT
*UIConstraints: *MediaType Thick3(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Thick3(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Thick3(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Thick3(2nd) *Combination Booklet
*UIConstraints: *MediaType Thick3(2nd) *Fold Stitch
*UIConstraints: *MediaType Thick3(2nd) *Fold HalfFold
*UIConstraints: *MediaType Thick3(2nd) *Fold TriFold
*UIConstraints: *MediaType Thick3(2nd) *Fold ZFold1
*UIConstraints: *MediaType Thick3(2nd) *Fold ZFold2
*UIConstraints: *MediaType Thick3(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick3(2nd) *GlossyMode True
*UIConstraints: *MediaType Thick3(2nd) *Model C4051i
*UIConstraints: *MediaType Thick3(2nd) *Model C3351i
*UIConstraints: *MediaType Thick3(2nd) *Model C4001i
*UIConstraints: *MediaType Thick3(2nd) *Model C3301i
*UIConstraints: *MediaType Thick3(2nd) *Model C3321i
*UIConstraints: *MediaType Thick3(2nd) *Model C4050i
*UIConstraints: *MediaType Thick3(2nd) *Model C3350i
*UIConstraints: *MediaType Thick3(2nd) *Model C4000i
*UIConstraints: *MediaType Thick3(2nd) *Model C3300i
*UIConstraints: *MediaType Thick3(2nd) *Model C3320i
*UIConstraints: *MediaType Thick4 *InputSlot Tray1
*UIConstraints: *MediaType Thick4 *InputSlot Tray2
*UIConstraints: *MediaType Thick4 *InputSlot Tray3
*UIConstraints: *MediaType Thick4 *InputSlot Tray4
*UIConstraints: *MediaType Thick4 *InputSlot LCT
*UIConstraints: *MediaType Thick4 *PageSize LetterTab-F
*UIConstraints: *MediaType Thick4 *PageSize A4Tab-F
*UIConstraints: *MediaType Thick4 *KMDuplex 2Sided
*UIConstraints: *MediaType Thick4 *Combination Booklet
*UIConstraints: *MediaType Thick4 *Fold Stitch
*UIConstraints: *MediaType Thick4 *Fold HalfFold
*UIConstraints: *MediaType Thick4 *Fold TriFold
*UIConstraints: *MediaType Thick4 *Fold ZFold1
*UIConstraints: *MediaType Thick4 *Fold ZFold2
*UIConstraints: *MediaType Thick4 *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick4 *GlossyMode True
*UIConstraints: *MediaType Thick4 *Model C4051i
*UIConstraints: *MediaType Thick4 *Model C3351i
*UIConstraints: *MediaType Thick4 *Model C4001i
*UIConstraints: *MediaType Thick4 *Model C3301i
*UIConstraints: *MediaType Thick4 *Model C3321i
*UIConstraints: *MediaType Thick4 *Model C287i
*UIConstraints: *MediaType Thick4 *Model C257i
*UIConstraints: *MediaType Thick4 *Model C227i
*UIConstraints: *MediaType Thick4 *Model C286i
*UIConstraints: *MediaType Thick4 *Model C266i
*UIConstraints: *MediaType Thick4 *Model C226i
*UIConstraints: *MediaType Thick4 *Model C4050i
*UIConstraints: *MediaType Thick4 *Model C3350i
*UIConstraints: *MediaType Thick4 *Model C4000i
*UIConstraints: *MediaType Thick4 *Model C3300i
*UIConstraints: *MediaType Thick4 *Model C3320i
*UIConstraints: *MediaType Thick4(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Thick4(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Thick4(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Thick4(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Thick4(2nd) *InputSlot LCT
*UIConstraints: *MediaType Thick4(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Thick4(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Thick4(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Thick4(2nd) *Combination Booklet
*UIConstraints: *MediaType Thick4(2nd) *Fold Stitch
*UIConstraints: *MediaType Thick4(2nd) *Fold HalfFold
*UIConstraints: *MediaType Thick4(2nd) *Fold TriFold
*UIConstraints: *MediaType Thick4(2nd) *Fold ZFold1
*UIConstraints: *MediaType Thick4(2nd) *Fold ZFold2
*UIConstraints: *MediaType Thick4(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType Thick4(2nd) *GlossyMode True
*UIConstraints: *MediaType Thick4(2nd) *Model C4051i
*UIConstraints: *MediaType Thick4(2nd) *Model C3351i
*UIConstraints: *MediaType Thick4(2nd) *Model C4001i
*UIConstraints: *MediaType Thick4(2nd) *Model C3301i
*UIConstraints: *MediaType Thick4(2nd) *Model C3321i
*UIConstraints: *MediaType Thick4(2nd) *Model C287i
*UIConstraints: *MediaType Thick4(2nd) *Model C257i
*UIConstraints: *MediaType Thick4(2nd) *Model C227i
*UIConstraints: *MediaType Thick4(2nd) *Model C286i
*UIConstraints: *MediaType Thick4(2nd) *Model C266i
*UIConstraints: *MediaType Thick4(2nd) *Model C226i
*UIConstraints: *MediaType Thick4(2nd) *Model C4050i
*UIConstraints: *MediaType Thick4(2nd) *Model C3350i
*UIConstraints: *MediaType Thick4(2nd) *Model C4000i
*UIConstraints: *MediaType Thick4(2nd) *Model C3300i
*UIConstraints: *MediaType Thick4(2nd) *Model C3320i
*UIConstraints: *MediaType Thin *InputSlot ManualFeed
*UIConstraints: *MediaType Thin *PageSize EnvISOB5
*UIConstraints: *MediaType Thin *PageSize EnvC4
*UIConstraints: *MediaType Thin *PageSize EnvC5
*UIConstraints: *MediaType Thin *PageSize EnvC6
*UIConstraints: *MediaType Thin *PageSize EnvChou3
*UIConstraints: *MediaType Thin *PageSize EnvChou4
*UIConstraints: *MediaType Thin *PageSize EnvYou3
*UIConstraints: *MediaType Thin *PageSize EnvYou4
*UIConstraints: *MediaType Thin *PageSize EnvKaku1
*UIConstraints: *MediaType Thin *PageSize EnvKaku2
*UIConstraints: *MediaType Thin *PageSize EnvKaku3
*UIConstraints: *MediaType Thin *PageSize EnvDL
*UIConstraints: *MediaType Thin *PageSize EnvMonarch
*UIConstraints: *MediaType Thin *PageSize Env10
*UIConstraints: *MediaType Thin *PageSize JapanesePostCard
*UIConstraints: *MediaType Thin *PageSize 4x6_PostCard
*UIConstraints: *MediaType Thin *PageSize LetterTab-F
*UIConstraints: *MediaType Thin *PageSize A4Tab-F
*UIConstraints: *MediaType Thin *TransparencyInterleave Blank
*UIConstraints: *MediaType Thin *GlossyMode True
*UIConstraints: *MediaType Thin *Model C4051i
*UIConstraints: *MediaType Thin *Model C3351i
*UIConstraints: *MediaType Thin *Model C4001i
*UIConstraints: *MediaType Thin *Model C3301i
*UIConstraints: *MediaType Thin *Model C3321i
*UIConstraints: *MediaType Thin *Model C287i
*UIConstraints: *MediaType Thin *Model C257i
*UIConstraints: *MediaType Thin *Model C227i
*UIConstraints: *MediaType Thin *Model C286i
*UIConstraints: *MediaType Thin *Model C266i
*UIConstraints: *MediaType Thin *Model C226i
*UIConstraints: *MediaType Thin *Model C4050i
*UIConstraints: *MediaType Thin *Model C3350i
*UIConstraints: *MediaType Thin *Model C4000i
*UIConstraints: *MediaType Thin *Model C3300i
*UIConstraints: *MediaType Thin *Model C3320i
*UIConstraints: *MediaType Envelope *Offset True
*UIConstraints: *MediaType Envelope *InputSlot Tray2
*UIConstraints: *MediaType Envelope *InputSlot Tray3
*UIConstraints: *MediaType Envelope *InputSlot Tray4
*UIConstraints: *MediaType Envelope *InputSlot LCT
*UIConstraints: *MediaType Envelope *PageSize JapanesePostCard
*UIConstraints: *MediaType Envelope *PageSize 4x6_PostCard
*UIConstraints: *MediaType Envelope *PageSize DoublePostcardRotated
*UIConstraints: *MediaType Envelope *PageSize A3Extra
*UIConstraints: *MediaType Envelope *PageSize A4Extra
*UIConstraints: *MediaType Envelope *PageSize A5Extra
*UIConstraints: *MediaType Envelope *PageSize B4Extra
*UIConstraints: *MediaType Envelope *PageSize B5Extra
*UIConstraints: *MediaType Envelope *PageSize TabloidExtra
*UIConstraints: *MediaType Envelope *PageSize LetterExtra
*UIConstraints: *MediaType Envelope *PageSize StatementExtra
*UIConstraints: *MediaType Envelope *PageSize LetterTab-F
*UIConstraints: *MediaType Envelope *PageSize A4Tab-F
*UIConstraints: *MediaType Envelope *KMDuplex 2Sided
*UIConstraints: *MediaType Envelope *Combination Booklet
*UIConstraints: *MediaType Envelope *Staple 1StapleAuto(Left)
*UIConstraints: *MediaType Envelope *Staple 1StapleZeroLeft
*UIConstraints: *MediaType Envelope *Staple 1StapleAuto(Right)
*UIConstraints: *MediaType Envelope *Staple 1StapleZeroRight
*UIConstraints: *MediaType Envelope *Staple 2Staples
*UIConstraints: *MediaType Envelope *Punch 2holes
*UIConstraints: *MediaType Envelope *Punch 3holes
*UIConstraints: *MediaType Envelope *Punch 4holes
*UIConstraints: *MediaType Envelope *Fold Stitch
*UIConstraints: *MediaType Envelope *Fold HalfFold
*UIConstraints: *MediaType Envelope *Fold TriFold
*UIConstraints: *MediaType Envelope *Fold ZFold1
*UIConstraints: *MediaType Envelope *Fold ZFold2
*UIConstraints: *MediaType Envelope *TransparencyInterleave Blank
*UIConstraints: *MediaType Envelope *GlossyMode True
*UIConstraints: *MediaType Transparency *Offset True
*UIConstraints: *MediaType Transparency *InputSlot Tray1
*UIConstraints: *MediaType Transparency *InputSlot Tray2
*UIConstraints: *MediaType Transparency *InputSlot Tray3
*UIConstraints: *MediaType Transparency *InputSlot Tray4
*UIConstraints: *MediaType Transparency *InputSlot LCT
*UIConstraints: *MediaType Transparency *PageSize EnvISOB5
*UIConstraints: *MediaType Transparency *PageSize EnvC4
*UIConstraints: *MediaType Transparency *PageSize EnvC5
*UIConstraints: *MediaType Transparency *PageSize EnvC6
*UIConstraints: *MediaType Transparency *PageSize EnvChou3
*UIConstraints: *MediaType Transparency *PageSize EnvChou4
*UIConstraints: *MediaType Transparency *PageSize EnvYou3
*UIConstraints: *MediaType Transparency *PageSize EnvYou4
*UIConstraints: *MediaType Transparency *PageSize EnvKaku1
*UIConstraints: *MediaType Transparency *PageSize EnvKaku2
*UIConstraints: *MediaType Transparency *PageSize EnvKaku3
*UIConstraints: *MediaType Transparency *PageSize EnvDL
*UIConstraints: *MediaType Transparency *PageSize EnvMonarch
*UIConstraints: *MediaType Transparency *PageSize Env10
*UIConstraints: *MediaType Transparency *PageSize JapanesePostCard
*UIConstraints: *MediaType Transparency *PageSize 4x6_PostCard
*UIConstraints: *MediaType Transparency *PageSize LetterTab-F
*UIConstraints: *MediaType Transparency *PageSize A4Tab-F
*UIConstraints: *MediaType Transparency *KMDuplex 2Sided
*UIConstraints: *MediaType Transparency *Combination Booklet
*UIConstraints: *MediaType Transparency *Staple 1StapleAuto(Left)
*UIConstraints: *MediaType Transparency *Staple 1StapleZeroLeft
*UIConstraints: *MediaType Transparency *Staple 1StapleAuto(Right)
*UIConstraints: *MediaType Transparency *Staple 1StapleZeroRight
*UIConstraints: *MediaType Transparency *Staple 2Staples
*UIConstraints: *MediaType Transparency *Punch 2holes
*UIConstraints: *MediaType Transparency *Punch 3holes
*UIConstraints: *MediaType Transparency *Punch 4holes
*UIConstraints: *MediaType Transparency *Fold Stitch
*UIConstraints: *MediaType Transparency *Fold HalfFold
*UIConstraints: *MediaType Transparency *Fold TriFold
*UIConstraints: *MediaType Transparency *Fold ZFold1
*UIConstraints: *MediaType Transparency *Fold ZFold2
*UIConstraints: *MediaType Transparency *SelectColor Auto
*UIConstraints: *MediaType Transparency *SelectColor Color
*UIConstraints: *MediaType Transparency *GlossyMode True
*UIConstraints: *MediaType Transparency *Model C4051i
*UIConstraints: *MediaType Transparency *Model C3351i
*UIConstraints: *MediaType Transparency *Model C4001i
*UIConstraints: *MediaType Transparency *Model C3301i
*UIConstraints: *MediaType Transparency *Model C3321i
*UIConstraints: *MediaType Transparency *Model C4050i
*UIConstraints: *MediaType Transparency *Model C3350i
*UIConstraints: *MediaType Transparency *Model C4000i
*UIConstraints: *MediaType Transparency *Model C3300i
*UIConstraints: *MediaType Transparency *Model C3320i
*UIConstraints: *MediaType Color *PageSize LetterTab-F
*UIConstraints: *MediaType Color *PageSize A4Tab-F
*UIConstraints: *MediaType Color *TransparencyInterleave Blank
*UIConstraints: *MediaType SingleSidedOnly *PageSize LetterTab-F
*UIConstraints: *MediaType SingleSidedOnly *PageSize A4Tab-F
*UIConstraints: *MediaType SingleSidedOnly *KMDuplex 2Sided
*UIConstraints: *MediaType SingleSidedOnly *Combination Booklet
*UIConstraints: *MediaType SingleSidedOnly *TransparencyInterleave Blank
*UIConstraints: *MediaType TAB *Offset True
*UIConstraints: *MediaType TAB *InputSlot Tray1
*UIConstraints: *MediaType TAB *InputSlot Tray2
*UIConstraints: *MediaType TAB *InputSlot Tray3
*UIConstraints: *MediaType TAB *InputSlot Tray4
*UIConstraints: *MediaType TAB *InputSlot LCT
*UIConstraints: *MediaType TAB *PageSize A3
*UIConstraints: *MediaType TAB *PageSize A4
*UIConstraints: *MediaType TAB *PageSize A5
*UIConstraints: *MediaType TAB *PageSize A6
*UIConstraints: *MediaType TAB *PageSize B4
*UIConstraints: *MediaType TAB *PageSize B5
*UIConstraints: *MediaType TAB *PageSize B6
*UIConstraints: *MediaType TAB *PageSize SRA3
*UIConstraints: *MediaType TAB *PageSize 220mmx330mm
*UIConstraints: *MediaType TAB *PageSize 12x18
*UIConstraints: *MediaType TAB *PageSize Tabloid
*UIConstraints: *MediaType TAB *PageSize Legal
*UIConstraints: *MediaType TAB *PageSize Letter
*UIConstraints: *MediaType TAB *PageSize Statement
*UIConstraints: *MediaType TAB *PageSize 8x13
*UIConstraints: *MediaType TAB *PageSize 8.5x13
*UIConstraints: *MediaType TAB *PageSize 8.5x13.5
*UIConstraints: *MediaType TAB *PageSize 8.25x13
*UIConstraints: *MediaType TAB *PageSize 8.125x13.25
*UIConstraints: *MediaType TAB *PageSize Executive
*UIConstraints: *MediaType TAB *PageSize 8K
*UIConstraints: *MediaType TAB *PageSize 16K
*UIConstraints: *MediaType TAB *PageSize EnvISOB5
*UIConstraints: *MediaType TAB *PageSize EnvC4
*UIConstraints: *MediaType TAB *PageSize EnvC5
*UIConstraints: *MediaType TAB *PageSize EnvC6
*UIConstraints: *MediaType TAB *PageSize EnvChou3
*UIConstraints: *MediaType TAB *PageSize EnvChou4
*UIConstraints: *MediaType TAB *PageSize EnvYou3
*UIConstraints: *MediaType TAB *PageSize EnvYou4
*UIConstraints: *MediaType TAB *PageSize EnvKaku1
*UIConstraints: *MediaType TAB *PageSize EnvKaku2
*UIConstraints: *MediaType TAB *PageSize EnvKaku3
*UIConstraints: *MediaType TAB *PageSize EnvDL
*UIConstraints: *MediaType TAB *PageSize EnvMonarch
*UIConstraints: *MediaType TAB *PageSize Env10
*UIConstraints: *MediaType TAB *PageSize JapanesePostCard
*UIConstraints: *MediaType TAB *PageSize 4x6_PostCard
*UIConstraints: *MediaType TAB *PageSize A3Extra
*UIConstraints: *MediaType TAB *PageSize A4Extra
*UIConstraints: *MediaType TAB *PageSize A5Extra
*UIConstraints: *MediaType TAB *PageSize B4Extra
*UIConstraints: *MediaType TAB *PageSize B5Extra
*UIConstraints: *MediaType TAB *PageSize TabloidExtra
*UIConstraints: *MediaType TAB *PageSize LetterExtra
*UIConstraints: *MediaType TAB *PageSize StatementExtra
*UIConstraints: *MediaType TAB *Binding TopBinding
*UIConstraints: *MediaType TAB *Binding RightBinding
*UIConstraints: *MediaType TAB *KMDuplex 2Sided
*UIConstraints: *MediaType TAB *Combination Booklet
*UIConstraints: *MediaType TAB *Staple 1StapleAuto(Left)
*UIConstraints: *MediaType TAB *Staple 1StapleZeroLeft
*UIConstraints: *MediaType TAB *Staple 1StapleAuto(Right)
*UIConstraints: *MediaType TAB *Staple 1StapleZeroRight
*UIConstraints: *MediaType TAB *Staple 2Staples
*UIConstraints: *MediaType TAB *Punch 2holes
*UIConstraints: *MediaType TAB *Punch 3holes
*UIConstraints: *MediaType TAB *Punch 4holes
*UIConstraints: *MediaType TAB *Fold Stitch
*UIConstraints: *MediaType TAB *Fold HalfFold
*UIConstraints: *MediaType TAB *Fold TriFold
*UIConstraints: *MediaType TAB *TransparencyInterleave Blank
*UIConstraints: *MediaType TAB *GlossyMode True
*UIConstraints: *MediaType TAB *Model C4051i
*UIConstraints: *MediaType TAB *Model C3351i
*UIConstraints: *MediaType TAB *Model C4001i
*UIConstraints: *MediaType TAB *Model C3301i
*UIConstraints: *MediaType TAB *Model C3321i
*UIConstraints: *MediaType TAB *Model C4050i
*UIConstraints: *MediaType TAB *Model C3350i
*UIConstraints: *MediaType TAB *Model C4000i
*UIConstraints: *MediaType TAB *Model C3300i
*UIConstraints: *MediaType TAB *Model C3320i
*UIConstraints: *MediaType Letterhead *PageSize EnvChou4
*UIConstraints: *MediaType Letterhead *PageSize EnvYou3
*UIConstraints: *MediaType Letterhead *PageSize EnvMonarch
*UIConstraints: *MediaType Letterhead *PageSize LetterTab-F
*UIConstraints: *MediaType Letterhead *PageSize A4Tab-F
*UIConstraints: *MediaType Letterhead *TransparencyInterleave Blank
*UIConstraints: *MediaType Special *PageSize LetterTab-F
*UIConstraints: *MediaType Special *PageSize A4Tab-F
*UIConstraints: *MediaType Special *TransparencyInterleave Blank
*UIConstraints: *MediaType Recycled *PageSize LetterTab-F
*UIConstraints: *MediaType Recycled *PageSize A4Tab-F
*UIConstraints: *MediaType Recycled *TransparencyInterleave Blank
*UIConstraints: *MediaType Recycled *GlossyMode True
*UIConstraints: *MediaType Recycled(2nd) *InputSlot Tray1
*UIConstraints: *MediaType Recycled(2nd) *InputSlot Tray2
*UIConstraints: *MediaType Recycled(2nd) *InputSlot Tray3
*UIConstraints: *MediaType Recycled(2nd) *InputSlot Tray4
*UIConstraints: *MediaType Recycled(2nd) *InputSlot LCT
*UIConstraints: *MediaType Recycled(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType Recycled(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType Recycled(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType Recycled(2nd) *Combination Booklet
*UIConstraints: *MediaType Recycled(2nd) *Fold Stitch
*UIConstraints: *MediaType Recycled(2nd) *Fold HalfFold
*UIConstraints: *MediaType Recycled(2nd) *Fold TriFold
*UIConstraints: *MediaType Recycled(2nd) *Fold ZFold1
*UIConstraints: *MediaType Recycled(2nd) *Fold ZFold2
*UIConstraints: *MediaType Recycled(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType Recycled(2nd) *GlossyMode True
*UIConstraints: *MediaType Labels *InputSlot Tray2
*UIConstraints: *MediaType Labels *InputSlot Tray3
*UIConstraints: *MediaType Labels *InputSlot Tray4
*UIConstraints: *MediaType Labels *KMDuplex 2Sided
*UIConstraints: *MediaType Labels *Combination Booklet
*UIConstraints: *MediaType Labels *Model C751i
*UIConstraints: *MediaType Labels *Model C651i
*UIConstraints: *MediaType Labels *Model C551i
*UIConstraints: *MediaType Labels *Model C451i
*UIConstraints: *MediaType Labels *Model C361i
*UIConstraints: *MediaType Labels *Model C301i
*UIConstraints: *MediaType Labels *Model C251i
*UIConstraints: *MediaType Labels *Model C750i
*UIConstraints: *MediaType Labels *Model C650i
*UIConstraints: *MediaType Labels *Model C550i
*UIConstraints: *MediaType Labels *Model C450i
*UIConstraints: *MediaType Labels *Model C360i
*UIConstraints: *MediaType Labels *Model C300i
*UIConstraints: *MediaType Labels *Model C250i
*UIConstraints: *MediaType Labels *Model C287i
*UIConstraints: *MediaType Labels *Model C257i
*UIConstraints: *MediaType Labels *Model C227i
*UIConstraints: *MediaType Labels *Model C286i
*UIConstraints: *MediaType Labels *Model C266i
*UIConstraints: *MediaType Labels *Model C226i
*UIConstraints: *MediaType Postcard *InputSlot Tray2
*UIConstraints: *MediaType Postcard *InputSlot Tray3
*UIConstraints: *MediaType Postcard *InputSlot Tray4
*UIConstraints: *MediaType Postcard *KMDuplex 2Sided
*UIConstraints: *MediaType Postcard *Combination Booklet
*UIConstraints: *MediaType Postcard *Model C751i
*UIConstraints: *MediaType Postcard *Model C651i
*UIConstraints: *MediaType Postcard *Model C551i
*UIConstraints: *MediaType Postcard *Model C451i
*UIConstraints: *MediaType Postcard *Model C361i
*UIConstraints: *MediaType Postcard *Model C301i
*UIConstraints: *MediaType Postcard *Model C251i
*UIConstraints: *MediaType Postcard *Model C750i
*UIConstraints: *MediaType Postcard *Model C650i
*UIConstraints: *MediaType Postcard *Model C550i
*UIConstraints: *MediaType Postcard *Model C450i
*UIConstraints: *MediaType Postcard *Model C360i
*UIConstraints: *MediaType Postcard *Model C300i
*UIConstraints: *MediaType Postcard *Model C250i
*UIConstraints: *MediaType Postcard *Model C287i
*UIConstraints: *MediaType Postcard *Model C257i
*UIConstraints: *MediaType Postcard *Model C227i
*UIConstraints: *MediaType Postcard *Model C286i
*UIConstraints: *MediaType Postcard *Model C266i
*UIConstraints: *MediaType Postcard *Model C226i
*UIConstraints: *MediaType Glossy *InputSlot Tray2
*UIConstraints: *MediaType Glossy *InputSlot Tray3
*UIConstraints: *MediaType Glossy *InputSlot Tray4
*UIConstraints: *MediaType Glossy *KMDuplex 2Sided
*UIConstraints: *MediaType Glossy *Combination Booklet
*UIConstraints: *MediaType Glossy *Model C751i
*UIConstraints: *MediaType Glossy *Model C651i
*UIConstraints: *MediaType Glossy *Model C551i
*UIConstraints: *MediaType Glossy *Model C451i
*UIConstraints: *MediaType Glossy *Model C361i
*UIConstraints: *MediaType Glossy *Model C301i
*UIConstraints: *MediaType Glossy *Model C251i
*UIConstraints: *MediaType Glossy *Model C750i
*UIConstraints: *MediaType Glossy *Model C650i
*UIConstraints: *MediaType Glossy *Model C550i
*UIConstraints: *MediaType Glossy *Model C450i
*UIConstraints: *MediaType Glossy *Model C360i
*UIConstraints: *MediaType Glossy *Model C300i
*UIConstraints: *MediaType Glossy *Model C250i
*UIConstraints: *MediaType Glossy *Model C287i
*UIConstraints: *MediaType Glossy *Model C257i
*UIConstraints: *MediaType Glossy *Model C227i
*UIConstraints: *MediaType Glossy *Model C286i
*UIConstraints: *MediaType Glossy *Model C266i
*UIConstraints: *MediaType Glossy *Model C226i
*UIConstraints: *MediaType GlossyPlus *InputSlot Tray2
*UIConstraints: *MediaType GlossyPlus *InputSlot Tray3
*UIConstraints: *MediaType GlossyPlus *InputSlot Tray4
*UIConstraints: *MediaType GlossyPlus *KMDuplex 2Sided
*UIConstraints: *MediaType GlossyPlus *Combination Booklet
*UIConstraints: *MediaType GlossyPlus *Model C751i
*UIConstraints: *MediaType GlossyPlus *Model C651i
*UIConstraints: *MediaType GlossyPlus *Model C551i
*UIConstraints: *MediaType GlossyPlus *Model C451i
*UIConstraints: *MediaType GlossyPlus *Model C361i
*UIConstraints: *MediaType GlossyPlus *Model C301i
*UIConstraints: *MediaType GlossyPlus *Model C251i
*UIConstraints: *MediaType GlossyPlus *Model C750i
*UIConstraints: *MediaType GlossyPlus *Model C650i
*UIConstraints: *MediaType GlossyPlus *Model C550i
*UIConstraints: *MediaType GlossyPlus *Model C450i
*UIConstraints: *MediaType GlossyPlus *Model C360i
*UIConstraints: *MediaType GlossyPlus *Model C300i
*UIConstraints: *MediaType GlossyPlus *Model C250i
*UIConstraints: *MediaType GlossyPlus *Model C287i
*UIConstraints: *MediaType GlossyPlus *Model C257i
*UIConstraints: *MediaType GlossyPlus *Model C227i
*UIConstraints: *MediaType GlossyPlus *Model C286i
*UIConstraints: *MediaType GlossyPlus *Model C266i
*UIConstraints: *MediaType GlossyPlus *Model C226i
*UIConstraints: *MediaType Glossy2 *InputSlot Tray2
*UIConstraints: *MediaType Glossy2 *InputSlot Tray3
*UIConstraints: *MediaType Glossy2 *InputSlot Tray4
*UIConstraints: *MediaType Glossy2 *KMDuplex 2Sided
*UIConstraints: *MediaType Glossy2 *Combination Booklet
*UIConstraints: *MediaType Glossy2 *Model C751i
*UIConstraints: *MediaType Glossy2 *Model C651i
*UIConstraints: *MediaType Glossy2 *Model C551i
*UIConstraints: *MediaType Glossy2 *Model C451i
*UIConstraints: *MediaType Glossy2 *Model C361i
*UIConstraints: *MediaType Glossy2 *Model C301i
*UIConstraints: *MediaType Glossy2 *Model C251i
*UIConstraints: *MediaType Glossy2 *Model C750i
*UIConstraints: *MediaType Glossy2 *Model C650i
*UIConstraints: *MediaType Glossy2 *Model C550i
*UIConstraints: *MediaType Glossy2 *Model C450i
*UIConstraints: *MediaType Glossy2 *Model C360i
*UIConstraints: *MediaType Glossy2 *Model C300i
*UIConstraints: *MediaType Glossy2 *Model C250i
*UIConstraints: *MediaType Glossy2 *Model C287i
*UIConstraints: *MediaType Glossy2 *Model C257i
*UIConstraints: *MediaType Glossy2 *Model C227i
*UIConstraints: *MediaType Glossy2 *Model C286i
*UIConstraints: *MediaType Glossy2 *Model C266i
*UIConstraints: *MediaType Glossy2 *Model C226i
*UIConstraints: *MediaType User1 *PageSize LetterTab-F
*UIConstraints: *MediaType User1 *PageSize A4Tab-F
*UIConstraints: *MediaType User1 *TransparencyInterleave Blank
*UIConstraints: *MediaType User1(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User1(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User1(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User1(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User1(2nd) *InputSlot LCT
*UIConstraints: *MediaType User1(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User1(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User1(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User1(2nd) *Combination Booklet
*UIConstraints: *MediaType User1(2nd) *Fold Stitch
*UIConstraints: *MediaType User1(2nd) *Fold HalfFold
*UIConstraints: *MediaType User1(2nd) *Fold ZFold1
*UIConstraints: *MediaType User1(2nd) *Fold ZFold2
*UIConstraints: *MediaType User1(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User2_1 *PageSize LetterTab-F
*UIConstraints: *MediaType User2_1 *PageSize A4Tab-F
*UIConstraints: *MediaType User2_1 *TransparencyInterleave Blank
*UIConstraints: *MediaType User2_1 *Model C751i
*UIConstraints: *MediaType User2_1 *Model C651i
*UIConstraints: *MediaType User2_1 *Model C551i
*UIConstraints: *MediaType User2_1 *Model C451i
*UIConstraints: *MediaType User2_1 *Model C361i
*UIConstraints: *MediaType User2_1 *Model C301i
*UIConstraints: *MediaType User2_1 *Model C251i
*UIConstraints: *MediaType User2_1 *Model C4051i
*UIConstraints: *MediaType User2_1 *Model C3351i
*UIConstraints: *MediaType User2_1 *Model C4001i
*UIConstraints: *MediaType User2_1 *Model C3301i
*UIConstraints: *MediaType User2_1 *Model C3321i
*UIConstraints: *MediaType User2_1 *Model C750i
*UIConstraints: *MediaType User2_1 *Model C650i
*UIConstraints: *MediaType User2_1 *Model C550i
*UIConstraints: *MediaType User2_1 *Model C450i
*UIConstraints: *MediaType User2_1 *Model C360i
*UIConstraints: *MediaType User2_1 *Model C300i
*UIConstraints: *MediaType User2_1 *Model C250i
*UIConstraints: *MediaType User2_1 *Model C4050i
*UIConstraints: *MediaType User2_1 *Model C3350i
*UIConstraints: *MediaType User2_1 *Model C4000i
*UIConstraints: *MediaType User2_1 *Model C3300i
*UIConstraints: *MediaType User2_1 *Model C3320i
*UIConstraints: *MediaType User2(2nd)_1 *InputSlot Tray1
*UIConstraints: *MediaType User2(2nd)_1 *InputSlot Tray2
*UIConstraints: *MediaType User2(2nd)_1 *InputSlot Tray3
*UIConstraints: *MediaType User2(2nd)_1 *InputSlot Tray4
*UIConstraints: *MediaType User2(2nd)_1 *PageSize LetterTab-F
*UIConstraints: *MediaType User2(2nd)_1 *PageSize A4Tab-F
*UIConstraints: *MediaType User2(2nd)_1 *KMDuplex 2Sided
*UIConstraints: *MediaType User2(2nd)_1 *Combination Booklet
*UIConstraints: *MediaType User2(2nd)_1 *Fold Stitch
*UIConstraints: *MediaType User2(2nd)_1 *Fold HalfFold
*UIConstraints: *MediaType User2(2nd)_1 *TransparencyInterleave Blank
*UIConstraints: *MediaType User2(2nd)_1 *Model C751i
*UIConstraints: *MediaType User2(2nd)_1 *Model C651i
*UIConstraints: *MediaType User2(2nd)_1 *Model C551i
*UIConstraints: *MediaType User2(2nd)_1 *Model C451i
*UIConstraints: *MediaType User2(2nd)_1 *Model C361i
*UIConstraints: *MediaType User2(2nd)_1 *Model C301i
*UIConstraints: *MediaType User2(2nd)_1 *Model C251i
*UIConstraints: *MediaType User2(2nd)_1 *Model C4051i
*UIConstraints: *MediaType User2(2nd)_1 *Model C3351i
*UIConstraints: *MediaType User2(2nd)_1 *Model C4001i
*UIConstraints: *MediaType User2(2nd)_1 *Model C3301i
*UIConstraints: *MediaType User2(2nd)_1 *Model C3321i
*UIConstraints: *MediaType User2(2nd)_1 *Model C750i
*UIConstraints: *MediaType User2(2nd)_1 *Model C650i
*UIConstraints: *MediaType User2(2nd)_1 *Model C550i
*UIConstraints: *MediaType User2(2nd)_1 *Model C450i
*UIConstraints: *MediaType User2(2nd)_1 *Model C360i
*UIConstraints: *MediaType User2(2nd)_1 *Model C300i
*UIConstraints: *MediaType User2(2nd)_1 *Model C250i
*UIConstraints: *MediaType User2(2nd)_1 *Model C4050i
*UIConstraints: *MediaType User2(2nd)_1 *Model C3350i
*UIConstraints: *MediaType User2(2nd)_1 *Model C4000i
*UIConstraints: *MediaType User2(2nd)_1 *Model C3300i
*UIConstraints: *MediaType User2(2nd)_1 *Model C3320i
*UIConstraints: *MediaType User2 *PageSize LetterTab-F
*UIConstraints: *MediaType User2 *PageSize A4Tab-F
*UIConstraints: *MediaType User2 *Fold ZFold1
*UIConstraints: *MediaType User2 *Fold ZFold2
*UIConstraints: *MediaType User2 *TransparencyInterleave Blank
*UIConstraints: *MediaType User2 *Model C287i
*UIConstraints: *MediaType User2 *Model C257i
*UIConstraints: *MediaType User2 *Model C227i
*UIConstraints: *MediaType User2 *Model C286i
*UIConstraints: *MediaType User2 *Model C266i
*UIConstraints: *MediaType User2 *Model C226i
*UIConstraints: *MediaType User2(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User2(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User2(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User2(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User2(2nd) *InputSlot LCT
*UIConstraints: *MediaType User2(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User2(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User2(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User2(2nd) *Combination Booklet
*UIConstraints: *MediaType User2(2nd) *Fold Stitch
*UIConstraints: *MediaType User2(2nd) *Fold HalfFold
*UIConstraints: *MediaType User2(2nd) *Fold TriFold
*UIConstraints: *MediaType User2(2nd) *Fold ZFold1
*UIConstraints: *MediaType User2(2nd) *Fold ZFold2
*UIConstraints: *MediaType User2(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User2(2nd) *Model C287i
*UIConstraints: *MediaType User2(2nd) *Model C257i
*UIConstraints: *MediaType User2(2nd) *Model C227i
*UIConstraints: *MediaType User2(2nd) *Model C286i
*UIConstraints: *MediaType User2(2nd) *Model C266i
*UIConstraints: *MediaType User2(2nd) *Model C226i
*UIConstraints: *MediaType User3 *PageSize LetterTab-F
*UIConstraints: *MediaType User3 *PageSize A4Tab-F
*UIConstraints: *MediaType User3 *Fold ZFold1
*UIConstraints: *MediaType User3 *Fold ZFold2
*UIConstraints: *MediaType User3 *TransparencyInterleave Blank
*UIConstraints: *MediaType User3 *GlossyMode True
*UIConstraints: *MediaType User3(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User3(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User3(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User3(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User3(2nd) *InputSlot LCT
*UIConstraints: *MediaType User3(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User3(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User3(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User3(2nd) *Combination Booklet
*UIConstraints: *MediaType User3(2nd) *Fold Stitch
*UIConstraints: *MediaType User3(2nd) *Fold HalfFold
*UIConstraints: *MediaType User3(2nd) *Fold TriFold
*UIConstraints: *MediaType User3(2nd) *Fold ZFold1
*UIConstraints: *MediaType User3(2nd) *Fold ZFold2
*UIConstraints: *MediaType User3(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User3(2nd) *GlossyMode True
*UIConstraints: *MediaType User4 *PageSize LetterTab-F
*UIConstraints: *MediaType User4 *PageSize A4Tab-F
*UIConstraints: *MediaType User4 *Fold TriFold
*UIConstraints: *MediaType User4 *Fold ZFold1
*UIConstraints: *MediaType User4 *Fold ZFold2
*UIConstraints: *MediaType User4 *TransparencyInterleave Blank
*UIConstraints: *MediaType User4 *GlossyMode True
*UIConstraints: *MediaType User4(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User4(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User4(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User4(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User4(2nd) *InputSlot LCT
*UIConstraints: *MediaType User4(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User4(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User4(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User4(2nd) *Combination Booklet
*UIConstraints: *MediaType User4(2nd) *Fold Stitch
*UIConstraints: *MediaType User4(2nd) *Fold HalfFold
*UIConstraints: *MediaType User4(2nd) *Fold TriFold
*UIConstraints: *MediaType User4(2nd) *Fold ZFold1
*UIConstraints: *MediaType User4(2nd) *Fold ZFold2
*UIConstraints: *MediaType User4(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User4(2nd) *GlossyMode True
*UIConstraints: *MediaType User5 *PageSize LetterTab-F
*UIConstraints: *MediaType User5 *PageSize A4Tab-F
*UIConstraints: *MediaType User5 *Fold TriFold
*UIConstraints: *MediaType User5 *Fold ZFold1
*UIConstraints: *MediaType User5 *Fold ZFold2
*UIConstraints: *MediaType User5 *TransparencyInterleave Blank
*UIConstraints: *MediaType User5 *GlossyMode True
*UIConstraints: *MediaType User5(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User5(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User5(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User5(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User5(2nd) *InputSlot LCT
*UIConstraints: *MediaType User5(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User5(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User5(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User5(2nd) *Combination Booklet
*UIConstraints: *MediaType User5(2nd) *Fold Stitch
*UIConstraints: *MediaType User5(2nd) *Fold HalfFold
*UIConstraints: *MediaType User5(2nd) *Fold TriFold
*UIConstraints: *MediaType User5(2nd) *Fold ZFold1
*UIConstraints: *MediaType User5(2nd) *Fold ZFold2
*UIConstraints: *MediaType User5(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User5(2nd) *GlossyMode True
*UIConstraints: *MediaType User6 *PageSize LetterTab-F
*UIConstraints: *MediaType User6 *PageSize A4Tab-F
*UIConstraints: *MediaType User6 *Fold Stitch
*UIConstraints: *MediaType User6 *Fold HalfFold
*UIConstraints: *MediaType User6 *Fold TriFold
*UIConstraints: *MediaType User6 *Fold ZFold1
*UIConstraints: *MediaType User6 *Fold ZFold2
*UIConstraints: *MediaType User6 *TransparencyInterleave Blank
*UIConstraints: *MediaType User6 *GlossyMode True
*UIConstraints: *MediaType User6 *Model C4051i
*UIConstraints: *MediaType User6 *Model C3351i
*UIConstraints: *MediaType User6 *Model C4001i
*UIConstraints: *MediaType User6 *Model C3301i
*UIConstraints: *MediaType User6 *Model C3321i
*UIConstraints: *MediaType User6 *Model C4050i
*UIConstraints: *MediaType User6 *Model C3350i
*UIConstraints: *MediaType User6 *Model C4000i
*UIConstraints: *MediaType User6 *Model C3300i
*UIConstraints: *MediaType User6 *Model C3320i
*UIConstraints: *MediaType User6(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User6(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User6(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User6(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User6(2nd) *InputSlot LCT
*UIConstraints: *MediaType User6(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User6(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User6(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User6(2nd) *Combination Booklet
*UIConstraints: *MediaType User6(2nd) *Fold Stitch
*UIConstraints: *MediaType User6(2nd) *Fold HalfFold
*UIConstraints: *MediaType User6(2nd) *Fold TriFold
*UIConstraints: *MediaType User6(2nd) *Fold ZFold1
*UIConstraints: *MediaType User6(2nd) *Fold ZFold2
*UIConstraints: *MediaType User6(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User6(2nd) *GlossyMode True
*UIConstraints: *MediaType User6(2nd) *Model C4051i
*UIConstraints: *MediaType User6(2nd) *Model C3351i
*UIConstraints: *MediaType User6(2nd) *Model C4001i
*UIConstraints: *MediaType User6(2nd) *Model C3301i
*UIConstraints: *MediaType User6(2nd) *Model C3321i
*UIConstraints: *MediaType User6(2nd) *Model C4050i
*UIConstraints: *MediaType User6(2nd) *Model C3350i
*UIConstraints: *MediaType User6(2nd) *Model C4000i
*UIConstraints: *MediaType User6(2nd) *Model C3300i
*UIConstraints: *MediaType User6(2nd) *Model C3320i
*UIConstraints: *MediaType User7 *InputSlot Tray1
*UIConstraints: *MediaType User7 *InputSlot Tray2
*UIConstraints: *MediaType User7 *InputSlot Tray3
*UIConstraints: *MediaType User7 *InputSlot Tray4
*UIConstraints: *MediaType User7 *InputSlot LCT
*UIConstraints: *MediaType User7 *PageSize LetterTab-F
*UIConstraints: *MediaType User7 *PageSize A4Tab-F
*UIConstraints: *MediaType User7 *Fold TriFold
*UIConstraints: *MediaType User7 *Fold ZFold1
*UIConstraints: *MediaType User7 *Fold ZFold2
*UIConstraints: *MediaType User7 *TransparencyInterleave Blank
*UIConstraints: *MediaType User7 *GlossyMode True
*UIConstraints: *MediaType User7 *Model C651i
*UIConstraints: *MediaType User7 *Model C551i
*UIConstraints: *MediaType User7 *Model C451i
*UIConstraints: *MediaType User7 *Model C361i
*UIConstraints: *MediaType User7 *Model C301i
*UIConstraints: *MediaType User7 *Model C251i
*UIConstraints: *MediaType User7 *Model C4051i
*UIConstraints: *MediaType User7 *Model C3351i
*UIConstraints: *MediaType User7 *Model C4001i
*UIConstraints: *MediaType User7 *Model C3301i
*UIConstraints: *MediaType User7 *Model C3321i
*UIConstraints: *MediaType User7 *Model C650i
*UIConstraints: *MediaType User7 *Model C550i
*UIConstraints: *MediaType User7 *Model C450i
*UIConstraints: *MediaType User7 *Model C360i
*UIConstraints: *MediaType User7 *Model C300i
*UIConstraints: *MediaType User7 *Model C250i
*UIConstraints: *MediaType User7 *Model C287i
*UIConstraints: *MediaType User7 *Model C257i
*UIConstraints: *MediaType User7 *Model C227i
*UIConstraints: *MediaType User7 *Model C286i
*UIConstraints: *MediaType User7 *Model C266i
*UIConstraints: *MediaType User7 *Model C226i
*UIConstraints: *MediaType User7 *Model C4050i
*UIConstraints: *MediaType User7 *Model C3350i
*UIConstraints: *MediaType User7 *Model C4000i
*UIConstraints: *MediaType User7 *Model C3300i
*UIConstraints: *MediaType User7 *Model C3320i
*UIConstraints: *MediaType User7(2nd) *InputSlot Tray1
*UIConstraints: *MediaType User7(2nd) *InputSlot Tray2
*UIConstraints: *MediaType User7(2nd) *InputSlot Tray3
*UIConstraints: *MediaType User7(2nd) *InputSlot Tray4
*UIConstraints: *MediaType User7(2nd) *InputSlot LCT
*UIConstraints: *MediaType User7(2nd) *PageSize LetterTab-F
*UIConstraints: *MediaType User7(2nd) *PageSize A4Tab-F
*UIConstraints: *MediaType User7(2nd) *KMDuplex 2Sided
*UIConstraints: *MediaType User7(2nd) *Combination Booklet
*UIConstraints: *MediaType User7(2nd) *Fold Stitch
*UIConstraints: *MediaType User7(2nd) *Fold HalfFold
*UIConstraints: *MediaType User7(2nd) *Fold TriFold
*UIConstraints: *MediaType User7(2nd) *Fold ZFold1
*UIConstraints: *MediaType User7(2nd) *Fold ZFold2
*UIConstraints: *MediaType User7(2nd) *TransparencyInterleave Blank
*UIConstraints: *MediaType User7(2nd) *GlossyMode True
*UIConstraints: *MediaType User7(2nd) *Model C651i
*UIConstraints: *MediaType User7(2nd) *Model C551i
*UIConstraints: *MediaType User7(2nd) *Model C451i
*UIConstraints: *MediaType User7(2nd) *Model C361i
*UIConstraints: *MediaType User7(2nd) *Model C301i
*UIConstraints: *MediaType User7(2nd) *Model C251i
*UIConstraints: *MediaType User7(2nd) *Model C4051i
*UIConstraints: *MediaType User7(2nd) *Model C3351i
*UIConstraints: *MediaType User7(2nd) *Model C4001i
*UIConstraints: *MediaType User7(2nd) *Model C3301i
*UIConstraints: *MediaType User7(2nd) *Model C3321i
*UIConstraints: *MediaType User7(2nd) *Model C650i
*UIConstraints: *MediaType User7(2nd) *Model C550i
*UIConstraints: *MediaType User7(2nd) *Model C450i
*UIConstraints: *MediaType User7(2nd) *Model C360i
*UIConstraints: *MediaType User7(2nd) *Model C300i
*UIConstraints: *MediaType User7(2nd) *Model C250i
*UIConstraints: *MediaType User7(2nd) *Model C287i
*UIConstraints: *MediaType User7(2nd) *Model C257i
*UIConstraints: *MediaType User7(2nd) *Model C227i
*UIConstraints: *MediaType User7(2nd) *Model C286i
*UIConstraints: *MediaType User7(2nd) *Model C266i
*UIConstraints: *MediaType User7(2nd) *Model C226i
*UIConstraints: *MediaType User7(2nd) *Model C4050i
*UIConstraints: *MediaType User7(2nd) *Model C3350i
*UIConstraints: *MediaType User7(2nd) *Model C4000i
*UIConstraints: *MediaType User7(2nd) *Model C3300i
*UIConstraints: *MediaType User7(2nd) *Model C3320i
*UIConstraints: *PageSize A3 *MediaType TAB
*UIConstraints: *PageSize A3 *OutputBin Tray4
*UIConstraints: *PageSize A3 *Combination Booklet
*UIConstraints: *PageSize A3 *Fold TriFold
*UIConstraints: *PageSize A3 *Model C4051i
*UIConstraints: *PageSize A3 *Model C3351i
*UIConstraints: *PageSize A3 *Model C4001i
*UIConstraints: *PageSize A3 *Model C3301i
*UIConstraints: *PageSize A3 *Model C3321i
*UIConstraints: *PageSize A3 *Model C4050i
*UIConstraints: *PageSize A3 *Model C3350i
*UIConstraints: *PageSize A3 *Model C4000i
*UIConstraints: *PageSize A3 *Model C3300i
*UIConstraints: *PageSize A3 *Model C3320i
*UIConstraints: *PageSize A4 *MediaType TAB
*UIConstraints: *PageSize A5 *MediaType TAB
*UIConstraints: *PageSize A5 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize A5 *Staple 1StapleZeroRight
*UIConstraints: *PageSize A5 *Punch 3holes
*UIConstraints: *PageSize A5 *Fold TriFold
*UIConstraints: *PageSize A6 *InputSlot LCT
*UIConstraints: *PageSize A6 *MediaType TAB
*UIConstraints: *PageSize A6 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize A6 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize A6 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize A6 *Staple 1StapleZeroRight
*UIConstraints: *PageSize A6 *Staple 2Staples
*UIConstraints: *PageSize A6 *Punch 2holes
*UIConstraints: *PageSize A6 *Punch 3holes
*UIConstraints: *PageSize A6 *Punch 4holes
*UIConstraints: *PageSize A6 *Fold Stitch
*UIConstraints: *PageSize A6 *Fold HalfFold
*UIConstraints: *PageSize A6 *Fold TriFold
*UIConstraints: *PageSize B4 *MediaType TAB
*UIConstraints: *PageSize B4 *OutputBin Tray4
*UIConstraints: *PageSize B4 *Combination Booklet
*UIConstraints: *PageSize B4 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize B4 *Staple 1StapleZeroRight
*UIConstraints: *PageSize B4 *Fold TriFold
*UIConstraints: *PageSize B4 *Model C4051i
*UIConstraints: *PageSize B4 *Model C3351i
*UIConstraints: *PageSize B4 *Model C4001i
*UIConstraints: *PageSize B4 *Model C3301i
*UIConstraints: *PageSize B4 *Model C3321i
*UIConstraints: *PageSize B4 *Model C4050i
*UIConstraints: *PageSize B4 *Model C3350i
*UIConstraints: *PageSize B4 *Model C4000i
*UIConstraints: *PageSize B4 *Model C3300i
*UIConstraints: *PageSize B4 *Model C3320i
*UIConstraints: *PageSize B5 *InputSlot LCT
*UIConstraints: *PageSize B5 *MediaType TAB
*UIConstraints: *PageSize B5 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize B5 *Staple 1StapleZeroRight
*UIConstraints: *PageSize B5 *Fold TriFold
*UIConstraints: *PageSize B6 *InputSlot LCT
*UIConstraints: *PageSize B6 *MediaType TAB
*UIConstraints: *PageSize B6 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize B6 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize B6 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize B6 *Staple 1StapleZeroRight
*UIConstraints: *PageSize B6 *Staple 2Staples
*UIConstraints: *PageSize B6 *Punch 2holes
*UIConstraints: *PageSize B6 *Punch 3holes
*UIConstraints: *PageSize B6 *Punch 4holes
*UIConstraints: *PageSize B6 *Fold Stitch
*UIConstraints: *PageSize B6 *Fold HalfFold
*UIConstraints: *PageSize B6 *Fold TriFold
*UIConstraints: *PageSize SRA3 *InputSlot Tray1
*UIConstraints: *PageSize SRA3 *InputSlot Tray3
*UIConstraints: *PageSize SRA3 *InputSlot Tray4
*UIConstraints: *PageSize SRA3 *MediaType TAB
*UIConstraints: *PageSize SRA3 *OutputBin Tray4
*UIConstraints: *PageSize SRA3 *Combination Booklet
*UIConstraints: *PageSize SRA3 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize SRA3 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize SRA3 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize SRA3 *Staple 1StapleZeroRight
*UIConstraints: *PageSize SRA3 *Staple 2Staples
*UIConstraints: *PageSize SRA3 *Punch 2holes
*UIConstraints: *PageSize SRA3 *Punch 3holes
*UIConstraints: *PageSize SRA3 *Punch 4holes
*UIConstraints: *PageSize SRA3 *Fold TriFold
*UIConstraints: *PageSize SRA3 *Model C4051i
*UIConstraints: *PageSize SRA3 *Model C3351i
*UIConstraints: *PageSize SRA3 *Model C4001i
*UIConstraints: *PageSize SRA3 *Model C3301i
*UIConstraints: *PageSize SRA3 *Model C3321i
*UIConstraints: *PageSize SRA3 *Model C287i
*UIConstraints: *PageSize SRA3 *Model C257i
*UIConstraints: *PageSize SRA3 *Model C227i
*UIConstraints: *PageSize SRA3 *Model C286i
*UIConstraints: *PageSize SRA3 *Model C266i
*UIConstraints: *PageSize SRA3 *Model C226i
*UIConstraints: *PageSize SRA3 *Model C4050i
*UIConstraints: *PageSize SRA3 *Model C3350i
*UIConstraints: *PageSize SRA3 *Model C4000i
*UIConstraints: *PageSize SRA3 *Model C3300i
*UIConstraints: *PageSize SRA3 *Model C3320i
*UIConstraints: *PageSize 220mmx330mm *InputSlot LCT
*UIConstraints: *PageSize 220mmx330mm *MediaType TAB
*UIConstraints: *PageSize 220mmx330mm *OutputBin Tray4
*UIConstraints: *PageSize 220mmx330mm *Combination Booklet
*UIConstraints: *PageSize 220mmx330mm *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 220mmx330mm *Staple 1StapleZeroRight
*UIConstraints: *PageSize 220mmx330mm *Punch 3holes
*UIConstraints: *PageSize 220mmx330mm *Fold TriFold
*UIConstraints: *PageSize 220mmx330mm *Model C4051i
*UIConstraints: *PageSize 220mmx330mm *Model C3351i
*UIConstraints: *PageSize 220mmx330mm *Model C4001i
*UIConstraints: *PageSize 220mmx330mm *Model C3301i
*UIConstraints: *PageSize 220mmx330mm *Model C3321i
*UIConstraints: *PageSize 220mmx330mm *Model C4050i
*UIConstraints: *PageSize 220mmx330mm *Model C3350i
*UIConstraints: *PageSize 220mmx330mm *Model C4000i
*UIConstraints: *PageSize 220mmx330mm *Model C3300i
*UIConstraints: *PageSize 220mmx330mm *Model C3320i
*UIConstraints: *PageSize 12x18 *InputSlot Tray1
*UIConstraints: *PageSize 12x18 *InputSlot Tray3
*UIConstraints: *PageSize 12x18 *InputSlot Tray4
*UIConstraints: *PageSize 12x18 *MediaType TAB
*UIConstraints: *PageSize 12x18 *OutputBin Tray4
*UIConstraints: *PageSize 12x18 *Combination Booklet
*UIConstraints: *PageSize 12x18 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize 12x18 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 12x18 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize 12x18 *Staple 1StapleZeroRight
*UIConstraints: *PageSize 12x18 *Staple 2Staples
*UIConstraints: *PageSize 12x18 *Punch 2holes
*UIConstraints: *PageSize 12x18 *Punch 3holes
*UIConstraints: *PageSize 12x18 *Punch 4holes
*UIConstraints: *PageSize 12x18 *Fold TriFold
*UIConstraints: *PageSize 12x18 *Model C4051i
*UIConstraints: *PageSize 12x18 *Model C3351i
*UIConstraints: *PageSize 12x18 *Model C4001i
*UIConstraints: *PageSize 12x18 *Model C3301i
*UIConstraints: *PageSize 12x18 *Model C3321i
*UIConstraints: *PageSize 12x18 *Model C287i
*UIConstraints: *PageSize 12x18 *Model C257i
*UIConstraints: *PageSize 12x18 *Model C227i
*UIConstraints: *PageSize 12x18 *Model C286i
*UIConstraints: *PageSize 12x18 *Model C266i
*UIConstraints: *PageSize 12x18 *Model C226i
*UIConstraints: *PageSize 12x18 *Model C4050i
*UIConstraints: *PageSize 12x18 *Model C3350i
*UIConstraints: *PageSize 12x18 *Model C4000i
*UIConstraints: *PageSize 12x18 *Model C3300i
*UIConstraints: *PageSize 12x18 *Model C3320i
*UIConstraints: *PageSize Tabloid *MediaType TAB
*UIConstraints: *PageSize Tabloid *OutputBin Tray4
*UIConstraints: *PageSize Tabloid *Combination Booklet
*UIConstraints: *PageSize Tabloid *Fold TriFold
*UIConstraints: *PageSize Tabloid *Model C4051i
*UIConstraints: *PageSize Tabloid *Model C3351i
*UIConstraints: *PageSize Tabloid *Model C4001i
*UIConstraints: *PageSize Tabloid *Model C3301i
*UIConstraints: *PageSize Tabloid *Model C3321i
*UIConstraints: *PageSize Tabloid *Model C4050i
*UIConstraints: *PageSize Tabloid *Model C3350i
*UIConstraints: *PageSize Tabloid *Model C4000i
*UIConstraints: *PageSize Tabloid *Model C3300i
*UIConstraints: *PageSize Tabloid *Model C3320i
*UIConstraints: *PageSize Legal *MediaType TAB
*UIConstraints: *PageSize Legal *OutputBin Tray4
*UIConstraints: *PageSize Legal *Combination Booklet
*UIConstraints: *PageSize Legal *Staple 1StapleZeroLeft
*UIConstraints: *PageSize Legal *Staple 1StapleZeroRight
*UIConstraints: *PageSize Legal *Punch 3holes
*UIConstraints: *PageSize Legal *Fold TriFold
*UIConstraints: *PageSize Letter *MediaType TAB
*UIConstraints: *PageSize LetterPlus *InputSlot Tray1
*UIConstraints: *PageSize LetterPlus *InputSlot Tray2
*UIConstraints: *PageSize LetterPlus *InputSlot Tray3
*UIConstraints: *PageSize LetterPlus *InputSlot Tray4
*UIConstraints: *PageSize LetterPlus *Combination Booklet
*UIConstraints: *PageSize LetterPlus *Model C751i
*UIConstraints: *PageSize LetterPlus *Model C651i
*UIConstraints: *PageSize LetterPlus *Model C551i
*UIConstraints: *PageSize LetterPlus *Model C451i
*UIConstraints: *PageSize LetterPlus *Model C361i
*UIConstraints: *PageSize LetterPlus *Model C301i
*UIConstraints: *PageSize LetterPlus *Model C251i
*UIConstraints: *PageSize LetterPlus *Model C750i
*UIConstraints: *PageSize LetterPlus *Model C650i
*UIConstraints: *PageSize LetterPlus *Model C550i
*UIConstraints: *PageSize LetterPlus *Model C450i
*UIConstraints: *PageSize LetterPlus *Model C360i
*UIConstraints: *PageSize LetterPlus *Model C300i
*UIConstraints: *PageSize LetterPlus *Model C250i
*UIConstraints: *PageSize LetterPlus *Model C287i
*UIConstraints: *PageSize LetterPlus *Model C257i
*UIConstraints: *PageSize LetterPlus *Model C227i
*UIConstraints: *PageSize LetterPlus *Model C286i
*UIConstraints: *PageSize LetterPlus *Model C266i
*UIConstraints: *PageSize LetterPlus *Model C226i
*UIConstraints: *PageSize Statement *MediaType TAB
*UIConstraints: *PageSize Statement *Staple 1StapleZeroLeft
*UIConstraints: *PageSize Statement *Staple 1StapleZeroRight
*UIConstraints: *PageSize Statement *Punch 3holes
*UIConstraints: *PageSize Statement *Fold TriFold
*UIConstraints: *PageSize 8x13 *InputSlot LCT
*UIConstraints: *PageSize 8x13 *MediaType TAB
*UIConstraints: *PageSize 8x13 *OutputBin Tray4
*UIConstraints: *PageSize 8x13 *Combination Booklet
*UIConstraints: *PageSize 8x13 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 8x13 *Staple 1StapleZeroRight
*UIConstraints: *PageSize 8x13 *Punch 3holes
*UIConstraints: *PageSize 8x13 *Fold Stitch
*UIConstraints: *PageSize 8x13 *Fold HalfFold
*UIConstraints: *PageSize 8x13 *Fold TriFold
*UIConstraints: *PageSize 8.5x13 *InputSlot LCT
*UIConstraints: *PageSize 8.5x13 *MediaType TAB
*UIConstraints: *PageSize 8.5x13 *OutputBin Tray4
*UIConstraints: *PageSize 8.5x13 *Combination Booklet
*UIConstraints: *PageSize 8.5x13 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 8.5x13 *Staple 1StapleZeroRight
*UIConstraints: *PageSize 8.5x13 *Punch 3holes
*UIConstraints: *PageSize 8.5x13 *Fold TriFold
*UIConstraints: *PageSize 8.5x13.5 *InputSlot LCT
*UIConstraints: *PageSize 8.5x13.5 *MediaType TAB
*UIConstraints: *PageSize 8.5x13.5 *OutputBin Tray4
*UIConstraints: *PageSize 8.5x13.5 *Combination Booklet
*UIConstraints: *PageSize 8.5x13.5 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 8.5x13.5 *Staple 1StapleZeroRight
*UIConstraints: *PageSize 8.5x13.5 *Punch 3holes
*UIConstraints: *PageSize 8.5x13.5 *Punch 4holes
*UIConstraints: *PageSize 8.5x13.5 *Fold TriFold
*UIConstraints: *PageSize 8.25x13 *InputSlot LCT
*UIConstraints: *PageSize 8.25x13 *MediaType TAB
*UIConstraints: *PageSize 8.25x13 *OutputBin Tray4
*UIConstraints: *PageSize 8.25x13 *Combination Booklet
*UIConstraints: *PageSize 8.25x13 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 8.25x13 *Staple 1StapleZeroRight
*UIConstraints: *PageSize 8.25x13 *Punch 3holes
*UIConstraints: *PageSize 8.25x13 *Fold Stitch
*UIConstraints: *PageSize 8.25x13 *Fold HalfFold
*UIConstraints: *PageSize 8.25x13 *Fold TriFold
*UIConstraints: *PageSize 8.125x13.25 *InputSlot LCT
*UIConstraints: *PageSize 8.125x13.25 *MediaType TAB
*UIConstraints: *PageSize 8.125x13.25 *OutputBin Tray4
*UIConstraints: *PageSize 8.125x13.25 *Combination Booklet
*UIConstraints: *PageSize 8.125x13.25 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 8.125x13.25 *Staple 1StapleZeroRight
*UIConstraints: *PageSize 8.125x13.25 *Punch 3holes
*UIConstraints: *PageSize 8.125x13.25 *Fold Stitch
*UIConstraints: *PageSize 8.125x13.25 *Fold HalfFold
*UIConstraints: *PageSize 8.125x13.25 *Fold TriFold
*UIConstraints: *PageSize 8x10 *InputSlot Tray2
*UIConstraints: *PageSize 8x10 *InputSlot Tray3
*UIConstraints: *PageSize 8x10 *InputSlot Tray4
*UIConstraints: *PageSize 8x10 *Combination Booklet
*UIConstraints: *PageSize 8x10 *Model C751i
*UIConstraints: *PageSize 8x10 *Model C651i
*UIConstraints: *PageSize 8x10 *Model C551i
*UIConstraints: *PageSize 8x10 *Model C451i
*UIConstraints: *PageSize 8x10 *Model C361i
*UIConstraints: *PageSize 8x10 *Model C301i
*UIConstraints: *PageSize 8x10 *Model C251i
*UIConstraints: *PageSize 8x10 *Model C750i
*UIConstraints: *PageSize 8x10 *Model C650i
*UIConstraints: *PageSize 8x10 *Model C550i
*UIConstraints: *PageSize 8x10 *Model C450i
*UIConstraints: *PageSize 8x10 *Model C360i
*UIConstraints: *PageSize 8x10 *Model C300i
*UIConstraints: *PageSize 8x10 *Model C250i
*UIConstraints: *PageSize 8x10 *Model C287i
*UIConstraints: *PageSize 8x10 *Model C257i
*UIConstraints: *PageSize 8x10 *Model C227i
*UIConstraints: *PageSize 8x10 *Model C286i
*UIConstraints: *PageSize 8x10 *Model C266i
*UIConstraints: *PageSize 8x10 *Model C226i
*UIConstraints: *PageSize 8x10.5 *InputSlot Tray2
*UIConstraints: *PageSize 8x10.5 *InputSlot Tray3
*UIConstraints: *PageSize 8x10.5 *InputSlot Tray4
*UIConstraints: *PageSize 8x10.5 *Combination Booklet
*UIConstraints: *PageSize 8x10.5 *Model C751i
*UIConstraints: *PageSize 8x10.5 *Model C651i
*UIConstraints: *PageSize 8x10.5 *Model C551i
*UIConstraints: *PageSize 8x10.5 *Model C451i
*UIConstraints: *PageSize 8x10.5 *Model C361i
*UIConstraints: *PageSize 8x10.5 *Model C301i
*UIConstraints: *PageSize 8x10.5 *Model C251i
*UIConstraints: *PageSize 8x10.5 *Model C750i
*UIConstraints: *PageSize 8x10.5 *Model C650i
*UIConstraints: *PageSize 8x10.5 *Model C550i
*UIConstraints: *PageSize 8x10.5 *Model C450i
*UIConstraints: *PageSize 8x10.5 *Model C360i
*UIConstraints: *PageSize 8x10.5 *Model C300i
*UIConstraints: *PageSize 8x10.5 *Model C250i
*UIConstraints: *PageSize 8x10.5 *Model C287i
*UIConstraints: *PageSize 8x10.5 *Model C257i
*UIConstraints: *PageSize 8x10.5 *Model C227i
*UIConstraints: *PageSize 8x10.5 *Model C286i
*UIConstraints: *PageSize 8x10.5 *Model C266i
*UIConstraints: *PageSize 8x10.5 *Model C226i
*UIConstraints: *PageSize Executive *InputSlot LCT
*UIConstraints: *PageSize Executive *MediaType TAB
*UIConstraints: *PageSize Executive *Combination Booklet
*UIConstraints: *PageSize Executive *Staple 1StapleZeroLeft
*UIConstraints: *PageSize Executive *Staple 1StapleZeroRight
*UIConstraints: *PageSize Executive *Fold Stitch
*UIConstraints: *PageSize Executive *Fold HalfFold
*UIConstraints: *PageSize Executive *Fold TriFold
*UIConstraints: *PageSize Executive *TransparencyInterleave Blank
*UIConstraints: *PageSize 8K *InputSlot LCT
*UIConstraints: *PageSize 8K *MediaType TAB
*UIConstraints: *PageSize 8K *OutputBin Tray4
*UIConstraints: *PageSize 8K *Combination Booklet
*UIConstraints: *PageSize 8K *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 8K *Staple 1StapleZeroRight
*UIConstraints: *PageSize 8K *Fold TriFold
*UIConstraints: *PageSize 8K *Model C4051i
*UIConstraints: *PageSize 8K *Model C3351i
*UIConstraints: *PageSize 8K *Model C4001i
*UIConstraints: *PageSize 8K *Model C3301i
*UIConstraints: *PageSize 8K *Model C3321i
*UIConstraints: *PageSize 8K *Model C4050i
*UIConstraints: *PageSize 8K *Model C3350i
*UIConstraints: *PageSize 8K *Model C4000i
*UIConstraints: *PageSize 8K *Model C3300i
*UIConstraints: *PageSize 8K *Model C3320i
*UIConstraints: *PageSize 16K *InputSlot LCT
*UIConstraints: *PageSize 16K *MediaType TAB
*UIConstraints: *PageSize 16K *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 16K *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvISOB5 *Offset True
*UIConstraints: *PageSize EnvISOB5 *InputSlot Tray2
*UIConstraints: *PageSize EnvISOB5 *InputSlot Tray3
*UIConstraints: *PageSize EnvISOB5 *InputSlot Tray4
*UIConstraints: *PageSize EnvISOB5 *InputSlot LCT
*UIConstraints: *PageSize EnvISOB5 *MediaType Thin
*UIConstraints: *PageSize EnvISOB5 *MediaType Transparency
*UIConstraints: *PageSize EnvISOB5 *MediaType TAB
*UIConstraints: *PageSize EnvISOB5 *Combination Booklet
*UIConstraints: *PageSize EnvISOB5 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvISOB5 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvISOB5 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvISOB5 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvISOB5 *Staple 2Staples
*UIConstraints: *PageSize EnvISOB5 *Punch 2holes
*UIConstraints: *PageSize EnvISOB5 *Punch 3holes
*UIConstraints: *PageSize EnvISOB5 *Punch 4holes
*UIConstraints: *PageSize EnvISOB5 *Fold Stitch
*UIConstraints: *PageSize EnvISOB5 *Fold HalfFold
*UIConstraints: *PageSize EnvISOB5 *Fold TriFold
*UIConstraints: *PageSize EnvISOB5 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvC4 *Offset True
*UIConstraints: *PageSize EnvC4 *InputSlot Tray2
*UIConstraints: *PageSize EnvC4 *InputSlot Tray3
*UIConstraints: *PageSize EnvC4 *InputSlot Tray4
*UIConstraints: *PageSize EnvC4 *InputSlot LCT
*UIConstraints: *PageSize EnvC4 *MediaType Thin
*UIConstraints: *PageSize EnvC4 *MediaType Transparency
*UIConstraints: *PageSize EnvC4 *MediaType TAB
*UIConstraints: *PageSize EnvC4 *Combination Booklet
*UIConstraints: *PageSize EnvC4 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvC4 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvC4 *Punch 2holes
*UIConstraints: *PageSize EnvC4 *Punch 3holes
*UIConstraints: *PageSize EnvC4 *Punch 4holes
*UIConstraints: *PageSize EnvC4 *Fold TriFold
*UIConstraints: *PageSize EnvC4 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvC4 *Model C4051i
*UIConstraints: *PageSize EnvC4 *Model C3351i
*UIConstraints: *PageSize EnvC4 *Model C4001i
*UIConstraints: *PageSize EnvC4 *Model C3301i
*UIConstraints: *PageSize EnvC4 *Model C3321i
*UIConstraints: *PageSize EnvC4 *Model C4050i
*UIConstraints: *PageSize EnvC4 *Model C3350i
*UIConstraints: *PageSize EnvC4 *Model C4000i
*UIConstraints: *PageSize EnvC4 *Model C3300i
*UIConstraints: *PageSize EnvC4 *Model C3320i
*UIConstraints: *PageSize EnvC5 *Offset True
*UIConstraints: *PageSize EnvC5 *InputSlot Tray2
*UIConstraints: *PageSize EnvC5 *InputSlot Tray3
*UIConstraints: *PageSize EnvC5 *InputSlot Tray4
*UIConstraints: *PageSize EnvC5 *InputSlot LCT
*UIConstraints: *PageSize EnvC5 *MediaType Thin
*UIConstraints: *PageSize EnvC5 *MediaType Transparency
*UIConstraints: *PageSize EnvC5 *MediaType TAB
*UIConstraints: *PageSize EnvC5 *Combination Booklet
*UIConstraints: *PageSize EnvC5 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvC5 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvC5 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvC5 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvC5 *Staple 2Staples
*UIConstraints: *PageSize EnvC5 *Punch 2holes
*UIConstraints: *PageSize EnvC5 *Punch 3holes
*UIConstraints: *PageSize EnvC5 *Punch 4holes
*UIConstraints: *PageSize EnvC5 *Fold Stitch
*UIConstraints: *PageSize EnvC5 *Fold HalfFold
*UIConstraints: *PageSize EnvC5 *Fold TriFold
*UIConstraints: *PageSize EnvC5 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvC5 *Model C4051i
*UIConstraints: *PageSize EnvC5 *Model C3351i
*UIConstraints: *PageSize EnvC5 *Model C4001i
*UIConstraints: *PageSize EnvC5 *Model C3301i
*UIConstraints: *PageSize EnvC5 *Model C3321i
*UIConstraints: *PageSize EnvC5 *Model C4050i
*UIConstraints: *PageSize EnvC5 *Model C3350i
*UIConstraints: *PageSize EnvC5 *Model C4000i
*UIConstraints: *PageSize EnvC5 *Model C3300i
*UIConstraints: *PageSize EnvC5 *Model C3320i
*UIConstraints: *PageSize EnvC6 *Offset True
*UIConstraints: *PageSize EnvC6 *InputSlot Tray2
*UIConstraints: *PageSize EnvC6 *InputSlot Tray3
*UIConstraints: *PageSize EnvC6 *InputSlot Tray4
*UIConstraints: *PageSize EnvC6 *InputSlot LCT
*UIConstraints: *PageSize EnvC6 *MediaType Thin
*UIConstraints: *PageSize EnvC6 *MediaType Transparency
*UIConstraints: *PageSize EnvC6 *MediaType TAB
*UIConstraints: *PageSize EnvC6 *Combination Booklet
*UIConstraints: *PageSize EnvC6 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvC6 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvC6 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvC6 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvC6 *Staple 2Staples
*UIConstraints: *PageSize EnvC6 *Punch 2holes
*UIConstraints: *PageSize EnvC6 *Punch 3holes
*UIConstraints: *PageSize EnvC6 *Punch 4holes
*UIConstraints: *PageSize EnvC6 *Fold Stitch
*UIConstraints: *PageSize EnvC6 *Fold HalfFold
*UIConstraints: *PageSize EnvC6 *Fold TriFold
*UIConstraints: *PageSize EnvC6 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvChou3 *Offset True
*UIConstraints: *PageSize EnvChou3 *InputSlot Tray2
*UIConstraints: *PageSize EnvChou3 *InputSlot Tray3
*UIConstraints: *PageSize EnvChou3 *InputSlot Tray4
*UIConstraints: *PageSize EnvChou3 *InputSlot LCT
*UIConstraints: *PageSize EnvChou3 *MediaType Thin
*UIConstraints: *PageSize EnvChou3 *MediaType Transparency
*UIConstraints: *PageSize EnvChou3 *MediaType TAB
*UIConstraints: *PageSize EnvChou3 *Combination Booklet
*UIConstraints: *PageSize EnvChou3 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvChou3 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvChou3 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvChou3 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvChou3 *Staple 2Staples
*UIConstraints: *PageSize EnvChou3 *Punch 2holes
*UIConstraints: *PageSize EnvChou3 *Punch 3holes
*UIConstraints: *PageSize EnvChou3 *Punch 4holes
*UIConstraints: *PageSize EnvChou3 *Fold Stitch
*UIConstraints: *PageSize EnvChou3 *Fold HalfFold
*UIConstraints: *PageSize EnvChou3 *Fold TriFold
*UIConstraints: *PageSize EnvChou3 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvChou4 *Offset True
*UIConstraints: *PageSize EnvChou4 *InputSlot Tray2
*UIConstraints: *PageSize EnvChou4 *InputSlot Tray3
*UIConstraints: *PageSize EnvChou4 *InputSlot Tray4
*UIConstraints: *PageSize EnvChou4 *InputSlot LCT
*UIConstraints: *PageSize EnvChou4 *MediaType Thin
*UIConstraints: *PageSize EnvChou4 *MediaType Transparency
*UIConstraints: *PageSize EnvChou4 *MediaType TAB
*UIConstraints: *PageSize EnvChou4 *MediaType Letterhead
*UIConstraints: *PageSize EnvChou4 *KMDuplex 2Sided
*UIConstraints: *PageSize EnvChou4 *Combination Booklet
*UIConstraints: *PageSize EnvChou4 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvChou4 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvChou4 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvChou4 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvChou4 *Staple 2Staples
*UIConstraints: *PageSize EnvChou4 *Punch 2holes
*UIConstraints: *PageSize EnvChou4 *Punch 3holes
*UIConstraints: *PageSize EnvChou4 *Punch 4holes
*UIConstraints: *PageSize EnvChou4 *Fold Stitch
*UIConstraints: *PageSize EnvChou4 *Fold HalfFold
*UIConstraints: *PageSize EnvChou4 *Fold TriFold
*UIConstraints: *PageSize EnvChou4 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvYou3 *Offset True
*UIConstraints: *PageSize EnvYou3 *InputSlot Tray2
*UIConstraints: *PageSize EnvYou3 *InputSlot Tray3
*UIConstraints: *PageSize EnvYou3 *InputSlot Tray4
*UIConstraints: *PageSize EnvYou3 *InputSlot LCT
*UIConstraints: *PageSize EnvYou3 *MediaType Thin
*UIConstraints: *PageSize EnvYou3 *MediaType Transparency
*UIConstraints: *PageSize EnvYou3 *MediaType TAB
*UIConstraints: *PageSize EnvYou3 *MediaType Letterhead
*UIConstraints: *PageSize EnvYou3 *KMDuplex 2Sided
*UIConstraints: *PageSize EnvYou3 *Combination Booklet
*UIConstraints: *PageSize EnvYou3 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvYou3 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvYou3 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvYou3 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvYou3 *Staple 2Staples
*UIConstraints: *PageSize EnvYou3 *Punch 2holes
*UIConstraints: *PageSize EnvYou3 *Punch 3holes
*UIConstraints: *PageSize EnvYou3 *Punch 4holes
*UIConstraints: *PageSize EnvYou3 *Fold Stitch
*UIConstraints: *PageSize EnvYou3 *Fold HalfFold
*UIConstraints: *PageSize EnvYou3 *Fold TriFold
*UIConstraints: *PageSize EnvYou3 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvYou4 *Offset True
*UIConstraints: *PageSize EnvYou4 *InputSlot Tray2
*UIConstraints: *PageSize EnvYou4 *InputSlot Tray3
*UIConstraints: *PageSize EnvYou4 *InputSlot Tray4
*UIConstraints: *PageSize EnvYou4 *InputSlot LCT
*UIConstraints: *PageSize EnvYou4 *MediaType Thin
*UIConstraints: *PageSize EnvYou4 *MediaType Transparency
*UIConstraints: *PageSize EnvYou4 *MediaType TAB
*UIConstraints: *PageSize EnvYou4 *Combination Booklet
*UIConstraints: *PageSize EnvYou4 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvYou4 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvYou4 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvYou4 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvYou4 *Staple 2Staples
*UIConstraints: *PageSize EnvYou4 *Punch 2holes
*UIConstraints: *PageSize EnvYou4 *Punch 3holes
*UIConstraints: *PageSize EnvYou4 *Punch 4holes
*UIConstraints: *PageSize EnvYou4 *Fold Stitch
*UIConstraints: *PageSize EnvYou4 *Fold HalfFold
*UIConstraints: *PageSize EnvYou4 *Fold TriFold
*UIConstraints: *PageSize EnvYou4 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvKaku1 *Offset True
*UIConstraints: *PageSize EnvKaku1 *InputSlot Tray2
*UIConstraints: *PageSize EnvKaku1 *InputSlot Tray3
*UIConstraints: *PageSize EnvKaku1 *InputSlot Tray4
*UIConstraints: *PageSize EnvKaku1 *InputSlot LCT
*UIConstraints: *PageSize EnvKaku1 *MediaType Thin
*UIConstraints: *PageSize EnvKaku1 *MediaType Transparency
*UIConstraints: *PageSize EnvKaku1 *MediaType TAB
*UIConstraints: *PageSize EnvKaku1 *Combination Booklet
*UIConstraints: *PageSize EnvKaku1 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvKaku1 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvKaku1 *Punch 2holes
*UIConstraints: *PageSize EnvKaku1 *Punch 3holes
*UIConstraints: *PageSize EnvKaku1 *Punch 4holes
*UIConstraints: *PageSize EnvKaku1 *Fold TriFold
*UIConstraints: *PageSize EnvKaku1 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvKaku1 *Model C4051i
*UIConstraints: *PageSize EnvKaku1 *Model C3351i
*UIConstraints: *PageSize EnvKaku1 *Model C4001i
*UIConstraints: *PageSize EnvKaku1 *Model C3301i
*UIConstraints: *PageSize EnvKaku1 *Model C3321i
*UIConstraints: *PageSize EnvKaku1 *Model C4050i
*UIConstraints: *PageSize EnvKaku1 *Model C3350i
*UIConstraints: *PageSize EnvKaku1 *Model C4000i
*UIConstraints: *PageSize EnvKaku1 *Model C3300i
*UIConstraints: *PageSize EnvKaku1 *Model C3320i
*UIConstraints: *PageSize EnvKaku2 *Offset True
*UIConstraints: *PageSize EnvKaku2 *InputSlot Tray2
*UIConstraints: *PageSize EnvKaku2 *InputSlot Tray3
*UIConstraints: *PageSize EnvKaku2 *InputSlot Tray4
*UIConstraints: *PageSize EnvKaku2 *InputSlot LCT
*UIConstraints: *PageSize EnvKaku2 *MediaType Thin
*UIConstraints: *PageSize EnvKaku2 *MediaType Transparency
*UIConstraints: *PageSize EnvKaku2 *MediaType TAB
*UIConstraints: *PageSize EnvKaku2 *Combination Booklet
*UIConstraints: *PageSize EnvKaku2 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvKaku2 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvKaku2 *Punch 2holes
*UIConstraints: *PageSize EnvKaku2 *Punch 3holes
*UIConstraints: *PageSize EnvKaku2 *Punch 4holes
*UIConstraints: *PageSize EnvKaku2 *Fold TriFold
*UIConstraints: *PageSize EnvKaku2 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvKaku2 *Model C4051i
*UIConstraints: *PageSize EnvKaku2 *Model C3351i
*UIConstraints: *PageSize EnvKaku2 *Model C4001i
*UIConstraints: *PageSize EnvKaku2 *Model C3301i
*UIConstraints: *PageSize EnvKaku2 *Model C3321i
*UIConstraints: *PageSize EnvKaku2 *Model C4050i
*UIConstraints: *PageSize EnvKaku2 *Model C3350i
*UIConstraints: *PageSize EnvKaku2 *Model C4000i
*UIConstraints: *PageSize EnvKaku2 *Model C3300i
*UIConstraints: *PageSize EnvKaku2 *Model C3320i
*UIConstraints: *PageSize EnvKaku3 *Offset True
*UIConstraints: *PageSize EnvKaku3 *InputSlot Tray2
*UIConstraints: *PageSize EnvKaku3 *InputSlot Tray3
*UIConstraints: *PageSize EnvKaku3 *InputSlot Tray4
*UIConstraints: *PageSize EnvKaku3 *InputSlot LCT
*UIConstraints: *PageSize EnvKaku3 *MediaType Thin
*UIConstraints: *PageSize EnvKaku3 *MediaType Transparency
*UIConstraints: *PageSize EnvKaku3 *MediaType TAB
*UIConstraints: *PageSize EnvKaku3 *Combination Booklet
*UIConstraints: *PageSize EnvKaku3 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvKaku3 *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvKaku3 *Punch 2holes
*UIConstraints: *PageSize EnvKaku3 *Punch 3holes
*UIConstraints: *PageSize EnvKaku3 *Punch 4holes
*UIConstraints: *PageSize EnvKaku3 *Fold Stitch
*UIConstraints: *PageSize EnvKaku3 *Fold HalfFold
*UIConstraints: *PageSize EnvKaku3 *Fold TriFold
*UIConstraints: *PageSize EnvKaku3 *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvKaku3 *Model C4051i
*UIConstraints: *PageSize EnvKaku3 *Model C3351i
*UIConstraints: *PageSize EnvKaku3 *Model C4001i
*UIConstraints: *PageSize EnvKaku3 *Model C3301i
*UIConstraints: *PageSize EnvKaku3 *Model C3321i
*UIConstraints: *PageSize EnvKaku3 *Model C4050i
*UIConstraints: *PageSize EnvKaku3 *Model C3350i
*UIConstraints: *PageSize EnvKaku3 *Model C4000i
*UIConstraints: *PageSize EnvKaku3 *Model C3300i
*UIConstraints: *PageSize EnvKaku3 *Model C3320i
*UIConstraints: *PageSize EnvDL *Offset True
*UIConstraints: *PageSize EnvDL *InputSlot Tray2
*UIConstraints: *PageSize EnvDL *InputSlot Tray3
*UIConstraints: *PageSize EnvDL *InputSlot Tray4
*UIConstraints: *PageSize EnvDL *InputSlot LCT
*UIConstraints: *PageSize EnvDL *MediaType Thin
*UIConstraints: *PageSize EnvDL *MediaType Transparency
*UIConstraints: *PageSize EnvDL *MediaType TAB
*UIConstraints: *PageSize EnvDL *Combination Booklet
*UIConstraints: *PageSize EnvDL *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvDL *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvDL *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvDL *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvDL *Staple 2Staples
*UIConstraints: *PageSize EnvDL *Punch 2holes
*UIConstraints: *PageSize EnvDL *Punch 3holes
*UIConstraints: *PageSize EnvDL *Punch 4holes
*UIConstraints: *PageSize EnvDL *Fold Stitch
*UIConstraints: *PageSize EnvDL *Fold HalfFold
*UIConstraints: *PageSize EnvDL *Fold TriFold
*UIConstraints: *PageSize EnvDL *TransparencyInterleave Blank
*UIConstraints: *PageSize EnvMonarch *Offset True
*UIConstraints: *PageSize EnvMonarch *InputSlot Tray2
*UIConstraints: *PageSize EnvMonarch *InputSlot Tray3
*UIConstraints: *PageSize EnvMonarch *InputSlot Tray4
*UIConstraints: *PageSize EnvMonarch *InputSlot LCT
*UIConstraints: *PageSize EnvMonarch *MediaType Thin
*UIConstraints: *PageSize EnvMonarch *MediaType Transparency
*UIConstraints: *PageSize EnvMonarch *MediaType TAB
*UIConstraints: *PageSize EnvMonarch *MediaType Letterhead
*UIConstraints: *PageSize EnvMonarch *KMDuplex 2Sided
*UIConstraints: *PageSize EnvMonarch *Combination Booklet
*UIConstraints: *PageSize EnvMonarch *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize EnvMonarch *Staple 1StapleZeroLeft
*UIConstraints: *PageSize EnvMonarch *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize EnvMonarch *Staple 1StapleZeroRight
*UIConstraints: *PageSize EnvMonarch *Staple 2Staples
*UIConstraints: *PageSize EnvMonarch *Punch 2holes
*UIConstraints: *PageSize EnvMonarch *Punch 3holes
*UIConstraints: *PageSize EnvMonarch *Punch 4holes
*UIConstraints: *PageSize EnvMonarch *Fold Stitch
*UIConstraints: *PageSize EnvMonarch *Fold HalfFold
*UIConstraints: *PageSize EnvMonarch *Fold TriFold
*UIConstraints: *PageSize EnvMonarch *TransparencyInterleave Blank
*UIConstraints: *PageSize Env10 *Offset True
*UIConstraints: *PageSize Env10 *InputSlot Tray2
*UIConstraints: *PageSize Env10 *InputSlot Tray3
*UIConstraints: *PageSize Env10 *InputSlot Tray4
*UIConstraints: *PageSize Env10 *InputSlot LCT
*UIConstraints: *PageSize Env10 *MediaType Thin
*UIConstraints: *PageSize Env10 *MediaType Transparency
*UIConstraints: *PageSize Env10 *MediaType TAB
*UIConstraints: *PageSize Env10 *Combination Booklet
*UIConstraints: *PageSize Env10 *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize Env10 *Staple 1StapleZeroLeft
*UIConstraints: *PageSize Env10 *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize Env10 *Staple 1StapleZeroRight
*UIConstraints: *PageSize Env10 *Staple 2Staples
*UIConstraints: *PageSize Env10 *Punch 2holes
*UIConstraints: *PageSize Env10 *Punch 3holes
*UIConstraints: *PageSize Env10 *Punch 4holes
*UIConstraints: *PageSize Env10 *Fold Stitch
*UIConstraints: *PageSize Env10 *Fold HalfFold
*UIConstraints: *PageSize Env10 *Fold TriFold
*UIConstraints: *PageSize Env10 *TransparencyInterleave Blank
*UIConstraints: *PageSize JapanesePostCard *Offset True
*UIConstraints: *PageSize JapanesePostCard *InputSlot Tray2
*UIConstraints: *PageSize JapanesePostCard *InputSlot Tray3
*UIConstraints: *PageSize JapanesePostCard *InputSlot Tray4
*UIConstraints: *PageSize JapanesePostCard *InputSlot LCT
*UIConstraints: *PageSize JapanesePostCard *MediaType Thin
*UIConstraints: *PageSize JapanesePostCard *MediaType Envelope
*UIConstraints: *PageSize JapanesePostCard *MediaType Transparency
*UIConstraints: *PageSize JapanesePostCard *MediaType TAB
*UIConstraints: *PageSize JapanesePostCard *Combination Booklet
*UIConstraints: *PageSize JapanesePostCard *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize JapanesePostCard *Staple 1StapleZeroLeft
*UIConstraints: *PageSize JapanesePostCard *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize JapanesePostCard *Staple 1StapleZeroRight
*UIConstraints: *PageSize JapanesePostCard *Staple 2Staples
*UIConstraints: *PageSize JapanesePostCard *Punch 2holes
*UIConstraints: *PageSize JapanesePostCard *Punch 3holes
*UIConstraints: *PageSize JapanesePostCard *Punch 4holes
*UIConstraints: *PageSize JapanesePostCard *Fold Stitch
*UIConstraints: *PageSize JapanesePostCard *Fold HalfFold
*UIConstraints: *PageSize JapanesePostCard *Fold TriFold
*UIConstraints: *PageSize JapanesePostCard *TransparencyInterleave Blank
*UIConstraints: *PageSize 4x6_PostCard *Offset True
*UIConstraints: *PageSize 4x6_PostCard *InputSlot Tray2
*UIConstraints: *PageSize 4x6_PostCard *InputSlot Tray3
*UIConstraints: *PageSize 4x6_PostCard *InputSlot Tray4
*UIConstraints: *PageSize 4x6_PostCard *InputSlot LCT
*UIConstraints: *PageSize 4x6_PostCard *MediaType Thin
*UIConstraints: *PageSize 4x6_PostCard *MediaType Envelope
*UIConstraints: *PageSize 4x6_PostCard *MediaType Transparency
*UIConstraints: *PageSize 4x6_PostCard *MediaType TAB
*UIConstraints: *PageSize 4x6_PostCard *Combination Booklet
*UIConstraints: *PageSize 4x6_PostCard *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize 4x6_PostCard *Staple 1StapleZeroLeft
*UIConstraints: *PageSize 4x6_PostCard *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize 4x6_PostCard *Staple 1StapleZeroRight
*UIConstraints: *PageSize 4x6_PostCard *Staple 2Staples
*UIConstraints: *PageSize 4x6_PostCard *Punch 2holes
*UIConstraints: *PageSize 4x6_PostCard *Punch 3holes
*UIConstraints: *PageSize 4x6_PostCard *Punch 4holes
*UIConstraints: *PageSize 4x6_PostCard *Fold Stitch
*UIConstraints: *PageSize 4x6_PostCard *Fold HalfFold
*UIConstraints: *PageSize 4x6_PostCard *Fold TriFold
*UIConstraints: *PageSize 4x6_PostCard *TransparencyInterleave Blank
*UIConstraints: *PageSize DoublePostcardRotated *InputSlot Tray2
*UIConstraints: *PageSize DoublePostcardRotated *InputSlot Tray3
*UIConstraints: *PageSize DoublePostcardRotated *InputSlot Tray4
*UIConstraints: *PageSize DoublePostcardRotated *KMDuplex 2Sided
*UIConstraints: *PageSize DoublePostcardRotated *Combination Booklet
*UIConstraints: *PageSize DoublePostcardRotated *Model C751i
*UIConstraints: *PageSize DoublePostcardRotated *Model C651i
*UIConstraints: *PageSize DoublePostcardRotated *Model C551i
*UIConstraints: *PageSize DoublePostcardRotated *Model C451i
*UIConstraints: *PageSize DoublePostcardRotated *Model C361i
*UIConstraints: *PageSize DoublePostcardRotated *Model C301i
*UIConstraints: *PageSize DoublePostcardRotated *Model C251i
*UIConstraints: *PageSize DoublePostcardRotated *Model C750i
*UIConstraints: *PageSize DoublePostcardRotated *Model C650i
*UIConstraints: *PageSize DoublePostcardRotated *Model C550i
*UIConstraints: *PageSize DoublePostcardRotated *Model C450i
*UIConstraints: *PageSize DoublePostcardRotated *Model C360i
*UIConstraints: *PageSize DoublePostcardRotated *Model C300i
*UIConstraints: *PageSize DoublePostcardRotated *Model C250i
*UIConstraints: *PageSize DoublePostcardRotated *Model C287i
*UIConstraints: *PageSize DoublePostcardRotated *Model C257i
*UIConstraints: *PageSize DoublePostcardRotated *Model C227i
*UIConstraints: *PageSize DoublePostcardRotated *Model C286i
*UIConstraints: *PageSize DoublePostcardRotated *Model C266i
*UIConstraints: *PageSize DoublePostcardRotated *Model C226i
*UIConstraints: *PageSize A3Extra *InputSlot LCT
*UIConstraints: *PageSize A3Extra *MediaType Envelope
*UIConstraints: *PageSize A3Extra *MediaType TAB
*UIConstraints: *PageSize A3Extra *OutputBin Tray4
*UIConstraints: *PageSize A3Extra *Combination Booklet
*UIConstraints: *PageSize A3Extra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize A3Extra *Staple 1StapleZeroRight
*UIConstraints: *PageSize A3Extra *Punch 2holes
*UIConstraints: *PageSize A3Extra *Punch 3holes
*UIConstraints: *PageSize A3Extra *Punch 4holes
*UIConstraints: *PageSize A3Extra *Fold TriFold
*UIConstraints: *PageSize A3Extra *Model C4051i
*UIConstraints: *PageSize A3Extra *Model C3351i
*UIConstraints: *PageSize A3Extra *Model C4001i
*UIConstraints: *PageSize A3Extra *Model C3301i
*UIConstraints: *PageSize A3Extra *Model C3321i
*UIConstraints: *PageSize A3Extra *Model C287i
*UIConstraints: *PageSize A3Extra *Model C257i
*UIConstraints: *PageSize A3Extra *Model C227i
*UIConstraints: *PageSize A3Extra *Model C286i
*UIConstraints: *PageSize A3Extra *Model C266i
*UIConstraints: *PageSize A3Extra *Model C226i
*UIConstraints: *PageSize A3Extra *Model C4050i
*UIConstraints: *PageSize A3Extra *Model C3350i
*UIConstraints: *PageSize A3Extra *Model C4000i
*UIConstraints: *PageSize A3Extra *Model C3300i
*UIConstraints: *PageSize A3Extra *Model C3320i
*UIConstraints: *PageSize A4Extra *InputSlot LCT
*UIConstraints: *PageSize A4Extra *MediaType Envelope
*UIConstraints: *PageSize A4Extra *MediaType TAB
*UIConstraints: *PageSize A4Extra *OutputBin Tray4
*UIConstraints: *PageSize A4Extra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize A4Extra *Staple 1StapleZeroRight
*UIConstraints: *PageSize A4Extra *Punch 2holes
*UIConstraints: *PageSize A4Extra *Punch 3holes
*UIConstraints: *PageSize A4Extra *Punch 4holes
*UIConstraints: *PageSize A4Extra *Fold TriFold
*UIConstraints: *PageSize A4Extra *Model C4051i
*UIConstraints: *PageSize A4Extra *Model C3351i
*UIConstraints: *PageSize A4Extra *Model C4001i
*UIConstraints: *PageSize A4Extra *Model C3301i
*UIConstraints: *PageSize A4Extra *Model C3321i
*UIConstraints: *PageSize A4Extra *Model C4050i
*UIConstraints: *PageSize A4Extra *Model C3350i
*UIConstraints: *PageSize A4Extra *Model C4000i
*UIConstraints: *PageSize A4Extra *Model C3300i
*UIConstraints: *PageSize A4Extra *Model C3320i
*UIConstraints: *PageSize A5Extra *InputSlot LCT
*UIConstraints: *PageSize A5Extra *MediaType Envelope
*UIConstraints: *PageSize A5Extra *MediaType TAB
*UIConstraints: *PageSize A5Extra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize A5Extra *Staple 1StapleZeroRight
*UIConstraints: *PageSize A5Extra *Punch 2holes
*UIConstraints: *PageSize A5Extra *Punch 3holes
*UIConstraints: *PageSize A5Extra *Punch 4holes
*UIConstraints: *PageSize A5Extra *Fold TriFold
*UIConstraints: *PageSize A5Extra *Model C4051i
*UIConstraints: *PageSize A5Extra *Model C3351i
*UIConstraints: *PageSize A5Extra *Model C4001i
*UIConstraints: *PageSize A5Extra *Model C3301i
*UIConstraints: *PageSize A5Extra *Model C3321i
*UIConstraints: *PageSize A5Extra *Model C4050i
*UIConstraints: *PageSize A5Extra *Model C3350i
*UIConstraints: *PageSize A5Extra *Model C4000i
*UIConstraints: *PageSize A5Extra *Model C3300i
*UIConstraints: *PageSize A5Extra *Model C3320i
*UIConstraints: *PageSize B4Extra *InputSlot LCT
*UIConstraints: *PageSize B4Extra *MediaType Envelope
*UIConstraints: *PageSize B4Extra *MediaType TAB
*UIConstraints: *PageSize B4Extra *OutputBin Tray4
*UIConstraints: *PageSize B4Extra *Combination Booklet
*UIConstraints: *PageSize B4Extra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize B4Extra *Staple 1StapleZeroRight
*UIConstraints: *PageSize B4Extra *Punch 2holes
*UIConstraints: *PageSize B4Extra *Punch 3holes
*UIConstraints: *PageSize B4Extra *Punch 4holes
*UIConstraints: *PageSize B4Extra *Fold TriFold
*UIConstraints: *PageSize B4Extra *Model C4051i
*UIConstraints: *PageSize B4Extra *Model C3351i
*UIConstraints: *PageSize B4Extra *Model C4001i
*UIConstraints: *PageSize B4Extra *Model C3301i
*UIConstraints: *PageSize B4Extra *Model C3321i
*UIConstraints: *PageSize B4Extra *Model C4050i
*UIConstraints: *PageSize B4Extra *Model C3350i
*UIConstraints: *PageSize B4Extra *Model C4000i
*UIConstraints: *PageSize B4Extra *Model C3300i
*UIConstraints: *PageSize B4Extra *Model C3320i
*UIConstraints: *PageSize B5Extra *InputSlot LCT
*UIConstraints: *PageSize B5Extra *MediaType Envelope
*UIConstraints: *PageSize B5Extra *MediaType TAB
*UIConstraints: *PageSize B5Extra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize B5Extra *Staple 1StapleZeroRight
*UIConstraints: *PageSize B5Extra *Punch 2holes
*UIConstraints: *PageSize B5Extra *Punch 3holes
*UIConstraints: *PageSize B5Extra *Punch 4holes
*UIConstraints: *PageSize B5Extra *Fold TriFold
*UIConstraints: *PageSize B5Extra *Model C4051i
*UIConstraints: *PageSize B5Extra *Model C3351i
*UIConstraints: *PageSize B5Extra *Model C4001i
*UIConstraints: *PageSize B5Extra *Model C3301i
*UIConstraints: *PageSize B5Extra *Model C3321i
*UIConstraints: *PageSize B5Extra *Model C4050i
*UIConstraints: *PageSize B5Extra *Model C3350i
*UIConstraints: *PageSize B5Extra *Model C4000i
*UIConstraints: *PageSize B5Extra *Model C3300i
*UIConstraints: *PageSize B5Extra *Model C3320i
*UIConstraints: *PageSize TabloidExtra *InputSlot LCT
*UIConstraints: *PageSize TabloidExtra *MediaType Envelope
*UIConstraints: *PageSize TabloidExtra *MediaType TAB
*UIConstraints: *PageSize TabloidExtra *OutputBin Tray4
*UIConstraints: *PageSize TabloidExtra *Combination Booklet
*UIConstraints: *PageSize TabloidExtra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize TabloidExtra *Staple 1StapleZeroRight
*UIConstraints: *PageSize TabloidExtra *Punch 2holes
*UIConstraints: *PageSize TabloidExtra *Punch 3holes
*UIConstraints: *PageSize TabloidExtra *Punch 4holes
*UIConstraints: *PageSize TabloidExtra *Fold TriFold
*UIConstraints: *PageSize TabloidExtra *Model C4051i
*UIConstraints: *PageSize TabloidExtra *Model C3351i
*UIConstraints: *PageSize TabloidExtra *Model C4001i
*UIConstraints: *PageSize TabloidExtra *Model C3301i
*UIConstraints: *PageSize TabloidExtra *Model C3321i
*UIConstraints: *PageSize TabloidExtra *Model C287i
*UIConstraints: *PageSize TabloidExtra *Model C257i
*UIConstraints: *PageSize TabloidExtra *Model C227i
*UIConstraints: *PageSize TabloidExtra *Model C286i
*UIConstraints: *PageSize TabloidExtra *Model C266i
*UIConstraints: *PageSize TabloidExtra *Model C226i
*UIConstraints: *PageSize TabloidExtra *Model C4050i
*UIConstraints: *PageSize TabloidExtra *Model C3350i
*UIConstraints: *PageSize TabloidExtra *Model C4000i
*UIConstraints: *PageSize TabloidExtra *Model C3300i
*UIConstraints: *PageSize TabloidExtra *Model C3320i
*UIConstraints: *PageSize LetterExtra *InputSlot LCT
*UIConstraints: *PageSize LetterExtra *MediaType Envelope
*UIConstraints: *PageSize LetterExtra *MediaType TAB
*UIConstraints: *PageSize LetterExtra *OutputBin Tray4
*UIConstraints: *PageSize LetterExtra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize LetterExtra *Staple 1StapleZeroRight
*UIConstraints: *PageSize LetterExtra *Punch 2holes
*UIConstraints: *PageSize LetterExtra *Punch 3holes
*UIConstraints: *PageSize LetterExtra *Punch 4holes
*UIConstraints: *PageSize LetterExtra *Fold TriFold
*UIConstraints: *PageSize LetterExtra *Model C4051i
*UIConstraints: *PageSize LetterExtra *Model C3351i
*UIConstraints: *PageSize LetterExtra *Model C4001i
*UIConstraints: *PageSize LetterExtra *Model C3301i
*UIConstraints: *PageSize LetterExtra *Model C3321i
*UIConstraints: *PageSize LetterExtra *Model C4050i
*UIConstraints: *PageSize LetterExtra *Model C3350i
*UIConstraints: *PageSize LetterExtra *Model C4000i
*UIConstraints: *PageSize LetterExtra *Model C3300i
*UIConstraints: *PageSize LetterExtra *Model C3320i
*UIConstraints: *PageSize StatementExtra *InputSlot LCT
*UIConstraints: *PageSize StatementExtra *MediaType Envelope
*UIConstraints: *PageSize StatementExtra *MediaType TAB
*UIConstraints: *PageSize StatementExtra *Staple 1StapleZeroLeft
*UIConstraints: *PageSize StatementExtra *Staple 1StapleZeroRight
*UIConstraints: *PageSize StatementExtra *Punch 2holes
*UIConstraints: *PageSize StatementExtra *Punch 3holes
*UIConstraints: *PageSize StatementExtra *Punch 4holes
*UIConstraints: *PageSize StatementExtra *Fold TriFold
*UIConstraints: *PageSize StatementExtra *Model C4051i
*UIConstraints: *PageSize StatementExtra *Model C3351i
*UIConstraints: *PageSize StatementExtra *Model C4001i
*UIConstraints: *PageSize StatementExtra *Model C3301i
*UIConstraints: *PageSize StatementExtra *Model C3321i
*UIConstraints: *PageSize StatementExtra *Model C4050i
*UIConstraints: *PageSize StatementExtra *Model C3350i
*UIConstraints: *PageSize StatementExtra *Model C4000i
*UIConstraints: *PageSize StatementExtra *Model C3300i
*UIConstraints: *PageSize StatementExtra *Model C3320i
*UIConstraints: *PageSize LetterTab-F *Offset True
*UIConstraints: *PageSize LetterTab-F *InputSlot Tray1
*UIConstraints: *PageSize LetterTab-F *InputSlot Tray2
*UIConstraints: *PageSize LetterTab-F *InputSlot Tray3
*UIConstraints: *PageSize LetterTab-F *InputSlot Tray4
*UIConstraints: *PageSize LetterTab-F *InputSlot LCT
*UIConstraints: *PageSize LetterTab-F *MediaType Plain
*UIConstraints: *PageSize LetterTab-F *MediaType Plain(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType PlainPlus
*UIConstraints: *PageSize LetterTab-F *MediaType PlainPlus(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType Thick1
*UIConstraints: *PageSize LetterTab-F *MediaType Thick1(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType Thick1Plus
*UIConstraints: *PageSize LetterTab-F *MediaType Thick1Plus(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType Thick2
*UIConstraints: *PageSize LetterTab-F *MediaType Thick2(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType Thick3
*UIConstraints: *PageSize LetterTab-F *MediaType Thick3(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType Thick4
*UIConstraints: *PageSize LetterTab-F *MediaType Thick4(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType Thin
*UIConstraints: *PageSize LetterTab-F *MediaType Envelope
*UIConstraints: *PageSize LetterTab-F *MediaType Transparency
*UIConstraints: *PageSize LetterTab-F *MediaType Color
*UIConstraints: *PageSize LetterTab-F *MediaType SingleSidedOnly
*UIConstraints: *PageSize LetterTab-F *MediaType Letterhead
*UIConstraints: *PageSize LetterTab-F *MediaType Special
*UIConstraints: *PageSize LetterTab-F *MediaType Recycled
*UIConstraints: *PageSize LetterTab-F *MediaType Recycled(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User1
*UIConstraints: *PageSize LetterTab-F *MediaType User1(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User2_1
*UIConstraints: *PageSize LetterTab-F *MediaType User2(2nd)_1
*UIConstraints: *PageSize LetterTab-F *MediaType User2
*UIConstraints: *PageSize LetterTab-F *MediaType User2(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User3
*UIConstraints: *PageSize LetterTab-F *MediaType User3(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User4
*UIConstraints: *PageSize LetterTab-F *MediaType User4(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User5
*UIConstraints: *PageSize LetterTab-F *MediaType User5(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User6
*UIConstraints: *PageSize LetterTab-F *MediaType User6(2nd)
*UIConstraints: *PageSize LetterTab-F *MediaType User7
*UIConstraints: *PageSize LetterTab-F *MediaType User7(2nd)
*UIConstraints: *PageSize LetterTab-F *Binding TopBinding
*UIConstraints: *PageSize LetterTab-F *Binding RightBinding
*UIConstraints: *PageSize LetterTab-F *KMDuplex 2Sided
*UIConstraints: *PageSize LetterTab-F *Combination Booklet
*UIConstraints: *PageSize LetterTab-F *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize LetterTab-F *Staple 1StapleZeroLeft
*UIConstraints: *PageSize LetterTab-F *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize LetterTab-F *Staple 1StapleZeroRight
*UIConstraints: *PageSize LetterTab-F *Staple 2Staples
*UIConstraints: *PageSize LetterTab-F *Punch 2holes
*UIConstraints: *PageSize LetterTab-F *Punch 3holes
*UIConstraints: *PageSize LetterTab-F *Punch 4holes
*UIConstraints: *PageSize LetterTab-F *Fold Stitch
*UIConstraints: *PageSize LetterTab-F *Fold HalfFold
*UIConstraints: *PageSize LetterTab-F *Fold TriFold
*UIConstraints: *PageSize LetterTab-F *TransparencyInterleave Blank
*UIConstraints: *PageSize LetterTab-F *Model C4051i
*UIConstraints: *PageSize LetterTab-F *Model C3351i
*UIConstraints: *PageSize LetterTab-F *Model C4001i
*UIConstraints: *PageSize LetterTab-F *Model C3301i
*UIConstraints: *PageSize LetterTab-F *Model C3321i
*UIConstraints: *PageSize LetterTab-F *Model C4050i
*UIConstraints: *PageSize LetterTab-F *Model C3350i
*UIConstraints: *PageSize LetterTab-F *Model C4000i
*UIConstraints: *PageSize LetterTab-F *Model C3300i
*UIConstraints: *PageSize LetterTab-F *Model C3320i
*UIConstraints: *PageSize A4Tab-F *Offset True
*UIConstraints: *PageSize A4Tab-F *InputSlot Tray1
*UIConstraints: *PageSize A4Tab-F *InputSlot Tray2
*UIConstraints: *PageSize A4Tab-F *InputSlot Tray3
*UIConstraints: *PageSize A4Tab-F *InputSlot Tray4
*UIConstraints: *PageSize A4Tab-F *InputSlot LCT
*UIConstraints: *PageSize A4Tab-F *MediaType Plain
*UIConstraints: *PageSize A4Tab-F *MediaType Plain(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType PlainPlus
*UIConstraints: *PageSize A4Tab-F *MediaType PlainPlus(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType Thick1
*UIConstraints: *PageSize A4Tab-F *MediaType Thick1(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType Thick1Plus
*UIConstraints: *PageSize A4Tab-F *MediaType Thick1Plus(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType Thick2
*UIConstraints: *PageSize A4Tab-F *MediaType Thick2(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType Thick3
*UIConstraints: *PageSize A4Tab-F *MediaType Thick3(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType Thick4
*UIConstraints: *PageSize A4Tab-F *MediaType Thick4(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType Thin
*UIConstraints: *PageSize A4Tab-F *MediaType Envelope
*UIConstraints: *PageSize A4Tab-F *MediaType Transparency
*UIConstraints: *PageSize A4Tab-F *MediaType Color
*UIConstraints: *PageSize A4Tab-F *MediaType SingleSidedOnly
*UIConstraints: *PageSize A4Tab-F *MediaType Letterhead
*UIConstraints: *PageSize A4Tab-F *MediaType Special
*UIConstraints: *PageSize A4Tab-F *MediaType Recycled
*UIConstraints: *PageSize A4Tab-F *MediaType Recycled(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User1
*UIConstraints: *PageSize A4Tab-F *MediaType User1(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User2_1
*UIConstraints: *PageSize A4Tab-F *MediaType User2(2nd)_1
*UIConstraints: *PageSize A4Tab-F *MediaType User2
*UIConstraints: *PageSize A4Tab-F *MediaType User2(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User3
*UIConstraints: *PageSize A4Tab-F *MediaType User3(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User4
*UIConstraints: *PageSize A4Tab-F *MediaType User4(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User5
*UIConstraints: *PageSize A4Tab-F *MediaType User5(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User6
*UIConstraints: *PageSize A4Tab-F *MediaType User6(2nd)
*UIConstraints: *PageSize A4Tab-F *MediaType User7
*UIConstraints: *PageSize A4Tab-F *MediaType User7(2nd)
*UIConstraints: *PageSize A4Tab-F *Binding TopBinding
*UIConstraints: *PageSize A4Tab-F *Binding RightBinding
*UIConstraints: *PageSize A4Tab-F *KMDuplex 2Sided
*UIConstraints: *PageSize A4Tab-F *Combination Booklet
*UIConstraints: *PageSize A4Tab-F *Staple 1StapleAuto(Left)
*UIConstraints: *PageSize A4Tab-F *Staple 1StapleZeroLeft
*UIConstraints: *PageSize A4Tab-F *Staple 1StapleAuto(Right)
*UIConstraints: *PageSize A4Tab-F *Staple 1StapleZeroRight
*UIConstraints: *PageSize A4Tab-F *Staple 2Staples
*UIConstraints: *PageSize A4Tab-F *Punch 2holes
*UIConstraints: *PageSize A4Tab-F *Punch 3holes
*UIConstraints: *PageSize A4Tab-F *Punch 4holes
*UIConstraints: *PageSize A4Tab-F *Fold Stitch
*UIConstraints: *PageSize A4Tab-F *Fold HalfFold
*UIConstraints: *PageSize A4Tab-F *Fold TriFold
*UIConstraints: *PageSize A4Tab-F *TransparencyInterleave Blank
*UIConstraints: *PageSize A4Tab-F *Model C4051i
*UIConstraints: *PageSize A4Tab-F *Model C3351i
*UIConstraints: *PageSize A4Tab-F *Model C4001i
*UIConstraints: *PageSize A4Tab-F *Model C3301i
*UIConstraints: *PageSize A4Tab-F *Model C3321i
*UIConstraints: *PageSize A4Tab-F *Model C4050i
*UIConstraints: *PageSize A4Tab-F *Model C3350i
*UIConstraints: *PageSize A4Tab-F *Model C4000i
*UIConstraints: *PageSize A4Tab-F *Model C3300i
*UIConstraints: *PageSize A4Tab-F *Model C3320i
*UIConstraints: *OutputBin Tray1 *Fold Stitch
*UIConstraints: *OutputBin Tray1 *Fold HalfFold
*UIConstraints: *OutputBin Tray1 *Fold TriFold
*UIConstraints: *OutputBin Tray1 *Fold ZFold1
*UIConstraints: *OutputBin Tray1 *Fold ZFold2
*UIConstraints: *OutputBin Tray1 *PIFrontCover PITray1
*UIConstraints: *OutputBin Tray1 *PIFrontCover PITray2
*UIConstraints: *OutputBin Tray1 *PIBackCover PITray1
*UIConstraints: *OutputBin Tray1 *PIBackCover PITray2
*UIConstraints: *OutputBin Tray1 *Finisher None
*UIConstraints: *OutputBin Tray1 *Model C4051i
*UIConstraints: *OutputBin Tray1 *Model C3351i
*UIConstraints: *OutputBin Tray1 *Model C4001i
*UIConstraints: *OutputBin Tray1 *Model C3301i
*UIConstraints: *OutputBin Tray1 *Model C3321i
*UIConstraints: *OutputBin Tray1 *Model C286i
*UIConstraints: *OutputBin Tray1 *Model C266i
*UIConstraints: *OutputBin Tray1 *Model C226i
*UIConstraints: *OutputBin Tray1 *Model C4050i
*UIConstraints: *OutputBin Tray1 *Model C3350i
*UIConstraints: *OutputBin Tray1 *Model C4000i
*UIConstraints: *OutputBin Tray1 *Model C3300i
*UIConstraints: *OutputBin Tray1 *Model C3320i
*UIConstraints: *OutputBin Tray2 *Fold Stitch
*UIConstraints: *OutputBin Tray2 *Fold HalfFold
*UIConstraints: *OutputBin Tray2 *Fold TriFold
*UIConstraints: *OutputBin Tray2 *Fold ZFold1
*UIConstraints: *OutputBin Tray2 *Fold ZFold2
*UIConstraints: *OutputBin Tray2 *Finisher None
*UIConstraints: *OutputBin Tray2 *Finisher FS533
*UIConstraints: *OutputBin Tray2 *Finisher FS542
*UIConstraints: *OutputBin Tray2 *Model C4051i
*UIConstraints: *OutputBin Tray2 *Model C3351i
*UIConstraints: *OutputBin Tray2 *Model C4001i
*UIConstraints: *OutputBin Tray2 *Model C3301i
*UIConstraints: *OutputBin Tray2 *Model C3321i
*UIConstraints: *OutputBin Tray2 *Model C286i
*UIConstraints: *OutputBin Tray2 *Model C266i
*UIConstraints: *OutputBin Tray2 *Model C226i
*UIConstraints: *OutputBin Tray2 *Model C4050i
*UIConstraints: *OutputBin Tray2 *Model C3350i
*UIConstraints: *OutputBin Tray2 *Model C4000i
*UIConstraints: *OutputBin Tray2 *Model C3300i
*UIConstraints: *OutputBin Tray2 *Model C3320i
*UIConstraints: *OutputBin Tray3 *Fold Stitch
*UIConstraints: *OutputBin Tray3 *Fold HalfFold
*UIConstraints: *OutputBin Tray3 *Fold TriFold
*UIConstraints: *OutputBin Tray3 *Fold ZFold1
*UIConstraints: *OutputBin Tray3 *Fold ZFold2
*UIConstraints: *OutputBin Tray3 *PIFrontCover PITray1
*UIConstraints: *OutputBin Tray3 *PIFrontCover PITray2
*UIConstraints: *OutputBin Tray3 *PIBackCover PITray1
*UIConstraints: *OutputBin Tray3 *PIBackCover PITray2
*UIConstraints: *OutputBin Tray3 *Finisher None
*UIConstraints: *OutputBin Tray3 *Finisher FS533
*UIConstraints: *OutputBin Tray3 *Finisher JS506
*UIConstraints: *OutputBin Tray3 *Finisher JS508
*UIConstraints: *OutputBin Tray3 *Finisher FS542
*UIConstraints: *OutputBin Tray3 *Model C4051i
*UIConstraints: *OutputBin Tray3 *Model C3351i
*UIConstraints: *OutputBin Tray3 *Model C4001i
*UIConstraints: *OutputBin Tray3 *Model C3301i
*UIConstraints: *OutputBin Tray3 *Model C3321i
*UIConstraints: *OutputBin Tray3 *Model C286i
*UIConstraints: *OutputBin Tray3 *Model C266i
*UIConstraints: *OutputBin Tray3 *Model C226i
*UIConstraints: *OutputBin Tray3 *Model C4050i
*UIConstraints: *OutputBin Tray3 *Model C3350i
*UIConstraints: *OutputBin Tray3 *Model C4000i
*UIConstraints: *OutputBin Tray3 *Model C3300i
*UIConstraints: *OutputBin Tray3 *Model C3320i
*UIConstraints: *OutputBin Tray4 *Offset True
*UIConstraints: *OutputBin Tray4 *PageSize A3
*UIConstraints: *OutputBin Tray4 *PageSize B4
*UIConstraints: *OutputBin Tray4 *PageSize SRA3
*UIConstraints: *OutputBin Tray4 *PageSize 220mmx330mm
*UIConstraints: *OutputBin Tray4 *PageSize 12x18
*UIConstraints: *OutputBin Tray4 *PageSize Tabloid
*UIConstraints: *OutputBin Tray4 *PageSize Legal
*UIConstraints: *OutputBin Tray4 *PageSize 8x13
*UIConstraints: *OutputBin Tray4 *PageSize 8.5x13
*UIConstraints: *OutputBin Tray4 *PageSize 8.5x13.5
*UIConstraints: *OutputBin Tray4 *PageSize 8.25x13
*UIConstraints: *OutputBin Tray4 *PageSize 8.125x13.25
*UIConstraints: *OutputBin Tray4 *PageSize 8K
*UIConstraints: *OutputBin Tray4 *PageSize A3Extra
*UIConstraints: *OutputBin Tray4 *PageSize A4Extra
*UIConstraints: *OutputBin Tray4 *PageSize B4Extra
*UIConstraints: *OutputBin Tray4 *PageSize TabloidExtra
*UIConstraints: *OutputBin Tray4 *PageSize LetterExtra
*UIConstraints: *OutputBin Tray4 *Staple 1StapleAuto(Left)
*UIConstraints: *OutputBin Tray4 *Staple 1StapleZeroLeft
*UIConstraints: *OutputBin Tray4 *Staple 1StapleAuto(Right)
*UIConstraints: *OutputBin Tray4 *Staple 1StapleZeroRight
*UIConstraints: *OutputBin Tray4 *Staple 2Staples
*UIConstraints: *OutputBin Tray4 *Punch 2holes
*UIConstraints: *OutputBin Tray4 *Punch 3holes
*UIConstraints: *OutputBin Tray4 *Punch 4holes
*UIConstraints: *OutputBin Tray4 *Fold Stitch
*UIConstraints: *OutputBin Tray4 *Fold HalfFold
*UIConstraints: *OutputBin Tray4 *Fold TriFold
*UIConstraints: *OutputBin Tray4 *Fold ZFold1
*UIConstraints: *OutputBin Tray4 *Fold ZFold2
*UIConstraints: *OutputBin Tray4 *PIFrontCover PITray1
*UIConstraints: *OutputBin Tray4 *PIFrontCover PITray2
*UIConstraints: *OutputBin Tray4 *PIBackCover PITray1
*UIConstraints: *OutputBin Tray4 *PIBackCover PITray2
*UIConstraints: *OutputBin Tray4 *Finisher None
*UIConstraints: *OutputBin Tray4 *Finisher FS533
*UIConstraints: *OutputBin Tray4 *Finisher FS539
*UIConstraints: *OutputBin Tray4 *Finisher JS506
*UIConstraints: *OutputBin Tray4 *Finisher JS508
*UIConstraints: *OutputBin Tray4 *Finisher FS540
*UIConstraints: *OutputBin Tray4 *Finisher FS542
*UIConstraints: *OutputBin Tray4 *Model C361i
*UIConstraints: *OutputBin Tray4 *Model C301i
*UIConstraints: *OutputBin Tray4 *Model C251i
*UIConstraints: *OutputBin Tray4 *Model C4051i
*UIConstraints: *OutputBin Tray4 *Model C3351i
*UIConstraints: *OutputBin Tray4 *Model C4001i
*UIConstraints: *OutputBin Tray4 *Model C3301i
*UIConstraints: *OutputBin Tray4 *Model C3321i
*UIConstraints: *OutputBin Tray4 *Model C360i
*UIConstraints: *OutputBin Tray4 *Model C300i
*UIConstraints: *OutputBin Tray4 *Model C250i
*UIConstraints: *OutputBin Tray4 *Model C287i
*UIConstraints: *OutputBin Tray4 *Model C257i
*UIConstraints: *OutputBin Tray4 *Model C227i
*UIConstraints: *OutputBin Tray4 *Model C286i
*UIConstraints: *OutputBin Tray4 *Model C266i
*UIConstraints: *OutputBin Tray4 *Model C226i
*UIConstraints: *OutputBin Tray4 *Model C4050i
*UIConstraints: *OutputBin Tray4 *Model C3350i
*UIConstraints: *OutputBin Tray4 *Model C4000i
*UIConstraints: *OutputBin Tray4 *Model C3300i
*UIConstraints: *OutputBin Tray4 *Model C3320i
*UIConstraints: *Binding LeftBinding *Staple 1StapleAuto(Right)
*UIConstraints: *Binding LeftBinding *Staple 1StapleZeroRight
*UIConstraints: *Binding TopBinding *MediaType TAB
*UIConstraints: *Binding TopBinding *PageSize LetterTab-F
*UIConstraints: *Binding TopBinding *PageSize A4Tab-F
*UIConstraints: *Binding TopBinding *Staple 1StapleZeroLeft
*UIConstraints: *Binding TopBinding *Staple 1StapleZeroRight
*UIConstraints: *Binding RightBinding *MediaType TAB
*UIConstraints: *Binding RightBinding *PageSize LetterTab-F
*UIConstraints: *Binding RightBinding *PageSize A4Tab-F
*UIConstraints: *Binding RightBinding *Staple 1StapleAuto(Left)
*UIConstraints: *Binding RightBinding *Staple 1StapleZeroLeft
*UIConstraints: *KMDuplex 2Sided *MediaType Plain(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType PlainPlus(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Thick1(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Thick1Plus(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Thick2(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Thick3(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Thick4
*UIConstraints: *KMDuplex 2Sided *MediaType Thick4(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Envelope
*UIConstraints: *KMDuplex 2Sided *MediaType Transparency
*UIConstraints: *KMDuplex 2Sided *MediaType SingleSidedOnly
*UIConstraints: *KMDuplex 2Sided *MediaType TAB
*UIConstraints: *KMDuplex 2Sided *MediaType Recycled(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType Labels
*UIConstraints: *KMDuplex 2Sided *MediaType Postcard
*UIConstraints: *KMDuplex 2Sided *MediaType Glossy
*UIConstraints: *KMDuplex 2Sided *MediaType GlossyPlus
*UIConstraints: *KMDuplex 2Sided *MediaType Glossy2
*UIConstraints: *KMDuplex 2Sided *MediaType User1(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType User2(2nd)_1
*UIConstraints: *KMDuplex 2Sided *MediaType User2(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType User3(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType User4(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType User5(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType User6(2nd)
*UIConstraints: *KMDuplex 2Sided *MediaType User7(2nd)
*UIConstraints: *KMDuplex 2Sided *PageSize EnvChou4
*UIConstraints: *KMDuplex 2Sided *PageSize EnvYou3
*UIConstraints: *KMDuplex 2Sided *PageSize EnvMonarch
*UIConstraints: *KMDuplex 2Sided *PageSize DoublePostcardRotated
*UIConstraints: *KMDuplex 2Sided *PageSize LetterTab-F
*UIConstraints: *KMDuplex 2Sided *PageSize A4Tab-F
*UIConstraints: *Combination Booklet *MediaType Plain(2nd)
*UIConstraints: *Combination Booklet *MediaType PlainPlus(2nd)
*UIConstraints: *Combination Booklet *MediaType Thick1(2nd)
*UIConstraints: *Combination Booklet *MediaType Thick1Plus(2nd)
*UIConstraints: *Combination Booklet *MediaType Thick2(2nd)
*UIConstraints: *Combination Booklet *MediaType Thick3(2nd)
*UIConstraints: *Combination Booklet *MediaType Thick4
*UIConstraints: *Combination Booklet *MediaType Thick4(2nd)
*UIConstraints: *Combination Booklet *MediaType Envelope
*UIConstraints: *Combination Booklet *MediaType Transparency
*UIConstraints: *Combination Booklet *MediaType SingleSidedOnly
*UIConstraints: *Combination Booklet *MediaType TAB
*UIConstraints: *Combination Booklet *MediaType Recycled(2nd)
*UIConstraints: *Combination Booklet *MediaType Labels
*UIConstraints: *Combination Booklet *MediaType Postcard
*UIConstraints: *Combination Booklet *MediaType Glossy
*UIConstraints: *Combination Booklet *MediaType GlossyPlus
*UIConstraints: *Combination Booklet *MediaType Glossy2
*UIConstraints: *Combination Booklet *MediaType User1(2nd)
*UIConstraints: *Combination Booklet *MediaType User2(2nd)_1
*UIConstraints: *Combination Booklet *MediaType User2(2nd)
*UIConstraints: *Combination Booklet *MediaType User3(2nd)
*UIConstraints: *Combination Booklet *MediaType User4(2nd)
*UIConstraints: *Combination Booklet *MediaType User5(2nd)
*UIConstraints: *Combination Booklet *MediaType User6(2nd)
*UIConstraints: *Combination Booklet *MediaType User7(2nd)
*UIConstraints: *Combination Booklet *PageSize A3
*UIConstraints: *Combination Booklet *PageSize B4
*UIConstraints: *Combination Booklet *PageSize SRA3
*UIConstraints: *Combination Booklet *PageSize 220mmx330mm
*UIConstraints: *Combination Booklet *PageSize 12x18
*UIConstraints: *Combination Booklet *PageSize Tabloid
*UIConstraints: *Combination Booklet *PageSize Legal
*UIConstraints: *Combination Booklet *PageSize LetterPlus
*UIConstraints: *Combination Booklet *PageSize 8x13
*UIConstraints: *Combination Booklet *PageSize 8.5x13
*UIConstraints: *Combination Booklet *PageSize 8.5x13.5
*UIConstraints: *Combination Booklet *PageSize 8.25x13
*UIConstraints: *Combination Booklet *PageSize 8.125x13.25
*UIConstraints: *Combination Booklet *PageSize 8x10
*UIConstraints: *Combination Booklet *PageSize 8x10.5
*UIConstraints: *Combination Booklet *PageSize Executive
*UIConstraints: *Combination Booklet *PageSize 8K
*UIConstraints: *Combination Booklet *PageSize EnvISOB5
*UIConstraints: *Combination Booklet *PageSize EnvC4
*UIConstraints: *Combination Booklet *PageSize EnvC5
*UIConstraints: *Combination Booklet *PageSize EnvC6
*UIConstraints: *Combination Booklet *PageSize EnvChou3
*UIConstraints: *Combination Booklet *PageSize EnvChou4
*UIConstraints: *Combination Booklet *PageSize EnvYou3
*UIConstraints: *Combination Booklet *PageSize EnvYou4
*UIConstraints: *Combination Booklet *PageSize EnvKaku1
*UIConstraints: *Combination Booklet *PageSize EnvKaku2
*UIConstraints: *Combination Booklet *PageSize EnvKaku3
*UIConstraints: *Combination Booklet *PageSize EnvDL
*UIConstraints: *Combination Booklet *PageSize EnvMonarch
*UIConstraints: *Combination Booklet *PageSize Env10
*UIConstraints: *Combination Booklet *PageSize JapanesePostCard
*UIConstraints: *Combination Booklet *PageSize 4x6_PostCard
*UIConstraints: *Combination Booklet *PageSize DoublePostcardRotated
*UIConstraints: *Combination Booklet *PageSize A3Extra
*UIConstraints: *Combination Booklet *PageSize B4Extra
*UIConstraints: *Combination Booklet *PageSize TabloidExtra
*UIConstraints: *Combination Booklet *PageSize LetterTab-F
*UIConstraints: *Combination Booklet *PageSize A4Tab-F
*UIConstraints: *Combination Booklet *Staple 1StapleAuto(Left)
*UIConstraints: *Combination Booklet *Staple 1StapleZeroLeft
*UIConstraints: *Combination Booklet *Staple 1StapleAuto(Right)
*UIConstraints: *Combination Booklet *Staple 1StapleZeroRight
*UIConstraints: *Combination Booklet *Staple 2Staples
*UIConstraints: *Combination Booklet *Punch 2holes
*UIConstraints: *Combination Booklet *Punch 3holes
*UIConstraints: *Combination Booklet *Punch 4holes
*UIConstraints: *Combination Booklet *Fold TriFold
*UIConstraints: *Combination Booklet *Fold ZFold1
*UIConstraints: *Combination Booklet *Fold ZFold2
*UIConstraints: *Combination Booklet *BackCoverPage Printed
*UIConstraints: *Combination Booklet *BackCoverPage Blank
*UIConstraints: *Combination Booklet *PIBackCover PITray1
*UIConstraints: *Combination Booklet *PIBackCover PITray2
*UIConstraints: *Staple 1StapleAuto(Left) *Offset True
*UIConstraints: *Staple 1StapleAuto(Left) *MediaType Envelope
*UIConstraints: *Staple 1StapleAuto(Left) *MediaType Transparency
*UIConstraints: *Staple 1StapleAuto(Left) *MediaType TAB
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize A6
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize B6
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize SRA3
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize 12x18
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvISOB5
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvC5
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvC6
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvChou3
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvChou4
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvYou3
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvYou4
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvDL
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize EnvMonarch
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize Env10
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize JapanesePostCard
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize 4x6_PostCard
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize LetterTab-F
*UIConstraints: *Staple 1StapleAuto(Left) *PageSize A4Tab-F
*UIConstraints: *Staple 1StapleAuto(Left) *OutputBin Tray4
*UIConstraints: *Staple 1StapleAuto(Left) *Binding RightBinding
*UIConstraints: *Staple 1StapleAuto(Left) *Combination Booklet
*UIConstraints: *Staple 1StapleAuto(Left) *Fold Stitch
*UIConstraints: *Staple 1StapleAuto(Left) *Fold HalfFold
*UIConstraints: *Staple 1StapleAuto(Left) *Fold TriFold
*UIConstraints: *Staple 1StapleAuto(Left) *Finisher None
*UIConstraints: *Staple 1StapleAuto(Left) *Finisher JS506
*UIConstraints: *Staple 1StapleAuto(Left) *Finisher JS508
*UIConstraints: *Staple 1StapleAuto(Left) *Model C4051i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C3351i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C4001i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C3301i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C3321i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C286i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C266i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C226i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C4050i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C3350i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C4000i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C3300i
*UIConstraints: *Staple 1StapleAuto(Left) *Model C3320i
*UIConstraints: *Staple 1StapleZeroLeft *Offset True
*UIConstraints: *Staple 1StapleZeroLeft *MediaType Envelope
*UIConstraints: *Staple 1StapleZeroLeft *MediaType Transparency
*UIConstraints: *Staple 1StapleZeroLeft *MediaType TAB
*UIConstraints: *Staple 1StapleZeroLeft *PageSize A5
*UIConstraints: *Staple 1StapleZeroLeft *PageSize A6
*UIConstraints: *Staple 1StapleZeroLeft *PageSize B4
*UIConstraints: *Staple 1StapleZeroLeft *PageSize B5
*UIConstraints: *Staple 1StapleZeroLeft *PageSize B6
*UIConstraints: *Staple 1StapleZeroLeft *PageSize SRA3
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 220mmx330mm
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 12x18
*UIConstraints: *Staple 1StapleZeroLeft *PageSize Legal
*UIConstraints: *Staple 1StapleZeroLeft *PageSize Statement
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 8x13
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 8.5x13
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 8.5x13.5
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 8.25x13
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 8.125x13.25
*UIConstraints: *Staple 1StapleZeroLeft *PageSize Executive
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 8K
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 16K
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvISOB5
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvC4
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvC5
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvC6
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvChou3
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvChou4
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvYou3
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvYou4
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvKaku1
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvKaku2
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvKaku3
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvDL
*UIConstraints: *Staple 1StapleZeroLeft *PageSize EnvMonarch
*UIConstraints: *Staple 1StapleZeroLeft *PageSize Env10
*UIConstraints: *Staple 1StapleZeroLeft *PageSize JapanesePostCard
*UIConstraints: *Staple 1StapleZeroLeft *PageSize 4x6_PostCard
*UIConstraints: *Staple 1StapleZeroLeft *PageSize A3Extra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize A4Extra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize A5Extra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize B4Extra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize B5Extra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize TabloidExtra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize LetterExtra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize StatementExtra
*UIConstraints: *Staple 1StapleZeroLeft *PageSize LetterTab-F
*UIConstraints: *Staple 1StapleZeroLeft *PageSize A4Tab-F
*UIConstraints: *Staple 1StapleZeroLeft *OutputBin Tray4
*UIConstraints: *Staple 1StapleZeroLeft *Binding TopBinding
*UIConstraints: *Staple 1StapleZeroLeft *Binding RightBinding
*UIConstraints: *Staple 1StapleZeroLeft *Combination Booklet
*UIConstraints: *Staple 1StapleZeroLeft *Fold Stitch
*UIConstraints: *Staple 1StapleZeroLeft *Fold HalfFold
*UIConstraints: *Staple 1StapleZeroLeft *Fold TriFold
*UIConstraints: *Staple 1StapleZeroLeft *Finisher None
*UIConstraints: *Staple 1StapleZeroLeft *Finisher FS533
*UIConstraints: *Staple 1StapleZeroLeft *Finisher JS506
*UIConstraints: *Staple 1StapleZeroLeft *Finisher JS508
*UIConstraints: *Staple 1StapleZeroLeft *Finisher FS542
*UIConstraints: *Staple 1StapleZeroLeft *Model C4051i
*UIConstraints: *Staple 1StapleZeroLeft *Model C3351i
*UIConstraints: *Staple 1StapleZeroLeft *Model C4001i
*UIConstraints: *Staple 1StapleZeroLeft *Model C3301i
*UIConstraints: *Staple 1StapleZeroLeft *Model C3321i
*UIConstraints: *Staple 1StapleZeroLeft *Model C286i
*UIConstraints: *Staple 1StapleZeroLeft *Model C266i
*UIConstraints: *Staple 1StapleZeroLeft *Model C226i
*UIConstraints: *Staple 1StapleZeroLeft *Model C4050i
*UIConstraints: *Staple 1StapleZeroLeft *Model C3350i
*UIConstraints: *Staple 1StapleZeroLeft *Model C4000i
*UIConstraints: *Staple 1StapleZeroLeft *Model C3300i
*UIConstraints: *Staple 1StapleZeroLeft *Model C3320i
*UIConstraints: *Staple 1StapleAuto(Right) *Offset True
*UIConstraints: *Staple 1StapleAuto(Right) *MediaType Envelope
*UIConstraints: *Staple 1StapleAuto(Right) *MediaType Transparency
*UIConstraints: *Staple 1StapleAuto(Right) *MediaType TAB
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize A6
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize B6
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize SRA3
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize 12x18
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvISOB5
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvC5
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvC6
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvChou3
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvChou4
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvYou3
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvYou4
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvDL
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize EnvMonarch
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize Env10
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize JapanesePostCard
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize 4x6_PostCard
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize LetterTab-F
*UIConstraints: *Staple 1StapleAuto(Right) *PageSize A4Tab-F
*UIConstraints: *Staple 1StapleAuto(Right) *OutputBin Tray4
*UIConstraints: *Staple 1StapleAuto(Right) *Binding LeftBinding
*UIConstraints: *Staple 1StapleAuto(Right) *Combination Booklet
*UIConstraints: *Staple 1StapleAuto(Right) *Fold Stitch
*UIConstraints: *Staple 1StapleAuto(Right) *Fold HalfFold
*UIConstraints: *Staple 1StapleAuto(Right) *Fold TriFold
*UIConstraints: *Staple 1StapleAuto(Right) *Finisher None
*UIConstraints: *Staple 1StapleAuto(Right) *Finisher JS506
*UIConstraints: *Staple 1StapleAuto(Right) *Finisher JS508
*UIConstraints: *Staple 1StapleAuto(Right) *Model C4051i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C3351i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C4001i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C3301i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C3321i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C286i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C266i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C226i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C4050i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C3350i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C4000i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C3300i
*UIConstraints: *Staple 1StapleAuto(Right) *Model C3320i
*UIConstraints: *Staple 1StapleZeroRight *Offset True
*UIConstraints: *Staple 1StapleZeroRight *MediaType Envelope
*UIConstraints: *Staple 1StapleZeroRight *MediaType Transparency
*UIConstraints: *Staple 1StapleZeroRight *MediaType TAB
*UIConstraints: *Staple 1StapleZeroRight *PageSize A5
*UIConstraints: *Staple 1StapleZeroRight *PageSize A6
*UIConstraints: *Staple 1StapleZeroRight *PageSize B4
*UIConstraints: *Staple 1StapleZeroRight *PageSize B5
*UIConstraints: *Staple 1StapleZeroRight *PageSize B6
*UIConstraints: *Staple 1StapleZeroRight *PageSize SRA3
*UIConstraints: *Staple 1StapleZeroRight *PageSize 220mmx330mm
*UIConstraints: *Staple 1StapleZeroRight *PageSize 12x18
*UIConstraints: *Staple 1StapleZeroRight *PageSize Legal
*UIConstraints: *Staple 1StapleZeroRight *PageSize Statement
*UIConstraints: *Staple 1StapleZeroRight *PageSize 8x13
*UIConstraints: *Staple 1StapleZeroRight *PageSize 8.5x13
*UIConstraints: *Staple 1StapleZeroRight *PageSize 8.5x13.5
*UIConstraints: *Staple 1StapleZeroRight *PageSize 8.25x13
*UIConstraints: *Staple 1StapleZeroRight *PageSize 8.125x13.25
*UIConstraints: *Staple 1StapleZeroRight *PageSize Executive
*UIConstraints: *Staple 1StapleZeroRight *PageSize 8K
*UIConstraints: *Staple 1StapleZeroRight *PageSize 16K
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvISOB5
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvC4
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvC5
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvC6
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvChou3
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvChou4
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvYou3
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvYou4
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvKaku1
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvKaku2
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvKaku3
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvDL
*UIConstraints: *Staple 1StapleZeroRight *PageSize EnvMonarch
*UIConstraints: *Staple 1StapleZeroRight *PageSize Env10
*UIConstraints: *Staple 1StapleZeroRight *PageSize JapanesePostCard
*UIConstraints: *Staple 1StapleZeroRight *PageSize 4x6_PostCard
*UIConstraints: *Staple 1StapleZeroRight *PageSize A3Extra
*UIConstraints: *Staple 1StapleZeroRight *PageSize A4Extra
*UIConstraints: *Staple 1StapleZeroRight *PageSize A5Extra
*UIConstraints: *Staple 1StapleZeroRight *PageSize B4Extra
*UIConstraints: *Staple 1StapleZeroRight *PageSize B5Extra
*UIConstraints: *Staple 1StapleZeroRight *PageSize TabloidExtra
*UIConstraints: *Staple 1StapleZeroRight *PageSize LetterExtra
*UIConstraints: *Staple 1StapleZeroRight *PageSize StatementExtra
*UIConstraints: *Staple 1StapleZeroRight *PageSize LetterTab-F
*UIConstraints: *Staple 1StapleZeroRight *PageSize A4Tab-F
*UIConstraints: *Staple 1StapleZeroRight *OutputBin Tray4
*UIConstraints: *Staple 1StapleZeroRight *Binding LeftBinding
*UIConstraints: *Staple 1StapleZeroRight *Binding TopBinding
*UIConstraints: *Staple 1StapleZeroRight *Combination Booklet
*UIConstraints: *Staple 1StapleZeroRight *Fold Stitch
*UIConstraints: *Staple 1StapleZeroRight *Fold HalfFold
*UIConstraints: *Staple 1StapleZeroRight *Fold TriFold
*UIConstraints: *Staple 1StapleZeroRight *Finisher None
*UIConstraints: *Staple 1StapleZeroRight *Finisher FS533
*UIConstraints: *Staple 1StapleZeroRight *Finisher JS506
*UIConstraints: *Staple 1StapleZeroRight *Finisher JS508
*UIConstraints: *Staple 1StapleZeroRight *Finisher FS542
*UIConstraints: *Staple 1StapleZeroRight *Model C4051i
*UIConstraints: *Staple 1StapleZeroRight *Model C3351i
*UIConstraints: *Staple 1StapleZeroRight *Model C4001i
*UIConstraints: *Staple 1StapleZeroRight *Model C3301i
*UIConstraints: *Staple 1StapleZeroRight *Model C3321i
*UIConstraints: *Staple 1StapleZeroRight *Model C286i
*UIConstraints: *Staple 1StapleZeroRight *Model C266i
*UIConstraints: *Staple 1StapleZeroRight *Model C226i
*UIConstraints: *Staple 1StapleZeroRight *Model C4050i
*UIConstraints: *Staple 1StapleZeroRight *Model C3350i
*UIConstraints: *Staple 1StapleZeroRight *Model C4000i
*UIConstraints: *Staple 1StapleZeroRight *Model C3300i
*UIConstraints: *Staple 1StapleZeroRight *Model C3320i
*UIConstraints: *Staple 2Staples *Offset True
*UIConstraints: *Staple 2Staples *MediaType Envelope
*UIConstraints: *Staple 2Staples *MediaType Transparency
*UIConstraints: *Staple 2Staples *MediaType TAB
*UIConstraints: *Staple 2Staples *PageSize A6
*UIConstraints: *Staple 2Staples *PageSize B6
*UIConstraints: *Staple 2Staples *PageSize SRA3
*UIConstraints: *Staple 2Staples *PageSize 12x18
*UIConstraints: *Staple 2Staples *PageSize EnvISOB5
*UIConstraints: *Staple 2Staples *PageSize EnvC5
*UIConstraints: *Staple 2Staples *PageSize EnvC6
*UIConstraints: *Staple 2Staples *PageSize EnvChou3
*UIConstraints: *Staple 2Staples *PageSize EnvChou4
*UIConstraints: *Staple 2Staples *PageSize EnvYou3
*UIConstraints: *Staple 2Staples *PageSize EnvYou4
*UIConstraints: *Staple 2Staples *PageSize EnvDL
*UIConstraints: *Staple 2Staples *PageSize EnvMonarch
*UIConstraints: *Staple 2Staples *PageSize Env10
*UIConstraints: *Staple 2Staples *PageSize JapanesePostCard
*UIConstraints: *Staple 2Staples *PageSize 4x6_PostCard
*UIConstraints: *Staple 2Staples *PageSize LetterTab-F
*UIConstraints: *Staple 2Staples *PageSize A4Tab-F
*UIConstraints: *Staple 2Staples *OutputBin Tray4
*UIConstraints: *Staple 2Staples *Combination Booklet
*UIConstraints: *Staple 2Staples *Fold Stitch
*UIConstraints: *Staple 2Staples *Fold HalfFold
*UIConstraints: *Staple 2Staples *Fold TriFold
*UIConstraints: *Staple 2Staples *Finisher None
*UIConstraints: *Staple 2Staples *Finisher JS506
*UIConstraints: *Staple 2Staples *Finisher JS508
*UIConstraints: *Staple 2Staples *Model C4051i
*UIConstraints: *Staple 2Staples *Model C3351i
*UIConstraints: *Staple 2Staples *Model C4001i
*UIConstraints: *Staple 2Staples *Model C3301i
*UIConstraints: *Staple 2Staples *Model C3321i
*UIConstraints: *Staple 2Staples *Model C286i
*UIConstraints: *Staple 2Staples *Model C266i
*UIConstraints: *Staple 2Staples *Model C226i
*UIConstraints: *Staple 2Staples *Model C4050i
*UIConstraints: *Staple 2Staples *Model C3350i
*UIConstraints: *Staple 2Staples *Model C4000i
*UIConstraints: *Staple 2Staples *Model C3300i
*UIConstraints: *Staple 2Staples *Model C3320i
*UIConstraints: *Punch 2holes *MediaType Envelope
*UIConstraints: *Punch 2holes *MediaType Transparency
*UIConstraints: *Punch 2holes *MediaType TAB
*UIConstraints: *Punch 2holes *PageSize A6
*UIConstraints: *Punch 2holes *PageSize B6
*UIConstraints: *Punch 2holes *PageSize SRA3
*UIConstraints: *Punch 2holes *PageSize 12x18
*UIConstraints: *Punch 2holes *PageSize EnvISOB5
*UIConstraints: *Punch 2holes *PageSize EnvC4
*UIConstraints: *Punch 2holes *PageSize EnvC5
*UIConstraints: *Punch 2holes *PageSize EnvC6
*UIConstraints: *Punch 2holes *PageSize EnvChou3
*UIConstraints: *Punch 2holes *PageSize EnvChou4
*UIConstraints: *Punch 2holes *PageSize EnvYou3
*UIConstraints: *Punch 2holes *PageSize EnvYou4
*UIConstraints: *Punch 2holes *PageSize EnvKaku1
*UIConstraints: *Punch 2holes *PageSize EnvKaku2
*UIConstraints: *Punch 2holes *PageSize EnvKaku3
*UIConstraints: *Punch 2holes *PageSize EnvDL
*UIConstraints: *Punch 2holes *PageSize EnvMonarch
*UIConstraints: *Punch 2holes *PageSize Env10
*UIConstraints: *Punch 2holes *PageSize JapanesePostCard
*UIConstraints: *Punch 2holes *PageSize 4x6_PostCard
*UIConstraints: *Punch 2holes *PageSize A3Extra
*UIConstraints: *Punch 2holes *PageSize A4Extra
*UIConstraints: *Punch 2holes *PageSize A5Extra
*UIConstraints: *Punch 2holes *PageSize B4Extra
*UIConstraints: *Punch 2holes *PageSize B5Extra
*UIConstraints: *Punch 2holes *PageSize TabloidExtra
*UIConstraints: *Punch 2holes *PageSize LetterExtra
*UIConstraints: *Punch 2holes *PageSize StatementExtra
*UIConstraints: *Punch 2holes *PageSize LetterTab-F
*UIConstraints: *Punch 2holes *PageSize A4Tab-F
*UIConstraints: *Punch 2holes *OutputBin Tray4
*UIConstraints: *Punch 2holes *Combination Booklet
*UIConstraints: *Punch 2holes *Fold Stitch
*UIConstraints: *Punch 2holes *Fold HalfFold
*UIConstraints: *Punch 2holes *Fold TriFold
*UIConstraints: *Punch 2holes *KOPunch None
*UIConstraints: *Punch 2holes *KOPunch PK519-SWE4
*UIConstraints: *Punch 2holes *KOPunch PK524-SWE4
*UIConstraints: *Punch 2holes *KOPunch PK526-SWE4
*UIConstraints: *Punch 2holes *KOPunch PK527-SWE4
*UIConstraints: *Punch 2holes *Model C4051i
*UIConstraints: *Punch 2holes *Model C3351i
*UIConstraints: *Punch 2holes *Model C4001i
*UIConstraints: *Punch 2holes *Model C3301i
*UIConstraints: *Punch 2holes *Model C3321i
*UIConstraints: *Punch 2holes *Model C286i
*UIConstraints: *Punch 2holes *Model C266i
*UIConstraints: *Punch 2holes *Model C226i
*UIConstraints: *Punch 2holes *Model C4050i
*UIConstraints: *Punch 2holes *Model C3350i
*UIConstraints: *Punch 2holes *Model C4000i
*UIConstraints: *Punch 2holes *Model C3300i
*UIConstraints: *Punch 2holes *Model C3320i
*UIConstraints: *Punch 3holes *MediaType Envelope
*UIConstraints: *Punch 3holes *MediaType Transparency
*UIConstraints: *Punch 3holes *MediaType TAB
*UIConstraints: *Punch 3holes *PageSize A5
*UIConstraints: *Punch 3holes *PageSize A6
*UIConstraints: *Punch 3holes *PageSize B6
*UIConstraints: *Punch 3holes *PageSize SRA3
*UIConstraints: *Punch 3holes *PageSize 220mmx330mm
*UIConstraints: *Punch 3holes *PageSize 12x18
*UIConstraints: *Punch 3holes *PageSize Legal
*UIConstraints: *Punch 3holes *PageSize Statement
*UIConstraints: *Punch 3holes *PageSize 8x13
*UIConstraints: *Punch 3holes *PageSize 8.5x13
*UIConstraints: *Punch 3holes *PageSize 8.5x13.5
*UIConstraints: *Punch 3holes *PageSize 8.25x13
*UIConstraints: *Punch 3holes *PageSize 8.125x13.25
*UIConstraints: *Punch 3holes *PageSize EnvISOB5
*UIConstraints: *Punch 3holes *PageSize EnvC4
*UIConstraints: *Punch 3holes *PageSize EnvC5
*UIConstraints: *Punch 3holes *PageSize EnvC6
*UIConstraints: *Punch 3holes *PageSize EnvChou3
*UIConstraints: *Punch 3holes *PageSize EnvChou4
*UIConstraints: *Punch 3holes *PageSize EnvYou3
*UIConstraints: *Punch 3holes *PageSize EnvYou4
*UIConstraints: *Punch 3holes *PageSize EnvKaku1
*UIConstraints: *Punch 3holes *PageSize EnvKaku2
*UIConstraints: *Punch 3holes *PageSize EnvKaku3
*UIConstraints: *Punch 3holes *PageSize EnvDL
*UIConstraints: *Punch 3holes *PageSize EnvMonarch
*UIConstraints: *Punch 3holes *PageSize Env10
*UIConstraints: *Punch 3holes *PageSize JapanesePostCard
*UIConstraints: *Punch 3holes *PageSize 4x6_PostCard
*UIConstraints: *Punch 3holes *PageSize A3Extra
*UIConstraints: *Punch 3holes *PageSize A4Extra
*UIConstraints: *Punch 3holes *PageSize A5Extra
*UIConstraints: *Punch 3holes *PageSize B4Extra
*UIConstraints: *Punch 3holes *PageSize B5Extra
*UIConstraints: *Punch 3holes *PageSize TabloidExtra
*UIConstraints: *Punch 3holes *PageSize LetterExtra
*UIConstraints: *Punch 3holes *PageSize StatementExtra
*UIConstraints: *Punch 3holes *PageSize LetterTab-F
*UIConstraints: *Punch 3holes *PageSize A4Tab-F
*UIConstraints: *Punch 3holes *OutputBin Tray4
*UIConstraints: *Punch 3holes *Combination Booklet
*UIConstraints: *Punch 3holes *Fold Stitch
*UIConstraints: *Punch 3holes *Fold HalfFold
*UIConstraints: *Punch 3holes *Fold TriFold
*UIConstraints: *Punch 3holes *KOPunch None
*UIConstraints: *Punch 3holes *KOPunch PK519
*UIConstraints: *Punch 3holes *KOPunch PK519-4
*UIConstraints: *Punch 3holes *KOPunch PK519-SWE4
*UIConstraints: *Punch 3holes *KOPunch PK524
*UIConstraints: *Punch 3holes *KOPunch PK524-4
*UIConstraints: *Punch 3holes *KOPunch PK524-SWE4
*UIConstraints: *Punch 3holes *KOPunch PK526
*UIConstraints: *Punch 3holes *KOPunch PK526-4
*UIConstraints: *Punch 3holes *KOPunch PK526-SWE4
*UIConstraints: *Punch 3holes *KOPunch PK527
*UIConstraints: *Punch 3holes *KOPunch PK527-4
*UIConstraints: *Punch 3holes *KOPunch PK527-SWE4
*UIConstraints: *Punch 3holes *Model C4051i
*UIConstraints: *Punch 3holes *Model C3351i
*UIConstraints: *Punch 3holes *Model C4001i
*UIConstraints: *Punch 3holes *Model C3301i
*UIConstraints: *Punch 3holes *Model C3321i
*UIConstraints: *Punch 3holes *Model C286i
*UIConstraints: *Punch 3holes *Model C266i
*UIConstraints: *Punch 3holes *Model C226i
*UIConstraints: *Punch 3holes *Model C4050i
*UIConstraints: *Punch 3holes *Model C3350i
*UIConstraints: *Punch 3holes *Model C4000i
*UIConstraints: *Punch 3holes *Model C3300i
*UIConstraints: *Punch 3holes *Model C3320i
*UIConstraints: *Punch 4holes *MediaType Envelope
*UIConstraints: *Punch 4holes *MediaType Transparency
*UIConstraints: *Punch 4holes *MediaType TAB
*UIConstraints: *Punch 4holes *PageSize A6
*UIConstraints: *Punch 4holes *PageSize B6
*UIConstraints: *Punch 4holes *PageSize SRA3
*UIConstraints: *Punch 4holes *PageSize 12x18
*UIConstraints: *Punch 4holes *PageSize 8.5x13.5
*UIConstraints: *Punch 4holes *PageSize EnvISOB5
*UIConstraints: *Punch 4holes *PageSize EnvC4
*UIConstraints: *Punch 4holes *PageSize EnvC5
*UIConstraints: *Punch 4holes *PageSize EnvC6
*UIConstraints: *Punch 4holes *PageSize EnvChou3
*UIConstraints: *Punch 4holes *PageSize EnvChou4
*UIConstraints: *Punch 4holes *PageSize EnvYou3
*UIConstraints: *Punch 4holes *PageSize EnvYou4
*UIConstraints: *Punch 4holes *PageSize EnvKaku1
*UIConstraints: *Punch 4holes *PageSize EnvKaku2
*UIConstraints: *Punch 4holes *PageSize EnvKaku3
*UIConstraints: *Punch 4holes *PageSize EnvDL
*UIConstraints: *Punch 4holes *PageSize EnvMonarch
*UIConstraints: *Punch 4holes *PageSize Env10
*UIConstraints: *Punch 4holes *PageSize JapanesePostCard
*UIConstraints: *Punch 4holes *PageSize 4x6_PostCard
*UIConstraints: *Punch 4holes *PageSize A3Extra
*UIConstraints: *Punch 4holes *PageSize A4Extra
*UIConstraints: *Punch 4holes *PageSize A5Extra
*UIConstraints: *Punch 4holes *PageSize B4Extra
*UIConstraints: *Punch 4holes *PageSize B5Extra
*UIConstraints: *Punch 4holes *PageSize TabloidExtra
*UIConstraints: *Punch 4holes *PageSize LetterExtra
*UIConstraints: *Punch 4holes *PageSize StatementExtra
*UIConstraints: *Punch 4holes *PageSize LetterTab-F
*UIConstraints: *Punch 4holes *PageSize A4Tab-F
*UIConstraints: *Punch 4holes *OutputBin Tray4
*UIConstraints: *Punch 4holes *Combination Booklet
*UIConstraints: *Punch 4holes *Fold Stitch
*UIConstraints: *Punch 4holes *Fold HalfFold
*UIConstraints: *Punch 4holes *Fold TriFold
*UIConstraints: *Punch 4holes *KOPunch None
*UIConstraints: *Punch 4holes *KOPunch PK519
*UIConstraints: *Punch 4holes *KOPunch PK519-3
*UIConstraints: *Punch 4holes *KOPunch PK524
*UIConstraints: *Punch 4holes *KOPunch PK524-3
*UIConstraints: *Punch 4holes *KOPunch PK526
*UIConstraints: *Punch 4holes *KOPunch PK526-3
*UIConstraints: *Punch 4holes *KOPunch PK527
*UIConstraints: *Punch 4holes *KOPunch PK527-3
*UIConstraints: *Punch 4holes *Model C4051i
*UIConstraints: *Punch 4holes *Model C3351i
*UIConstraints: *Punch 4holes *Model C4001i
*UIConstraints: *Punch 4holes *Model C3301i
*UIConstraints: *Punch 4holes *Model C3321i
*UIConstraints: *Punch 4holes *Model C286i
*UIConstraints: *Punch 4holes *Model C266i
*UIConstraints: *Punch 4holes *Model C226i
*UIConstraints: *Punch 4holes *Model C4050i
*UIConstraints: *Punch 4holes *Model C3350i
*UIConstraints: *Punch 4holes *Model C4000i
*UIConstraints: *Punch 4holes *Model C3300i
*UIConstraints: *Punch 4holes *Model C3320i
*UIConstraints: *Fold Stitch *Offset True
*UIConstraints: *Fold Stitch *MediaType Plain(2nd)
*UIConstraints: *Fold Stitch *MediaType PlainPlus(2nd)
*UIConstraints: *Fold Stitch *MediaType Thick1(2nd)
*UIConstraints: *Fold Stitch *MediaType Thick1Plus(2nd)
*UIConstraints: *Fold Stitch *MediaType Thick2(2nd)
*UIConstraints: *Fold Stitch *MediaType Thick3
*UIConstraints: *Fold Stitch *MediaType Thick3(2nd)
*UIConstraints: *Fold Stitch *MediaType Thick4
*UIConstraints: *Fold Stitch *MediaType Thick4(2nd)
*UIConstraints: *Fold Stitch *MediaType Envelope
*UIConstraints: *Fold Stitch *MediaType Transparency
*UIConstraints: *Fold Stitch *MediaType TAB
*UIConstraints: *Fold Stitch *MediaType Recycled(2nd)
*UIConstraints: *Fold Stitch *MediaType User1(2nd)
*UIConstraints: *Fold Stitch *MediaType User2(2nd)_1
*UIConstraints: *Fold Stitch *MediaType User2(2nd)
*UIConstraints: *Fold Stitch *MediaType User3(2nd)
*UIConstraints: *Fold Stitch *MediaType User4(2nd)
*UIConstraints: *Fold Stitch *MediaType User5(2nd)
*UIConstraints: *Fold Stitch *MediaType User6
*UIConstraints: *Fold Stitch *MediaType User6(2nd)
*UIConstraints: *Fold Stitch *MediaType User7(2nd)
*UIConstraints: *Fold Stitch *PageSize A6
*UIConstraints: *Fold Stitch *PageSize B6
*UIConstraints: *Fold Stitch *PageSize 8x13
*UIConstraints: *Fold Stitch *PageSize 8.25x13
*UIConstraints: *Fold Stitch *PageSize 8.125x13.25
*UIConstraints: *Fold Stitch *PageSize Executive
*UIConstraints: *Fold Stitch *PageSize EnvISOB5
*UIConstraints: *Fold Stitch *PageSize EnvC5
*UIConstraints: *Fold Stitch *PageSize EnvC6
*UIConstraints: *Fold Stitch *PageSize EnvChou3
*UIConstraints: *Fold Stitch *PageSize EnvChou4
*UIConstraints: *Fold Stitch *PageSize EnvYou3
*UIConstraints: *Fold Stitch *PageSize EnvYou4
*UIConstraints: *Fold Stitch *PageSize EnvKaku3
*UIConstraints: *Fold Stitch *PageSize EnvDL
*UIConstraints: *Fold Stitch *PageSize EnvMonarch
*UIConstraints: *Fold Stitch *PageSize Env10
*UIConstraints: *Fold Stitch *PageSize JapanesePostCard
*UIConstraints: *Fold Stitch *PageSize 4x6_PostCard
*UIConstraints: *Fold Stitch *PageSize LetterTab-F
*UIConstraints: *Fold Stitch *PageSize A4Tab-F
*UIConstraints: *Fold Stitch *OutputBin Tray1
*UIConstraints: *Fold Stitch *OutputBin Tray2
*UIConstraints: *Fold Stitch *OutputBin Tray3
*UIConstraints: *Fold Stitch *OutputBin Tray4
*UIConstraints: *Fold Stitch *Staple 1StapleAuto(Left)
*UIConstraints: *Fold Stitch *Staple 1StapleZeroLeft
*UIConstraints: *Fold Stitch *Staple 1StapleAuto(Right)
*UIConstraints: *Fold Stitch *Staple 1StapleZeroRight
*UIConstraints: *Fold Stitch *Staple 2Staples
*UIConstraints: *Fold Stitch *Punch 2holes
*UIConstraints: *Fold Stitch *Punch 3holes
*UIConstraints: *Fold Stitch *Punch 4holes
*UIConstraints: *Fold Stitch *BackCoverPage Printed
*UIConstraints: *Fold Stitch *BackCoverPage Blank
*UIConstraints: *Fold Stitch *PIBackCover PITray1
*UIConstraints: *Fold Stitch *PIBackCover PITray2
*UIConstraints: *Fold Stitch *GlossyMode True
*UIConstraints: *Fold Stitch *SaddleUnit None
*UIConstraints: *Fold Stitch *Model C4051i
*UIConstraints: *Fold Stitch *Model C3351i
*UIConstraints: *Fold Stitch *Model C4001i
*UIConstraints: *Fold Stitch *Model C3301i
*UIConstraints: *Fold Stitch *Model C3321i
*UIConstraints: *Fold Stitch *Model C286i
*UIConstraints: *Fold Stitch *Model C266i
*UIConstraints: *Fold Stitch *Model C226i
*UIConstraints: *Fold Stitch *Model C4050i
*UIConstraints: *Fold Stitch *Model C3350i
*UIConstraints: *Fold Stitch *Model C4000i
*UIConstraints: *Fold Stitch *Model C3300i
*UIConstraints: *Fold Stitch *Model C3320i
*UIConstraints: *Fold HalfFold *Offset True
*UIConstraints: *Fold HalfFold *MediaType Plain(2nd)
*UIConstraints: *Fold HalfFold *MediaType PlainPlus(2nd)
*UIConstraints: *Fold HalfFold *MediaType Thick1(2nd)
*UIConstraints: *Fold HalfFold *MediaType Thick1Plus(2nd)
*UIConstraints: *Fold HalfFold *MediaType Thick2(2nd)
*UIConstraints: *Fold HalfFold *MediaType Thick3
*UIConstraints: *Fold HalfFold *MediaType Thick3(2nd)
*UIConstraints: *Fold HalfFold *MediaType Thick4
*UIConstraints: *Fold HalfFold *MediaType Thick4(2nd)
*UIConstraints: *Fold HalfFold *MediaType Envelope
*UIConstraints: *Fold HalfFold *MediaType Transparency
*UIConstraints: *Fold HalfFold *MediaType TAB
*UIConstraints: *Fold HalfFold *MediaType Recycled(2nd)
*UIConstraints: *Fold HalfFold *MediaType User1(2nd)
*UIConstraints: *Fold HalfFold *MediaType User2(2nd)_1
*UIConstraints: *Fold HalfFold *MediaType User2(2nd)
*UIConstraints: *Fold HalfFold *MediaType User3(2nd)
*UIConstraints: *Fold HalfFold *MediaType User4(2nd)
*UIConstraints: *Fold HalfFold *MediaType User5(2nd)
*UIConstraints: *Fold HalfFold *MediaType User6
*UIConstraints: *Fold HalfFold *MediaType User6(2nd)
*UIConstraints: *Fold HalfFold *MediaType User7(2nd)
*UIConstraints: *Fold HalfFold *PageSize A6
*UIConstraints: *Fold HalfFold *PageSize B6
*UIConstraints: *Fold HalfFold *PageSize 8x13
*UIConstraints: *Fold HalfFold *PageSize 8.25x13
*UIConstraints: *Fold HalfFold *PageSize 8.125x13.25
*UIConstraints: *Fold HalfFold *PageSize Executive
*UIConstraints: *Fold HalfFold *PageSize EnvISOB5
*UIConstraints: *Fold HalfFold *PageSize EnvC5
*UIConstraints: *Fold HalfFold *PageSize EnvC6
*UIConstraints: *Fold HalfFold *PageSize EnvChou3
*UIConstraints: *Fold HalfFold *PageSize EnvChou4
*UIConstraints: *Fold HalfFold *PageSize EnvYou3
*UIConstraints: *Fold HalfFold *PageSize EnvYou4
*UIConstraints: *Fold HalfFold *PageSize EnvKaku3
*UIConstraints: *Fold HalfFold *PageSize EnvDL
*UIConstraints: *Fold HalfFold *PageSize EnvMonarch
*UIConstraints: *Fold HalfFold *PageSize Env10
*UIConstraints: *Fold HalfFold *PageSize JapanesePostCard
*UIConstraints: *Fold HalfFold *PageSize 4x6_PostCard
*UIConstraints: *Fold HalfFold *PageSize LetterTab-F
*UIConstraints: *Fold HalfFold *PageSize A4Tab-F
*UIConstraints: *Fold HalfFold *OutputBin Tray1
*UIConstraints: *Fold HalfFold *OutputBin Tray2
*UIConstraints: *Fold HalfFold *OutputBin Tray3
*UIConstraints: *Fold HalfFold *OutputBin Tray4
*UIConstraints: *Fold HalfFold *Staple 1StapleAuto(Left)
*UIConstraints: *Fold HalfFold *Staple 1StapleZeroLeft
*UIConstraints: *Fold HalfFold *Staple 1StapleAuto(Right)
*UIConstraints: *Fold HalfFold *Staple 1StapleZeroRight
*UIConstraints: *Fold HalfFold *Staple 2Staples
*UIConstraints: *Fold HalfFold *Punch 2holes
*UIConstraints: *Fold HalfFold *Punch 3holes
*UIConstraints: *Fold HalfFold *Punch 4holes
*UIConstraints: *Fold HalfFold *BackCoverPage Printed
*UIConstraints: *Fold HalfFold *BackCoverPage Blank
*UIConstraints: *Fold HalfFold *PIBackCover PITray1
*UIConstraints: *Fold HalfFold *PIBackCover PITray2
*UIConstraints: *Fold HalfFold *GlossyMode True
*UIConstraints: *Fold HalfFold *SaddleUnit None
*UIConstraints: *Fold HalfFold *Model C4051i
*UIConstraints: *Fold HalfFold *Model C3351i
*UIConstraints: *Fold HalfFold *Model C4001i
*UIConstraints: *Fold HalfFold *Model C3301i
*UIConstraints: *Fold HalfFold *Model C3321i
*UIConstraints: *Fold HalfFold *Model C286i
*UIConstraints: *Fold HalfFold *Model C266i
*UIConstraints: *Fold HalfFold *Model C226i
*UIConstraints: *Fold HalfFold *Model C4050i
*UIConstraints: *Fold HalfFold *Model C3350i
*UIConstraints: *Fold HalfFold *Model C4000i
*UIConstraints: *Fold HalfFold *Model C3300i
*UIConstraints: *Fold HalfFold *Model C3320i
*UIConstraints: *Fold TriFold *Offset True
*UIConstraints: *Fold TriFold *MediaType PlainPlus(2nd)
*UIConstraints: *Fold TriFold *MediaType Thick1(2nd)
*UIConstraints: *Fold TriFold *MediaType Thick1Plus
*UIConstraints: *Fold TriFold *MediaType Thick1Plus(2nd)
*UIConstraints: *Fold TriFold *MediaType Thick2
*UIConstraints: *Fold TriFold *MediaType Thick2(2nd)
*UIConstraints: *Fold TriFold *MediaType Thick3
*UIConstraints: *Fold TriFold *MediaType Thick3(2nd)
*UIConstraints: *Fold TriFold *MediaType Thick4
*UIConstraints: *Fold TriFold *MediaType Thick4(2nd)
*UIConstraints: *Fold TriFold *MediaType Envelope
*UIConstraints: *Fold TriFold *MediaType Transparency
*UIConstraints: *Fold TriFold *MediaType TAB
*UIConstraints: *Fold TriFold *MediaType Recycled(2nd)
*UIConstraints: *Fold TriFold *MediaType User2(2nd)
*UIConstraints: *Fold TriFold *MediaType User3(2nd)
*UIConstraints: *Fold TriFold *MediaType User4
*UIConstraints: *Fold TriFold *MediaType User4(2nd)
*UIConstraints: *Fold TriFold *MediaType User5
*UIConstraints: *Fold TriFold *MediaType User5(2nd)
*UIConstraints: *Fold TriFold *MediaType User6
*UIConstraints: *Fold TriFold *MediaType User6(2nd)
*UIConstraints: *Fold TriFold *MediaType User7
*UIConstraints: *Fold TriFold *MediaType User7(2nd)
*UIConstraints: *Fold TriFold *PageSize A3
*UIConstraints: *Fold TriFold *PageSize A5
*UIConstraints: *Fold TriFold *PageSize A6
*UIConstraints: *Fold TriFold *PageSize B4
*UIConstraints: *Fold TriFold *PageSize B5
*UIConstraints: *Fold TriFold *PageSize B6
*UIConstraints: *Fold TriFold *PageSize SRA3
*UIConstraints: *Fold TriFold *PageSize 220mmx330mm
*UIConstraints: *Fold TriFold *PageSize 12x18
*UIConstraints: *Fold TriFold *PageSize Tabloid
*UIConstraints: *Fold TriFold *PageSize Legal
*UIConstraints: *Fold TriFold *PageSize Statement
*UIConstraints: *Fold TriFold *PageSize 8x13
*UIConstraints: *Fold TriFold *PageSize 8.5x13
*UIConstraints: *Fold TriFold *PageSize 8.5x13.5
*UIConstraints: *Fold TriFold *PageSize 8.25x13
*UIConstraints: *Fold TriFold *PageSize 8.125x13.25
*UIConstraints: *Fold TriFold *PageSize Executive
*UIConstraints: *Fold TriFold *PageSize 8K
*UIConstraints: *Fold TriFold *PageSize EnvISOB5
*UIConstraints: *Fold TriFold *PageSize EnvC4
*UIConstraints: *Fold TriFold *PageSize EnvC5
*UIConstraints: *Fold TriFold *PageSize EnvC6
*UIConstraints: *Fold TriFold *PageSize EnvChou3
*UIConstraints: *Fold TriFold *PageSize EnvChou4
*UIConstraints: *Fold TriFold *PageSize EnvYou3
*UIConstraints: *Fold TriFold *PageSize EnvYou4
*UIConstraints: *Fold TriFold *PageSize EnvKaku1
*UIConstraints: *Fold TriFold *PageSize EnvKaku2
*UIConstraints: *Fold TriFold *PageSize EnvKaku3
*UIConstraints: *Fold TriFold *PageSize EnvDL
*UIConstraints: *Fold TriFold *PageSize EnvMonarch
*UIConstraints: *Fold TriFold *PageSize Env10
*UIConstraints: *Fold TriFold *PageSize JapanesePostCard
*UIConstraints: *Fold TriFold *PageSize 4x6_PostCard
*UIConstraints: *Fold TriFold *PageSize A3Extra
*UIConstraints: *Fold TriFold *PageSize A4Extra
*UIConstraints: *Fold TriFold *PageSize A5Extra
*UIConstraints: *Fold TriFold *PageSize B4Extra
*UIConstraints: *Fold TriFold *PageSize B5Extra
*UIConstraints: *Fold TriFold *PageSize TabloidExtra
*UIConstraints: *Fold TriFold *PageSize LetterExtra
*UIConstraints: *Fold TriFold *PageSize StatementExtra
*UIConstraints: *Fold TriFold *PageSize LetterTab-F
*UIConstraints: *Fold TriFold *PageSize A4Tab-F
*UIConstraints: *Fold TriFold *OutputBin Tray1
*UIConstraints: *Fold TriFold *OutputBin Tray2
*UIConstraints: *Fold TriFold *OutputBin Tray3
*UIConstraints: *Fold TriFold *OutputBin Tray4
*UIConstraints: *Fold TriFold *Combination Booklet
*UIConstraints: *Fold TriFold *Staple 1StapleAuto(Left)
*UIConstraints: *Fold TriFold *Staple 1StapleZeroLeft
*UIConstraints: *Fold TriFold *Staple 1StapleAuto(Right)
*UIConstraints: *Fold TriFold *Staple 1StapleZeroRight
*UIConstraints: *Fold TriFold *Staple 2Staples
*UIConstraints: *Fold TriFold *Punch 2holes
*UIConstraints: *Fold TriFold *Punch 3holes
*UIConstraints: *Fold TriFold *Punch 4holes
*UIConstraints: *Fold TriFold *PIBackCover PITray1
*UIConstraints: *Fold TriFold *PIBackCover PITray2
*UIConstraints: *Fold TriFold *SaddleUnit None
*UIConstraints: *Fold TriFold *Model C4051i
*UIConstraints: *Fold TriFold *Model C3351i
*UIConstraints: *Fold TriFold *Model C4001i
*UIConstraints: *Fold TriFold *Model C3301i
*UIConstraints: *Fold TriFold *Model C3321i
*UIConstraints: *Fold TriFold *Model C286i
*UIConstraints: *Fold TriFold *Model C266i
*UIConstraints: *Fold TriFold *Model C226i
*UIConstraints: *Fold TriFold *Model C4050i
*UIConstraints: *Fold TriFold *Model C3350i
*UIConstraints: *Fold TriFold *Model C4000i
*UIConstraints: *Fold TriFold *Model C3300i
*UIConstraints: *Fold TriFold *Model C3320i
*UIConstraints: *Fold ZFold1 *MediaType Plain(2nd)
*UIConstraints: *Fold ZFold1 *MediaType PlainPlus
*UIConstraints: *Fold ZFold1 *MediaType PlainPlus(2nd)
*UIConstraints: *Fold ZFold1 *MediaType Thick1
*UIConstraints: *Fold ZFold1 *MediaType Thick1(2nd)
*UIConstraints: *Fold ZFold1 *MediaType Thick1Plus
*UIConstraints: *Fold ZFold1 *MediaType Thick1Plus(2nd)
*UIConstraints: *Fold ZFold1 *MediaType Thick2
*UIConstraints: *Fold ZFold1 *MediaType Thick2(2nd)
*UIConstraints: *Fold ZFold1 *MediaType Thick3
*UIConstraints: *Fold ZFold1 *MediaType Thick3(2nd)
*UIConstraints: *Fold ZFold1 *MediaType Thick4
*UIConstraints: *Fold ZFold1 *MediaType Thick4(2nd)
*UIConstraints: *Fold ZFold1 *MediaType Envelope
*UIConstraints: *Fold ZFold1 *MediaType Transparency
*UIConstraints: *Fold ZFold1 *MediaType Recycled(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User1(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User2
*UIConstraints: *Fold ZFold1 *MediaType User2(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User3
*UIConstraints: *Fold ZFold1 *MediaType User3(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User4
*UIConstraints: *Fold ZFold1 *MediaType User4(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User5
*UIConstraints: *Fold ZFold1 *MediaType User5(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User6
*UIConstraints: *Fold ZFold1 *MediaType User6(2nd)
*UIConstraints: *Fold ZFold1 *MediaType User7
*UIConstraints: *Fold ZFold1 *MediaType User7(2nd)
*UIConstraints: *Fold ZFold1 *OutputBin Tray1
*UIConstraints: *Fold ZFold1 *OutputBin Tray2
*UIConstraints: *Fold ZFold1 *OutputBin Tray3
*UIConstraints: *Fold ZFold1 *OutputBin Tray4
*UIConstraints: *Fold ZFold1 *Combination Booklet
*UIConstraints: *Fold ZFold1 *ZFoldUnit None
*UIConstraints: *Fold ZFold1 *Model C361i
*UIConstraints: *Fold ZFold1 *Model C301i
*UIConstraints: *Fold ZFold1 *Model C251i
*UIConstraints: *Fold ZFold1 *Model C4051i
*UIConstraints: *Fold ZFold1 *Model C3351i
*UIConstraints: *Fold ZFold1 *Model C4001i
*UIConstraints: *Fold ZFold1 *Model C3301i
*UIConstraints: *Fold ZFold1 *Model C3321i
*UIConstraints: *Fold ZFold1 *Model C360i
*UIConstraints: *Fold ZFold1 *Model C300i
*UIConstraints: *Fold ZFold1 *Model C250i
*UIConstraints: *Fold ZFold1 *Model C287i
*UIConstraints: *Fold ZFold1 *Model C257i
*UIConstraints: *Fold ZFold1 *Model C227i
*UIConstraints: *Fold ZFold1 *Model C286i
*UIConstraints: *Fold ZFold1 *Model C266i
*UIConstraints: *Fold ZFold1 *Model C226i
*UIConstraints: *Fold ZFold1 *Model C4050i
*UIConstraints: *Fold ZFold1 *Model C3350i
*UIConstraints: *Fold ZFold1 *Model C4000i
*UIConstraints: *Fold ZFold1 *Model C3300i
*UIConstraints: *Fold ZFold1 *Model C3320i
*UIConstraints: *Fold ZFold2 *MediaType Plain(2nd)
*UIConstraints: *Fold ZFold2 *MediaType PlainPlus
*UIConstraints: *Fold ZFold2 *MediaType PlainPlus(2nd)
*UIConstraints: *Fold ZFold2 *MediaType Thick1
*UIConstraints: *Fold ZFold2 *MediaType Thick1(2nd)
*UIConstraints: *Fold ZFold2 *MediaType Thick1Plus
*UIConstraints: *Fold ZFold2 *MediaType Thick1Plus(2nd)
*UIConstraints: *Fold ZFold2 *MediaType Thick2
*UIConstraints: *Fold ZFold2 *MediaType Thick2(2nd)
*UIConstraints: *Fold ZFold2 *MediaType Thick3
*UIConstraints: *Fold ZFold2 *MediaType Thick3(2nd)
*UIConstraints: *Fold ZFold2 *MediaType Thick4
*UIConstraints: *Fold ZFold2 *MediaType Thick4(2nd)
*UIConstraints: *Fold ZFold2 *MediaType Envelope
*UIConstraints: *Fold ZFold2 *MediaType Transparency
*UIConstraints: *Fold ZFold2 *MediaType Recycled(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User1(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User2
*UIConstraints: *Fold ZFold2 *MediaType User2(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User3
*UIConstraints: *Fold ZFold2 *MediaType User3(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User4
*UIConstraints: *Fold ZFold2 *MediaType User4(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User5
*UIConstraints: *Fold ZFold2 *MediaType User5(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User6
*UIConstraints: *Fold ZFold2 *MediaType User6(2nd)
*UIConstraints: *Fold ZFold2 *MediaType User7
*UIConstraints: *Fold ZFold2 *MediaType User7(2nd)
*UIConstraints: *Fold ZFold2 *OutputBin Tray1
*UIConstraints: *Fold ZFold2 *OutputBin Tray2
*UIConstraints: *Fold ZFold2 *OutputBin Tray3
*UIConstraints: *Fold ZFold2 *OutputBin Tray4
*UIConstraints: *Fold ZFold2 *Combination Booklet
*UIConstraints: *Fold ZFold2 *ZFoldUnit None
*UIConstraints: *Fold ZFold2 *Model C361i
*UIConstraints: *Fold ZFold2 *Model C301i
*UIConstraints: *Fold ZFold2 *Model C251i
*UIConstraints: *Fold ZFold2 *Model C4051i
*UIConstraints: *Fold ZFold2 *Model C3351i
*UIConstraints: *Fold ZFold2 *Model C4001i
*UIConstraints: *Fold ZFold2 *Model C3301i
*UIConstraints: *Fold ZFold2 *Model C3321i
*UIConstraints: *Fold ZFold2 *Model C360i
*UIConstraints: *Fold ZFold2 *Model C300i
*UIConstraints: *Fold ZFold2 *Model C250i
*UIConstraints: *Fold ZFold2 *Model C287i
*UIConstraints: *Fold ZFold2 *Model C257i
*UIConstraints: *Fold ZFold2 *Model C227i
*UIConstraints: *Fold ZFold2 *Model C286i
*UIConstraints: *Fold ZFold2 *Model C266i
*UIConstraints: *Fold ZFold2 *Model C226i
*UIConstraints: *Fold ZFold2 *Model C4050i
*UIConstraints: *Fold ZFold2 *Model C3350i
*UIConstraints: *Fold ZFold2 *Model C4000i
*UIConstraints: *Fold ZFold2 *Model C3300i
*UIConstraints: *Fold ZFold2 *Model C3320i
*UIConstraints: *FrontCoverPage None *FrontCoverTray Tray1
*UIConstraints: *FrontCoverPage None *FrontCoverTray Tray2
*UIConstraints: *FrontCoverPage None *FrontCoverTray Tray3
*UIConstraints: *FrontCoverPage None *FrontCoverTray Tray4
*UIConstraints: *FrontCoverPage None *FrontCoverTray LCT
*UIConstraints: *FrontCoverPage None *FrontCoverTray BypassTray
*UIConstraints: *FrontCoverTray Tray1 *FrontCoverPage None
*UIConstraints: *FrontCoverTray Tray2 *FrontCoverPage None
*UIConstraints: *FrontCoverTray Tray3 *FrontCoverPage None
*UIConstraints: *FrontCoverTray Tray3 *PaperSources LU207
*UIConstraints: *FrontCoverTray Tray3 *PaperSources LU302
*UIConstraints: *FrontCoverTray Tray3 *PaperSources PFP13T2
*UIConstraints: *FrontCoverTray Tray3 *Model C3300i
*UIConstraints: *FrontCoverTray Tray3 *Model C3320i
*UIConstraints: *FrontCoverTray Tray4 *FrontCoverPage None
*UIConstraints: *FrontCoverTray Tray4 *PaperSources LU207
*UIConstraints: *FrontCoverTray Tray4 *PaperSources LU302
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC116
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC116+LU207
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC116+LU302
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC118
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC416
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC416+LU207
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC416+LU302
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PC418
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PFP13T2
*UIConstraints: *FrontCoverTray Tray4 *PaperSources PFP13T23
*UIConstraints: *FrontCoverTray Tray4 *Model C3321i
*UIConstraints: *FrontCoverTray Tray4 *Model C4050i
*UIConstraints: *FrontCoverTray Tray4 *Model C3350i
*UIConstraints: *FrontCoverTray Tray4 *Model C4000i
*UIConstraints: *FrontCoverTray Tray4 *Model C3300i
*UIConstraints: *FrontCoverTray Tray4 *Model C3320i
*UIConstraints: *FrontCoverTray LCT *FrontCoverPage None
*UIConstraints: *FrontCoverTray LCT *PaperSources None
*UIConstraints: *FrontCoverTray LCT *PaperSources PC116
*UIConstraints: *FrontCoverTray LCT *PaperSources PC216
*UIConstraints: *FrontCoverTray LCT *PaperSources PC416
*UIConstraints: *FrontCoverTray LCT *PaperSources PC417
*UIConstraints: *FrontCoverTray LCT *Model C4051i
*UIConstraints: *FrontCoverTray LCT *Model C3351i
*UIConstraints: *FrontCoverTray LCT *Model C4001i
*UIConstraints: *FrontCoverTray LCT *Model C3301i
*UIConstraints: *FrontCoverTray LCT *Model C3321i
*UIConstraints: *FrontCoverTray LCT *Model C287i
*UIConstraints: *FrontCoverTray LCT *Model C257i
*UIConstraints: *FrontCoverTray LCT *Model C227i
*UIConstraints: *FrontCoverTray LCT *Model C286i
*UIConstraints: *FrontCoverTray LCT *Model C266i
*UIConstraints: *FrontCoverTray LCT *Model C226i
*UIConstraints: *FrontCoverTray LCT *Model C4050i
*UIConstraints: *FrontCoverTray LCT *Model C3350i
*UIConstraints: *FrontCoverTray LCT *Model C4000i
*UIConstraints: *FrontCoverTray LCT *Model C3300i
*UIConstraints: *FrontCoverTray LCT *Model C3320i
*UIConstraints: *FrontCoverTray BypassTray *FrontCoverPage None
*UIConstraints: *BackCoverPage None *BackCoverTray Tray1
*UIConstraints: *BackCoverPage None *BackCoverTray Tray2
*UIConstraints: *BackCoverPage None *BackCoverTray Tray3
*UIConstraints: *BackCoverPage None *BackCoverTray Tray4
*UIConstraints: *BackCoverPage None *BackCoverTray LCT
*UIConstraints: *BackCoverPage None *BackCoverTray BypassTray
*UIConstraints: *BackCoverPage Printed *Combination Booklet
*UIConstraints: *BackCoverPage Printed *Fold Stitch
*UIConstraints: *BackCoverPage Printed *Fold HalfFold
*UIConstraints: *BackCoverPage Blank *Combination Booklet
*UIConstraints: *BackCoverPage Blank *Fold Stitch
*UIConstraints: *BackCoverPage Blank *Fold HalfFold
*UIConstraints: *BackCoverTray Tray1 *BackCoverPage None
*UIConstraints: *BackCoverTray Tray2 *BackCoverPage None
*UIConstraints: *BackCoverTray Tray3 *BackCoverPage None
*UIConstraints: *BackCoverTray Tray3 *PaperSources LU207
*UIConstraints: *BackCoverTray Tray3 *PaperSources LU302
*UIConstraints: *BackCoverTray Tray3 *PaperSources PFP13T2
*UIConstraints: *BackCoverTray Tray3 *Model C3300i
*UIConstraints: *BackCoverTray Tray3 *Model C3320i
*UIConstraints: *BackCoverTray Tray4 *BackCoverPage None
*UIConstraints: *BackCoverTray Tray4 *PaperSources LU207
*UIConstraints: *BackCoverTray Tray4 *PaperSources LU302
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC116
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC116+LU207
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC116+LU302
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC118
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC416
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC416+LU207
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC416+LU302
*UIConstraints: *BackCoverTray Tray4 *PaperSources PC418
*UIConstraints: *BackCoverTray Tray4 *PaperSources PFP13T2
*UIConstraints: *BackCoverTray Tray4 *PaperSources PFP13T23
*UIConstraints: *BackCoverTray Tray4 *Model C3321i
*UIConstraints: *BackCoverTray Tray4 *Model C4050i
*UIConstraints: *BackCoverTray Tray4 *Model C3350i
*UIConstraints: *BackCoverTray Tray4 *Model C4000i
*UIConstraints: *BackCoverTray Tray4 *Model C3300i
*UIConstraints: *BackCoverTray Tray4 *Model C3320i
*UIConstraints: *BackCoverTray LCT *BackCoverPage None
*UIConstraints: *BackCoverTray LCT *PaperSources None
*UIConstraints: *BackCoverTray LCT *PaperSources PC116
*UIConstraints: *BackCoverTray LCT *PaperSources PC216
*UIConstraints: *BackCoverTray LCT *PaperSources PC416
*UIConstraints: *BackCoverTray LCT *PaperSources PC417
*UIConstraints: *BackCoverTray LCT *Model C4051i
*UIConstraints: *BackCoverTray LCT *Model C3351i
*UIConstraints: *BackCoverTray LCT *Model C4001i
*UIConstraints: *BackCoverTray LCT *Model C3301i
*UIConstraints: *BackCoverTray LCT *Model C3321i
*UIConstraints: *BackCoverTray LCT *Model C287i
*UIConstraints: *BackCoverTray LCT *Model C257i
*UIConstraints: *BackCoverTray LCT *Model C227i
*UIConstraints: *BackCoverTray LCT *Model C286i
*UIConstraints: *BackCoverTray LCT *Model C266i
*UIConstraints: *BackCoverTray LCT *Model C226i
*UIConstraints: *BackCoverTray LCT *Model C4050i
*UIConstraints: *BackCoverTray LCT *Model C3350i
*UIConstraints: *BackCoverTray LCT *Model C4000i
*UIConstraints: *BackCoverTray LCT *Model C3300i
*UIConstraints: *BackCoverTray LCT *Model C3320i
*UIConstraints: *BackCoverTray BypassTray *BackCoverPage None
*UIConstraints: *PIFrontCover PITray1 *OutputBin Tray1
*UIConstraints: *PIFrontCover PITray1 *OutputBin Tray3
*UIConstraints: *PIFrontCover PITray1 *OutputBin Tray4
*UIConstraints: *PIFrontCover PITray1 *PostInserter None
*UIConstraints: *PIFrontCover PITray1 *Model C361i
*UIConstraints: *PIFrontCover PITray1 *Model C301i
*UIConstraints: *PIFrontCover PITray1 *Model C251i
*UIConstraints: *PIFrontCover PITray1 *Model C4051i
*UIConstraints: *PIFrontCover PITray1 *Model C3351i
*UIConstraints: *PIFrontCover PITray1 *Model C4001i
*UIConstraints: *PIFrontCover PITray1 *Model C3301i
*UIConstraints: *PIFrontCover PITray1 *Model C3321i
*UIConstraints: *PIFrontCover PITray1 *Model C360i
*UIConstraints: *PIFrontCover PITray1 *Model C300i
*UIConstraints: *PIFrontCover PITray1 *Model C250i
*UIConstraints: *PIFrontCover PITray1 *Model C287i
*UIConstraints: *PIFrontCover PITray1 *Model C257i
*UIConstraints: *PIFrontCover PITray1 *Model C227i
*UIConstraints: *PIFrontCover PITray1 *Model C286i
*UIConstraints: *PIFrontCover PITray1 *Model C266i
*UIConstraints: *PIFrontCover PITray1 *Model C226i
*UIConstraints: *PIFrontCover PITray1 *Model C4050i
*UIConstraints: *PIFrontCover PITray1 *Model C3350i
*UIConstraints: *PIFrontCover PITray1 *Model C4000i
*UIConstraints: *PIFrontCover PITray1 *Model C3300i
*UIConstraints: *PIFrontCover PITray1 *Model C3320i
*UIConstraints: *PIFrontCover PITray2 *OutputBin Tray1
*UIConstraints: *PIFrontCover PITray2 *OutputBin Tray3
*UIConstraints: *PIFrontCover PITray2 *OutputBin Tray4
*UIConstraints: *PIFrontCover PITray2 *PostInserter None
*UIConstraints: *PIFrontCover PITray2 *Model C361i
*UIConstraints: *PIFrontCover PITray2 *Model C301i
*UIConstraints: *PIFrontCover PITray2 *Model C251i
*UIConstraints: *PIFrontCover PITray2 *Model C4051i
*UIConstraints: *PIFrontCover PITray2 *Model C3351i
*UIConstraints: *PIFrontCover PITray2 *Model C4001i
*UIConstraints: *PIFrontCover PITray2 *Model C3301i
*UIConstraints: *PIFrontCover PITray2 *Model C3321i
*UIConstraints: *PIFrontCover PITray2 *Model C360i
*UIConstraints: *PIFrontCover PITray2 *Model C300i
*UIConstraints: *PIFrontCover PITray2 *Model C250i
*UIConstraints: *PIFrontCover PITray2 *Model C287i
*UIConstraints: *PIFrontCover PITray2 *Model C257i
*UIConstraints: *PIFrontCover PITray2 *Model C227i
*UIConstraints: *PIFrontCover PITray2 *Model C286i
*UIConstraints: *PIFrontCover PITray2 *Model C266i
*UIConstraints: *PIFrontCover PITray2 *Model C226i
*UIConstraints: *PIFrontCover PITray2 *Model C4050i
*UIConstraints: *PIFrontCover PITray2 *Model C3350i
*UIConstraints: *PIFrontCover PITray2 *Model C4000i
*UIConstraints: *PIFrontCover PITray2 *Model C3300i
*UIConstraints: *PIFrontCover PITray2 *Model C3320i
*UIConstraints: *PIBackCover PITray1 *OutputBin Tray1
*UIConstraints: *PIBackCover PITray1 *OutputBin Tray3
*UIConstraints: *PIBackCover PITray1 *OutputBin Tray4
*UIConstraints: *PIBackCover PITray1 *Combination Booklet
*UIConstraints: *PIBackCover PITray1 *Fold Stitch
*UIConstraints: *PIBackCover PITray1 *Fold HalfFold
*UIConstraints: *PIBackCover PITray1 *Fold TriFold
*UIConstraints: *PIBackCover PITray1 *PostInserter None
*UIConstraints: *PIBackCover PITray1 *Model C361i
*UIConstraints: *PIBackCover PITray1 *Model C301i
*UIConstraints: *PIBackCover PITray1 *Model C251i
*UIConstraints: *PIBackCover PITray1 *Model C4051i
*UIConstraints: *PIBackCover PITray1 *Model C3351i
*UIConstraints: *PIBackCover PITray1 *Model C4001i
*UIConstraints: *PIBackCover PITray1 *Model C3301i
*UIConstraints: *PIBackCover PITray1 *Model C3321i
*UIConstraints: *PIBackCover PITray1 *Model C360i
*UIConstraints: *PIBackCover PITray1 *Model C300i
*UIConstraints: *PIBackCover PITray1 *Model C250i
*UIConstraints: *PIBackCover PITray1 *Model C287i
*UIConstraints: *PIBackCover PITray1 *Model C257i
*UIConstraints: *PIBackCover PITray1 *Model C227i
*UIConstraints: *PIBackCover PITray1 *Model C286i
*UIConstraints: *PIBackCover PITray1 *Model C266i
*UIConstraints: *PIBackCover PITray1 *Model C226i
*UIConstraints: *PIBackCover PITray1 *Model C4050i
*UIConstraints: *PIBackCover PITray1 *Model C3350i
*UIConstraints: *PIBackCover PITray1 *Model C4000i
*UIConstraints: *PIBackCover PITray1 *Model C3300i
*UIConstraints: *PIBackCover PITray1 *Model C3320i
*UIConstraints: *PIBackCover PITray2 *OutputBin Tray1
*UIConstraints: *PIBackCover PITray2 *OutputBin Tray3
*UIConstraints: *PIBackCover PITray2 *OutputBin Tray4
*UIConstraints: *PIBackCover PITray2 *Combination Booklet
*UIConstraints: *PIBackCover PITray2 *Fold Stitch
*UIConstraints: *PIBackCover PITray2 *Fold HalfFold
*UIConstraints: *PIBackCover PITray2 *Fold TriFold
*UIConstraints: *PIBackCover PITray2 *PostInserter None
*UIConstraints: *PIBackCover PITray2 *Model C361i
*UIConstraints: *PIBackCover PITray2 *Model C301i
*UIConstraints: *PIBackCover PITray2 *Model C251i
*UIConstraints: *PIBackCover PITray2 *Model C4051i
*UIConstraints: *PIBackCover PITray2 *Model C3351i
*UIConstraints: *PIBackCover PITray2 *Model C4001i
*UIConstraints: *PIBackCover PITray2 *Model C3301i
*UIConstraints: *PIBackCover PITray2 *Model C3321i
*UIConstraints: *PIBackCover PITray2 *Model C360i
*UIConstraints: *PIBackCover PITray2 *Model C300i
*UIConstraints: *PIBackCover PITray2 *Model C250i
*UIConstraints: *PIBackCover PITray2 *Model C287i
*UIConstraints: *PIBackCover PITray2 *Model C257i
*UIConstraints: *PIBackCover PITray2 *Model C227i
*UIConstraints: *PIBackCover PITray2 *Model C286i
*UIConstraints: *PIBackCover PITray2 *Model C266i
*UIConstraints: *PIBackCover PITray2 *Model C226i
*UIConstraints: *PIBackCover PITray2 *Model C4050i
*UIConstraints: *PIBackCover PITray2 *Model C3350i
*UIConstraints: *PIBackCover PITray2 *Model C4000i
*UIConstraints: *PIBackCover PITray2 *Model C3300i
*UIConstraints: *PIBackCover PITray2 *Model C3320i
*UIConstraints: *TransparencyInterleave None *OHPOpTray Tray1
*UIConstraints: *TransparencyInterleave None *OHPOpTray Tray2
*UIConstraints: *TransparencyInterleave None *OHPOpTray Tray3
*UIConstraints: *TransparencyInterleave None *OHPOpTray Tray4
*UIConstraints: *TransparencyInterleave None *OHPOpTray LCT
*UIConstraints: *TransparencyInterleave Blank *Offset True
*UIConstraints: *TransparencyInterleave Blank *MediaType Plain
*UIConstraints: *TransparencyInterleave Blank *MediaType Plain(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType PlainPlus
*UIConstraints: *TransparencyInterleave Blank *MediaType PlainPlus(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick1
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick1(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick1Plus
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick1Plus(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick2
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick2(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick3
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick3(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick4
*UIConstraints: *TransparencyInterleave Blank *MediaType Thick4(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType Thin
*UIConstraints: *TransparencyInterleave Blank *MediaType Envelope
*UIConstraints: *TransparencyInterleave Blank *MediaType Color
*UIConstraints: *TransparencyInterleave Blank *MediaType SingleSidedOnly
*UIConstraints: *TransparencyInterleave Blank *MediaType TAB
*UIConstraints: *TransparencyInterleave Blank *MediaType Letterhead
*UIConstraints: *TransparencyInterleave Blank *MediaType Special
*UIConstraints: *TransparencyInterleave Blank *MediaType Recycled
*UIConstraints: *TransparencyInterleave Blank *MediaType Recycled(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User1
*UIConstraints: *TransparencyInterleave Blank *MediaType User1(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User2_1
*UIConstraints: *TransparencyInterleave Blank *MediaType User2(2nd)_1
*UIConstraints: *TransparencyInterleave Blank *MediaType User2
*UIConstraints: *TransparencyInterleave Blank *MediaType User2(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User3
*UIConstraints: *TransparencyInterleave Blank *MediaType User3(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User4
*UIConstraints: *TransparencyInterleave Blank *MediaType User4(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User5
*UIConstraints: *TransparencyInterleave Blank *MediaType User5(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User6
*UIConstraints: *TransparencyInterleave Blank *MediaType User6(2nd)
*UIConstraints: *TransparencyInterleave Blank *MediaType User7
*UIConstraints: *TransparencyInterleave Blank *MediaType User7(2nd)
*UIConstraints: *TransparencyInterleave Blank *PageSize Executive
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvISOB5
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvC4
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvC5
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvC6
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvChou3
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvChou4
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvYou3
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvYou4
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvKaku1
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvKaku2
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvKaku3
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvDL
*UIConstraints: *TransparencyInterleave Blank *PageSize EnvMonarch
*UIConstraints: *TransparencyInterleave Blank *PageSize Env10
*UIConstraints: *TransparencyInterleave Blank *PageSize JapanesePostCard
*UIConstraints: *TransparencyInterleave Blank *PageSize 4x6_PostCard
*UIConstraints: *TransparencyInterleave Blank *PageSize LetterTab-F
*UIConstraints: *TransparencyInterleave Blank *PageSize A4Tab-F
*UIConstraints: *TransparencyInterleave Blank *Model C4051i
*UIConstraints: *TransparencyInterleave Blank *Model C3351i
*UIConstraints: *TransparencyInterleave Blank *Model C4001i
*UIConstraints: *TransparencyInterleave Blank *Model C3301i
*UIConstraints: *TransparencyInterleave Blank *Model C3321i
*UIConstraints: *TransparencyInterleave Blank *Model C4050i
*UIConstraints: *TransparencyInterleave Blank *Model C3350i
*UIConstraints: *TransparencyInterleave Blank *Model C4000i
*UIConstraints: *TransparencyInterleave Blank *Model C3300i
*UIConstraints: *TransparencyInterleave Blank *Model C3320i
*UIConstraints: *OHPOpTray Tray1 *TransparencyInterleave None
*UIConstraints: *OHPOpTray Tray1 *Model C4051i
*UIConstraints: *OHPOpTray Tray1 *Model C3351i
*UIConstraints: *OHPOpTray Tray1 *Model C4001i
*UIConstraints: *OHPOpTray Tray1 *Model C3301i
*UIConstraints: *OHPOpTray Tray1 *Model C3321i
*UIConstraints: *OHPOpTray Tray1 *Model C4050i
*UIConstraints: *OHPOpTray Tray1 *Model C3350i
*UIConstraints: *OHPOpTray Tray1 *Model C4000i
*UIConstraints: *OHPOpTray Tray1 *Model C3300i
*UIConstraints: *OHPOpTray Tray1 *Model C3320i
*UIConstraints: *OHPOpTray Tray2 *TransparencyInterleave None
*UIConstraints: *OHPOpTray Tray2 *Model C4051i
*UIConstraints: *OHPOpTray Tray2 *Model C3351i
*UIConstraints: *OHPOpTray Tray2 *Model C4001i
*UIConstraints: *OHPOpTray Tray2 *Model C3301i
*UIConstraints: *OHPOpTray Tray2 *Model C3321i
*UIConstraints: *OHPOpTray Tray2 *Model C4050i
*UIConstraints: *OHPOpTray Tray2 *Model C3350i
*UIConstraints: *OHPOpTray Tray2 *Model C4000i
*UIConstraints: *OHPOpTray Tray2 *Model C3300i
*UIConstraints: *OHPOpTray Tray2 *Model C3320i
*UIConstraints: *OHPOpTray Tray3 *TransparencyInterleave None
*UIConstraints: *OHPOpTray Tray3 *PaperSources LU207
*UIConstraints: *OHPOpTray Tray3 *PaperSources LU302
*UIConstraints: *OHPOpTray Tray3 *Model C4051i
*UIConstraints: *OHPOpTray Tray3 *Model C3351i
*UIConstraints: *OHPOpTray Tray3 *Model C4001i
*UIConstraints: *OHPOpTray Tray3 *Model C3301i
*UIConstraints: *OHPOpTray Tray3 *Model C3321i
*UIConstraints: *OHPOpTray Tray3 *Model C4050i
*UIConstraints: *OHPOpTray Tray3 *Model C3350i
*UIConstraints: *OHPOpTray Tray3 *Model C4000i
*UIConstraints: *OHPOpTray Tray3 *Model C3300i
*UIConstraints: *OHPOpTray Tray3 *Model C3320i
*UIConstraints: *OHPOpTray Tray4 *TransparencyInterleave None
*UIConstraints: *OHPOpTray Tray4 *PaperSources LU207
*UIConstraints: *OHPOpTray Tray4 *PaperSources LU302
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC116
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC116+LU207
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC116+LU302
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC118
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC416
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC416+LU207
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC416+LU302
*UIConstraints: *OHPOpTray Tray4 *PaperSources PC418
*UIConstraints: *OHPOpTray Tray4 *Model C4051i
*UIConstraints: *OHPOpTray Tray4 *Model C3351i
*UIConstraints: *OHPOpTray Tray4 *Model C4001i
*UIConstraints: *OHPOpTray Tray4 *Model C3301i
*UIConstraints: *OHPOpTray Tray4 *Model C3321i
*UIConstraints: *OHPOpTray Tray4 *Model C4050i
*UIConstraints: *OHPOpTray Tray4 *Model C3350i
*UIConstraints: *OHPOpTray Tray4 *Model C4000i
*UIConstraints: *OHPOpTray Tray4 *Model C3300i
*UIConstraints: *OHPOpTray Tray4 *Model C3320i
*UIConstraints: *OHPOpTray LCT *TransparencyInterleave None
*UIConstraints: *OHPOpTray LCT *PaperSources None
*UIConstraints: *OHPOpTray LCT *PaperSources PC116
*UIConstraints: *OHPOpTray LCT *PaperSources PC216
*UIConstraints: *OHPOpTray LCT *PaperSources PC416
*UIConstraints: *OHPOpTray LCT *PaperSources PC417
*UIConstraints: *OHPOpTray LCT *Model C4051i
*UIConstraints: *OHPOpTray LCT *Model C3351i
*UIConstraints: *OHPOpTray LCT *Model C4001i
*UIConstraints: *OHPOpTray LCT *Model C3301i
*UIConstraints: *OHPOpTray LCT *Model C3321i
*UIConstraints: *OHPOpTray LCT *Model C287i
*UIConstraints: *OHPOpTray LCT *Model C257i
*UIConstraints: *OHPOpTray LCT *Model C227i
*UIConstraints: *OHPOpTray LCT *Model C286i
*UIConstraints: *OHPOpTray LCT *Model C266i
*UIConstraints: *OHPOpTray LCT *Model C226i
*UIConstraints: *OHPOpTray LCT *Model C4050i
*UIConstraints: *OHPOpTray LCT *Model C3350i
*UIConstraints: *OHPOpTray LCT *Model C4000i
*UIConstraints: *OHPOpTray LCT *Model C3300i
*UIConstraints: *OHPOpTray LCT *Model C3320i
*UIConstraints: *SelectColor Auto *MediaType Transparency
*UIConstraints: *SelectColor Color *MediaType Transparency
*UIConstraints: *SelectColor Grayscale *AutoTrapping True
*UIConstraints: *SelectColor Grayscale *BlackOverPrint Text
*UIConstraints: *SelectColor Grayscale *BlackOverPrint TextGraphic
*UIConstraints: *SelectColor Grayscale *TextColorMatching Colorimetric
*UIConstraints: *SelectColor Grayscale *PhotoColorMatching Colorimetric
*UIConstraints: *SelectColor Grayscale *GraphicColorMatching Colorimetric
*UIConstraints: *GlossyMode True *MediaType Thick1
*UIConstraints: *GlossyMode True *MediaType Thick1(2nd)
*UIConstraints: *GlossyMode True *MediaType Thick1Plus
*UIConstraints: *GlossyMode True *MediaType Thick1Plus(2nd)
*UIConstraints: *GlossyMode True *MediaType Thick2
*UIConstraints: *GlossyMode True *MediaType Thick2(2nd)
*UIConstraints: *GlossyMode True *MediaType Thick3
*UIConstraints: *GlossyMode True *MediaType Thick3(2nd)
*UIConstraints: *GlossyMode True *MediaType Thick4
*UIConstraints: *GlossyMode True *MediaType Thick4(2nd)
*UIConstraints: *GlossyMode True *MediaType Thin
*UIConstraints: *GlossyMode True *MediaType Envelope
*UIConstraints: *GlossyMode True *MediaType Transparency
*UIConstraints: *GlossyMode True *MediaType TAB
*UIConstraints: *GlossyMode True *MediaType Recycled
*UIConstraints: *GlossyMode True *MediaType Recycled(2nd)
*UIConstraints: *GlossyMode True *MediaType User3
*UIConstraints: *GlossyMode True *MediaType User3(2nd)
*UIConstraints: *GlossyMode True *MediaType User4
*UIConstraints: *GlossyMode True *MediaType User4(2nd)
*UIConstraints: *GlossyMode True *MediaType User5
*UIConstraints: *GlossyMode True *MediaType User5(2nd)
*UIConstraints: *GlossyMode True *MediaType User6
*UIConstraints: *GlossyMode True *MediaType User6(2nd)
*UIConstraints: *GlossyMode True *MediaType User7
*UIConstraints: *GlossyMode True *MediaType User7(2nd)
*UIConstraints: *GlossyMode True *Fold Stitch
*UIConstraints: *GlossyMode True *Fold HalfFold
*UIConstraints: *OriginalImageType CAD *LineWidthAdjustment Thin
*UIConstraints: *OriginalImageType CAD *LineWidthAdjustment SlightlyThin
*UIConstraints: *OriginalImageType CAD *LineWidthAdjustment Normal
*UIConstraints: *OriginalImageType CAD *LineWidthAdjustment SlightlyThick
*UIConstraints: *OriginalImageType CAD *LineWidthAdjustment Thick
*UIConstraints: *AutoTrapping True *SelectColor Grayscale
*UIConstraints: *BlackOverPrint Text *SelectColor Grayscale
*UIConstraints: *BlackOverPrint TextGraphic *SelectColor Grayscale
*UIConstraints: *TextColorMatching Colorimetric *SelectColor Grayscale
*UIConstraints: *PhotoColorMatching Colorimetric *SelectColor Grayscale
*UIConstraints: *GraphicColorMatching Colorimetric *SelectColor Grayscale
*UIConstraints: *LineWidthAdjustment Thin *OriginalImageType CAD
*UIConstraints: *LineWidthAdjustment SlightlyThin *OriginalImageType CAD
*UIConstraints: *LineWidthAdjustment Normal *OriginalImageType CAD
*UIConstraints: *LineWidthAdjustment SlightlyThick *OriginalImageType CAD
*UIConstraints: *LineWidthAdjustment Thick *OriginalImageType CAD
*UIConstraints: *PaperSources None *InputSlot LCT
*UIConstraints: *PaperSources None *FrontCoverTray LCT
*UIConstraints: *PaperSources None *BackCoverTray LCT
*UIConstraints: *PaperSources None *OHPOpTray LCT
*UIConstraints: *PaperSources LU207 *InputSlot Tray3
*UIConstraints: *PaperSources LU207 *InputSlot Tray4
*UIConstraints: *PaperSources LU207 *FrontCoverTray Tray3
*UIConstraints: *PaperSources LU207 *FrontCoverTray Tray4
*UIConstraints: *PaperSources LU207 *BackCoverTray Tray3
*UIConstraints: *PaperSources LU207 *BackCoverTray Tray4
*UIConstraints: *PaperSources LU207 *OHPOpTray Tray3
*UIConstraints: *PaperSources LU207 *OHPOpTray Tray4
*UIConstraints: *PaperSources LU207 *Model C751i
*UIConstraints: *PaperSources LU207 *Model C361i
*UIConstraints: *PaperSources LU207 *Model C301i
*UIConstraints: *PaperSources LU207 *Model C251i
*UIConstraints: *PaperSources LU207 *Model C4051i
*UIConstraints: *PaperSources LU207 *Model C3351i
*UIConstraints: *PaperSources LU207 *Model C4001i
*UIConstraints: *PaperSources LU207 *Model C3301i
*UIConstraints: *PaperSources LU207 *Model C3321i
*UIConstraints: *PaperSources LU207 *Model C750i
*UIConstraints: *PaperSources LU207 *Model C360i
*UIConstraints: *PaperSources LU207 *Model C300i
*UIConstraints: *PaperSources LU207 *Model C250i
*UIConstraints: *PaperSources LU207 *Model C287i
*UIConstraints: *PaperSources LU207 *Model C257i
*UIConstraints: *PaperSources LU207 *Model C227i
*UIConstraints: *PaperSources LU207 *Model C286i
*UIConstraints: *PaperSources LU207 *Model C266i
*UIConstraints: *PaperSources LU207 *Model C226i
*UIConstraints: *PaperSources LU207 *Model C4050i
*UIConstraints: *PaperSources LU207 *Model C3350i
*UIConstraints: *PaperSources LU207 *Model C4000i
*UIConstraints: *PaperSources LU207 *Model C3300i
*UIConstraints: *PaperSources LU207 *Model C3320i
*UIConstraints: *PaperSources LU302 *InputSlot Tray3
*UIConstraints: *PaperSources LU302 *InputSlot Tray4
*UIConstraints: *PaperSources LU302 *FrontCoverTray Tray3
*UIConstraints: *PaperSources LU302 *FrontCoverTray Tray4
*UIConstraints: *PaperSources LU302 *BackCoverTray Tray3
*UIConstraints: *PaperSources LU302 *BackCoverTray Tray4
*UIConstraints: *PaperSources LU302 *OHPOpTray Tray3
*UIConstraints: *PaperSources LU302 *OHPOpTray Tray4
*UIConstraints: *PaperSources LU302 *Model C751i
*UIConstraints: *PaperSources LU302 *Model C4051i
*UIConstraints: *PaperSources LU302 *Model C3351i
*UIConstraints: *PaperSources LU302 *Model C4001i
*UIConstraints: *PaperSources LU302 *Model C3301i
*UIConstraints: *PaperSources LU302 *Model C3321i
*UIConstraints: *PaperSources LU302 *Model C750i
*UIConstraints: *PaperSources LU302 *Model C287i
*UIConstraints: *PaperSources LU302 *Model C257i
*UIConstraints: *PaperSources LU302 *Model C227i
*UIConstraints: *PaperSources LU302 *Model C286i
*UIConstraints: *PaperSources LU302 *Model C266i
*UIConstraints: *PaperSources LU302 *Model C226i
*UIConstraints: *PaperSources LU302 *Model C4050i
*UIConstraints: *PaperSources LU302 *Model C3350i
*UIConstraints: *PaperSources LU302 *Model C4000i
*UIConstraints: *PaperSources LU302 *Model C3300i
*UIConstraints: *PaperSources LU302 *Model C3320i
*UIConstraints: *PaperSources LU205 *Model C651i
*UIConstraints: *PaperSources LU205 *Model C551i
*UIConstraints: *PaperSources LU205 *Model C451i
*UIConstraints: *PaperSources LU205 *Model C361i
*UIConstraints: *PaperSources LU205 *Model C301i
*UIConstraints: *PaperSources LU205 *Model C251i
*UIConstraints: *PaperSources LU205 *Model C4051i
*UIConstraints: *PaperSources LU205 *Model C3351i
*UIConstraints: *PaperSources LU205 *Model C4001i
*UIConstraints: *PaperSources LU205 *Model C3301i
*UIConstraints: *PaperSources LU205 *Model C3321i
*UIConstraints: *PaperSources LU205 *Model C650i
*UIConstraints: *PaperSources LU205 *Model C550i
*UIConstraints: *PaperSources LU205 *Model C450i
*UIConstraints: *PaperSources LU205 *Model C360i
*UIConstraints: *PaperSources LU205 *Model C300i
*UIConstraints: *PaperSources LU205 *Model C250i
*UIConstraints: *PaperSources LU205 *Model C287i
*UIConstraints: *PaperSources LU205 *Model C257i
*UIConstraints: *PaperSources LU205 *Model C227i
*UIConstraints: *PaperSources LU205 *Model C286i
*UIConstraints: *PaperSources LU205 *Model C266i
*UIConstraints: *PaperSources LU205 *Model C226i
*UIConstraints: *PaperSources LU205 *Model C4050i
*UIConstraints: *PaperSources LU205 *Model C3350i
*UIConstraints: *PaperSources LU205 *Model C4000i
*UIConstraints: *PaperSources LU205 *Model C3300i
*UIConstraints: *PaperSources LU205 *Model C3320i
*UIConstraints: *PaperSources LU303 *Model C651i
*UIConstraints: *PaperSources LU303 *Model C551i
*UIConstraints: *PaperSources LU303 *Model C451i
*UIConstraints: *PaperSources LU303 *Model C361i
*UIConstraints: *PaperSources LU303 *Model C301i
*UIConstraints: *PaperSources LU303 *Model C251i
*UIConstraints: *PaperSources LU303 *Model C4051i
*UIConstraints: *PaperSources LU303 *Model C3351i
*UIConstraints: *PaperSources LU303 *Model C4001i
*UIConstraints: *PaperSources LU303 *Model C3301i
*UIConstraints: *PaperSources LU303 *Model C3321i
*UIConstraints: *PaperSources LU303 *Model C650i
*UIConstraints: *PaperSources LU303 *Model C550i
*UIConstraints: *PaperSources LU303 *Model C450i
*UIConstraints: *PaperSources LU303 *Model C360i
*UIConstraints: *PaperSources LU303 *Model C300i
*UIConstraints: *PaperSources LU303 *Model C250i
*UIConstraints: *PaperSources LU303 *Model C287i
*UIConstraints: *PaperSources LU303 *Model C257i
*UIConstraints: *PaperSources LU303 *Model C227i
*UIConstraints: *PaperSources LU303 *Model C286i
*UIConstraints: *PaperSources LU303 *Model C266i
*UIConstraints: *PaperSources LU303 *Model C226i
*UIConstraints: *PaperSources LU303 *Model C4050i
*UIConstraints: *PaperSources LU303 *Model C3350i
*UIConstraints: *PaperSources LU303 *Model C4000i
*UIConstraints: *PaperSources LU303 *Model C3300i
*UIConstraints: *PaperSources LU303 *Model C3320i
*UIConstraints: *PaperSources PC116 *InputSlot Tray4
*UIConstraints: *PaperSources PC116 *InputSlot LCT
*UIConstraints: *PaperSources PC116 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC116 *FrontCoverTray LCT
*UIConstraints: *PaperSources PC116 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC116 *BackCoverTray LCT
*UIConstraints: *PaperSources PC116 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC116 *OHPOpTray LCT
*UIConstraints: *PaperSources PC116 *Model C751i
*UIConstraints: *PaperSources PC116 *Model C4051i
*UIConstraints: *PaperSources PC116 *Model C3351i
*UIConstraints: *PaperSources PC116 *Model C4001i
*UIConstraints: *PaperSources PC116 *Model C3301i
*UIConstraints: *PaperSources PC116 *Model C3321i
*UIConstraints: *PaperSources PC116 *Model C750i
*UIConstraints: *PaperSources PC116 *Model C287i
*UIConstraints: *PaperSources PC116 *Model C257i
*UIConstraints: *PaperSources PC116 *Model C227i
*UIConstraints: *PaperSources PC116 *Model C286i
*UIConstraints: *PaperSources PC116 *Model C266i
*UIConstraints: *PaperSources PC116 *Model C226i
*UIConstraints: *PaperSources PC116 *Model C4050i
*UIConstraints: *PaperSources PC116 *Model C3350i
*UIConstraints: *PaperSources PC116 *Model C4000i
*UIConstraints: *PaperSources PC116 *Model C3300i
*UIConstraints: *PaperSources PC116 *Model C3320i
*UIConstraints: *PaperSources PC116+LU207 *InputSlot Tray4
*UIConstraints: *PaperSources PC116+LU207 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC116+LU207 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC116+LU207 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC116+LU207 *Model C751i
*UIConstraints: *PaperSources PC116+LU207 *Model C361i
*UIConstraints: *PaperSources PC116+LU207 *Model C301i
*UIConstraints: *PaperSources PC116+LU207 *Model C251i
*UIConstraints: *PaperSources PC116+LU207 *Model C4051i
*UIConstraints: *PaperSources PC116+LU207 *Model C3351i
*UIConstraints: *PaperSources PC116+LU207 *Model C4001i
*UIConstraints: *PaperSources PC116+LU207 *Model C3301i
*UIConstraints: *PaperSources PC116+LU207 *Model C3321i
*UIConstraints: *PaperSources PC116+LU207 *Model C750i
*UIConstraints: *PaperSources PC116+LU207 *Model C360i
*UIConstraints: *PaperSources PC116+LU207 *Model C300i
*UIConstraints: *PaperSources PC116+LU207 *Model C250i
*UIConstraints: *PaperSources PC116+LU207 *Model C287i
*UIConstraints: *PaperSources PC116+LU207 *Model C257i
*UIConstraints: *PaperSources PC116+LU207 *Model C227i
*UIConstraints: *PaperSources PC116+LU207 *Model C286i
*UIConstraints: *PaperSources PC116+LU207 *Model C266i
*UIConstraints: *PaperSources PC116+LU207 *Model C226i
*UIConstraints: *PaperSources PC116+LU207 *Model C4050i
*UIConstraints: *PaperSources PC116+LU207 *Model C3350i
*UIConstraints: *PaperSources PC116+LU207 *Model C4000i
*UIConstraints: *PaperSources PC116+LU207 *Model C3300i
*UIConstraints: *PaperSources PC116+LU207 *Model C3320i
*UIConstraints: *PaperSources PC116+LU302 *InputSlot Tray4
*UIConstraints: *PaperSources PC116+LU302 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC116+LU302 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC116+LU302 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC116+LU302 *Model C751i
*UIConstraints: *PaperSources PC116+LU302 *Model C4051i
*UIConstraints: *PaperSources PC116+LU302 *Model C3351i
*UIConstraints: *PaperSources PC116+LU302 *Model C4001i
*UIConstraints: *PaperSources PC116+LU302 *Model C3301i
*UIConstraints: *PaperSources PC116+LU302 *Model C3321i
*UIConstraints: *PaperSources PC116+LU302 *Model C750i
*UIConstraints: *PaperSources PC116+LU302 *Model C287i
*UIConstraints: *PaperSources PC116+LU302 *Model C257i
*UIConstraints: *PaperSources PC116+LU302 *Model C227i
*UIConstraints: *PaperSources PC116+LU302 *Model C286i
*UIConstraints: *PaperSources PC116+LU302 *Model C266i
*UIConstraints: *PaperSources PC116+LU302 *Model C226i
*UIConstraints: *PaperSources PC116+LU302 *Model C4050i
*UIConstraints: *PaperSources PC116+LU302 *Model C3350i
*UIConstraints: *PaperSources PC116+LU302 *Model C4000i
*UIConstraints: *PaperSources PC116+LU302 *Model C3300i
*UIConstraints: *PaperSources PC116+LU302 *Model C3320i
*UIConstraints: *PaperSources PC118 *InputSlot Tray4
*UIConstraints: *PaperSources PC118 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC118 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC118 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC118 *Model C751i
*UIConstraints: *PaperSources PC118 *Model C651i
*UIConstraints: *PaperSources PC118 *Model C551i
*UIConstraints: *PaperSources PC118 *Model C451i
*UIConstraints: *PaperSources PC118 *Model C361i
*UIConstraints: *PaperSources PC118 *Model C301i
*UIConstraints: *PaperSources PC118 *Model C251i
*UIConstraints: *PaperSources PC118 *Model C4051i
*UIConstraints: *PaperSources PC118 *Model C3351i
*UIConstraints: *PaperSources PC118 *Model C4001i
*UIConstraints: *PaperSources PC118 *Model C3301i
*UIConstraints: *PaperSources PC118 *Model C3321i
*UIConstraints: *PaperSources PC118 *Model C750i
*UIConstraints: *PaperSources PC118 *Model C650i
*UIConstraints: *PaperSources PC118 *Model C550i
*UIConstraints: *PaperSources PC118 *Model C450i
*UIConstraints: *PaperSources PC118 *Model C360i
*UIConstraints: *PaperSources PC118 *Model C300i
*UIConstraints: *PaperSources PC118 *Model C250i
*UIConstraints: *PaperSources PC118 *Model C4050i
*UIConstraints: *PaperSources PC118 *Model C3350i
*UIConstraints: *PaperSources PC118 *Model C4000i
*UIConstraints: *PaperSources PC118 *Model C3300i
*UIConstraints: *PaperSources PC118 *Model C3320i
*UIConstraints: *PaperSources PC216 *InputSlot LCT
*UIConstraints: *PaperSources PC216 *FrontCoverTray LCT
*UIConstraints: *PaperSources PC216 *BackCoverTray LCT
*UIConstraints: *PaperSources PC216 *OHPOpTray LCT
*UIConstraints: *PaperSources PC216 *Model C751i
*UIConstraints: *PaperSources PC216 *Model C4051i
*UIConstraints: *PaperSources PC216 *Model C3351i
*UIConstraints: *PaperSources PC216 *Model C4001i
*UIConstraints: *PaperSources PC216 *Model C3301i
*UIConstraints: *PaperSources PC216 *Model C3321i
*UIConstraints: *PaperSources PC216 *Model C750i
*UIConstraints: *PaperSources PC216 *Model C287i
*UIConstraints: *PaperSources PC216 *Model C257i
*UIConstraints: *PaperSources PC216 *Model C227i
*UIConstraints: *PaperSources PC216 *Model C286i
*UIConstraints: *PaperSources PC216 *Model C266i
*UIConstraints: *PaperSources PC216 *Model C226i
*UIConstraints: *PaperSources PC216 *Model C4050i
*UIConstraints: *PaperSources PC216 *Model C3350i
*UIConstraints: *PaperSources PC216 *Model C4000i
*UIConstraints: *PaperSources PC216 *Model C3300i
*UIConstraints: *PaperSources PC216 *Model C3320i
*UIConstraints: *PaperSources PC216+LU207 *Model C751i
*UIConstraints: *PaperSources PC216+LU207 *Model C361i
*UIConstraints: *PaperSources PC216+LU207 *Model C301i
*UIConstraints: *PaperSources PC216+LU207 *Model C251i
*UIConstraints: *PaperSources PC216+LU207 *Model C4051i
*UIConstraints: *PaperSources PC216+LU207 *Model C3351i
*UIConstraints: *PaperSources PC216+LU207 *Model C4001i
*UIConstraints: *PaperSources PC216+LU207 *Model C3301i
*UIConstraints: *PaperSources PC216+LU207 *Model C3321i
*UIConstraints: *PaperSources PC216+LU207 *Model C750i
*UIConstraints: *PaperSources PC216+LU207 *Model C360i
*UIConstraints: *PaperSources PC216+LU207 *Model C300i
*UIConstraints: *PaperSources PC216+LU207 *Model C250i
*UIConstraints: *PaperSources PC216+LU207 *Model C287i
*UIConstraints: *PaperSources PC216+LU207 *Model C257i
*UIConstraints: *PaperSources PC216+LU207 *Model C227i
*UIConstraints: *PaperSources PC216+LU207 *Model C286i
*UIConstraints: *PaperSources PC216+LU207 *Model C266i
*UIConstraints: *PaperSources PC216+LU207 *Model C226i
*UIConstraints: *PaperSources PC216+LU207 *Model C4050i
*UIConstraints: *PaperSources PC216+LU207 *Model C3350i
*UIConstraints: *PaperSources PC216+LU207 *Model C4000i
*UIConstraints: *PaperSources PC216+LU207 *Model C3300i
*UIConstraints: *PaperSources PC216+LU207 *Model C3320i
*UIConstraints: *PaperSources PC216+LU302 *Model C751i
*UIConstraints: *PaperSources PC216+LU302 *Model C4051i
*UIConstraints: *PaperSources PC216+LU302 *Model C3351i
*UIConstraints: *PaperSources PC216+LU302 *Model C4001i
*UIConstraints: *PaperSources PC216+LU302 *Model C3301i
*UIConstraints: *PaperSources PC216+LU302 *Model C3321i
*UIConstraints: *PaperSources PC216+LU302 *Model C750i
*UIConstraints: *PaperSources PC216+LU302 *Model C287i
*UIConstraints: *PaperSources PC216+LU302 *Model C257i
*UIConstraints: *PaperSources PC216+LU302 *Model C227i
*UIConstraints: *PaperSources PC216+LU302 *Model C286i
*UIConstraints: *PaperSources PC216+LU302 *Model C266i
*UIConstraints: *PaperSources PC216+LU302 *Model C226i
*UIConstraints: *PaperSources PC216+LU302 *Model C4050i
*UIConstraints: *PaperSources PC216+LU302 *Model C3350i
*UIConstraints: *PaperSources PC216+LU302 *Model C4000i
*UIConstraints: *PaperSources PC216+LU302 *Model C3300i
*UIConstraints: *PaperSources PC216+LU302 *Model C3320i
*UIConstraints: *PaperSources PC218 *Model C751i
*UIConstraints: *PaperSources PC218 *Model C651i
*UIConstraints: *PaperSources PC218 *Model C551i
*UIConstraints: *PaperSources PC218 *Model C451i
*UIConstraints: *PaperSources PC218 *Model C361i
*UIConstraints: *PaperSources PC218 *Model C301i
*UIConstraints: *PaperSources PC218 *Model C251i
*UIConstraints: *PaperSources PC218 *Model C4051i
*UIConstraints: *PaperSources PC218 *Model C3351i
*UIConstraints: *PaperSources PC218 *Model C4001i
*UIConstraints: *PaperSources PC218 *Model C3301i
*UIConstraints: *PaperSources PC218 *Model C3321i
*UIConstraints: *PaperSources PC218 *Model C750i
*UIConstraints: *PaperSources PC218 *Model C650i
*UIConstraints: *PaperSources PC218 *Model C550i
*UIConstraints: *PaperSources PC218 *Model C450i
*UIConstraints: *PaperSources PC218 *Model C360i
*UIConstraints: *PaperSources PC218 *Model C300i
*UIConstraints: *PaperSources PC218 *Model C250i
*UIConstraints: *PaperSources PC218 *Model C4050i
*UIConstraints: *PaperSources PC218 *Model C3350i
*UIConstraints: *PaperSources PC218 *Model C4000i
*UIConstraints: *PaperSources PC218 *Model C3300i
*UIConstraints: *PaperSources PC218 *Model C3320i
*UIConstraints: *PaperSources PC416 *InputSlot Tray4
*UIConstraints: *PaperSources PC416 *InputSlot LCT
*UIConstraints: *PaperSources PC416 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC416 *FrontCoverTray LCT
*UIConstraints: *PaperSources PC416 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC416 *BackCoverTray LCT
*UIConstraints: *PaperSources PC416 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC416 *OHPOpTray LCT
*UIConstraints: *PaperSources PC416 *Model C751i
*UIConstraints: *PaperSources PC416 *Model C4051i
*UIConstraints: *PaperSources PC416 *Model C3351i
*UIConstraints: *PaperSources PC416 *Model C4001i
*UIConstraints: *PaperSources PC416 *Model C3301i
*UIConstraints: *PaperSources PC416 *Model C3321i
*UIConstraints: *PaperSources PC416 *Model C750i
*UIConstraints: *PaperSources PC416 *Model C287i
*UIConstraints: *PaperSources PC416 *Model C257i
*UIConstraints: *PaperSources PC416 *Model C227i
*UIConstraints: *PaperSources PC416 *Model C286i
*UIConstraints: *PaperSources PC416 *Model C266i
*UIConstraints: *PaperSources PC416 *Model C226i
*UIConstraints: *PaperSources PC416 *Model C4050i
*UIConstraints: *PaperSources PC416 *Model C3350i
*UIConstraints: *PaperSources PC416 *Model C4000i
*UIConstraints: *PaperSources PC416 *Model C3300i
*UIConstraints: *PaperSources PC416 *Model C3320i
*UIConstraints: *PaperSources PC416+LU207 *InputSlot Tray4
*UIConstraints: *PaperSources PC416+LU207 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC416+LU207 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC416+LU207 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC416+LU207 *Model C751i
*UIConstraints: *PaperSources PC416+LU207 *Model C361i
*UIConstraints: *PaperSources PC416+LU207 *Model C301i
*UIConstraints: *PaperSources PC416+LU207 *Model C251i
*UIConstraints: *PaperSources PC416+LU207 *Model C4051i
*UIConstraints: *PaperSources PC416+LU207 *Model C3351i
*UIConstraints: *PaperSources PC416+LU207 *Model C4001i
*UIConstraints: *PaperSources PC416+LU207 *Model C3301i
*UIConstraints: *PaperSources PC416+LU207 *Model C3321i
*UIConstraints: *PaperSources PC416+LU207 *Model C750i
*UIConstraints: *PaperSources PC416+LU207 *Model C360i
*UIConstraints: *PaperSources PC416+LU207 *Model C300i
*UIConstraints: *PaperSources PC416+LU207 *Model C250i
*UIConstraints: *PaperSources PC416+LU207 *Model C287i
*UIConstraints: *PaperSources PC416+LU207 *Model C257i
*UIConstraints: *PaperSources PC416+LU207 *Model C227i
*UIConstraints: *PaperSources PC416+LU207 *Model C286i
*UIConstraints: *PaperSources PC416+LU207 *Model C266i
*UIConstraints: *PaperSources PC416+LU207 *Model C226i
*UIConstraints: *PaperSources PC416+LU207 *Model C4050i
*UIConstraints: *PaperSources PC416+LU207 *Model C3350i
*UIConstraints: *PaperSources PC416+LU207 *Model C4000i
*UIConstraints: *PaperSources PC416+LU207 *Model C3300i
*UIConstraints: *PaperSources PC416+LU207 *Model C3320i
*UIConstraints: *PaperSources PC416+LU302 *InputSlot Tray4
*UIConstraints: *PaperSources PC416+LU302 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC416+LU302 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC416+LU302 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC416+LU302 *Model C751i
*UIConstraints: *PaperSources PC416+LU302 *Model C4051i
*UIConstraints: *PaperSources PC416+LU302 *Model C3351i
*UIConstraints: *PaperSources PC416+LU302 *Model C4001i
*UIConstraints: *PaperSources PC416+LU302 *Model C3301i
*UIConstraints: *PaperSources PC416+LU302 *Model C3321i
*UIConstraints: *PaperSources PC416+LU302 *Model C750i
*UIConstraints: *PaperSources PC416+LU302 *Model C287i
*UIConstraints: *PaperSources PC416+LU302 *Model C257i
*UIConstraints: *PaperSources PC416+LU302 *Model C227i
*UIConstraints: *PaperSources PC416+LU302 *Model C286i
*UIConstraints: *PaperSources PC416+LU302 *Model C266i
*UIConstraints: *PaperSources PC416+LU302 *Model C226i
*UIConstraints: *PaperSources PC416+LU302 *Model C4050i
*UIConstraints: *PaperSources PC416+LU302 *Model C3350i
*UIConstraints: *PaperSources PC416+LU302 *Model C4000i
*UIConstraints: *PaperSources PC416+LU302 *Model C3300i
*UIConstraints: *PaperSources PC416+LU302 *Model C3320i
*UIConstraints: *PaperSources PC417 *InputSlot LCT
*UIConstraints: *PaperSources PC417 *FrontCoverTray LCT
*UIConstraints: *PaperSources PC417 *BackCoverTray LCT
*UIConstraints: *PaperSources PC417 *OHPOpTray LCT
*UIConstraints: *PaperSources PC417 *Model C751i
*UIConstraints: *PaperSources PC417 *Model C4051i
*UIConstraints: *PaperSources PC417 *Model C3351i
*UIConstraints: *PaperSources PC417 *Model C4001i
*UIConstraints: *PaperSources PC417 *Model C3301i
*UIConstraints: *PaperSources PC417 *Model C3321i
*UIConstraints: *PaperSources PC417 *Model C750i
*UIConstraints: *PaperSources PC417 *Model C287i
*UIConstraints: *PaperSources PC417 *Model C257i
*UIConstraints: *PaperSources PC417 *Model C227i
*UIConstraints: *PaperSources PC417 *Model C286i
*UIConstraints: *PaperSources PC417 *Model C266i
*UIConstraints: *PaperSources PC417 *Model C226i
*UIConstraints: *PaperSources PC417 *Model C4050i
*UIConstraints: *PaperSources PC417 *Model C3350i
*UIConstraints: *PaperSources PC417 *Model C4000i
*UIConstraints: *PaperSources PC417 *Model C3300i
*UIConstraints: *PaperSources PC417 *Model C3320i
*UIConstraints: *PaperSources PC417+LU207 *Model C751i
*UIConstraints: *PaperSources PC417+LU207 *Model C361i
*UIConstraints: *PaperSources PC417+LU207 *Model C301i
*UIConstraints: *PaperSources PC417+LU207 *Model C251i
*UIConstraints: *PaperSources PC417+LU207 *Model C4051i
*UIConstraints: *PaperSources PC417+LU207 *Model C3351i
*UIConstraints: *PaperSources PC417+LU207 *Model C4001i
*UIConstraints: *PaperSources PC417+LU207 *Model C3301i
*UIConstraints: *PaperSources PC417+LU207 *Model C3321i
*UIConstraints: *PaperSources PC417+LU207 *Model C750i
*UIConstraints: *PaperSources PC417+LU207 *Model C360i
*UIConstraints: *PaperSources PC417+LU207 *Model C300i
*UIConstraints: *PaperSources PC417+LU207 *Model C250i
*UIConstraints: *PaperSources PC417+LU207 *Model C287i
*UIConstraints: *PaperSources PC417+LU207 *Model C257i
*UIConstraints: *PaperSources PC417+LU207 *Model C227i
*UIConstraints: *PaperSources PC417+LU207 *Model C286i
*UIConstraints: *PaperSources PC417+LU207 *Model C266i
*UIConstraints: *PaperSources PC417+LU207 *Model C226i
*UIConstraints: *PaperSources PC417+LU207 *Model C4050i
*UIConstraints: *PaperSources PC417+LU207 *Model C3350i
*UIConstraints: *PaperSources PC417+LU207 *Model C4000i
*UIConstraints: *PaperSources PC417+LU207 *Model C3300i
*UIConstraints: *PaperSources PC417+LU207 *Model C3320i
*UIConstraints: *PaperSources PC417+LU302 *Model C751i
*UIConstraints: *PaperSources PC417+LU302 *Model C4051i
*UIConstraints: *PaperSources PC417+LU302 *Model C3351i
*UIConstraints: *PaperSources PC417+LU302 *Model C4001i
*UIConstraints: *PaperSources PC417+LU302 *Model C3301i
*UIConstraints: *PaperSources PC417+LU302 *Model C3321i
*UIConstraints: *PaperSources PC417+LU302 *Model C750i
*UIConstraints: *PaperSources PC417+LU302 *Model C287i
*UIConstraints: *PaperSources PC417+LU302 *Model C257i
*UIConstraints: *PaperSources PC417+LU302 *Model C227i
*UIConstraints: *PaperSources PC417+LU302 *Model C286i
*UIConstraints: *PaperSources PC417+LU302 *Model C266i
*UIConstraints: *PaperSources PC417+LU302 *Model C226i
*UIConstraints: *PaperSources PC417+LU302 *Model C4050i
*UIConstraints: *PaperSources PC417+LU302 *Model C3350i
*UIConstraints: *PaperSources PC417+LU302 *Model C4000i
*UIConstraints: *PaperSources PC417+LU302 *Model C3300i
*UIConstraints: *PaperSources PC417+LU302 *Model C3320i
*UIConstraints: *PaperSources PC418 *InputSlot Tray4
*UIConstraints: *PaperSources PC418 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PC418 *BackCoverTray Tray4
*UIConstraints: *PaperSources PC418 *OHPOpTray Tray4
*UIConstraints: *PaperSources PC418 *Model C751i
*UIConstraints: *PaperSources PC418 *Model C651i
*UIConstraints: *PaperSources PC418 *Model C551i
*UIConstraints: *PaperSources PC418 *Model C451i
*UIConstraints: *PaperSources PC418 *Model C361i
*UIConstraints: *PaperSources PC418 *Model C301i
*UIConstraints: *PaperSources PC418 *Model C251i
*UIConstraints: *PaperSources PC418 *Model C4051i
*UIConstraints: *PaperSources PC418 *Model C3351i
*UIConstraints: *PaperSources PC418 *Model C4001i
*UIConstraints: *PaperSources PC418 *Model C3301i
*UIConstraints: *PaperSources PC418 *Model C3321i
*UIConstraints: *PaperSources PC418 *Model C750i
*UIConstraints: *PaperSources PC418 *Model C650i
*UIConstraints: *PaperSources PC418 *Model C550i
*UIConstraints: *PaperSources PC418 *Model C450i
*UIConstraints: *PaperSources PC418 *Model C360i
*UIConstraints: *PaperSources PC418 *Model C300i
*UIConstraints: *PaperSources PC418 *Model C250i
*UIConstraints: *PaperSources PC418 *Model C4050i
*UIConstraints: *PaperSources PC418 *Model C3350i
*UIConstraints: *PaperSources PC418 *Model C4000i
*UIConstraints: *PaperSources PC418 *Model C3300i
*UIConstraints: *PaperSources PC418 *Model C3320i
*UIConstraints: *PaperSources PFP13T2 *InputSlot Tray3
*UIConstraints: *PaperSources PFP13T2 *InputSlot Tray4
*UIConstraints: *PaperSources PFP13T2 *FrontCoverTray Tray3
*UIConstraints: *PaperSources PFP13T2 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PFP13T2 *BackCoverTray Tray3
*UIConstraints: *PaperSources PFP13T2 *BackCoverTray Tray4
*UIConstraints: *PaperSources PFP13T2 *Model C751i
*UIConstraints: *PaperSources PFP13T2 *Model C651i
*UIConstraints: *PaperSources PFP13T2 *Model C551i
*UIConstraints: *PaperSources PFP13T2 *Model C451i
*UIConstraints: *PaperSources PFP13T2 *Model C361i
*UIConstraints: *PaperSources PFP13T2 *Model C301i
*UIConstraints: *PaperSources PFP13T2 *Model C251i
*UIConstraints: *PaperSources PFP13T2 *Model C750i
*UIConstraints: *PaperSources PFP13T2 *Model C650i
*UIConstraints: *PaperSources PFP13T2 *Model C550i
*UIConstraints: *PaperSources PFP13T2 *Model C450i
*UIConstraints: *PaperSources PFP13T2 *Model C360i
*UIConstraints: *PaperSources PFP13T2 *Model C300i
*UIConstraints: *PaperSources PFP13T2 *Model C250i
*UIConstraints: *PaperSources PFP13T2 *Model C287i
*UIConstraints: *PaperSources PFP13T2 *Model C257i
*UIConstraints: *PaperSources PFP13T2 *Model C227i
*UIConstraints: *PaperSources PFP13T2 *Model C286i
*UIConstraints: *PaperSources PFP13T2 *Model C266i
*UIConstraints: *PaperSources PFP13T2 *Model C226i
*UIConstraints: *PaperSources PFP13T23 *InputSlot Tray4
*UIConstraints: *PaperSources PFP13T23 *FrontCoverTray Tray4
*UIConstraints: *PaperSources PFP13T23 *BackCoverTray Tray4
*UIConstraints: *PaperSources PFP13T23 *Model C751i
*UIConstraints: *PaperSources PFP13T23 *Model C651i
*UIConstraints: *PaperSources PFP13T23 *Model C551i
*UIConstraints: *PaperSources PFP13T23 *Model C451i
*UIConstraints: *PaperSources PFP13T23 *Model C361i
*UIConstraints: *PaperSources PFP13T23 *Model C301i
*UIConstraints: *PaperSources PFP13T23 *Model C251i
*UIConstraints: *PaperSources PFP13T23 *Model C750i
*UIConstraints: *PaperSources PFP13T23 *Model C650i
*UIConstraints: *PaperSources PFP13T23 *Model C550i
*UIConstraints: *PaperSources PFP13T23 *Model C450i
*UIConstraints: *PaperSources PFP13T23 *Model C360i
*UIConstraints: *PaperSources PFP13T23 *Model C300i
*UIConstraints: *PaperSources PFP13T23 *Model C250i
*UIConstraints: *PaperSources PFP13T23 *Model C287i
*UIConstraints: *PaperSources PFP13T23 *Model C257i
*UIConstraints: *PaperSources PFP13T23 *Model C227i
*UIConstraints: *PaperSources PFP13T23 *Model C286i
*UIConstraints: *PaperSources PFP13T23 *Model C266i
*UIConstraints: *PaperSources PFP13T23 *Model C226i
*UIConstraints: *PaperSources PFP13T23 *Model C3300i
*UIConstraints: *PaperSources PFP13T23 *Model C3320i
*UIConstraints: *PaperSources PFP13T234 *Model C751i
*UIConstraints: *PaperSources PFP13T234 *Model C651i
*UIConstraints: *PaperSources PFP13T234 *Model C551i
*UIConstraints: *PaperSources PFP13T234 *Model C451i
*UIConstraints: *PaperSources PFP13T234 *Model C361i
*UIConstraints: *PaperSources PFP13T234 *Model C301i
*UIConstraints: *PaperSources PFP13T234 *Model C251i
*UIConstraints: *PaperSources PFP13T234 *Model C3321i
*UIConstraints: *PaperSources PFP13T234 *Model C750i
*UIConstraints: *PaperSources PFP13T234 *Model C650i
*UIConstraints: *PaperSources PFP13T234 *Model C550i
*UIConstraints: *PaperSources PFP13T234 *Model C450i
*UIConstraints: *PaperSources PFP13T234 *Model C360i
*UIConstraints: *PaperSources PFP13T234 *Model C300i
*UIConstraints: *PaperSources PFP13T234 *Model C250i
*UIConstraints: *PaperSources PFP13T234 *Model C287i
*UIConstraints: *PaperSources PFP13T234 *Model C257i
*UIConstraints: *PaperSources PFP13T234 *Model C227i
*UIConstraints: *PaperSources PFP13T234 *Model C286i
*UIConstraints: *PaperSources PFP13T234 *Model C266i
*UIConstraints: *PaperSources PFP13T234 *Model C226i
*UIConstraints: *PaperSources PFP13T234 *Model C4050i
*UIConstraints: *PaperSources PFP13T234 *Model C3350i
*UIConstraints: *PaperSources PFP13T234 *Model C4000i
*UIConstraints: *PaperSources PFP13T234 *Model C3300i
*UIConstraints: *PaperSources PFP13T234 *Model C3320i
*UIConstraints: *Finisher None *OutputBin Tray1
*UIConstraints: *Finisher None *OutputBin Tray2
*UIConstraints: *Finisher None *OutputBin Tray3
*UIConstraints: *Finisher None *OutputBin Tray4
*UIConstraints: *Finisher None *Staple 1StapleAuto(Left)
*UIConstraints: *Finisher None *Staple 1StapleZeroLeft
*UIConstraints: *Finisher None *Staple 1StapleAuto(Right)
*UIConstraints: *Finisher None *Staple 1StapleZeroRight
*UIConstraints: *Finisher None *Staple 2Staples
*UIConstraints: *Finisher None *KOPunch PK519
*UIConstraints: *Finisher None *KOPunch PK519-3
*UIConstraints: *Finisher None *KOPunch PK519-4
*UIConstraints: *Finisher None *KOPunch PK519-SWE4
*UIConstraints: *Finisher None *KOPunch PK524
*UIConstraints: *Finisher None *KOPunch PK524-3
*UIConstraints: *Finisher None *KOPunch PK524-4
*UIConstraints: *Finisher None *KOPunch PK524-SWE4
*UIConstraints: *Finisher None *KOPunch PK526
*UIConstraints: *Finisher None *KOPunch PK526-3
*UIConstraints: *Finisher None *KOPunch PK526-4
*UIConstraints: *Finisher None *KOPunch PK526-SWE4
*UIConstraints: *Finisher None *KOPunch PK527
*UIConstraints: *Finisher None *KOPunch PK527-3
*UIConstraints: *Finisher None *KOPunch PK527-4
*UIConstraints: *Finisher None *KOPunch PK527-SWE4
*UIConstraints: *Finisher None *ZFoldUnit ZU609
*UIConstraints: *Finisher None *PostInserter PI507
*UIConstraints: *Finisher None *SaddleUnit SD511
*UIConstraints: *Finisher None *SaddleUnit SD512
*UIConstraints: *Finisher FS533 *OutputBin Tray2
*UIConstraints: *Finisher FS533 *OutputBin Tray3
*UIConstraints: *Finisher FS533 *OutputBin Tray4
*UIConstraints: *Finisher FS533 *Staple 1StapleZeroLeft
*UIConstraints: *Finisher FS533 *Staple 1StapleZeroRight
*UIConstraints: *Finisher FS533 *KOPunch PK524
*UIConstraints: *Finisher FS533 *KOPunch PK524-3
*UIConstraints: *Finisher FS533 *KOPunch PK524-4
*UIConstraints: *Finisher FS533 *KOPunch PK524-SWE4
*UIConstraints: *Finisher FS533 *KOPunch PK526
*UIConstraints: *Finisher FS533 *KOPunch PK526-3
*UIConstraints: *Finisher FS533 *KOPunch PK526-4
*UIConstraints: *Finisher FS533 *KOPunch PK526-SWE4
*UIConstraints: *Finisher FS533 *KOPunch PK527
*UIConstraints: *Finisher FS533 *KOPunch PK527-3
*UIConstraints: *Finisher FS533 *KOPunch PK527-4
*UIConstraints: *Finisher FS533 *KOPunch PK527-SWE4
*UIConstraints: *Finisher FS533 *ZFoldUnit ZU609
*UIConstraints: *Finisher FS533 *PostInserter PI507
*UIConstraints: *Finisher FS533 *SaddleUnit SD511
*UIConstraints: *Finisher FS533 *SaddleUnit SD512
*UIConstraints: *Finisher FS533 *Model C751i
*UIConstraints: *Finisher FS533 *Model C651i
*UIConstraints: *Finisher FS533 *Model C4051i
*UIConstraints: *Finisher FS533 *Model C3351i
*UIConstraints: *Finisher FS533 *Model C4001i
*UIConstraints: *Finisher FS533 *Model C3301i
*UIConstraints: *Finisher FS533 *Model C3321i
*UIConstraints: *Finisher FS533 *Model C750i
*UIConstraints: *Finisher FS533 *Model C650i
*UIConstraints: *Finisher FS533 *Model C286i
*UIConstraints: *Finisher FS533 *Model C266i
*UIConstraints: *Finisher FS533 *Model C226i
*UIConstraints: *Finisher FS533 *Model C4050i
*UIConstraints: *Finisher FS533 *Model C3350i
*UIConstraints: *Finisher FS533 *Model C4000i
*UIConstraints: *Finisher FS533 *Model C3300i
*UIConstraints: *Finisher FS533 *Model C3320i
*UIConstraints: *Finisher FS539 *OutputBin Tray4
*UIConstraints: *Finisher FS539 *KOPunch PK519
*UIConstraints: *Finisher FS539 *KOPunch PK519-3
*UIConstraints: *Finisher FS539 *KOPunch PK519-4
*UIConstraints: *Finisher FS539 *KOPunch PK519-SWE4
*UIConstraints: *Finisher FS539 *KOPunch PK526
*UIConstraints: *Finisher FS539 *KOPunch PK526-3
*UIConstraints: *Finisher FS539 *KOPunch PK526-4
*UIConstraints: *Finisher FS539 *KOPunch PK526-SWE4
*UIConstraints: *Finisher FS539 *KOPunch PK527
*UIConstraints: *Finisher FS539 *KOPunch PK527-3
*UIConstraints: *Finisher FS539 *KOPunch PK527-4
*UIConstraints: *Finisher FS539 *KOPunch PK527-SWE4
*UIConstraints: *Finisher FS539 *ZFoldUnit ZU609
*UIConstraints: *Finisher FS539 *PostInserter PI507
*UIConstraints: *Finisher FS539 *SaddleUnit SD512
*UIConstraints: *Finisher FS539 *Model C4051i
*UIConstraints: *Finisher FS539 *Model C3351i
*UIConstraints: *Finisher FS539 *Model C4001i
*UIConstraints: *Finisher FS539 *Model C3301i
*UIConstraints: *Finisher FS539 *Model C3321i
*UIConstraints: *Finisher FS539 *Model C286i
*UIConstraints: *Finisher FS539 *Model C266i
*UIConstraints: *Finisher FS539 *Model C226i
*UIConstraints: *Finisher FS539 *Model C4050i
*UIConstraints: *Finisher FS539 *Model C3350i
*UIConstraints: *Finisher FS539 *Model C4000i
*UIConstraints: *Finisher FS539 *Model C3300i
*UIConstraints: *Finisher FS539 *Model C3320i
*UIConstraints: *Finisher JS506 *OutputBin Tray3
*UIConstraints: *Finisher JS506 *OutputBin Tray4
*UIConstraints: *Finisher JS506 *Staple 1StapleAuto(Left)
*UIConstraints: *Finisher JS506 *Staple 1StapleZeroLeft
*UIConstraints: *Finisher JS506 *Staple 1StapleAuto(Right)
*UIConstraints: *Finisher JS506 *Staple 1StapleZeroRight
*UIConstraints: *Finisher JS506 *Staple 2Staples
*UIConstraints: *Finisher JS506 *KOPunch PK519
*UIConstraints: *Finisher JS506 *KOPunch PK519-3
*UIConstraints: *Finisher JS506 *KOPunch PK519-4
*UIConstraints: *Finisher JS506 *KOPunch PK519-SWE4
*UIConstraints: *Finisher JS506 *KOPunch PK524
*UIConstraints: *Finisher JS506 *KOPunch PK524-3
*UIConstraints: *Finisher JS506 *KOPunch PK524-4
*UIConstraints: *Finisher JS506 *KOPunch PK524-SWE4
*UIConstraints: *Finisher JS506 *KOPunch PK526
*UIConstraints: *Finisher JS506 *KOPunch PK526-3
*UIConstraints: *Finisher JS506 *KOPunch PK526-4
*UIConstraints: *Finisher JS506 *KOPunch PK526-SWE4
*UIConstraints: *Finisher JS506 *KOPunch PK527
*UIConstraints: *Finisher JS506 *KOPunch PK527-3
*UIConstraints: *Finisher JS506 *KOPunch PK527-4
*UIConstraints: *Finisher JS506 *KOPunch PK527-SWE4
*UIConstraints: *Finisher JS506 *ZFoldUnit ZU609
*UIConstraints: *Finisher JS506 *PostInserter PI507
*UIConstraints: *Finisher JS506 *SaddleUnit SD511
*UIConstraints: *Finisher JS506 *SaddleUnit SD512
*UIConstraints: *Finisher JS506 *Model C751i
*UIConstraints: *Finisher JS506 *Model C651i
*UIConstraints: *Finisher JS506 *Model C551i
*UIConstraints: *Finisher JS506 *Model C451i
*UIConstraints: *Finisher JS506 *Model C4051i
*UIConstraints: *Finisher JS506 *Model C3351i
*UIConstraints: *Finisher JS506 *Model C4001i
*UIConstraints: *Finisher JS506 *Model C3301i
*UIConstraints: *Finisher JS506 *Model C3321i
*UIConstraints: *Finisher JS506 *Model C750i
*UIConstraints: *Finisher JS506 *Model C650i
*UIConstraints: *Finisher JS506 *Model C550i
*UIConstraints: *Finisher JS506 *Model C450i
*UIConstraints: *Finisher JS506 *Model C286i
*UIConstraints: *Finisher JS506 *Model C266i
*UIConstraints: *Finisher JS506 *Model C226i
*UIConstraints: *Finisher JS506 *Model C4050i
*UIConstraints: *Finisher JS506 *Model C3350i
*UIConstraints: *Finisher JS506 *Model C4000i
*UIConstraints: *Finisher JS506 *Model C3300i
*UIConstraints: *Finisher JS506 *Model C3320i
*UIConstraints: *Finisher JS508 *OutputBin Tray3
*UIConstraints: *Finisher JS508 *OutputBin Tray4
*UIConstraints: *Finisher JS508 *Staple 1StapleAuto(Left)
*UIConstraints: *Finisher JS508 *Staple 1StapleZeroLeft
*UIConstraints: *Finisher JS508 *Staple 1StapleAuto(Right)
*UIConstraints: *Finisher JS508 *Staple 1StapleZeroRight
*UIConstraints: *Finisher JS508 *Staple 2Staples
*UIConstraints: *Finisher JS508 *KOPunch PK519
*UIConstraints: *Finisher JS508 *KOPunch PK519-3
*UIConstraints: *Finisher JS508 *KOPunch PK519-4
*UIConstraints: *Finisher JS508 *KOPunch PK519-SWE4
*UIConstraints: *Finisher JS508 *KOPunch PK524
*UIConstraints: *Finisher JS508 *KOPunch PK524-3
*UIConstraints: *Finisher JS508 *KOPunch PK524-4
*UIConstraints: *Finisher JS508 *KOPunch PK524-SWE4
*UIConstraints: *Finisher JS508 *KOPunch PK526
*UIConstraints: *Finisher JS508 *KOPunch PK526-3
*UIConstraints: *Finisher JS508 *KOPunch PK526-4
*UIConstraints: *Finisher JS508 *KOPunch PK526-SWE4
*UIConstraints: *Finisher JS508 *KOPunch PK527
*UIConstraints: *Finisher JS508 *KOPunch PK527-3
*UIConstraints: *Finisher JS508 *KOPunch PK527-4
*UIConstraints: *Finisher JS508 *KOPunch PK527-SWE4
*UIConstraints: *Finisher JS508 *ZFoldUnit ZU609
*UIConstraints: *Finisher JS508 *PostInserter PI507
*UIConstraints: *Finisher JS508 *SaddleUnit SD511
*UIConstraints: *Finisher JS508 *SaddleUnit SD512
*UIConstraints: *Finisher JS508 *Model C751i
*UIConstraints: *Finisher JS508 *Model C651i
*UIConstraints: *Finisher JS508 *Model C361i
*UIConstraints: *Finisher JS508 *Model C301i
*UIConstraints: *Finisher JS508 *Model C251i
*UIConstraints: *Finisher JS508 *Model C4051i
*UIConstraints: *Finisher JS508 *Model C3351i
*UIConstraints: *Finisher JS508 *Model C4001i
*UIConstraints: *Finisher JS508 *Model C3301i
*UIConstraints: *Finisher JS508 *Model C3321i
*UIConstraints: *Finisher JS508 *Model C750i
*UIConstraints: *Finisher JS508 *Model C650i
*UIConstraints: *Finisher JS508 *Model C360i
*UIConstraints: *Finisher JS508 *Model C300i
*UIConstraints: *Finisher JS508 *Model C250i
*UIConstraints: *Finisher JS508 *Model C287i
*UIConstraints: *Finisher JS508 *Model C257i
*UIConstraints: *Finisher JS508 *Model C227i
*UIConstraints: *Finisher JS508 *Model C286i
*UIConstraints: *Finisher JS508 *Model C266i
*UIConstraints: *Finisher JS508 *Model C226i
*UIConstraints: *Finisher JS508 *Model C4050i
*UIConstraints: *Finisher JS508 *Model C3350i
*UIConstraints: *Finisher JS508 *Model C4000i
*UIConstraints: *Finisher JS508 *Model C3300i
*UIConstraints: *Finisher JS508 *Model C3320i
*UIConstraints: *Finisher FS540 *OutputBin Tray4
*UIConstraints: *Finisher FS540 *KOPunch PK519
*UIConstraints: *Finisher FS540 *KOPunch PK519-3
*UIConstraints: *Finisher FS540 *KOPunch PK519-4
*UIConstraints: *Finisher FS540 *KOPunch PK519-SWE4
*UIConstraints: *Finisher FS540 *KOPunch PK524
*UIConstraints: *Finisher FS540 *KOPunch PK524-3
*UIConstraints: *Finisher FS540 *KOPunch PK524-4
*UIConstraints: *Finisher FS540 *KOPunch PK524-SWE4
*UIConstraints: *Finisher FS540 *KOPunch PK527
*UIConstraints: *Finisher FS540 *KOPunch PK527-3
*UIConstraints: *Finisher FS540 *KOPunch PK527-4
*UIConstraints: *Finisher FS540 *KOPunch PK527-SWE4
*UIConstraints: *Finisher FS540 *SaddleUnit SD511
*UIConstraints: *Finisher FS540 *Model C361i
*UIConstraints: *Finisher FS540 *Model C301i
*UIConstraints: *Finisher FS540 *Model C251i
*UIConstraints: *Finisher FS540 *Model C4051i
*UIConstraints: *Finisher FS540 *Model C3351i
*UIConstraints: *Finisher FS540 *Model C4001i
*UIConstraints: *Finisher FS540 *Model C3301i
*UIConstraints: *Finisher FS540 *Model C3321i
*UIConstraints: *Finisher FS540 *Model C360i
*UIConstraints: *Finisher FS540 *Model C300i
*UIConstraints: *Finisher FS540 *Model C250i
*UIConstraints: *Finisher FS540 *Model C287i
*UIConstraints: *Finisher FS540 *Model C257i
*UIConstraints: *Finisher FS540 *Model C227i
*UIConstraints: *Finisher FS540 *Model C286i
*UIConstraints: *Finisher FS540 *Model C266i
*UIConstraints: *Finisher FS540 *Model C226i
*UIConstraints: *Finisher FS540 *Model C4050i
*UIConstraints: *Finisher FS540 *Model C3350i
*UIConstraints: *Finisher FS540 *Model C4000i
*UIConstraints: *Finisher FS540 *Model C3300i
*UIConstraints: *Finisher FS540 *Model C3320i
*UIConstraints: *Finisher FS540JS602 *KOPunch PK519
*UIConstraints: *Finisher FS540JS602 *KOPunch PK519-3
*UIConstraints: *Finisher FS540JS602 *KOPunch PK519-4
*UIConstraints: *Finisher FS540JS602 *KOPunch PK519-SWE4
*UIConstraints: *Finisher FS540JS602 *KOPunch PK524
*UIConstraints: *Finisher FS540JS602 *KOPunch PK524-3
*UIConstraints: *Finisher FS540JS602 *KOPunch PK524-4
*UIConstraints: *Finisher FS540JS602 *KOPunch PK524-SWE4
*UIConstraints: *Finisher FS540JS602 *KOPunch PK527
*UIConstraints: *Finisher FS540JS602 *KOPunch PK527-3
*UIConstraints: *Finisher FS540JS602 *KOPunch PK527-4
*UIConstraints: *Finisher FS540JS602 *KOPunch PK527-SWE4
*UIConstraints: *Finisher FS540JS602 *PostInserter PI507
*UIConstraints: *Finisher FS540JS602 *SaddleUnit SD511
*UIConstraints: *Finisher FS540JS602 *Model C361i
*UIConstraints: *Finisher FS540JS602 *Model C301i
*UIConstraints: *Finisher FS540JS602 *Model C251i
*UIConstraints: *Finisher FS540JS602 *Model C4051i
*UIConstraints: *Finisher FS540JS602 *Model C3351i
*UIConstraints: *Finisher FS540JS602 *Model C4001i
*UIConstraints: *Finisher FS540JS602 *Model C3301i
*UIConstraints: *Finisher FS540JS602 *Model C3321i
*UIConstraints: *Finisher FS540JS602 *Model C360i
*UIConstraints: *Finisher FS540JS602 *Model C300i
*UIConstraints: *Finisher FS540JS602 *Model C250i
*UIConstraints: *Finisher FS540JS602 *Model C287i
*UIConstraints: *Finisher FS540JS602 *Model C257i
*UIConstraints: *Finisher FS540JS602 *Model C227i
*UIConstraints: *Finisher FS540JS602 *Model C286i
*UIConstraints: *Finisher FS540JS602 *Model C266i
*UIConstraints: *Finisher FS540JS602 *Model C226i
*UIConstraints: *Finisher FS540JS602 *Model C4050i
*UIConstraints: *Finisher FS540JS602 *Model C3350i
*UIConstraints: *Finisher FS540JS602 *Model C4000i
*UIConstraints: *Finisher FS540JS602 *Model C3300i
*UIConstraints: *Finisher FS540JS602 *Model C3320i
*UIConstraints: *Finisher FS542 *OutputBin Tray2
*UIConstraints: *Finisher FS542 *OutputBin Tray3
*UIConstraints: *Finisher FS542 *OutputBin Tray4
*UIConstraints: *Finisher FS542 *Staple 1StapleZeroLeft
*UIConstraints: *Finisher FS542 *Staple 1StapleZeroRight
*UIConstraints: *Finisher FS542 *KOPunch PK519
*UIConstraints: *Finisher FS542 *KOPunch PK519-3
*UIConstraints: *Finisher FS542 *KOPunch PK519-4
*UIConstraints: *Finisher FS542 *KOPunch PK519-SWE4
*UIConstraints: *Finisher FS542 *KOPunch PK524
*UIConstraints: *Finisher FS542 *KOPunch PK524-3
*UIConstraints: *Finisher FS542 *KOPunch PK524-4
*UIConstraints: *Finisher FS542 *KOPunch PK524-SWE4
*UIConstraints: *Finisher FS542 *KOPunch PK526
*UIConstraints: *Finisher FS542 *KOPunch PK526-3
*UIConstraints: *Finisher FS542 *KOPunch PK526-4
*UIConstraints: *Finisher FS542 *KOPunch PK526-SWE4
*UIConstraints: *Finisher FS542 *ZFoldUnit ZU609
*UIConstraints: *Finisher FS542 *PostInserter PI507
*UIConstraints: *Finisher FS542 *SaddleUnit SD511
*UIConstraints: *Finisher FS542 *SaddleUnit SD512
*UIConstraints: *Finisher FS542 *Model C751i
*UIConstraints: *Finisher FS542 *Model C4051i
*UIConstraints: *Finisher FS542 *Model C3351i
*UIConstraints: *Finisher FS542 *Model C4001i
*UIConstraints: *Finisher FS542 *Model C3301i
*UIConstraints: *Finisher FS542 *Model C3321i
*UIConstraints: *Finisher FS542 *Model C750i
*UIConstraints: *Finisher FS542 *Model C650i
*UIConstraints: *Finisher FS542 *Model C550i
*UIConstraints: *Finisher FS542 *Model C450i
*UIConstraints: *Finisher FS542 *Model C360i
*UIConstraints: *Finisher FS542 *Model C300i
*UIConstraints: *Finisher FS542 *Model C250i
*UIConstraints: *Finisher FS542 *Model C286i
*UIConstraints: *Finisher FS542 *Model C266i
*UIConstraints: *Finisher FS542 *Model C226i
*UIConstraints: *Finisher FS542 *Model C4050i
*UIConstraints: *Finisher FS542 *Model C3350i
*UIConstraints: *Finisher FS542 *Model C4000i
*UIConstraints: *Finisher FS542 *Model C3300i
*UIConstraints: *Finisher FS542 *Model C3320i
*UIConstraints: *KOPunch None *Punch 2holes
*UIConstraints: *KOPunch None *Punch 3holes
*UIConstraints: *KOPunch None *Punch 4holes
*UIConstraints: *KOPunch PK519 *Punch 3holes
*UIConstraints: *KOPunch PK519 *Punch 4holes
*UIConstraints: *KOPunch PK519 *Finisher None
*UIConstraints: *KOPunch PK519 *Finisher FS539
*UIConstraints: *KOPunch PK519 *Finisher JS506
*UIConstraints: *KOPunch PK519 *Finisher JS508
*UIConstraints: *KOPunch PK519 *Finisher FS540
*UIConstraints: *KOPunch PK519 *Finisher FS540JS602
*UIConstraints: *KOPunch PK519 *Finisher FS542
*UIConstraints: *KOPunch PK519 *Model C751i
*UIConstraints: *KOPunch PK519 *Model C651i
*UIConstraints: *KOPunch PK519 *Model C4051i
*UIConstraints: *KOPunch PK519 *Model C3351i
*UIConstraints: *KOPunch PK519 *Model C4001i
*UIConstraints: *KOPunch PK519 *Model C3301i
*UIConstraints: *KOPunch PK519 *Model C3321i
*UIConstraints: *KOPunch PK519 *Model C750i
*UIConstraints: *KOPunch PK519 *Model C650i
*UIConstraints: *KOPunch PK519 *Model C286i
*UIConstraints: *KOPunch PK519 *Model C266i
*UIConstraints: *KOPunch PK519 *Model C226i
*UIConstraints: *KOPunch PK519 *Model C4050i
*UIConstraints: *KOPunch PK519 *Model C3350i
*UIConstraints: *KOPunch PK519 *Model C4000i
*UIConstraints: *KOPunch PK519 *Model C3300i
*UIConstraints: *KOPunch PK519 *Model C3320i
*UIConstraints: *KOPunch PK519-3 *Punch 4holes
*UIConstraints: *KOPunch PK519-3 *Finisher None
*UIConstraints: *KOPunch PK519-3 *Finisher FS539
*UIConstraints: *KOPunch PK519-3 *Finisher JS506
*UIConstraints: *KOPunch PK519-3 *Finisher JS508
*UIConstraints: *KOPunch PK519-3 *Finisher FS540
*UIConstraints: *KOPunch PK519-3 *Finisher FS540JS602
*UIConstraints: *KOPunch PK519-3 *Finisher FS542
*UIConstraints: *KOPunch PK519-3 *Model C751i
*UIConstraints: *KOPunch PK519-3 *Model C651i
*UIConstraints: *KOPunch PK519-3 *Model C4051i
*UIConstraints: *KOPunch PK519-3 *Model C3351i
*UIConstraints: *KOPunch PK519-3 *Model C4001i
*UIConstraints: *KOPunch PK519-3 *Model C3301i
*UIConstraints: *KOPunch PK519-3 *Model C3321i
*UIConstraints: *KOPunch PK519-3 *Model C750i
*UIConstraints: *KOPunch PK519-3 *Model C650i
*UIConstraints: *KOPunch PK519-3 *Model C286i
*UIConstraints: *KOPunch PK519-3 *Model C266i
*UIConstraints: *KOPunch PK519-3 *Model C226i
*UIConstraints: *KOPunch PK519-3 *Model C4050i
*UIConstraints: *KOPunch PK519-3 *Model C3350i
*UIConstraints: *KOPunch PK519-3 *Model C4000i
*UIConstraints: *KOPunch PK519-3 *Model C3300i
*UIConstraints: *KOPunch PK519-3 *Model C3320i
*UIConstraints: *KOPunch PK519-4 *Punch 3holes
*UIConstraints: *KOPunch PK519-4 *Finisher None
*UIConstraints: *KOPunch PK519-4 *Finisher FS539
*UIConstraints: *KOPunch PK519-4 *Finisher JS506
*UIConstraints: *KOPunch PK519-4 *Finisher JS508
*UIConstraints: *KOPunch PK519-4 *Finisher FS540
*UIConstraints: *KOPunch PK519-4 *Finisher FS540JS602
*UIConstraints: *KOPunch PK519-4 *Finisher FS542
*UIConstraints: *KOPunch PK519-4 *Model C751i
*UIConstraints: *KOPunch PK519-4 *Model C651i
*UIConstraints: *KOPunch PK519-4 *Model C4051i
*UIConstraints: *KOPunch PK519-4 *Model C3351i
*UIConstraints: *KOPunch PK519-4 *Model C4001i
*UIConstraints: *KOPunch PK519-4 *Model C3301i
*UIConstraints: *KOPunch PK519-4 *Model C3321i
*UIConstraints: *KOPunch PK519-4 *Model C750i
*UIConstraints: *KOPunch PK519-4 *Model C650i
*UIConstraints: *KOPunch PK519-4 *Model C286i
*UIConstraints: *KOPunch PK519-4 *Model C266i
*UIConstraints: *KOPunch PK519-4 *Model C226i
*UIConstraints: *KOPunch PK519-4 *Model C4050i
*UIConstraints: *KOPunch PK519-4 *Model C3350i
*UIConstraints: *KOPunch PK519-4 *Model C4000i
*UIConstraints: *KOPunch PK519-4 *Model C3300i
*UIConstraints: *KOPunch PK519-4 *Model C3320i
*UIConstraints: *KOPunch PK519-SWE4 *Punch 2holes
*UIConstraints: *KOPunch PK519-SWE4 *Punch 3holes
*UIConstraints: *KOPunch PK519-SWE4 *Finisher None
*UIConstraints: *KOPunch PK519-SWE4 *Finisher FS539
*UIConstraints: *KOPunch PK519-SWE4 *Finisher JS506
*UIConstraints: *KOPunch PK519-SWE4 *Finisher JS508
*UIConstraints: *KOPunch PK519-SWE4 *Finisher FS540
*UIConstraints: *KOPunch PK519-SWE4 *Finisher FS540JS602
*UIConstraints: *KOPunch PK519-SWE4 *Finisher FS542
*UIConstraints: *KOPunch PK519-SWE4 *Model C751i
*UIConstraints: *KOPunch PK519-SWE4 *Model C651i
*UIConstraints: *KOPunch PK519-SWE4 *Model C4051i
*UIConstraints: *KOPunch PK519-SWE4 *Model C3351i
*UIConstraints: *KOPunch PK519-SWE4 *Model C4001i
*UIConstraints: *KOPunch PK519-SWE4 *Model C3301i
*UIConstraints: *KOPunch PK519-SWE4 *Model C3321i
*UIConstraints: *KOPunch PK519-SWE4 *Model C750i
*UIConstraints: *KOPunch PK519-SWE4 *Model C650i
*UIConstraints: *KOPunch PK519-SWE4 *Model C286i
*UIConstraints: *KOPunch PK519-SWE4 *Model C266i
*UIConstraints: *KOPunch PK519-SWE4 *Model C226i
*UIConstraints: *KOPunch PK519-SWE4 *Model C4050i
*UIConstraints: *KOPunch PK519-SWE4 *Model C3350i
*UIConstraints: *KOPunch PK519-SWE4 *Model C4000i
*UIConstraints: *KOPunch PK519-SWE4 *Model C3300i
*UIConstraints: *KOPunch PK519-SWE4 *Model C3320i
*UIConstraints: *KOPunch PK524 *Punch 3holes
*UIConstraints: *KOPunch PK524 *Punch 4holes
*UIConstraints: *KOPunch PK524 *Finisher None
*UIConstraints: *KOPunch PK524 *Finisher FS533
*UIConstraints: *KOPunch PK524 *Finisher JS506
*UIConstraints: *KOPunch PK524 *Finisher JS508
*UIConstraints: *KOPunch PK524 *Finisher FS540
*UIConstraints: *KOPunch PK524 *Finisher FS540JS602
*UIConstraints: *KOPunch PK524 *Finisher FS542
*UIConstraints: *KOPunch PK524 *Model C4051i
*UIConstraints: *KOPunch PK524 *Model C3351i
*UIConstraints: *KOPunch PK524 *Model C4001i
*UIConstraints: *KOPunch PK524 *Model C3301i
*UIConstraints: *KOPunch PK524 *Model C3321i
*UIConstraints: *KOPunch PK524 *Model C286i
*UIConstraints: *KOPunch PK524 *Model C266i
*UIConstraints: *KOPunch PK524 *Model C226i
*UIConstraints: *KOPunch PK524 *Model C4050i
*UIConstraints: *KOPunch PK524 *Model C3350i
*UIConstraints: *KOPunch PK524 *Model C4000i
*UIConstraints: *KOPunch PK524 *Model C3300i
*UIConstraints: *KOPunch PK524 *Model C3320i
*UIConstraints: *KOPunch PK524-3 *Punch 4holes
*UIConstraints: *KOPunch PK524-3 *Finisher None
*UIConstraints: *KOPunch PK524-3 *Finisher FS533
*UIConstraints: *KOPunch PK524-3 *Finisher JS506
*UIConstraints: *KOPunch PK524-3 *Finisher JS508
*UIConstraints: *KOPunch PK524-3 *Finisher FS540
*UIConstraints: *KOPunch PK524-3 *Finisher FS540JS602
*UIConstraints: *KOPunch PK524-3 *Finisher FS542
*UIConstraints: *KOPunch PK524-3 *Model C4051i
*UIConstraints: *KOPunch PK524-3 *Model C3351i
*UIConstraints: *KOPunch PK524-3 *Model C4001i
*UIConstraints: *KOPunch PK524-3 *Model C3301i
*UIConstraints: *KOPunch PK524-3 *Model C3321i
*UIConstraints: *KOPunch PK524-3 *Model C286i
*UIConstraints: *KOPunch PK524-3 *Model C266i
*UIConstraints: *KOPunch PK524-3 *Model C226i
*UIConstraints: *KOPunch PK524-3 *Model C4050i
*UIConstraints: *KOPunch PK524-3 *Model C3350i
*UIConstraints: *KOPunch PK524-3 *Model C4000i
*UIConstraints: *KOPunch PK524-3 *Model C3300i
*UIConstraints: *KOPunch PK524-3 *Model C3320i
*UIConstraints: *KOPunch PK524-4 *Punch 3holes
*UIConstraints: *KOPunch PK524-4 *Finisher None
*UIConstraints: *KOPunch PK524-4 *Finisher FS533
*UIConstraints: *KOPunch PK524-4 *Finisher JS506
*UIConstraints: *KOPunch PK524-4 *Finisher JS508
*UIConstraints: *KOPunch PK524-4 *Finisher FS540
*UIConstraints: *KOPunch PK524-4 *Finisher FS540JS602
*UIConstraints: *KOPunch PK524-4 *Finisher FS542
*UIConstraints: *KOPunch PK524-4 *Model C4051i
*UIConstraints: *KOPunch PK524-4 *Model C3351i
*UIConstraints: *KOPunch PK524-4 *Model C4001i
*UIConstraints: *KOPunch PK524-4 *Model C3301i
*UIConstraints: *KOPunch PK524-4 *Model C3321i
*UIConstraints: *KOPunch PK524-4 *Model C286i
*UIConstraints: *KOPunch PK524-4 *Model C266i
*UIConstraints: *KOPunch PK524-4 *Model C226i
*UIConstraints: *KOPunch PK524-4 *Model C4050i
*UIConstraints: *KOPunch PK524-4 *Model C3350i
*UIConstraints: *KOPunch PK524-4 *Model C4000i
*UIConstraints: *KOPunch PK524-4 *Model C3300i
*UIConstraints: *KOPunch PK524-4 *Model C3320i
*UIConstraints: *KOPunch PK524-SWE4 *Punch 2holes
*UIConstraints: *KOPunch PK524-SWE4 *Punch 3holes
*UIConstraints: *KOPunch PK524-SWE4 *Finisher None
*UIConstraints: *KOPunch PK524-SWE4 *Finisher FS533
*UIConstraints: *KOPunch PK524-SWE4 *Finisher JS506
*UIConstraints: *KOPunch PK524-SWE4 *Finisher JS508
*UIConstraints: *KOPunch PK524-SWE4 *Finisher FS540
*UIConstraints: *KOPunch PK524-SWE4 *Finisher FS540JS602
*UIConstraints: *KOPunch PK524-SWE4 *Finisher FS542
*UIConstraints: *KOPunch PK524-SWE4 *Model C4051i
*UIConstraints: *KOPunch PK524-SWE4 *Model C3351i
*UIConstraints: *KOPunch PK524-SWE4 *Model C4001i
*UIConstraints: *KOPunch PK524-SWE4 *Model C3301i
*UIConstraints: *KOPunch PK524-SWE4 *Model C3321i
*UIConstraints: *KOPunch PK524-SWE4 *Model C286i
*UIConstraints: *KOPunch PK524-SWE4 *Model C266i
*UIConstraints: *KOPunch PK524-SWE4 *Model C226i
*UIConstraints: *KOPunch PK524-SWE4 *Model C4050i
*UIConstraints: *KOPunch PK524-SWE4 *Model C3350i
*UIConstraints: *KOPunch PK524-SWE4 *Model C4000i
*UIConstraints: *KOPunch PK524-SWE4 *Model C3300i
*UIConstraints: *KOPunch PK524-SWE4 *Model C3320i
*UIConstraints: *KOPunch PK526 *Punch 3holes
*UIConstraints: *KOPunch PK526 *Punch 4holes
*UIConstraints: *KOPunch PK526 *Finisher None
*UIConstraints: *KOPunch PK526 *Finisher FS533
*UIConstraints: *KOPunch PK526 *Finisher FS539
*UIConstraints: *KOPunch PK526 *Finisher JS506
*UIConstraints: *KOPunch PK526 *Finisher JS508
*UIConstraints: *KOPunch PK526 *Finisher FS542
*UIConstraints: *KOPunch PK526 *Model C361i
*UIConstraints: *KOPunch PK526 *Model C301i
*UIConstraints: *KOPunch PK526 *Model C251i
*UIConstraints: *KOPunch PK526 *Model C4051i
*UIConstraints: *KOPunch PK526 *Model C3351i
*UIConstraints: *KOPunch PK526 *Model C4001i
*UIConstraints: *KOPunch PK526 *Model C3301i
*UIConstraints: *KOPunch PK526 *Model C3321i
*UIConstraints: *KOPunch PK526 *Model C360i
*UIConstraints: *KOPunch PK526 *Model C300i
*UIConstraints: *KOPunch PK526 *Model C250i
*UIConstraints: *KOPunch PK526 *Model C287i
*UIConstraints: *KOPunch PK526 *Model C257i
*UIConstraints: *KOPunch PK526 *Model C227i
*UIConstraints: *KOPunch PK526 *Model C286i
*UIConstraints: *KOPunch PK526 *Model C266i
*UIConstraints: *KOPunch PK526 *Model C226i
*UIConstraints: *KOPunch PK526 *Model C4050i
*UIConstraints: *KOPunch PK526 *Model C3350i
*UIConstraints: *KOPunch PK526 *Model C4000i
*UIConstraints: *KOPunch PK526 *Model C3300i
*UIConstraints: *KOPunch PK526 *Model C3320i
*UIConstraints: *KOPunch PK526-3 *Punch 4holes
*UIConstraints: *KOPunch PK526-3 *Finisher None
*UIConstraints: *KOPunch PK526-3 *Finisher FS533
*UIConstraints: *KOPunch PK526-3 *Finisher FS539
*UIConstraints: *KOPunch PK526-3 *Finisher JS506
*UIConstraints: *KOPunch PK526-3 *Finisher JS508
*UIConstraints: *KOPunch PK526-3 *Finisher FS542
*UIConstraints: *KOPunch PK526-3 *Model C361i
*UIConstraints: *KOPunch PK526-3 *Model C301i
*UIConstraints: *KOPunch PK526-3 *Model C251i
*UIConstraints: *KOPunch PK526-3 *Model C4051i
*UIConstraints: *KOPunch PK526-3 *Model C3351i
*UIConstraints: *KOPunch PK526-3 *Model C4001i
*UIConstraints: *KOPunch PK526-3 *Model C3301i
*UIConstraints: *KOPunch PK526-3 *Model C3321i
*UIConstraints: *KOPunch PK526-3 *Model C360i
*UIConstraints: *KOPunch PK526-3 *Model C300i
*UIConstraints: *KOPunch PK526-3 *Model C250i
*UIConstraints: *KOPunch PK526-3 *Model C287i
*UIConstraints: *KOPunch PK526-3 *Model C257i
*UIConstraints: *KOPunch PK526-3 *Model C227i
*UIConstraints: *KOPunch PK526-3 *Model C286i
*UIConstraints: *KOPunch PK526-3 *Model C266i
*UIConstraints: *KOPunch PK526-3 *Model C226i
*UIConstraints: *KOPunch PK526-3 *Model C4050i
*UIConstraints: *KOPunch PK526-3 *Model C3350i
*UIConstraints: *KOPunch PK526-3 *Model C4000i
*UIConstraints: *KOPunch PK526-3 *Model C3300i
*UIConstraints: *KOPunch PK526-3 *Model C3320i
*UIConstraints: *KOPunch PK526-4 *Punch 3holes
*UIConstraints: *KOPunch PK526-4 *Finisher None
*UIConstraints: *KOPunch PK526-4 *Finisher FS533
*UIConstraints: *KOPunch PK526-4 *Finisher FS539
*UIConstraints: *KOPunch PK526-4 *Finisher JS506
*UIConstraints: *KOPunch PK526-4 *Finisher JS508
*UIConstraints: *KOPunch PK526-4 *Finisher FS542
*UIConstraints: *KOPunch PK526-4 *Model C361i
*UIConstraints: *KOPunch PK526-4 *Model C301i
*UIConstraints: *KOPunch PK526-4 *Model C251i
*UIConstraints: *KOPunch PK526-4 *Model C4051i
*UIConstraints: *KOPunch PK526-4 *Model C3351i
*UIConstraints: *KOPunch PK526-4 *Model C4001i
*UIConstraints: *KOPunch PK526-4 *Model C3301i
*UIConstraints: *KOPunch PK526-4 *Model C3321i
*UIConstraints: *KOPunch PK526-4 *Model C360i
*UIConstraints: *KOPunch PK526-4 *Model C300i
*UIConstraints: *KOPunch PK526-4 *Model C250i
*UIConstraints: *KOPunch PK526-4 *Model C287i
*UIConstraints: *KOPunch PK526-4 *Model C257i
*UIConstraints: *KOPunch PK526-4 *Model C227i
*UIConstraints: *KOPunch PK526-4 *Model C286i
*UIConstraints: *KOPunch PK526-4 *Model C266i
*UIConstraints: *KOPunch PK526-4 *Model C226i
*UIConstraints: *KOPunch PK526-4 *Model C4050i
*UIConstraints: *KOPunch PK526-4 *Model C3350i
*UIConstraints: *KOPunch PK526-4 *Model C4000i
*UIConstraints: *KOPunch PK526-4 *Model C3300i
*UIConstraints: *KOPunch PK526-4 *Model C3320i
*UIConstraints: *KOPunch PK526-SWE4 *Punch 2holes
*UIConstraints: *KOPunch PK526-SWE4 *Punch 3holes
*UIConstraints: *KOPunch PK526-SWE4 *Finisher None
*UIConstraints: *KOPunch PK526-SWE4 *Finisher FS533
*UIConstraints: *KOPunch PK526-SWE4 *Finisher FS539
*UIConstraints: *KOPunch PK526-SWE4 *Finisher JS506
*UIConstraints: *KOPunch PK526-SWE4 *Finisher JS508
*UIConstraints: *KOPunch PK526-SWE4 *Finisher FS542
*UIConstraints: *KOPunch PK526-SWE4 *Model C361i
*UIConstraints: *KOPunch PK526-SWE4 *Model C301i
*UIConstraints: *KOPunch PK526-SWE4 *Model C251i
*UIConstraints: *KOPunch PK526-SWE4 *Model C4051i
*UIConstraints: *KOPunch PK526-SWE4 *Model C3351i
*UIConstraints: *KOPunch PK526-SWE4 *Model C4001i
*UIConstraints: *KOPunch PK526-SWE4 *Model C3301i
*UIConstraints: *KOPunch PK526-SWE4 *Model C3321i
*UIConstraints: *KOPunch PK526-SWE4 *Model C360i
*UIConstraints: *KOPunch PK526-SWE4 *Model C300i
*UIConstraints: *KOPunch PK526-SWE4 *Model C250i
*UIConstraints: *KOPunch PK526-SWE4 *Model C287i
*UIConstraints: *KOPunch PK526-SWE4 *Model C257i
*UIConstraints: *KOPunch PK526-SWE4 *Model C227i
*UIConstraints: *KOPunch PK526-SWE4 *Model C286i
*UIConstraints: *KOPunch PK526-SWE4 *Model C266i
*UIConstraints: *KOPunch PK526-SWE4 *Model C226i
*UIConstraints: *KOPunch PK526-SWE4 *Model C4050i
*UIConstraints: *KOPunch PK526-SWE4 *Model C3350i
*UIConstraints: *KOPunch PK526-SWE4 *Model C4000i
*UIConstraints: *KOPunch PK526-SWE4 *Model C3300i
*UIConstraints: *KOPunch PK526-SWE4 *Model C3320i
*UIConstraints: *KOPunch PK527 *Punch 3holes
*UIConstraints: *KOPunch PK527 *Punch 4holes
*UIConstraints: *KOPunch PK527 *Finisher None
*UIConstraints: *KOPunch PK527 *Finisher FS533
*UIConstraints: *KOPunch PK527 *Finisher FS539
*UIConstraints: *KOPunch PK527 *Finisher JS506
*UIConstraints: *KOPunch PK527 *Finisher JS508
*UIConstraints: *KOPunch PK527 *Finisher FS540
*UIConstraints: *KOPunch PK527 *Finisher FS540JS602
*UIConstraints: *KOPunch PK527 *Model C751i
*UIConstraints: *KOPunch PK527 *Model C4051i
*UIConstraints: *KOPunch PK527 *Model C3351i
*UIConstraints: *KOPunch PK527 *Model C4001i
*UIConstraints: *KOPunch PK527 *Model C3301i
*UIConstraints: *KOPunch PK527 *Model C3321i
*UIConstraints: *KOPunch PK527 *Model C750i
*UIConstraints: *KOPunch PK527 *Model C650i
*UIConstraints: *KOPunch PK527 *Model C550i
*UIConstraints: *KOPunch PK527 *Model C450i
*UIConstraints: *KOPunch PK527 *Model C360i
*UIConstraints: *KOPunch PK527 *Model C300i
*UIConstraints: *KOPunch PK527 *Model C250i
*UIConstraints: *KOPunch PK527 *Model C286i
*UIConstraints: *KOPunch PK527 *Model C266i
*UIConstraints: *KOPunch PK527 *Model C226i
*UIConstraints: *KOPunch PK527 *Model C4050i
*UIConstraints: *KOPunch PK527 *Model C3350i
*UIConstraints: *KOPunch PK527 *Model C4000i
*UIConstraints: *KOPunch PK527 *Model C3300i
*UIConstraints: *KOPunch PK527 *Model C3320i
*UIConstraints: *KOPunch PK527-3 *Punch 4holes
*UIConstraints: *KOPunch PK527-3 *Finisher None
*UIConstraints: *KOPunch PK527-3 *Finisher FS533
*UIConstraints: *KOPunch PK527-3 *Finisher FS539
*UIConstraints: *KOPunch PK527-3 *Finisher JS506
*UIConstraints: *KOPunch PK527-3 *Finisher JS508
*UIConstraints: *KOPunch PK527-3 *Finisher FS540
*UIConstraints: *KOPunch PK527-3 *Finisher FS540JS602
*UIConstraints: *KOPunch PK527-3 *Model C751i
*UIConstraints: *KOPunch PK527-3 *Model C4051i
*UIConstraints: *KOPunch PK527-3 *Model C3351i
*UIConstraints: *KOPunch PK527-3 *Model C4001i
*UIConstraints: *KOPunch PK527-3 *Model C3301i
*UIConstraints: *KOPunch PK527-3 *Model C3321i
*UIConstraints: *KOPunch PK527-3 *Model C750i
*UIConstraints: *KOPunch PK527-3 *Model C650i
*UIConstraints: *KOPunch PK527-3 *Model C550i
*UIConstraints: *KOPunch PK527-3 *Model C450i
*UIConstraints: *KOPunch PK527-3 *Model C360i
*UIConstraints: *KOPunch PK527-3 *Model C300i
*UIConstraints: *KOPunch PK527-3 *Model C250i
*UIConstraints: *KOPunch PK527-3 *Model C286i
*UIConstraints: *KOPunch PK527-3 *Model C266i
*UIConstraints: *KOPunch PK527-3 *Model C226i
*UIConstraints: *KOPunch PK527-3 *Model C4050i
*UIConstraints: *KOPunch PK527-3 *Model C3350i
*UIConstraints: *KOPunch PK527-3 *Model C4000i
*UIConstraints: *KOPunch PK527-3 *Model C3300i
*UIConstraints: *KOPunch PK527-3 *Model C3320i
*UIConstraints: *KOPunch PK527-4 *Punch 3holes
*UIConstraints: *KOPunch PK527-4 *Finisher None
*UIConstraints: *KOPunch PK527-4 *Finisher FS533
*UIConstraints: *KOPunch PK527-4 *Finisher FS539
*UIConstraints: *KOPunch PK527-4 *Finisher JS506
*UIConstraints: *KOPunch PK527-4 *Finisher JS508
*UIConstraints: *KOPunch PK527-4 *Finisher FS540
*UIConstraints: *KOPunch PK527-4 *Finisher FS540JS602
*UIConstraints: *KOPunch PK527-4 *Model C751i
*UIConstraints: *KOPunch PK527-4 *Model C4051i
*UIConstraints: *KOPunch PK527-4 *Model C3351i
*UIConstraints: *KOPunch PK527-4 *Model C4001i
*UIConstraints: *KOPunch PK527-4 *Model C3301i
*UIConstraints: *KOPunch PK527-4 *Model C3321i
*UIConstraints: *KOPunch PK527-4 *Model C750i
*UIConstraints: *KOPunch PK527-4 *Model C650i
*UIConstraints: *KOPunch PK527-4 *Model C550i
*UIConstraints: *KOPunch PK527-4 *Model C450i
*UIConstraints: *KOPunch PK527-4 *Model C360i
*UIConstraints: *KOPunch PK527-4 *Model C300i
*UIConstraints: *KOPunch PK527-4 *Model C250i
*UIConstraints: *KOPunch PK527-4 *Model C286i
*UIConstraints: *KOPunch PK527-4 *Model C266i
*UIConstraints: *KOPunch PK527-4 *Model C226i
*UIConstraints: *KOPunch PK527-4 *Model C4050i
*UIConstraints: *KOPunch PK527-4 *Model C3350i
*UIConstraints: *KOPunch PK527-4 *Model C4000i
*UIConstraints: *KOPunch PK527-4 *Model C3300i
*UIConstraints: *KOPunch PK527-4 *Model C3320i
*UIConstraints: *KOPunch PK527-SWE4 *Punch 2holes
*UIConstraints: *KOPunch PK527-SWE4 *Punch 3holes
*UIConstraints: *KOPunch PK527-SWE4 *Finisher None
*UIConstraints: *KOPunch PK527-SWE4 *Finisher FS533
*UIConstraints: *KOPunch PK527-SWE4 *Finisher FS539
*UIConstraints: *KOPunch PK527-SWE4 *Finisher JS506
*UIConstraints: *KOPunch PK527-SWE4 *Finisher JS508
*UIConstraints: *KOPunch PK527-SWE4 *Finisher FS540
*UIConstraints: *KOPunch PK527-SWE4 *Finisher FS540JS602
*UIConstraints: *KOPunch PK527-SWE4 *Model C751i
*UIConstraints: *KOPunch PK527-SWE4 *Model C4051i
*UIConstraints: *KOPunch PK527-SWE4 *Model C3351i
*UIConstraints: *KOPunch PK527-SWE4 *Model C4001i
*UIConstraints: *KOPunch PK527-SWE4 *Model C3301i
*UIConstraints: *KOPunch PK527-SWE4 *Model C3321i
*UIConstraints: *KOPunch PK527-SWE4 *Model C750i
*UIConstraints: *KOPunch PK527-SWE4 *Model C650i
*UIConstraints: *KOPunch PK527-SWE4 *Model C550i
*UIConstraints: *KOPunch PK527-SWE4 *Model C450i
*UIConstraints: *KOPunch PK527-SWE4 *Model C360i
*UIConstraints: *KOPunch PK527-SWE4 *Model C300i
*UIConstraints: *KOPunch PK527-SWE4 *Model C250i
*UIConstraints: *KOPunch PK527-SWE4 *Model C286i
*UIConstraints: *KOPunch PK527-SWE4 *Model C266i
*UIConstraints: *KOPunch PK527-SWE4 *Model C226i
*UIConstraints: *KOPunch PK527-SWE4 *Model C4050i
*UIConstraints: *KOPunch PK527-SWE4 *Model C3350i
*UIConstraints: *KOPunch PK527-SWE4 *Model C4000i
*UIConstraints: *KOPunch PK527-SWE4 *Model C3300i
*UIConstraints: *KOPunch PK527-SWE4 *Model C3320i
*UIConstraints: *ZFoldUnit None *Fold ZFold1
*UIConstraints: *ZFoldUnit None *Fold ZFold2
*UIConstraints: *ZFoldUnit ZU609 *Finisher None
*UIConstraints: *ZFoldUnit ZU609 *Finisher FS533
*UIConstraints: *ZFoldUnit ZU609 *Finisher FS539
*UIConstraints: *ZFoldUnit ZU609 *Finisher JS506
*UIConstraints: *ZFoldUnit ZU609 *Finisher JS508
*UIConstraints: *ZFoldUnit ZU609 *Finisher FS542
*UIConstraints: *ZFoldUnit ZU609 *Model C361i
*UIConstraints: *ZFoldUnit ZU609 *Model C301i
*UIConstraints: *ZFoldUnit ZU609 *Model C251i
*UIConstraints: *ZFoldUnit ZU609 *Model C4051i
*UIConstraints: *ZFoldUnit ZU609 *Model C3351i
*UIConstraints: *ZFoldUnit ZU609 *Model C4001i
*UIConstraints: *ZFoldUnit ZU609 *Model C3301i
*UIConstraints: *ZFoldUnit ZU609 *Model C3321i
*UIConstraints: *ZFoldUnit ZU609 *Model C360i
*UIConstraints: *ZFoldUnit ZU609 *Model C300i
*UIConstraints: *ZFoldUnit ZU609 *Model C250i
*UIConstraints: *ZFoldUnit ZU609 *Model C287i
*UIConstraints: *ZFoldUnit ZU609 *Model C257i
*UIConstraints: *ZFoldUnit ZU609 *Model C227i
*UIConstraints: *ZFoldUnit ZU609 *Model C286i
*UIConstraints: *ZFoldUnit ZU609 *Model C266i
*UIConstraints: *ZFoldUnit ZU609 *Model C226i
*UIConstraints: *ZFoldUnit ZU609 *Model C4050i
*UIConstraints: *ZFoldUnit ZU609 *Model C3350i
*UIConstraints: *ZFoldUnit ZU609 *Model C4000i
*UIConstraints: *ZFoldUnit ZU609 *Model C3300i
*UIConstraints: *ZFoldUnit ZU609 *Model C3320i
*UIConstraints: *PostInserter None *PIFrontCover PITray1
*UIConstraints: *PostInserter None *PIFrontCover PITray2
*UIConstraints: *PostInserter None *PIBackCover PITray1
*UIConstraints: *PostInserter None *PIBackCover PITray2
*UIConstraints: *PostInserter PI507 *Finisher None
*UIConstraints: *PostInserter PI507 *Finisher FS533
*UIConstraints: *PostInserter PI507 *Finisher FS539
*UIConstraints: *PostInserter PI507 *Finisher JS506
*UIConstraints: *PostInserter PI507 *Finisher JS508
*UIConstraints: *PostInserter PI507 *Finisher FS540JS602
*UIConstraints: *PostInserter PI507 *Finisher FS542
*UIConstraints: *PostInserter PI507 *Model C361i
*UIConstraints: *PostInserter PI507 *Model C301i
*UIConstraints: *PostInserter PI507 *Model C251i
*UIConstraints: *PostInserter PI507 *Model C4051i
*UIConstraints: *PostInserter PI507 *Model C3351i
*UIConstraints: *PostInserter PI507 *Model C4001i
*UIConstraints: *PostInserter PI507 *Model C3301i
*UIConstraints: *PostInserter PI507 *Model C3321i
*UIConstraints: *PostInserter PI507 *Model C360i
*UIConstraints: *PostInserter PI507 *Model C300i
*UIConstraints: *PostInserter PI507 *Model C250i
*UIConstraints: *PostInserter PI507 *Model C287i
*UIConstraints: *PostInserter PI507 *Model C257i
*UIConstraints: *PostInserter PI507 *Model C227i
*UIConstraints: *PostInserter PI507 *Model C286i
*UIConstraints: *PostInserter PI507 *Model C266i
*UIConstraints: *PostInserter PI507 *Model C226i
*UIConstraints: *PostInserter PI507 *Model C4050i
*UIConstraints: *PostInserter PI507 *Model C3350i
*UIConstraints: *PostInserter PI507 *Model C4000i
*UIConstraints: *PostInserter PI507 *Model C3300i
*UIConstraints: *PostInserter PI507 *Model C3320i
*UIConstraints: *SaddleUnit None *Fold Stitch
*UIConstraints: *SaddleUnit None *Fold HalfFold
*UIConstraints: *SaddleUnit None *Fold TriFold
*UIConstraints: *SaddleUnit SD511 *Finisher None
*UIConstraints: *SaddleUnit SD511 *Finisher FS533
*UIConstraints: *SaddleUnit SD511 *Finisher JS506
*UIConstraints: *SaddleUnit SD511 *Finisher JS508
*UIConstraints: *SaddleUnit SD511 *Finisher FS540
*UIConstraints: *SaddleUnit SD511 *Finisher FS540JS602
*UIConstraints: *SaddleUnit SD511 *Finisher FS542
*UIConstraints: *SaddleUnit SD511 *Model C4051i
*UIConstraints: *SaddleUnit SD511 *Model C3351i
*UIConstraints: *SaddleUnit SD511 *Model C4001i
*UIConstraints: *SaddleUnit SD511 *Model C3301i
*UIConstraints: *SaddleUnit SD511 *Model C3321i
*UIConstraints: *SaddleUnit SD511 *Model C286i
*UIConstraints: *SaddleUnit SD511 *Model C266i
*UIConstraints: *SaddleUnit SD511 *Model C226i
*UIConstraints: *SaddleUnit SD511 *Model C4050i
*UIConstraints: *SaddleUnit SD511 *Model C3350i
*UIConstraints: *SaddleUnit SD511 *Model C4000i
*UIConstraints: *SaddleUnit SD511 *Model C3300i
*UIConstraints: *SaddleUnit SD511 *Model C3320i
*UIConstraints: *SaddleUnit SD512 *Finisher None
*UIConstraints: *SaddleUnit SD512 *Finisher FS533
*UIConstraints: *SaddleUnit SD512 *Finisher FS539
*UIConstraints: *SaddleUnit SD512 *Finisher JS506
*UIConstraints: *SaddleUnit SD512 *Finisher JS508
*UIConstraints: *SaddleUnit SD512 *Finisher FS542
*UIConstraints: *SaddleUnit SD512 *Model C361i
*UIConstraints: *SaddleUnit SD512 *Model C301i
*UIConstraints: *SaddleUnit SD512 *Model C251i
*UIConstraints: *SaddleUnit SD512 *Model C4051i
*UIConstraints: *SaddleUnit SD512 *Model C3351i
*UIConstraints: *SaddleUnit SD512 *Model C4001i
*UIConstraints: *SaddleUnit SD512 *Model C3301i
*UIConstraints: *SaddleUnit SD512 *Model C3321i
*UIConstraints: *SaddleUnit SD512 *Model C360i
*UIConstraints: *SaddleUnit SD512 *Model C300i
*UIConstraints: *SaddleUnit SD512 *Model C250i
*UIConstraints: *SaddleUnit SD512 *Model C287i
*UIConstraints: *SaddleUnit SD512 *Model C257i
*UIConstraints: *SaddleUnit SD512 *Model C227i
*UIConstraints: *SaddleUnit SD512 *Model C286i
*UIConstraints: *SaddleUnit SD512 *Model C266i
*UIConstraints: *SaddleUnit SD512 *Model C226i
*UIConstraints: *SaddleUnit SD512 *Model C4050i
*UIConstraints: *SaddleUnit SD512 *Model C3350i
*UIConstraints: *SaddleUnit SD512 *Model C4000i
*UIConstraints: *SaddleUnit SD512 *Model C3300i
*UIConstraints: *SaddleUnit SD512 *Model C3320i
*UIConstraints: *PrinterHDD HDD *Model C4001i
*UIConstraints: *PrinterHDD HDD *Model C3301i
*UIConstraints: *PrinterHDD HDD *Model C3321i
*UIConstraints: *PrinterHDD HDD *Model C4000i
*UIConstraints: *PrinterHDD HDD *Model C3300i
*UIConstraints: *PrinterHDD HDD *Model C3320i
*UIConstraints: *Model C751i *MediaType Labels
*UIConstraints: *Model C751i *MediaType Postcard
*UIConstraints: *Model C751i *MediaType Glossy
*UIConstraints: *Model C751i *MediaType GlossyPlus
*UIConstraints: *Model C751i *MediaType Glossy2
*UIConstraints: *Model C751i *MediaType User2_1
*UIConstraints: *Model C751i *MediaType User2(2nd)_1
*UIConstraints: *Model C751i *PageSize LetterPlus
*UIConstraints: *Model C751i *PageSize 8x10
*UIConstraints: *Model C751i *PageSize 8x10.5
*UIConstraints: *Model C751i *PageSize DoublePostcardRotated
*UIConstraints: *Model C751i *PaperSources LU207
*UIConstraints: *Model C751i *PaperSources LU302
*UIConstraints: *Model C751i *PaperSources PC116
*UIConstraints: *Model C751i *PaperSources PC116+LU207
*UIConstraints: *Model C751i *PaperSources PC116+LU302
*UIConstraints: *Model C751i *PaperSources PC118
*UIConstraints: *Model C751i *PaperSources PC216
*UIConstraints: *Model C751i *PaperSources PC216+LU207
*UIConstraints: *Model C751i *PaperSources PC216+LU302
*UIConstraints: *Model C751i *PaperSources PC218
*UIConstraints: *Model C751i *PaperSources PC416
*UIConstraints: *Model C751i *PaperSources PC416+LU207
*UIConstraints: *Model C751i *PaperSources PC416+LU302
*UIConstraints: *Model C751i *PaperSources PC417
*UIConstraints: *Model C751i *PaperSources PC417+LU207
*UIConstraints: *Model C751i *PaperSources PC417+LU302
*UIConstraints: *Model C751i *PaperSources PC418
*UIConstraints: *Model C751i *PaperSources PFP13T2
*UIConstraints: *Model C751i *PaperSources PFP13T23
*UIConstraints: *Model C751i *PaperSources PFP13T234
*UIConstraints: *Model C751i *Finisher FS533
*UIConstraints: *Model C751i *Finisher JS506
*UIConstraints: *Model C751i *Finisher JS508
*UIConstraints: *Model C751i *Finisher FS542
*UIConstraints: *Model C751i *KOPunch PK519
*UIConstraints: *Model C751i *KOPunch PK519-3
*UIConstraints: *Model C751i *KOPunch PK519-4
*UIConstraints: *Model C751i *KOPunch PK519-SWE4
*UIConstraints: *Model C751i *KOPunch PK527
*UIConstraints: *Model C751i *KOPunch PK527-3
*UIConstraints: *Model C751i *KOPunch PK527-4
*UIConstraints: *Model C751i *KOPunch PK527-SWE4
*UIConstraints: *Model C651i *MediaType Labels
*UIConstraints: *Model C651i *MediaType Postcard
*UIConstraints: *Model C651i *MediaType Glossy
*UIConstraints: *Model C651i *MediaType GlossyPlus
*UIConstraints: *Model C651i *MediaType Glossy2
*UIConstraints: *Model C651i *MediaType User2_1
*UIConstraints: *Model C651i *MediaType User2(2nd)_1
*UIConstraints: *Model C651i *MediaType User7
*UIConstraints: *Model C651i *MediaType User7(2nd)
*UIConstraints: *Model C651i *PageSize LetterPlus
*UIConstraints: *Model C651i *PageSize 8x10
*UIConstraints: *Model C651i *PageSize 8x10.5
*UIConstraints: *Model C651i *PageSize DoublePostcardRotated
*UIConstraints: *Model C651i *PaperSources LU205
*UIConstraints: *Model C651i *PaperSources LU303
*UIConstraints: *Model C651i *PaperSources PC118
*UIConstraints: *Model C651i *PaperSources PC218
*UIConstraints: *Model C651i *PaperSources PC418
*UIConstraints: *Model C651i *PaperSources PFP13T2
*UIConstraints: *Model C651i *PaperSources PFP13T23
*UIConstraints: *Model C651i *PaperSources PFP13T234
*UIConstraints: *Model C651i *Finisher FS533
*UIConstraints: *Model C651i *Finisher JS506
*UIConstraints: *Model C651i *Finisher JS508
*UIConstraints: *Model C651i *KOPunch PK519
*UIConstraints: *Model C651i *KOPunch PK519-3
*UIConstraints: *Model C651i *KOPunch PK519-4
*UIConstraints: *Model C651i *KOPunch PK519-SWE4
*UIConstraints: *Model C551i *MediaType Labels
*UIConstraints: *Model C551i *MediaType Postcard
*UIConstraints: *Model C551i *MediaType Glossy
*UIConstraints: *Model C551i *MediaType GlossyPlus
*UIConstraints: *Model C551i *MediaType Glossy2
*UIConstraints: *Model C551i *MediaType User2_1
*UIConstraints: *Model C551i *MediaType User2(2nd)_1
*UIConstraints: *Model C551i *MediaType User7
*UIConstraints: *Model C551i *MediaType User7(2nd)
*UIConstraints: *Model C551i *PageSize LetterPlus
*UIConstraints: *Model C551i *PageSize 8x10
*UIConstraints: *Model C551i *PageSize 8x10.5
*UIConstraints: *Model C551i *PageSize DoublePostcardRotated
*UIConstraints: *Model C551i *PaperSources LU205
*UIConstraints: *Model C551i *PaperSources LU303
*UIConstraints: *Model C551i *PaperSources PC118
*UIConstraints: *Model C551i *PaperSources PC218
*UIConstraints: *Model C551i *PaperSources PC418
*UIConstraints: *Model C551i *PaperSources PFP13T2
*UIConstraints: *Model C551i *PaperSources PFP13T23
*UIConstraints: *Model C551i *PaperSources PFP13T234
*UIConstraints: *Model C551i *Finisher JS506
*UIConstraints: *Model C451i *MediaType Labels
*UIConstraints: *Model C451i *MediaType Postcard
*UIConstraints: *Model C451i *MediaType Glossy
*UIConstraints: *Model C451i *MediaType GlossyPlus
*UIConstraints: *Model C451i *MediaType Glossy2
*UIConstraints: *Model C451i *MediaType User2_1
*UIConstraints: *Model C451i *MediaType User2(2nd)_1
*UIConstraints: *Model C451i *MediaType User7
*UIConstraints: *Model C451i *MediaType User7(2nd)
*UIConstraints: *Model C451i *PageSize LetterPlus
*UIConstraints: *Model C451i *PageSize 8x10
*UIConstraints: *Model C451i *PageSize 8x10.5
*UIConstraints: *Model C451i *PageSize DoublePostcardRotated
*UIConstraints: *Model C451i *PaperSources LU205
*UIConstraints: *Model C451i *PaperSources LU303
*UIConstraints: *Model C451i *PaperSources PC118
*UIConstraints: *Model C451i *PaperSources PC218
*UIConstraints: *Model C451i *PaperSources PC418
*UIConstraints: *Model C451i *PaperSources PFP13T2
*UIConstraints: *Model C451i *PaperSources PFP13T23
*UIConstraints: *Model C451i *PaperSources PFP13T234
*UIConstraints: *Model C451i *Finisher JS506
*UIConstraints: *Model C361i *MediaType Labels
*UIConstraints: *Model C361i *MediaType Postcard
*UIConstraints: *Model C361i *MediaType Glossy
*UIConstraints: *Model C361i *MediaType GlossyPlus
*UIConstraints: *Model C361i *MediaType Glossy2
*UIConstraints: *Model C361i *MediaType User2_1
*UIConstraints: *Model C361i *MediaType User2(2nd)_1
*UIConstraints: *Model C361i *MediaType User7
*UIConstraints: *Model C361i *MediaType User7(2nd)
*UIConstraints: *Model C361i *PageSize LetterPlus
*UIConstraints: *Model C361i *PageSize 8x10
*UIConstraints: *Model C361i *PageSize 8x10.5
*UIConstraints: *Model C361i *PageSize DoublePostcardRotated
*UIConstraints: *Model C361i *OutputBin Tray4
*UIConstraints: *Model C361i *Fold ZFold1
*UIConstraints: *Model C361i *Fold ZFold2
*UIConstraints: *Model C361i *PIFrontCover PITray1
*UIConstraints: *Model C361i *PIFrontCover PITray2
*UIConstraints: *Model C361i *PIBackCover PITray1
*UIConstraints: *Model C361i *PIBackCover PITray2
*UIConstraints: *Model C361i *PaperSources LU207
*UIConstraints: *Model C361i *PaperSources LU205
*UIConstraints: *Model C361i *PaperSources LU303
*UIConstraints: *Model C361i *PaperSources PC116+LU207
*UIConstraints: *Model C361i *PaperSources PC118
*UIConstraints: *Model C361i *PaperSources PC216+LU207
*UIConstraints: *Model C361i *PaperSources PC218
*UIConstraints: *Model C361i *PaperSources PC416+LU207
*UIConstraints: *Model C361i *PaperSources PC417+LU207
*UIConstraints: *Model C361i *PaperSources PC418
*UIConstraints: *Model C361i *PaperSources PFP13T2
*UIConstraints: *Model C361i *PaperSources PFP13T23
*UIConstraints: *Model C361i *PaperSources PFP13T234
*UIConstraints: *Model C361i *Finisher JS508
*UIConstraints: *Model C361i *Finisher FS540
*UIConstraints: *Model C361i *Finisher FS540JS602
*UIConstraints: *Model C361i *KOPunch PK526
*UIConstraints: *Model C361i *KOPunch PK526-3
*UIConstraints: *Model C361i *KOPunch PK526-4
*UIConstraints: *Model C361i *KOPunch PK526-SWE4
*UIConstraints: *Model C361i *ZFoldUnit ZU609
*UIConstraints: *Model C361i *PostInserter PI507
*UIConstraints: *Model C361i *SaddleUnit SD512
*UIConstraints: *Model C301i *MediaType Labels
*UIConstraints: *Model C301i *MediaType Postcard
*UIConstraints: *Model C301i *MediaType Glossy
*UIConstraints: *Model C301i *MediaType GlossyPlus
*UIConstraints: *Model C301i *MediaType Glossy2
*UIConstraints: *Model C301i *MediaType User2_1
*UIConstraints: *Model C301i *MediaType User2(2nd)_1
*UIConstraints: *Model C301i *MediaType User7
*UIConstraints: *Model C301i *MediaType User7(2nd)
*UIConstraints: *Model C301i *PageSize LetterPlus
*UIConstraints: *Model C301i *PageSize 8x10
*UIConstraints: *Model C301i *PageSize 8x10.5
*UIConstraints: *Model C301i *PageSize DoublePostcardRotated
*UIConstraints: *Model C301i *OutputBin Tray4
*UIConstraints: *Model C301i *Fold ZFold1
*UIConstraints: *Model C301i *Fold ZFold2
*UIConstraints: *Model C301i *PIFrontCover PITray1
*UIConstraints: *Model C301i *PIFrontCover PITray2
*UIConstraints: *Model C301i *PIBackCover PITray1
*UIConstraints: *Model C301i *PIBackCover PITray2
*UIConstraints: *Model C301i *PaperSources LU207
*UIConstraints: *Model C301i *PaperSources LU205
*UIConstraints: *Model C301i *PaperSources LU303
*UIConstraints: *Model C301i *PaperSources PC116+LU207
*UIConstraints: *Model C301i *PaperSources PC118
*UIConstraints: *Model C301i *PaperSources PC216+LU207
*UIConstraints: *Model C301i *PaperSources PC218
*UIConstraints: *Model C301i *PaperSources PC416+LU207
*UIConstraints: *Model C301i *PaperSources PC417+LU207
*UIConstraints: *Model C301i *PaperSources PC418
*UIConstraints: *Model C301i *PaperSources PFP13T2
*UIConstraints: *Model C301i *PaperSources PFP13T23
*UIConstraints: *Model C301i *PaperSources PFP13T234
*UIConstraints: *Model C301i *Finisher JS508
*UIConstraints: *Model C301i *Finisher FS540
*UIConstraints: *Model C301i *Finisher FS540JS602
*UIConstraints: *Model C301i *KOPunch PK526
*UIConstraints: *Model C301i *KOPunch PK526-3
*UIConstraints: *Model C301i *KOPunch PK526-4
*UIConstraints: *Model C301i *KOPunch PK526-SWE4
*UIConstraints: *Model C301i *ZFoldUnit ZU609
*UIConstraints: *Model C301i *PostInserter PI507
*UIConstraints: *Model C301i *SaddleUnit SD512
*UIConstraints: *Model C251i *MediaType Labels
*UIConstraints: *Model C251i *MediaType Postcard
*UIConstraints: *Model C251i *MediaType Glossy
*UIConstraints: *Model C251i *MediaType GlossyPlus
*UIConstraints: *Model C251i *MediaType Glossy2
*UIConstraints: *Model C251i *MediaType User2_1
*UIConstraints: *Model C251i *MediaType User2(2nd)_1
*UIConstraints: *Model C251i *MediaType User7
*UIConstraints: *Model C251i *MediaType User7(2nd)
*UIConstraints: *Model C251i *PageSize LetterPlus
*UIConstraints: *Model C251i *PageSize 8x10
*UIConstraints: *Model C251i *PageSize 8x10.5
*UIConstraints: *Model C251i *PageSize DoublePostcardRotated
*UIConstraints: *Model C251i *OutputBin Tray4
*UIConstraints: *Model C251i *Fold ZFold1
*UIConstraints: *Model C251i *Fold ZFold2
*UIConstraints: *Model C251i *PIFrontCover PITray1
*UIConstraints: *Model C251i *PIFrontCover PITray2
*UIConstraints: *Model C251i *PIBackCover PITray1
*UIConstraints: *Model C251i *PIBackCover PITray2
*UIConstraints: *Model C251i *PaperSources LU207
*UIConstraints: *Model C251i *PaperSources LU205
*UIConstraints: *Model C251i *PaperSources LU303
*UIConstraints: *Model C251i *PaperSources PC116+LU207
*UIConstraints: *Model C251i *PaperSources PC118
*UIConstraints: *Model C251i *PaperSources PC216+LU207
*UIConstraints: *Model C251i *PaperSources PC218
*UIConstraints: *Model C251i *PaperSources PC416+LU207
*UIConstraints: *Model C251i *PaperSources PC417+LU207
*UIConstraints: *Model C251i *PaperSources PC418
*UIConstraints: *Model C251i *PaperSources PFP13T2
*UIConstraints: *Model C251i *PaperSources PFP13T23
*UIConstraints: *Model C251i *PaperSources PFP13T234
*UIConstraints: *Model C251i *Finisher JS508
*UIConstraints: *Model C251i *Finisher FS540
*UIConstraints: *Model C251i *Finisher FS540JS602
*UIConstraints: *Model C251i *KOPunch PK526
*UIConstraints: *Model C251i *KOPunch PK526-3
*UIConstraints: *Model C251i *KOPunch PK526-4
*UIConstraints: *Model C251i *KOPunch PK526-SWE4
*UIConstraints: *Model C251i *ZFoldUnit ZU609
*UIConstraints: *Model C251i *PostInserter PI507
*UIConstraints: *Model C251i *SaddleUnit SD512
*UIConstraints: *Model C4051i *Offset True
*UIConstraints: *Model C4051i *InputSlot LCT
*UIConstraints: *Model C4051i *MediaType Thick3
*UIConstraints: *Model C4051i *MediaType Thick3(2nd)
*UIConstraints: *Model C4051i *MediaType Thick4
*UIConstraints: *Model C4051i *MediaType Thick4(2nd)
*UIConstraints: *Model C4051i *MediaType Thin
*UIConstraints: *Model C4051i *MediaType Transparency
*UIConstraints: *Model C4051i *MediaType TAB
*UIConstraints: *Model C4051i *MediaType User2_1
*UIConstraints: *Model C4051i *MediaType User2(2nd)_1
*UIConstraints: *Model C4051i *MediaType User6
*UIConstraints: *Model C4051i *MediaType User6(2nd)
*UIConstraints: *Model C4051i *MediaType User7
*UIConstraints: *Model C4051i *MediaType User7(2nd)
*UIConstraints: *Model C4051i *PageSize A3
*UIConstraints: *Model C4051i *PageSize B4
*UIConstraints: *Model C4051i *PageSize SRA3
*UIConstraints: *Model C4051i *PageSize 220mmx330mm
*UIConstraints: *Model C4051i *PageSize 12x18
*UIConstraints: *Model C4051i *PageSize Tabloid
*UIConstraints: *Model C4051i *PageSize 8K
*UIConstraints: *Model C4051i *PageSize EnvC4
*UIConstraints: *Model C4051i *PageSize EnvC5
*UIConstraints: *Model C4051i *PageSize EnvKaku1
*UIConstraints: *Model C4051i *PageSize EnvKaku2
*UIConstraints: *Model C4051i *PageSize EnvKaku3
*UIConstraints: *Model C4051i *PageSize A3Extra
*UIConstraints: *Model C4051i *PageSize A4Extra
*UIConstraints: *Model C4051i *PageSize A5Extra
*UIConstraints: *Model C4051i *PageSize B4Extra
*UIConstraints: *Model C4051i *PageSize B5Extra
*UIConstraints: *Model C4051i *PageSize TabloidExtra
*UIConstraints: *Model C4051i *PageSize LetterExtra
*UIConstraints: *Model C4051i *PageSize StatementExtra
*UIConstraints: *Model C4051i *PageSize LetterTab-F
*UIConstraints: *Model C4051i *PageSize A4Tab-F
*UIConstraints: *Model C4051i *OutputBin Tray1
*UIConstraints: *Model C4051i *OutputBin Tray2
*UIConstraints: *Model C4051i *OutputBin Tray3
*UIConstraints: *Model C4051i *OutputBin Tray4
*UIConstraints: *Model C4051i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C4051i *Staple 1StapleZeroLeft
*UIConstraints: *Model C4051i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C4051i *Staple 1StapleZeroRight
*UIConstraints: *Model C4051i *Staple 2Staples
*UIConstraints: *Model C4051i *Punch 2holes
*UIConstraints: *Model C4051i *Punch 3holes
*UIConstraints: *Model C4051i *Punch 4holes
*UIConstraints: *Model C4051i *Fold Stitch
*UIConstraints: *Model C4051i *Fold HalfFold
*UIConstraints: *Model C4051i *Fold TriFold
*UIConstraints: *Model C4051i *Fold ZFold1
*UIConstraints: *Model C4051i *Fold ZFold2
*UIConstraints: *Model C4051i *FrontCoverTray LCT
*UIConstraints: *Model C4051i *BackCoverTray LCT
*UIConstraints: *Model C4051i *PIFrontCover PITray1
*UIConstraints: *Model C4051i *PIFrontCover PITray2
*UIConstraints: *Model C4051i *PIBackCover PITray1
*UIConstraints: *Model C4051i *PIBackCover PITray2
*UIConstraints: *Model C4051i *TransparencyInterleave Blank
*UIConstraints: *Model C4051i *OHPOpTray Tray1
*UIConstraints: *Model C4051i *OHPOpTray Tray2
*UIConstraints: *Model C4051i *OHPOpTray Tray3
*UIConstraints: *Model C4051i *OHPOpTray Tray4
*UIConstraints: *Model C4051i *OHPOpTray LCT
*UIConstraints: *Model C4051i *PaperSources LU207
*UIConstraints: *Model C4051i *PaperSources LU302
*UIConstraints: *Model C4051i *PaperSources LU205
*UIConstraints: *Model C4051i *PaperSources LU303
*UIConstraints: *Model C4051i *PaperSources PC116
*UIConstraints: *Model C4051i *PaperSources PC116+LU207
*UIConstraints: *Model C4051i *PaperSources PC116+LU302
*UIConstraints: *Model C4051i *PaperSources PC118
*UIConstraints: *Model C4051i *PaperSources PC216
*UIConstraints: *Model C4051i *PaperSources PC216+LU207
*UIConstraints: *Model C4051i *PaperSources PC216+LU302
*UIConstraints: *Model C4051i *PaperSources PC218
*UIConstraints: *Model C4051i *PaperSources PC416
*UIConstraints: *Model C4051i *PaperSources PC416+LU207
*UIConstraints: *Model C4051i *PaperSources PC416+LU302
*UIConstraints: *Model C4051i *PaperSources PC417
*UIConstraints: *Model C4051i *PaperSources PC417+LU207
*UIConstraints: *Model C4051i *PaperSources PC417+LU302
*UIConstraints: *Model C4051i *PaperSources PC418
*UIConstraints: *Model C4051i *Finisher FS533
*UIConstraints: *Model C4051i *Finisher FS539
*UIConstraints: *Model C4051i *Finisher JS506
*UIConstraints: *Model C4051i *Finisher JS508
*UIConstraints: *Model C4051i *Finisher FS540
*UIConstraints: *Model C4051i *Finisher FS540JS602
*UIConstraints: *Model C4051i *Finisher FS542
*UIConstraints: *Model C4051i *KOPunch PK519
*UIConstraints: *Model C4051i *KOPunch PK519-3
*UIConstraints: *Model C4051i *KOPunch PK519-4
*UIConstraints: *Model C4051i *KOPunch PK519-SWE4
*UIConstraints: *Model C4051i *KOPunch PK524
*UIConstraints: *Model C4051i *KOPunch PK524-3
*UIConstraints: *Model C4051i *KOPunch PK524-4
*UIConstraints: *Model C4051i *KOPunch PK524-SWE4
*UIConstraints: *Model C4051i *KOPunch PK526
*UIConstraints: *Model C4051i *KOPunch PK526-3
*UIConstraints: *Model C4051i *KOPunch PK526-4
*UIConstraints: *Model C4051i *KOPunch PK526-SWE4
*UIConstraints: *Model C4051i *KOPunch PK527
*UIConstraints: *Model C4051i *KOPunch PK527-3
*UIConstraints: *Model C4051i *KOPunch PK527-4
*UIConstraints: *Model C4051i *KOPunch PK527-SWE4
*UIConstraints: *Model C4051i *ZFoldUnit ZU609
*UIConstraints: *Model C4051i *PostInserter PI507
*UIConstraints: *Model C4051i *SaddleUnit SD511
*UIConstraints: *Model C4051i *SaddleUnit SD512
*UIConstraints: *Model C3351i *Offset True
*UIConstraints: *Model C3351i *InputSlot LCT
*UIConstraints: *Model C3351i *MediaType Thick3
*UIConstraints: *Model C3351i *MediaType Thick3(2nd)
*UIConstraints: *Model C3351i *MediaType Thick4
*UIConstraints: *Model C3351i *MediaType Thick4(2nd)
*UIConstraints: *Model C3351i *MediaType Thin
*UIConstraints: *Model C3351i *MediaType Transparency
*UIConstraints: *Model C3351i *MediaType TAB
*UIConstraints: *Model C3351i *MediaType User2_1
*UIConstraints: *Model C3351i *MediaType User2(2nd)_1
*UIConstraints: *Model C3351i *MediaType User6
*UIConstraints: *Model C3351i *MediaType User6(2nd)
*UIConstraints: *Model C3351i *MediaType User7
*UIConstraints: *Model C3351i *MediaType User7(2nd)
*UIConstraints: *Model C3351i *PageSize A3
*UIConstraints: *Model C3351i *PageSize B4
*UIConstraints: *Model C3351i *PageSize SRA3
*UIConstraints: *Model C3351i *PageSize 220mmx330mm
*UIConstraints: *Model C3351i *PageSize 12x18
*UIConstraints: *Model C3351i *PageSize Tabloid
*UIConstraints: *Model C3351i *PageSize 8K
*UIConstraints: *Model C3351i *PageSize EnvC4
*UIConstraints: *Model C3351i *PageSize EnvC5
*UIConstraints: *Model C3351i *PageSize EnvKaku1
*UIConstraints: *Model C3351i *PageSize EnvKaku2
*UIConstraints: *Model C3351i *PageSize EnvKaku3
*UIConstraints: *Model C3351i *PageSize A3Extra
*UIConstraints: *Model C3351i *PageSize A4Extra
*UIConstraints: *Model C3351i *PageSize A5Extra
*UIConstraints: *Model C3351i *PageSize B4Extra
*UIConstraints: *Model C3351i *PageSize B5Extra
*UIConstraints: *Model C3351i *PageSize TabloidExtra
*UIConstraints: *Model C3351i *PageSize LetterExtra
*UIConstraints: *Model C3351i *PageSize StatementExtra
*UIConstraints: *Model C3351i *PageSize LetterTab-F
*UIConstraints: *Model C3351i *PageSize A4Tab-F
*UIConstraints: *Model C3351i *OutputBin Tray1
*UIConstraints: *Model C3351i *OutputBin Tray2
*UIConstraints: *Model C3351i *OutputBin Tray3
*UIConstraints: *Model C3351i *OutputBin Tray4
*UIConstraints: *Model C3351i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C3351i *Staple 1StapleZeroLeft
*UIConstraints: *Model C3351i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C3351i *Staple 1StapleZeroRight
*UIConstraints: *Model C3351i *Staple 2Staples
*UIConstraints: *Model C3351i *Punch 2holes
*UIConstraints: *Model C3351i *Punch 3holes
*UIConstraints: *Model C3351i *Punch 4holes
*UIConstraints: *Model C3351i *Fold Stitch
*UIConstraints: *Model C3351i *Fold HalfFold
*UIConstraints: *Model C3351i *Fold TriFold
*UIConstraints: *Model C3351i *Fold ZFold1
*UIConstraints: *Model C3351i *Fold ZFold2
*UIConstraints: *Model C3351i *FrontCoverTray LCT
*UIConstraints: *Model C3351i *BackCoverTray LCT
*UIConstraints: *Model C3351i *PIFrontCover PITray1
*UIConstraints: *Model C3351i *PIFrontCover PITray2
*UIConstraints: *Model C3351i *PIBackCover PITray1
*UIConstraints: *Model C3351i *PIBackCover PITray2
*UIConstraints: *Model C3351i *TransparencyInterleave Blank
*UIConstraints: *Model C3351i *OHPOpTray Tray1
*UIConstraints: *Model C3351i *OHPOpTray Tray2
*UIConstraints: *Model C3351i *OHPOpTray Tray3
*UIConstraints: *Model C3351i *OHPOpTray Tray4
*UIConstraints: *Model C3351i *OHPOpTray LCT
*UIConstraints: *Model C3351i *PaperSources LU207
*UIConstraints: *Model C3351i *PaperSources LU302
*UIConstraints: *Model C3351i *PaperSources LU205
*UIConstraints: *Model C3351i *PaperSources LU303
*UIConstraints: *Model C3351i *PaperSources PC116
*UIConstraints: *Model C3351i *PaperSources PC116+LU207
*UIConstraints: *Model C3351i *PaperSources PC116+LU302
*UIConstraints: *Model C3351i *PaperSources PC118
*UIConstraints: *Model C3351i *PaperSources PC216
*UIConstraints: *Model C3351i *PaperSources PC216+LU207
*UIConstraints: *Model C3351i *PaperSources PC216+LU302
*UIConstraints: *Model C3351i *PaperSources PC218
*UIConstraints: *Model C3351i *PaperSources PC416
*UIConstraints: *Model C3351i *PaperSources PC416+LU207
*UIConstraints: *Model C3351i *PaperSources PC416+LU302
*UIConstraints: *Model C3351i *PaperSources PC417
*UIConstraints: *Model C3351i *PaperSources PC417+LU207
*UIConstraints: *Model C3351i *PaperSources PC417+LU302
*UIConstraints: *Model C3351i *PaperSources PC418
*UIConstraints: *Model C3351i *Finisher FS533
*UIConstraints: *Model C3351i *Finisher FS539
*UIConstraints: *Model C3351i *Finisher JS506
*UIConstraints: *Model C3351i *Finisher JS508
*UIConstraints: *Model C3351i *Finisher FS540
*UIConstraints: *Model C3351i *Finisher FS540JS602
*UIConstraints: *Model C3351i *Finisher FS542
*UIConstraints: *Model C3351i *KOPunch PK519
*UIConstraints: *Model C3351i *KOPunch PK519-3
*UIConstraints: *Model C3351i *KOPunch PK519-4
*UIConstraints: *Model C3351i *KOPunch PK519-SWE4
*UIConstraints: *Model C3351i *KOPunch PK524
*UIConstraints: *Model C3351i *KOPunch PK524-3
*UIConstraints: *Model C3351i *KOPunch PK524-4
*UIConstraints: *Model C3351i *KOPunch PK524-SWE4
*UIConstraints: *Model C3351i *KOPunch PK526
*UIConstraints: *Model C3351i *KOPunch PK526-3
*UIConstraints: *Model C3351i *KOPunch PK526-4
*UIConstraints: *Model C3351i *KOPunch PK526-SWE4
*UIConstraints: *Model C3351i *KOPunch PK527
*UIConstraints: *Model C3351i *KOPunch PK527-3
*UIConstraints: *Model C3351i *KOPunch PK527-4
*UIConstraints: *Model C3351i *KOPunch PK527-SWE4
*UIConstraints: *Model C3351i *ZFoldUnit ZU609
*UIConstraints: *Model C3351i *PostInserter PI507
*UIConstraints: *Model C3351i *SaddleUnit SD511
*UIConstraints: *Model C3351i *SaddleUnit SD512
*UIConstraints: *Model C4001i *Offset True
*UIConstraints: *Model C4001i *InputSlot LCT
*UIConstraints: *Model C4001i *MediaType Thick3
*UIConstraints: *Model C4001i *MediaType Thick3(2nd)
*UIConstraints: *Model C4001i *MediaType Thick4
*UIConstraints: *Model C4001i *MediaType Thick4(2nd)
*UIConstraints: *Model C4001i *MediaType Thin
*UIConstraints: *Model C4001i *MediaType Transparency
*UIConstraints: *Model C4001i *MediaType TAB
*UIConstraints: *Model C4001i *MediaType User2_1
*UIConstraints: *Model C4001i *MediaType User2(2nd)_1
*UIConstraints: *Model C4001i *MediaType User6
*UIConstraints: *Model C4001i *MediaType User6(2nd)
*UIConstraints: *Model C4001i *MediaType User7
*UIConstraints: *Model C4001i *MediaType User7(2nd)
*UIConstraints: *Model C4001i *PageSize A3
*UIConstraints: *Model C4001i *PageSize B4
*UIConstraints: *Model C4001i *PageSize SRA3
*UIConstraints: *Model C4001i *PageSize 220mmx330mm
*UIConstraints: *Model C4001i *PageSize 12x18
*UIConstraints: *Model C4001i *PageSize Tabloid
*UIConstraints: *Model C4001i *PageSize 8K
*UIConstraints: *Model C4001i *PageSize EnvC4
*UIConstraints: *Model C4001i *PageSize EnvC5
*UIConstraints: *Model C4001i *PageSize EnvKaku1
*UIConstraints: *Model C4001i *PageSize EnvKaku2
*UIConstraints: *Model C4001i *PageSize EnvKaku3
*UIConstraints: *Model C4001i *PageSize A3Extra
*UIConstraints: *Model C4001i *PageSize A4Extra
*UIConstraints: *Model C4001i *PageSize A5Extra
*UIConstraints: *Model C4001i *PageSize B4Extra
*UIConstraints: *Model C4001i *PageSize B5Extra
*UIConstraints: *Model C4001i *PageSize TabloidExtra
*UIConstraints: *Model C4001i *PageSize LetterExtra
*UIConstraints: *Model C4001i *PageSize StatementExtra
*UIConstraints: *Model C4001i *PageSize LetterTab-F
*UIConstraints: *Model C4001i *PageSize A4Tab-F
*UIConstraints: *Model C4001i *OutputBin Tray1
*UIConstraints: *Model C4001i *OutputBin Tray2
*UIConstraints: *Model C4001i *OutputBin Tray3
*UIConstraints: *Model C4001i *OutputBin Tray4
*UIConstraints: *Model C4001i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C4001i *Staple 1StapleZeroLeft
*UIConstraints: *Model C4001i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C4001i *Staple 1StapleZeroRight
*UIConstraints: *Model C4001i *Staple 2Staples
*UIConstraints: *Model C4001i *Punch 2holes
*UIConstraints: *Model C4001i *Punch 3holes
*UIConstraints: *Model C4001i *Punch 4holes
*UIConstraints: *Model C4001i *Fold Stitch
*UIConstraints: *Model C4001i *Fold HalfFold
*UIConstraints: *Model C4001i *Fold TriFold
*UIConstraints: *Model C4001i *Fold ZFold1
*UIConstraints: *Model C4001i *Fold ZFold2
*UIConstraints: *Model C4001i *FrontCoverTray LCT
*UIConstraints: *Model C4001i *BackCoverTray LCT
*UIConstraints: *Model C4001i *PIFrontCover PITray1
*UIConstraints: *Model C4001i *PIFrontCover PITray2
*UIConstraints: *Model C4001i *PIBackCover PITray1
*UIConstraints: *Model C4001i *PIBackCover PITray2
*UIConstraints: *Model C4001i *TransparencyInterleave Blank
*UIConstraints: *Model C4001i *OHPOpTray Tray1
*UIConstraints: *Model C4001i *OHPOpTray Tray2
*UIConstraints: *Model C4001i *OHPOpTray Tray3
*UIConstraints: *Model C4001i *OHPOpTray Tray4
*UIConstraints: *Model C4001i *OHPOpTray LCT
*UIConstraints: *Model C4001i *PaperSources LU207
*UIConstraints: *Model C4001i *PaperSources LU302
*UIConstraints: *Model C4001i *PaperSources LU205
*UIConstraints: *Model C4001i *PaperSources LU303
*UIConstraints: *Model C4001i *PaperSources PC116
*UIConstraints: *Model C4001i *PaperSources PC116+LU207
*UIConstraints: *Model C4001i *PaperSources PC116+LU302
*UIConstraints: *Model C4001i *PaperSources PC118
*UIConstraints: *Model C4001i *PaperSources PC216
*UIConstraints: *Model C4001i *PaperSources PC216+LU207
*UIConstraints: *Model C4001i *PaperSources PC216+LU302
*UIConstraints: *Model C4001i *PaperSources PC218
*UIConstraints: *Model C4001i *PaperSources PC416
*UIConstraints: *Model C4001i *PaperSources PC416+LU207
*UIConstraints: *Model C4001i *PaperSources PC416+LU302
*UIConstraints: *Model C4001i *PaperSources PC417
*UIConstraints: *Model C4001i *PaperSources PC417+LU207
*UIConstraints: *Model C4001i *PaperSources PC417+LU302
*UIConstraints: *Model C4001i *PaperSources PC418
*UIConstraints: *Model C4001i *Finisher FS533
*UIConstraints: *Model C4001i *Finisher FS539
*UIConstraints: *Model C4001i *Finisher JS506
*UIConstraints: *Model C4001i *Finisher JS508
*UIConstraints: *Model C4001i *Finisher FS540
*UIConstraints: *Model C4001i *Finisher FS540JS602
*UIConstraints: *Model C4001i *Finisher FS542
*UIConstraints: *Model C4001i *KOPunch PK519
*UIConstraints: *Model C4001i *KOPunch PK519-3
*UIConstraints: *Model C4001i *KOPunch PK519-4
*UIConstraints: *Model C4001i *KOPunch PK519-SWE4
*UIConstraints: *Model C4001i *KOPunch PK524
*UIConstraints: *Model C4001i *KOPunch PK524-3
*UIConstraints: *Model C4001i *KOPunch PK524-4
*UIConstraints: *Model C4001i *KOPunch PK524-SWE4
*UIConstraints: *Model C4001i *KOPunch PK526
*UIConstraints: *Model C4001i *KOPunch PK526-3
*UIConstraints: *Model C4001i *KOPunch PK526-4
*UIConstraints: *Model C4001i *KOPunch PK526-SWE4
*UIConstraints: *Model C4001i *KOPunch PK527
*UIConstraints: *Model C4001i *KOPunch PK527-3
*UIConstraints: *Model C4001i *KOPunch PK527-4
*UIConstraints: *Model C4001i *KOPunch PK527-SWE4
*UIConstraints: *Model C4001i *ZFoldUnit ZU609
*UIConstraints: *Model C4001i *PostInserter PI507
*UIConstraints: *Model C4001i *SaddleUnit SD511
*UIConstraints: *Model C4001i *SaddleUnit SD512
*UIConstraints: *Model C4001i *PrinterHDD HDD
*UIConstraints: *Model C3301i *Offset True
*UIConstraints: *Model C3301i *InputSlot LCT
*UIConstraints: *Model C3301i *MediaType Thick3
*UIConstraints: *Model C3301i *MediaType Thick3(2nd)
*UIConstraints: *Model C3301i *MediaType Thick4
*UIConstraints: *Model C3301i *MediaType Thick4(2nd)
*UIConstraints: *Model C3301i *MediaType Thin
*UIConstraints: *Model C3301i *MediaType Transparency
*UIConstraints: *Model C3301i *MediaType TAB
*UIConstraints: *Model C3301i *MediaType User2_1
*UIConstraints: *Model C3301i *MediaType User2(2nd)_1
*UIConstraints: *Model C3301i *MediaType User6
*UIConstraints: *Model C3301i *MediaType User6(2nd)
*UIConstraints: *Model C3301i *MediaType User7
*UIConstraints: *Model C3301i *MediaType User7(2nd)
*UIConstraints: *Model C3301i *PageSize A3
*UIConstraints: *Model C3301i *PageSize B4
*UIConstraints: *Model C3301i *PageSize SRA3
*UIConstraints: *Model C3301i *PageSize 220mmx330mm
*UIConstraints: *Model C3301i *PageSize 12x18
*UIConstraints: *Model C3301i *PageSize Tabloid
*UIConstraints: *Model C3301i *PageSize 8K
*UIConstraints: *Model C3301i *PageSize EnvC4
*UIConstraints: *Model C3301i *PageSize EnvC5
*UIConstraints: *Model C3301i *PageSize EnvKaku1
*UIConstraints: *Model C3301i *PageSize EnvKaku2
*UIConstraints: *Model C3301i *PageSize EnvKaku3
*UIConstraints: *Model C3301i *PageSize A3Extra
*UIConstraints: *Model C3301i *PageSize A4Extra
*UIConstraints: *Model C3301i *PageSize A5Extra
*UIConstraints: *Model C3301i *PageSize B4Extra
*UIConstraints: *Model C3301i *PageSize B5Extra
*UIConstraints: *Model C3301i *PageSize TabloidExtra
*UIConstraints: *Model C3301i *PageSize LetterExtra
*UIConstraints: *Model C3301i *PageSize StatementExtra
*UIConstraints: *Model C3301i *PageSize LetterTab-F
*UIConstraints: *Model C3301i *PageSize A4Tab-F
*UIConstraints: *Model C3301i *OutputBin Tray1
*UIConstraints: *Model C3301i *OutputBin Tray2
*UIConstraints: *Model C3301i *OutputBin Tray3
*UIConstraints: *Model C3301i *OutputBin Tray4
*UIConstraints: *Model C3301i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C3301i *Staple 1StapleZeroLeft
*UIConstraints: *Model C3301i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C3301i *Staple 1StapleZeroRight
*UIConstraints: *Model C3301i *Staple 2Staples
*UIConstraints: *Model C3301i *Punch 2holes
*UIConstraints: *Model C3301i *Punch 3holes
*UIConstraints: *Model C3301i *Punch 4holes
*UIConstraints: *Model C3301i *Fold Stitch
*UIConstraints: *Model C3301i *Fold HalfFold
*UIConstraints: *Model C3301i *Fold TriFold
*UIConstraints: *Model C3301i *Fold ZFold1
*UIConstraints: *Model C3301i *Fold ZFold2
*UIConstraints: *Model C3301i *FrontCoverTray LCT
*UIConstraints: *Model C3301i *BackCoverTray LCT
*UIConstraints: *Model C3301i *PIFrontCover PITray1
*UIConstraints: *Model C3301i *PIFrontCover PITray2
*UIConstraints: *Model C3301i *PIBackCover PITray1
*UIConstraints: *Model C3301i *PIBackCover PITray2
*UIConstraints: *Model C3301i *TransparencyInterleave Blank
*UIConstraints: *Model C3301i *OHPOpTray Tray1
*UIConstraints: *Model C3301i *OHPOpTray Tray2
*UIConstraints: *Model C3301i *OHPOpTray Tray3
*UIConstraints: *Model C3301i *OHPOpTray Tray4
*UIConstraints: *Model C3301i *OHPOpTray LCT
*UIConstraints: *Model C3301i *PaperSources LU207
*UIConstraints: *Model C3301i *PaperSources LU302
*UIConstraints: *Model C3301i *PaperSources LU205
*UIConstraints: *Model C3301i *PaperSources LU303
*UIConstraints: *Model C3301i *PaperSources PC116
*UIConstraints: *Model C3301i *PaperSources PC116+LU207
*UIConstraints: *Model C3301i *PaperSources PC116+LU302
*UIConstraints: *Model C3301i *PaperSources PC118
*UIConstraints: *Model C3301i *PaperSources PC216
*UIConstraints: *Model C3301i *PaperSources PC216+LU207
*UIConstraints: *Model C3301i *PaperSources PC216+LU302
*UIConstraints: *Model C3301i *PaperSources PC218
*UIConstraints: *Model C3301i *PaperSources PC416
*UIConstraints: *Model C3301i *PaperSources PC416+LU207
*UIConstraints: *Model C3301i *PaperSources PC416+LU302
*UIConstraints: *Model C3301i *PaperSources PC417
*UIConstraints: *Model C3301i *PaperSources PC417+LU207
*UIConstraints: *Model C3301i *PaperSources PC417+LU302
*UIConstraints: *Model C3301i *PaperSources PC418
*UIConstraints: *Model C3301i *Finisher FS533
*UIConstraints: *Model C3301i *Finisher FS539
*UIConstraints: *Model C3301i *Finisher JS506
*UIConstraints: *Model C3301i *Finisher JS508
*UIConstraints: *Model C3301i *Finisher FS540
*UIConstraints: *Model C3301i *Finisher FS540JS602
*UIConstraints: *Model C3301i *Finisher FS542
*UIConstraints: *Model C3301i *KOPunch PK519
*UIConstraints: *Model C3301i *KOPunch PK519-3
*UIConstraints: *Model C3301i *KOPunch PK519-4
*UIConstraints: *Model C3301i *KOPunch PK519-SWE4
*UIConstraints: *Model C3301i *KOPunch PK524
*UIConstraints: *Model C3301i *KOPunch PK524-3
*UIConstraints: *Model C3301i *KOPunch PK524-4
*UIConstraints: *Model C3301i *KOPunch PK524-SWE4
*UIConstraints: *Model C3301i *KOPunch PK526
*UIConstraints: *Model C3301i *KOPunch PK526-3
*UIConstraints: *Model C3301i *KOPunch PK526-4
*UIConstraints: *Model C3301i *KOPunch PK526-SWE4
*UIConstraints: *Model C3301i *KOPunch PK527
*UIConstraints: *Model C3301i *KOPunch PK527-3
*UIConstraints: *Model C3301i *KOPunch PK527-4
*UIConstraints: *Model C3301i *KOPunch PK527-SWE4
*UIConstraints: *Model C3301i *ZFoldUnit ZU609
*UIConstraints: *Model C3301i *PostInserter PI507
*UIConstraints: *Model C3301i *SaddleUnit SD511
*UIConstraints: *Model C3301i *SaddleUnit SD512
*UIConstraints: *Model C3301i *PrinterHDD HDD
*UIConstraints: *Model C3321i *Offset True
*UIConstraints: *Model C3321i *InputSlot Tray4
*UIConstraints: *Model C3321i *InputSlot LCT
*UIConstraints: *Model C3321i *MediaType Thick3
*UIConstraints: *Model C3321i *MediaType Thick3(2nd)
*UIConstraints: *Model C3321i *MediaType Thick4
*UIConstraints: *Model C3321i *MediaType Thick4(2nd)
*UIConstraints: *Model C3321i *MediaType Thin
*UIConstraints: *Model C3321i *MediaType Transparency
*UIConstraints: *Model C3321i *MediaType TAB
*UIConstraints: *Model C3321i *MediaType User2_1
*UIConstraints: *Model C3321i *MediaType User2(2nd)_1
*UIConstraints: *Model C3321i *MediaType User6
*UIConstraints: *Model C3321i *MediaType User6(2nd)
*UIConstraints: *Model C3321i *MediaType User7
*UIConstraints: *Model C3321i *MediaType User7(2nd)
*UIConstraints: *Model C3321i *PageSize A3
*UIConstraints: *Model C3321i *PageSize B4
*UIConstraints: *Model C3321i *PageSize SRA3
*UIConstraints: *Model C3321i *PageSize 220mmx330mm
*UIConstraints: *Model C3321i *PageSize 12x18
*UIConstraints: *Model C3321i *PageSize Tabloid
*UIConstraints: *Model C3321i *PageSize 8K
*UIConstraints: *Model C3321i *PageSize EnvC4
*UIConstraints: *Model C3321i *PageSize EnvC5
*UIConstraints: *Model C3321i *PageSize EnvKaku1
*UIConstraints: *Model C3321i *PageSize EnvKaku2
*UIConstraints: *Model C3321i *PageSize EnvKaku3
*UIConstraints: *Model C3321i *PageSize A3Extra
*UIConstraints: *Model C3321i *PageSize A4Extra
*UIConstraints: *Model C3321i *PageSize A5Extra
*UIConstraints: *Model C3321i *PageSize B4Extra
*UIConstraints: *Model C3321i *PageSize B5Extra
*UIConstraints: *Model C3321i *PageSize TabloidExtra
*UIConstraints: *Model C3321i *PageSize LetterExtra
*UIConstraints: *Model C3321i *PageSize StatementExtra
*UIConstraints: *Model C3321i *PageSize LetterTab-F
*UIConstraints: *Model C3321i *PageSize A4Tab-F
*UIConstraints: *Model C3321i *OutputBin Tray1
*UIConstraints: *Model C3321i *OutputBin Tray2
*UIConstraints: *Model C3321i *OutputBin Tray3
*UIConstraints: *Model C3321i *OutputBin Tray4
*UIConstraints: *Model C3321i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C3321i *Staple 1StapleZeroLeft
*UIConstraints: *Model C3321i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C3321i *Staple 1StapleZeroRight
*UIConstraints: *Model C3321i *Staple 2Staples
*UIConstraints: *Model C3321i *Punch 2holes
*UIConstraints: *Model C3321i *Punch 3holes
*UIConstraints: *Model C3321i *Punch 4holes
*UIConstraints: *Model C3321i *Fold Stitch
*UIConstraints: *Model C3321i *Fold HalfFold
*UIConstraints: *Model C3321i *Fold TriFold
*UIConstraints: *Model C3321i *Fold ZFold1
*UIConstraints: *Model C3321i *Fold ZFold2
*UIConstraints: *Model C3321i *FrontCoverTray Tray4
*UIConstraints: *Model C3321i *FrontCoverTray LCT
*UIConstraints: *Model C3321i *BackCoverTray Tray4
*UIConstraints: *Model C3321i *BackCoverTray LCT
*UIConstraints: *Model C3321i *PIFrontCover PITray1
*UIConstraints: *Model C3321i *PIFrontCover PITray2
*UIConstraints: *Model C3321i *PIBackCover PITray1
*UIConstraints: *Model C3321i *PIBackCover PITray2
*UIConstraints: *Model C3321i *TransparencyInterleave Blank
*UIConstraints: *Model C3321i *OHPOpTray Tray1
*UIConstraints: *Model C3321i *OHPOpTray Tray2
*UIConstraints: *Model C3321i *OHPOpTray Tray3
*UIConstraints: *Model C3321i *OHPOpTray Tray4
*UIConstraints: *Model C3321i *OHPOpTray LCT
*UIConstraints: *Model C3321i *PaperSources LU207
*UIConstraints: *Model C3321i *PaperSources LU302
*UIConstraints: *Model C3321i *PaperSources LU205
*UIConstraints: *Model C3321i *PaperSources LU303
*UIConstraints: *Model C3321i *PaperSources PC116
*UIConstraints: *Model C3321i *PaperSources PC116+LU207
*UIConstraints: *Model C3321i *PaperSources PC116+LU302
*UIConstraints: *Model C3321i *PaperSources PC118
*UIConstraints: *Model C3321i *PaperSources PC216
*UIConstraints: *Model C3321i *PaperSources PC216+LU207
*UIConstraints: *Model C3321i *PaperSources PC216+LU302
*UIConstraints: *Model C3321i *PaperSources PC218
*UIConstraints: *Model C3321i *PaperSources PC416
*UIConstraints: *Model C3321i *PaperSources PC416+LU207
*UIConstraints: *Model C3321i *PaperSources PC416+LU302
*UIConstraints: *Model C3321i *PaperSources PC417
*UIConstraints: *Model C3321i *PaperSources PC417+LU207
*UIConstraints: *Model C3321i *PaperSources PC417+LU302
*UIConstraints: *Model C3321i *PaperSources PC418
*UIConstraints: *Model C3321i *PaperSources PFP13T234
*UIConstraints: *Model C3321i *Finisher FS533
*UIConstraints: *Model C3321i *Finisher FS539
*UIConstraints: *Model C3321i *Finisher JS506
*UIConstraints: *Model C3321i *Finisher JS508
*UIConstraints: *Model C3321i *Finisher FS540
*UIConstraints: *Model C3321i *Finisher FS540JS602
*UIConstraints: *Model C3321i *Finisher FS542
*UIConstraints: *Model C3321i *KOPunch PK519
*UIConstraints: *Model C3321i *KOPunch PK519-3
*UIConstraints: *Model C3321i *KOPunch PK519-4
*UIConstraints: *Model C3321i *KOPunch PK519-SWE4
*UIConstraints: *Model C3321i *KOPunch PK524
*UIConstraints: *Model C3321i *KOPunch PK524-3
*UIConstraints: *Model C3321i *KOPunch PK524-4
*UIConstraints: *Model C3321i *KOPunch PK524-SWE4
*UIConstraints: *Model C3321i *KOPunch PK526
*UIConstraints: *Model C3321i *KOPunch PK526-3
*UIConstraints: *Model C3321i *KOPunch PK526-4
*UIConstraints: *Model C3321i *KOPunch PK526-SWE4
*UIConstraints: *Model C3321i *KOPunch PK527
*UIConstraints: *Model C3321i *KOPunch PK527-3
*UIConstraints: *Model C3321i *KOPunch PK527-4
*UIConstraints: *Model C3321i *KOPunch PK527-SWE4
*UIConstraints: *Model C3321i *ZFoldUnit ZU609
*UIConstraints: *Model C3321i *PostInserter PI507
*UIConstraints: *Model C3321i *SaddleUnit SD511
*UIConstraints: *Model C3321i *SaddleUnit SD512
*UIConstraints: *Model C3321i *PrinterHDD HDD
*UIConstraints: *Model C750i *MediaType Labels
*UIConstraints: *Model C750i *MediaType Postcard
*UIConstraints: *Model C750i *MediaType Glossy
*UIConstraints: *Model C750i *MediaType GlossyPlus
*UIConstraints: *Model C750i *MediaType Glossy2
*UIConstraints: *Model C750i *MediaType User2_1
*UIConstraints: *Model C750i *MediaType User2(2nd)_1
*UIConstraints: *Model C750i *PageSize LetterPlus
*UIConstraints: *Model C750i *PageSize 8x10
*UIConstraints: *Model C750i *PageSize 8x10.5
*UIConstraints: *Model C750i *PageSize DoublePostcardRotated
*UIConstraints: *Model C750i *PaperSources LU207
*UIConstraints: *Model C750i *PaperSources LU302
*UIConstraints: *Model C750i *PaperSources PC116
*UIConstraints: *Model C750i *PaperSources PC116+LU207
*UIConstraints: *Model C750i *PaperSources PC116+LU302
*UIConstraints: *Model C750i *PaperSources PC118
*UIConstraints: *Model C750i *PaperSources PC216
*UIConstraints: *Model C750i *PaperSources PC216+LU207
*UIConstraints: *Model C750i *PaperSources PC216+LU302
*UIConstraints: *Model C750i *PaperSources PC218
*UIConstraints: *Model C750i *PaperSources PC416
*UIConstraints: *Model C750i *PaperSources PC416+LU207
*UIConstraints: *Model C750i *PaperSources PC416+LU302
*UIConstraints: *Model C750i *PaperSources PC417
*UIConstraints: *Model C750i *PaperSources PC417+LU207
*UIConstraints: *Model C750i *PaperSources PC417+LU302
*UIConstraints: *Model C750i *PaperSources PC418
*UIConstraints: *Model C750i *PaperSources PFP13T2
*UIConstraints: *Model C750i *PaperSources PFP13T23
*UIConstraints: *Model C750i *PaperSources PFP13T234
*UIConstraints: *Model C750i *Finisher FS533
*UIConstraints: *Model C750i *Finisher JS506
*UIConstraints: *Model C750i *Finisher JS508
*UIConstraints: *Model C750i *Finisher FS542
*UIConstraints: *Model C750i *KOPunch PK519
*UIConstraints: *Model C750i *KOPunch PK519-3
*UIConstraints: *Model C750i *KOPunch PK519-4
*UIConstraints: *Model C750i *KOPunch PK519-SWE4
*UIConstraints: *Model C750i *KOPunch PK527
*UIConstraints: *Model C750i *KOPunch PK527-3
*UIConstraints: *Model C750i *KOPunch PK527-4
*UIConstraints: *Model C750i *KOPunch PK527-SWE4
*UIConstraints: *Model C650i *MediaType Labels
*UIConstraints: *Model C650i *MediaType Postcard
*UIConstraints: *Model C650i *MediaType Glossy
*UIConstraints: *Model C650i *MediaType GlossyPlus
*UIConstraints: *Model C650i *MediaType Glossy2
*UIConstraints: *Model C650i *MediaType User2_1
*UIConstraints: *Model C650i *MediaType User2(2nd)_1
*UIConstraints: *Model C650i *MediaType User7
*UIConstraints: *Model C650i *MediaType User7(2nd)
*UIConstraints: *Model C650i *PageSize LetterPlus
*UIConstraints: *Model C650i *PageSize 8x10
*UIConstraints: *Model C650i *PageSize 8x10.5
*UIConstraints: *Model C650i *PageSize DoublePostcardRotated
*UIConstraints: *Model C650i *PaperSources LU205
*UIConstraints: *Model C650i *PaperSources LU303
*UIConstraints: *Model C650i *PaperSources PC118
*UIConstraints: *Model C650i *PaperSources PC218
*UIConstraints: *Model C650i *PaperSources PC418
*UIConstraints: *Model C650i *PaperSources PFP13T2
*UIConstraints: *Model C650i *PaperSources PFP13T23
*UIConstraints: *Model C650i *PaperSources PFP13T234
*UIConstraints: *Model C650i *Finisher FS533
*UIConstraints: *Model C650i *Finisher JS506
*UIConstraints: *Model C650i *Finisher JS508
*UIConstraints: *Model C650i *Finisher FS542
*UIConstraints: *Model C650i *KOPunch PK519
*UIConstraints: *Model C650i *KOPunch PK519-3
*UIConstraints: *Model C650i *KOPunch PK519-4
*UIConstraints: *Model C650i *KOPunch PK519-SWE4
*UIConstraints: *Model C650i *KOPunch PK527
*UIConstraints: *Model C650i *KOPunch PK527-3
*UIConstraints: *Model C650i *KOPunch PK527-4
*UIConstraints: *Model C650i *KOPunch PK527-SWE4
*UIConstraints: *Model C550i *MediaType Labels
*UIConstraints: *Model C550i *MediaType Postcard
*UIConstraints: *Model C550i *MediaType Glossy
*UIConstraints: *Model C550i *MediaType GlossyPlus
*UIConstraints: *Model C550i *MediaType Glossy2
*UIConstraints: *Model C550i *MediaType User2_1
*UIConstraints: *Model C550i *MediaType User2(2nd)_1
*UIConstraints: *Model C550i *MediaType User7
*UIConstraints: *Model C550i *MediaType User7(2nd)
*UIConstraints: *Model C550i *PageSize LetterPlus
*UIConstraints: *Model C550i *PageSize 8x10
*UIConstraints: *Model C550i *PageSize 8x10.5
*UIConstraints: *Model C550i *PageSize DoublePostcardRotated
*UIConstraints: *Model C550i *PaperSources LU205
*UIConstraints: *Model C550i *PaperSources LU303
*UIConstraints: *Model C550i *PaperSources PC118
*UIConstraints: *Model C550i *PaperSources PC218
*UIConstraints: *Model C550i *PaperSources PC418
*UIConstraints: *Model C550i *PaperSources PFP13T2
*UIConstraints: *Model C550i *PaperSources PFP13T23
*UIConstraints: *Model C550i *PaperSources PFP13T234
*UIConstraints: *Model C550i *Finisher JS506
*UIConstraints: *Model C550i *Finisher FS542
*UIConstraints: *Model C550i *KOPunch PK527
*UIConstraints: *Model C550i *KOPunch PK527-3
*UIConstraints: *Model C550i *KOPunch PK527-4
*UIConstraints: *Model C550i *KOPunch PK527-SWE4
*UIConstraints: *Model C450i *MediaType Labels
*UIConstraints: *Model C450i *MediaType Postcard
*UIConstraints: *Model C450i *MediaType Glossy
*UIConstraints: *Model C450i *MediaType GlossyPlus
*UIConstraints: *Model C450i *MediaType Glossy2
*UIConstraints: *Model C450i *MediaType User2_1
*UIConstraints: *Model C450i *MediaType User2(2nd)_1
*UIConstraints: *Model C450i *MediaType User7
*UIConstraints: *Model C450i *MediaType User7(2nd)
*UIConstraints: *Model C450i *PageSize LetterPlus
*UIConstraints: *Model C450i *PageSize 8x10
*UIConstraints: *Model C450i *PageSize 8x10.5
*UIConstraints: *Model C450i *PageSize DoublePostcardRotated
*UIConstraints: *Model C450i *PaperSources LU205
*UIConstraints: *Model C450i *PaperSources LU303
*UIConstraints: *Model C450i *PaperSources PC118
*UIConstraints: *Model C450i *PaperSources PC218
*UIConstraints: *Model C450i *PaperSources PC418
*UIConstraints: *Model C450i *PaperSources PFP13T2
*UIConstraints: *Model C450i *PaperSources PFP13T23
*UIConstraints: *Model C450i *PaperSources PFP13T234
*UIConstraints: *Model C450i *Finisher JS506
*UIConstraints: *Model C450i *Finisher FS542
*UIConstraints: *Model C450i *KOPunch PK527
*UIConstraints: *Model C450i *KOPunch PK527-3
*UIConstraints: *Model C450i *KOPunch PK527-4
*UIConstraints: *Model C450i *KOPunch PK527-SWE4
*UIConstraints: *Model C360i *MediaType Labels
*UIConstraints: *Model C360i *MediaType Postcard
*UIConstraints: *Model C360i *MediaType Glossy
*UIConstraints: *Model C360i *MediaType GlossyPlus
*UIConstraints: *Model C360i *MediaType Glossy2
*UIConstraints: *Model C360i *MediaType User2_1
*UIConstraints: *Model C360i *MediaType User2(2nd)_1
*UIConstraints: *Model C360i *MediaType User7
*UIConstraints: *Model C360i *MediaType User7(2nd)
*UIConstraints: *Model C360i *PageSize LetterPlus
*UIConstraints: *Model C360i *PageSize 8x10
*UIConstraints: *Model C360i *PageSize 8x10.5
*UIConstraints: *Model C360i *PageSize DoublePostcardRotated
*UIConstraints: *Model C360i *OutputBin Tray4
*UIConstraints: *Model C360i *Fold ZFold1
*UIConstraints: *Model C360i *Fold ZFold2
*UIConstraints: *Model C360i *PIFrontCover PITray1
*UIConstraints: *Model C360i *PIFrontCover PITray2
*UIConstraints: *Model C360i *PIBackCover PITray1
*UIConstraints: *Model C360i *PIBackCover PITray2
*UIConstraints: *Model C360i *PaperSources LU207
*UIConstraints: *Model C360i *PaperSources LU205
*UIConstraints: *Model C360i *PaperSources LU303
*UIConstraints: *Model C360i *PaperSources PC116+LU207
*UIConstraints: *Model C360i *PaperSources PC118
*UIConstraints: *Model C360i *PaperSources PC216+LU207
*UIConstraints: *Model C360i *PaperSources PC218
*UIConstraints: *Model C360i *PaperSources PC416+LU207
*UIConstraints: *Model C360i *PaperSources PC417+LU207
*UIConstraints: *Model C360i *PaperSources PC418
*UIConstraints: *Model C360i *PaperSources PFP13T2
*UIConstraints: *Model C360i *PaperSources PFP13T23
*UIConstraints: *Model C360i *PaperSources PFP13T234
*UIConstraints: *Model C360i *Finisher JS508
*UIConstraints: *Model C360i *Finisher FS540
*UIConstraints: *Model C360i *Finisher FS540JS602
*UIConstraints: *Model C360i *Finisher FS542
*UIConstraints: *Model C360i *KOPunch PK526
*UIConstraints: *Model C360i *KOPunch PK526-3
*UIConstraints: *Model C360i *KOPunch PK526-4
*UIConstraints: *Model C360i *KOPunch PK526-SWE4
*UIConstraints: *Model C360i *KOPunch PK527
*UIConstraints: *Model C360i *KOPunch PK527-3
*UIConstraints: *Model C360i *KOPunch PK527-4
*UIConstraints: *Model C360i *KOPunch PK527-SWE4
*UIConstraints: *Model C360i *ZFoldUnit ZU609
*UIConstraints: *Model C360i *PostInserter PI507
*UIConstraints: *Model C360i *SaddleUnit SD512
*UIConstraints: *Model C300i *MediaType Labels
*UIConstraints: *Model C300i *MediaType Postcard
*UIConstraints: *Model C300i *MediaType Glossy
*UIConstraints: *Model C300i *MediaType GlossyPlus
*UIConstraints: *Model C300i *MediaType Glossy2
*UIConstraints: *Model C300i *MediaType User2_1
*UIConstraints: *Model C300i *MediaType User2(2nd)_1
*UIConstraints: *Model C300i *MediaType User7
*UIConstraints: *Model C300i *MediaType User7(2nd)
*UIConstraints: *Model C300i *PageSize LetterPlus
*UIConstraints: *Model C300i *PageSize 8x10
*UIConstraints: *Model C300i *PageSize 8x10.5
*UIConstraints: *Model C300i *PageSize DoublePostcardRotated
*UIConstraints: *Model C300i *OutputBin Tray4
*UIConstraints: *Model C300i *Fold ZFold1
*UIConstraints: *Model C300i *Fold ZFold2
*UIConstraints: *Model C300i *PIFrontCover PITray1
*UIConstraints: *Model C300i *PIFrontCover PITray2
*UIConstraints: *Model C300i *PIBackCover PITray1
*UIConstraints: *Model C300i *PIBackCover PITray2
*UIConstraints: *Model C300i *PaperSources LU207
*UIConstraints: *Model C300i *PaperSources LU205
*UIConstraints: *Model C300i *PaperSources LU303
*UIConstraints: *Model C300i *PaperSources PC116+LU207
*UIConstraints: *Model C300i *PaperSources PC118
*UIConstraints: *Model C300i *PaperSources PC216+LU207
*UIConstraints: *Model C300i *PaperSources PC218
*UIConstraints: *Model C300i *PaperSources PC416+LU207
*UIConstraints: *Model C300i *PaperSources PC417+LU207
*UIConstraints: *Model C300i *PaperSources PC418
*UIConstraints: *Model C300i *PaperSources PFP13T2
*UIConstraints: *Model C300i *PaperSources PFP13T23
*UIConstraints: *Model C300i *PaperSources PFP13T234
*UIConstraints: *Model C300i *Finisher JS508
*UIConstraints: *Model C300i *Finisher FS540
*UIConstraints: *Model C300i *Finisher FS540JS602
*UIConstraints: *Model C300i *Finisher FS542
*UIConstraints: *Model C300i *KOPunch PK526
*UIConstraints: *Model C300i *KOPunch PK526-3
*UIConstraints: *Model C300i *KOPunch PK526-4
*UIConstraints: *Model C300i *KOPunch PK526-SWE4
*UIConstraints: *Model C300i *KOPunch PK527
*UIConstraints: *Model C300i *KOPunch PK527-3
*UIConstraints: *Model C300i *KOPunch PK527-4
*UIConstraints: *Model C300i *KOPunch PK527-SWE4
*UIConstraints: *Model C300i *ZFoldUnit ZU609
*UIConstraints: *Model C300i *PostInserter PI507
*UIConstraints: *Model C300i *SaddleUnit SD512
*UIConstraints: *Model C250i *MediaType Labels
*UIConstraints: *Model C250i *MediaType Postcard
*UIConstraints: *Model C250i *MediaType Glossy
*UIConstraints: *Model C250i *MediaType GlossyPlus
*UIConstraints: *Model C250i *MediaType Glossy2
*UIConstraints: *Model C250i *MediaType User2_1
*UIConstraints: *Model C250i *MediaType User2(2nd)_1
*UIConstraints: *Model C250i *MediaType User7
*UIConstraints: *Model C250i *MediaType User7(2nd)
*UIConstraints: *Model C250i *PageSize LetterPlus
*UIConstraints: *Model C250i *PageSize 8x10
*UIConstraints: *Model C250i *PageSize 8x10.5
*UIConstraints: *Model C250i *PageSize DoublePostcardRotated
*UIConstraints: *Model C250i *OutputBin Tray4
*UIConstraints: *Model C250i *Fold ZFold1
*UIConstraints: *Model C250i *Fold ZFold2
*UIConstraints: *Model C250i *PIFrontCover PITray1
*UIConstraints: *Model C250i *PIFrontCover PITray2
*UIConstraints: *Model C250i *PIBackCover PITray1
*UIConstraints: *Model C250i *PIBackCover PITray2
*UIConstraints: *Model C250i *PaperSources LU207
*UIConstraints: *Model C250i *PaperSources LU205
*UIConstraints: *Model C250i *PaperSources LU303
*UIConstraints: *Model C250i *PaperSources PC116+LU207
*UIConstraints: *Model C250i *PaperSources PC118
*UIConstraints: *Model C250i *PaperSources PC216+LU207
*UIConstraints: *Model C250i *PaperSources PC218
*UIConstraints: *Model C250i *PaperSources PC416+LU207
*UIConstraints: *Model C250i *PaperSources PC417+LU207
*UIConstraints: *Model C250i *PaperSources PC418
*UIConstraints: *Model C250i *PaperSources PFP13T2
*UIConstraints: *Model C250i *PaperSources PFP13T23
*UIConstraints: *Model C250i *PaperSources PFP13T234
*UIConstraints: *Model C250i *Finisher JS508
*UIConstraints: *Model C250i *Finisher FS540
*UIConstraints: *Model C250i *Finisher FS540JS602
*UIConstraints: *Model C250i *Finisher FS542
*UIConstraints: *Model C250i *KOPunch PK526
*UIConstraints: *Model C250i *KOPunch PK526-3
*UIConstraints: *Model C250i *KOPunch PK526-4
*UIConstraints: *Model C250i *KOPunch PK526-SWE4
*UIConstraints: *Model C250i *KOPunch PK527
*UIConstraints: *Model C250i *KOPunch PK527-3
*UIConstraints: *Model C250i *KOPunch PK527-4
*UIConstraints: *Model C250i *KOPunch PK527-SWE4
*UIConstraints: *Model C250i *ZFoldUnit ZU609
*UIConstraints: *Model C250i *PostInserter PI507
*UIConstraints: *Model C250i *SaddleUnit SD512
*UIConstraints: *Model C287i *InputSlot LCT
*UIConstraints: *Model C287i *MediaType PlainPlus
*UIConstraints: *Model C287i *MediaType PlainPlus(2nd)
*UIConstraints: *Model C287i *MediaType Thick4
*UIConstraints: *Model C287i *MediaType Thick4(2nd)
*UIConstraints: *Model C287i *MediaType Thin
*UIConstraints: *Model C287i *MediaType Labels
*UIConstraints: *Model C287i *MediaType Postcard
*UIConstraints: *Model C287i *MediaType Glossy
*UIConstraints: *Model C287i *MediaType GlossyPlus
*UIConstraints: *Model C287i *MediaType Glossy2
*UIConstraints: *Model C287i *MediaType User2
*UIConstraints: *Model C287i *MediaType User2(2nd)
*UIConstraints: *Model C287i *MediaType User7
*UIConstraints: *Model C287i *MediaType User7(2nd)
*UIConstraints: *Model C287i *PageSize SRA3
*UIConstraints: *Model C287i *PageSize 12x18
*UIConstraints: *Model C287i *PageSize LetterPlus
*UIConstraints: *Model C287i *PageSize 8x10
*UIConstraints: *Model C287i *PageSize 8x10.5
*UIConstraints: *Model C287i *PageSize DoublePostcardRotated
*UIConstraints: *Model C287i *PageSize A3Extra
*UIConstraints: *Model C287i *PageSize TabloidExtra
*UIConstraints: *Model C287i *OutputBin Tray4
*UIConstraints: *Model C287i *Fold ZFold1
*UIConstraints: *Model C287i *Fold ZFold2
*UIConstraints: *Model C287i *FrontCoverTray LCT
*UIConstraints: *Model C287i *BackCoverTray LCT
*UIConstraints: *Model C287i *PIFrontCover PITray1
*UIConstraints: *Model C287i *PIFrontCover PITray2
*UIConstraints: *Model C287i *PIBackCover PITray1
*UIConstraints: *Model C287i *PIBackCover PITray2
*UIConstraints: *Model C287i *OHPOpTray LCT
*UIConstraints: *Model C287i *PaperSources LU207
*UIConstraints: *Model C287i *PaperSources LU302
*UIConstraints: *Model C287i *PaperSources LU205
*UIConstraints: *Model C287i *PaperSources LU303
*UIConstraints: *Model C287i *PaperSources PC116
*UIConstraints: *Model C287i *PaperSources PC116+LU207
*UIConstraints: *Model C287i *PaperSources PC116+LU302
*UIConstraints: *Model C287i *PaperSources PC216
*UIConstraints: *Model C287i *PaperSources PC216+LU207
*UIConstraints: *Model C287i *PaperSources PC216+LU302
*UIConstraints: *Model C287i *PaperSources PC416
*UIConstraints: *Model C287i *PaperSources PC416+LU207
*UIConstraints: *Model C287i *PaperSources PC416+LU302
*UIConstraints: *Model C287i *PaperSources PC417
*UIConstraints: *Model C287i *PaperSources PC417+LU207
*UIConstraints: *Model C287i *PaperSources PC417+LU302
*UIConstraints: *Model C287i *PaperSources PFP13T2
*UIConstraints: *Model C287i *PaperSources PFP13T23
*UIConstraints: *Model C287i *PaperSources PFP13T234
*UIConstraints: *Model C287i *Finisher JS508
*UIConstraints: *Model C287i *Finisher FS540
*UIConstraints: *Model C287i *Finisher FS540JS602
*UIConstraints: *Model C287i *KOPunch PK526
*UIConstraints: *Model C287i *KOPunch PK526-3
*UIConstraints: *Model C287i *KOPunch PK526-4
*UIConstraints: *Model C287i *KOPunch PK526-SWE4
*UIConstraints: *Model C287i *ZFoldUnit ZU609
*UIConstraints: *Model C287i *PostInserter PI507
*UIConstraints: *Model C287i *SaddleUnit SD512
*UIConstraints: *Model C257i *InputSlot LCT
*UIConstraints: *Model C257i *MediaType PlainPlus
*UIConstraints: *Model C257i *MediaType PlainPlus(2nd)
*UIConstraints: *Model C257i *MediaType Thick4
*UIConstraints: *Model C257i *MediaType Thick4(2nd)
*UIConstraints: *Model C257i *MediaType Thin
*UIConstraints: *Model C257i *MediaType Labels
*UIConstraints: *Model C257i *MediaType Postcard
*UIConstraints: *Model C257i *MediaType Glossy
*UIConstraints: *Model C257i *MediaType GlossyPlus
*UIConstraints: *Model C257i *MediaType Glossy2
*UIConstraints: *Model C257i *MediaType User2
*UIConstraints: *Model C257i *MediaType User2(2nd)
*UIConstraints: *Model C257i *MediaType User7
*UIConstraints: *Model C257i *MediaType User7(2nd)
*UIConstraints: *Model C257i *PageSize SRA3
*UIConstraints: *Model C257i *PageSize 12x18
*UIConstraints: *Model C257i *PageSize LetterPlus
*UIConstraints: *Model C257i *PageSize 8x10
*UIConstraints: *Model C257i *PageSize 8x10.5
*UIConstraints: *Model C257i *PageSize DoublePostcardRotated
*UIConstraints: *Model C257i *PageSize A3Extra
*UIConstraints: *Model C257i *PageSize TabloidExtra
*UIConstraints: *Model C257i *OutputBin Tray4
*UIConstraints: *Model C257i *Fold ZFold1
*UIConstraints: *Model C257i *Fold ZFold2
*UIConstraints: *Model C257i *FrontCoverTray LCT
*UIConstraints: *Model C257i *BackCoverTray LCT
*UIConstraints: *Model C257i *PIFrontCover PITray1
*UIConstraints: *Model C257i *PIFrontCover PITray2
*UIConstraints: *Model C257i *PIBackCover PITray1
*UIConstraints: *Model C257i *PIBackCover PITray2
*UIConstraints: *Model C257i *OHPOpTray LCT
*UIConstraints: *Model C257i *PaperSources LU207
*UIConstraints: *Model C257i *PaperSources LU302
*UIConstraints: *Model C257i *PaperSources LU205
*UIConstraints: *Model C257i *PaperSources LU303
*UIConstraints: *Model C257i *PaperSources PC116
*UIConstraints: *Model C257i *PaperSources PC116+LU207
*UIConstraints: *Model C257i *PaperSources PC116+LU302
*UIConstraints: *Model C257i *PaperSources PC216
*UIConstraints: *Model C257i *PaperSources PC216+LU207
*UIConstraints: *Model C257i *PaperSources PC216+LU302
*UIConstraints: *Model C257i *PaperSources PC416
*UIConstraints: *Model C257i *PaperSources PC416+LU207
*UIConstraints: *Model C257i *PaperSources PC416+LU302
*UIConstraints: *Model C257i *PaperSources PC417
*UIConstraints: *Model C257i *PaperSources PC417+LU207
*UIConstraints: *Model C257i *PaperSources PC417+LU302
*UIConstraints: *Model C257i *PaperSources PFP13T2
*UIConstraints: *Model C257i *PaperSources PFP13T23
*UIConstraints: *Model C257i *PaperSources PFP13T234
*UIConstraints: *Model C257i *Finisher JS508
*UIConstraints: *Model C257i *Finisher FS540
*UIConstraints: *Model C257i *Finisher FS540JS602
*UIConstraints: *Model C257i *KOPunch PK526
*UIConstraints: *Model C257i *KOPunch PK526-3
*UIConstraints: *Model C257i *KOPunch PK526-4
*UIConstraints: *Model C257i *KOPunch PK526-SWE4
*UIConstraints: *Model C257i *ZFoldUnit ZU609
*UIConstraints: *Model C257i *PostInserter PI507
*UIConstraints: *Model C257i *SaddleUnit SD512
*UIConstraints: *Model C227i *InputSlot LCT
*UIConstraints: *Model C227i *MediaType PlainPlus
*UIConstraints: *Model C227i *MediaType PlainPlus(2nd)
*UIConstraints: *Model C227i *MediaType Thick4
*UIConstraints: *Model C227i *MediaType Thick4(2nd)
*UIConstraints: *Model C227i *MediaType Thin
*UIConstraints: *Model C227i *MediaType Labels
*UIConstraints: *Model C227i *MediaType Postcard
*UIConstraints: *Model C227i *MediaType Glossy
*UIConstraints: *Model C227i *MediaType GlossyPlus
*UIConstraints: *Model C227i *MediaType Glossy2
*UIConstraints: *Model C227i *MediaType User2
*UIConstraints: *Model C227i *MediaType User2(2nd)
*UIConstraints: *Model C227i *MediaType User7
*UIConstraints: *Model C227i *MediaType User7(2nd)
*UIConstraints: *Model C227i *PageSize SRA3
*UIConstraints: *Model C227i *PageSize 12x18
*UIConstraints: *Model C227i *PageSize LetterPlus
*UIConstraints: *Model C227i *PageSize 8x10
*UIConstraints: *Model C227i *PageSize 8x10.5
*UIConstraints: *Model C227i *PageSize DoublePostcardRotated
*UIConstraints: *Model C227i *PageSize A3Extra
*UIConstraints: *Model C227i *PageSize TabloidExtra
*UIConstraints: *Model C227i *OutputBin Tray4
*UIConstraints: *Model C227i *Fold ZFold1
*UIConstraints: *Model C227i *Fold ZFold2
*UIConstraints: *Model C227i *FrontCoverTray LCT
*UIConstraints: *Model C227i *BackCoverTray LCT
*UIConstraints: *Model C227i *PIFrontCover PITray1
*UIConstraints: *Model C227i *PIFrontCover PITray2
*UIConstraints: *Model C227i *PIBackCover PITray1
*UIConstraints: *Model C227i *PIBackCover PITray2
*UIConstraints: *Model C227i *OHPOpTray LCT
*UIConstraints: *Model C227i *PaperSources LU207
*UIConstraints: *Model C227i *PaperSources LU302
*UIConstraints: *Model C227i *PaperSources LU205
*UIConstraints: *Model C227i *PaperSources LU303
*UIConstraints: *Model C227i *PaperSources PC116
*UIConstraints: *Model C227i *PaperSources PC116+LU207
*UIConstraints: *Model C227i *PaperSources PC116+LU302
*UIConstraints: *Model C227i *PaperSources PC216
*UIConstraints: *Model C227i *PaperSources PC216+LU207
*UIConstraints: *Model C227i *PaperSources PC216+LU302
*UIConstraints: *Model C227i *PaperSources PC416
*UIConstraints: *Model C227i *PaperSources PC416+LU207
*UIConstraints: *Model C227i *PaperSources PC416+LU302
*UIConstraints: *Model C227i *PaperSources PC417
*UIConstraints: *Model C227i *PaperSources PC417+LU207
*UIConstraints: *Model C227i *PaperSources PC417+LU302
*UIConstraints: *Model C227i *PaperSources PFP13T2
*UIConstraints: *Model C227i *PaperSources PFP13T23
*UIConstraints: *Model C227i *PaperSources PFP13T234
*UIConstraints: *Model C227i *Finisher JS508
*UIConstraints: *Model C227i *Finisher FS540
*UIConstraints: *Model C227i *Finisher FS540JS602
*UIConstraints: *Model C227i *KOPunch PK526
*UIConstraints: *Model C227i *KOPunch PK526-3
*UIConstraints: *Model C227i *KOPunch PK526-4
*UIConstraints: *Model C227i *KOPunch PK526-SWE4
*UIConstraints: *Model C227i *ZFoldUnit ZU609
*UIConstraints: *Model C227i *PostInserter PI507
*UIConstraints: *Model C227i *SaddleUnit SD512
*UIConstraints: *Model C286i *InputSlot LCT
*UIConstraints: *Model C286i *MediaType PlainPlus
*UIConstraints: *Model C286i *MediaType PlainPlus(2nd)
*UIConstraints: *Model C286i *MediaType Thick4
*UIConstraints: *Model C286i *MediaType Thick4(2nd)
*UIConstraints: *Model C286i *MediaType Thin
*UIConstraints: *Model C286i *MediaType Labels
*UIConstraints: *Model C286i *MediaType Postcard
*UIConstraints: *Model C286i *MediaType Glossy
*UIConstraints: *Model C286i *MediaType GlossyPlus
*UIConstraints: *Model C286i *MediaType Glossy2
*UIConstraints: *Model C286i *MediaType User2
*UIConstraints: *Model C286i *MediaType User2(2nd)
*UIConstraints: *Model C286i *MediaType User7
*UIConstraints: *Model C286i *MediaType User7(2nd)
*UIConstraints: *Model C286i *PageSize SRA3
*UIConstraints: *Model C286i *PageSize 12x18
*UIConstraints: *Model C286i *PageSize LetterPlus
*UIConstraints: *Model C286i *PageSize 8x10
*UIConstraints: *Model C286i *PageSize 8x10.5
*UIConstraints: *Model C286i *PageSize DoublePostcardRotated
*UIConstraints: *Model C286i *PageSize A3Extra
*UIConstraints: *Model C286i *PageSize TabloidExtra
*UIConstraints: *Model C286i *OutputBin Tray1
*UIConstraints: *Model C286i *OutputBin Tray2
*UIConstraints: *Model C286i *OutputBin Tray3
*UIConstraints: *Model C286i *OutputBin Tray4
*UIConstraints: *Model C286i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C286i *Staple 1StapleZeroLeft
*UIConstraints: *Model C286i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C286i *Staple 1StapleZeroRight
*UIConstraints: *Model C286i *Staple 2Staples
*UIConstraints: *Model C286i *Punch 2holes
*UIConstraints: *Model C286i *Punch 3holes
*UIConstraints: *Model C286i *Punch 4holes
*UIConstraints: *Model C286i *Fold Stitch
*UIConstraints: *Model C286i *Fold HalfFold
*UIConstraints: *Model C286i *Fold TriFold
*UIConstraints: *Model C286i *Fold ZFold1
*UIConstraints: *Model C286i *Fold ZFold2
*UIConstraints: *Model C286i *FrontCoverTray LCT
*UIConstraints: *Model C286i *BackCoverTray LCT
*UIConstraints: *Model C286i *PIFrontCover PITray1
*UIConstraints: *Model C286i *PIFrontCover PITray2
*UIConstraints: *Model C286i *PIBackCover PITray1
*UIConstraints: *Model C286i *PIBackCover PITray2
*UIConstraints: *Model C286i *OHPOpTray LCT
*UIConstraints: *Model C286i *PaperSources LU207
*UIConstraints: *Model C286i *PaperSources LU302
*UIConstraints: *Model C286i *PaperSources LU205
*UIConstraints: *Model C286i *PaperSources LU303
*UIConstraints: *Model C286i *PaperSources PC116
*UIConstraints: *Model C286i *PaperSources PC116+LU207
*UIConstraints: *Model C286i *PaperSources PC116+LU302
*UIConstraints: *Model C286i *PaperSources PC216
*UIConstraints: *Model C286i *PaperSources PC216+LU207
*UIConstraints: *Model C286i *PaperSources PC216+LU302
*UIConstraints: *Model C286i *PaperSources PC416
*UIConstraints: *Model C286i *PaperSources PC416+LU207
*UIConstraints: *Model C286i *PaperSources PC416+LU302
*UIConstraints: *Model C286i *PaperSources PC417
*UIConstraints: *Model C286i *PaperSources PC417+LU207
*UIConstraints: *Model C286i *PaperSources PC417+LU302
*UIConstraints: *Model C286i *PaperSources PFP13T2
*UIConstraints: *Model C286i *PaperSources PFP13T23
*UIConstraints: *Model C286i *PaperSources PFP13T234
*UIConstraints: *Model C286i *Finisher FS533
*UIConstraints: *Model C286i *Finisher FS539
*UIConstraints: *Model C286i *Finisher JS506
*UIConstraints: *Model C286i *Finisher JS508
*UIConstraints: *Model C286i *Finisher FS540
*UIConstraints: *Model C286i *Finisher FS540JS602
*UIConstraints: *Model C286i *Finisher FS542
*UIConstraints: *Model C286i *KOPunch PK519
*UIConstraints: *Model C286i *KOPunch PK519-3
*UIConstraints: *Model C286i *KOPunch PK519-4
*UIConstraints: *Model C286i *KOPunch PK519-SWE4
*UIConstraints: *Model C286i *KOPunch PK524
*UIConstraints: *Model C286i *KOPunch PK524-3
*UIConstraints: *Model C286i *KOPunch PK524-4
*UIConstraints: *Model C286i *KOPunch PK524-SWE4
*UIConstraints: *Model C286i *KOPunch PK526
*UIConstraints: *Model C286i *KOPunch PK526-3
*UIConstraints: *Model C286i *KOPunch PK526-4
*UIConstraints: *Model C286i *KOPunch PK526-SWE4
*UIConstraints: *Model C286i *KOPunch PK527
*UIConstraints: *Model C286i *KOPunch PK527-3
*UIConstraints: *Model C286i *KOPunch PK527-4
*UIConstraints: *Model C286i *KOPunch PK527-SWE4
*UIConstraints: *Model C286i *ZFoldUnit ZU609
*UIConstraints: *Model C286i *PostInserter PI507
*UIConstraints: *Model C286i *SaddleUnit SD511
*UIConstraints: *Model C286i *SaddleUnit SD512
*UIConstraints: *Model C266i *InputSlot LCT
*UIConstraints: *Model C266i *MediaType PlainPlus
*UIConstraints: *Model C266i *MediaType PlainPlus(2nd)
*UIConstraints: *Model C266i *MediaType Thick4
*UIConstraints: *Model C266i *MediaType Thick4(2nd)
*UIConstraints: *Model C266i *MediaType Thin
*UIConstraints: *Model C266i *MediaType Labels
*UIConstraints: *Model C266i *MediaType Postcard
*UIConstraints: *Model C266i *MediaType Glossy
*UIConstraints: *Model C266i *MediaType GlossyPlus
*UIConstraints: *Model C266i *MediaType Glossy2
*UIConstraints: *Model C266i *MediaType User2
*UIConstraints: *Model C266i *MediaType User2(2nd)
*UIConstraints: *Model C266i *MediaType User7
*UIConstraints: *Model C266i *MediaType User7(2nd)
*UIConstraints: *Model C266i *PageSize SRA3
*UIConstraints: *Model C266i *PageSize 12x18
*UIConstraints: *Model C266i *PageSize LetterPlus
*UIConstraints: *Model C266i *PageSize 8x10
*UIConstraints: *Model C266i *PageSize 8x10.5
*UIConstraints: *Model C266i *PageSize DoublePostcardRotated
*UIConstraints: *Model C266i *PageSize A3Extra
*UIConstraints: *Model C266i *PageSize TabloidExtra
*UIConstraints: *Model C266i *OutputBin Tray1
*UIConstraints: *Model C266i *OutputBin Tray2
*UIConstraints: *Model C266i *OutputBin Tray3
*UIConstraints: *Model C266i *OutputBin Tray4
*UIConstraints: *Model C266i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C266i *Staple 1StapleZeroLeft
*UIConstraints: *Model C266i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C266i *Staple 1StapleZeroRight
*UIConstraints: *Model C266i *Staple 2Staples
*UIConstraints: *Model C266i *Punch 2holes
*UIConstraints: *Model C266i *Punch 3holes
*UIConstraints: *Model C266i *Punch 4holes
*UIConstraints: *Model C266i *Fold Stitch
*UIConstraints: *Model C266i *Fold HalfFold
*UIConstraints: *Model C266i *Fold TriFold
*UIConstraints: *Model C266i *Fold ZFold1
*UIConstraints: *Model C266i *Fold ZFold2
*UIConstraints: *Model C266i *FrontCoverTray LCT
*UIConstraints: *Model C266i *BackCoverTray LCT
*UIConstraints: *Model C266i *PIFrontCover PITray1
*UIConstraints: *Model C266i *PIFrontCover PITray2
*UIConstraints: *Model C266i *PIBackCover PITray1
*UIConstraints: *Model C266i *PIBackCover PITray2
*UIConstraints: *Model C266i *OHPOpTray LCT
*UIConstraints: *Model C266i *PaperSources LU207
*UIConstraints: *Model C266i *PaperSources LU302
*UIConstraints: *Model C266i *PaperSources LU205
*UIConstraints: *Model C266i *PaperSources LU303
*UIConstraints: *Model C266i *PaperSources PC116
*UIConstraints: *Model C266i *PaperSources PC116+LU207
*UIConstraints: *Model C266i *PaperSources PC116+LU302
*UIConstraints: *Model C266i *PaperSources PC216
*UIConstraints: *Model C266i *PaperSources PC216+LU207
*UIConstraints: *Model C266i *PaperSources PC216+LU302
*UIConstraints: *Model C266i *PaperSources PC416
*UIConstraints: *Model C266i *PaperSources PC416+LU207
*UIConstraints: *Model C266i *PaperSources PC416+LU302
*UIConstraints: *Model C266i *PaperSources PC417
*UIConstraints: *Model C266i *PaperSources PC417+LU207
*UIConstraints: *Model C266i *PaperSources PC417+LU302
*UIConstraints: *Model C266i *PaperSources PFP13T2
*UIConstraints: *Model C266i *PaperSources PFP13T23
*UIConstraints: *Model C266i *PaperSources PFP13T234
*UIConstraints: *Model C266i *Finisher FS533
*UIConstraints: *Model C266i *Finisher FS539
*UIConstraints: *Model C266i *Finisher JS506
*UIConstraints: *Model C266i *Finisher JS508
*UIConstraints: *Model C266i *Finisher FS540
*UIConstraints: *Model C266i *Finisher FS540JS602
*UIConstraints: *Model C266i *Finisher FS542
*UIConstraints: *Model C266i *KOPunch PK519
*UIConstraints: *Model C266i *KOPunch PK519-3
*UIConstraints: *Model C266i *KOPunch PK519-4
*UIConstraints: *Model C266i *KOPunch PK519-SWE4
*UIConstraints: *Model C266i *KOPunch PK524
*UIConstraints: *Model C266i *KOPunch PK524-3
*UIConstraints: *Model C266i *KOPunch PK524-4
*UIConstraints: *Model C266i *KOPunch PK524-SWE4
*UIConstraints: *Model C266i *KOPunch PK526
*UIConstraints: *Model C266i *KOPunch PK526-3
*UIConstraints: *Model C266i *KOPunch PK526-4
*UIConstraints: *Model C266i *KOPunch PK526-SWE4
*UIConstraints: *Model C266i *KOPunch PK527
*UIConstraints: *Model C266i *KOPunch PK527-3
*UIConstraints: *Model C266i *KOPunch PK527-4
*UIConstraints: *Model C266i *KOPunch PK527-SWE4
*UIConstraints: *Model C266i *ZFoldUnit ZU609
*UIConstraints: *Model C266i *PostInserter PI507
*UIConstraints: *Model C266i *SaddleUnit SD511
*UIConstraints: *Model C266i *SaddleUnit SD512
*UIConstraints: *Model C226i *InputSlot LCT
*UIConstraints: *Model C226i *MediaType PlainPlus
*UIConstraints: *Model C226i *MediaType PlainPlus(2nd)
*UIConstraints: *Model C226i *MediaType Thick4
*UIConstraints: *Model C226i *MediaType Thick4(2nd)
*UIConstraints: *Model C226i *MediaType Thin
*UIConstraints: *Model C226i *MediaType Labels
*UIConstraints: *Model C226i *MediaType Postcard
*UIConstraints: *Model C226i *MediaType Glossy
*UIConstraints: *Model C226i *MediaType GlossyPlus
*UIConstraints: *Model C226i *MediaType Glossy2
*UIConstraints: *Model C226i *MediaType User2
*UIConstraints: *Model C226i *MediaType User2(2nd)
*UIConstraints: *Model C226i *MediaType User7
*UIConstraints: *Model C226i *MediaType User7(2nd)
*UIConstraints: *Model C226i *PageSize SRA3
*UIConstraints: *Model C226i *PageSize 12x18
*UIConstraints: *Model C226i *PageSize LetterPlus
*UIConstraints: *Model C226i *PageSize 8x10
*UIConstraints: *Model C226i *PageSize 8x10.5
*UIConstraints: *Model C226i *PageSize DoublePostcardRotated
*UIConstraints: *Model C226i *PageSize A3Extra
*UIConstraints: *Model C226i *PageSize TabloidExtra
*UIConstraints: *Model C226i *OutputBin Tray1
*UIConstraints: *Model C226i *OutputBin Tray2
*UIConstraints: *Model C226i *OutputBin Tray3
*UIConstraints: *Model C226i *OutputBin Tray4
*UIConstraints: *Model C226i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C226i *Staple 1StapleZeroLeft
*UIConstraints: *Model C226i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C226i *Staple 1StapleZeroRight
*UIConstraints: *Model C226i *Staple 2Staples
*UIConstraints: *Model C226i *Punch 2holes
*UIConstraints: *Model C226i *Punch 3holes
*UIConstraints: *Model C226i *Punch 4holes
*UIConstraints: *Model C226i *Fold Stitch
*UIConstraints: *Model C226i *Fold HalfFold
*UIConstraints: *Model C226i *Fold TriFold
*UIConstraints: *Model C226i *Fold ZFold1
*UIConstraints: *Model C226i *Fold ZFold2
*UIConstraints: *Model C226i *FrontCoverTray LCT
*UIConstraints: *Model C226i *BackCoverTray LCT
*UIConstraints: *Model C226i *PIFrontCover PITray1
*UIConstraints: *Model C226i *PIFrontCover PITray2
*UIConstraints: *Model C226i *PIBackCover PITray1
*UIConstraints: *Model C226i *PIBackCover PITray2
*UIConstraints: *Model C226i *OHPOpTray LCT
*UIConstraints: *Model C226i *PaperSources LU207
*UIConstraints: *Model C226i *PaperSources LU302
*UIConstraints: *Model C226i *PaperSources LU205
*UIConstraints: *Model C226i *PaperSources LU303
*UIConstraints: *Model C226i *PaperSources PC116
*UIConstraints: *Model C226i *PaperSources PC116+LU207
*UIConstraints: *Model C226i *PaperSources PC116+LU302
*UIConstraints: *Model C226i *PaperSources PC216
*UIConstraints: *Model C226i *PaperSources PC216+LU207
*UIConstraints: *Model C226i *PaperSources PC216+LU302
*UIConstraints: *Model C226i *PaperSources PC416
*UIConstraints: *Model C226i *PaperSources PC416+LU207
*UIConstraints: *Model C226i *PaperSources PC416+LU302
*UIConstraints: *Model C226i *PaperSources PC417
*UIConstraints: *Model C226i *PaperSources PC417+LU207
*UIConstraints: *Model C226i *PaperSources PC417+LU302
*UIConstraints: *Model C226i *PaperSources PFP13T2
*UIConstraints: *Model C226i *PaperSources PFP13T23
*UIConstraints: *Model C226i *PaperSources PFP13T234
*UIConstraints: *Model C226i *Finisher FS533
*UIConstraints: *Model C226i *Finisher FS539
*UIConstraints: *Model C226i *Finisher JS506
*UIConstraints: *Model C226i *Finisher JS508
*UIConstraints: *Model C226i *Finisher FS540
*UIConstraints: *Model C226i *Finisher FS540JS602
*UIConstraints: *Model C226i *Finisher FS542
*UIConstraints: *Model C226i *KOPunch PK519
*UIConstraints: *Model C226i *KOPunch PK519-3
*UIConstraints: *Model C226i *KOPunch PK519-4
*UIConstraints: *Model C226i *KOPunch PK519-SWE4
*UIConstraints: *Model C226i *KOPunch PK524
*UIConstraints: *Model C226i *KOPunch PK524-3
*UIConstraints: *Model C226i *KOPunch PK524-4
*UIConstraints: *Model C226i *KOPunch PK524-SWE4
*UIConstraints: *Model C226i *KOPunch PK526
*UIConstraints: *Model C226i *KOPunch PK526-3
*UIConstraints: *Model C226i *KOPunch PK526-4
*UIConstraints: *Model C226i *KOPunch PK526-SWE4
*UIConstraints: *Model C226i *KOPunch PK527
*UIConstraints: *Model C226i *KOPunch PK527-3
*UIConstraints: *Model C226i *KOPunch PK527-4
*UIConstraints: *Model C226i *KOPunch PK527-SWE4
*UIConstraints: *Model C226i *ZFoldUnit ZU609
*UIConstraints: *Model C226i *PostInserter PI507
*UIConstraints: *Model C226i *SaddleUnit SD511
*UIConstraints: *Model C226i *SaddleUnit SD512
*UIConstraints: *Model C4050i *Offset True
*UIConstraints: *Model C4050i *InputSlot Tray4
*UIConstraints: *Model C4050i *InputSlot LCT
*UIConstraints: *Model C4050i *MediaType Thick3
*UIConstraints: *Model C4050i *MediaType Thick3(2nd)
*UIConstraints: *Model C4050i *MediaType Thick4
*UIConstraints: *Model C4050i *MediaType Thick4(2nd)
*UIConstraints: *Model C4050i *MediaType Thin
*UIConstraints: *Model C4050i *MediaType Transparency
*UIConstraints: *Model C4050i *MediaType TAB
*UIConstraints: *Model C4050i *MediaType User2_1
*UIConstraints: *Model C4050i *MediaType User2(2nd)_1
*UIConstraints: *Model C4050i *MediaType User6
*UIConstraints: *Model C4050i *MediaType User6(2nd)
*UIConstraints: *Model C4050i *MediaType User7
*UIConstraints: *Model C4050i *MediaType User7(2nd)
*UIConstraints: *Model C4050i *PageSize A3
*UIConstraints: *Model C4050i *PageSize B4
*UIConstraints: *Model C4050i *PageSize SRA3
*UIConstraints: *Model C4050i *PageSize 220mmx330mm
*UIConstraints: *Model C4050i *PageSize 12x18
*UIConstraints: *Model C4050i *PageSize Tabloid
*UIConstraints: *Model C4050i *PageSize 8K
*UIConstraints: *Model C4050i *PageSize EnvC4
*UIConstraints: *Model C4050i *PageSize EnvC5
*UIConstraints: *Model C4050i *PageSize EnvKaku1
*UIConstraints: *Model C4050i *PageSize EnvKaku2
*UIConstraints: *Model C4050i *PageSize EnvKaku3
*UIConstraints: *Model C4050i *PageSize A3Extra
*UIConstraints: *Model C4050i *PageSize A4Extra
*UIConstraints: *Model C4050i *PageSize A5Extra
*UIConstraints: *Model C4050i *PageSize B4Extra
*UIConstraints: *Model C4050i *PageSize B5Extra
*UIConstraints: *Model C4050i *PageSize TabloidExtra
*UIConstraints: *Model C4050i *PageSize LetterExtra
*UIConstraints: *Model C4050i *PageSize StatementExtra
*UIConstraints: *Model C4050i *PageSize LetterTab-F
*UIConstraints: *Model C4050i *PageSize A4Tab-F
*UIConstraints: *Model C4050i *OutputBin Tray1
*UIConstraints: *Model C4050i *OutputBin Tray2
*UIConstraints: *Model C4050i *OutputBin Tray3
*UIConstraints: *Model C4050i *OutputBin Tray4
*UIConstraints: *Model C4050i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C4050i *Staple 1StapleZeroLeft
*UIConstraints: *Model C4050i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C4050i *Staple 1StapleZeroRight
*UIConstraints: *Model C4050i *Staple 2Staples
*UIConstraints: *Model C4050i *Punch 2holes
*UIConstraints: *Model C4050i *Punch 3holes
*UIConstraints: *Model C4050i *Punch 4holes
*UIConstraints: *Model C4050i *Fold Stitch
*UIConstraints: *Model C4050i *Fold HalfFold
*UIConstraints: *Model C4050i *Fold TriFold
*UIConstraints: *Model C4050i *Fold ZFold1
*UIConstraints: *Model C4050i *Fold ZFold2
*UIConstraints: *Model C4050i *FrontCoverTray Tray4
*UIConstraints: *Model C4050i *FrontCoverTray LCT
*UIConstraints: *Model C4050i *BackCoverTray Tray4
*UIConstraints: *Model C4050i *BackCoverTray LCT
*UIConstraints: *Model C4050i *PIFrontCover PITray1
*UIConstraints: *Model C4050i *PIFrontCover PITray2
*UIConstraints: *Model C4050i *PIBackCover PITray1
*UIConstraints: *Model C4050i *PIBackCover PITray2
*UIConstraints: *Model C4050i *TransparencyInterleave Blank
*UIConstraints: *Model C4050i *OHPOpTray Tray1
*UIConstraints: *Model C4050i *OHPOpTray Tray2
*UIConstraints: *Model C4050i *OHPOpTray Tray3
*UIConstraints: *Model C4050i *OHPOpTray Tray4
*UIConstraints: *Model C4050i *OHPOpTray LCT
*UIConstraints: *Model C4050i *PaperSources LU207
*UIConstraints: *Model C4050i *PaperSources LU302
*UIConstraints: *Model C4050i *PaperSources LU205
*UIConstraints: *Model C4050i *PaperSources LU303
*UIConstraints: *Model C4050i *PaperSources PC116
*UIConstraints: *Model C4050i *PaperSources PC116+LU207
*UIConstraints: *Model C4050i *PaperSources PC116+LU302
*UIConstraints: *Model C4050i *PaperSources PC118
*UIConstraints: *Model C4050i *PaperSources PC216
*UIConstraints: *Model C4050i *PaperSources PC216+LU207
*UIConstraints: *Model C4050i *PaperSources PC216+LU302
*UIConstraints: *Model C4050i *PaperSources PC218
*UIConstraints: *Model C4050i *PaperSources PC416
*UIConstraints: *Model C4050i *PaperSources PC416+LU207
*UIConstraints: *Model C4050i *PaperSources PC416+LU302
*UIConstraints: *Model C4050i *PaperSources PC417
*UIConstraints: *Model C4050i *PaperSources PC417+LU207
*UIConstraints: *Model C4050i *PaperSources PC417+LU302
*UIConstraints: *Model C4050i *PaperSources PC418
*UIConstraints: *Model C4050i *PaperSources PFP13T234
*UIConstraints: *Model C4050i *Finisher FS533
*UIConstraints: *Model C4050i *Finisher FS539
*UIConstraints: *Model C4050i *Finisher JS506
*UIConstraints: *Model C4050i *Finisher JS508
*UIConstraints: *Model C4050i *Finisher FS540
*UIConstraints: *Model C4050i *Finisher FS540JS602
*UIConstraints: *Model C4050i *Finisher FS542
*UIConstraints: *Model C4050i *KOPunch PK519
*UIConstraints: *Model C4050i *KOPunch PK519-3
*UIConstraints: *Model C4050i *KOPunch PK519-4
*UIConstraints: *Model C4050i *KOPunch PK519-SWE4
*UIConstraints: *Model C4050i *KOPunch PK524
*UIConstraints: *Model C4050i *KOPunch PK524-3
*UIConstraints: *Model C4050i *KOPunch PK524-4
*UIConstraints: *Model C4050i *KOPunch PK524-SWE4
*UIConstraints: *Model C4050i *KOPunch PK526
*UIConstraints: *Model C4050i *KOPunch PK526-3
*UIConstraints: *Model C4050i *KOPunch PK526-4
*UIConstraints: *Model C4050i *KOPunch PK526-SWE4
*UIConstraints: *Model C4050i *KOPunch PK527
*UIConstraints: *Model C4050i *KOPunch PK527-3
*UIConstraints: *Model C4050i *KOPunch PK527-4
*UIConstraints: *Model C4050i *KOPunch PK527-SWE4
*UIConstraints: *Model C4050i *ZFoldUnit ZU609
*UIConstraints: *Model C4050i *PostInserter PI507
*UIConstraints: *Model C4050i *SaddleUnit SD511
*UIConstraints: *Model C4050i *SaddleUnit SD512
*UIConstraints: *Model C3350i *Offset True
*UIConstraints: *Model C3350i *InputSlot Tray4
*UIConstraints: *Model C3350i *InputSlot LCT
*UIConstraints: *Model C3350i *MediaType Thick3
*UIConstraints: *Model C3350i *MediaType Thick3(2nd)
*UIConstraints: *Model C3350i *MediaType Thick4
*UIConstraints: *Model C3350i *MediaType Thick4(2nd)
*UIConstraints: *Model C3350i *MediaType Thin
*UIConstraints: *Model C3350i *MediaType Transparency
*UIConstraints: *Model C3350i *MediaType TAB
*UIConstraints: *Model C3350i *MediaType User2_1
*UIConstraints: *Model C3350i *MediaType User2(2nd)_1
*UIConstraints: *Model C3350i *MediaType User6
*UIConstraints: *Model C3350i *MediaType User6(2nd)
*UIConstraints: *Model C3350i *MediaType User7
*UIConstraints: *Model C3350i *MediaType User7(2nd)
*UIConstraints: *Model C3350i *PageSize A3
*UIConstraints: *Model C3350i *PageSize B4
*UIConstraints: *Model C3350i *PageSize SRA3
*UIConstraints: *Model C3350i *PageSize 220mmx330mm
*UIConstraints: *Model C3350i *PageSize 12x18
*UIConstraints: *Model C3350i *PageSize Tabloid
*UIConstraints: *Model C3350i *PageSize 8K
*UIConstraints: *Model C3350i *PageSize EnvC4
*UIConstraints: *Model C3350i *PageSize EnvC5
*UIConstraints: *Model C3350i *PageSize EnvKaku1
*UIConstraints: *Model C3350i *PageSize EnvKaku2
*UIConstraints: *Model C3350i *PageSize EnvKaku3
*UIConstraints: *Model C3350i *PageSize A3Extra
*UIConstraints: *Model C3350i *PageSize A4Extra
*UIConstraints: *Model C3350i *PageSize A5Extra
*UIConstraints: *Model C3350i *PageSize B4Extra
*UIConstraints: *Model C3350i *PageSize B5Extra
*UIConstraints: *Model C3350i *PageSize TabloidExtra
*UIConstraints: *Model C3350i *PageSize LetterExtra
*UIConstraints: *Model C3350i *PageSize StatementExtra
*UIConstraints: *Model C3350i *PageSize LetterTab-F
*UIConstraints: *Model C3350i *PageSize A4Tab-F
*UIConstraints: *Model C3350i *OutputBin Tray1
*UIConstraints: *Model C3350i *OutputBin Tray2
*UIConstraints: *Model C3350i *OutputBin Tray3
*UIConstraints: *Model C3350i *OutputBin Tray4
*UIConstraints: *Model C3350i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C3350i *Staple 1StapleZeroLeft
*UIConstraints: *Model C3350i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C3350i *Staple 1StapleZeroRight
*UIConstraints: *Model C3350i *Staple 2Staples
*UIConstraints: *Model C3350i *Punch 2holes
*UIConstraints: *Model C3350i *Punch 3holes
*UIConstraints: *Model C3350i *Punch 4holes
*UIConstraints: *Model C3350i *Fold Stitch
*UIConstraints: *Model C3350i *Fold HalfFold
*UIConstraints: *Model C3350i *Fold TriFold
*UIConstraints: *Model C3350i *Fold ZFold1
*UIConstraints: *Model C3350i *Fold ZFold2
*UIConstraints: *Model C3350i *FrontCoverTray Tray4
*UIConstraints: *Model C3350i *FrontCoverTray LCT
*UIConstraints: *Model C3350i *BackCoverTray Tray4
*UIConstraints: *Model C3350i *BackCoverTray LCT
*UIConstraints: *Model C3350i *PIFrontCover PITray1
*UIConstraints: *Model C3350i *PIFrontCover PITray2
*UIConstraints: *Model C3350i *PIBackCover PITray1
*UIConstraints: *Model C3350i *PIBackCover PITray2
*UIConstraints: *Model C3350i *TransparencyInterleave Blank
*UIConstraints: *Model C3350i *OHPOpTray Tray1
*UIConstraints: *Model C3350i *OHPOpTray Tray2
*UIConstraints: *Model C3350i *OHPOpTray Tray3
*UIConstraints: *Model C3350i *OHPOpTray Tray4
*UIConstraints: *Model C3350i *OHPOpTray LCT
*UIConstraints: *Model C3350i *PaperSources LU207
*UIConstraints: *Model C3350i *PaperSources LU302
*UIConstraints: *Model C3350i *PaperSources LU205
*UIConstraints: *Model C3350i *PaperSources LU303
*UIConstraints: *Model C3350i *PaperSources PC116
*UIConstraints: *Model C3350i *PaperSources PC116+LU207
*UIConstraints: *Model C3350i *PaperSources PC116+LU302
*UIConstraints: *Model C3350i *PaperSources PC118
*UIConstraints: *Model C3350i *PaperSources PC216
*UIConstraints: *Model C3350i *PaperSources PC216+LU207
*UIConstraints: *Model C3350i *PaperSources PC216+LU302
*UIConstraints: *Model C3350i *PaperSources PC218
*UIConstraints: *Model C3350i *PaperSources PC416
*UIConstraints: *Model C3350i *PaperSources PC416+LU207
*UIConstraints: *Model C3350i *PaperSources PC416+LU302
*UIConstraints: *Model C3350i *PaperSources PC417
*UIConstraints: *Model C3350i *PaperSources PC417+LU207
*UIConstraints: *Model C3350i *PaperSources PC417+LU302
*UIConstraints: *Model C3350i *PaperSources PC418
*UIConstraints: *Model C3350i *PaperSources PFP13T234
*UIConstraints: *Model C3350i *Finisher FS533
*UIConstraints: *Model C3350i *Finisher FS539
*UIConstraints: *Model C3350i *Finisher JS506
*UIConstraints: *Model C3350i *Finisher JS508
*UIConstraints: *Model C3350i *Finisher FS540
*UIConstraints: *Model C3350i *Finisher FS540JS602
*UIConstraints: *Model C3350i *Finisher FS542
*UIConstraints: *Model C3350i *KOPunch PK519
*UIConstraints: *Model C3350i *KOPunch PK519-3
*UIConstraints: *Model C3350i *KOPunch PK519-4
*UIConstraints: *Model C3350i *KOPunch PK519-SWE4
*UIConstraints: *Model C3350i *KOPunch PK524
*UIConstraints: *Model C3350i *KOPunch PK524-3
*UIConstraints: *Model C3350i *KOPunch PK524-4
*UIConstraints: *Model C3350i *KOPunch PK524-SWE4
*UIConstraints: *Model C3350i *KOPunch PK526
*UIConstraints: *Model C3350i *KOPunch PK526-3
*UIConstraints: *Model C3350i *KOPunch PK526-4
*UIConstraints: *Model C3350i *KOPunch PK526-SWE4
*UIConstraints: *Model C3350i *KOPunch PK527
*UIConstraints: *Model C3350i *KOPunch PK527-3
*UIConstraints: *Model C3350i *KOPunch PK527-4
*UIConstraints: *Model C3350i *KOPunch PK527-SWE4
*UIConstraints: *Model C3350i *ZFoldUnit ZU609
*UIConstraints: *Model C3350i *PostInserter PI507
*UIConstraints: *Model C3350i *SaddleUnit SD511
*UIConstraints: *Model C3350i *SaddleUnit SD512
*UIConstraints: *Model C4000i *Offset True
*UIConstraints: *Model C4000i *InputSlot Tray4
*UIConstraints: *Model C4000i *InputSlot LCT
*UIConstraints: *Model C4000i *MediaType Thick3
*UIConstraints: *Model C4000i *MediaType Thick3(2nd)
*UIConstraints: *Model C4000i *MediaType Thick4
*UIConstraints: *Model C4000i *MediaType Thick4(2nd)
*UIConstraints: *Model C4000i *MediaType Thin
*UIConstraints: *Model C4000i *MediaType Transparency
*UIConstraints: *Model C4000i *MediaType TAB
*UIConstraints: *Model C4000i *MediaType User2_1
*UIConstraints: *Model C4000i *MediaType User2(2nd)_1
*UIConstraints: *Model C4000i *MediaType User6
*UIConstraints: *Model C4000i *MediaType User6(2nd)
*UIConstraints: *Model C4000i *MediaType User7
*UIConstraints: *Model C4000i *MediaType User7(2nd)
*UIConstraints: *Model C4000i *PageSize A3
*UIConstraints: *Model C4000i *PageSize B4
*UIConstraints: *Model C4000i *PageSize SRA3
*UIConstraints: *Model C4000i *PageSize 220mmx330mm
*UIConstraints: *Model C4000i *PageSize 12x18
*UIConstraints: *Model C4000i *PageSize Tabloid
*UIConstraints: *Model C4000i *PageSize 8K
*UIConstraints: *Model C4000i *PageSize EnvC4
*UIConstraints: *Model C4000i *PageSize EnvC5
*UIConstraints: *Model C4000i *PageSize EnvKaku1
*UIConstraints: *Model C4000i *PageSize EnvKaku2
*UIConstraints: *Model C4000i *PageSize EnvKaku3
*UIConstraints: *Model C4000i *PageSize A3Extra
*UIConstraints: *Model C4000i *PageSize A4Extra
*UIConstraints: *Model C4000i *PageSize A5Extra
*UIConstraints: *Model C4000i *PageSize B4Extra
*UIConstraints: *Model C4000i *PageSize B5Extra
*UIConstraints: *Model C4000i *PageSize TabloidExtra
*UIConstraints: *Model C4000i *PageSize LetterExtra
*UIConstraints: *Model C4000i *PageSize StatementExtra
*UIConstraints: *Model C4000i *PageSize LetterTab-F
*UIConstraints: *Model C4000i *PageSize A4Tab-F
*UIConstraints: *Model C4000i *OutputBin Tray1
*UIConstraints: *Model C4000i *OutputBin Tray2
*UIConstraints: *Model C4000i *OutputBin Tray3
*UIConstraints: *Model C4000i *OutputBin Tray4
*UIConstraints: *Model C4000i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C4000i *Staple 1StapleZeroLeft
*UIConstraints: *Model C4000i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C4000i *Staple 1StapleZeroRight
*UIConstraints: *Model C4000i *Staple 2Staples
*UIConstraints: *Model C4000i *Punch 2holes
*UIConstraints: *Model C4000i *Punch 3holes
*UIConstraints: *Model C4000i *Punch 4holes
*UIConstraints: *Model C4000i *Fold Stitch
*UIConstraints: *Model C4000i *Fold HalfFold
*UIConstraints: *Model C4000i *Fold TriFold
*UIConstraints: *Model C4000i *Fold ZFold1
*UIConstraints: *Model C4000i *Fold ZFold2
*UIConstraints: *Model C4000i *FrontCoverTray Tray4
*UIConstraints: *Model C4000i *FrontCoverTray LCT
*UIConstraints: *Model C4000i *BackCoverTray Tray4
*UIConstraints: *Model C4000i *BackCoverTray LCT
*UIConstraints: *Model C4000i *PIFrontCover PITray1
*UIConstraints: *Model C4000i *PIFrontCover PITray2
*UIConstraints: *Model C4000i *PIBackCover PITray1
*UIConstraints: *Model C4000i *PIBackCover PITray2
*UIConstraints: *Model C4000i *TransparencyInterleave Blank
*UIConstraints: *Model C4000i *OHPOpTray Tray1
*UIConstraints: *Model C4000i *OHPOpTray Tray2
*UIConstraints: *Model C4000i *OHPOpTray Tray3
*UIConstraints: *Model C4000i *OHPOpTray Tray4
*UIConstraints: *Model C4000i *OHPOpTray LCT
*UIConstraints: *Model C4000i *PaperSources LU207
*UIConstraints: *Model C4000i *PaperSources LU302
*UIConstraints: *Model C4000i *PaperSources LU205
*UIConstraints: *Model C4000i *PaperSources LU303
*UIConstraints: *Model C4000i *PaperSources PC116
*UIConstraints: *Model C4000i *PaperSources PC116+LU207
*UIConstraints: *Model C4000i *PaperSources PC116+LU302
*UIConstraints: *Model C4000i *PaperSources PC118
*UIConstraints: *Model C4000i *PaperSources PC216
*UIConstraints: *Model C4000i *PaperSources PC216+LU207
*UIConstraints: *Model C4000i *PaperSources PC216+LU302
*UIConstraints: *Model C4000i *PaperSources PC218
*UIConstraints: *Model C4000i *PaperSources PC416
*UIConstraints: *Model C4000i *PaperSources PC416+LU207
*UIConstraints: *Model C4000i *PaperSources PC416+LU302
*UIConstraints: *Model C4000i *PaperSources PC417
*UIConstraints: *Model C4000i *PaperSources PC417+LU207
*UIConstraints: *Model C4000i *PaperSources PC417+LU302
*UIConstraints: *Model C4000i *PaperSources PC418
*UIConstraints: *Model C4000i *PaperSources PFP13T234
*UIConstraints: *Model C4000i *Finisher FS533
*UIConstraints: *Model C4000i *Finisher FS539
*UIConstraints: *Model C4000i *Finisher JS506
*UIConstraints: *Model C4000i *Finisher JS508
*UIConstraints: *Model C4000i *Finisher FS540
*UIConstraints: *Model C4000i *Finisher FS540JS602
*UIConstraints: *Model C4000i *Finisher FS542
*UIConstraints: *Model C4000i *KOPunch PK519
*UIConstraints: *Model C4000i *KOPunch PK519-3
*UIConstraints: *Model C4000i *KOPunch PK519-4
*UIConstraints: *Model C4000i *KOPunch PK519-SWE4
*UIConstraints: *Model C4000i *KOPunch PK524
*UIConstraints: *Model C4000i *KOPunch PK524-3
*UIConstraints: *Model C4000i *KOPunch PK524-4
*UIConstraints: *Model C4000i *KOPunch PK524-SWE4
*UIConstraints: *Model C4000i *KOPunch PK526
*UIConstraints: *Model C4000i *KOPunch PK526-3
*UIConstraints: *Model C4000i *KOPunch PK526-4
*UIConstraints: *Model C4000i *KOPunch PK526-SWE4
*UIConstraints: *Model C4000i *KOPunch PK527
*UIConstraints: *Model C4000i *KOPunch PK527-3
*UIConstraints: *Model C4000i *KOPunch PK527-4
*UIConstraints: *Model C4000i *KOPunch PK527-SWE4
*UIConstraints: *Model C4000i *ZFoldUnit ZU609
*UIConstraints: *Model C4000i *PostInserter PI507
*UIConstraints: *Model C4000i *SaddleUnit SD511
*UIConstraints: *Model C4000i *SaddleUnit SD512
*UIConstraints: *Model C4000i *PrinterHDD HDD
*UIConstraints: *Model C3300i *Offset True
*UIConstraints: *Model C3300i *InputSlot Tray3
*UIConstraints: *Model C3300i *InputSlot Tray4
*UIConstraints: *Model C3300i *InputSlot LCT
*UIConstraints: *Model C3300i *MediaType Thick3
*UIConstraints: *Model C3300i *MediaType Thick3(2nd)
*UIConstraints: *Model C3300i *MediaType Thick4
*UIConstraints: *Model C3300i *MediaType Thick4(2nd)
*UIConstraints: *Model C3300i *MediaType Thin
*UIConstraints: *Model C3300i *MediaType Transparency
*UIConstraints: *Model C3300i *MediaType TAB
*UIConstraints: *Model C3300i *MediaType User2_1
*UIConstraints: *Model C3300i *MediaType User2(2nd)_1
*UIConstraints: *Model C3300i *MediaType User6
*UIConstraints: *Model C3300i *MediaType User6(2nd)
*UIConstraints: *Model C3300i *MediaType User7
*UIConstraints: *Model C3300i *MediaType User7(2nd)
*UIConstraints: *Model C3300i *PageSize A3
*UIConstraints: *Model C3300i *PageSize B4
*UIConstraints: *Model C3300i *PageSize SRA3
*UIConstraints: *Model C3300i *PageSize 220mmx330mm
*UIConstraints: *Model C3300i *PageSize 12x18
*UIConstraints: *Model C3300i *PageSize Tabloid
*UIConstraints: *Model C3300i *PageSize 8K
*UIConstraints: *Model C3300i *PageSize EnvC4
*UIConstraints: *Model C3300i *PageSize EnvC5
*UIConstraints: *Model C3300i *PageSize EnvKaku1
*UIConstraints: *Model C3300i *PageSize EnvKaku2
*UIConstraints: *Model C3300i *PageSize EnvKaku3
*UIConstraints: *Model C3300i *PageSize A3Extra
*UIConstraints: *Model C3300i *PageSize A4Extra
*UIConstraints: *Model C3300i *PageSize A5Extra
*UIConstraints: *Model C3300i *PageSize B4Extra
*UIConstraints: *Model C3300i *PageSize B5Extra
*UIConstraints: *Model C3300i *PageSize TabloidExtra
*UIConstraints: *Model C3300i *PageSize LetterExtra
*UIConstraints: *Model C3300i *PageSize StatementExtra
*UIConstraints: *Model C3300i *PageSize LetterTab-F
*UIConstraints: *Model C3300i *PageSize A4Tab-F
*UIConstraints: *Model C3300i *OutputBin Tray1
*UIConstraints: *Model C3300i *OutputBin Tray2
*UIConstraints: *Model C3300i *OutputBin Tray3
*UIConstraints: *Model C3300i *OutputBin Tray4
*UIConstraints: *Model C3300i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C3300i *Staple 1StapleZeroLeft
*UIConstraints: *Model C3300i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C3300i *Staple 1StapleZeroRight
*UIConstraints: *Model C3300i *Staple 2Staples
*UIConstraints: *Model C3300i *Punch 2holes
*UIConstraints: *Model C3300i *Punch 3holes
*UIConstraints: *Model C3300i *Punch 4holes
*UIConstraints: *Model C3300i *Fold Stitch
*UIConstraints: *Model C3300i *Fold HalfFold
*UIConstraints: *Model C3300i *Fold TriFold
*UIConstraints: *Model C3300i *Fold ZFold1
*UIConstraints: *Model C3300i *Fold ZFold2
*UIConstraints: *Model C3300i *FrontCoverTray Tray3
*UIConstraints: *Model C3300i *FrontCoverTray Tray4
*UIConstraints: *Model C3300i *FrontCoverTray LCT
*UIConstraints: *Model C3300i *BackCoverTray Tray3
*UIConstraints: *Model C3300i *BackCoverTray Tray4
*UIConstraints: *Model C3300i *BackCoverTray LCT
*UIConstraints: *Model C3300i *PIFrontCover PITray1
*UIConstraints: *Model C3300i *PIFrontCover PITray2
*UIConstraints: *Model C3300i *PIBackCover PITray1
*UIConstraints: *Model C3300i *PIBackCover PITray2
*UIConstraints: *Model C3300i *TransparencyInterleave Blank
*UIConstraints: *Model C3300i *OHPOpTray Tray1
*UIConstraints: *Model C3300i *OHPOpTray Tray2
*UIConstraints: *Model C3300i *OHPOpTray Tray3
*UIConstraints: *Model C3300i *OHPOpTray Tray4
*UIConstraints: *Model C3300i *OHPOpTray LCT
*UIConstraints: *Model C3300i *PaperSources LU207
*UIConstraints: *Model C3300i *PaperSources LU302
*UIConstraints: *Model C3300i *PaperSources LU205
*UIConstraints: *Model C3300i *PaperSources LU303
*UIConstraints: *Model C3300i *PaperSources PC116
*UIConstraints: *Model C3300i *PaperSources PC116+LU207
*UIConstraints: *Model C3300i *PaperSources PC116+LU302
*UIConstraints: *Model C3300i *PaperSources PC118
*UIConstraints: *Model C3300i *PaperSources PC216
*UIConstraints: *Model C3300i *PaperSources PC216+LU207
*UIConstraints: *Model C3300i *PaperSources PC216+LU302
*UIConstraints: *Model C3300i *PaperSources PC218
*UIConstraints: *Model C3300i *PaperSources PC416
*UIConstraints: *Model C3300i *PaperSources PC416+LU207
*UIConstraints: *Model C3300i *PaperSources PC416+LU302
*UIConstraints: *Model C3300i *PaperSources PC417
*UIConstraints: *Model C3300i *PaperSources PC417+LU207
*UIConstraints: *Model C3300i *PaperSources PC417+LU302
*UIConstraints: *Model C3300i *PaperSources PC418
*UIConstraints: *Model C3300i *PaperSources PFP13T23
*UIConstraints: *Model C3300i *PaperSources PFP13T234
*UIConstraints: *Model C3300i *Finisher FS533
*UIConstraints: *Model C3300i *Finisher FS539
*UIConstraints: *Model C3300i *Finisher JS506
*UIConstraints: *Model C3300i *Finisher JS508
*UIConstraints: *Model C3300i *Finisher FS540
*UIConstraints: *Model C3300i *Finisher FS540JS602
*UIConstraints: *Model C3300i *Finisher FS542
*UIConstraints: *Model C3300i *KOPunch PK519
*UIConstraints: *Model C3300i *KOPunch PK519-3
*UIConstraints: *Model C3300i *KOPunch PK519-4
*UIConstraints: *Model C3300i *KOPunch PK519-SWE4
*UIConstraints: *Model C3300i *KOPunch PK524
*UIConstraints: *Model C3300i *KOPunch PK524-3
*UIConstraints: *Model C3300i *KOPunch PK524-4
*UIConstraints: *Model C3300i *KOPunch PK524-SWE4
*UIConstraints: *Model C3300i *KOPunch PK526
*UIConstraints: *Model C3300i *KOPunch PK526-3
*UIConstraints: *Model C3300i *KOPunch PK526-4
*UIConstraints: *Model C3300i *KOPunch PK526-SWE4
*UIConstraints: *Model C3300i *KOPunch PK527
*UIConstraints: *Model C3300i *KOPunch PK527-3
*UIConstraints: *Model C3300i *KOPunch PK527-4
*UIConstraints: *Model C3300i *KOPunch PK527-SWE4
*UIConstraints: *Model C3300i *ZFoldUnit ZU609
*UIConstraints: *Model C3300i *PostInserter PI507
*UIConstraints: *Model C3300i *SaddleUnit SD511
*UIConstraints: *Model C3300i *SaddleUnit SD512
*UIConstraints: *Model C3300i *PrinterHDD HDD
*UIConstraints: *Model C3320i *Offset True
*UIConstraints: *Model C3320i *InputSlot Tray3
*UIConstraints: *Model C3320i *InputSlot Tray4
*UIConstraints: *Model C3320i *InputSlot LCT
*UIConstraints: *Model C3320i *MediaType Thick3
*UIConstraints: *Model C3320i *MediaType Thick3(2nd)
*UIConstraints: *Model C3320i *MediaType Thick4
*UIConstraints: *Model C3320i *MediaType Thick4(2nd)
*UIConstraints: *Model C3320i *MediaType Thin
*UIConstraints: *Model C3320i *MediaType Transparency
*UIConstraints: *Model C3320i *MediaType TAB
*UIConstraints: *Model C3320i *MediaType User2_1
*UIConstraints: *Model C3320i *MediaType User2(2nd)_1
*UIConstraints: *Model C3320i *MediaType User6
*UIConstraints: *Model C3320i *MediaType User6(2nd)
*UIConstraints: *Model C3320i *MediaType User7
*UIConstraints: *Model C3320i *MediaType User7(2nd)
*UIConstraints: *Model C3320i *PageSize A3
*UIConstraints: *Model C3320i *PageSize B4
*UIConstraints: *Model C3320i *PageSize SRA3
*UIConstraints: *Model C3320i *PageSize 220mmx330mm
*UIConstraints: *Model C3320i *PageSize 12x18
*UIConstraints: *Model C3320i *PageSize Tabloid
*UIConstraints: *Model C3320i *PageSize 8K
*UIConstraints: *Model C3320i *PageSize EnvC4
*UIConstraints: *Model C3320i *PageSize EnvC5
*UIConstraints: *Model C3320i *PageSize EnvKaku1
*UIConstraints: *Model C3320i *PageSize EnvKaku2
*UIConstraints: *Model C3320i *PageSize EnvKaku3
*UIConstraints: *Model C3320i *PageSize A3Extra
*UIConstraints: *Model C3320i *PageSize A4Extra
*UIConstraints: *Model C3320i *PageSize A5Extra
*UIConstraints: *Model C3320i *PageSize B4Extra
*UIConstraints: *Model C3320i *PageSize B5Extra
*UIConstraints: *Model C3320i *PageSize TabloidExtra
*UIConstraints: *Model C3320i *PageSize LetterExtra
*UIConstraints: *Model C3320i *PageSize StatementExtra
*UIConstraints: *Model C3320i *PageSize LetterTab-F
*UIConstraints: *Model C3320i *PageSize A4Tab-F
*UIConstraints: *Model C3320i *OutputBin Tray1
*UIConstraints: *Model C3320i *OutputBin Tray2
*UIConstraints: *Model C3320i *OutputBin Tray3
*UIConstraints: *Model C3320i *OutputBin Tray4
*UIConstraints: *Model C3320i *Staple 1StapleAuto(Left)
*UIConstraints: *Model C3320i *Staple 1StapleZeroLeft
*UIConstraints: *Model C3320i *Staple 1StapleAuto(Right)
*UIConstraints: *Model C3320i *Staple 1StapleZeroRight
*UIConstraints: *Model C3320i *Staple 2Staples
*UIConstraints: *Model C3320i *Punch 2holes
*UIConstraints: *Model C3320i *Punch 3holes
*UIConstraints: *Model C3320i *Punch 4holes
*UIConstraints: *Model C3320i *Fold Stitch
*UIConstraints: *Model C3320i *Fold HalfFold
*UIConstraints: *Model C3320i *Fold TriFold
*UIConstraints: *Model C3320i *Fold ZFold1
*UIConstraints: *Model C3320i *Fold ZFold2
*UIConstraints: *Model C3320i *FrontCoverTray Tray3
*UIConstraints: *Model C3320i *FrontCoverTray Tray4
*UIConstraints: *Model C3320i *FrontCoverTray LCT
*UIConstraints: *Model C3320i *BackCoverTray Tray3
*UIConstraints: *Model C3320i *BackCoverTray Tray4
*UIConstraints: *Model C3320i *BackCoverTray LCT
*UIConstraints: *Model C3320i *PIFrontCover PITray1
*UIConstraints: *Model C3320i *PIFrontCover PITray2
*UIConstraints: *Model C3320i *PIBackCover PITray1
*UIConstraints: *Model C3320i *PIBackCover PITray2
*UIConstraints: *Model C3320i *TransparencyInterleave Blank
*UIConstraints: *Model C3320i *OHPOpTray Tray1
*UIConstraints: *Model C3320i *OHPOpTray Tray2
*UIConstraints: *Model C3320i *OHPOpTray Tray3
*UIConstraints: *Model C3320i *OHPOpTray Tray4
*UIConstraints: *Model C3320i *OHPOpTray LCT
*UIConstraints: *Model C3320i *PaperSources LU207
*UIConstraints: *Model C3320i *PaperSources LU302
*UIConstraints: *Model C3320i *PaperSources LU205
*UIConstraints: *Model C3320i *PaperSources LU303
*UIConstraints: *Model C3320i *PaperSources PC116
*UIConstraints: *Model C3320i *PaperSources PC116+LU207
*UIConstraints: *Model C3320i *PaperSources PC116+LU302
*UIConstraints: *Model C3320i *PaperSources PC118
*UIConstraints: *Model C3320i *PaperSources PC216
*UIConstraints: *Model C3320i *PaperSources PC216+LU207
*UIConstraints: *Model C3320i *PaperSources PC216+LU302
*UIConstraints: *Model C3320i *PaperSources PC218
*UIConstraints: *Model C3320i *PaperSources PC416
*UIConstraints: *Model C3320i *PaperSources PC416+LU207
*UIConstraints: *Model C3320i *PaperSources PC416+LU302
*UIConstraints: *Model C3320i *PaperSources PC417
*UIConstraints: *Model C3320i *PaperSources PC417+LU207
*UIConstraints: *Model C3320i *PaperSources PC417+LU302
*UIConstraints: *Model C3320i *PaperSources PC418
*UIConstraints: *Model C3320i *PaperSources PFP13T23
*UIConstraints: *Model C3320i *PaperSources PFP13T234
*UIConstraints: *Model C3320i *Finisher FS533
*UIConstraints: *Model C3320i *Finisher FS539
*UIConstraints: *Model C3320i *Finisher JS506
*UIConstraints: *Model C3320i *Finisher JS508
*UIConstraints: *Model C3320i *Finisher FS540
*UIConstraints: *Model C3320i *Finisher FS540JS602
*UIConstraints: *Model C3320i *Finisher FS542
*UIConstraints: *Model C3320i *KOPunch PK519
*UIConstraints: *Model C3320i *KOPunch PK519-3
*UIConstraints: *Model C3320i *KOPunch PK519-4
*UIConstraints: *Model C3320i *KOPunch PK519-SWE4
*UIConstraints: *Model C3320i *KOPunch PK524
*UIConstraints: *Model C3320i *KOPunch PK524-3
*UIConstraints: *Model C3320i *KOPunch PK524-4
*UIConstraints: *Model C3320i *KOPunch PK524-SWE4
*UIConstraints: *Model C3320i *KOPunch PK526
*UIConstraints: *Model C3320i *KOPunch PK526-3
*UIConstraints: *Model C3320i *KOPunch PK526-4
*UIConstraints: *Model C3320i *KOPunch PK526-SWE4
*UIConstraints: *Model C3320i *KOPunch PK527
*UIConstraints: *Model C3320i *KOPunch PK527-3
*UIConstraints: *Model C3320i *KOPunch PK527-4
*UIConstraints: *Model C3320i *KOPunch PK527-SWE4
*UIConstraints: *Model C3320i *ZFoldUnit ZU609
*UIConstraints: *Model C3320i *PostInserter PI507
*UIConstraints: *Model C3320i *SaddleUnit SD511
*UIConstraints: *Model C3320i *SaddleUnit SD512
*UIConstraints: *Model C3320i *PrinterHDD HDD

*%
*% === Font Information  ============
*%
*DefaultFont: Courier
*Font AlbertusMT-Italic:  Standard "(001.000)" Standard ROM
*Font AlbertusMT-Light:  Standard "(001.000)" Standard ROM
*Font AlbertusMT:  Standard "(001.000)" Standard ROM
*Font AntiqueOlive-Bold:  Standard "(501.009)" ExtendedRoman ROM
*Font AntiqueOlive-Compact:  Standard "(501.008)" ExtendedRoman ROM
*Font AntiqueOlive-Italic:  Standard "(501.010)" ExtendedRoman ROM
*Font AntiqueOlive-Roman:  Standard "(501.008)" ExtendedRoman ROM
*Font Apple-Chancery:  Standard "(001.001)" ExtendedRoman ROM
*Font Arial-BoldItalicMT:  Standard "(501.009)" ExtendedRoman ROM
*Font Arial-BoldMT:  Standard "(501.009)" ExtendedRoman ROM
*Font Arial-ItalicMT:  Standard "(501.012)" ExtendedRoman ROM
*Font ArialMT:  Standard "(501.009)" ExtendedRoman ROM
*Font AvantGarde-Book:  Standard "(501.009)" ExtendedRoman ROM
*Font AvantGarde-BookOblique:  Standard "(501.009)" ExtendedRoman ROM
*Font AvantGarde-Demi:  Standard "(501.010)" ExtendedRoman ROM
*Font AvantGarde-DemiOblique:  Standard "(501.010)" ExtendedRoman ROM
*Font Bodoni-Bold:  Standard "(501.006)" ExtendedRoman ROM
*Font Bodoni-BoldItalic:  Standard "(501.007)" ExtendedRoman ROM
*Font Bodoni-Italic:  Standard "(501.007)" ExtendedRoman ROM
*Font Bodoni-Poster:  Standard "(501.009)" ExtendedRoman ROM
*Font Bodoni-PosterCompressed:  Standard "(501.007)" ExtendedRoman ROM
*Font Bodoni:  Standard "(501.008)" ExtendedRoman ROM
*Font Bookman-Demi:  Standard "(501.007)" ExtendedRoman ROM
*Font Bookman-DemiItalic:  Standard "(501.008)" ExtendedRoman ROM
*Font Bookman-Light:  Standard "(501.006)" ExtendedRoman ROM
*Font Bookman-LightItalic:  Standard "(501.007)" ExtendedRoman ROM
*Font Chicago:  Standard "(501.011)" ExtendedRoman ROM
*Font Clarendon-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font Clarendon-Light:  Standard "(501.009)" ExtendedRoman ROM
*Font Clarendon:  Standard "(501.009)" ExtendedRoman ROM
*Font CooperBlack-Italic:  Standard "(001.003)" Standard ROM
*Font CooperBlack:  Standard "(001.003)" Standard ROM
*Font Copperplate-ThirtyThreeBC:  Standard "(001.002)" Standard ROM
*Font Copperplate-ThirtyTwoBC:  Standard "(001.002)" Standard ROM
*Font Coronet-Regular:  Standard "(001.000)" ExtendedRoman ROM
*Font Courier-Bold:  Standard "(501.010)" ExtendedRoman ROM
*Font Courier-BoldOblique:  Standard "(501.010)" ExtendedRoman ROM
*Font Courier-Oblique:  Standard "(501.010)" ExtendedRoman ROM
*Font Courier:  Standard "(501.010)" ExtendedRoman ROM
*Font Eurostile-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font Eurostile-BoldExtendedTwo:  Standard "(501.008)" ExtendedRoman ROM
*Font Eurostile-ExtendedTwo:  Standard "(501.010)" ExtendedRoman ROM
*Font Eurostile:  Standard "(501.008)" ExtendedRoman ROM
*Font Geneva:  Standard "(501.007)" ExtendedRoman ROM
*Font GillSans-Bold:  Standard "(501.007)" ExtendedRoman ROM
*Font GillSans-BoldCondensed:  Standard "(501.006)" ExtendedRoman ROM
*Font GillSans-BoldItalic:  Standard "(501.008)" ExtendedRoman ROM
*Font GillSans-Condensed:  Standard "(501.007)" ExtendedRoman ROM
*Font GillSans-ExtraBold:  Standard "(501.008)" ExtendedRoman ROM
*Font GillSans-Italic:  Standard "(501.008)" ExtendedRoman ROM
*Font GillSans-Light:  Standard "(501.009)" ExtendedRoman ROM
*Font GillSans-LightItalic:  Standard "(501.009)" ExtendedRoman ROM
*Font GillSans:  Standard "(501.009)" ExtendedRoman ROM
*Font Goudy-Bold:  Standard "(001.002)" Standard ROM
*Font Goudy-BoldItalic:  Standard "(001.002)" Standard ROM
*Font Goudy-ExtraBold:  Standard "(001.001)" Standard ROM
*Font Goudy-Italic:  Standard "(001.002)" Standard ROM
*Font Goudy:  Standard "(001.003)" Standard ROM
*Font Helvetica-Bold:  Standard "(501.010)" ExtendedRoman ROM
*Font Helvetica-BoldOblique:  Standard "(501.010)" ExtendedRoman ROM
*Font Helvetica-Condensed-Bold:  Standard "(501.009)" ExtendedRoman ROM
*Font Helvetica-Condensed-BoldObl:  Standard "(501.009)" ExtendedRoman ROM
*Font Helvetica-Condensed-Oblique:  Standard "(501.010)" ExtendedRoman ROM
*Font Helvetica-Condensed:  Standard "(501.010)" ExtendedRoman ROM
*Font Helvetica-Narrow-Bold:  Standard "(501.010)" ExtendedRoman ROM
*Font Helvetica-Narrow-BoldOblique:  Standard "(501.010)" ExtendedRoman ROM
*Font Helvetica-Narrow-Oblique:  Standard "(501.008)" ExtendedRoman ROM
*Font Helvetica-Narrow:  Standard "(501.008)" ExtendedRoman ROM
*Font Helvetica-Oblique:  Standard "(501.008)" ExtendedRoman ROM
*Font Helvetica:  Standard "(501.008)" ExtendedRoman ROM
*Font HoeflerText-Black:  Standard "(501.008)" ExtendedRoman ROM
*Font HoeflerText-BlackItalic:  Standard "(501.009)" ExtendedRoman ROM
*Font HoeflerText-Italic:  Standard "(501.010)" ExtendedRoman ROM
*Font HoeflerText-Ornaments:  Special "(001.001)" Special ROM
*Font HoeflerText-Regular:  Standard "(501.009)" ExtendedRoman ROM
*Font JoannaMT-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font JoannaMT-BoldItalic:  Standard "(501.008)" ExtendedRoman ROM
*Font JoannaMT-Italic:  Standard "(501.008)" ExtendedRoman ROM
*Font JoannaMT:  Standard "(501.009)" ExtendedRoman ROM
*Font LetterGothic-Bold:  Standard "(501.010)" ExtendedRoman ROM
*Font LetterGothic-BoldSlanted:  Standard "(501.010)" ExtendedRoman ROM
*Font LetterGothic-Slanted:  Standard "(501.010)" ExtendedRoman ROM
*Font LetterGothic:  Standard "(501.009)" ExtendedRoman ROM
*Font LubalinGraph-Book:  Standard "(501.009)" ExtendedRoman ROM
*Font LubalinGraph-BookOblique:  Standard "(501.009)" ExtendedRoman ROM
*Font LubalinGraph-Demi:  Standard "(501.009)" ExtendedRoman ROM
*Font LubalinGraph-DemiOblique:  Standard "(501.009)" ExtendedRoman ROM
*Font Marigold:  Standard "(001.000)" Standard ROM
*Font MonaLisa-Recut:  Standard "(001.000)" Standard ROM
*Font Monaco:  Standard "(501.012)" ExtendedRoman ROM
*Font NewCenturySchlbk-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font NewCenturySchlbk-BoldItalic:  Standard "(501.009)" ExtendedRoman ROM
*Font NewCenturySchlbk-Italic:  Standard "(501.011)" ExtendedRoman ROM
*Font NewCenturySchlbk-Roman:  Standard "(501.008)" ExtendedRoman ROM
*Font NewYork:  Standard "(501.013)" ExtendedRoman ROM
*Font Optima-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font Optima-BoldItalic:  Standard "(501.009)" ExtendedRoman ROM
*Font Optima-Italic:  Standard "(501.010)" ExtendedRoman ROM
*Font Optima:  Standard "(501.010)" ExtendedRoman ROM
*Font Oxford:  Standard "(001.000)" Standard ROM
*Font Palatino-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font Palatino-BoldItalic:  Standard "(501.007)" ExtendedRoman ROM
*Font Palatino-Italic:  Standard "(501.008)" ExtendedRoman ROM
*Font Palatino-Roman:  Standard "(501.006)" ExtendedRoman ROM
*Font StempelGaramond-Bold:  Standard "(501.007)" ExtendedRoman ROM
*Font StempelGaramond-BoldItalic:  Standard "(501.012)" ExtendedRoman ROM
*Font StempelGaramond-Italic:  Standard "(501.009)" ExtendedRoman ROM
*Font StempelGaramond-Roman:  Standard "(501.011)" ExtendedRoman ROM
*Font Symbol:  Special "(001.008)" Special ROM
*Font Times-Bold:  Standard "(501.009)" ExtendedRoman ROM
*Font Times-BoldItalic:  Standard "(501.009)" ExtendedRoman ROM
*Font Times-Italic:  Standard "(501.010)" ExtendedRoman ROM
*Font Times-Roman:  Standard "(501.010)" ExtendedRoman ROM
*Font TimesNewRomanPS-BoldItalicMT:  Standard "(501.011)" ExtendedRoman ROM
*Font TimesNewRomanPS-BoldMT:  Standard "(501.009)" ExtendedRoman ROM
*Font TimesNewRomanPS-ItalicMT:  Standard "(501.011)" ExtendedRoman ROM
*Font TimesNewRomanPSMT:  Standard "(501.010)" ExtendedRoman ROM
*Font Univers-Bold:  Standard "(501.008)" ExtendedRoman ROM
*Font Univers-BoldExt:  Standard "(501.010)" ExtendedRoman ROM
*Font Univers-BoldExtObl:  Standard "(501.010)" ExtendedRoman ROM
*Font Univers-BoldOblique:  Standard "(501.008)" ExtendedRoman ROM
*Font Univers-Condensed:  Standard "(501.011)" ExtendedRoman ROM
*Font Univers-CondensedBold:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers-CondensedBoldOblique:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers-CondensedOblique:  Standard "(501.011)" ExtendedRoman ROM
*Font Univers-Extended:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers-ExtendedObl:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers-Light:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers-LightOblique:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers-Oblique:  Standard "(501.009)" ExtendedRoman ROM
*Font Univers:  Standard "(501.009)" ExtendedRoman ROM
*Font Wingdings-Regular:  Special "(001.001)" Special ROM
*Font ZapfChancery-MediumItalic:  Standard "(002.000)" ExtendedRoman ROM
*Font ZapfDingbats:  Special "(001.005S)" Special ROM

*%
*% === Begin Interpreter Footer Common  ===========
*%

*?FontQuery: "
 save
    { count 1 gt
       { exch dup 127 string cvs (/) print print (:) print
        /Font resourcestatus {pop pop (Yes)} {(No)} ifelse =
       } { exit } ifelse
    } bind loop
    (*) = flush
 restore"
*End
*?FontList: "
 save (*) {cvn ==} 128 string /Font resourceforall
 (*) = flush restore"
*End

*%
*% === Begin Emepror Footer Functions  ============
*%

*%
*% === Begin Custom Footer Function  =============
*%

*% === Change Log =============================

*% end of Printer Description file
*% English localization
*en.Translation ModelName/KONICA MINOLTA C751iSeriesPS/P: ""
*en.Translation PaperSources/Paper Source Unit: ""
*en.PaperSources None/None: ""
*en.PaperSources LU207/LU-207: ""
*en.PaperSources LU302/LU-302: ""
*en.PaperSources LU205/LU-205: ""
*en.PaperSources LU303/LU-303: ""
*en.PaperSources PC116/PC-116: ""
*en.PaperSources PC116+LU207/PC-116+LU-207: ""
*en.PaperSources PC116+LU302/PC-116+LU-302: ""
*en.PaperSources PC118/PC-118: ""
*en.PaperSources PC216/PC-216: ""
*en.PaperSources PC216+LU207/PC-216+LU-207: ""
*en.PaperSources PC216+LU302/PC-216+LU-302: ""
*en.PaperSources PC218/PC-218: ""
*en.PaperSources PC416/PC-416: ""
*en.PaperSources PC416+LU207/PC-416+LU-207: ""
*en.PaperSources PC416+LU302/PC-416+LU-302: ""
*en.PaperSources PC417/PC-417: ""
*en.PaperSources PC417+LU207/PC-417+LU-207: ""
*en.PaperSources PC417+LU302/PC-417+LU-302: ""
*en.PaperSources PC418/PC-418: ""
*en.PaperSources PFP13T2/Tray2: ""
*en.PaperSources PFP13T23/Tray2+3: ""
*en.PaperSources PFP13T234/Tray2+3+4: ""

*en.Translation Finisher/Finisher: ""
*en.Finisher None/None: ""
*en.Finisher FS533/FS-533: ""
*en.Finisher FS539/FS-539: ""
*en.Finisher JS506/JS-506: ""
*en.Finisher JS508/JS-508: ""
*en.Finisher FS540/FS-540: ""
*en.Finisher FS540JS602/FS-540+JS-602: ""
*en.Finisher FS542/FS-542: ""

*en.Translation KOPunch/Punch Unit: ""
*en.KOPunch None/None: ""
*en.KOPunch PK519/PK-519 (2-Hole): ""
*en.KOPunch PK519-3/PK-519 (2/3-Hole): ""
*en.KOPunch PK519-4/PK-519 (2/4-Hole): ""
*en.KOPunch PK519-SWE4/PK-519 (SWE 4-Hole): ""
*en.KOPunch PK524/PK-524 (2-Hole): ""
*en.KOPunch PK524-3/PK-524 (2/3-Hole): ""
*en.KOPunch PK524-4/PK-524 (2/4-Hole): ""
*en.KOPunch PK524-SWE4/PK-524 (SWE 4-Hole): ""
*en.KOPunch PK526/PK-526 (2-Hole): ""
*en.KOPunch PK526-3/PK-526 (2/3-Hole): ""
*en.KOPunch PK526-4/PK-526 (2/4-Hole): ""
*en.KOPunch PK526-SWE4/PK-526 (SWE 4-Hole): ""
*en.KOPunch PK527/PK-527 (2-Hole): ""
*en.KOPunch PK527-3/PK-527 (2/3-Hole): ""
*en.KOPunch PK527-4/PK-527 (2/4-Hole): ""
*en.KOPunch PK527-SWE4/PK-527 (SWE 4-Hole): ""

*en.Translation ZFoldUnit/Z-Fold Unit: ""
*en.ZFoldUnit None/None: ""
*en.ZFoldUnit ZU609/ZU-609: ""

*en.Translation PostInserter/Post Inserter: ""
*en.PostInserter None/None: ""
*en.PostInserter PI507/PI-507: ""

*en.Translation SaddleUnit/Saddle Kit: ""
*en.SaddleUnit None/None: ""
*en.SaddleUnit SD511/SD-511: ""
*en.SaddleUnit SD512/SD-512: ""

*en.Translation PrinterHDD/Storage: ""
*en.PrinterHDD None/None: ""
*en.PrinterHDD HDD/Installed: ""

*en.Translation Model/Model: ""
*en.Model C751i/C751i: ""
*en.Model C651i/C651i: ""
*en.Model C551i/C551i: ""
*en.Model C451i/C451i: ""
*en.Model C361i/C361i: ""
*en.Model C301i/C301i: ""
*en.Model C251i/C251i: ""
*en.Model C4051i/C4051i: ""
*en.Model C3351i/C3351i: ""
*en.Model C4001i/C4001i: ""
*en.Model C3301i/C3301i: ""
*en.Model C3321i/C3321i: ""
*en.Model C750i/C750i: ""
*en.Model C650i/C650i: ""
*en.Model C550i/C550i: ""
*en.Model C450i/C450i: ""
*en.Model C360i/C360i: ""
*en.Model C300i/C300i: ""
*en.Model C250i/C250i: ""
*en.Model C287i/C287i: ""
*en.Model C257i/C257i: ""
*en.Model C227i/C227i: ""
*en.Model C286i/C286i: ""
*en.Model C266i/C266i: ""
*en.Model C226i/C226i: ""
*en.Model C4050i/C4050i: ""
*en.Model C3350i/C3350i: ""
*en.Model C4000i/C4000i: ""
*en.Model C3300i/C3300i: ""
*en.Model C3320i/C3320i: ""

*%
*% === Begin Print Quality & Effects ============
*%

*en.Translation Collate/Collate: ""
*en.Collate False/Off: ""
*en.Collate True/On: ""

*en.Translation InputSlot/Paper Tray: ""
*en.InputSlot AutoSelect/Auto: ""
*en.InputSlot Tray1/Tray1: ""
*en.InputSlot Tray2/Tray2: ""
*en.InputSlot Tray3/Tray3: ""
*en.InputSlot Tray4/Tray4: ""
*en.InputSlot LCT/LCT: ""
*en.InputSlot ManualFeed/Bypass Tray: ""

*en.Translation MediaType/Paper Type: ""
*en.MediaType Plain/Plain Paper: ""
*en.MediaType Plain(2nd)/Plain Paper(Side2): ""
*en.MediaType PlainPlus/Plain Paper+: ""
*en.MediaType PlainPlus(2nd)/Plain Paper+(Side2): ""
*en.MediaType Thick1/Thick 1: ""
*en.MediaType Thick1(2nd)/Thick 1(Side2): ""
*en.MediaType Thick1Plus/Thick 1+: ""
*en.MediaType Thick1Plus(2nd)/Thick 1+(Side2): ""
*en.MediaType Thick2/Thick 2: ""
*en.MediaType Thick2(2nd)/Thick 2(Side2): ""
*en.MediaType Thick3/Thick 3: ""
*en.MediaType Thick3(2nd)/Thick 3(Side2): ""
*en.MediaType Thick4/Thick 4: ""
*en.MediaType Thick4(2nd)/Thick 4(Side2): ""
*en.MediaType Thin/Thin Paper: ""
*en.MediaType Envelope/Envelope: ""
*en.MediaType Transparency/Transparency: ""
*en.MediaType Color/Colored Paper: ""
*en.MediaType SingleSidedOnly/Single Side Only: ""
*en.MediaType TAB/TAB: ""
*en.MediaType Letterhead/Letterhead: ""
*en.MediaType Special/Special Paper: ""
*en.MediaType Recycled/Recycled: ""
*en.MediaType Recycled(2nd)/Recycled(Side2): ""
*en.MediaType Labels/Label: ""
*en.MediaType Postcard/Postcard: ""
*en.MediaType Glossy/Glossy 1: ""
*en.MediaType GlossyPlus/Glossy 1+: ""
*en.MediaType Glossy2/Glossy 2: ""
*en.MediaType User1/User1(Plain Paper): ""
*en.MediaType User1(2nd)/User1(Plain. Side2): ""
*en.MediaType User2_1/User2(Plain Paper): ""
*en.MediaType User2(2nd)_1/User2(Plain. Side2): ""
*en.MediaType User2/User2(Plain Paper+): ""
*en.MediaType User2(2nd)/User2(Plain.+ Side2): ""
*en.MediaType User3/User3(Thick 1): ""
*en.MediaType User3(2nd)/User3(Thick 1 Side2): ""
*en.MediaType User4/User4(Thick 1+): ""
*en.MediaType User4(2nd)/User4(Thick 1+ Side2): ""
*en.MediaType User5/User5(Thick 2): ""
*en.MediaType User5(2nd)/User5(Thick 2 Side2): ""
*en.MediaType User6/User6(Thick 3): ""
*en.MediaType User6(2nd)/User6(Thick 3 Side2): ""
*en.MediaType User7/User7: ""
*en.MediaType User7(2nd)/User7(Side2): ""
*en.MediaType PrinterDefault/Not Specified: ""
*en.MediaType UserCustomType1/<3C>Custom 1<3E>: ""
*en.MediaType UserCustomType1(2nd)/<3C>Custom 1<3E>(Side2): ""
*en.MediaType UserCustomType2/<3C>Custom 2<3E>: ""
*en.MediaType UserCustomType2(2nd)/<3C>Custom 2<3E>(Side2): ""
*en.MediaType UserCustomType3/<3C>Custom 3<3E>: ""
*en.MediaType UserCustomType3(2nd)/<3C>Custom 3<3E>(Side2): ""
*en.MediaType UserCustomType4/<3C>Custom 4<3E>: ""
*en.MediaType UserCustomType4(2nd)/<3C>Custom 4<3E>(Side2): ""
*en.MediaType UserCustomType5/<3C>Custom 5<3E>: ""
*en.MediaType UserCustomType5(2nd)/<3C>Custom 5<3E>(Side2): ""
*en.MediaType UserCustomType6/<3C>Custom 6<3E>: ""
*en.MediaType UserCustomType6(2nd)/<3C>Custom 6<3E>(Side2): ""
*en.MediaType UserCustomType7/<3C>Custom 7<3E>: ""
*en.MediaType UserCustomType7(2nd)/<3C>Custom 7<3E>(Side2): ""
*en.MediaType UserCustomType8/<3C>Custom 8<3E>: ""
*en.MediaType UserCustomType8(2nd)/<3C>Custom 8<3E>(Side2): ""
*en.MediaType UserCustomType9/<3C>Custom 9<3E>: ""
*en.MediaType UserCustomType9(2nd)/<3C>Custom 9<3E>(Side2): ""
*en.MediaType UserCustomType10/<3C>Custom 10<3E>: ""
*en.MediaType UserCustomType10(2nd)/<3C>Custom 10<3E>(Side2): ""
*en.MediaType UserCustomType11/<3C>Custom 11<3E>: ""
*en.MediaType UserCustomType11(2nd)/<3C>Custom 11<3E>(Side2): ""
*en.MediaType UserCustomType12/<3C>Custom 12<3E>: ""
*en.MediaType UserCustomType12(2nd)/<3C>Custom 12<3E>(Side2): ""
*en.MediaType UserCustomType13/<3C>Custom 13<3E>: ""
*en.MediaType UserCustomType13(2nd)/<3C>Custom 13<3E>(Side2): ""
*en.MediaType UserCustomType14/<3C>Custom 14<3E>: ""
*en.MediaType UserCustomType14(2nd)/<3C>Custom 14<3E>(Side2): ""
*en.MediaType UserCustomType15/<3C>Custom 15<3E>: ""
*en.MediaType UserCustomType15(2nd)/<3C>Custom 15<3E>(Side2): ""
*en.MediaType UserCustomType16/<3C>Custom 16<3E>: ""
*en.MediaType UserCustomType16(2nd)/<3C>Custom 16<3E>(Side2): ""
*en.MediaType UserCustomType17/<3C>Custom 17<3E>: ""
*en.MediaType UserCustomType17(2nd)/<3C>Custom 17<3E>(Side2): ""
*en.MediaType UserCustomType18/<3C>Custom 18<3E>: ""
*en.MediaType UserCustomType18(2nd)/<3C>Custom 18<3E>(Side2): ""
*en.MediaType UserCustomType19/<3C>Custom 19<3E>: ""
*en.MediaType UserCustomType19(2nd)/<3C>Custom 19<3E>(Side2): ""

*en.Translation PageSize/Paper Size: ""
*en.PageSize A3/A3: ""
*en.PageSize A4/A4: ""
*en.PageSize A5/A5: ""
*en.PageSize A6/A6: ""
*en.PageSize B4/B4: ""
*en.PageSize B5/B5: ""
*en.PageSize B6/B6: ""
*en.PageSize SRA3/SRA3: ""
*en.PageSize 220mmx330mm/220mmx330mm: ""
*en.PageSize 12x18/12x18: ""
*en.PageSize Tabloid/11x17: ""
*en.PageSize Legal/8 1/2x14: ""
*en.PageSize Letter/8 1/2x11: ""
*en.PageSize LetterPlus/8 1/2x12 11/16: ""
*en.PageSize Statement/5 1/2x8 1/2: ""
*en.PageSize 8x13/8x13: ""
*en.PageSize 8.5x13/8 1/2x13: ""
*en.PageSize 8.5x13.5/8 1/2x13 1/2: ""
*en.PageSize 8.25x13/8 1/4x13: ""
*en.PageSize 8.125x13.25/8 1/8x13 1/4: ""
*en.PageSize 8x10/8x10: ""
*en.PageSize 8x10.5/8x10 1/2: ""
*en.PageSize Executive/7 1/4x10 1/2: ""
*en.PageSize 8K/8K: ""
*en.PageSize 16K/16K: ""
*en.PageSize EnvISOB5/Envelope B5: ""
*en.PageSize EnvC4/Envelope C4: ""
*en.PageSize EnvC5/Envelope C5: ""
*en.PageSize EnvC6/Envelope C6: ""
*en.PageSize EnvChou3/Envelope Nagagata3: ""
*en.PageSize EnvChou4/Envelope Nagagata4: ""
*en.PageSize EnvYou3/Envelope Yougata3: ""
*en.PageSize EnvYou4/Envelope Yougata4: ""
*en.PageSize EnvKaku1/Envelope Kakugata1: ""
*en.PageSize EnvKaku2/Envelope Kakugata2: ""
*en.PageSize EnvKaku3/Envelope Kakugata3: ""
*en.PageSize EnvDL/Envelope DL: ""
*en.PageSize EnvMonarch/Envelope Monarch: ""
*en.PageSize Env10/Envelope Com10: ""
*en.PageSize JapanesePostCard/Postcard: ""
*en.PageSize 4x6_PostCard/4x6 Postcard: ""
*en.PageSize DoublePostcardRotated/Double Postcard: ""
*en.PageSize A3Extra/A3W: ""
*en.PageSize A4Extra/A4W: ""
*en.PageSize A5Extra/A5W: ""
*en.PageSize B4Extra/B4W: ""
*en.PageSize B5Extra/B5W: ""
*en.PageSize TabloidExtra/11x17W: ""
*en.PageSize LetterExtra/8 1/2x11W: ""
*en.PageSize StatementExtra/5 1/2x8 1/2W: ""
*en.PageSize LetterTab-F/8 1/2x11 Tab: ""
*en.PageSize A4Tab-F/A4 Tab: ""

*%
*% === Begin Functions Section ============
*%

*en.Translation Offset/Offset: ""
*en.Offset False/Off: ""
*en.Offset True/On: ""

*en.Translation OutputBin/Output Tray: ""
*en.OutputBin Default/Default: ""
*en.OutputBin Tray1/Tray1: ""
*en.OutputBin Tray2/Tray2: ""
*en.OutputBin Tray3/Tray3: ""
*en.OutputBin Tray4/Tray4: ""

*en.Translation Binding/Binding Position: ""
*en.Binding LeftBinding/Left Bind: ""
*en.Binding TopBinding/Top Bind: ""
*en.Binding RightBinding/Right Bind: ""

*en.Translation KMDuplex/Print Type: ""
*en.KMDuplex 1Sided/1-Sided: ""
*en.KMDuplex 2Sided/2-Sided: ""

*en.Translation Combination/Combination: ""
*en.Combination None/Off: ""
*en.Combination Booklet/Booklet: ""

*en.Translation Staple/Staple: ""
*en.Staple None/Off: ""
*en.Staple 1StapleAuto(Left)/Left Corner (Auto): ""
*en.Staple 1StapleZeroLeft/Left Corner (0 degrees): ""
*en.Staple 1StapleAuto(Right)/Right Corner (Auto): ""
*en.Staple 1StapleZeroRight/Right Corner (0 degrees): ""
*en.Staple 2Staples/2 Position: ""

*en.Translation Punch/Punch: ""
*en.Punch None/Off: ""
*en.Punch 2holes/2-Hole: ""
*en.Punch 3holes/3-Hole: ""
*en.Punch 4holes/4-Hole: ""

*en.Translation Fold/Fold: ""
*en.Fold None/Off: ""
*en.Fold Stitch/Center Staple and Fold: ""
*en.Fold HalfFold/Half-Fold: ""
*en.Fold TriFold/Tri-Fold: ""
*en.Fold ZFold1/Z-Fold(A3,B4,11x17,8K): ""
*en.Fold ZFold2/Z-Fold(8 1/2x14): ""

*en.Translation FrontCoverPage/Front Cover: ""
*en.FrontCoverPage None/Off: ""
*en.FrontCoverPage Printed/Print: ""
*en.FrontCoverPage Blank/Blank: ""

*en.Translation FrontCoverTray/Front Cover Tray: ""
*en.FrontCoverTray None/Off: ""
*en.FrontCoverTray Tray1/Tray1: ""
*en.FrontCoverTray Tray2/Tray2: ""
*en.FrontCoverTray Tray3/Tray3: ""
*en.FrontCoverTray Tray4/Tray4: ""
*en.FrontCoverTray LCT/LCT: ""
*en.FrontCoverTray BypassTray/Bypass Tray: ""

*en.Translation BackCoverPage/Back Cover: ""
*en.BackCoverPage None/Off: ""
*en.BackCoverPage Printed/Print: ""
*en.BackCoverPage Blank/Blank: ""

*en.Translation BackCoverTray/Back Cover Tray: ""
*en.BackCoverTray None/Off: ""
*en.BackCoverTray Tray1/Tray1: ""
*en.BackCoverTray Tray2/Tray2: ""
*en.BackCoverTray Tray3/Tray3: ""
*en.BackCoverTray Tray4/Tray4: ""
*en.BackCoverTray LCT/LCT: ""
*en.BackCoverTray BypassTray/Bypass Tray: ""

*en.Translation PIFrontCover/Front Cover from Post Inserter: ""
*en.PIFrontCover None/Off: ""
*en.PIFrontCover PITray1/PI Tray 1: ""
*en.PIFrontCover PITray2/PI Tray 2: ""

*en.Translation PIBackCover/Back Cover from Post Inserter: ""
*en.PIBackCover None/Off: ""
*en.PIBackCover PITray1/PI Tray 1: ""
*en.PIBackCover PITray2/PI Tray 2: ""

*en.Translation TransparencyInterleave/Transparency Interleave: ""
*en.TransparencyInterleave None/Off: ""
*en.TransparencyInterleave Blank/Blank: ""

*en.Translation OHPOpTray/Interleave Tray: ""
*en.OHPOpTray None/Off: ""
*en.OHPOpTray Tray1/Tray1: ""
*en.OHPOpTray Tray2/Tray2: ""
*en.OHPOpTray Tray3/Tray3: ""
*en.OHPOpTray Tray4/Tray4: ""
*en.OHPOpTray LCT/LCT: ""

*en.Translation WaitMode/Output Method: ""
*en.WaitMode None/Print: ""
*en.WaitMode ProofMode/Proof Print: ""

*en.Translation SelectColor/Select Color: ""
*en.SelectColor Auto/Auto Color: ""
*en.SelectColor Color/Full Color: ""
*en.SelectColor Grayscale/Gray Scale: ""

*en.Translation GlossyMode/Glossy Mode: ""
*en.GlossyMode False/Off: ""
*en.GlossyMode True/On: ""

*en.Translation OriginalImageType/Image Quality Setting: ""
*en.OriginalImageType Document-Photo/Document/Photo: ""
*en.OriginalImageType Document/Document: ""
*en.OriginalImageType Photo/Photo: ""
*en.OriginalImageType CAD/CAD: ""

*en.Translation AutoTrapping/Auto Trapping: ""
*en.AutoTrapping False/Off: ""
*en.AutoTrapping True/On: ""

*en.Translation BlackOverPrint/Black Over Print: ""
*en.BlackOverPrint Off/Off: ""
*en.BlackOverPrint Text/Text: ""
*en.BlackOverPrint TextGraphic/Text/Figure: ""

*en.Translation TextColorMatching/Color Matching (Text): ""
*en.TextColorMatching Auto/Auto: ""
*en.TextColorMatching ColorEmphasis/Color Highlight(Vivid): ""
*en.TextColorMatching Sharp/Color Priority(Sharp): ""
*en.TextColorMatching Colorimetric/Colorimetric(Natural): ""

*en.Translation TextPureBlack/Pure Black (Text): ""
*en.TextPureBlack Auto/Auto: ""
*en.TextPureBlack Off/Off: ""
*en.TextPureBlack On/On: ""

*en.Translation TextScreen/Screen (Text): ""
*en.TextScreen Auto/Auto: ""
*en.TextScreen Gradation/Gradation: ""
*en.TextScreen Resolution/Resolution: ""
*en.TextScreen HighResolution/High Resolution: ""

*en.Translation PhotoColorMatching/Color Matching (Photo): ""
*en.PhotoColorMatching Auto/Auto: ""
*en.PhotoColorMatching ColorEmphasis/Color Highlight(Vivid): ""
*en.PhotoColorMatching Sharp/Color Priority(Sharp): ""
*en.PhotoColorMatching Colorimetric/Colorimetric(Natural): ""

*en.Translation PhotoPureBlack/Pure Black (Photo): ""
*en.PhotoPureBlack Auto/Auto: ""
*en.PhotoPureBlack Off/Off: ""
*en.PhotoPureBlack On/On: ""

*en.Translation PhotoScreen/Screen (Photo): ""
*en.PhotoScreen Auto/Auto: ""
*en.PhotoScreen Gradation/Gradation: ""
*en.PhotoScreen Resolution/Resolution: ""
*en.PhotoScreen HighResolution/High Resolution: ""

*en.Translation PhotoSmoothing/Smoothing (Photo): ""
*en.PhotoSmoothing Auto/Auto: ""
*en.PhotoSmoothing None/Off: ""
*en.PhotoSmoothing Dark/Dark: ""
*en.PhotoSmoothing Medium/Medium: ""
*en.PhotoSmoothing Light/Light: ""

*en.Translation GraphicColorMatching/Color Matching (Graphic): ""
*en.GraphicColorMatching Auto/Auto: ""
*en.GraphicColorMatching ColorEmphasis/Color Highlight(Vivid): ""
*en.GraphicColorMatching Sharp/Color Priority(Sharp): ""
*en.GraphicColorMatching Colorimetric/Colorimetric(Natural): ""

*en.Translation GraphicPureBlack/Pure Black (Graphic): ""
*en.GraphicPureBlack Auto/Auto: ""
*en.GraphicPureBlack Off/Off: ""
*en.GraphicPureBlack On/On: ""

*en.Translation GraphicScreen/Screen (Graphic): ""
*en.GraphicScreen Auto/Auto: ""
*en.GraphicScreen Gradation/Gradation: ""
*en.GraphicScreen Resolution/Resolution: ""
*en.GraphicScreen HighResolution/High Resolution: ""

*en.Translation GraphicSmoothing/Smoothing (Graphic): ""
*en.GraphicSmoothing Auto/Auto: ""
*en.GraphicSmoothing None/Off: ""
*en.GraphicSmoothing Dark/Dark: ""
*en.GraphicSmoothing Medium/Medium: ""
*en.GraphicSmoothing Light/Light: ""

*en.Translation TonerSave/Toner Save: ""
*en.TonerSave False/Off: ""
*en.TonerSave True/On: ""

*en.Translation String4Pt/Edge Enhancement: ""
*en.String4Pt False/None: ""
*en.String4Pt Weak/Weak: ""
*en.String4Pt Normal/Medium: ""
*en.String4Pt Strong/Strong: ""

*en.Translation LineWidthAdjustment/Line Width Adjustment: ""
*en.LineWidthAdjustment Printers/Machine Setting: ""
*en.LineWidthAdjustment Thin/Thin: ""
*en.LineWidthAdjustment SlightlyThin/Slightly Thin: ""
*en.LineWidthAdjustment Normal/Normal: ""
*en.LineWidthAdjustment SlightlyThick/Slightly Thick: ""
*en.LineWidthAdjustment Thick/Thick: ""

*%
*% === Begin Page Section ============
*%

*en.Translation PageRegion/PageRegion: ""
*en.PageRegion A3/A3: ""
*en.PageRegion A4/A4: ""
*en.PageRegion A5/A5: ""
*en.PageRegion A6/A6: ""
*en.PageRegion B4/B4: ""
*en.PageRegion B5/B5: ""
*en.PageRegion B6/B6: ""
*en.PageRegion SRA3/SRA3: ""
*en.PageRegion 220mmx330mm/220mmx330mm: ""
*en.PageRegion 12x18/12x18: ""
*en.PageRegion Tabloid/11x17: ""
*en.PageRegion Legal/8 1/2x14: ""
*en.PageRegion Letter/8 1/2x11: ""
*en.PageRegion LetterPlus/8 1/2x12 11/16: ""
*en.PageRegion Statement/5 1/2x8 1/2: ""
*en.PageRegion 8x13/8x13: ""
*en.PageRegion 8.5x13/8 1/2x13: ""
*en.PageRegion 8.5x13.5/8 1/2x13 1/2: ""
*en.PageRegion 8.25x13/8 1/4x13: ""
*en.PageRegion 8.125x13.25/8 1/8x13 1/4: ""
*en.PageRegion 8x10/8x10: ""
*en.PageRegion 8x10.5/8x10 1/2: ""
*en.PageRegion Executive/7 1/4x10 1/2: ""
*en.PageRegion 8K/8K: ""
*en.PageRegion 16K/16K: ""
*en.PageRegion EnvISOB5/Envelope B5: ""
*en.PageRegion EnvC4/Envelope C4: ""
*en.PageRegion EnvC5/Envelope C5: ""
*en.PageRegion EnvC6/Envelope C6: ""
*en.PageRegion EnvChou3/Envelope Nagagata3: ""
*en.PageRegion EnvChou4/Envelope Nagagata4: ""
*en.PageRegion EnvYou3/Envelope Yougata3: ""
*en.PageRegion EnvYou4/Envelope Yougata4: ""
*en.PageRegion EnvKaku1/Envelope Kakugata1: ""
*en.PageRegion EnvKaku2/Envelope Kakugata2: ""
*en.PageRegion EnvKaku3/Envelope Kakugata3: ""
*en.PageRegion EnvDL/Envelope DL: ""
*en.PageRegion EnvMonarch/Envelope Monarch: ""
*en.PageRegion Env10/Envelope Com10: ""
*en.PageRegion JapanesePostCard/Postcard: ""
*en.PageRegion 4x6_PostCard/4x6 Postcard: ""
*en.PageRegion DoublePostcardRotated/Double Postcard: ""
*en.PageRegion A3Extra/A3W: ""
*en.PageRegion A4Extra/A4W: ""
*en.PageRegion A5Extra/A5W: ""
*en.PageRegion B4Extra/B4W: ""
*en.PageRegion B5Extra/B5W: ""
*en.PageRegion TabloidExtra/11x17W: ""
*en.PageRegion LetterExtra/8 1/2x11W: ""
*en.PageRegion StatementExtra/5 1/2x8 1/2W: ""
*en.PageRegion LetterTab-F/8 1/2x11 Tab: ""
*en.PageRegion A4Tab-F/A4 Tab: ""
EOF
