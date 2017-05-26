; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply 
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there. 

;--------------------------------

; The name of the installer
Name "Box2C Angry Nerds Game using SFML"

; The file to write
OutFile "Box2C_Angry_Nerds_Game_SFML_installer.exe"

; The default installation directory
InstallDir "$DESKTOP\Box2C Angry Nerds Game using SFML"

; Request application privileges for Windows Vista
RequestExecutionLevel user

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File Box2C_Angry_Nerds_Game_SFML.exe
  File Box2C.dll
  File csfml-graphics-2.dll
  File csfml-system-2.dll
  File csfml-window-2.dll
  File *.png
  
SectionEnd ; end the section
