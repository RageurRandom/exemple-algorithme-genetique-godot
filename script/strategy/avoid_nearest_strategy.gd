class_name AvoidNearestStrategy extends AStrategy

func getTargetVector(human: Human, zombies:Array)->Vector2:
	var nearestEnemy: Vector2 = Utils.getNearest(human, zombies).global_position
	return (human.global_position - nearestEnemy).normalized()
