## Toute la partie nécessaire à l'algo génétique.
##
## Comprends les caractéristiques, mais aussi la fitness du gène.
class_name Genes

## Envoyé quand l'individu meurt.
## Permet à la population de recalculer la fitness max 
signal mort
var fitness: int

#region caracteristiques
var vitesse: float :
	set(val):
		vitesse = maxf(0, val)
const VITESSE_DEFAUT = 10

var taille: float :
	set(val):
		taille = maxf(0.1, val) # évite d'avoir une taille de 0
const TAILLE_DEFAUT = 1

var champsDeVision: float
const CHAMPS_VISION_DEFAUT = 150
#endregion

static func cloner(genes: Genes)->Genes:
	return Genes.new(genes.vitesse, genes.taille, genes.champsDeVision)


func _init(_vitesse: float = VITESSE_DEFAUT,
		_taille: float  = TAILLE_DEFAUT,
		_champsDeVision: float = CHAMPS_VISION_DEFAUT) -> void:
	self.vitesse = _vitesse
	self.taille = _taille
	self.champsDeVision = _champsDeVision
	self.fitness = 0


## Renvoie la moyenne des gènes parents (étape de "reproduction")
static func crossover(gene1: Genes, gene2: Genes)->Genes:
	var newVitesse = (gene1.vitesse + gene2.vitesse) / 2
	var newTaille = (gene1.taille + gene2.taille) / 2
	var newChampsDeVision = (gene1.champsDeVision + gene2.champsDeVision) / 2
	
	return Genes.new(newVitesse, newTaille, newChampsDeVision)
