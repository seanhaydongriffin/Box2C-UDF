#include-once
#include <Array.au3>
#include "Box2CEx.au3"

; Setup SFML

_Box2C_Setup_SFML()

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)
;_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -0.0000000)

; Setup the Box2D Shapes
;
; 	_Box2C_b2Shape_ArrayAdd_SFML parameters:
;		#1 - the type of shape being one of the following - $Box2C_e_circle, $Box2C_e_edge, $Box2C_e_polygon, $Box2C_e_chain, $Box2C_e_typeCount
;		#2 - if a type of $Box2C_e_circle the radius of the circle, if a type of $Box2C_e_edge the vertices of the polygon as a two dimensional array
;		#3 - the path and name of the file of the texture / image of the shape

Global $background_shape_vertice[4][2] = [[0,0],[16,0],[16,12],[0,12]]
Global $background_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $background_shape_vertice, @ScriptDir & "\angry_nerds_fence_background.png")
Global $ground_shape_vertice[4][2] = [[0,0],[16,0],[16,2],[0,2]]
Global $ground_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $ground_shape_vertice, @ScriptDir & "\angry_nerds_ground.png")

Global $cross1_plank_shape_vertice[4][2] = [[0,0],[2,0],[2,0.6],[0,0.6]]
Global $cross1_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $cross1_plank_shape_vertice, @ScriptDir & "\angry_nerds_crossed_plank1.png")

Global $box_shape_vertice[4][2] = [[0,0],[1,0],[1,1],[0,1]]
Global $box_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $box_shape_vertice, @ScriptDir & "\angry_nerds_box.png")
Global $triangle_plank_shape_vertice[3][2] = [[0,0],[1,0],[0.5,1]]
Global $triangle_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $triangle_plank_shape_vertice, @ScriptDir & "\angry_nerds_triangle.png")
Global $triangle2_plank_shape_vertice[3][2] = [[0,0],[1,0],[0,1]]
Global $triangle2_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $triangle2_plank_shape_vertice, @ScriptDir & "\angry_nerds_triangle2.png")
Global $circle_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_circle, (1 / 2), @ScriptDir & "\angry_nerds_circle.png")
Global $thick1_plank_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.5],[0,0.5]]
Global $thick1_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $thick1_plank_shape_vertice, @ScriptDir & "\angry_nerds_thick_plank1.png")
Global $thick2_plank_shape_vertice[4][2] = [[0,0],[1,0],[1,0.5],[0,0.5]]
Global $thick2_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $thick2_plank_shape_vertice, @ScriptDir & "\angry_nerds_thick_plank2.png")
Global $thin1_plank_shape_vertice[4][2] = [[0,0],[0.25,0],[0.25,0.25],[0,0.25]]
Global $thin1_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $thin1_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank1.png")
Global $thin2_plank_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.25],[0,0.25]]
Global $thin2_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $thin2_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank2.png")
Global $thin3_plank_shape_vertice[4][2] = [[0,0],[1,0],[1,0.25],[0,0.25]]
Global $thin3_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $thin3_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank3.png")
Global $thin4_plank_shape_vertice[4][2] = [[0,0],[2,0],[2,0.25],[0,0.25]]
Global $thin4_plank_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $thin4_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank4.png")

Global $earth_ball_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_circle, (0.5 / 2), @ScriptDir & "\earth_ball.png")

;Global $droid_shape_margin = 0.35
;Global $droid_stand_shape_vertice[4][2] = [[0 + $droid_shape_margin, 0 + $droid_shape_margin],[1.12, 0 + $droid_shape_margin],[1.12, 1.6],[0 + $droid_shape_margin, 1.6]]
;Global $droid_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $droid_stand_shape_vertice, @ScriptDir & "\droid_stand.png")

Global $droid_shape_margin = 0.26
Global $droid_stand_shape_vertice[4][2] = [[0 + $droid_shape_margin, 0 + $droid_shape_margin],[0.84, 0 + $droid_shape_margin],[0.84, 1.2],[0 + $droid_shape_margin, 1.2]]
Global $droid_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $droid_stand_shape_vertice, @ScriptDir & "\droid_stand.png")

