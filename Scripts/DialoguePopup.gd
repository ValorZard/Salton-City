extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var npc_name setget name_set
var dialogue setget dialogue_set
var answers setget answers_set

var npc 

onready var answer_labels := []
export var answer_buffer := 15 # between dialogue and answers labels in pixels

var menu_buffer := 0.5 
var buffer_left = menu_buffer #time till input
var menu_input_bool := false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false) #cuz its hidden
	visible = false
	pass # Replace with function body.

func name_set(new_name):
	npc_name = new_name
	get_node("NPCName").text = npc_name
	pass

func dialogue_set(new_dialogue):
	dialogue = new_dialogue
	get_node("ScrollContainer/Dialogue").text = dialogue
	pass

func answers_set(new_value):
	answers = new_value
	get_node("Answers").text = new_value
	pass

func open():
	get_tree().paused = true #pause game
	visible = true #popup
	menu_input_bool = true
	pass

func close():
	get_tree().paused = false
	visible = false
	set_process_input(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_if_allows_input(delta)
	pass

#this adds a buffer to the menu so that you dont instantly exit out
func check_if_allows_input(delta):
	if(menu_input_bool):
		buffer_left -= delta
		if(buffer_left <= 0):
			menu_input_bool = false
			set_process_input(true)
			buffer_left = menu_buffer
	pass

##REDO THIS CODE I DONT LIKE THIS
# make this much less key dependent

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Z:
			set_process_input(false)
			npc.talk("1")
		elif event.scancode == KEY_X:
			set_process_input(false)
			npc.talk("2")
		elif event.scancode == KEY_C:
			set_process_input(false)
			npc.talk("3")

func set_answers(answers_array):
	#delete the labels that were in the answers
	for label in answer_labels:
		label.queue_free()
	answer_labels.clear()
	
	var answer_number := 0
	var dialogue_node:= get_node("ScrollContainer")
	
	for answer in answers_array:
		var answer_label := Label.new()
		answer_label.text = answer
		#offset
		var vertical_offset = dialogue_node.rect_global_position.y + dialogue_node.rect_size.y + (answer_buffer * answer_number)
		var horizontal_offset = dialogue_node.rect_global_position.x + rect_size.x/2
		answer_label.rect_position = Vector2(horizontal_offset, vertical_offset)
		#color
		answer_label.set("custom_colors/font_color", Color(0, 0, 0))
		#child
		add_child(answer_label)
		answer_labels.append(answer_label)
		answer_number += 1
		print("HELP " + str(answer_label.get_global_transform()))
	pass

