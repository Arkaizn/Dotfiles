#!/bin/bash

(
    curl -L -o Bibata-Modern-Ice.tar.xz https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz
    7z x Bibata-Modern-Ice.tar.xz
    7z x Bibata-Modern-Ice.tar
    cp -r Bibata-Modern-Ice ~/.icons/Bibata-Modern-Ice
)