
; #INDEX# =======================================================================================================================
; Title .........: Box2C
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Box2D Functions using the Box2C library
; Author(s) .....: Sean Griffin
; Dlls ..........: Box2C.dll
; ===============================================================================================================================

;#include-once
;#include <Array.au3>

; #VARIABLES# ===================================================================================================================
Global $__Box2C_Box2C_DLL = -1
Global $__position = -1
Global $__position_ptr = -1
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__epsilon = 0.00001
Global Enum $Box2C_b2_staticBody, $Box2C_b2_kinematicBody, $Box2C_b2_dynamicBody
Global Enum $Box2C_e_circle, $Box2C_e_edge, $Box2C_e_polygon, $Box2C_e_chain, $Box2C_e_typeCount
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Box2C_Startup
; _Box2C_Shutdown
; _Box2C_b2Vec2_Constructor
; _Box2C_b2Vec2_Length
; _Box2C_b2Vec2_Distance
; _Box2C_b2World_Constructor
; _Box2C_b2World_CreateBody
; _Box2C_b2World_DestroyBody
; _Box2C_b2World_CreateFixture
; _Box2C_b2World_CreateFixtureFromShape
; _Box2C_b2World_Step
; _Box2C_b2BoxShape_Constructor
; _Box2C_b2CircleShape_Constructor
; _Box2C_b2PolygonShape_Constructor
; _Box2C_b2PolygonShape_Set
; _Box2C_b2PolygonShape_CrossProductVectorScalar
; _Box2C_b2PolygonShape_CrossProductVectorVector
; _Box2C_b2PolygonShape_Normalize
; _Box2C_b2PolygonShape_ComputeCentroid
; _Box2C_b2BodyDef_Constructor
; _Box2C_b2Body_DestroyFixture
; _Box2C_b2Body_GetPosition
; _Box2C_b2Body_SetPosition
; _Box2C_b2Body_GetAngle
; _Box2C_b2Body_SetAngle
; _Box2C_b2Body_SetAwake
; _Box2C_b2Body_SetTransform
; _Box2C_b2Body_GetLinearVelocity
; _Box2C_b2Body_SetLinearVelocity
; _Box2C_b2Body_GetAngularVelocity
; _Box2C_b2Body_SetAngularVelocity
; _Box2C_b2Body_ApplyForce
; _Box2C_b2Body_ApplyForceAtBody
; _Box2C_b2Body_ApplyDirectionalForceAtBody
; _Box2C_b2Body_ApplyTorque
; _Box2C_b2Fixture_GetShape
; _Box2C_b2Fixture_GetDensity
; _Box2C_b2Fixture_SetDensity
; _Box2C_b2Fixture_GetRestitution
; _Box2C_b2Fixture_SetRestitution
; _Box2C_b2Fixture_GetFriction
; _Box2C_b2Fixture_SetFriction
; _Box2C_b2Fixture_SetSensor
; ===============================================================================================================================


; #MISCELLANEOUS FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_Startup
; Description ...: Loads the Box2C DLL, and sets up other internal variables
; Syntax.........: _Box2C_Startup($Box2CDLL)
; Parameters ....: $Box2CDLL - the filename of the Box2C System DLL
; Return values .: True - DLLs loaded successfully
;                  False - DLL load failed
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _Box2C_Shutdown
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_Startup($Box2CDLL = "Box2C.dll")

	$__position = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	$__position_ptr = DllStructGetPtr($__position)

	If $__Box2C_Box2C_DLL >= 0 Then Return 1

	$__Box2C_Box2C_DLL = DllOpen($Box2CDLL)

	Return $__Box2C_Box2C_DLL >= 0
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_Shutdown
; Description ...: Unloads the Box2D DLLs
; Syntax.........: _Box2C_Shutdown()
; Parameters ....:
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _Box2C_Startup
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_Shutdown()

	DllClose($__Box2C_Box2C_DLL)
EndFunc


; #B2VEC2 FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2_Constructor
; Description ...: Constructs a b2Vec2 structure.
; Syntax.........: _Box2C_b2Vec2_Constructor($x, $y)
; Parameters ....: $x - horizontal component (pixel position) of the vector.
;				   $y - vertical component (pixel position) of the vector.
; Return values .: Success - the b2Vec2 structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Vec2_Constructor($x = 0, $y = 0)

	local $b2Vec2 = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2Vec2, 1, $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2Vec2, 2, $y)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $b2Vec2
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2_Length
; Description ...: Gets the length of a vector.
; Syntax.........: _Box2C_b2Vec2_Length($x, $y)
; Parameters ....: $x - horizontal component (pixel position) of the vector
;				   $y - vertical component (pixel position) of the vector
; Return values .: Success - the length of the vector
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Vec2_Length($x, $y)

	Return Sqrt($x * $x + $y * $y)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2_Distance
