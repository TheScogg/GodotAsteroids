extends Node2D

var scn_asteroids = preload("res://Scenes/Asteroids.tscn") #Asteroids.gd
var anAsteroidCode = preload("res://Scenes/anAsteroid.gd")
#var player = preload("res://Scenes/Player.tscn")
#var main = preload("res://Scenes/Main.tscn")
var asteroid

#var scn_explosion = preload("res://Scenes/Explosion.tscn")
var explosion 
var hits = 0
var totalAsteroids = 15
var asteroidPath2D
var asteroidFollowPath
var asteroidDictionary = {}
var lives = 5


func _ready():
	set_process(true)
	
func _process(delta):
	pass

func create(size, asteroidPos, howMany):

	for i in range(howMany):
		asteroid = scn_asteroids.instance() #Asteroids.gd
		asteroid = asteroid.spawnAsteroid(size)

		asteroid.global_position = asteroidPos
		asteroid.set_script(anAsteroidCode)
		

		#Signal Lists 

		asteroid.connect("makeMedium", self, "_make_medium")
		asteroid.connect("makeSmall", self, "_make_small")
#		asteroid.connect("playerHit", player, "_player_hit")
		
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
	self.get_node("TimerAsteroid").wait_time *= .99
	print (self.get_node("TimerAsteroid").wait_time)
	create("Big", Vector2(0,0), 1)
	totalAsteroids -= 1
#	else:
#		self.get_node("TimerAsteroid").queue_free()
#
	



