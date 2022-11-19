extends Node

class_name Quest_List

const questNode = preload("res://Quest/Quest.tscn")

var quest = questNode.instance().duplicate()
var quest_array = []

signal increment_objective(obj, q_name, max_obj)
signal quest_has_been_taken(q_name, description, objective, max_obj)
signal quest_has_been_completed(q_name)

func _ready():
	pass

func take_quest(q_name, description, reward, max_obj, target):
	var array_size_index_temp
	var objective = 0
	var quest_taken = true
	array_size_index_temp = quest_array.size()
	#print("Quest diambil pada list ke :",array_size_index_temp)
	quest_array.append(quest.duplicate())
	quest_array[array_size_index_temp].quest_taken = true
	quest_array[array_size_index_temp].quest_name = q_name
	quest_array[array_size_index_temp].max_objective = max_obj
	quest_array[array_size_index_temp].quest_description = description
	quest_array[array_size_index_temp].quest_reward = reward
	quest_array[array_size_index_temp].target_name = target
	emit_signal("quest_has_been_taken", q_name, description, objective, max_obj)

func objective_reached(value):
	#print("objective_reached working ", value)
	for i in quest_array.size():
		if quest_array[i].target_name == value and quest_array[i].quest_complete == false:
			quest_array[i].objective += 1
			emit_signal("increment_objective",quest_array[i].objective, quest_array[i].quest_name, quest_array[i].max_objective)
			#print("objective_reached :", value, " target item : ", quest_array[i].target_name, " Quest : ", quest_array[i].quest_name)

func check_quest_completion(quest_name):
	var index_check = null
	for i in quest_array.size():
		if quest_array[i].quest_name == quest_name:
			if quest_array[i].objective >= quest_array[i].max_objective and !quest_array[i].quest_complete:
				print("Quest Completed")
				emit_signal("quest_has_been_completed", quest_name)
				quest_array[i].quest_complete = true
				index_check = i
	if index_check != null:
		return true
	else:
		return false

func get_array_size():
	return quest_array.size()
