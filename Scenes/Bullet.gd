extends KinematicBody2D
var bulletHitTex = preload("res://Assets/Space shooter assets (300 assets)/PNG/Lasers/laserRed05.png")
var motion
var playerPos
var playerRot
var xTimer
var explosion
export var bulletSpeed = 400
#onready var player = get_parent()



func _ready():
	motion = Vector2(-sin(rotation), cos(rotation)) 


	

	if (get_node("Sprite").texture == bulletHitTex):
		set_physics_process(true)
	else:
		set_physics_process(false)
		xTimer = Timer.new()
		self.add_child(xTimer)
		xTimer.wait_time = .1
		xTimer.connect("timeout",self,"_on_timer_timeout")
		xTimer.start()
#	
	
func _physics_process(delta):
	position = position + (motion * delta * bulletSpeed)
	if (position.x < 0 || position.x > get_viewport().get_visible_rect().size.x || position.y < 0 || position.y > get_viewport().get_visible_rect().size.y):
		queue_free()
	


	
func _on_timer_timeout():
	self.queue_free()