; Description ...: Gets the distance between two vectors.
; Syntax.........: _Box2C_b2Vec2_Distance($x1, $y1, $x2, $y2)
; Parameters ....: $x1 - horizontal component (pixel position) of the vector
;				   $y1 - vertical component (pixel position) of the vector
;				   $x2 - horizontal component (pixel position) of the vector
;				   $y3 - vertical component (pixel position) of the vector
; Return values .: Success - the length of the vector
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Vec2_Distance($x1, $y1, $x2, $y2)

	Return Sqrt((($x1 - $x2) * ($x1 - $x2)) + (($y1 - $y2) * ($y1 - $y2)))
EndFunc


; #B2WORLD FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_Constructor
; Description ...: Constructs a b2World structure.
; Syntax.........: _Box2C_b2World_Constructor($gravity, $doSleep)
; Parameters ....: $gravity - gravity
;				   $doSleep - ?
; Return values .: Success - a pointer (PTR) to the b2World structure (PTR).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Constructor($gravity, $doSleep = True)

	Local $world = DllCall($__Box2C_Box2C_DLL, "PTR:cdecl", "b2world_constructor", "STRUCT", $gravity, "BOOL", $doSleep)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $world_ptr = $world[0]
	Return $world_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_CreateBody
; Description ...: Creates a body in a world from a body definition
; Syntax.........: _Box2C_b2World_CreateBody($world_ptr, $bodyDef_ptr)
; Parameters ....: $world_ptr - a pointer (PTR) to the world (b2World) to create the body within
;				   $bodyDef_ptr - a pointer (PTR) to the definition of the body (b2BodyDef)
; Return values .: Success - a pointer (PTR) to the body (b2Body) structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_CreateBody($world_ptr, $bodyDef_ptr)

	Local $body = DllCall($__Box2C_Box2C_DLL, "PTR:cdecl", "b2world_createbody", "PTR", $world_ptr, "PTR", $bodyDef_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $body_ptr = $body[0]
	Return $body_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_DestroyBody
; Description ...: Destroys / removes a body from a world
; Syntax.........: _Box2C_b2World_DestroyBody($world_ptr, $bodyDef_ptr)
; Parameters ....: $world_ptr - a pointer (PTR) to the world (b2World) to remove the body from
;				   $body_ptr - a pointer (PTR) to the body (b2Body) to remove
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_DestroyBody($world_ptr, $body_ptr)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2world_destroybody", "PTR", $world_ptr, "PTR", $body_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_CreateFixture
; Description ...: Creates a fixture for a shape and body combination
; Syntax.........: _Box2C_b2World_CreateFixture($body_ptr, $shape_ptr, $density, $restitution, $friction, $filter_category_bits, $filter_mask_bits, $filter_group_index, $is_sensor, $user_data)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $shape_ptr - a pointer to the shape (b2...)
;				   $density -
;				   $restitution -
;				   $friction -
;				   $filter_category_bits -
;				   $filter_mask_bits -
;				   $filter_group_index -
;				   $is_sensor -
;				   $user_data -
; Return values .: Success - a pointer (PTR) to the fixture (b2Fixture) structure
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_CreateFixture($body_ptr, $shape_ptr, $density, $restitution, $friction, $filter_category_bits = 1, $filter_mask_bits = 65535, $filter_group_index = 0, $is_sensor = False, $user_data = Null)

	local $fixture_ptr = _Box2C_b2World_CreateFixtureFromShape($body_ptr, $shape_ptr, $density)

;	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setdensity", "PTR", $fixture_ptr, "FLOAT", 1)
	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setrestitution", "PTR", $fixture_ptr, "FLOAT", $restitution)
	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setfriction", "PTR", $fixture_ptr, "FLOAT", $friction)

	local $dynamicBox_fixture_filter = DllStructCreate("STRUCT;ushort;ushort;short;ENDSTRUCT")
	DllStructSetData($dynamicBox_fixture_filter, 1, $filter_category_bits)
	DllStructSetData($dynamicBox_fixture_filter, 2, $filter_mask_bits)
	DllStructSetData($dynamicBox_fixture_filter, 3, $filter_group_index)
	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setfilterdata", "PTR", $fixture_ptr, "STRUCT", $dynamicBox_fixture_filter)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setsensor", "PTR", $fixture_ptr, "BOOL", $is_sensor)
	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setuserdata", "PTR", $fixture_ptr, "PTR", $user_data)

	Return $fixture_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_CreateFixtureFromShape
; Description ...: Creates a fixture for a shape and body combination
; Syntax.........: _Box2C_b2World_CreateFixtureFromShape($body_ptr, $shape_ptr, $density)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $shape_ptr - a pointer to the shape (b2...)
;				   $density -
; Return values .: Success - a pointer (PTR) to the fixture (b2Fixture) structure
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_CreateFixtureFromShape($body_ptr, $shape_ptr, $density)

	Local $fixture = DllCall($__Box2C_Box2C_DLL, "PTR:cdecl", "b2body_createfixturefromshape", "PTR", $body_ptr, "PTR", $shape_ptr, "FLOAT", $density)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $fixture_ptr = $fixture[0]
	Return $fixture_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_Step
