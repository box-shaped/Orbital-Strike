extends Node2D
class_name Facility

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func destruct():
	$Sprite2D.visible=false
	$Sprite2D2.visible=false
	$Sprite2D3.visible=false
	$Polygon2D.visible=false
	$Explosion.emitting= true


func _on_explosion_finished() -> void:
	self.queue_free()
