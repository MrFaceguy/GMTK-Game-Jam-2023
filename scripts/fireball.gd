extends Area2D


var speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position.x += speed
	if speed > 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		self.queue_free()
		body.enemyHealth -= 1 
