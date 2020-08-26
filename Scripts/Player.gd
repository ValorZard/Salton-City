extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var horizontal_input := 0.0
var vertical_input := 0.0
var is_interacting := false
var can_interact := false

var current_npc

var player_velocity := Vector2()
var player_speed := 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	set_input()
	set_movement(delta)
	attempt_to_talk()
	#print("is interacting " + str(is_interacting))
	#print("can interact" + str(can_interact))
	pass

func set_input():
	horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vertical_input = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	is_interacting = Input.is_action_pressed("interact")
	
	if(is_interacting):
		print("can interact " + str(can_interact))
	pass

func set_movement(delta):
	player_velocity = player_speed * Vector2(horizontal_input, vertical_input).normalized()
	move_and_slide(player_velocity)

func attempt_to_talk():
	if can_interact and is_interacting:
		current_npc.talk()
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("NPCs"):
		#print("Works?")
		current_npc = body
		can_interact = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.is_in_group("NPCs"):
		can_interact = false
	pass # Replace with function body.
