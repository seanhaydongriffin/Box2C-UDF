#include-once
#include <Math.au3>
#include <File.au3>
;#include <Array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include "Box2CEx.au3"

Global $sprite_filename = @ScriptDir & "\scrolling_sprite_data.txt"
Global $sprite_data
_FileReadToArray($sprite_filename, $sprite_data, 0)

Global $tmp_body_index, $tmp_shape_vertice, $tmp_shape_index
Global $droid_body_index_arr[0], $droid_body_velocity_arr[0][2], $droid_body_old_velocity_arr[0][2]
Global $droid_shape_margin = 0.2
Global $droid_stand_shape_index, $droid_dead_shape_index
Global $you_win_sprite_index

Global $gui_width_pixels = 800
Global $gui_height_pixels = 600
Global $map_width_pixels = 8000
Global $map_height_pixels = 2752

Global $gui_width_metres = $gui_width_pixels / 50
Global $gui_height_metres = $gui_height_pixels / 50
Global $map_width_metres = $map_width_pixels / 50
Global $map_height_metres = $map_height_pixels / 50

;Global $player_x_metres = 0 - ($map_width_metres / 2) + ($gui_width_metres / 2)
;Global $player_y_metres = 0 + ($map_height_metres / 2) - ($gui_height_metres / 2)
Global $player_x_metres = 0 + ($gui_width_metres / 2)
Global $player_y_metres = 0 - ($gui_height_metres / 2)
Global $player_velocity_metres = 0.2

Global $map_texture_rectangle_left
Global $map_texture_rectangle_top
Local $info_text_string, $info_text_num = 1
Global $edited_convex_shape_vertices[0][2], $edited_box2d_vertices[0][2], $edited_convex_shape_ptr, $edited_convex_shape_x, $edited_convex_shape_y, $edited_box2d_first_x, $edited_box2d_first_y
Global $edited_previous_angle = -1, $edited_angle = -1, $edited_total_angles = 0
Global $closest_shape_index_to_mouse
Global $view_centre_pos
Global $mouse_gui_x, $mouse_gui_y, $mouse_box2d_world_x, $mouse_box2d_world_y, $mouse_info

; Setup SQLite

_SQLite_Startup()

_SQLite_Open(@ScriptDir & "\Box2C_scrolling_SFML.sqlite")

; Setup SFML

_Box2C_Setup_SFML()

; Setup SFML sprites / sprite sheets (animated sprites) outside Box2D (for explosions and background etc)
;
;	$__active_sprite_data array elements:
; 		0 = the sprite
;		1 - texture frame number
; 		2 - texture width
; 		3 - texture height
; 		4 - texture frame rate
; 		5 - number of textures
; 		6 - texture number
; 		7 - sprite x position
; 		8 - sprite y position
; 		9 = x movement per frame
; 		10 = x movement multiplier per frame
; 		11 = y movement per frame
; 		12 = y movement multiplier per frame
; 		13 = remove sprite after animation

Global $__active_sprite_data[0][14]

; Setup the Box2D World (no visible gravity because this is a top-down view game)

_Box2C_b2World_Setup(50, 800, 600, 0, 0)

; Setup the Box2D Body Definitions
;
; 	_Box2C_b2BodyDefArray_AddItem parameters:
;		1 - the type of body being one of the following - $Box2C_b2_staticBody, $Box2C_b2_kinematicBody or $Box2C_b2_dynamicBody
;		2 - the body's initial horizontal position (in Box2D world coordinates)
;		3 - the body's initial vertical position (in Box2D world coordinates)
;		4 - the body's initial angular position / rotation (in Box2D world coordinates) - use the degrees_to_radians function, as below, if convenient

Global $background_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, 0, 0, 0)
;Global $ground_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, 0, 0, 0)
Global $ground_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, 0, 0, 0)
Global $player_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, -4, 4, 0, 2, 2)
Global $player_arrow_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_kinematicBody, -4, 4, 0)
Global $plank_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, 4, 4, 0)
Global $enemy_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, 4, 4, 0, 1)

; (Re)setup the level, including the Box2D Shapes and Bodies

Global $player_body_index, $player_arrow_body_index, $player_arrow2_body_index, $throwing_ball = False, $throwing_angle, $red_arrow_velocity = 0, $num_throws_left = 1
Local $level_num = 1
Local $level_complete = False
restart_level($level_num)

