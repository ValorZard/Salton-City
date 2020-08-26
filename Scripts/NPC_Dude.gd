extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum QuestStatus {NOT_STARTED, STARTED, COMPLETED}
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state := "Dialogue1" #current state of the dialogue
var necklace_found := false

onready var dialoguePopup = get_node("../Player/UI_Layers/DialoguePopup")
onready var player = get_tree().root.get_node("Player")

onready var path_to_dialogue = "res://Dialogues/Fiona.json"
var raw_dialogue := ""

onready var answer_dictionary = Dictionary()
var json_reader := Dictionary()

enum Potion {HEALTH, MANA} #reward for the quest

# Called when the node enters the scene tree for the first time.
func _ready():
	raw_dialogue = load_file(path_to_dialogue)
	json_reader = Dictionary(parse_json(raw_dialogue))
	pass # Replace with function body.

func load_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var file_str = ""
	
	while not file.eof_reached(): #iterate through all file lines
		file_str += file.get_line()
		pass
	
	file.close()
	
	return file_str
	pass

func talk(answer = ""):
	#Set Fiona's animation to "talk"
	get_node("AnimatedSprite").play("talk")
	
	#set dialogue
	if(answer_dictionary.has(answer)):
		var answer_text = answer_dictionary[answer]
		dialogue_state = json_reader["dialogues"][dialogue_state]["answers"][answer_text]
	
	if(dialogue_state == "END"):
		#reset dialogue state
		dialogue_state = "Dialogue1"
		#Close dialogue popup
		dialoguePopup.close()
		#Set Fiona's animation to "idle"
		get_node("AnimatedSprite").play("idle")
	else:
		#print player
		dialoguePopup.npc = self
		dialoguePopup.npc_name = json_reader["firstName"] + " " + json_reader["lastName"]
	
		#print dialogues
	
		dialoguePopup.dialogue = json_reader["dialogues"][dialogue_state]["dialogueText"]
	
		#add answers to dialogue
		answer_dictionary.clear() #this stores the answers in relation to number-strings
		var answer_array = []
		var answer_index = 1
	
		for potential_answer in json_reader["dialogues"][dialogue_state]["answers"]:
			answer_dictionary[str(answer_index)] = potential_answer
			answer_array.append(potential_answer)
			answer_index += 1
			pass
	
		dialoguePopup.set_answers(answer_array)
		dialoguePopup.open()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	pass # Replace with function body.
