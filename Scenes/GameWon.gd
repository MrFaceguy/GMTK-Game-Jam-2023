extends Label

@export var enemy = Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy == null:
		self.visible = true