Global $gnu_shape_margin = 0.35
Global $gnu_stand_shape_vertice[4][2] = [[0 + $gnu_shape_margin, 0 + $gnu_shape_margin],[1.12, 0 + $gnu_shape_margin],[1.12, 1.6],[0 + $gnu_shape_margin, 1.6]]
Global $gnu_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $gnu_stand_shape_vertice, @ScriptDir & "\gnu_stand.png")

Global $kisi_shape_margin = 0.35
Global $kisi_stand_shape_vertice[4][2] = [[0 + $kisi_shape_margin, 0 + $kisi_shape_margin],[1.12, 0 + $kisi_shape_margin],[1.12, 1.6],[0 + $kisi_shape_margin, 1.6]]
Global $kisi_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $kisi_stand_shape_vertice, @ScriptDir & "\kisi_stand.png")

Global $kit_shape_margin = 0.35
Global $kit_stand_shape_vertice[4][2] = [[0 + $kit_shape_margin, 0 + $kit_shape_margin],[1.12, 0 + $kit_shape_margin],[1.12, 1.6],[0 + $kit_shape_margin, 1.6]]
Global $kit_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $kit_stand_shape_vertice, @ScriptDir & "\kit_stand.png")

Global $pacman_shape_margin = 0.35
Global $pacman_stand_shape_vertice[4][2] = [[0 + $pacman_shape_margin, 0 + $pacman_shape_margin],[1.12, 0 + $pacman_shape_margin],[1.12, 1.6],[0 + $pacman_shape_margin, 1.6]]
Global $pacman_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $pacman_stand_shape_vertice, @ScriptDir & "\pacman_stand.png")

Global $sara_shape_margin = 0.35
Global $sara_stand_shape_vertice[4][2] = [[0 + $sara_shape_margin, 0 + $sara_shape_margin],[1.12, 0 + $sara_shape_margin],[1.12, 1.6],[0 + $sara_shape_margin, 1.6]]
Global $sara_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $sara_stand_shape_vertice, @ScriptDir & "\sara_stand.png")

Global $tux_shape_margin = 0.35
Global $tux_stand_shape_vertice[4][2] = [[0 + $tux_shape_margin, 0 + $tux_shape_margin],[1.12, 0 + $tux_shape_margin],[1.12, 1.6],[0 + $tux_shape_margin, 1.6]]
Global $tux_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $tux_stand_shape_vertice, @ScriptDir & "\tux_stand.png")

Global $wilbur_shape_margin = 0.35
Global $wilbur_stand_shape_vertice[4][2] = [[0 + $wilbur_shape_margin, 0 + $wilbur_shape_margin],[1.12, 0 + $wilbur_shape_margin],[1.12, 1.6],[0 + $wilbur_shape_margin, 1.6]]
Global $wilbur_stand_shape_index = _Box2C_b2Shape_ArrayAdd_SFML($Box2C_e_edge, $wilbur_stand_shape_vertice, @ScriptDir & "\wilbur_stand.png")

; Setup the Box2D Body Definitions
;
; 	_Box2C_b2BodyDef_ArrayAdd parameters:
;		#1 - the type of body being one of the following - $Box2C_b2_staticBody, $Box2C_b2_kinematicBody or $Box2C_b2_dynamicBody
;		#2 - the body's initial horizontal position (in Box2D world coordinates)
;		#3 - the body's initial vertical position (in Box2D world coordinates)
;		#4 - the body's initial angular position / rotation (in Box2D world coordinates) - use the degrees_to_radians function, as below, if convenient

Global $background_bodydef_index = _Box2C_b2BodyDef_ArrayAdd($Box2C_b2_staticBody, 0, 0, 0)
Global $ground_bodydef_index = _Box2C_b2BodyDef_ArrayAdd($Box2C_b2_staticBody, 0, -5.4, 0)
Global $player_bodydef_index = _Box2C_b2BodyDef_ArrayAdd($Box2C_b2_dynamicBody, -4, 4, 0)
Global $plank_bodydef_index = _Box2C_b2BodyDef_ArrayAdd($Box2C_b2_dynamicBody, 4, 4, 0)
Global $enemy_bodydef_index = _Box2C_b2BodyDef_ArrayAdd($Box2C_b2_dynamicBody, 4, 4, 0)


