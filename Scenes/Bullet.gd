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
	if (position.x < 0 || position.x > get_viewport().get_visible_rect().size.x || position.y < 0 || position.y > get_viewport().get_visible_rect().size.y):
		queue_free()
	


