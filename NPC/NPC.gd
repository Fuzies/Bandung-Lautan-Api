extends KinematicBody2D

const itemdropNode = preload("res://World/ItemDrop.tscn")

export var object_name = ""
export var quest_name = ""
export var max_objective = 0
export var quest_description = ""
export var quest_reward = ""
export var target_name = ""

export(String, FILE, "*.txt") var dialogue_file_pre_quest
export(String, FILE, "*.txt") var dialogue_file_asking_quest
export(String, FILE, "*.txt") var dialogue_file_completing_quest
export(String, FILE, "*.txt") var dialogue_file_post_quest

onready var playerDetectionZone = $PlayerDetectionZone
onready var guide = $RichTextLabel
onready var dialogue = $Dialogue
onready var quest = QuestList
var index = 0
var reward_dropped = false

func _ready():
	dialogue.dialogue_file = dialogue_file_pre_quest

func _on_HurtBoxInterract_area_entered(area):
	var quest_complete = quest.check_quest_completion(quest_name)
	#print(index)
	#print(quest_complete)
	if index == 0 and max_objective != 0:
		find_and_use_dialogue()
		quest.take_quest(quest_name, quest_description, quest_reward, max_objective, target_name)
		index += 1
	elif index == 0 and max_objective == 0:
		find_and_use_dialogue()

	if quest_complete and index != 2:
		index = 2
		dialogue.dialogue_file = dialogue_file_completing_quest
		if quest_reward != "" and !reward_dropped:
			reward_dropped = true
			var itemdrop = itemdropNode.instance()
			var tweenpos
			get_parent().call_deferred("add_child",itemdrop)
			yield(get_tree().create_timer(0.00001), "timeout")
			itemdrop.global_position = global_position
			tweenpos = global_position + Vector2(rand_range(-32,32),rand_range(-32,32))
			itemdrop.animate_position_tween(tweenpos.x, tweenpos.y, quest_reward)
		find_and_use_dialogue()
	if index == 2:
		if dialogue_file_post_quest != null:
			dialogue.dialogue_file = dialogue_file_post_quest
			find_and_use_dialogue()
	if quest_complete == false:
		dialogue.dialogue_file = dialogue_file_asking_quest
		find_and_use_dialogue()
		
func _on_PlayerDetectionZone_body_entered(body):
	guide.visible = true

func _on_PlayerDetectionZone_body_exited(body):
	guide.visible = false
 
func find_and_use_dialogue():
	var dialogue_player = get_node_or_null("Dialogue")
	
	if dialogue_player:
		dialogue_player.play()
