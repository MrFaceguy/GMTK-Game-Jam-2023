extends ProgressBar

@export var mainMan = Node2D

var maximumHealthValue 
var currentHealthValue 

func _ready():
	self.max_value = mainMan.maxEnemyHealth
	currentHealthValue = mainMan.enemyHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.value = mainMan.enemyHealth
