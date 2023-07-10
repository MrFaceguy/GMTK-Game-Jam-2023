extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State {ADVANCE, STANDING_ATTACK}
@export var current_state = State

@export var maxEnemyHealth = 5
@export var enemyHealth = 5

@export var target = Node2D

var direction = 0

func _ready():
	current_state = State.ADVANCE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match current_state:
		State.ADVANCE:
			$AnimationPlayer.play("walk")
			var difference = target.global_position.x - self.global_position.x
			velocity.x = SPEED * sign(difference)
			direction = sign(velocity.x)
		State.STANDING_ATTACK:
			$AnimationPlayer.play("attack")
			velocity.x = 0
	move_and_slide()
	
	if enemyHealth == 0:
		queue_free()
		


func _on_battle_range_body_entered(body):
	current_state = State.STANDING_ATTACK
	if body == target:
		if direction < 0:
			$Sprite2D.flip_h = true
			$SwordHitbox/CollisionShape2D.position.x = -40
		if direction > 0:
			$Sprite2D.flip_h = false
			$SwordHitbox/CollisionShape2D.position.x = 40


func _on_sword_hitbox_body_entered(body):
	if body == target:
		body.takeDamage(10, direction)
		
