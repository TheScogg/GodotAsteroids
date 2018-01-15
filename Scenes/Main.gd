extends Node2D

var health = 100

#******* DO THIS 01/13/17
#Link up with dynamically created Lives nodes
var startingLives = 3

var Player 
var damageDict = {}
export (int) var lives = 3
var damage
export (int) var damageMultiplier = 40

signal killed
var ui
var screensize 
var playerKilledTimer

func _ready():
	screensize = get_viewport().get_visible_rect().size
	set_physics_process(true)
	connect_signals()

func _physics_process(delta):
	get_node("CanvasLayer/UI/XPContainer/ProgressHealth").value = health

#	if (lives <= 0):
#		get_tree().change_scene("res://Scenes/Main.tscn")

func connect_signals():
	ui = get_node("CanvasLayer/UI")
	self.connect("killed", ui, "_on_killed")
	####
	Player = get_node("Player")


	
		
func gameOver():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_player_killed_timeout():
	Player.get_node("SpriteShip").set_texture(load("res://Assets/Space shooter assets (300 assets)/PNG/playerShip2_red.png"))
	Player.get_node("AnimationExplode").stop(true)
	print(Player.get_node("AnimationExplode").is_playing())
	Player.position = screensize/2
	Player.get_node("CollisionPolygon2D").disabled = false
	playerKilledTimer.stop()


func playerKilled():
#	print (get_tree().get_root().get_node("Sounds"))
	playerKilledTimer = Timer.new()
	self.add_child(playerKilledTimer)
	playerKilledTimer.wait_time = 2
	playerKilledTimer.connect("timeout",self,"_on_player_killed_timeout")
	playerKilledTimer.start()
	
	Player.get_node("AnimationExplode").play("explode")
	Player.get_node("CollisionPolygon2D").disabled = true

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