extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var playerHealth = 100

var fireball = load("res://objects/fireball.tscn")

var doubleJump = true

signal fireballShot

@onready var mainScene = get_tree().current_scene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func shootFireball():
	if Input.is_action_pressed("Left") && is_on_floor():
		$RayCast2D.position.x = -128
		$RayCast2D.target_position.x = -10
	if Input.is_action_pressed("Right") && is_on_floor():
		$RayCast2D.position.x = 128
		$RayCast2D.target_position.x = 10
	if Input.is_action_just_pressed("Projectile"):
		var projectile = fireball.instantiate()
		projectile.position = $RayCast2D.global_position

		projectile.speed = $RayCast2D.target_position.x
		mainScene.add_child(projectile)
		fireballShot.emit()
	

func _physics_process(delta):
	
	shootFireball()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("Jump") and doubleJump == true:
			velocity.y = JUMP_VELOCITY
			doubleJump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
