#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

cd "$(dirname "$0")"
cp printers/KOC751iUX.ppd /usr/share/cups/model/KOC751iUX.ppd
cp printers/ZebraZC300Printer.ppd /usr/share/cups/model/ZebraZC300Printer.ppd
cp printers/brother_ql820nwb_printer_en.ppd /usr/share/cups/model/brother_ql820nwb_printer_en.ppd

cp printers/rastertojg /usr/lib/cups/filter/rastertojg
chmod a+x /usr/lib/cups/filter/rastertojg
cp printers/pdftojgpdf /usr/lib/cups/filter/pdftojgpdf
chmod a+x /usr/lib/cups/filter/pdftojgpdf

mkdir /usr/lib/opt/zebra
ln -s /usr/lib64/libtinyxml.so.0 /usr/lib/opt/zebra/libtinyxml.so.2.6.2
ln -s /usr/lib64/libudev.so /usr/lib/opt/zebra/libudev_64bit.so.1
cp printers/libzmjxml.so /usr/lib/opt/zebra/libzmjxml.so
chmod a+x /usr/lib/opt/zebra/libzmjxml.so

#cp printers/libtinyxml.so.2.6.2 /usr/lib64/libtinyxml.so.2.6.2
#chmod a+x /usr/lib64/libtinyxml.so.2.6.2
#cp printers/libzmjxml.so /usr/lib64/libzmjxml.so
#chmod a+x /usr/lib64/libzmjxml.so
#cp printers/libudev_64bit.so.1 /usr/lib64/libudev_64bit.so.1
#chmod a+x /usr/lib64/libudev_64bit.so.1
