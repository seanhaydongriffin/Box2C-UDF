# Box2C-UDF

## Introduction

This is an AutoIT UDF of for Box2D.  It uses the Box2C API / wrapper for Box2D.


## Download

Click **Clone or download** above, then **Download ZIP**, then download and extract the contents of the zip file to your computer.

## Contents

- **CSFML.au3** is the CSFML UDF itself, containing the SFML functions for AutoIT
- **CSFML_short_example.au3** is an example of an AutoIT script using the UDF
- **arial.ttf** and **logo4.gif** are resource files required by CSFML_short_example.au3 above

## Usage

There are four speed tests, which you can run to test the performance of the UDF against four popular graphics engines.  These are the following files.

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

