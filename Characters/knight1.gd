extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attacking = false
var direction = 0

@export var target = Node2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
#
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handles movement towards player
	if attacking == false:
		if target.global_position.x < self.global_position.x:
			velocity.x = -SPEED
			direction = -1
		elif target.global_position.x > self.global_position.x:
			velocity.x = SPEED
			direction = 1
			
	move_and_slide()


func _on_battle_range_body_entered(body):
	attacking == true
	if body.is_in_group("player"):
		if direction < 0:
			$Sprite2D.flip_h = true
			$SwordHitbox/CollisionShape2D.position.x = -61
		if direction > 0:
			$Sprite2D.flip_h = false
			$SwordHitbox/CollisionShape2D.position.x = 61
		velocity.x = 0
		$AnimationPlayer.play("attack")
		
