extends CanvasLayer



func change_scene(target):
	$AnimationPlayer.play("Fade In")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("Fade In")
