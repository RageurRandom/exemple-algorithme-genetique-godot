extends Label

const TEXT = "Vitesse : x%d"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = TEXT % Engine.time_scale
