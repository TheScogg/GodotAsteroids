extends Node2D

var scn_asteroids = preload("res://Scenes/Asteroids.tscn")
var anAsteroidCode = preload("res://Scenes/anAsteroid.gd")
var player = preload("res://Scenes/Player.tscn")
var asteroid

#var scn_explosion = preload("res://Scenes/Explosion.tscn")
var explosion 
var hits = 0
var totalAsteroids = 5
var asteroidPath2D
var asteroidFollowPath
var asteroidDictionary = {}
var lives = 5


func _ready():
	player = player.instance()
	#AsteroidSpawn

	set_process(true)
	
func _process(delta):
	pass


func create(size, asteroidPos, howMany):
	print (asteroidPos)
	for i in range(howMany):
		asteroid = scn_asteroids.instance()
		asteroid = asteroid.spawnAsteroid(size)
		
		asteroid.global_position = asteroidPos
		asteroid.set_script(anAsteroidCode)
		

		#Signal Lists 
		asteroid.connect("body_entered", asteroid, "_body_entered")
		asteroid.connect("makeMedium", self, "_make_medium")
		asteroid.connect("makeSmall", self, "_make_small")
		asteroid.connect("playerHit", player, "_player_hit")
		
		#A) Add asteroid to follow path and follow path to path2D to bring asteroids in from outside the screen
		if (size == "Big"):
			asteroidFollowPath = PathFollow2D.new()
			asteroidFollowPath.set_name("AsteroidPath")
			asteroidFollowPath.add_child(asteroid)
		
			#Path2D is a child of AsteroidSpawn node
			$Path2D.add_child(asteroidFollowPath)
		#B) Seperate from big asteroids since these are instanced at position of split big asteroids, not outside the screen
		elif (size == "Medium" || size == "Small"):
			$Freefloating.add_child(asteroid)


	
func _make_big(asteroidPos):
	create("Big", asteroidPos, 1)

func _make_medium(asteroidPos):
	create("Medium", asteroidPos, 2)
	
func _make_small(asteroidPos):
	create("Small", asteroidPos, 2)
	
#Create asteroid path and Area2d / Sprite subnodes every time TimerAsteroid expires
func _on_TimerAsteroid_timeout():
	print ("Total Asteroids Left: ",totalAsteroids)
	if (totalAsteroids > 0):
		create("Big", Vector2(0,0), 1)
		totalAsteroids -= 1
	else:
		self.get_node("TimerAsteroid").queue_free()
	
	



