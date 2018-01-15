extends Control
var livesIcons
var paused 
var pauseLabel
var scoreLabel
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	makeLivesArray()
	scoreLabel = get_node("ScoreLabel")
	pauseLabel = get_node("PauseLabel")
	paused = false

	
	set_physics_process(true)

func playSound(sound):
	var soundLocation = ("Main/Sounds/" + sound)
	print (soundLocation)
	var soundRoot = get_tree().get_root().get_node(soundLocation)
	print (soundRoot)
	soundRoot.play()

func _physics_process(delta):
	
	scoreLabel.set_text(String(global.score))

	if (Input.is_action_just_pressed("ui_pause")):
		playSound("Pause")
		if (get_tree().is_paused() == false):
			get_tree().set_pause(true)
			pauseLabel.visible = true

		else:
			get_tree().set_pause(false)
			pauseLabel.visible = false
		
	

	
func makeLivesArray():
	livesIcons = get_node("LivesContainer").get_children()

func _on_killed():
	self.get_node("LivesContainer").remove_child(livesIcons[livesIcons.size()-1])
	livesIcons.remove(livesIcons.size() - 1)
	
	
	
func _on_dead():
	pass