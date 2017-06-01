#include-once
#include <Array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include "Box2CEx.au3"

; Setup SQLite

_SQLite_Startup()
_SQLite_Open(@ScriptDir & "\Box2C_speed_test_SFML.sqlite")

; Setup SFML

_Box2C_Setup_SFML()

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)

; Setup the Box2D Shapes

Global $platform_shape_ptr = _Box2C_b2ShapeDict_AddItem_SFML($Box2C_e_edge, _StringSplit2d("-2.5,-0.5|2.5,-0.5|2.5,0.5|-2.5,0.5"), @ScriptDir & "\platform.gif")
Global $crate_shape_ptr = _Box2C_b2ShapeDict_AddItem_SFML($Box2C_e_edge, _StringSplit2d("-0.125,-0.125|0.125,-0.125|0.125,0.125|-0.125,0.125"), @ScriptDir & "\smallest_crate.gif")
Exit
; Setup the Box2D Body Definitions

Global $platform_bodydef_index = _Box2C_b2BodyDefDict_AddItem($Box2C_b2_staticBody, 0, -4, 0, 0, 0)
Global $platform2_bodydef_index = _Box2C_b2BodyDefDict_AddItem($Box2C_b2_staticBody, -4.5, -2, -0.785398, 0, 0)
Global $platform3_bodydef_index = _Box2C_b2BodyDefDict_AddItem($Box2C_b2_staticBody, +4.5, -2, +0.785398, 0, 0)
Global $falling_bodydef_index = _Box2C_b2BodyDefDict_AddItem($Box2C_b2_dynamicBody, 0, 4, 0, 0, 0)

_Box2C_b2Body_SetDrawSpriteRange_SFML(0, 99999)
_Box2C_b2Body_SetDrawConvexShapeRange_SFML(-1, -1)
;_Box2C_b2Body_SetDrawConvexShapeRange_SFML(0, 99999)


; Setup the Box2D Bodies and SFML Sprites

Local $platform_body_index = _Box2C_b2BodyDict_AddItem_SFML($platform_bodydef_index, $platform_shape_ptr, 0, 0, 0, "", "", "", 0, 0, 0)
Local $platform2_body_index = _Box2C_b2BodyDict_AddItem_SFML($platform2_bodydef_index, $platform_shape_ptr, 0, 0, 0, "", "", "", 0, 0, 0)
Local $platform3_body_index = _Box2C_b2BodyDict_AddItem_SFML($platform3_bodydef_index, $platform_shape_ptr, 0, 0, 0, "", "", "", 0, 0, 0)
Local $falling_body_index = _Box2C_b2BodyDict_AddItem_SFML($falling_bodydef_index, $crate_shape_ptr, 1, 0.2, 0.3, "", "", "", 0, -6.25, -6.25)

; Setup the GUI for SFML inside the AutoIT GUI

Local $video_mode = _CSFML_sfVideoMode_Constructor(800, 600, 16)
Global $window_ptr = _CSFML_sfRenderWindow_create($video_mode, "Box2D Speed Test for the SFML Engine", $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose, Null)
Global $window_hwnd = _CSFML_sfRenderWindow_getSystemHandle($window_ptr)
_CSFML_sfRenderWindow_setVerticalSyncEnabled($window_ptr, False)
Local $info_text_ptr = _CSFML_sfText_create_and_set($__courier_new_font_ptr, 14, $__black, 10, 10)

; Setup the Box2D animation, including the clocks (timers) and animation rate

Global $num_frames = 0
Global $fps = 0
Local $fps_timer = _Timer_SetTimer($window_hwnd, 1000, "update_fps")
Local $frame_timer = _Timer_Init()

; The animation frame loop

While true

	; Every animation frame (1 / 60th of a second) update the Box2D world

	if _Timer_Diff($frame_timer) > ((1 / 60) * 1000) Then

		$frame_timer = _Timer_Init()
;		_Box2C_b2World_Step($__world_ptr, (1.0 / 60.0), 6, 2)

		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step_Ex((0.6 + (UBound($__body_struct_ptr) / 200)) / 60.0)

		; Check for events

		While _CSFML_sfRenderWindow_pollEvent($window_ptr, $__event_ptr) = True

			Switch DllStructGetData($__event, 1)

				; if the GUI was closed

				Case $CSFML_sfEvtClosed

					_Exit()

				; if a key was pressed

				Case $CSFML_sfEvtKeyPressed

					Local $key_code = DllStructGetData($__event, 2)
;					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $key_code = ' & $key_code & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

					Switch $key_code

						Case 36 ; Esc

							_Exit()

						; if "A" was pressed then add a new body

						case 0 ; A

							Local $new_body_num = _Box2C_b2BodyDict_AddItem_SFML($falling_bodydef_index, $crate_shape_ptr, 1, 0.2, 0.3, "", "", "", 0, -6.25, -6.25)

						; if "E" was pressed then rotate the center platform clockwise

						Case 4 ; E

;							Local $curr_angle = _Box2C_b2BodyArray_GetItemAngle(0)
;							Local $curr_angle_degrees2 = _Degree($curr_angle)
;							$curr_angle_degrees2 = $curr_angle_degrees2 - 5
;							_Box2C_b2BodyArray_SetItemAngle(0, _Radian($curr_angle_degrees2))

						; if "Q" was pressed then rotate the center platform counter-clockwise

						Case 16 ; Q

;							Local $curr_angle = _Box2C_b2BodyArray_GetItemAngle(0)
;							Local $curr_angle_degrees2 = _Degree($curr_angle)
;							$curr_angle_degrees2 = $curr_angle_degrees2 + 5
;							_Box2C_b2BodyArray_SetItemAngle(0, _Radian($curr_angle_degrees2))

					EndSwitch
			EndSwitch
		WEnd

		Local $info_text_string = 	"Keys" & @LF & _
									"----" & @LF & _
									"Press ""A"" to add (drop) a new box / body to the world" & @LF & _
									"Press ""Q"" to rotate the center platform anti-clockwise" & @LF & _
									"Press ""E"" to rotate the center platform clockwise" & @LF & _
									"" & @LF & _
									"Stats" & @LF & _
									"-----" & @LF & _
									"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
									"FPS = " & $fps


		; Transform all the Box2D bodies to SFML sprites

		_Box2C_b2BodyArray_Transform_SFML()

		; Clear the animation frame

		_CSFML_sfRenderWindow_clear($window_ptr, $__white)

		; Draw and display all the SFML sprites (including background) with information text

		_Box2C_b2BodyArray_Draw_SFML($window_ptr, $info_text_ptr, $info_text_string, 2)

		_CSFML_sfRenderWindow_display($window_ptr)

		if StringInStr("999", "999") > 0 Then

			$tmp = "999"
		EndIf

		$num_frames = $num_frames + 1
	EndIf
WEnd

Func _Exit()

	; Close the SFML RenderWindow
	_CSFML_sfRenderWindow_close($window_ptr)

	; Shutdown SFML
	_CSFML_Shutdown()

	Exit
EndFunc

Func update_fps($hWnd, $iMsg, $iIDTimer, $iTime)
    #forceref $hWnd, $iMsg, $iIDTimer, $iTime

	$fps = $num_frames
	$num_frames = 0

EndFunc

