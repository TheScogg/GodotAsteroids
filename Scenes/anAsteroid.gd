extends Area2D


var scn_explosion = preload("res://Scenes/Explosion.tscn")
var scn_asteroids = load("res://Scenes/Asteroids.tscn")
var scn_asteroidSpawn = load("res://Scenes/AsteroidSpawn - Copy.gd")

var explosion 
var hits = 0
var screensize
var timer
signal makeMedium

func _ready():
	screensize = get_viewport().get_visible_rect().size
	startContainTimer()
	set_pos_and_trajectory()
	unhook()
	set_physics_process(true)
	
func startContainTimer():
	timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 2
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.start()


func _on_timer_timeout():
	print ("Timer timed out")
	timer.stop()


func unhook():
	print (get_parent().get_name(), " is parent")
	pass

func _physics_process(delta):
	contain()
	move_asteroids(delta)

func contain():
	if (timer.is_stopped()):
		if (global_position.y <= 0):
			global_position.y = screensize.y - 1
		if (global_position.y >= screensize.y):
			global_position.y = 0
		if (global_position.x <= 0):
			global_position.x = screensize.x - 1
		if (global_position.x >= screensize.x):
			global_position.x = 0


func move_asteroids(delta):
	self.position += Vector2(1,0)
	self.rotation += 1.5 * delta
	
func player_collision():
	print ("You're Dead...")

func print_hello():
	print ("Asteroid Instantiated")	

func set_pos_and_trajectory():
	get_parent().set_unit_offset(randf())
	get_parent().rotate(rand_range(PI/4, 3 * PI/4))

func _body_entered( body ):
#	asteroid.create("Medium")
	if (body.get_name() != "Player"):
		explosion = scn_explosion.instance()
	#	if body.get_name().match("Bullet"):
		body.queue_free()
		explosion.position = Vector2(0,0)
		self.add_child(explosion)
		explosion.get_node("AnimationExplosion").play("explode")
		
	
	if (hits == 5):
		#!!!! Emit signal to be connected to in AsteroidSpawn, just like the timer signal in there
		emit_signal("makeMedium", self.global_position)


		self.queue_free()
		print ("Asteroid split")
		
	


		
	hits += 1



