#include-once
#include <Array.au3>
#include "Box2CEx.au3"

; Setup SFML

_Box2C_Setup_SFML()

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)

; Setup the Box2D Shapes
;
; 	_Box2C_b2Shape_ArrayAdd_SFML parameters:
;		#1 - the type of shape being one of the following - $Box2C_e_circle, $Box2C_e_edge, $Box2C_e_polygon, $Box2C_e_chain, $Box2C_e_typeCount
;		#2 - if a type of $Box2C_e_circle the radius of the circle, if a type of $Box2C_e_edge the vertices of the polygon as a two dimensional array
;		#3 - the path and name of the file of the texture / image of the shape

Global $girder_shape_vertice[4][2] = [[0,0],[11,0],[11,1],[0,1]]
Global $girder_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $girder_shape_vertice, @ScriptDir & "\girder.png")
Global $crate_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.5],[0,0.5]]
Global $crate_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_edge, $crate_shape_vertice, @ScriptDir & "\small_crate.gif")
Global $eight_ball_shape_index = _Box2C_b2ShapeArray_AddItem_SFML($Box2C_e_circle, (0.5 / 2), @ScriptDir & "\eight_ball_small.png")

; Setup the Box2D Body Definitions
;
; 	_Box2C_b2BodyDef_ArrayAdd parameters:
;		#1 - the type of body being one of the following - $Box2C_b2_staticBody, $Box2C_b2_kinematicBody or $Box2C_b2_dynamicBody
;		#2 - the body's initial horizontal position (in Box2D world coordinates)
;		#3 - the body's initial vertical position (in Box2D world coordinates)
;		#4 - the body's initial angular position / rotation (in Box2D world coordinates) - use the degrees_to_radians function, as below, if convenient

Global $girder1_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, -2, 2, degrees_to_radians(-5))
Global $girder2_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, 2, -1, degrees_to_radians(10))
Global $girder3_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_staticBody, -2, -4, degrees_to_radians(-5))
Global $player_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, 0, 4, 0)
Global $enemy_bodydef_index = _Box2C_b2BodyDefArray_AddItem($Box2C_b2_dynamicBody, -2, 4, 0)

; Setup the Box2D Bodies and SFML Sprites
;
; 	_Box2C_b2Body_ArrayAdd_SFML parameters:
;		#1 - the index to the definition of the body, as given by _Box2C_b2BodyDef_ArrayAdd above
;		#2 - the index to the shape of the body, as given by _Box2C_b2PolygonShape_ArrayAdd_SFML and _Box2C_b2CircleShape_ArrayAdd_SFML above
;		#3 - the density of the body
;		#4 - the restitution (bounciness) of the body
;		#5 - the friction of the body - note it's very important for all bodies to have some friction for torque to work on circle shapes!
;		#6 - the index of the shape containing the vertices for the body
;		#7 - the body's initial horizontal position (in Box2D world coordinates)
;		#8 - the body's initial vertical position (in Box2D world coordinates)
;		#9 - a flag that indicates what bodies / sprites should do when they go outside the GUI area:
;				0 = do nothing (keep animating)
;				1 = destroy the body / sprite
;				2 = bounce the linear velocity of the body / sprite (like bouncing off a wall)
;				3 = stop the linear velocity of the body / sprite (like hitting a wall)

Local $girder1_body_index = _Box2C_b2BodyArray_AddItem_SFML($girder1_bodydef_index, $girder_shape_index, 0, 0, 1, "", "", "", 0)
Local $girder2_body_index = _Box2C_b2BodyArray_AddItem_SFML($girder2_bodydef_index, $girder_shape_index, 0, 0, 1, "", "", "", 0)
Local $girder3_body_index = _Box2C_b2BodyArray_AddItem_SFML($girder3_bodydef_index, $girder_shape_index, 0, 0, 1, "", "", "", 0)
Local $player_body_index = _Box2C_b2BodyArray_AddItem_SFML($player_bodydef_index, $crate_shape_index, 1, 0.2, 1, "", "", "", 2)

; Setup the GUI for SFML inside the AutoIT GUI

Local $video_mode = _CSFML_sfVideoMode_Constructor(800, 600, 16)
Global $window_ptr = _CSFML_sfRenderWindow_create($video_mode, "Box2D Linear Forces Test for the SFML Engine", $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose, Null)
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

		; randomly add enemies to the world
		if Random(1, 500, 1) = 1 Then

			_Box2C_b2BodyArray_AddItem_SFML($enemy_bodydef_index, $eight_ball_shape_index, 1, 0.2, 1, "", "", "", 1)
		EndIf


		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step_Ex((0.6 + (UBound($__body_struct_ptr) / 200)) / 60.0)

		; Check for "ESC" key press

		if _CSFML_sfKeyboard_isKeyPressed(36) = True Then

			_Exit()
		EndIf

		; If the "A" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(0) = True Then

			; Apply a leftwards linear force to the player body
			_Box2C_b2BodyArray_ApplyItemForceAtBody($player_body_index, -8, 0)
		EndIf

		; If the "D" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(3) = True Then

			; Apply a rightwards linear force to the player body
			_Box2C_b2BodyArray_ApplyItemForceAtBody($player_body_index, 8, 0)
		EndIf

		; If the "W" key is pressed
		if _CSFML_sfKeyboard_isKeyPressed(22) = True Then

			; Apply an upwards linear force to the player body
			_Box2C_b2BodyArray_ApplyItemForceAtBody($player_body_index, 0, 10)
		EndIf

		; While other SFML events
		While _CSFML_sfRenderWindow_pollEvent($window_ptr, $__event_ptr) = True

			Switch DllStructGetData($__event, 1)

				; if the GUI was closed
				Case $CSFML_sfEvtClosed

					_Exit()
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
									"Number of bodies = " & _Box2C_b2BodyArray_GetItemCount() & @LF & _
									"FPS = " & $fps

		; Transform all the Box2D bodies to SFML sprites

		_Box2C_b2BodyArray_Transform_SFML()

		; Clear the animation frame

		_CSFML_sfRenderWindow_clear($window_ptr, $__white)

		; Draw and display all the SFML sprites (including background) with information text

		_Box2C_b2Body_ArrayDrawDisplay_SFML($window_ptr, $info_text_ptr, $info_text_string, 2)

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
