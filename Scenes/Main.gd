extends Node2D

var LivesLabel

var damageDict = {}
var lives = 8
var damage

func _ready():
	LivesLabel = get_node("CanvasLayer/Control/LivesLabel")
	
	set_physics_process(true)
	
	
func _physics_process(delta):
	pass


func _player_hit(size):
	if (size == "Big"):
		damage = 1
	if (size == "Medium"):
		damage = .5
	if (size == "Small"):
		damage = .25
	
	LivesLabel.text = String(lives)
	lives = lives - damage
