#include-once
#include <Array.au3>
#include "Box2CEx.au3"


Local $video_mode, $video_mode_ptr


; Startup SFML

_CSFML_Startup()

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)
Local $tmp_gui_center_x = _Box2C_b2World_GetGUIAreaCenter(0)
Local $tmp_gui_center_y = _Box2C_b2World_GetGUIAreaCenter(1)

; Setup the Box2D Shapes

Global $platform_shape_vertice[4][2] = [[0,0],[5,0],[5,1],[0,1]]
Local $platform_shape_index = _Box2C_b2PolygonShape_ArrayAdd_SFML($platform_shape_vertice, @ScriptDir & "\platform.gif")

Global $crate_shape_vertice[4][2] = [[0,0],[0.25,0],[0.25,0.25],[0,0.25]]
Local $crate_shape_index = _Box2C_b2PolygonShape_ArrayAdd_SFML($crate_shape_vertice, @ScriptDir & "\smallest_crate.gif")

; Setup the Box2D Body Definitions

Local $platform_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(0, 0, -4, 0)
Local $platform2_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(0, -4.5, -2, -0.785398)
Local $platform3_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(0, +4.5, -2, +0.785398)
Local $falling_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(2, 0, 4, 0)

; Setup the Box2D Bodies

Local $platform_body_index = _Box2C_b2Body_ArrayAdd_SFML($platform_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_index, 0, -4)
Local $platform2_body_index = _Box2C_b2Body_ArrayAdd_SFML($platform2_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_index, -4.5, -2)
Local $platform3_body_index = _Box2C_b2Body_ArrayAdd_SFML($platform3_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_index, +4.5, -2)
Local $falling_body_index = _Box2C_b2Body_ArrayAdd_SFML($falling_bodydef_index, $crate_shape_index, 1, 0.2, 0.3, $crate_shape_index, 0, 4)

; Setup basic variables for SFML

Local $event = _CSFML_sfEvent_Constructor()
Local $event_ptr = DllStructGetPtr($event)
;Local $black = _CSFML_sfColor_fromRGB(0,0,0)
Local $black = _CSFML_sfColor_Constructor(0,0,0,0)
Local $white = _CSFML_sfColor_Constructor(255,255,255,0)
Local $pos = _CSFML_sfVector2f_Constructor(1,1)
Local $pos_ptr = DllStructGetPtr($pos)

; Setup the GUI for SFML

$video_mode = _CSFML_sfVideoMode_Constructor(800, 600, 16)
Local $window_ptr = _CSFML_sfRenderWindow_create($video_mode, "SFML window", $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose, Null)
_CSFML_sfRenderWindow_setVerticalSyncEnabled($window_ptr, False)

; Attach an AutoIT GUI for reporting

Local $irr_win_pos = WinGetPos("SFML window")
Global $g_hGUI = GUICreate("Box2D / Box2C by seangriffin", 300, 400, $irr_win_pos[0] + $irr_win_pos[2], $irr_win_pos[1])
Global $number_of_bodies_label = GUICtrlCreateLabel("Number of bodies = ", 20, 80, 160, 20)
Global $b2world_step_time_label = GUICtrlCreateLabel("b2World_Step runtime = ", 20, 100, 160, 20)
Global $CSFML_clear_transform_display_runtime_label = GUICtrlCreateLabel("CSFML_clear_tranform_display runtime = ", 20, 120, 260, 20)
Global $fps_label = GUICtrlCreateLabel("FPS = ", 20, 140, 260, 20)
GUISetState(@SW_SHOW)
WinActivate( "SFML window" )

; Setup the initial 4 SFML sprites

local $sprite_ptr[UBound($__body_struct_ptr)]

for $body_num = 0 to (UBound($__body_struct_ptr) - 1)

	$sprite_ptr[$body_num] = _CSFML_sfSprite_create()

	if $body_num >= 0 and $body_num <= 2 Then

		_CSFML_sfSprite_setTexture($sprite_ptr[$body_num], $__shape_image[$platform_shape_index], $CSFML_sfTrue)
	Else

		_CSFML_sfSprite_setTexture($sprite_ptr[$body_num], $__shape_image[$crate_shape_index], $CSFML_sfTrue)
	EndIf

	_CSFML_sfSprite_setOrigin($sprite_ptr[$body_num], _CSFML_sfVector2f_Constructor(($__body_width[$body_num] / 2) * $__pixels_per_metre, ($__body_height[$body_num] / 2) * $__pixels_per_metre))
Next

; Setup the Box2D animation, including the clocks (timers) and animation rate

Local $clock_ptr = _CSFML_sfClock_create()
Local $b2World_Step_clock_ptr = _CSFML_sfClock_create()
Local $b2World_Step_runtime_clock_ptr = _CSFML_sfClock_create()
;Local $CSFML_clear_transform_display_runtime_clock_ptr = _CSFML_sfClock_create()
Local $fps_clock_ptr = _CSFML_sfClock_create()
Local $fps = 0

; in microseconds (i.e. 1 60th of a second times 1,000,000 microseconds in a second)
Local $animation_rate = Int(1 / 60 * 1000000)

; The animation loop

While True

