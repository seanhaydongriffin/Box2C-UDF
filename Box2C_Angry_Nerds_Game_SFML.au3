#include-once
;#include <Array.au3>
#include "Box2CEx.au3"

Global $droid_body_index

; Setup SFML

_Box2C_Setup_SFML()

; Setup SFML sprites / sprite sheets (animated sprites) outside Box2D (for explosions and background etc)
;
;	The sprite_data array has the following elements:
;		0 - texture frame number
; 		1 - texture width
; 		2 - texture height
; 		3 - texture frame rate
; 		4 - number of textures
; 		5 - texture number
; 		6 - sprite x position
; 		7 - sprite y position

Global $active_explosion_sprite_sheet = _CSFML_sfSprite_CreateWithTexture(@ScriptDir & "\explosion_sprite_sheet_80x80.png")
Global $active_explosion_sprite_data[0][8]

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)
;_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -0.0000000)

; Setup the Box2D Shapes
;
; 	_Box2C_b2ShapeArray_AddItem_SFML parameters:
;		#1 - the type of shape being one of the following - $Box2C_e_circle, $Box2C_e_edge, $Box2C_e_polygon, $Box2C_e_chain, $Box2C_e_typeCount
;		#2 - if a type of $Box2C_e_circle the radius of the circle, if a type of $Box2C_e_edge the vertices of the polygon as a two dimensional array
;		#3 - the path and name of the file of the texture / image of the shape

Global $background_shape_vertice[4][2] = [[0,0],[16,0],[16,12],[0,12]]
Global $background_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $background_shape_vertice, @ScriptDir & "\angry_nerds_fence_background.png")
Global $ground_shape_vertice[4][2] = [[0,0],[16,0],[16,2],[0,2]]
Global $ground_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $ground_shape_vertice, @ScriptDir & "\angry_nerds_ground.png")

Global $cross1_plank_shape_vertice[4][2] = [[0,0],[2,0],[2,0.6],[0,0.6]]
Global $cross1_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $cross1_plank_shape_vertice, @ScriptDir & "\angry_nerds_crossed_plank1.png")

Global $box_shape_vertice[4][2] = [[0,0],[1,0],[1,1],[0,1]]
Global $box_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $box_shape_vertice, @ScriptDir & "\angry_nerds_box.png")
Global $triangle_plank_shape_vertice[3][2] = [[0,0],[1,0],[0.5,1]]
Global $triangle_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $triangle_plank_shape_vertice, @ScriptDir & "\angry_nerds_triangle.png")
Global $triangle2_plank_shape_vertice[3][2] = [[0,0],[1,0],[0,1]]
Global $triangle2_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $triangle2_plank_shape_vertice, @ScriptDir & "\angry_nerds_triangle2.png")
Global $circle_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_circle, (1 / 2), @ScriptDir & "\angry_nerds_circle.png")
Global $thick1_plank_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.5],[0,0.5]]
Global $thick1_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $thick1_plank_shape_vertice, @ScriptDir & "\angry_nerds_thick_plank1.png")
Global $thick2_plank_shape_vertice[4][2] = [[0,0],[1,0],[1,0.5],[0,0.5]]
Global $thick2_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $thick2_plank_shape_vertice, @ScriptDir & "\angry_nerds_thick_plank2.png")
Global $thin1_plank_shape_vertice[4][2] = [[0,0],[0.25,0],[0.25,0.25],[0,0.25]]
Global $thin1_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $thin1_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank1.png")
Global $thin2_plank_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.25],[0,0.25]]
Global $thin2_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $thin2_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank2.png")
Global $thin3_plank_shape_vertice[4][2] = [[0,0],[1,0],[1,0.25],[0,0.25]]
Global $thin3_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $thin3_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank3.png")
Global $thin4_plank_shape_vertice[4][2] = [[0,0],[2,0],[2,0.25],[0,0.25]]
Global $thin4_plank_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $thin4_plank_shape_vertice, @ScriptDir & "\angry_nerds_thin_plank4.png")