; Description ...: Creates a fixture for a shape and body combination
; Syntax.........: _Box2C_b2World_Step($world_ptr, $timeStep, $velocityIterations, $positionIterations)
; Parameters ....: $world_ptr - a pointer to the body (b2Body)
;				   $timeStep - a pointer to the shape (b2...)
;				   $velocityIterations -
;				   $positionIterations -
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Step($world_ptr, $timeStep, $velocityIterations, $positionIterations)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2world_step", "PTR", $world_ptr, "FLOAT", $timeStep, "INT", $velocityIterations, "INT", $positionIterations)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc



; #B2POLYGONSHAPE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BoxShape_Constructor
; Description ...: Constructs a b2PolygonShape structure for a box shape.
; Syntax.........: _Box2C_b2BoxShape_Constructor($shape_width, $shape_height)
; Parameters ....: $shape_width -
;				   $shape_height -
; Return values .: Success - the b2PolygonShape structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BoxShape_Constructor($shape_width, $shape_height)

	$shape_half_width_neg = 0 - ($shape_width / 2)
	$shape_half_width_pos = 0 + ($shape_width / 2)
	$shape_half_height_neg = 0 - ($shape_height / 2)
	$shape_half_height_pos = 0 + ($shape_height / 2)

	local $polygon_shape_portable = DllStructCreate("STRUCT;int;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;int;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	; cb2polygonshapeportable for a box shape as follows.
	; m_shape ...
	DllStructSetData($polygon_shape_portable, 1, 1)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 2, 0.01)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_centroid ...
	DllStructSetData($polygon_shape_portable, 3, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 4, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_vertices ...
	DllStructSetData($polygon_shape_portable, 5, $shape_half_width_neg)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 6, $shape_half_height_neg)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 7, $shape_half_width_pos)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 8, $shape_half_height_neg)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 9, $shape_half_width_pos)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 10, $shape_half_height_pos)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 11, $shape_half_width_neg)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 12, $shape_half_height_pos)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 13, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 14, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 15, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 16, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 17, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 18, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 19, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 20, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_normals ...
	DllStructSetData($polygon_shape_portable, 21, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 22, -1)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 23, 1)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 24, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 25, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 26, 1)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 27, -1)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 28, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 29, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 30, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 31, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 32, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 33, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 34, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 35, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 36, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_vertexCount ...
	DllStructSetData($polygon_shape_portable, 37, 4)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $polygon_shape_portable

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2CircleShape_Constructor
; Description ...: Constructs a b2PolygonShape structure.
; Syntax.........: _Box2C_b2CircleShape_Constructor($radius)
; Parameters ....: $radius - the radius of the circle to construct
; Return values .: Success - the b2PolygonShape structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2CircleShape_Constructor($radius)

	local $polygon_shape_portable = DllStructCreate("STRUCT;int;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;int;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	; cb2polygonshapeportable for a circle shape as follows.
	; m_shape ...
	DllStructSetData($polygon_shape_portable, 1, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 2, $radius)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_centroid ...
	DllStructSetData($polygon_shape_portable, 3, $radius)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 4, -$radius)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_vertices ...
	DllStructSetData($polygon_shape_portable, 5, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 6, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 7, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 8, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 9, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 10, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 11, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 12, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 13, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 14, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 15, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 16, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 17, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 18, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 19, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 20, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_normals  ...
	DllStructSetData($polygon_shape_portable, 21, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 22, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 23, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 24, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 25, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 26, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 27, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 28, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 29, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 30, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 31, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 32, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 33, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 34, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 35, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 36, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_vertexCount ...
	DllStructSetData($polygon_shape_portable, 37, 4)
	If @error > 0 Then Return SetError(@error,0,0)

;	_Box2C_b2PolygonShape_Set(DllStructGetPtr($polygon_shape_portable), $vertices)

	Return $polygon_shape_portable

EndFunc



; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_Constructor
; Description ...: Constructs a b2PolygonShape structure.
; Syntax.........: _Box2C_b2PolygonShape_Constructor($vertices)
; Parameters ....: $vertices - the vertices of the polygon to construct
; Return values .: Success - the b2PolygonShape structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_Constructor($vertices)

	local $polygon_shape_portable = DllStructCreate("STRUCT;int;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;int;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	; cb2polygonshapeportable for a box shape as follows.
	; m_shape ...
	DllStructSetData($polygon_shape_portable, 1, 1)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 2, 0.01)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_centroid ...
	DllStructSetData($polygon_shape_portable, 3, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 4, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_vertices ...
	DllStructSetData($polygon_shape_portable, 5, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 6, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 7, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 8, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 9, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 10, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 11, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 12, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 13, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 14, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 15, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 16, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 17, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 18, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 19, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 20, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_normals  ...
	DllStructSetData($polygon_shape_portable, 21, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 22, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 23, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 24, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 25, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 26, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 27, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 28, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 29, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 30, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 31, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 32, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 33, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 34, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 35, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($polygon_shape_portable, 36, 0)
	If @error > 0 Then Return SetError(@error,0,0)

	; m_vertexCount ...
	DllStructSetData($polygon_shape_portable, 37, 4)
	If @error > 0 Then Return SetError(@error,0,0)

	_Box2C_b2PolygonShape_Set(DllStructGetPtr($polygon_shape_portable), $vertices)

	Return $polygon_shape_portable

EndFunc



; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_Set
; Description ...: Creates a fixture for a shape and body combination
; Syntax.........: _Box2C_b2PolygonShape_Set($polygon_shape_portable_ptr, $vertices)
; Parameters ....: $polygon_shape_portable_ptr - a pointer to the body (b2Body)
;				   $vertices - a pointer to the shape (b2...)
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: There is no return value for this function.  It simply repopulates the structure pointed to by $polygon_shape_portable_ptr
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_Set($polygon_shape_portable_ptr, $vertices)

	local $polygon_shape_portable = DllStructCreate("STRUCT;int;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;float;int;ENDSTRUCT", $polygon_shape_portable_ptr)
	Local $normals[UBound($vertices)][2]

	Local $polygon_shape_portable_element_num
	Local $vertice_num = -1

	; Compute the polygon centroid.

	Local $centroid = _Box2C_b2PolygonShape_ComputeCentroid($vertices)

	DllStructSetData($polygon_shape_portable, 3, $centroid[0])
	DllStructSetData($polygon_shape_portable, 4, $centroid[1])


	; Shift the shape, meaning it's center and therefore it's centroid, to the world position of 0,0, such that rotations and calculations are easier

	for $vertice_num = 0 to (UBound($vertices) - 1)

		$vertices[$vertice_num][0] = $vertices[$vertice_num][0] - $centroid[0]
		$vertices[$vertice_num][1] = $vertices[$vertice_num][1] - $centroid[1]
	Next


	$polygon_shape_portable_element_num = 4

	for $vertice_num = 0 to (UBound($vertices) - 1)

		$polygon_shape_portable_element_num = $polygon_shape_portable_element_num + 1
		DllStructSetData($polygon_shape_portable, $polygon_shape_portable_element_num, $vertices[$vertice_num][0])
		$polygon_shape_portable_element_num = $polygon_shape_portable_element_num + 1
		DllStructSetData($polygon_shape_portable, $polygon_shape_portable_element_num, $vertices[$vertice_num][1])
	Next

	; Compute normals. Ensure the edges have non-zero length.

	$polygon_shape_portable_element_num = 20

	for $i = 0 to (UBound($vertices) - 1)

		Local $i1 = $i
		Local $i2 = 0

		if ($i + 1) < UBound($vertices) Then

			$i2 = $i + 1
		EndIf

		Local $edge_x = $vertices[$i2][0] - $vertices[$i1][0]
		Local $edge_y = $vertices[$i2][1] - $vertices[$i1][1]

		Local $edge_cross = _Box2C_b2PolygonShape_CrossProductVectorScalar($edge_x, $edge_y, 1)

		$normals[$i][0] = $edge_cross[0]
		$normals[$i][1] = $edge_cross[1]

		Local $normal_normalised = _Box2C_b2PolygonShape_Normalize($normals[$i][0], $normals[$i][1])

		$polygon_shape_portable_element_num = $polygon_shape_portable_element_num + 1
		DllStructSetData($polygon_shape_portable, $polygon_shape_portable_element_num, $normal_normalised[0])
		$polygon_shape_portable_element_num = $polygon_shape_portable_element_num + 1
		DllStructSetData($polygon_shape_portable, $polygon_shape_portable_element_num, $normal_normalised[1])

;		$normals[$i][0] = $normal_normalised[0]
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $normals[$i][0] = ' & $normals[$i][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;		$normals[$i][1] = $normal_normalised[1]
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $normals[$i][1] = ' & $normals[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Next


	; Vertex Count

	DllStructSetData($polygon_shape_portable, 37, UBound($vertices))


;	for $i = 0 to (UBound($vertices) - 1)

;		_internalPolyShape.m_vertices[i] = verts[i];
;		_internalPolyShape.m_normals[i] = normals[i];
;	Next

;	VertexCount = verts.Length;


EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_CrossProductVectorScalar
; Description ...:
; Syntax.........: _Box2C_b2PolygonShape_CrossProductVectorScalar($x, $y, $s)
; Parameters ....: $x -
;				   $y -
;				   $s -
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_CrossProductVectorScalar($x, $y, $s)

	Local $vector[2]

	$vector[0] = $s * $y
	$vector[1] = -$s * $x

	Return $vector
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_CrossProductVectorVector
; Description ...:
; Syntax.........: _Box2C_b2PolygonShape_CrossProductVectorVector($x1, $y1, $x2, $y2)
; Parameters ....: $x1 -
;				   $y1 -
;				   $x2 -
;				   $y2 -
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_CrossProductVectorVector($x1, $y1, $x2, $y2)

	Return $x1 * $y2 - $y1 * $x2
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_Normalize
; Description ...:
; Syntax.........: _Box2C_b2PolygonShape_Normalize($x, $y)
; Parameters ....: $x -
;				   $y -
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_Normalize($x, $y)

	Local $vector[2]

	Local $length = _Box2C_b2Vec2_Length($x, $y)

	if $length < $__epsilon Then

		Return 0;
	EndIf

	Local $invLength = 1 / $length

	$vector[0] = $x * $invLength
	$vector[1] = $y * $invLength

	Return $vector
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_ComputeCentroid
; Description ...:
; Syntax.........: _Box2C_b2PolygonShape_ComputeCentroid($vertices)
; Parameters ....: $x -
;				   $y -
; Return values .: A vector (2D element array) of the centroid of the vertices
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_ComputeCentroid($vertices)

	Local $centroid[2]
	Local $area = 0

	if UBound($vertices) = 2 Then

		$centroid[0] = 0.5 * ($vertices[0][0] + $vertices[1][0])
		$centroid[1] = 0.5 * ($vertices[0][1] + $vertices[1][1])
	EndIf

	; pRef is the reference point for forming triangles.
	; It's location doesn't change the result (except for rounding error).

	Local $pRef_x, $pRef_y
	Local $inv3 = 1 / 3

	for $i = 0 to (UBound($vertices) - 1)

		Local $p1_x = $pRef_x
		Local $p1_y = $pRef_y
		Local $p2_x = $vertices[$i][0]
		Local $p2_y = $vertices[$i][1]
		Local $p3_x, $p3_y

		if ($i + 1) < UBound($vertices) Then

			$p3_x = $vertices[$i + 1][0]
			$p3_y = $vertices[$i + 1][1]
		Else

			$p3_x = $vertices[0][0]
			$p3_y = $vertices[0][1]
		EndIf

		Local $e1_x = $p2_x - $p1_x
		Local $e1_y = $p2_y - $p1_y
		Local $e2_x = $p3_x - $p1_x
		Local $e2_y = $p3_y - $p1_y

		Local $D = _Box2C_b2PolygonShape_CrossProductVectorVector($e1_x, $e1_y, $e2_x, $e2_y)

		Local $triangleArea = 0.5 * $D
		$area = $area + $triangleArea

		; Area weighted centroid
		$centroid[0] = $centroid[0] + ($triangleArea * $inv3 * ($p1_x + $p2_x + $p3_x));
		$centroid[1] = $centroid[1] + ($triangleArea * $inv3 * ($p1_y + $p2_y + $p3_y));
	Next

	$centroid[0] = $centroid[0] * (1 / $area)
	$centroid[1] = $centroid[1] * (1 / $area)

	Return $centroid
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_MoveToZeroCentroid
; Description ...: Computes the centroid of the shape and moves the vertices such that the centroid becomes 0,0.
; Syntax.........: _Box2C_b2PolygonShape_MoveToZeroCentroid($vertices)
; Parameters ....: $vertices
;				   $format - a StringFormat string to make a vertices smaller.  Try "%4.2f".
; Return values .: the centroid
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: In the calling script you can apply the returned centroid to understand where the shap has moved to.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_MoveToZeroCentroid(ByRef $vertices, $format = "%4.2f", $first_vertex_x = 0, $first_vertex_y = 0)

	; Compute the polygon centroid.

	Local $centroid = _Box2C_b2PolygonShape_ComputeCentroid($vertices)

	; Shift the shape, meaning it's center and therefore it's centroid, to the world position of 0,0, such that rotations and calculations are easier

	for $vertice_num = 0 to (UBound($vertices) - 1)

		$vertices[$vertice_num][0] = StringFormat($format, $vertices[$vertice_num][0] - $centroid[0])
		$vertices[$vertice_num][1] = StringFormat($format, $vertices[$vertice_num][1] - $centroid[1])
	Next

	; If the first vertex in $vertices is 0,0 then we can add the $centroid position above to the $first_vertex_x and $first_vertex_y
	;	to arrive at the real-world centroid position, which is then returned

	$centroid[0] = $first_vertex_x - $vertices[0][0]
	$centroid[1] = $first_vertex_y - $vertices[0][1]
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $first_vertex_y = ' & $first_vertex_y & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $vertices[0][1] = ' & $vertices[0][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	Return $centroid
EndFunc


; #B2BODYDEF FUNCTIONS# =====================================================================================================


; type (b2BodyType) = 0 (b2_staticBody)
; type (b2BodyType) = 1 (b2_kinematicBody)
; type (b2BodyType) = 2 (b2_dynamicBody)
; position x (float / b2Vec2)
; position y (float / b2Vec2)
; angle (float)
; linearVelocity x (float / b2Vec2)
; linearVelocity y (float / b2Vec2)
; angularVelocity (float)
; linearDamping (float)
; angularDamping (float)
; allowSleep (bool)
; awake (bool)
; fixedRotation (bool)
; bullet (bool)
; active (bool)
; userData (void *)
; gravityScale (float)

; m_flags
;e_islandFlag			= 0x0001,
;e_awakeFlag			= 0x0002,
;e_autoSleepFlag		= 0x0004,
;e_bulletFlag			= 0x0008,
;e_fixedRotationFlag	= 0x0010,
;e_activeFlag			= 0x0020,
;e_toiFlag 				= 0x0040

; 38 dec = 26 hex = e_activeFlag, e_autoSleepFlag, e_awakeFlag
; 36 dec = 24 hex = e_activeFlag, e_autoSleepFlag
; 32 dec = 20 hex = e_activeFlag

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyDef_Constructor
; Description ...: Constructs a b2BodyDef structure for a box shape.
; Syntax.........: _Box2C_b2BodyDef_Constructor($type, $position_x, $position_y, $angle, $linearVelocity_x, $linearVelocity_y, $angularVelocity, $linearDamping, $angularDamping, $allowSleep, $awake, $fixedRotation, $bullet, $active, $userData, $gravityScale)
; Parameters ....: $type -
;				   $position_x -
;				   $position_y -
;				   $angle -
;				   $linearVelocity_x -
;				   $linearVelocity_y -
;				   $angularVelocity -
;				   $linearDamping -
;				   $angularDamping -
;				   $allowSleep -
;				   $awake -
;				   $fixedRotation -
;				   $bullet -
;				   $active -
;				   $userData -
;				   $gravityScale -
; Return values .: Success - the b2BodyDef structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyDef_Constructor($type = 2, $position_x = 0, $position_y = 0, $angle = 0, $linearVelocity_x = 0, $linearVelocity_y = 0, $angularVelocity = 0, $linearDamping = 0, $angularDamping = 0, $allowSleep = True, $awake = True, $fixedRotation = False, $bullet = False, $active = True, $userData = Null, $gravityScale = 1)

	local $b2BodyDef = DllStructCreate("STRUCT;int;float;float;float;float;float;float;float;float;bool;bool;bool;bool;bool;ptr;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 1, $type)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 2, $position_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 3, $position_y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 4, $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 5, $linearVelocity_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 6, $linearVelocity_y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 7, $angularVelocity)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 8, $linearDamping)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 9, $angularDamping)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 10, $allowSleep)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 11, $awake)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 12, $fixedRotation)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 13, $bullet)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 14, $active)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 15, $userData)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($b2BodyDef, 16, $gravityScale)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $b2BodyDef

;	Local $b2BodyDef_ptr = DllStructGetPtr($b2BodyDef)

;	Return $b2BodyDef_ptr
EndFunc


; #B2BODY FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetActive
; Description ...: Activates / deactivates a body
; Syntax.........: _Box2C_b2Body_SetActive($body_ptr, $fixture_ptr)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $active - True to activate, False to deactivate
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetActive($body_ptr, $active)

	Local $fixture = DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_setactive", "PTR", $body_ptr, "BOOL", $active)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_DestroyFixture
; Description ...: Destroys / removes a fixture from a body
; Syntax.........: _Box2C_b2Body_DestroyFixture($body_ptr, $fixture_ptr)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $fixture_ptr - a pointer to the shape (b2Fixture)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_DestroyFixture($body_ptr, $fixture_ptr)

	Local $fixture = DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_destroyfixture", "PTR", $body_ptr, "PTR", $fixture_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_GetPosition
; Description ...: Gets the position (vector) of a body (b2Body)
; Syntax.........: _Box2C_b2Body_GetPosition($body_ptr)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
; Return values .: A vector (2D element array) of the position of the body (b2Body)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_GetPosition($body_ptr)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_getposition", "PTR", $body_ptr, "PTR", $__position_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $x = DllStructGetData($__position, 1)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $y = DllStructGetData($__position, 2)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $position_arr[2] = [$x, $y]
	Return $position_arr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetPosition
; Description ...: Sets the position (vector) of a body (b2Body)
; Syntax.........: _Box2C_b2Body_SetPosition($body_ptr, $x, $y)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $x - the horizontal position / vector
;				   $y - the vertical position / vector
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetPosition($body_ptr, $x, $y)

	local $position = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($position, 1, $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($position, 2, $y)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $angle = _Box2C_b2Body_GetAngle($body_ptr)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_settransform", "PTR", $body_ptr, "STRUCT", $position, "FLOAT", $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_GetAngle
; Description ...: Gets the angle (radians) of a body (b2Body)
; Syntax.........: _Box2C_b2Body_GetAngle($body_ptr)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
; Return values .: The angle (radians) of the body (b2Body)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_GetAngle($body_ptr)

	Local $angle = DllCall($__Box2C_Box2C_DLL, "FLOAT:cdecl", "b2body_getangle", "PTR", $body_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $angle_val = $angle[0]
	Return $angle_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetAngle
; Description ...: Sets the angle (radians) of a body (b2Body)
; Syntax.........: _Box2C_b2Body_SetAngle($body_ptr, $angle)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $angle - the angle (radians)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetAngle($body_ptr, $angle)

	Local $position_arr = _Box2C_b2Body_GetPosition($body_ptr)

	local $position = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($position, 1, $position_arr[0])
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($position, 2, $position_arr[1])
	If @error > 0 Then Return SetError(@error,0,0)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_settransform", "PTR", $body_ptr, "STRUCT", $position, "FLOAT", $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetAwake
; Description ...: Sets the awake state of a body (b2Body)
; Syntax.........: _Box2C_b2Body_SetAwake($body_ptr, $awake)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $awake - True for awake, False for sleep
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetAwake($body_ptr, $awake)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_setawake", "PTR", $body_ptr, "BOOL", $awake)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetTransform
; Description ...: Sets the transform of a body (b2Body)
; Syntax.........: _Box2C_b2Body_SetTransform($body_ptr, $x, $y, $angle)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $x -
;				   $y -
;				   $angle -
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetTransform($body_ptr, $x, $y, $angle)

	local $position = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($position, 1, $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($position, 2, $y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_settransform", "PTR", $body_ptr, "STRUCT", $position, "FLOAT", $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_GetLinearVelocity
; Description ...: Gets the linear velocity of a body (b2Body)
; Syntax.........: _Box2C_b2Body_GetLinearVelocity($body_ptr)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
; Return values .: Success - the linear velocity as a two dimensional array
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_GetLinearVelocity($body_ptr)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_getlinearvelocity", "PTR", $body_ptr, "PTR", $__position_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $velocity_x = DllStructGetData($__position, 1)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $velocity_y = DllStructGetData($__position, 2)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $velocity_arr[2] = [$velocity_x, $velocity_y]
	Return $velocity_arr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetLinearVelocity
; Description ...: Sets the velocity (vector) of a body (b2Body)
; Syntax.........: _Box2C_b2Body_SetLinearVelocity($body_ptr, $x, $y)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $x - the horizontal velocity / vector
;				   $y - the vertical velocity / vector
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetLinearVelocity($body_ptr, $x, $y)

	local $velocity = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($velocity, 1, $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($velocity, 2, $y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_setlinearvelocity", "PTR", $body_ptr, "STRUCT", $velocity)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_GetAngularVelocity
; Description ...: Gets the angular velocity of a body (b2Body)
; Syntax.........: _Box2C_b2Body_GetAngularVelocity($body_ptr)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
; Return values .: Success - the linear velocity as a two dimensional array
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_GetAngularVelocity($body_ptr)

	Local $angular_velocity = DllCall($__Box2C_Box2C_DLL, "FLOAT:cdecl", "b2body_getangularvelocity", "PTR", $body_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $angular_velocity_val = $angular_velocity[0]
	Return $angular_velocity_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_SetAngularVelocity
; Description ...: Sets the angular velocity (radians) of a body (b2Body)
; Syntax.........: _Box2C_b2Body_SetAngularVelocity($body_ptr, $angular_velocity)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $angular_velocity - the angular velocity (radians)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_SetAngularVelocity($body_ptr, $angular_velocity)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_setangularvelocity", "PTR", $body_ptr, "FLOAT", $angular_velocity)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ApplyForce
; Description ...: Applies a force to a point on a body (b2Body)
; Syntax.........: _Box2C_b2Body_ApplyForce($body_ptr, $force_x, $force_y, $point_x, $point_y)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $force_x - the horizontal component of the force
;				   $force_y - the vertical component of the force
;				   $point_x - the horizontal component of the point
;				   $point_y - the vertical component of the point
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ApplyForce($body_ptr, $force_x, $force_y, $point_x, $point_y)

	local $force = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($force, 1, $force_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($force, 2, $force_y)
	If @error > 0 Then Return SetError(@error,0,0)

	local $point = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($point, 1, $point_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($point, 2, $point_y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_applyforce", "PTR", $body_ptr, "STRUCT", $force, "STRUCT", $point)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ApplyForceAtBody
; Description ...: A convenience function to apply a force to a body relative to it's centroid (b2Body)
; Syntax.........: _Box2C_b2Body_ApplyForceAtBody($body_ptr, $force_x, $force_y, $offset_point_x, $offset_point_y)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $force_x - the horizontal component of the force
;				   $force_y - the vertical component of the force
;				   $offset_point_x - the horizontal component of an offset point from the centroid (defaults to 0 for no offset)
;				   $offset_point_y - the vertical component of offset point from the centroid (defaults to 0 for no offset)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ApplyForceAtBody($body_ptr, $force_x, $force_y, $offset_point_x = 0, $offset_point_y = 0)

	Local $body_position = _Box2C_b2Body_GetPosition($body_ptr)

	local $force = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($force, 1, $force_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($force, 2, $force_y)
	If @error > 0 Then Return SetError(@error,0,0)

	local $point = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($point, 1, $body_position[0] + $offset_point_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($point, 2, $body_position[1] + $offset_point_y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_applyforce", "PTR", $body_ptr, "STRUCT", $force, "STRUCT", $point)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ApplyDirectionalForceAtBody
; Description ...: A convenience function to apply a force of a given magnitude to a body relative to it's centroid (b2Body) and angle
; Syntax.........: _Box2C_b2Body_ApplyDirectionalForceAtBody($body_ptr, $force_magnitude, $offset_point_x, $offset_point_y)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $force_magnitude - the size of the force
;				   $offset_point_x - the horizontal component of an offset point from the centroid (defaults to 0 for no offset)
;				   $offset_point_y - the vertical component of offset point from the centroid (defaults to 0 for no offset)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ApplyDirectionalForceAtBody($body_ptr, $force_magnitude, $offset_point_x = 0, $offset_point_y = 0)

	Local $tmp_angle = _Box2C_b2Body_GetAngle($body_ptr)
	Local $force_x = $force_magnitude * Cos($tmp_angle)
	Local $force_y = $force_magnitude * Sin($tmp_angle)

	local $force = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($force, 1, $force_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($force, 2, $force_y)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $body_position = _Box2C_b2Body_GetPosition($body_ptr)

	local $point = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($point, 1, $body_position[0] + $offset_point_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($point, 2, $body_position[1] + $offset_point_y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_applyforce", "PTR", $body_ptr, "STRUCT", $force, "STRUCT", $point)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ApplyTorque
; Description ...: Applies a torque on a body (b2Body)
; Syntax.........: _Box2C_b2Body_ApplyTorque($body_ptr, $torque)
; Parameters ....: $body_ptr - a pointer to the body (b2Body)
;				   $torque - the torque
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ApplyTorque($body_ptr, $torque)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2body_applytorque", "PTR", $body_ptr, "FLOAT", $torque)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


; #B2FIXTURE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_GetShape
; Description ...: Gets the shape (b2...) of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_GetShape($fixture_ptr, $shape_ptr)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
;				   $shape_ptr - a pointer to the shape (b2...)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_GetShape($fixture_ptr, $shape_ptr)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_getshape", "PTR", $fixture_ptr, "PTR", $shape_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_GetDensity
; Description ...: Gets the density of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_GetDensity($fixture_ptr)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
; Return values .: Success - the density
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_GetDensity($fixture_ptr)

	Local $density = DllCall($__Box2C_Box2C_DLL, "FLOAT:cdecl", "b2fixture_getdensity", "PTR", $fixture_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $density_val = $density[0]
	Return $density_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_SetDensity
; Description ...: Sets the density of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_SetDensity($fixture_ptr, $value)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
;				   $value - the density value
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_SetDensity($fixture_ptr, $value)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setdensity", "PTR", $fixture_ptr, "FLOAT", $value)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_GetRestitution
; Description ...: Gets the restitution of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_GetRestitution($fixture_ptr)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_GetRestitution($fixture_ptr)

	Local $restitution = DllCall($__Box2C_Box2C_DLL, "FLOAT:cdecl", "b2fixture_getrestitution", "PTR", $fixture_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $restitution_val = $restitution[0]
	Return $restitution_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_SetRestitution
; Description ...: Sets the restitution of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_SetRestitution($fixture_ptr, $value)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
;				   $value - the restitution value
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_SetRestitution($fixture_ptr, $value)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setrestitution", "PTR", $fixture_ptr, "FLOAT", $value)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_GetFriction
; Description ...: Gets the density of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_GetFriction($fixture_ptr)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
; Return values .: Success - the friction
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_GetFriction($fixture_ptr)

	Local $friction = DllCall($__Box2C_Box2C_DLL, "FLOAT:cdecl", "b2fixture_getfriction", "PTR", $fixture_ptr)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $friction_val = $friction[0]
	Return $friction_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_SetFriction
; Description ...: Sets the friction of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_SetFriction($fixture_ptr, $value)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
;				   $value - the friction value
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_SetFriction($fixture_ptr, $value)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setfriction", "PTR", $fixture_ptr, "FLOAT", $value)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Fixture_SetSensor
; Description ...: Sets the sensor of a fixture (b2Fixture)
; Syntax.........: _Box2C_b2Fixture_SetSensor($fixture_ptr, $value)
; Parameters ....: $fixture_ptr - a pointer to the fixture (b2Fixture)
;				   $value - True will turn the sensor on, False will turn the sensor off
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Fixture_SetSensor($fixture_ptr, $value)

	DllCall($__Box2C_Box2C_DLL, "NONE:cdecl", "b2fixture_setsensor", "PTR", $fixture_ptr, "BOOL", $value)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


