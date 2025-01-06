extends Node2D
@export var mass = 10
@export var saturation_factor = 0.9
@export var density=1
@export var rotation_ratio:float=0.5
func desaturate(color):
	var luminance = color.get_luminance()
	var red_divergence = luminance - color.r
	var green_divergence = luminance - color.g
	var blue_divergence = luminance - color.b
	color.r+=red_divergence*saturation_factor
	color.g+=green_divergence*saturation_factor
	color.b+=blue_divergence*saturation_factor
	return color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color = pick_random_color()
	print(color)
	$Sprite2D.material.set_shader_parameter("color",color)
	print($Sprite2D.material.get_shader_parameter("color"))
	var rad = scale.x*10
	mass = (int(rad)^2)*PI*density
	$Path2D/PathFollow2D.progress_ratio=rotation_ratio
	$"Debug label".text = str(snapped(mass,0.01))
	var facility = find_child("Facility")
	if facility!=null:
		print("Facility detected, positioning...")
		facility.reparent($Path2D/PathFollow2D,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func pick_random_color() -> Color:
	var test  = Vector3(randf(),randf(),randf())
	test = test.normalized()
	var color:Color = Color(test.x,test.y,test.z)
	
	color=desaturate(color)
	return color