Global $earth_ball_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_circle, (0.5 / 2), @ScriptDir & "\earth_ball.png")
Global $black_arrow_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.12],[0,0.12]]
Global $black_arrow_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $black_arrow_shape_vertice, @ScriptDir & "\arrow_black.png")
Global $red_arrow_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.12],[0,0.12]]
Global $red_arrow_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $red_arrow_shape_vertice, @ScriptDir & "\arrow_red.png")

Global $droid_shape_margin = 0.26
Global $droid_stand_shape_vertice[4][2] = [[0 + $droid_shape_margin, 0 + $droid_shape_margin],[0.84, 0 + $droid_shape_margin],[0.84, 1.2],[0 + $droid_shape_margin, 1.2]]
Global $droid_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $droid_stand_shape_vertice, @ScriptDir & "\droid_stand.png")

Global $gnu_shape_margin = 0.35
Global $gnu_stand_shape_vertice[4][2] = [[0 + $gnu_shape_margin, 0 + $gnu_shape_margin],[1.12, 0 + $gnu_shape_margin],[1.12, 1.6],[0 + $gnu_shape_margin, 1.6]]
Global $gnu_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $gnu_stand_shape_vertice, @ScriptDir & "\gnu_stand.png")

Global $kisi_shape_margin = 0.35
Global $kisi_stand_shape_vertice[4][2] = [[0 + $kisi_shape_margin, 0 + $kisi_shape_margin],[1.12, 0 + $kisi_shape_margin],[1.12, 1.6],[0 + $kisi_shape_margin, 1.6]]
Global $kisi_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $kisi_stand_shape_vertice, @ScriptDir & "\kisi_stand.png")

Global $kit_shape_margin = 0.35
Global $kit_stand_shape_vertice[4][2] = [[0 + $kit_shape_margin, 0 + $kit_shape_margin],[1.12, 0 + $kit_shape_margin],[1.12, 1.6],[0 + $kit_shape_margin, 1.6]]
Global $kit_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $kit_stand_shape_vertice, @ScriptDir & "\kit_stand.png")

Global $pacman_shape_margin = 0.35
Global $pacman_stand_shape_vertice[4][2] = [[0 + $pacman_shape_margin, 0 + $pacman_shape_margin],[1.12, 0 + $pacman_shape_margin],[1.12, 1.6],[0 + $pacman_shape_margin, 1.6]]
Global $pacman_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $pacman_stand_shape_vertice, @ScriptDir & "\pacman_stand.png")

Global $sara_shape_margin = 0.35
Global $sara_stand_shape_vertice[4][2] = [[0 + $sara_shape_margin, 0 + $sara_shape_margin],[1.12, 0 + $sara_shape_margin],[1.12, 1.6],[0 + $sara_shape_margin, 1.6]]
Global $sara_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $sara_stand_shape_vertice, @ScriptDir & "\sara_stand.png")

Global $tux_shape_margin = 0.35
Global $tux_stand_shape_vertice[4][2] = [[0 + $tux_shape_margin, 0 + $tux_shape_margin],[1.12, 0 + $tux_shape_margin],[1.12, 1.6],[0 + $tux_shape_margin, 1.6]]
Global $tux_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $tux_stand_shape_vertice, @ScriptDir & "\tux_stand.png")

Global $wilbur_shape_margin = 0.35
Global $wilbur_stand_shape_vertice[4][2] = [[0 + $wilbur_shape_margin, 0 + $wilbur_shape_margin],[1.12, 0 + $wilbur_shape_margin],[1.12, 1.6],[0 + $wilbur_shape_margin, 1.6]]
Global $wilbur_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $wilbur_stand_shape_vertice, @ScriptDir & "\wilbur_stand.png")

Global $explosion_shape_vertice[4][2] = [[0,0],[1.6,0],[1.6,1.6],[0,1.6]]
Global $explosion_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $explosion_shape_vertice, @ScriptDir & "\explosion_sprite_sheet_80x80.png")

