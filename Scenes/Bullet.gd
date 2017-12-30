extends KinematicBody2D

var motion

export var bulletSpeed = 800
onready var player = get_tree().get_current_scene().get_node("Player")

func _ready():
	position = player.position 
	rotation = player.rotation
	motion = Vector2(-sin(rotation), cos(rotation)) 
	set_physics_process(true)

	
func _physics_process(delta):

	position = position + (motion * delta * bulletSpeed)
	

func _on_TimerKill_timeout():
	queue_free()
