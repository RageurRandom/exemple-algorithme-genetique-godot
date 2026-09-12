class_name Zombie extends CharacterBody2D

@export var speed: float = 50

func _physics_process(_delta: float) -> void:
	var humans: Array[Node2D] = []
	for human: Node in get_tree().get_nodes_in_group("human"):
		if human is Node2D:
			humans.append(human)
	
	if !humans.is_empty() :
		var target: Node2D = Utils.getNearest(self, humans)
		velocity = (target.global_position - global_position).normalized() * speed
		move_and_slide()
		if get_last_slide_collision() != null and get_last_slide_collision().get_collider() is Human:
			var collider: Human = get_last_slide_collision().get_collider()
			collider.die()
