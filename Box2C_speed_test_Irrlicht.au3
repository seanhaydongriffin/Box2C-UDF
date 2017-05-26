#include ".\au3Irrlicht2.au3"
#include "Box2CEx.au3"

opt("MustDeclareVars", True)
HotKeySet("{ESC}", "_exit")


; Setup Irrlicht

Local $CameraNode ; irr_node
Local $pKeyEvent ; $IRR_KEY_EVENT PTR
Local $keyCode
Local $POS[3] ; single
Local $ROT[3] ; single

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)


; Setup the Box2D Shapes

;Global $platform_shape_vertice[4][2] = [[0,0],[5,0],[5,1],[0,1]]
;Local $platform_shape_index = _Box2C_b2PolygonShape_ArrayAdd($platform_shape_vertice, @ScriptDir & "\platform.gif")

;Global $platform_shape_vertice[4][2] = [[0,0],[10,0],[10,4],[0,4]]
;Local $platform_shape_index = _Box2C_b2PolygonShape_ArrayAdd($platform_shape_vertice, @ScriptDir & "\groundbox.gif")

;Global $crate_shape_vertice[4][2] = [[0,0],[2,0],[2,2],[0,2]]
;Local $crate_shape_index = _Box2C_b2PolygonShape_ArrayAdd($crate_shape_vertice, @ScriptDir & "\crate.gif")

Global $huge_crate_shape_vertice[4][2] = [[0,0],[10,0],[10,10],[0,10]]
Local $huge_crate_shape_index = _Box2C_b2PolygonShape_ArrayAdd_Irrlicht($huge_crate_shape_vertice, @ScriptDir & "\crate.gif")

Global $small_crate_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.5],[0,0.5]]
Local $small_crate_shape_index = _Box2C_b2PolygonShape_ArrayAdd_Irrlicht($small_crate_shape_vertice, @ScriptDir & "\small_crate.gif")

;Global $triangle_shape_vertice[3][2] = [[0,0],[1,0],[0.5,1]]
;Local $triangle_shape_index = _Box2C_b2PolygonShape_ArrayAdd($triangle_shape_vertice, @ScriptDir & "\sporttriangle.gif")

; Setup the Box2D Body Definitions

Local $platform_bodydef_index = _Box2C_b2BodyDefArray_AddItem(0, 0, -13, 0)
Local $platform2_bodydef_index = _Box2C_b2BodyDefArray_AddItem(0, -12, -8, -0.785398)
Local $platform3_bodydef_index = _Box2C_b2BodyDefArray_AddItem(0, +12, -8, +0.785398)
Local $falling_bodydef_index = _Box2C_b2BodyDefArray_AddItem(2, 0, 4, 0)

; Setup the Box2D Bodies

Local $platform_body_index = _Box2C_b2Body_ArrayAdd_Irrlicht($platform_bodydef_index, $huge_crate_shape_index, 0, 0, 0, $huge_crate_shape_vertice, 0, -13)
Local $platform2_body_index = _Box2C_b2Body_ArrayAdd_Irrlicht($platform2_bodydef_index, $huge_crate_shape_index, 0, 0, 0, $huge_crate_shape_index, -12, -8)
Local $platform3_body_index = _Box2C_b2Body_ArrayAdd_Irrlicht($platform3_bodydef_index, $huge_crate_shape_index, 0, 0, 0, $huge_crate_shape_index, -12, -8)
Local $falling_body_index = _Box2C_b2Body_ArrayAdd_Irrlicht($falling_bodydef_index, $small_crate_shape_index, 1, 0.2, 0.3, $small_crate_shape_vertice, 0, 4)




; -----------------------------------------------------------------------------
; start the irrlicht interface
; here we
;_IrrStart( $IRR_EDT_OPENGL, 800, 600, $IRR_BITS_PER_PIXEL_32, _
 ;       $IRR_WINDOWED, $IRR_SHADOWS, $IRR_CAPTURE_EVENTS, $IRR_VERTICAL_SYNC_ON )

_IrrStart( $IRR_EDT_OPENGL, 800, 600, $IRR_BITS_PER_PIXEL_16, $IRR_WINDOWED, $IRR_NO_SHADOWS, $IRR_CAPTURE_EVENTS, $IRR_VERTICAL_SYNC_OFF )

;_IrrStart( $IRR_EDT_DIRECT3D9, 800, 600, $IRR_BITS_PER_PIXEL_16, _
 ;       $IRR_WINDOWED, $IRR_NO_SHADOWS, $IRR_CAPTURE_EVENTS, $IRR_VERTICAL_SYNC_OFF )

; send the window caption
_IrrSetWindowCaption( "Box2C Speed Test for the Irrlicht Engine" )

Local $irr_win_pos = WinGetPos("Box2C Speed Test for the Irrlicht Engine")

Global $g_hGUI = GUICreate("Stats", 200, 400, $irr_win_pos[0] + $irr_win_pos[2], $irr_win_pos[1])
GUICtrlCreateLabel("Press ""A"" to add (drop) a new box / body to the world", 20, 60, 160, 40)
GUICtrlCreateLabel("Press ""Q"" to rotate the center platform anti-clockwise", 20, 100, 160, 40)
GUICtrlCreateLabel("Press ""E"" to rotate the center platform clockwise", 20, 140, 160, 40)
Global $number_of_bodies_label = GUICtrlCreateLabel("Number of bodies = ", 20, 180, 160, 20)
Global $fps_label = GUICtrlCreateLabel("FPS = ", 20, 200, 160, 20)
GUISetState(@SW_SHOW)
WinActivate( "Box2C Speed Test for the Irrlicht Engine" )


