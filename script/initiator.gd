extends Node

const NB_ZOMBIES = 10
const ZOMBIE_SCENE: PackedScene = preload("res://scenes/zombie.tscn")

var _camera: Camera2D
var _generationLabel: GenerationLabel
var _genesLabel: GenesMeilleurIndividuLabel
var algo: AlgoGenetique
var humains: Array[Human]

## limites de la caméra
var _limits: Rect2


func _ready():
	_camera = $Camera2D
	_generationLabel = $UI/HBoxContainer/VBoxContainer/GenerationLabel
	_genesLabel = $UI/HBoxContainer/GenesMeilleurIndividu
	algo = $AlgoGenetique
	
	assert(_camera != null, "noeud de camera null")
	assert(_generationLabel != null, "label generation null")
	assert(_genesLabel != null, "label meilleures genes null")
	assert(algo != null, "noeud d'algo genetique null")
	
	var viewport_size := _camera.get_viewport_rect().size / _camera.zoom
	_limits = Rect2(
		_camera.get_screen_center_position() - viewport_size / 2.0,
		viewport_size
	)

	for i in NB_ZOMBIES:
		var zombie: Zombie = ZOMBIE_SCENE.instantiate()
		zombie.position = _random_position()
		add_child(zombie)
		
	var premierePop:Array[Genes] = algo.intialise()
	instancieHumains(premierePop)


## Renvoie une position aléatoire dans les limites de la camera
func _random_position() -> Vector2:
	return Vector2(
		randf_range(_limits.position.x, _limits.end.x),
		randf_range(_limits.position.y, _limits.end.y)
	)


# Appelé toutes les frames
func _process(_delta: float) -> void:
	# check if no humans left
	if(get_tree().get_nodes_in_group("human") == null || get_tree().get_nodes_in_group("human").is_empty()):
		get_tree().paused = true
		finGeneration()
		get_tree().paused = false


func finGeneration():
	var nouvellePop = algo.finGeneration()
	instancieHumains(nouvellePop.individus)
	_generationLabel.changeGeneration()
	var meilleurPop: Population = algo.getMeilleureAnciennePop()
	_generationLabel.changeFitnessMax(meilleurPop.fitnessMax)
	_genesLabel.changeGenes(meilleurPop.meilleurGene)


## applique les nouveaux genes aux humains de la scène
func instancieHumains(nouveauxGenes: Array[Genes]):
	for genes in nouveauxGenes:
		var nouvelHumain: Human = Human.instanciate(genes)
		nouvelHumain.position = _random_position()
		add_child(nouvelHumain)