_Box2C_b2BodyArray_SetDrawSpriteRange_SFML(0, 99999)
_Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML(-1, -1)

Global $current_density = StringFormat("%4.2f", _Box2C_b2FixtureArray_GetItemDensity($player_body_index))
Global $current_restitution = StringFormat("%4.2f", _Box2C_b2FixtureArray_GetItemRestitution($player_body_index))
Global $current_friction = StringFormat("%4.2f", _Box2C_b2FixtureArray_GetItemFriction($player_body_index))

; Setup the GUI for SFML inside the AutoIT GUI
Local $video_mode = _CSFML_sfVideoMode_Constructor(800, 600, 16)
Global $window_ptr = _CSFML_sfRenderWindow_create($video_mode, "Box2D Angry Nerds Game using the SFML Engine", $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose, Null)
Global $window_hwnd = _CSFML_sfRenderWindow_getSystemHandle($window_ptr)
_CSFML_sfRenderWindow_setVerticalSyncEnabled($window_ptr, False)
Local $info_text_ptr = _CSFML_sfText_create_and_set($__courier_new_font_ptr, 14, $__white, 10, 10)

; Setup the Box2D animation, including the clocks (timers) and animation rate
Global $num_frames = 0
Global $fps = 0
Local $fps_timer = _Timer_SetTimer($window_hwnd, 1000, "update_fps")
Local $frame_timer = _Timer_Init()

;Local $vertex1 = _CSFML_sfVertex_Constructor(0, 0, 255, 255, 255, 255, 0, 0)
;Local $vertex1 = _CSFML_sfVertex_Constructor(0, 0, 255, 255, 255, 255, 0, 0)


;Local $vertex_array = _CSFML_sfVertexArray_Create()
;_CSFML_sfVertexArray_Append($vertex_array, $vertex1)

;Local $convex_shape = _CSFML_sfConvexShape_Create()
;_CSFML_sfConvexShape_setPointCount($convex_shape, 4)
;_CSFML_sfConvexShape_setPoint($convex_shape, 1, 0, 0)
;_CSFML_sfConvexShape_setPoint($convex_shape, 2, 50, 0)
;_CSFML_sfConvexShape_setPoint($convex_shape, 3, 50, 50)
;_CSFML_sfConvexShape_setPoint($convex_shape, 4, 0, 50)
;_CSFML_sfConvexShape_setPosition($convex_shape, 50, 50)




