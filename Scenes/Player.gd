extends KinematicBody2D

var screensize
var motion
var prevMotion
export var SPEED = 400
export var DETERIORATION = -.05
var rotateBoost
var direction
var velocity
var canShoot = true
var lives = 3
var asteroid
var engineSprites = []
var bullet
onready var bullets = preload("res://Scenes/Bullet.tscn")

func _ready():

	


	
	screensize = get_viewport().get_visible_rect().size
	position = screensize / 2
	motion = Vector2(0,0)

	#Forward is 1, Backwards is -1
	direction = 1
	set_physics_process(true)
	
	engineSprites = get_tree().get_nodes_in_group("Thrusters")



	
func _physics_process(delta):

		#Instance bullet scene upon Space Bar press
	if (Input.is_action_pressed("ui_select")):
		if (canShoot == true):
			bullet = bullets.instance()
			bullet.position = self.position
			bullet.rotation = self.rotation

			get_parent().add_child(bullet)
#			self.add_child(bullet)
			$TimerBulletTimeout.start()
		canShoot = false
	
	###############################################################################
	##PLAYER MOVEMENT CODE
	###############################################################################
	#Default rotation speed, unless rotate boost is engaged with "ui_shift"
	rotateBoost = 2
	SPEED = 400
	

	
	#Hold shift for tighter turns, deteriorates after use
	if (Input.is_action_pressed("ui_shift")):
		SPEED = SPEED * 1.5
	#Drag on ship when throttle is not on
	
	#If no forward or backwards thrust, turn off thruster sprites and deteriorate velocity 
	if (!Input.is_action_pressed("ui_up") && !Input.is_action_pressed("ui_down")):
		for i in range(4):
			engineSprites[i].visible = false
		motion = motion * .98

	#If pressing up, show forward thrusters. Deteriorate if moving backwards, and reverse direction when threshold reached
	if (Input.is_action_pressed("ui_up")):
		for i in range(2):
			engineSprites[i].visible = true
		if (abs(motion.x) > .04 && abs(motion.y) > .04 && direction == -1):
			motion = motion * .90
		else:
			direction = 1
			motion = Vector2(-sin(rotation), cos(rotation)) * SPEED * delta * direction
		
	#When braking with down arrow, motion deteriorates
	if (Input.is_action_pressed("ui_down")):
		for i in range(2):
			engineSprites[i+2].visible = true
		if (abs(motion.x) > .04 && abs(motion.y) > .04 && direction == 1):
			motion = motion * .90
		else:
			direction = -1
			motion = Vector2(-sin(rotation), cos(rotation)) * SPEED * delta * direction
		
	if (Input.is_action_pressed("ui_right")):
		self.rotate(delta * rotateBoost * direction)
	if (Input.is_action_pressed("ui_left")):
		self.rotate(-delta * rotateBoost * direction)
	#########################################################################################
		
	#Wraps character around when they reach edges of screen
	if (position.y <= 0):
		position.y = screensize.y - 1
	if (position.y >= screensize.y):
		position.y = 0
	if (position.x <= 0):
		position.x = screensize.x - 1
	if (position.x >= screensize.x):
		position.x = 0

	position = position + motion

func playerLives():
	lives -= 1
	print (lives)

func _player_hit():
	print ("Yo you got hit fool")
	playerLives()

	

	


	###############################################################################

func _on_Timer_timeout():
	print (lives)
	canShoot = true
	$TimerBulletTimeout.start()


func _on_Area2D_playerHit():
	print ("FUCK OFF")
