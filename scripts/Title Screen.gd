extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Projectile"):
		SceneTransition.change_scene("res://Scenes/battle_scene.tscn")

