extends KinematicBody2D

signal dice_added

var animations =  {
	"idle": "idle",
	"prepare_jump": "prepare_jump",
	"jump": "jump",
	"fall": "fall",
	"land": "land",
	"blink": "blink",
	"quack": "quack"
}

enum State {
	Idle,
	PreparingToJump,
	Jump,
	Fall,
	Land,
}

onready var animated_sprite = $AnimatedSprite
onready var CoyoteJumpTimer = $CoyoteJumpTimer

var Velocity = Vector2()
var current_state = State.Idle
var JumpAvialability: bool
var JumpBufferPressed: bool
var on_floor: bool

export(float) var TimeToJumpPeak = .25
export(int) var JumpHeight = 128
export(int) var JumpDistance = 392
export var JumpPower = 0
export var JumpDirection = Vector2.RIGHT


var MAXSPEED: float
const ACCELERATION = 3000

var GRAVITY: float
var JUMPSPEED: float

func _ready():
	GRAVITY = (2*JumpHeight)/pow(TimeToJumpPeak,2)
	JUMPSPEED = GRAVITY * TimeToJumpPeak
	MAXSPEED = JumpDistance / (2*TimeToJumpPeak)
	

func _physics_process(delta):
	if is_on_floor() or is_on_wall():
		if current_state == State.PreparingToJump and JumpPower <= MAXSPEED:
			JumpPower += 12
			JumpHeight = JumpPower/2
			GRAVITY = (JumpHeight)/pow(TimeToJumpPeak,2)
			JUMPSPEED = GRAVITY * TimeToJumpPeak
			$JumpScale/Scale.region_rect = Rect2(Vector2(0,0), Vector2(int(lerp(0,35, JumpPower/MAXSPEED)),2))
			JumpAvialability = true
	elif JumpAvialability == true && CoyoteJumpTimer.is_stopped():
		CoyoteJumpTimer.start()

func _process(delta):
	#print(State.keys()[current_state])
	if Input.get_action_strength("ui_right") - \
				Input.get_action_strength("ui_left") != 0 and \
				(current_state == State.Idle or \
				current_state == State.PreparingToJump):
		JumpDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if JumpDirection.x > 0:
		animated_sprite.set_flip_h(false)
	if JumpDirection.x < 0:
		animated_sprite.set_flip_h(true)
	
	
	if Input.is_action_just_pressed("ui_accept"):
		if current_state == State.Idle or \
				current_state == State.PreparingToJump:
			$PrepareJumpSound.play()
			current_state = State.PreparingToJump
	
	if Input.is_action_just_released("ui_accept"):
		if current_state == State.PreparingToJump:
			$PrepareJumpSound.stop()
			var jump_out_effect = Global.jump_out_effect_resource.instance()
			jump_out_effect.position = position
			get_parent().add_child(jump_out_effect)
			Jump()
	else:
		Velocity.y += GRAVITY*delta
	
	if is_on_floor():
		if !on_floor and current_state == State.Fall:
			Velocity = Vector2(0,0)
			current_state = State.Land
			var jump_in_effect = Global.jump_in_effect_resource.instance()
			jump_in_effect.position = position
			get_parent().add_child(jump_in_effect)
			on_floor = is_on_floor()
		else:
			on_floor = false
	elif Velocity.y <= 0:
		current_state = State.Jump
	elif Velocity.y >= 0:
		current_state = State.Fall
	
	
	
	if current_state == State.Jump or current_state == State.Fall:
		Velocity.x = JumpDirection.x*JumpPower

	if current_state == State.Idle:
		Velocity = Vector2(0, 0)
		JumpPower = 0
	$JumpScale.visible = current_state == State.PreparingToJump

	match current_state:
		State.Idle:
			return
		State.PreparingToJump:
			animated_sprite.play(animations.prepare_jump)
		State.Jump:
			animated_sprite.play(animations.jump)
		State.Fall:
			animated_sprite.play(animations.fall)
		State.Land:
			animated_sprite.play(animations.land)
			
	Velocity = move_and_slide(Velocity, Vector2.UP)

func Jump():
	Velocity.y = -JUMPSPEED

func _on_IdleTimer_timeout():
	randomize()
	if animated_sprite.animation == animations.idle:
		if randi()%2 > 0:
			animated_sprite.play(animations.quack)
		else:
			animated_sprite.play(animations.blink)
			
func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == animations.land or \
	animated_sprite.animation == animations.quack or \
	animated_sprite.animation == animations.blink:
		current_state = State.Idle
		animated_sprite.play(animations.idle)

func add_dice(number):
	Global.collected_dice.append(number)
	emit_signal("dice_added", number)


func _on_CoyoteJumpTimer_timeout():
	JumpAvialability = false


func _on_Area2D_area_entered(area):
	if area.get_parent().name == "Portal" and area.get_parent().visible:
		get_parent().end_level()


