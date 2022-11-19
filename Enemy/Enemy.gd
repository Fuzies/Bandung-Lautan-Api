extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effect/EnemyDeathEffect.tscn")
const itemdropNode = preload("res://World/ItemDrop.tscn")
var damage_text = preload("res://Effect/Damage_Number.tscn")

export(String, FILE, "*.png") var costum_move_spritesheet = null
export var object_name = ""
export var ACCELERATION = 300
export var MAX_SPEED = 70
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
export var attack = 1
export var hp = 1
export var itemdrop_name = ""
export var hatdrop_name = ""
export var torsodrop_name = ""
export var pantsdrop_name = ""
export var shoesdrop_name = ""
export var is_enemy_boss = 0 #0 jika bukan boss, selain 0 merepresentasikan stage

enum{
	IDLE,
	WANDER,
	CHASE
}

var quest = QuestList
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE


#onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtBox = $Hurtbox
onready var softCollision = $SoftCollision
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var wanderControler = $WanderController
onready var line2d = $Line2D
onready var statlabel = $Label
onready var hitbox = $HitboxEnemy
onready var sprite = $Sprite

func _ready():
	if costum_move_spritesheet != null:
		sprite.texture = load(costum_move_spritesheet)
	stats.set_base_attack(attack)
	stats.set_health(hp)
	stats.connect("health_changed",self, "update_health_display")
	hitbox.damage = attack
	state = pick_random_state([IDLE, WANDER])
	statlabel.text = str("HP :",stats.health," ATK : ",stats.base_attack)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
func _process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animationState.travel("Idle")
			seek_player()
			
			if wanderControler.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderControler.start_wander_timer(rand_range(1, 3))
		WANDER:
			seek_player()
			if wanderControler.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderControler.start_wander_timer(rand_range(1, 3))
			
			var direction = global_position.direction_to(wanderControler.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			if velocity != null:
				animationTree.set("parameters/Run/blend_position", direction)
				animationTree.set("parameters/Idle/blend_position", direction)
				animationState.travel("Run")
			if global_position.distance_to(wanderControler.target_position) <= WANDER_TARGET_RANGE:
				state = pick_random_state([IDLE, WANDER])
				wanderControler.start_wander_timer(rand_range(1, 3))
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction  = (player.global_position  - global_position).normalized()
				animationTree.set("parameters/Idle/blend_position", direction)
				animationTree.set("parameters/Run/blend_position", direction)
				animationState.travel("Run")
				#line2d.global_position = Vector2.ZERO
				velocity = velocity.move_toward(direction * MAX_SPEED,ACCELERATION * delta)
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400  # dorong ketika soft colision overlap
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	var damage_output = damage_text.instance()
	get_parent().add_child(damage_output)
	damage_output.global_position.x = global_position.x - 4
	damage_output.global_position.y = global_position.y - 50
	damage_output.set_values_and_animate(str(area.damage),get_parent().global_position, 1, 1)
	knockback += area.knockback_vector * 150
	hurtBox.create_hit_effect()

func _on_Stats_death():
	quest.objective_reached(object_name)
	var itemdrop = itemdropNode.instance()
	var dropgracha = int(rand_range(0,1000))
	var tweenpos
	var item_name = "404"
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	if velocity.x <= -1:
		enemyDeathEffect.scale.x *= -1
	if itemdrop_name != null and hatdrop_name != null and torsodrop_name != null and pantsdrop_name != null and shoesdrop_name != null:	
		if dropgracha <= 1000:
			item_name = itemdrop_name
			if dropgracha <= 100:
				item_name = hatdrop_name
				if dropgracha <= 75:
					item_name = torsodrop_name
					if dropgracha <= 50:
						item_name = pantsdrop_name
						if dropgracha <= 25:
							item_name = shoesdrop_name
			#print(dropgracha, " item :", item_name) #debug dropitem
			get_parent().call_deferred("add_child",itemdrop)
			yield(get_tree().create_timer(0.05), "timeout")
			itemdrop.global_position = global_position
			tweenpos = global_position + Vector2(rand_range(-32,32),rand_range(-32,32))
			itemdrop.animate_position_tween(tweenpos.x, tweenpos.y, item_name)
	#get_parent().remove_child(self)
	queue_free()
	
func update_health_display(health):
	statlabel.text = str("HP :",health," ATK : ",stats.base_attack)
