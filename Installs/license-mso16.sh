#!/bin/bash
pkg="/tmp/mso16vl.pkg"
curl -sLo "$pkg" https://github.com/jaykepeters/MDM/raw/master/macOS/PKG/Microsoft_Office_2016_VL_Serializer_2.0.pkg
installer -pkg "$pkg" -target "$3"
