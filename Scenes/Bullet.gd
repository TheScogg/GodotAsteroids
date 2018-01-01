extends KinematicBody2D

var motion
var playerPos
var playerRot

export var bulletSpeed = 800
#onready var player = get_parent()



func _ready():

	motion = Vector2(-sin(rotation), cos(rotation)) 
	set_physics_process(true)
	
	
	

	
func _physics_process(delta):

	position = position + (motion * delta * bulletSpeed)
	

func _on_TimerKill_timeout():
	queue_free()
