extends PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var npc_name setget name_set
var dialogue setget dialogue_set
var answers setget answers_set

var npc 

onready var answer_labels := []
export var answer_buffer := 15
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false) #cuz its hidden
	pass # Replace with function body.

func name_set(new_name):
	npc_name = new_name
	get_node("DialogueBox/NPCName").text = npc_name
	pass

func dialogue_set(new_dialogue):
	dialogue = new_dialogue
	get_node("DialogueBox/Dialogue").text = dialogue
	pass

func answers_set(new_value):
	answers = new_value
	get_node("DialogueBox/Answers").text = new_value
	pass

func open():
	get_tree().paused = true #pause game
	popup() #popup
	get_node("AnimationPlayer").playback_speed = 60.0 / dialogue.length()
	get_node("AnimationPlayer").play("ShowDialogue")
	pass

func close():
	get_tree().paused = false
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

##REDO THIS CODE I DONT LIKE THIS
# make this much less key dependent

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Z:
			set_process_input(false)
			npc.talk("A")
		elif event.scancode == KEY_X:
			set_process_input(false)
			npc.talk("B")

func set_answers(answers_array):
	#delete the labels that were in the answers
	for label in answer_labels:
		label.queue_free()
	answer_labels.clear()
	
	var answer_number := 0
	var dialogue_label := get_node("DialogueBox/Dialogue")
	
	for answer in answers_array:
		var answer_label := Label.new()
		answer_label.text = answer
		#offset
		var vertical_offset = dialogue_label.rect_global_position.y + dialogue_label.rect_size.y + (answer_buffer * answer_number)
		var horizontal_offset = dialogue_label.rect_global_position.x + rect_size.x/2
		answer_label.rect_position = Vector2(horizontal_offset, vertical_offset)
		#color
		answer_label.set("custom_colors/font_color", Color("Black"))
		#child
		add_child(answer_label)
		answer_labels.append(answer_label)
		answer_number += 1
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	set_process_input(true) #NOW you can do input
	pass # Replace with function body.
