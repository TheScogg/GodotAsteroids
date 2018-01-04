extends Node2D

var scn_asteroids = preload("res://Scenes/Asteroids.tscn")
var asteroid
var totalAsteroids = 5
var asteroidPath2D
var asteroidFollowPath
var asteroidDictionary = {}
var lives = 5

#Number of bullet hits needed to split asteroid into medium and then small pieces
var asteroidSplitHits = 3


func _ready():
	asteroidPath2D = get_node("Path2D")
	set_physics_process(true)
	
func _physics_process(delta):
	move_asteroids(delta)
	
func collision():
	for asteroid in asteroidDictionary:
		asteroid = asteroidDictionary[asteroid].get_child(0)
		
func contain():
	pass
	
func move_asteroids(delta):
	for asteroid in asteroidDictionary:
		asteroid = asteroidDictionary[asteroid].get_child(0)
		asteroid.position += Vector2(1,0)
		asteroid.rotation += .5 * delta
		
func split_asteroids():
	pass
	
func set_pos_and_trajectory(asteroid):
	asteroid = asteroid[asteroidDictionary.size() - 1]
	asteroid.set_unit_offset(randf())
	asteroid.rotate(rand_range(PI/4, 3 * PI/4))



#Create asteroid path and Area2d / Sprite subnodes every time TimerAsteroid expires
func _on_TimerAsteroid_timeout():
	randomize()
	if (totalAsteroids > 0):
		asteroid = scn_asteroids.instance()
		asteroid = asteroid.spawnAsteroid("Big")
		asteroid.connect("body_entered", self, "_body_entered", [asteroid])
		asteroid.position = Vector2(0,0)

		asteroidFollowPath = PathFollow2D.new()
		asteroidFollowPath.set_name("AsteroidPath" + str(asteroidDictionary.size()))
		asteroidFollowPath.add_child(asteroid)
		
		$Path2D.add_child(asteroidFollowPath)
		asteroidDictionary[asteroidDictionary.size()] = asteroidFollowPath
#		asteroidDictionary[asteroidFollowPath.get_name()] = asteroidFollowPath
		
		set_pos_and_trajectory(asteroidDictionary)
		
	totalAsteroids -= 1


func _body_entered( body, asteroid ):
	#asteroid parameter points to actual asteroid being hit
	#add hits variable to asteroidDictionary, 3 hits to split
	#Change name of keys to AsteroidPaths?
	lives -= 1
	
	if body.get_name().match("Bullet"):
		asteroid.get_node("ExplodeBigAnim").play("explosion")

#	get_parent().get_node("CanvasLayer/Control/RichTextLabel").set_text(str(lives))
		
