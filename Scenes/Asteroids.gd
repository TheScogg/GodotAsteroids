extends Node2D

var randomAsteroid
var big = []
var medium = []
var small = []
var asteroids
signal body_entered

func _ready():
	set_physics_process(true)
	

func _set_phsyics_process():
	pass

func spawnAsteroid(size):
	
	asteroids = get_children()
	for asteroid in asteroids:
		if (asteroid.get_name().find("Big") == 0):
			big.append(asteroid)
		elif (asteroid.get_name().find("Medium") == 0):
			medium.append(asteroid)
		elif (asteroid.get_name().find("Small") == 0):
			small.append(asteroid)
			
	randomize()

	
	if (size == "Big"):
		randomAsteroid = big[randi() % big.size()]

	elif (size == "Medium"):
		randomAsteroid = medium[randi() % medium.size()]
	elif (size == "Small"):
		randomAsteroid = small[randi() % small.size()]
		

<<<<<<< HEAD

=======
>>>>>>> cdd88ae2fadaeab1595e880d7159ced0e9802cf7
	print (randomAsteroid)


	return randomAsteroid.duplicate()





