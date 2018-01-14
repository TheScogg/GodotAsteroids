extends Control
var livesIcons
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	makeLivesArray()
	set_physics_process(true)


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func makeLivesArray():
	livesIcons = get_node("LivesContainer").get_children()

func _on_killed():
	self.get_node("LivesContainer").remove_child(livesIcons[livesIcons.size()-1])
	livesIcons.remove(livesIcons.size() - 1)
	
func _on_dead():
	pass