local $CameraNode = _IrrAddCamera(0,0,20, 0,0,0 )
_IrrSetCameraOrthagonal($CameraNode, 0, 0, 20)

local $nodeTest[UBound($__body_struct_ptr)]

for $body_num = 0 to (UBound($__body_struct_ptr) - 1)

	if $body_num >= 0 And $body_num <= 2 Then

		$nodeTest[$body_num] = _IrrAddCubeSceneNode(10)
	Else

		$nodeTest[$body_num] = _IrrAddCubeSceneNode(0.5)
	EndIf

	_IrrSetNodeMaterialTexture( $nodeTest[$body_num], _IrrGetTexture(".\au3irr2_logo.jpg"), 0)
	_IrrSetNodeMaterialFlag( $nodeTest[$body_num], $IRR_EMF_LIGHTING, $IRR_OFF )
Next

Local $fps = 0
Local $fps_timer = _Timer_Init()
Local $frame_timer = _Timer_Init()


WHILE _IrrRunning()

	Local $transform_result = False

	; Every second calculate and display the FPS and number of active bodies

	if _Timer_Diff($fps_timer) > 1000 Then

		$fps_timer = _Timer_Init()

		GUICtrlSetData($number_of_bodies_label, "Number of bodies = " & UBound($__body_struct_ptr))
		GUICtrlSetData($fps_label, "FPS = " & $fps)
		$fps = 0
	EndIf

	; Every 60th of a second

	if _Timer_Diff($frame_timer) > ((1 / 60) * 1000) Then

		$frame_timer = _Timer_Init()

		; Animation step

;		_Box2C_b2World_Step($__world_ptr, (1.0 / 60.0), 6, 2)

		; The followsing b2World Step compensates well for a large number of bodies
		_Box2C_b2World_Step($__world_ptr, (0.6 + (UBound($__body_struct_ptr) / 200)) / 60.0, 6, 2)



		; begin the scene, erasing the canvas with sky-blue before rendering
		_IrrBeginScene( 240, 255, 255 )


		Local $extra_rot = 0
		Local $extra_rot_body_num = -1
		Local $added_body = False

		; while there are key events waiting to be processed
		while _IrrKeyEventAvailable()

			$pKeyEvent = _IrrReadKeyEvent()

			; arbitrate based on the key that was pressed
			$keyCode = __getKeyEvt($pKeyEvent, $EVT_KEY_IKEY)
			select

				case $keyCode = $KEY_KEY_E     ; Left Arrow

					; if the key is going down
					if __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN then

						$extra_rot = 5
						$extra_rot_body_num = 0
					endif

				case $keyCode = $KEY_KEY_Q     ; Left Arrow

					; if the key is going down
					if __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN then

						$extra_rot = -5
						$extra_rot_body_num = 0
					endif

				case $keyCode = $KEY_KEY_A     ; Up Arrow

					; if the key is going down
					if __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN then

						Local $new_body_num = _Box2C_b2Body_ArrayAdd_Irrlicht($falling_bodydef_index, $small_crate_shape_index, 1, 0.2, 0.3, $small_crate_shape_vertice, 0, 4)

						_ArrayAdd($nodeTest, Null)
						$nodeTest[$new_body_num] = _IrrAddCubeSceneNode(0.5)
						_IrrSetNodeMaterialTexture( $nodeTest[$new_body_num], _IrrGetTexture(".\au3irr2_logo.jpg"), 0)
						_IrrSetNodeMaterialFlag( $nodeTest[$new_body_num], $IRR_EMF_LIGHTING, $IRR_OFF )

						$added_body = True

					endif

				case $keyCode = $KEY_KEY_D     ; Up Arrow

					; if the key is going down
					if __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN then

						$POS[0] = $POS[0] - 1
					endif

				case $keyCode = $KEY_KEY_W     ; Up Arrow

					; if the key is going down
					if __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN then

						$POS[1] = $POS[1] + 1
					endif

				case $keyCode = $KEY_KEY_S     ; Up Arrow

					; if the key is going down
					if __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN then

						$POS[1] = $POS[1] - 1
					endif

			endselect
		wend


		if $added_body = False Then

			; Transform Bodies

			for $body_num = 0 to (UBound($__body_struct_ptr) - 1)

				Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_num])

				if $body_num > 2 And $body_position[1] < -11 Then

					_Box2C_b2Body_Destroy($body_num)
					_IrrRemoveNode($nodeTest[$body_num])
					_ArrayDelete($nodeTest, $body_num)
					ExitLoop
				EndIf

				_IrrSetNodePosition($nodeTest[$body_num], $body_position[0], $body_position[1], 0)

				if $body_num = $extra_rot_body_num Then

					Local $curr_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$extra_rot_body_num])
					Local $curr_angle_degrees2 = radians_to_degrees($curr_angle)
					$curr_angle_degrees2 = $curr_angle_degrees2 + $extra_rot
					_Box2C_b2Body_SetAngle($__body_struct_ptr[$extra_rot_body_num], degrees_to_radians($curr_angle_degrees2))
				EndIf


				Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_num])
				$body_angle = radians_to_degrees($body_angle)

				if $body_num <> $extra_rot_body_num Then

					$body_angle = $body_angle + $extra_rot
				EndIf

				_IrrSetNodeRotation($nodeTest[$body_num], 0, 0, $body_angle)
	;			_IrrSetNodeRotation($nodeTest[$body_num], 0, 0, 0)

			Next
		EndIf

		_IrrDrawScene()
		_IrrEndScene()
	EndIf

	$fps = $fps + 1

WEND

; -----------------------------------------------------------------------------
; Stop the irrlicht engine and release resources
_IrrStop()

Func _exit()
	_IrrStop()
	Exit
EndFunc ; _exit
