extends CharacterBody2D

class_name Bullet

var speed: int
var damage: int
var range_time: float
var player_bullet: bool
var bouncing: bool
var transparent: bool

func init(
	speed: int,
	damage: int,
	range_time: float,
	player_bullet: bool,
	bouncing: bool,
	transparent: bool
) -> void:
	self.speed = speed
	self.damage = damage
	self.range_time = range_time
	self.player_bullet = player_bullet
	self.bouncing = bouncing
	self.transparent = transparent
	

var direction : Vector2
var angle: float

func _ready() -> void:
	$Polygon2D.polygon = GlobalVariables.draw_shape(25, 10)
	$Area2D/CollisionPolygon2D.polygon = GlobalVariables.draw_shape(25, 5)
	$CollisionPolygon2D.polygon = GlobalVariables.draw_shape(25, 5)
	
	$Area2D.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))
	
	$RangeTimer.wait_time = range_time
	$RangeTimer.connect("timeout", Callable(self, "_on_range_timer_timeout"))
	$RangeTimer.start()
	
	if transparent:
		$CollisionPolygon2D.disabled = true
		
	if player_bullet:
		modulate = Color.AQUA
	else:
		modulate = Color.FIREBRICK

func _physics_process(delta: float) -> void:
	direction = Vector2(cos(angle), sin(angle))
	velocity = direction * speed
	move_and_slide()
	rotation = direction.angle()
	
	if bouncing:
		for i in range (get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var normal = collision.get_normal()
			if $BounceTimer.is_stopped():
				if abs(normal.x) > abs(normal.y):
					angle = PI - angle
				else:
					angle = -angle
				$BounceTimer.start()
				
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies") and player_bullet:
		body.take_damage(damage)
		queue_free()
	elif body.is_in_group("players") and not player_bullet:
		body.take_damage()
		queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		if not bouncing and not transparent:
			queue_free()
		
func _on_range_timer_timeout():
	queue_free()