; The animation frame loop
While true


	; Every animation frame (1 / 60th of a second) update the Box2D world

	if _Timer_Diff($frame_timer) > ((1 / 60) * 1000) Then

		$frame_timer = _Timer_Init()


		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step_Ex((0.6 + (_Box2C_b2BodyArray_GetItemCount() / 200)) / 60.0)

		; Get the player's position always, because the world revolves around the player in this game
		Local $player_pos = _Box2C_b2BodyArray_GetItemPosition($player_body_index)
		Local $player_velocity = _Box2C_b2BodyArray_GetItemLinearVelocity($player_body_index)

		; Check for "ESC" key press

		if _CSFML_sfKeyboard_isKeyPressed(36) = True Then

			_Exit()
		EndIf


		; If the "W" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(22) = True Then

			if Abs($player_velocity[1]) < 3 Then

				$player_velocity[1] = $player_velocity[1] - $player_velocity_metres
			Else

				$player_velocity[1] = $player_velocity[1] * 0.99
			EndIf

			_Box2C_b2BodyArray_RotateItemTowardAngle($player_body_index, 270, 0.1)
		EndIf

		; If the "S" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(18) = True Then

			if Abs($player_velocity[1]) < 3 Then

				$player_velocity[1] = $player_velocity[1] + $player_velocity_metres
			Else

				$player_velocity[1] = $player_velocity[1] * 0.99
			EndIf

			_Box2C_b2BodyArray_RotateItemTowardAngle($player_body_index, 90, 0.1)
		EndIf

		; If the "A" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(0) = True Then

			if Abs($player_velocity[0]) < 3 Then

				$player_velocity[0] = $player_velocity[0] - $player_velocity_metres
			Else

				$player_velocity[0] = $player_velocity[0] * 0.99
			EndIf

			_Box2C_b2BodyArray_RotateItemTowardAngle($player_body_index, 180, 0.1)

		EndIf

		; If the "D" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(3) = True Then

			if Abs($player_velocity[0]) < 3 Then

				$player_velocity[0] = $player_velocity[0] + $player_velocity_metres
			Else

				$player_velocity[0] = $player_velocity[0] * 0.99
			EndIf

			_Box2C_b2BodyArray_RotateItemTowardAngle($player_body_index, 0, 0.1)
		EndIf

		; If the "O" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(14) = True Then

			_Box2C_b2BodyArray_SetDrawSpriteRange_SFML(0, 0)
		EndIf

		; If the "P" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(15) = True Then

			_Box2C_b2BodyArray_SetDrawSpriteRange_SFML(0, 99999)
		EndIf

		; If the "K" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(10) = True Then

			_Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML(-1, -1)
		EndIf

		; If the "L" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(11) = True Then

			_Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML(1, 99999)
		EndIf

		; If the "N" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(13) = True Then

			; Game mode
			$info_text_num = 1
		EndIf

		; If the "M" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(12) = True Then

			_Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML(1, 99999)

			; Box2D body edit mode
			$info_text_num = 2
		EndIf

		_Box2C_b2BodyArray_SetItemLinearVelocity($player_body_index, $player_velocity)



		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step_Ex((0.6 + (_Box2C_b2BodyArray_GetItemCount() / 200)) / 60.0)




		; update the player's position with any changes above
		_Box2C_b2BodyArray_SetItemPosition($player_body_index, $player_pos[0], $player_pos[1])

		; While other SFML events
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

						; if backspace was pressed
						case 59

							; if we are in Box2D body edit mode

							if $info_text_num = 2 Then

								_ArrayDelete($edited_convex_shape_vertices, UBound($edited_convex_shape_vertices) - 1)
								_ArrayDelete($edited_box2d_vertices, UBound($edited_box2d_vertices) - 1)

								edited_shape_transform()
							EndIf

						; If the "C" key is pressed
						Case 2

							$info_text_num = 3

						; If the "F" key is pressed
						Case 5

							if $info_text_num = 3 Then

								$info_text_num = 2

								; Move the vertices such that the centroid becomes 0,0
								Local $centroid = _Box2C_b2PolygonShape_MoveToZeroCentroid($edited_box2d_vertices, "%4.2f", $edited_box2d_first_x, $edited_box2d_first_y)

								; Note below that I need to add a small vertical offset of 0.7 metres to the body to ensure it's pixel location is correct in the window
								;	Unsure why at this stage

								$clipboard_str = $centroid[0] & "," & $centroid[1] & "|" & _ArrayToString($edited_box2d_vertices, ",", -1, -1, "|")
								ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $clipboard_str = ' & $clipboard_str & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
							;	ClipPut($clipboard_str)

								_ArrayAdd($sprite_data, $clipboard_str, 0, "", "", 1)
								_FileWriteFromArray($sprite_filename, $sprite_data, Default, Default, "")
							EndIf

					EndSwitch

				; if a mouse button is pressed

				Case $CSFML_sfEvtMouseButtonPressed

					; if we are in Box2D body edit mode

					if $info_text_num = 3 Then

						Local $mouse_data = _CSFML_sfMouseButtonEvent_GetData($__event_ptr)
						$mouse_gui_x = $mouse_data[2]
						ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $mouse_gui_x = ' & $mouse_gui_x & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
						$mouse_gui_y = $mouse_data[3]
						ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $mouse_gui_y = ' & $mouse_gui_y & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
							ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : UBound($edited_convex_shape_vertices) = ' & UBound($edited_convex_shape_vertices) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

						if UBound($edited_convex_shape_vertices) < 1 Then

							$edited_convex_shape_ptr = _CSFML_sfConvexShape_Create()
							ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $edited_convex_shape_ptr = ' & $edited_convex_shape_ptr & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
							$edited_convex_shape_x = $mouse_gui_x
							$edited_convex_shape_y = $mouse_gui_y
							$edited_box2d_first_x = $mouse_gui_x / 50
							$edited_box2d_first_y = ($mouse_gui_y / 50) - 12
						EndIf

						_ArrayAdd($edited_convex_shape_vertices, ($mouse_gui_x - $edited_convex_shape_x) & "|" & ($mouse_gui_y - $edited_convex_shape_y))
						_ArrayAdd($edited_box2d_vertices, (($mouse_gui_x - $edited_convex_shape_x) / 50) & "|" & (($mouse_gui_y - $edited_convex_shape_y) / 50))

						Local $is_convex_and_clockwise = True

						if UBound($edited_box2d_vertices) > 2 Then

							$is_convex_and_clockwise = _Box2C_b2Vec2Array_IsConvexAndClockwise($edited_box2d_vertices)
						EndIf

						if $is_convex_and_clockwise = False Then

							_ArrayDelete($edited_convex_shape_vertices, UBound($edited_convex_shape_vertices) - 1)
							_ArrayDelete($edited_box2d_vertices, UBound($edited_box2d_vertices) - 1)
						EndIf

						edited_shape_transform()

					EndIf

					;if DllStructGetData($__event, 1)

			EndSwitch
		WEnd



		Switch $info_text_num

			; main info
			Case 1

				$info_text_string = 	"Keys" & @LF & _
										"----" & @LF & _
										"Press ""O"" or ""P"" to toggle sprite draw" & @LF & _
										"Press ""K"" or ""L"" to toggle polygon draw" & @LF & _
										"Press ""M"" to edit Box2D bodies" & @LF & _
										"" & @LF & _
										"Stats" & @LF & _
										"-----" & @LF & _
										$mouse_info & @LF & _
										"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
										"Current body density = " & $current_density & @LF & _
										"Current body restitution = " & $current_restitution & @LF & _
										"Current body friction = " & $current_friction & @LF & _
										"FPS = " & $fps

			; edit body info
			Case 2

				$info_text_string = 	"Keys" & @LF & _
										"----" & @LF & _
										"Press ""N"" to stop editing Box2D bodies" & @LF & _
										"Press ""C"" to start creating a new sprite" & @LF & _
										"Press ""U"" to start updating sprite # " & $closest_shape_index_to_mouse & @LF & _
										"" & @LF & _
										"Stats" & @LF & _
										"-----" & @LF & _
										$mouse_info & @LF & _
										"Closest sprite # = " & $closest_shape_index_to_mouse & @LF & _
										"Current convex shape vertices = " & _ArrayToString($edited_box2d_vertices, ",", -1, -1, "|") & @LF & _
										"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
										"Current body density = " & $current_density & @LF & _
										"Current body restitution = " & $current_restitution & @LF & _
										"Current body friction = " & $current_friction & @LF & _
										"FPS = " & $fps

			; creating body info
			Case 3

				$info_text_string = 	"Keys" & @LF & _
										"----" & @LF & _
										"Press ""N"" to stop editing Box2D bodies" & @LF & _
										"Press ""F"" to finish creating the sprite" & @LF & _
										"" & @LF & _
										"Stats" & @LF & _
										"-----" & @LF & _
										$mouse_info & @LF & _
										"Current convex shape vertices = " & _ArrayToString($edited_box2d_vertices, ",", -1, -1, "|") & @LF & _
										"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
										"Current body density = " & $current_density & @LF & _
										"Current body restitution = " & $current_restitution & @LF & _
										"Current body friction = " & $current_friction & @LF & _
										"FPS = " & $fps

			; updating body info
			Case 4

				$info_text_string = 	"Keys" & @LF & _
										"----" & @LF & _
										"Press ""N"" to stop editing Box2D bodies" & @LF & _
										"Press ""F"" to finish updating sprite # " & $closest_shape_index_to_mouse & @LF & _
										"" & @LF & _
										"Stats" & @LF & _
										"-----" & @LF & _
										$mouse_info & @LF & _
										"Current convex shape vertices = " & _ArrayToString($edited_box2d_vertices, ",", -1, -1, "|") & @LF & _
										"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
										"Current body density = " & $current_density & @LF & _
										"Current body restitution = " & $current_restitution & @LF & _
										"Current body friction = " & $current_friction & @LF & _
										"FPS = " & $fps
		EndSwitch

		; set the texture rectangle of the background (the viewing area) to surround the player always (the effect of scrolling)
		Local $player_pos = _Box2C_b2BodyArray_GetItemPosition($player_body_index)

		$view_centre_pos = $player_pos


		if $player_pos[0] < 0 Then

			$player_velocity[0] = 0
			_Box2C_b2BodyArray_SetItemLinearVelocity($player_body_index, $player_velocity)
			$player_pos[0] = 0
			_Box2C_b2BodyArray_SetItemPosition($player_body_index, $player_pos[0], $player_pos[1])
		Else

			if $player_pos[0] < 8 Then

				$view_centre_pos[0] = 8
				$map_texture_rectangle_left = 0
			Else

				if $player_pos[0] > 158 Then

					$player_velocity[0] = 0
					_Box2C_b2BodyArray_SetItemLinearVelocity($player_body_index, $player_velocity)
					$player_pos[0] = 158
					_Box2C_b2BodyArray_SetItemPosition($player_body_index, $player_pos[0], $player_pos[1])
				Else

					if $player_pos[0] > 150 Then

						$view_centre_pos[0] = 150
						$map_texture_rectangle_left = (150 - 8) * 50
					Else

						$map_texture_rectangle_left = ($player_pos[0] * 50) - ($gui_width_pixels / 2)
					EndIf
				EndIf
			EndIf
		EndIf



		if $player_pos[1] < -12 Then

			$player_velocity[1] = 0
			_Box2C_b2BodyArray_SetItemLinearVelocity($player_body_index, $player_velocity)
			$player_pos[1] = -12
			_Box2C_b2BodyArray_SetItemPosition($player_body_index, $player_pos[0], $player_pos[1])
		Else

			if $player_pos[1] < -6 Then

				$view_centre_pos[1] = -6
				$map_texture_rectangle_top = 0
			Else

				if $player_pos[1] > 43 Then

					$player_velocity[1] = 0
					_Box2C_b2BodyArray_SetItemLinearVelocity($player_body_index, $player_velocity)
					$player_pos[1] = 43
					_Box2C_b2BodyArray_SetItemPosition($player_body_index, $player_pos[0], $player_pos[1])
				Else

					if $player_pos[1] > 37 Then

						$view_centre_pos[1] = 37
						$map_texture_rectangle_top = (37 + 6) * 50
					Else

						$map_texture_rectangle_top = ($player_pos[1] * 50) + ($gui_height_pixels / 2)
					EndIf
				EndIf
			EndIf
		EndIf