; Setup the Box2D Body Definitions
;
; 	_Box2C_b2BodyDefArray_AddItem parameters:
;		#1 - the type of body being one of the following - $Box2C_b2_staticBody, $Box2C_b2_kinematicBody or $Box2C_b2_dynamicBody
;		#2 - the body's initial horizontal position (in Box2D world coordinates)
;		#3 - the body's initial vertical position (in Box2D world coordinates)
;		#4 - the body's initial angular position / rotation (in Box2D world coordinates) - use the degrees_to_radians function, as below, if convenient

Global $background_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, 0, 0, 0)
Global $ground_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, 0, -5.4, 0)
Global $player_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, -4, 4, 0)
Global $player_arrow_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_kinematicBody, -4, 4, 0)
Global $plank_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, 4, 4, 0)
Global $enemy_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, 4, 4, 0)


; Setup the Box2D Bodies and SFML Sprites
;
; 	_Box2C_b2BodyArray_AddItem_SFML parameters:
;		#1 - the index to the definition of the body, as given by _Box2C_b2BodyDefArray_AddItem above
;		#2 - the index to the shape of the body, as given by _Box2C_b2PolygonShape_ArrayAdd_SFML and _Box2C_b2CircleShape_ArrayAdd_SFML above
;		#3 - the density of the body
;		#4 - the restitution (bounciness) of the body
;		#5 - the friction of the body - note it's very important for all bodies to have some friction for torque to work on circle shapes!
;		#6 - a flag that indicates what bodies / sprites should do when they go outside the GUI area:
;				0 = do nothing (keep animating)
;				1 = destroy the body / sprite
;				2 = bounce the linear velocity of the body / sprite (like bouncing off a wall)
;				3 = stop the linear velocity of the body / sprite (like hitting a wall)

; Add the background and ensure it is inactive from physics operations
Global $background_body_index = _Box2C_b2BodyArray_AddItem_SFML($background_bodydef_index, $background_shape_index, 0, 0, 1, "", "", "", 0)
_Box2C_b2BodyArray_SetItemActive($background_body_index, False)

; Add the invisible ground body to ensure bodies rest on the ground
Local $ground_body_index = _Box2C_b2BodyArray_AddItem_SFML($ground_bodydef_index, $ground_shape_index, 0, 0, 1, "", "", "", 0)

Global $player_body_index, $player_arrow_body_index, $player_arrow2_body_index, $throwing_ball = False, $throwing_angle, $red_arrow_velocity = 0, $num_throws_left = 1
Global $level_num = 1

; Re-setup the level, such as the positions and attributes of all the bodies
restart_level()

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

Local $texture_rectangle_num
Global $droid_old_velocity

