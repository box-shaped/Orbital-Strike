extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level2.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level3.tscn")


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level4.tscn")


func _on_level_5_pressed() -> void:
	pass # Replace with function body.


func _on_level_6_pressed() -> void:
	pass # Replace with function body.
