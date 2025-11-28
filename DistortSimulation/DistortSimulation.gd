extends Sprite2D

var timer := 0.0
var impact_scale := Vector2(0.25, 0.25)
var propagation := 0.25
var effect_simulation_size := Vector2.ZERO
@onready var marker_1 = %Marker1

@onready var simulation_sprite = $"../../SubViewportVFX/SimulationSprite"

func _ready():
	effect_simulation_size = simulation_sprite.scale * 2.0


func get_normal(uv:Vector2):
	var z = sqrt( 1.0 - ( pow(uv.x, 2.0) + pow(uv.y, 2.0) ) )
	return  Vector3( uv.x, uv.y, z )


func sphere_to_UV(sphere_point:Vector3):
	var n:Vector3 = sphere_point.normalized()
	return Vector2( atan2(n.x, n.y) / TAU + 0.5, n.z * 0.5 + 0.5 )


func _physics_process(_delta):
	marker_1.hide()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		marker_1.position = get_global_mouse_position()*0.25
		marker_1.scale = impact_scale * (randf() * 0.5  + 0.5)
		marker_1.show()


func _on_impact_size_value_changed(value):
	impact_scale = Vector2(value, value);

func _on_propagation_value_changed(value):
	propagation = value;
	$SubViewport/Sprite2D.material.set_shader_parameter("propagation", propagation)
