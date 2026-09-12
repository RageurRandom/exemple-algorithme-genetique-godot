class_name Utils

static func getNearest(caster: Node2D, targets: Array)->Node2D:
	var tab2D: Array = targets.filter(func (node:Node)->bool: return node is Node2D).map(func (node:Node)->Node2D:
		return node as Node2D)
	
	var target: Node2D = tab2D.get(0)
	
	for node in tab2D:
		if getDistance(caster, node) < getDistance(caster, target):
			target = node
	
	return target

static func getDistance(a:Node2D, b: Node2D)-> float:
	return b.global_position.distance_to(a.global_position)