; Setup the Box2D Bodies and SFML Sprites
;
; 	_Box2C_b2Body_ArrayAdd_SFML parameters:
;		#1 - the index to the definition of the body, as given by _Box2C_b2BodyDef_ArrayAdd above
;		#2 - the index to the shape of the body, as given by _Box2C_b2PolygonShape_ArrayAdd_SFML and _Box2C_b2CircleShape_ArrayAdd_SFML above
;		#3 - the density of the body
;		#4 - the restitution (bounciness) of the body
;		#5 - the friction of the body - note it's very important for all bodies to have some friction for torque to work on circle shapes!
;		#6 - a flag that indicates what bodies / sprites should do when they go outside the GUI area:
;				0 = do nothing (keep animating)
;				1 = destroy the body / sprite
;				2 = bounce the linear velocity of the body / sprite (like bouncing off a wall)
;				3 = stop the linear velocity of the body / sprite (like hitting a wall)

Global $background_body_index = _Box2C_b2Body_ArrayAdd_SFML($background_bodydef_index, $background_shape_index, 0, 0, 1, "", "", "", 0)

; Ensure the background is inactive from physics operations
_Box2C_b2Body_SetActive($__body_struct_ptr[$background_body_index], False)

Local $ground_body_index = _Box2C_b2Body_ArrayAdd_SFML($ground_bodydef_index, $ground_shape_index, 0, 0, 1, "", "", "", 0)


;Local $player_body_index = _Box2C_b2Body_ArrayAdd_SFML($player_bodydef_index, $earth_ball_shape_index, 1, 0.2, 1, -4, -4.2, degrees_to_radians(0), 0)

; construct the village to knock down
;_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 4, -4.2, degrees_to_radians(0), 0)
;_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 3.2, -3.0, degrees_to_radians(90), 0)
;_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 4.8, -3.0, degrees_to_radians(90), 0)
;_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 4, -2.15, degrees_to_radians(0), 0)

;_Box2C_b2Body_ArrayAdd_SFML($enemy_bodydef_index, $droid_stand_shape_index, 1, 0.2, 1, 4, 4, degrees_to_radians(0), 0)

Global $player_body_index
Global $level_num = 1

restart_level()

