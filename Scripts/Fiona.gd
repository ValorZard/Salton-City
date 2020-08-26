extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum QuestStatus {NOT_STARTED, STARTED, COMPLETED}
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state := 0 #current state of the dialogue
var necklace_found := false

onready var dialoguePopup = get_node("../Player/UI_Layers/DialoguePopup")
onready var player = get_tree().root.get_node("Player")

enum Potion {HEALTH, MANA} #reward for the quest

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func talk(answer = ""):
	#Set Fiona's animation to "talk"
	get_node("AnimatedSprite").play("talk")
	
	#Set dialoguePopup npc to Fiona
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Fiona"
	
	#Show the current dialogue
	#a code version of a flowchart for dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hello adventurer! I've lost my necklace, could you find it for me?"
					dialoguePopup.set_answers(["[1] Yes", "[2] No"])
					dialoguePopup.open()
					pass
				1:
					match answer:
						"1":
							#Update dialogue tree state
							dialogue_state = 2
							#Show dialogue popup
							dialoguePopup.dialogue = "Thank you!"
							dialoguePopup.set_answers(["[1] Bye"])
							dialoguePopup.open()
							pass
						"2":
							#Update dialogue tree state
							dialogue_state = 3
							#Show dialogue popup
							dialoguePopup.dialogue = "If you change your mind, you'll find me here...."
							dialoguePopup.set_answers(["[1] Bye"])
							dialoguePopup.open()
							pass
				2:
					#Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					#Close dialogue popup
					dialoguePopup.close()
					#Set Fiona's animation to "idle"
					get_node("AnimatedSprite").play("idle")
					pass
				3:
					#Update dialogue tree state
					dialogue_state = 0
					#Close dialogue popup
					dialoguePopup.close()
					#Set Fiona's animation to 'idle'
					get_node("AnimatedSprite").play("idle")
					pass
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					#Update dialogue tree state
					dialogue_state = 1
					#Show dialogue popup
					dialoguePopup.dialogue = "Did you find my necklace?"
					if necklace_found:
						dialoguePopup.set_answers(["[1] Yes", "[2] No"])
					else:
						dialoguePopup.set_answers(["[1] No"])
					dialoguePopup.open()
					pass
				1:
					if necklace_found and answer == "1":
						#Update dialogue tree state
						dialogue_state = 2
						#Show dialogue popup
						dialoguePopup.dialogue = "You're my hero! Please take this potion as thanks!"
						dialoguePopup.set_answers(["[1] Thanks"])
						dialoguePopup.open()
					else:
						#Update dialogue tree state
						dialogue_state = 3
						#Show dialogue popup
						dialoguePopup.dialogue = "Please, find it!"
						dialoguePopup.set_answers(["[1] I'll try...."])
						dialoguePopup.open()
					pass
				2:
					#Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					#Close dialogue popup
					dialoguePopup.close()
					#Set Fiona's animation to "idle"
					get_node("AnimatedSprite").play("idle")
					#Add rewards - TODO
					pass
				3:
					#Update dialogue tree state
					dialogue_state = 0
					#Close dialogue popup
					dialoguePopup.close()
					#Set Fiona's animation to "idle"
					get_node("AnimatedSprite").play("idle")
					pass
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					#Update dialogue tree state
					dialogue_state = 1
					#Show dialogue popup
					dialoguePopup.dialogue = "Thanks again for your help"
					dialoguePopup.set_answers(["[1] Bye"])
					dialoguePopup.open()
					pass
				1:
					#Update dialogue tree state
					dialogue_state = 0
					#Close dialogue popup
					dialoguePopup.close()
					#Set Fiona's animation to "idle"
					get_node("AnimatedSprite").play("idle")
					pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		body.can_interact = true
		pass
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.is_in_group("Players"):
		body.can_interact = false
		pass
	pass # Replace with function body.
