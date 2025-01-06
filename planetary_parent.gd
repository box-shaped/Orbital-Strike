extends Node2D
@export_category("Automaic planet population")
@export var enabled:bool = false
@export var Size:Vector2 = Vector2(1000,1000)
@export var density = 0.3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enabled:
		for i in range(5):
			generatePlanet()
			print("attempting")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func generatePlanet():
	var location = Vector2(randi() % int(Size.x),randi()%int(Size.y))
	var planet = preload("res://Planet.tscn").instantiate()
	planet.position = location
	var size = randf()*4
	planet.scale*=size
	var rad = size*10
	planet.mass = (int(rad)^2)*PI*density
	
	planet.get_child(2).text = str(snapped(planet.mass,0.01))

	add_child(planet)
	#planet.get_child(0).material.set_shader_parameter()
