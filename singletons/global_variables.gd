extends Node

func draw_shape(points_count: int, radius: float) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(points_count + 1):
		var point = deg_to_rad(i * 360 / points_count - 90)
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * radius)
		
	return points
