extends KinematicBody2D

onready var area2d = $Area2D
onready var bulletSprite = $Area2D/Sprite
onready var timer = $Timer

var velocity = Vector2(1, 0)
var speed = 500
var knockback_vector
var inventory = InventoryContainer
var real_velocity = Vector2.LEFT

func _ready():
	timer.connect("timeout", self, "_on_timer_timeout")
	inventory.inventorySlotDisplay.decrease_ammo()
	area2d.knockback_vector = knockback_vector
	bullet_timer()

func _physics_process(delta):
	if velocity == Vector2.ZERO:
		queue_free()
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if collision_info != null:
		queue_free()

func bullet_timer():
	timer.start(2)

func _on_timer_timeout():
	queue_free()
