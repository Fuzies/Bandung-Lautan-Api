extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 100
export var FRICTION = 500

const bulletPath = preload("res://Player/Bullet.tscn")
const inventoryslotpath = preload("res://UI/InventorySlotDisplay.tscn")

enum{
	MOVE,
	ATTACK,
	INTERRACT
}

var state = MOVE
var velocity = Vector2.ZERO
var knockback_vector2 = Vector2.DOWN
var stats = PlayerStats # akses ke PlayerStats.tscn lewat auto load di setting project
var velocity_temp = Vector2.ZERO
var ammo_exist

onready var animationPlayer = $AnimationPlayer #onready = _ready()
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") #akses animationnodestate pada $animationTree
onready var hitboxBambu = $HitboxPivot/HitboxBambu
onready var hurtbox = $Hurtbox
onready var interractCollision = $HitBoxInterract/CollisionShape2D
onready var joystick = $CanvasLayer/Joystick/Joystick_Button
onready var audiostreamplayer = $AudioStreamPlayer
onready var bulletposition = $Node2D/BulletPosition
onready var bulletnode = $Node2D

func _ready():
	randomize()
	interractCollision.set_deferred("disabled", true) #perlu perbaikan
	stats.connect("death", self, "queue_free")#gunakan func queue_free saat health habis
	animationTree.active = true
	hitboxBambu.knockback_vector = knockback_vector2

func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
	#	shoot()
	bulletnode.look_at(velocity_temp) 
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		INTERRACT:
			interract_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector == Vector2.ZERO:
		input_vector = joystick.get_value()
	

	if input_vector != Vector2.ZERO:
		hitboxBambu.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Interract/blend_position", input_vector)
		animationTree.set("parameters/Shoot/blend_position", input_vector)
		velocity_temp_record(input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
		
			#animationState.travel("Interract")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		ammo_exist = inventoryslotpath.instance().check_available_ammo()
		state = ATTACK
	elif Input.is_action_just_pressed("Interract"):
		state = INTERRACT

func attack_state(delta):
	var inventoryslot = inventoryslotpath.instance()
	if !inventoryslot.check_hand_weapon():
		velocity = Vector2.ZERO
		animationState.travel("Attack")
	else:
		velocity = Vector2.ZERO
		
		if ammo_exist:
			animationState.travel("Shoot")
		elif !ammo_exist:
			animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
	
func interract_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Interract")

func interract_animation_finished():
	audiostreamplayer.playing = false
	state = MOVE

func _on_Hurtbox_area_entered(area): #ketika bertabrakan dengan musuh
	stats.health -= area.damage
	Global.camera.shake(0.2,1)
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()

func shoot():
	var bullet = bulletPath.instance()
	bullet.knockback_vector = Vector2.ZERO
	#bullet.set_collision_mask_bit(3, true)
	get_parent().add_child(bullet)
	bullet.position = bulletposition.global_position
	bullet.velocity = velocity_temp
	bullet.rotation_degrees = rad2deg(velocity_temp.angle())
	play_shoot_sound()
	#print(rad2deg(velocity_temp.angle()))

func velocity_temp_record(vector2):
	if vector2 != Vector2.ZERO:
		#print(vector2)
		velocity_temp.x = round(vector2.x)
		velocity_temp.y = round(vector2.y)
	#print(velocity_temp)

func play_shoot_sound():
	audiostreamplayer.stream = load("res://Player/Shoot.mp3")
	audiostreamplayer.volume_db = 0
	audiostreamplayer.play()
