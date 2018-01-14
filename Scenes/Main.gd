extends Node2D

var health = 100

#******* DO THIS 01/13/17
#Link up with dynamically created Lives nodes
var startingLives = 3


var damageDict = {}
export (int) var lives = 3
var damage
export (int) var damageMultiplier = 40

signal killed
var ui



func _ready():
	set_physics_process(true)
	connect_signals()
	
func _physics_process(delta):
	get_node("CanvasLayer/UI/XPContainer/ProgressHealth").value = health

	if (lives <= 0):
		get_tree().change_scene("res://Scenes/Main.tscn")

func connect_signals():
	ui = get_node("CanvasLayer/UI")
	self.connect("killed", ui, "_on_killed")
	####

	
		
func gameOver():
	get_tree().change_scene("res://path/to/scene.scn")


func playerKilled():
	lives -= 1
	emit_signal("killed")
	health = 100
	
	if (lives <= 0):
		gameOver()
		


func _player_hit(size):
	if (size == "Big"):
		damage = 1
	if (size == "Medium"):
		damage = .5
	if (size == "Small"):
		damage = .25

	health -= damage * damageMultiplier
	print (health)	
	if (health <= 0):
		playerKilled()