;		ConsoleWrite($view_centre_pos[0] & "," & $view_centre_pos[1] & @CRLF)

		; the background body / sprite is unique.  it is the only one that must always draw relative / fixed to the player's position, as below
		_CSFML_sfSprite_setTextureRect($__sprite_ptr[0], $map_texture_rectangle_left, $map_texture_rectangle_top, $map_texture_rectangle_left + $gui_width_pixels, $map_texture_rectangle_top + $gui_height_pixels)
		_CSFML_sfSprite_setPosition_xy($__sprite_ptr[0], ($gui_width_pixels / 2), ($gui_height_pixels / 2))

		; Transform all other Box2D bodies (apart from the background) to SFML sprites
		_Box2C_b2BodyArray_ScrollerTransform_SFML($view_centre_pos, $player_body_index)

		; Draw all Box2D bodies / SFML sprites in the array

		_Box2C_b2BodyArray_Draw_SFML($window_ptr, $info_text_ptr, $info_text_string, 2)



		if $info_text_num >= 2 and $info_text_num <= 4 and UBound($edited_convex_shape_vertices) > 2 Then

			_CSFML_sfRenderWindow_drawConvexShape($window_ptr, $edited_convex_shape_ptr, Null)
		EndIf



		; Render all the sprites to the Render Window

		_CSFML_sfRenderWindow_display($window_ptr)

