extends CharacterBody2D

class_name Player

@export var health: int
@export var speed: int
@export var damage: int
@export var fire_rate: float
@export var bullet_range: float
@export var bullet_speed: int

@export var shape_points: int
@export var shape_color: Color

var direction: Vector2
var deadzone: float = 0.1

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")

func _ready() -> void:
	$Polygon2D.polygon = GlobalVariables.draw_shape(shape_points, 25)
	$CollisionPolygon2D.polygon = GlobalVariables.draw_shape(shape_points, 15)
	$Reticle.polygon = GlobalVariables.draw_shape(4, 20)
	
	$Polygon2D.modulate = shape_color
	
	InputMap.action_set_deadzone("look_up", deadzone)
	InputMap.action_set_deadzone("look_down", deadzone)
	InputMap.action_set_deadzone("look_left", deadzone)
	InputMap.action_set_deadzone("look_right", deadzone)
	
	$FireRateTimer.wait_time = fire_rate

func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("shoot") and $FireRateTimer.is_stopped():
		$FireRateTimer.start()
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.init(bullet_speed, damage, bullet_range, true, false, false)
		bullet.position = global_position
		bullet.angle = rotation - PI / 2
		get_tree().current_scene.add_child(bullet)
		
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	
	var look_vector = Vector2.ZERO
	var point
	var angle
	look_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	look_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	$Reticle.global_position = (position + look_vector * 200)
	point = $Reticle.global_position - global_position
	if look_vector == Vector2.ZERO:
		$Reticle.visible = false
	else:
		$Reticle.visible = true
	angle = point.angle()
	rotation = angle + PI / 2
