extends Area2D


var scn_explosion = preload("res://Scenes/Explosion.tscn")
var scn_asteroids = load("res://Scenes/Asteroids.tscn")
var scn_asteroidSpawn = load("res://Scenes/AsteroidSpawn - Copy.gd")
var vectorHeading = Vector2(0,0)
var explosion 
var hits = 0
var screensize
var timer
signal makeMedium
signal makeSmall

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
	timer.stop()


func unhook():

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

	if (self.get_name().find("Big") != -1):
		self.position += Vector2(1,0)
		self.rotation += 1.5 * delta
	else:
		self.position += vectorHeading
		self.rotation += 1.5 * delta
	
func player_collision():
	print ("You're Dead...")

func print_hello():
	pass

func set_pos_and_trajectory():
	randomize()
	if (self.get_name().find("Big") != -1):
		get_parent().set_unit_offset(randf())
		get_parent().rotate(rand_range(PI/4, 3 * PI/4))
	else:
		vectorHeading = Vector2(randf() * 2.0 - 1, randf() * 2.0 - 1)

		
		
func _body_entered( body ):
	if (body.get_name().find("Bullet") != -1):
		explosion = scn_explosion.instance()
	#	if body.get_name().match("Bullet"):
		body.queue_free()
		explosion.position = Vector2(0,0)
		self.add_child(explosion)
		explosion.get_node("AnimationExplosion").play("explode")
		
	
		if (self.get_name().find("Big") != -1 && hits == 5):
			#!!!! Emit signal to be connected to in AsteroidSpawn, just like the timer signal in there
			emit_signal("makeMedium", self.global_position)
			explosion.get_node("AnimationExplosion").play("explode")
			self.queue_free()
		elif (self.get_name().find("Medium") != -1 && hits == 5):
			emit_signal("makeSmall", self.global_position)
			explosion.get_node("AnimationExplosion").play("explode")
			self.queue_free()
		elif (self.get_name().find("Small") != -1 && hits == 5):
			explosion.get_node("AnimationExplosion").play("explode")
			self.queue_free()

		
	hits += 1



