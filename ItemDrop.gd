extends KinematicBody2D

var tweenx = 0 
var tweeny = 0

onready var playerDetectionZone = $PlayerDetectionZone
onready var audio = $AudioStreamPlayer2D

var quest = QuestList
var inventoryContainer = InventoryContainer

export(String) var itemname = "Perban"

func _ready():
	var img = load("res://UI/Item/"+itemname+"_Drop"+".png")
	$Sprite.texture = img

func _on_PlayerDetectionZone_body_entered(body):
	audio.play()
	inventoryContainer.item_picked(itemname)
	quest.objective_reached(itemname)
	self.visible = false
	yield(audio, "finished")
	queue_free()

func animate_position_tween(x, y,name):
	var img = load("res://UI/Item/"+name+"_Drop"+".png")
	$Sprite.texture = img
	itemname = name
	tweenx = x
	tweeny = y
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(tweenx, tweeny), 1.2 )