;	$animation_rate = 20000 - (UBound($__body_struct_ptr) * 60)

	; Every second calculate and display the FPS and number of active bodies

	if _CSFML_sfClock_getElapsedTime($fps_clock_ptr) > 1000000 Then

		_CSFML_sfClock_restart($fps_clock_ptr)

		GUICtrlSetData($fps_label, "FPS = " & $fps)
		$fps = 0

		GUICtrlSetData($number_of_bodies_label, "Number of bodies = " & UBound($__body_struct_ptr))
	EndIf

	; Every animation frame update the Box2D world

	if _CSFML_sfClock_getElapsedTime($b2World_Step_clock_ptr) > ($animation_rate - 3000) Then

		_CSFML_sfClock_restart($b2World_Step_clock_ptr)
		_Box2C_b2World_Step($__world_ptr, (1.0 / 60.0), 6, 2)
	EndIf

	; Every animation frame render the bodies with SFML 2D

;	if _CSFML_sfClock_getElapsedTime($clock_ptr) > $animation_rate Then
	if _CSFML_sfClock_getElapsedTime($clock_ptr) > 1 Then

		_CSFML_sfClock_restart($clock_ptr)

		; Check for events

		While _CSFML_sfRenderWindow_pollEvent($window_ptr, $event_ptr) = True

			Switch DllStructGetData($event, 1)

				; if the GUI was closed

				Case $CSFML_sfEvtClosed

					_CSFML_sfRenderWindow_close($window_ptr)

				; if a key was pressed

				Case $CSFML_sfEvtKeyPressed

					Local $key_code = DllStructGetData($event, 2)
;					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $key_code = ' & $key_code & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

					Switch $key_code

						Case 36 ; Esc

							_CSFML_sfRenderWindow_close($window_ptr)
							ExitLoop 2

						; if "A" was pressed then add a new body

						case 0 ; A

							Local $new_body_num = _Box2C_b2Body_ArrayAdd_SFML($falling_bodydef_index, $crate_shape_index, 1, 0.2, 0.3, $crate_shape_vertice, 0, 4)

							_ArrayAdd($sprite_ptr, Null)
							$sprite_ptr[$new_body_num] = _CSFML_sfSprite_create()
							_CSFML_sfSprite_setTexture($sprite_ptr[$new_body_num], $__shape_image[$crate_shape_index], $CSFML_sfTrue)
							_CSFML_sfSprite_setOrigin($sprite_ptr[$new_body_num], _CSFML_sfVector2f_Constructor(($__body_width[$new_body_num] / 2) * $__pixels_per_metre, ($__body_height[$new_body_num] / 2) * $__pixels_per_metre))

						; if "E" was pressed then rotate the center platform clockwise

						Case 4 ; E

							Local $curr_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[0])
							Local $curr_angle_degrees2 = radians_to_degrees($curr_angle)
							$curr_angle_degrees2 = $curr_angle_degrees2 - 5
							_Box2C_b2Body_SetAngle($__body_struct_ptr[0], degrees_to_radians($curr_angle_degrees2))

						; if "Q" was pressed then rotate the center platform counter-clockwise

						Case 16 ; Q

							Local $curr_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[0])
							Local $curr_angle_degrees2 = radians_to_degrees($curr_angle)
							$curr_angle_degrees2 = $curr_angle_degrees2 + 5
							_Box2C_b2Body_SetAngle($__body_struct_ptr[0], degrees_to_radians($curr_angle_degrees2))

					EndSwitch
			EndSwitch
		WEnd

		; Clear the animation frame

		_CSFML_sfRenderWindow_clear($window_ptr, $white)

		; Transform the Box2D bodies and SFML sprites

		Local $body_num = -1

		While True

			$body_num = $body_num + 1

			if $body_num > (UBound($__body_struct_ptr) - 1) Then

				ExitLoop
			EndIf

			Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_num])

			if $body_position[1] < -11 Then

				_Box2C_b2Body_Destroy($body_num)
				_CSFML_sfSprite_destroy($sprite_ptr[$body_num])
				_ArrayDelete($sprite_ptr, $body_num)
			Else

				$__body_curr_screen_x[$body_num] = $tmp_gui_center_x + ($body_position[0] * $__pixels_per_metre)
;				$__body_curr_screen_x[$body_num] = x_metres_to_gui_x($body_position[0], $tmp_gui_center_x)

				$__body_curr_screen_y[$body_num] = $tmp_gui_center_y - ($body_position[1] * $__pixels_per_metre)
;				$__body_curr_screen_y[$body_num] = y_metres_to_gui_y($body_position[1], $tmp_gui_center_y)

				Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_num])
				$__body_curr_angle_degrees[$body_num] = 0 - radians_to_degrees($body_angle)

				_CSFML_sfVector2f_Update($pos_ptr, $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])
				_CSFML_sfSprite_setPosition($sprite_ptr[$body_num], $pos)
				_CSFML_sfSprite_setRotation($sprite_ptr[$body_num], $__body_curr_angle_degrees[$body_num])
				_CSFML_sfRenderWindow_drawSprite($window_ptr, $sprite_ptr[$body_num], Null)
			EndIf
		WEnd

		; Render the animation frame

		_CSFML_sfRenderWindow_display($window_ptr)
		$fps = $fps + 1
	EndIf
WEnd

; Shutdown SFML
_CSFML_Shutdown()