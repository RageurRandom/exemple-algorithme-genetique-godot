## Humain physiquement présent dans le jeu
##
class_name Human extends CharacterBody2D

const HUMAN_SCENE = preload("res://scenes/human.tscn")

## L'IA de l'humain (actuellement une seule est "fonctionnelle")
var strategy: AStrategy

var isDead: bool = false # patch de merde
var started: bool = false # second patch de merde

var genes: Genes :
	set(val): # réajuste automatiquement la taille
		genes = val
		self.scale = Vector2(genes.taille, genes.taille)

# possibilité de modifier la génération intiale


## Instancie un humain.
## Si tu comprends pas pourquoi je fais comme ça pose pas trop de questions stp.
static func instanciate(_genes = Genes.new())->Human:
	var retour: Human = HUMAN_SCENE.instantiate()
	retour.genes = _genes
	retour.strategy = AvoidCornerStrategy.new()
	
	return retour




# Executée toutes les frames
func _physics_process(_delta: float) -> void:
	var zombies: Array[Zombie] = []
	for zombie: Node in get_tree().get_nodes_in_group("zombie"):
		if zombie is Zombie:
			zombies.append(zombie)
	
	velocity = strategy.getTargetVector(self, zombies) * genes.vitesse
	move_and_slide()
	
	if started:
		genes.fitness += 1

## Quand un humain est touché par un zombie (ici je le supprime)
func die():
	if(!isDead):
		isDead = true
		genes.mort.emit()
		queue_free()
