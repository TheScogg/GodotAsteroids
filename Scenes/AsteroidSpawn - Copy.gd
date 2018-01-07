extends Node2D

var scn_asteroids = preload("res://Scenes/Asteroids.tscn")
var anAsteroidCode = preload("res://Scenes/anAsteroid.gd")
var asteroid

var scn_explosion = preload("res://Scenes/Explosion.tscn")
var explosion 
var hits = 0
var totalAsteroids = 15
var asteroidPath2D
var asteroidFollowPath
var asteroidDictionary = {}
var lives = 5

func _ready():
	#AsteroidSpawn
	print (self.get_name())
	set_process(true)
	
func _process(delta):
	pass


func create(size, asteroidPos):
	asteroid = scn_asteroids.instance()
	asteroid = asteroid.spawnAsteroid(size)
	print (asteroidPos)
	asteroid.position = asteroidPos
	asteroid.set_script(anAsteroidCode)
	asteroid.connect("makeMedium", self, "_make_medium")
	asteroid.connect("body_entered", asteroid, "_body_entered")

	

	asteroidFollowPath = PathFollow2D.new()
	asteroidFollowPath.set_name("AsteroidPath")
	asteroidFollowPath.add_child(asteroid)

	#Path2D is a child of AsteroidSpawn node
	$Path2D.add_child(asteroidFollowPath)

		
	totalAsteroids -= 1
	

func _make_medium(asteroidPos):
	print (asteroidPos)
	create("Medium", asteroidPos)
	
#Create asteroid path and Area2d / Sprite subnodes every time TimerAsteroid expires
func _on_TimerAsteroid_timeout():
	create("Big", Vector2(0,0))

	
	
