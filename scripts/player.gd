extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var playerHealth = 100

var fireball = load("res://objects/fireball.tscn")
var fireballCooldown = false

var doubleJump = true

@onready var mainScene = get_tree().current_scene

const defaultCollisionSize = Vector2(128,96)
const defaultPositionY = 2


enum State {IDLE, MOVING, FIREBALL, HITSTUN, JUMP, DOUBLE_JUMP}
@export var current_state = State.IDLE


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func characterFlipping():
	if Input.is_action_pressed("Left"):
		$RayCast2D.position.x = -70
		$RayCast2D.target_position.x = -10
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("Right"):
		$RayCast2D.position.x = 70
		$RayCast2D.target_position.x = 10
		$AnimatedSprite2D.flip_h = true

func movementHandling():
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func shootFireball():
	if fireballCooldown == false:
		if Input.is_action_just_pressed("Projectile"):
			$AnimatedSprite2D.play("spitFire")
			var projectile = fireball.instantiate()
			projectile.position = $RayCast2D.global_position
			projectile.speed = $RayCast2D.target_position.x
			mainScene.add_child(projectile)
			fireballCooldown = true
			$FireballTimer.start()

func takeDamage(damage, direction):
	current_state = State.HITSTUN
	playerHealth -= damage
	velocity += Vector2(direction * -JUMP_VELOCITY/2, JUMP_VELOCITY/2)
	$HitstunTimer.start()


func stateManagement():
	# Revised State Handling
	if Input.is_action_just_pressed("Projectile"):
		current_state = State.FIREBALL
	elif !self.is_on_floor() or Input.is_action_just_pressed("Jump"):
		current_state = State.JUMP
	else:
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			current_state = State.MOVING
		else:
			current_state = State.IDLE

func _physics_process(delta):
	
	stateManagement()
	
	match current_state:
		State.IDLE:
			$AnimatedSprite2D.play("idle")
			
			velocity.x = 0
		State.MOVING:
			$AnimatedSprite2D.play("walk")
			
			characterFlipping()
				
				
			movementHandling()
		State.FIREBALL:
			shootFireball()
			
			characterFlipping()
			
			movementHandling()
		State.HITSTUN:
			pass
		State.JUMP:
			$AnimatedSprite2D.animation = "jump"
			
			
			characterFlipping()
			
			movementHandling()
			
			# Handle Jump.
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
		State.DOUBLE_JUMP:
			pass
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	move_and_slide()

func _on_timer_timeout():
	current_state = State.IDLE
	velocity.x = 0


func _on_fireball_timer_timeout():
	fireballCooldown = false