;Local $box_body_index = _Box2C_b2Body_ArrayAdd_SFML($box_bodydef_index, $box_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $triangle_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($triangle_plank_bodydef_index, $triangle_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $triangle2_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($triangle2_plank_bodydef_index, $triangle2_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $circle_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($circle_plank_bodydef_index, $circle_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $thick1_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($thick1_plank_bodydef_index_plank_bodydef_index, $thick1_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $thick2_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($thick2_plank_bodydef_index_plank_bodydef_index, $thick2_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $thin1_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($thin1_plank_bodydef_index, $thin1_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $thin2_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($thin2_plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $thin3_plank_body_index = _Box2C_b2Body_ArrayAdd_SFML($thin3_plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $gnu_body_index = _Box2C_b2Body_ArrayAdd_SFML($gnu_bodydef_index, $gnu_stand_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $kisi_body_index = _Box2C_b2Body_ArrayAdd_SFML($kisi_bodydef_index, $kisi_stand_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $kit_body_index = _Box2C_b2Body_ArrayAdd_SFML($kit_bodydef_index, $kit_stand_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $pacman_body_index = _Box2C_b2Body_ArrayAdd_SFML($pacman_bodydef_index, $pacman_stand_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $sara_body_index = _Box2C_b2Body_ArrayAdd_SFML($sara_bodydef_index, $sara_stand_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $tux_body_index = _Box2C_b2Body_ArrayAdd_SFML($tux_bodydef_index, $tux_stand_shape_index, 1, 0.2, 1, "", "", "", 0)
;Local $wilbur_body_index = _Box2C_b2Body_ArrayAdd_SFML($wilbur_bodydef_index, $wilbur_stand_shape_index, 1, 0.2, 1, "", "", "", 0)

; Setup the GUI for SFML inside the AutoIT GUI

Local $video_mode = _CSFML_sfVideoMode_Constructor(800, 600, 16)
Global $window_ptr = _CSFML_sfRenderWindow_create($video_mode, "Box2D Angry Nerds Game using the SFML Engine", $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose, Null)
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


		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step($__world_ptr, (0.6 + (UBound($__body_struct_ptr) / 200)) / 60.0, 6, 2)

		; Check for "ESC" key press

		if _CSFML_sfKeyboard_isKeyPressed(36) = True Then

			_Exit()
		EndIf

		; If the "R" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(17) = True Then

			restart_level()

		EndIf

		; If the "Enter" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(58) = True Then

			; Apply a linear force to the player body
			_Box2C_b2Body_ApplyForceAtBody($__body_struct_ptr[$player_body_index], 20, 10)
		EndIf

		; If the "A" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(0) = True Then

			; Apply a leftwards linear force to the player body
;			_Box2C_b2Body_ApplyForceAtBody($__body_struct_ptr[$player_body_index], -8, 0)
		EndIf

		; If the "D" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(3) = True Then

			; Apply a rightwards linear force to the player body
;			_Box2C_b2Body_ApplyForceAtBody($__body_struct_ptr[$player_body_index], 8, 0)
		EndIf

		; If the "W" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(22) = True Then

			; Apply an upwards linear force to the player body
;			_Box2C_b2Body_ApplyForceAtBody($__body_struct_ptr[$player_body_index], 0, 10)
		EndIf

		; While other SFML events
		While _CSFML_sfRenderWindow_pollEvent($window_ptr, $__event_ptr) = True

			Switch DllStructGetData($__event, 1)

				; if the GUI was closed
				Case $CSFML_sfEvtClosed

					_Exit()

				; if a key was pressed

;				Case $CSFML_sfEvtKeyPressed

;					Local $key_code = DllStructGetData($__event, 2)
;					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $key_code = ' & $key_code & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

			EndSwitch
		WEnd

		Local $info_text_string = 	"Keys" & @LF & _
									"----" & @LF & _
									"Press ""A"" to push the crate left with a linear force" & @LF & _
									"Press ""D"" to push the crate right with a linear force" & @LF & _
									"Press ""W"" to push the crate up with a linear force" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"" & @LF & _
									"Stats" & @LF & _
									"-----" & @LF & _
									"Number of bodies = " & UBound($__body_struct_ptr) & @LF & _
									"FPS = " & $fps

		; Animate the frame
		_Box2C_b2World_Animate_SFML($window_ptr, $__white, $info_text_ptr, $info_text_string, 3)

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

Func restart_level()

	; Restart the level, by destroying all bodies from index 2 and re-creating them
	_Box2C_b2Body_DestroyAll_SFML(2)

	; Recreate the bodies for the level
	Switch $level_num

		Case 1

			$player_body_index = _Box2C_b2Body_ArrayAdd_SFML($player_bodydef_index, $earth_ball_shape_index, 1, 0.2, 1, -7, -3.9, degrees_to_radians(0), 0)

			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $cross1_plank_shape_index, 1, 0.2, 1, 1, -4.075, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $cross1_plank_shape_index, 1, 0.2, 1, 3, -4.075, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 0.2, -3.54, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 3.8, -3.54, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2, -3.65, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 1.6, -3, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2.4, -3, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2, -2.36, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 1.1, -2.78, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 2.9, -2.78, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 2, -1.62, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 2, -1.36, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 1.5, -0.5, degrees_to_radians(90), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 2.5, -0.5, degrees_to_radians(90), 2)

			_Box2C_b2Body_ArrayAdd_SFML($enemy_bodydef_index, $droid_stand_shape_index, 1, 0.2, 0.01, 2, -0.73, degrees_to_radians(0), 2)

			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2, 0.65, degrees_to_radians(0), 2)
			_Box2C_b2Body_ArrayAdd_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 2, 1, degrees_to_radians(90), 2)

	EndSwitch

EndFunc

