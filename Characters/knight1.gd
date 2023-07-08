extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State {ADVANCE, STANDING_ATTACK}
@export var current_state = State


var direction = 0

@export var target = Node2D

func _ready():
	current_state = State.ADVANCE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handles movement towards player
	if current_state == State.ADVANCE:
		$AnimationPlayer.play("idle")
		var difference = self.global_position.x - target.global_position.x
		velocity.x = SPEED * sign(-difference)
			
#
#		if self.global_position.x > target.global_position.x:
#			velocity.x = -SPEED
#			direction = -1
#
#		if self.global_position.x < target.global_position.x:
#			velocity.x = SPEED
#			direction = 1

			
	move_and_slide()


func _on_battle_range_body_entered(body):
	current_state = State.STANDING_ATTACK
	if body.is_in_group("player"):
		if direction < 0:
			$Sprite2D.flip_h = true
			$SwordHitbox/CollisionShape2D.position.x = -61
		if direction > 0:
			$Sprite2D.flip_h = false
			$SwordHitbox/CollisionShape2D.position.x = 61
		velocity.x = 0
		$AnimationPlayer.play("attack")
		