;$window_hwnd

;		_CSFML_sfMouse_getPosition($window_ptr)


		; get the mouse position information

		Local $tPoint2 = _WinAPI_GetMousePos(True, $window_hwnd)
		$mouse_gui_x = DllStructGetData($tPoint2, "X")
		$mouse_gui_y = DllStructGetData($tPoint2, "Y")
		$mouse_box2d_world_x = $view_centre_pos[0] - ((400 - $mouse_gui_x) / 50)
		$mouse_box2d_world_y = $view_centre_pos[1] - ((300 - $mouse_gui_y) / 50)
		$mouse_info = "Mouse GUI pos = " & $mouse_gui_x & "," & $mouse_gui_y & " Box2D pos = " & StringFormat("%4.2f", $mouse_box2d_world_x) & "," & StringFormat("%4.2f", $mouse_box2d_world_y)

		; determine which sprite the mouse is closest to

		if $info_text_num = 2 Then

			$closest_shape_index_to_mouse = -1
			Local $closest_shape_distance = 9999

			for $sprite_num = 0 to (UBound($sprite_data) - 1)

				Local $sprite_pos_delimiter_pos = StringInStr($sprite_data[$sprite_num], "|")
				Local $sprite_pos = StringLeft($sprite_data[$sprite_num], $sprite_pos_delimiter_pos - 1)
				Local $sprite_pos_arr = StringSplit($sprite_pos, ",", 3)

				Local $distance = _Box2C_b2Vec2_Distance($mouse_box2d_world_x, $mouse_box2d_world_y, $sprite_pos_arr[0], $sprite_pos_arr[1])
