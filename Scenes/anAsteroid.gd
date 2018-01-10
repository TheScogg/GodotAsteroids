extends Area2D


var scn_explosion = preload("res://Scenes/Explosion.tscn")
var explosion 
var bulletHitTex = preload("res://Assets/Space shooter assets (300 assets)/PNG/Lasers/laserRed11.png")

var vectorHeading = Vector2(0,0)

var hits = 0
var screensize
var timer

var timerKillBullet
signal makeMedium
signal makeSmall
signal playerHit

func _ready():
	explosion = get_tree().get_root().get_child(0).get_node("AsteroidSpawn/Explosions").get_child(0)
	screensize = get_viewport().get_visible_rect().size
	startContainTimer()
	set_pos_and_trajectory()
	set_physics_process(true)


	
func _physics_process(delta):
	contain()
	move_asteroids(delta)
	
	
################BEGIN ASTEROID CONTAINMENT CODE############################
############################################################################
#Starts a timer to allow asteroids to enter playing field before enforcing 	
func startContainTimer():
	timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 2
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.start()

func _on_timer_timeout():
	timer.stop()
	
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
############################################################################
################END ASTEROID CONTAINMENT CODE###############################

func free_bullet(body):
	timerKillBullet = Timer.new()
	timerKillBullet.wait_time = .1
	timerKillBullet.connect("timeout",self,"_on_timer_free_bullet_timeout", [body])
	timerKillBullet.start()
	self.add_child(timerKillBullet)
	
func _on_timer_free_bullet_timeout(body):
	timerKillBullet.stop()
	body.queue_free()

####################BEGIN ASTEROID PHYSICS CODE###############################
############################################################################
func move_asteroids(delta):

	if (self.get_name().find("Big") != -1):
		self.position += Vector2(1,0)
		self.rotation += 1.5 * delta
	else:
		self.position += vectorHeading
		self.rotation += 1.5 * delta
	


func set_pos_and_trajectory():
	randomize()
	#Sets initial rotation for big asteroids being spawned on parent PathFollow2D
	if (self.get_name().find("Big") != -1):
		get_parent().set_unit_offset(randf())
		get_parent().rotate(rand_range(PI/4, 3 * PI/4))
	else:
		#Sets initial vector for small & medium asteroids which are spawned at location of big asteroid, as opposed to Pathfollow2D
		vectorHeading = Vector2(randf() * 2.0 - 1, randf() * 2.0 - 1)
############################################################################
####################END ASTEROID PHYSICS CODE###############################


############################BEGIN COLLISION CODE############################
############################################################################
func _player_hit():
	print ("Playerr pdsajljdkfjk")

		
func _body_entered( body ):
	if (body.get_name().find("Bullet") != -1):
		hits += 1
#		explosion = scn_explosion.instance()
	#	if body.get_name().match("Bullet"):
		body.get_node("Sprite").set_texture(bulletHitTex)

		
		if (self.get_name().find("Big") != -1 && hits == 5):
			# Spawn 2 medium asteroids after destroying large asteroid, find and play explosion animation
			emit_signal("makeMedium", self.global_position)
			explosion.position = self.global_position
			explosion.get_node("AnimationExplosion").play("explode")
			self.queue_free()
			print (OS.get_datetime().minute)
		elif (self.get_name().find("Medium") != -1 && hits == 5):
			emit_signal("makeSmall", self.global_position)
			explosion.position = self.global_position
			explosion.get_node("AnimationExplosion").play("explodeMedium")
			self.queue_free()
		elif (self.get_name().find("Small") != -1 && hits == 5):
			explosion.position = self.global_position
			explosion.get_node("AnimationExplosion").play("explodeSmall")
			self.queue_free()
			
	elif (body.get_name().find("Player") != -1):
		emit_signal("playerHit")
############################################################################
############################END COLLISION CODE##############################