; The animation frame loop
While true


	; Every animation frame (1 / 60th of a second) update the Box2D world

	if _Timer_Diff($frame_timer) > ((1 / 60) * 1000) Then

		$frame_timer = _Timer_Init()


		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step_Ex((0.6 + (_Box2C_b2BodyArray_GetItemCount() / 200)) / 60.0)

		; Check for "ESC" key press

		if _CSFML_sfKeyboard_isKeyPressed(36) = True Then

			_Exit()
		EndIf

		; If the "R" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(17) = True Then

			restart_level()

		EndIf

		; If the "Enter" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(58) = True and $num_throws_left > 0 Then

			Local $arrow1_body_position = _Box2C_b2BodyArray_GetItemPosition($player_arrow_body_index)

			if $throwing_ball = False Then

				$throwing_ball = True
				$red_arrow_velocity = 0

				_Box2C_b2BodyArray_SetItemPosition($player_arrow2_body_index, $arrow1_body_position[0], $arrow1_body_position[1])
				$throwing_angle = _Box2C_b2BodyArray_GetItemAngle($player_arrow_body_index)
				_Box2C_b2BodyArray_SetItemAngle($player_arrow2_body_index, $throwing_angle)
				_Box2C_b2BodyArray_SetItemDraw($player_arrow2_body_index, True)
			EndIf

			; move the red arrow a small distance in the same direction as the black arrow

			Local $arrow2_body_position = _Box2C_b2BodyArray_GetItemPosition($player_arrow2_body_index)
			$red_arrow_velocity = $red_arrow_velocity + 0.001
			Local $tmp_x = $arrow2_body_position[0] + ($red_arrow_velocity * Cos($throwing_angle))
			Local $tmp_y = $arrow2_body_position[1] + ($red_arrow_velocity * Sin($throwing_angle))
			_Box2C_b2BodyArray_SetItemPosition($player_arrow2_body_index, $tmp_x, $tmp_y)

			Local $arrow_distance = _Box2C_b2Vec2_Distance($arrow1_body_position[0], $arrow1_body_position[1], $arrow2_body_position[0], $arrow2_body_position[1])

			if $arrow_distance > 2 Then

				throw_the_ball()
			EndIf

		Else

			if $throwing_ball = True Then

				throw_the_ball()
			EndIf

		EndIf

		; If the "A" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(0) = True Then

			Local $tmp_angle = _Box2C_b2BodyArray_GetItemAngle($player_arrow_body_index)
			$tmp_angle = $tmp_angle + degrees_to_radians(5);
			_Box2C_b2BodyArray_SetItemAngle($player_arrow_body_index, $tmp_angle)
		EndIf

		; If the "D" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(3) = True Then

			Local $tmp_angle = _Box2C_b2BodyArray_GetItemAngle($player_arrow_body_index)
			$tmp_angle = $tmp_angle + degrees_to_radians(-5);
			_Box2C_b2BodyArray_SetItemAngle($player_arrow_body_index, $tmp_angle)
		EndIf

		; If the "W" key is pressed
;		if _CSFML_sfKeyboard_isKeyPressed(22) = True Then

;			$active_explosion_sprite_texture_num[0] = $active_explosion_sprite_texture_num[0] + 0.01
;		EndIf

		; If the "S" key is pressed
;		if _CSFML_sfKeyboard_isKeyPressed(18) = True Then

;		EndIf

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

		Local $filepath = _Box2C_b2ShapeArray_GetItemImagePath_SFML($droid_stand_shape_index)
		Local $droid_velocity = _Box2C_b2BodyArray_GetItemLinearVelocity($droid_body_index)

		if IsString($droid_old_velocity) = True Then

			$droid_old_velocity = $droid_velocity
		EndIf

		Local $change_in_velocity_x = $droid_old_velocity[0] - $droid_velocity[0]
		Local $change_in_velocity_y = $droid_old_velocity[1] - $droid_velocity[1]
	;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $change_in_velocity_y = ' & $change_in_velocity_y & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

		; if the change in velocity is large, from a higher velocity to a lower velocity (i.e. a sudden stop), then destroy the droid
		if (abs($change_in_velocity_x) > 0.5 or abs($change_in_velocity_y) > 4) And StringInStr($filepath, "droid_stand") > 0 Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $change_in_velocity_y = ' & $change_in_velocity_y & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $change_in_velocity_x = ' & $change_in_velocity_x & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


			_Box2C_b2ShapeArray_SetItem_SFML($droid_stand_shape_index, $Box2C_e_edge, $droid_stand_shape_vertice, @ScriptDir & "\droid_dead.png")