;				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $distance = ' & $distance & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

				if $distance < $closest_shape_distance Then

					$closest_shape_distance = $distance
					$closest_shape_index_to_mouse = $sprite_num
				EndIf
			Next
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

Func _CSFML_sfSprite_CreateWithTexture($texture_file_path)

	Local $sprite_sheet_texture = _CSFML_sfTexture_createFromFile($texture_file_path, Null)
	Global $sprite_sheet = _CSFML_sfSprite_create()
	_CSFML_sfSprite_setTexture($sprite_sheet, $sprite_sheet_texture, $CSFML_sfTrue)

	Return $sprite_sheet
EndFunc

Func _CSFML_sfSpriteArray_AddItem($sprite_file_path, $texture_width, $texture_height, $texture_frame_rate, $num_textures, $x_position, $y_position, $x_movement = 0, $x_movement_multiplier = 0, $y_movement = 0, $y_movement_multiplier = 0, $remove_after_animation = True)

	; index 0 = the sprite
	; index 1 = texture frame number
	; index 2 = texture width
	; index 3 = texture height
	; index 4 = texture frame rate
	; index 5 = number of textures
	; index 6 = texture number
	; index 7 = sprite x position
	; index 8 = sprite y position
	; index 9 = x movement per frame
	; index 10 = x movement multiplier per frame
	; index 11 = y movement per frame
	; index 12 = y movement multiplier per frame
	; index 13 = remove sprite after animation


	Local $sprite_index = _ArrayAdd($__active_sprite_data, "|1|" & $texture_width & "|" & $texture_height & "|" & $texture_frame_rate & "|" & $num_textures & "|1|" & $x_position & "|" & $y_position & "|" & $x_movement & "|" & $x_movement_multiplier & "|" & $y_movement & "|" & $y_movement_multiplier & "|" & $remove_after_animation)
	$__active_sprite_data[$sprite_index][0] = _CSFML_sfSprite_CreateWithTexture($sprite_file_path)

	Return $sprite_index
EndFunc

Func _CSFML_sfSpriteArray_DeleteItem($sprite_index)

	_CSFML_sfSprite_destroy($__active_sprite_data[$sprite_index][0])
	_ArrayDelete($__active_sprite_data, $sprite_index)
EndFunc

Func _CSFML_sfSpriteArray_DeleteAllItems()

	While UBound($__active_sprite_data) > 0

		_CSFML_sfSpriteArray_DeleteItem(0)
	WEnd

EndFunc

