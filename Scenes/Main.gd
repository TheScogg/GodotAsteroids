extends Node2D

var health = 100

#******* DO THIS 01/13/17
#Link up with dynamically created Lives nodes
var startingLives = 3

var Player 
var damageDict = {}
export (int) var lives = 3
var damage
export (int) var damageMultiplier = 5

signal killed
var ui
var screensize 
var playerKilledTimer
onready var impactTween
onready var opacityTween
var sounds

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
	impactTween = Player.get_node("impactTween")
	opacityTween = Player.get_node("opacityTween")
	sounds = get_tree().get_root().get_node("Main/Sounds")
	print (sounds)
	
		
func gameOver():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_player_killed_timeout():

	Player.get_node("SpriteShip").set_texture(load("res://Assets/AssetForge/Ship1.png"))
	Player.get_node("AnimationExplode").stop(true)
	Player.position = screensize/2
	Player.motion = Vector2(0,0)
	sounds.get_node("Womp").play()
	opacityTween.start()
	Player.get_node("CollisionPolygon2D").disabled = false
	playerKilledTimer.stop()


func playerKilled():
#	print (get_tree().get_root().get_node("Sounds"))
	playerKilledTimer = Timer.new()
	self.add_child(playerKilledTimer)
	playerKilledTimer.wait_time = 2
	opacityTween.interpolate_property(Player.get_node("SpriteShip"), "modulate", Color(1,1,1,0), Color(1,1,1,1), 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)

	playerKilledTimer.connect("timeout",self,"_on_player_killed_timeout")
	playerKilledTimer.start()

	

	Player.get_node("AnimationExplode").play("explode")
	Player.get_node("CollisionPolygon2D").disabled = true

	sounds.get_node("Explosion").play()

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
	
	opacityTween.interpolate_property(Player, "DETERIORATION", -Player.direction, Player.direction, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	opacityTween.start()
#	Player.motion *= -1
	if (health <= 0):
		playerKilled()