;			_Box2C_b2Body_DestroyFixture($__body_struct_ptr[$droid_body_index], $__fixture_struct_ptr[$droid_body_index])
;			$__fixture_struct_ptr[$droid_body_index] = _Box2C_b2World_CreateFixture($__body_struct_ptr[$droid_body_index], $__shape_struct_ptr[$droid_stand_shape_index], 1, 0.2, 0.01)
			_Box2C_b2BodyArray_SetItemImage_SFML($droid_body_index, $droid_stand_shape_index)

			; add an explosion animation
			Local $droid_gui_position = _Box2C_b2BodyArray_GetItemGUIPosition($droid_body_index)
			_CSFML_sfSpriteArray_AddItem($active_explosion_sprite_data, 80, 80, 10, 8, $droid_gui_position[0] - 40, $droid_gui_position[1] - 40)

		EndIf


	;	if Abs($rrr) > 1 Then

	;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $rrr = ' & $rrr & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;	EndIf

		$droid_old_velocity = $droid_velocity

		Local $info_text_string = 	"Keys" & @LF & _
									"----" & @LF & _
									"Press ""A"" or ""D"" to change the throwing angle" & @LF & _
									"Press and hold ""Enter"" to increase the throwing power" & @LF & _
									"Release ""Enter"" to throw the ball" & @LF & _
									"Press ""R"" to restart the level" & @LF & _
									"" & @LF & _
									"Stats" & @LF & _
									"-----" & @LF & _
									"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
									"FPS = " & $fps

;									"X Velocity = " & $droid_old_velocity[0] - velocity[0] & @LF & _

		; Transform all the Box2D bodies to SFML sprites

		_Box2C_b2Body_ArrayTransform_SFML()

		; Draw all Box2D bodies / SFML sprites in the array

		_Box2C_b2Body_ArrayDraw_SFML($window_ptr, $info_text_ptr, $info_text_string, 2)

		; Draw (animate) all regular SFML sprites (sprite sheets), which are outside of Box2D physics

		_CSFML_sfSprite_AnimateSheet($active_explosion_sprite_sheet, $active_explosion_sprite_data)







		; Render all the sprites to the Render Window

		_CSFML_sfRenderWindow_display($window_ptr)



		; Draw and display all the SFML sprites (including background) with information text

;		_Box2C_b2Body_ArrayDrawDisplay_SFML($window_ptr, $info_text_ptr, $info_text_string, 2)

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

Func _CSFML_sfSprite_CreateWithTexture($texture_file_path)

	Local $sprite_sheet_texture = _CSFML_sfTexture_createFromFile($texture_file_path, Null)
	Global $sprite_sheet = _CSFML_sfSprite_create()
	_CSFML_sfSprite_setTexture($sprite_sheet, $sprite_sheet_texture, $CSFML_sfTrue)

	Return $sprite_sheet
EndFunc

Func _CSFML_sfSpriteArray_AddItem(ByRef $active_sprite_data, $texture_width, $texture_height, $texture_frame_rate, $num_textures, $x_position, $y_position)

	; index 0 = texture frame number
	; index 1 = texture width
	; index 2 = texture height
	; index 3 = texture frame rate
	; index 4 = number of textures
	; index 5 = texture number
	; index 6 = sprite x position
	; index 7 = sprite y position

	_ArrayAdd($active_sprite_data, "1|" & $texture_width & "|" & $texture_height & "|" & $texture_frame_rate & "|" & $num_textures & "|1|" & $x_position & "|" & $y_position)
EndFunc

Func _CSFML_sfSprite_AnimateSheet(ByRef $active_sprite_sheet, ByRef $active_sprite_data)

	Local $active_sprite_num = 0

	While True

		if $active_sprite_num > (UBound($active_sprite_data) - 1) Then

			ExitLoop
		EndIf

		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $active_sprite_data[$active_sprite_num][0] = ' & $active_sprite_data[$active_sprite_num][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

		; increment the frame counter
		$active_sprite_data[$active_sprite_num][0] = $active_sprite_data[$active_sprite_num][0] + 1

		Local $sprite_deleted = False

		; if the frame counter has reached the frame rate
		if $active_sprite_data[$active_sprite_num][0] > $active_sprite_data[$active_sprite_num][3] Then

			; reset the frame counter and increment the texture number
			$active_sprite_data[$active_sprite_num][0] = 1
			$active_sprite_data[$active_sprite_num][5] = $active_sprite_data[$active_sprite_num][5] + 1

			; if the texture number has exceeded the number of textures
			if $active_sprite_data[$active_sprite_num][5] > $active_sprite_data[$active_sprite_num][4] Then

				; the animation is done and is to be deleted ...
				_ArrayDelete($active_sprite_data, $active_sprite_num)
				$sprite_deleted = True
			EndIf

		EndIf

		; if the animation isn't done
		if $sprite_deleted = False Then

			; draw it
			_CSFML_sfSprite_setTextureRect($active_sprite_sheet, 1 + ($active_sprite_data[$active_sprite_num][1] * $active_sprite_data[$active_sprite_num][5]), 1, $active_sprite_data[$active_sprite_num][1], $active_sprite_data[$active_sprite_num][2])
			_CSFML_sfSprite_setPosition_xy($active_sprite_sheet, $active_sprite_data[$active_sprite_num][6], $active_sprite_data[$active_sprite_num][7])
			_CSFML_sfRenderWindow_drawSprite($window_ptr, $active_sprite_sheet, Null)

		EndIf

		$active_sprite_num = $active_sprite_num + 1
	WEnd