Func _CSFML_sfSpriteArray_Animate()

	Local $active_sprite_num = 0
	Local $sprite_deleted = False

	While True

		if $active_sprite_num > (UBound($__active_sprite_data) - 1) Then

			ExitLoop
		EndIf

		; if there are multiple textures
		if $__active_sprite_data[$active_sprite_num][5] > 0 Then

			; increment the frame counter
			$__active_sprite_data[$active_sprite_num][1] = $__active_sprite_data[$active_sprite_num][1] + 1

			$sprite_deleted = False

			; if the frame counter has reached the frame rate
			if $__active_sprite_data[$active_sprite_num][1] > $__active_sprite_data[$active_sprite_num][4] Then

				; reset the frame counter and increment the texture number
				$__active_sprite_data[$active_sprite_num][1] = 1
				$__active_sprite_data[$active_sprite_num][6] = $__active_sprite_data[$active_sprite_num][6] + 1

				; if the texture number has exceeded the number of textures
				if $__active_sprite_data[$active_sprite_num][6] > $__active_sprite_data[$active_sprite_num][5] Then

					; the animation is done and is to be deleted ...
					_ArrayDelete($__active_sprite_data, $active_sprite_num)
					$active_sprite_num = $active_sprite_num - 1
					$sprite_deleted = True
				EndIf

			EndIf
		EndIf

		; if the animation isn't done
		if $sprite_deleted = False Then

			; draw it

			; if there are multiple textures
			if $__active_sprite_data[$active_sprite_num][5] > 0 Then

				_CSFML_sfSprite_setTextureRect($__active_sprite_data[$active_sprite_num][0], 1 + ($__active_sprite_data[$active_sprite_num][2] * $__active_sprite_data[$active_sprite_num][6]), 1, $__active_sprite_data[$active_sprite_num][2], $__active_sprite_data[$active_sprite_num][3])
			EndIf

			_CSFML_sfSprite_setPosition_xy($__active_sprite_data[$active_sprite_num][0], $__active_sprite_data[$active_sprite_num][7], $__active_sprite_data[$active_sprite_num][8])
			_CSFML_sfRenderWindow_drawSprite($window_ptr, $__active_sprite_data[$active_sprite_num][0], Null)

			; if there is a y movement
			if $__active_sprite_data[$active_sprite_num][11] > 0 Then

				$__active_sprite_data[$active_sprite_num][8] = $__active_sprite_data[$active_sprite_num][8] + $__active_sprite_data[$active_sprite_num][11]
			EndIf

			; if there is a y multiplier
			if $__active_sprite_data[$active_sprite_num][12] > 0 Then

				$__active_sprite_data[$active_sprite_num][11] = $__active_sprite_data[$active_sprite_num][11] * $__active_sprite_data[$active_sprite_num][12]
			EndIf
		EndIf

		$active_sprite_num = $active_sprite_num + 1
	WEnd


EndFunc

Func restart_level($level_num)

	; Restart the level, by destroying all bodies from index 2 and re-creating them
	_Box2C_b2Body_DestroyAll_SFML(0)

	; destroy all shape images / textures

	for $i = 0 to (UBound($__shape_image) - 1)

		_CSFML_sfTexture_destroy($__shape_image[$i])
	Next

	_CSFML_sfSpriteArray_DeleteAllItems()

	; reset the data about droids

	Global $droid_body_index_arr[0], $droid_body_velocity_arr[0][2], $droid_body_old_velocity_arr[0][2]

	; destroy / reset all the shape arrays

	Global $__shape_vertice[0]
	Global $__shape_image[0]
	Global $__shape_image_file_path[0]
	Global $__shape_struct[0]
	Global $__shape_struct_ptr[0]

	; (Re)create the Box2D Shapes
	;
	; 	_Box2C_b2ShapeArray_AddItem_SFML parameters:
	;		#1 - the type of shape being one of the following - $Box2C_e_circle, $Box2C_e_edge, $Box2C_e_polygon, $Box2C_e_chain, $Box2C_e_typeCount
	;		#2 - if a type of $Box2C_e_circle the radius of the circle, if a type of $Box2C_e_edge the vertices of the polygon as a two dimensional array
	;		#3 - the path and name of the file of the texture / image of the shape


	; Add the background and ensure it is inactive from physics operations
	$tmp_body_index = _Box2C_b2BodyArray_AddItem_SFML($background_bodydef_index, _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d("-8,-6|8,-6|8,6|-8,6"), @ScriptDir & "\melden_city_map2.png"), 0, 0, 1, "", "", "", 0, -400, -300)
	_Box2C_b2BodyArray_SetItemActive($tmp_body_index, False)


;			_CSFML_sfSprite_setTextureRect($__sprite_ptr[0], 1, 1, 800, 600)



	; IMPORTANT! -	Always ensure the vertices in the shapes (below) have a centroid of 0,0.
	;				Use the last two parameters of _Box2C_b2BodyArray_AddItem_SFML to position the sprite correctly over the Box2D body.

	$player_x_metres = 0 + ($gui_width_metres / 2)
	$player_y_metres = 0 - ($gui_height_metres / 2)
	Local $earth_ball_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d("-0.25,-0.175|0.25,-0.175|0.25,0.175|-0.25,0.175"), @ScriptDir & "\shooter_player_stand.png")
	$player_body_index = _Box2C_b2BodyArray_AddItem_SFML($player_bodydef_index, $earth_ball_shape_index, 1, 1, 1, $player_x_metres, $player_y_metres, _Radian(0), 0, -15, -10)
	_Box2C_b2BodyArray_SetItemAwake($player_body_index, False)

