GCC Crosscompiler Toolchain for ESP8266
=======================================

This docker image builds a gcc crosscompiler for the esp8266 (xtensa) architecture. The toolchain is build with crosstool-NG.

Tools currently in use:

* crosstool-NG fork of Max Filippov <https://github.com/jcmvbkbc/crosstool-NG>
* mforce-l32 patch mainly for micropython (Max Filippov)

An Espressif fork of this toolchain (with gcc 5.2.0 and newlib 2.2) may be found here:

* <https://github.com/espressif/crosstool-NG/tree/esp8266-1.22.x>

An alternative toolchain without crosstool-NG and more recent versions may be found here:

* <https://github.com/earlephilhower/esp-quick-toolchain>