EndFunc

Func restart_level()

	; Restart the level, by destroying all bodies from index 2 and re-creating them
	_Box2C_b2Body_DestroyAll_SFML(2)

	; Recreate the bodies for the level
	Switch $level_num

		Case 1

			$player_body_index = _Box2C_b2BodyArray_AddItem_SFML($player_bodydef_index, $earth_ball_shape_index, 1, 0.2, 1, -7, 0, degrees_to_radians(0), 0)
			_Box2C_b2BodyArray_SetItemAwake($player_body_index, False)

			$player_arrow2_body_index = _Box2C_b2BodyArray_AddItem_SFML($player_arrow_bodydef_index, $red_arrow_shape_index, 1, 0.2, 1, -6, -0.25, degrees_to_radians(0), 0)
			_Box2C_b2BodyArray_SetItemDraw($player_arrow2_body_index, False)
			$player_arrow_body_index = _Box2C_b2BodyArray_AddItem_SFML($player_arrow_bodydef_index, $black_arrow_shape_index, 1, 0.2, 1, -6, -0.25, degrees_to_radians(0), 0)

			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $cross1_plank_shape_index, 1, 0.2, 1, 1, -4.075, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $cross1_plank_shape_index, 1, 0.2, 1, 3, -4.075, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 0.2, -3.54, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 3.8, -3.54, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2, -3.65, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 1.6, -3, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2.4, -3, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2, -2.36, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 1.1, -2.78, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 2.9, -2.78, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 2, -1.62, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 2, -1.36, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 1.5, -0.5, degrees_to_radians(90), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin4_plank_shape_index, 1, 0.2, 1, 2.5, -0.5, degrees_to_radians(90), 2)

			$droid_body_index = _Box2C_b2BodyArray_AddItem_SFML($enemy_bodydef_index, $droid_stand_shape_index, 1, 0.2, 0.01, 2, -0.73, degrees_to_radians(0), 2)

			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin3_plank_shape_index, 1, 0.2, 1, 2, 0.65, degrees_to_radians(0), 2)
			_Box2C_b2BodyArray_AddItem_SFML($plank_bodydef_index, $thin2_plank_shape_index, 1, 0.2, 1, 2, 1, degrees_to_radians(90), 2)

	EndSwitch

	$num_throws_left = 1
EndFunc

Func throw_the_ball()

	$throwing_ball = False
	$num_throws_left = $num_throws_left - 1

	_Box2C_b2BodyArray_SetItemAngle($player_body_index, $throwing_angle)
	_Box2C_b2BodyArray_ApplyItemDirectionalForceAtBody($player_body_index, $red_arrow_velocity * 3000)

	_Box2C_b2FixtureArray_SetItemSensor($player_arrow_body_index, True)
	_Box2C_b2FixtureArray_SetItemSensor($player_arrow2_body_index, True)
	_Box2C_b2BodyArray_SetItemDraw($player_arrow_body_index, False)
	_Box2C_b2BodyArray_SetItemDraw($player_arrow2_body_index, False)

EndFunc