;3.15,0.99 -3.07,2.39|-3.07,-2.71|-2.61,-2.73|-2.27,-2.15|-2.35,-1.13|-1.89,-0.49|-0.53,-0.49|0.13,-1.23|0.17,-2.01|0.51,-2.45|0.47,-3.27|2.47,-3.27|2.51,-2.47|2.87,-2.17|2.87,0.59|0.83,2.65|-2.03,2.61|-2.31,2.27
;4.71,-4.06 -1.41,0.90|-1.45,0.06|-1.11,-0.20|-1.13,-1.56|-0.65,-1.56|-0.55,-1.30|0.93,-1.28|0.97,-0.40|1.29,-0.14|1.29,0.56|1.61,0.90|1.21,1.40
;4.69,-4.51 -0.91,0.45|0.45,0.41|0.45,-0.87

;	Global $tmp_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d("-0.91,0.45|0.45,0.41|0.45,-0.87"), @ScriptDir & "\empty.png")
;	_ArrayAdd($droid_body_index_arr, _Box2C_b2BodyArray_AddItem_SFML($ground_bodydef_index, $tmp_shape_index, 1, 0.2, 0.01, 4.69,-4.51, _Radian(0), 0, 0, 0))


	for $sprite_num = 0 to (UBound($sprite_data) - 1)

		Local $sprite_pos_delimiter_pos = StringInStr($sprite_data[$sprite_num], "|")
		Local $sprite_pos = StringLeft($sprite_data[$sprite_num], $sprite_pos_delimiter_pos - 1)
		Local $sprite_pos_arr = StringSplit($sprite_pos, ",", 3)
		Local $sprite_vertices = StringMid($sprite_data[$sprite_num], $sprite_pos_delimiter_pos + 1)

		Global $tmp_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d($sprite_vertices), @ScriptDir & "\empty.png")
		_ArrayAdd($droid_body_index_arr, _Box2C_b2BodyArray_AddItem_SFML($ground_bodydef_index, $tmp_shape_index, 1, 0.2, 0.01, Number($sprite_pos_arr[0]), Number($sprite_pos_arr[1]), _Radian(0), 0, 0, 0))

	Next


;	Global $droid_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d("0,0|0.6,0|0.6,1|0,1"), @ScriptDir & "\droid_stand.png")
	Global $droid_stand_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d("-0.3,-0.5|0.3,-0.5|0.3,0.5|-0.3,0.5"), @ScriptDir & "\droid_stand.png")
	_ArrayAdd($droid_body_index_arr, _Box2C_b2BodyArray_AddItem_SFML($enemy_bodydef_index, $droid_stand_shape_index, 1, 0.2, 0.01, 10, -4, _Radian(0), 0, -15, -26))



;	Global $droid_dead_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, _StringSplit2d(0 + $droid_shape_margin & "," & 0 + $droid_shape_margin & "|0.84," & 0 + $droid_shape_margin & "|0.84,1.2|" & 0 + $droid_shape_margin & ",1.2"), @ScriptDir & "\droid_dead.png")

	; (Re)create the Box2D Bodies and SFML Sprites
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

	; Recreate the level-specific bodies






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

Func edited_shape_transform()


	_CSFML_sfConvexShape_setPointCount($edited_convex_shape_ptr, UBound($edited_convex_shape_vertices))

	for $i = 0 to (UBound($edited_convex_shape_vertices) - 1)

		_CSFML_sfConvexShape_setPoint($edited_convex_shape_ptr, $i, $edited_convex_shape_vertices[$i][0], $edited_convex_shape_vertices[$i][1])
	Next

	_CSFML_sfConvexShape_setOrigin($edited_convex_shape_ptr, _CSFML_sfVector2f_Constructor(0, 0))
	_CSFML_sfConvexShape_setFillColor($edited_convex_shape_ptr, _CSFML_sfColor_Constructor(255, 255, 255, 128))
	_CSFML_sfConvexShape_setPosition($edited_convex_shape_ptr, $edited_convex_shape_x, $edited_convex_shape_y)

EndFunc