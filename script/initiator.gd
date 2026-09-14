extends Node

const NB_ZOMBIES = 5
const ZOMBIE_SCENE: PackedScene = preload("res://scenes/zombie.tscn")

var _camera: Camera2D
var _generationLabel: GenerationLabel
var _genesLabel: GenesMeilleurIndividuLabel
var algo: AlgoGenetique
var zombies: Array[Zombie] = []
var humains: Array[Human] = []

## limites de la caméra
var _limits: Rect2


func _ready():
	get_tree().paused = true
	_camera = $Camera2D
	_generationLabel = $Camera2D/UI/HBoxContainer/VBoxContainer/GenerationLabel
	_genesLabel = $Camera2D/UI/HBoxContainer/GenesMeilleurIndividu
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
		zombies.append(zombie)
		if !zombie.is_node_ready():
			await zombie.ready
		
	var premierePop:Array[Genes] = algo.intialise()
	await instancieHumains(premierePop)
	
	for humain in humains:
		humain.started = true
	
	get_tree().paused = false


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
		await finGeneration()
		get_tree().paused = false


func finGeneration():
	humains.clear()
	var nouvellePop: Population = algo.finGeneration()
	await instancieHumains(nouvellePop.individus)
	for zombie in zombies:
		zombie.position = _random_position()
		
	_generationLabel.changeGeneration()
	var meilleurPop: Population = algo.getMeilleureAnciennePop()
	_generationLabel.changeFitnessMax(meilleurPop.fitnessMax)
	_genesLabel.changeGenes(meilleurPop.meilleurGene)
	for humain in humains:
		humain.started = true


## applique les nouveaux genes aux humains de la scène
func instancieHumains(nouveauxGenes: Array[Genes]):
	for genes in nouveauxGenes:
		var nouvelHumain: Human = Human.instanciate(genes)
		nouvelHumain.position = _random_position()
		add_child(nouvelHumain)
		if !nouvelHumain.is_node_ready():
			await nouvelHumain.ready
		humains.append(nouvelHumain)
