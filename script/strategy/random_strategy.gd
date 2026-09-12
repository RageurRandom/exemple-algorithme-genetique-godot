class_name RandomStrategy extends AStrategy

func getTargetVector(_human: Human, _zombies:Array[Zombie])->Vector2:
	return Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
