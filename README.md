# Box2C-UDF

## Introduction

This is an AutoIT UDF of for Box2D.  It uses the Box2C API / wrapper for Box2D.


## Download

Click **Clone or download** above, then **Download ZIP**, then download and extract the contents of the zip file to your computer.

## Contents

- **Box2C_Angry_Nerds_Game_SFML_installer.exe** is an installer for Angry Nerds, the best demo so far for the UDF
- **Box2C.au3** is the Box2D UDF itself, containing the Box2D / Box2C functions for AutoIT
- **Box2C_linear_forces_test_SFML.exe** is a test of Box2D linear forces using AutoIT and SFML
- **Box2C_angular_forces_test_SFML.exe** is a test of Box2D angular forces using AutoIT and SFML
- **Box2C_speed_test_SFML.exe** is a speed test using AutoIT and SFML
- **Box2C_speed_test_Irrlicht.exe** is a speed test using AutoIT and Irrlicht
- **Box2C_speed_test_D2D.exe** is a speed test using AutoIT and Direct 2D
- **Box2C_speed_test_GDIPlus.exe** is a speed test using AutoIT and GDI+
- the ***.au3** files are the AutoIT scripts of the same name as the exe files above
- the ***.gif** and ***.png** files are the sprites / images used in the tests
- the ***.dll** files are the graphic engine libraries, and also the Box2C libraries

## Usage

You can run any of the executables (exe files) above to test the UDF. The Angry Nerds game demo should play similar to this YouTube video:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=h5QH1O63Wik
" target="_blank"><img src="http://img.youtube.com/vi/h5QH1O63Wik/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

The four speed tests will test the performance of the UDF against four popular graphics engines, as follows.

Filename | Test
-------- | ----
Box2C_speed_test_SFML.exe | Tests the SFML graphics engine with the Box2D UDF
Box2C_speed_test_Irrlicht.exe | Tests the Irrlicht graphics engine with the Box2D UDF
Box2C_speed_test_D2D.exe | Tests the Direct 2D graphics engine with the Box2D UDF
Box2C_speed_test_GDIPlus.exe | Tests the GDI+ graphics engine with the Box2D UDF

Follow the prompts in the displayed GUI on how to conduct the test.

SFML (Box2C_speed_test_SFML.exe) should provide the best performance.

## Benchmarks

FPS readings are not limited.

test 1. 60hz box2d step, all frame rendering, for 4 bodies ...

Engine | FPS
------ | ---
Irrlicht | 1360
SFML | 1260
D2D | 650
GDI+ | 114

Repeated above but with 10 bodies ...

Engine | FPS
------ | ---
Irrlicht | 780
SFML | 700
D2D | 333
GDI+ | 86

Repeated above but with 100 bodies ...

Engine | FPS
------ | ---
Irrlicht | 100
SFML | 87
D2D | 44
GDI+ | 24

test 2. Irrlicht and SFML only. 60hz box2d step and frame rendering combined, for 100 bodies

Engine | FPS
------ | ---
Irrlicht | 7300
SFML | 6500

test 3. as above but excluding transforming / draw logic

Engine | FPS
------ | ---
Irrlicht | 13000
SFML | 14200

