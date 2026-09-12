class_name AvoidCornerStrategy extends AStrategy

const EDGE_MARGIN := 120.0
const EDGE_STRENGTH := 4.0
const ZOMBIE_AVOID_DISTANCE := 220.0
const ZOMBIE_AVOID_STRENGTH := 3.0
const WANDER_STRENGTH := 0.8
const DIRECTION_CHANGE_TIME := 0.8

var wander_direction := Vector2.RIGHT.rotated(randf_range(0.0, TAU))
var direction_change_timer := 0.0

func getTargetVector(human: Human, zombies: Array[Zombie]) -> Vector2:
	var current_time := Time.get_ticks_msec() / 1000.0
	if current_time - direction_change_timer > DIRECTION_CHANGE_TIME:
		direction_change_timer = current_time
		wander_direction = wander_direction.rotated(randf_range(-0.7, 0.7)).normalized()

	var target_vector := wander_direction * WANDER_STRENGTH

	if !zombies.is_empty():
		var nearest_enemy: Node2D = Utils.getNearest(human, zombies)
		var away_vector := (human.global_position - nearest_enemy.global_position).normalized()
		var distance_to_enemy := human.global_position.distance_to(nearest_enemy.global_position)
		var proximity = 1.0 - clamp(
			distance_to_enemy / ZOMBIE_AVOID_DISTANCE,
			0.0,
			1.0
		)

		if proximity > 0.0:
			var tangent_vector := Vector2(-away_vector.y, away_vector.x)
			if tangent_vector.dot(wander_direction) < 0.0:
				tangent_vector = -tangent_vector
			target_vector += (
				away_vector + tangent_vector * 1.5
			) * proximity * ZOMBIE_AVOID_STRENGTH

	var edge_vector := _get_edge_vector(human)

	target_vector += edge_vector * EDGE_STRENGTH
	return target_vector.normalized() if target_vector != Vector2.ZERO else Vector2.RIGHT

func _get_edge_vector(human: Human) -> Vector2:
	var camera := human.get_viewport().get_camera_2d()
	if camera == null:
		return Vector2.ZERO

	var viewport_size := camera.get_viewport_rect().size / camera.zoom
	var screen_center := camera.get_screen_center_position()
	var screen_rect := Rect2(screen_center - viewport_size / 2.0, viewport_size)
	var position := human.global_position
	var force := Vector2.ZERO

	var distance_to_left := position.x - screen_rect.position.x
	var distance_to_right := screen_rect.end.x - position.x
	var distance_to_top := position.y - screen_rect.position.y
	var distance_to_bottom := screen_rect.end.y - position.y

	if distance_to_left < EDGE_MARGIN:
		force.x += 1.0 - clamp(distance_to_left / EDGE_MARGIN, 0.0, 1.0)
	if distance_to_right < EDGE_MARGIN:
		force.x -= 1.0 - clamp(distance_to_right / EDGE_MARGIN, 0.0, 1.0)
	if distance_to_top < EDGE_MARGIN:
		force.y += 1.0 - clamp(distance_to_top / EDGE_MARGIN, 0.0, 1.0)
	if distance_to_bottom < EDGE_MARGIN:
		force.y -= 1.0 - clamp(distance_to_bottom / EDGE_MARGIN, 0.0, 1.0)

	return force.normalized() if force != Vector2.ZERO else Vector2.ZERO
