## Représente un ensemble d'individus (représentés ici par des [Genes])
##
## Contient les individus, ainsi que le meilleur
## et la meilleure fitness de la population
class_name Population

var individus: Array[Genes]
## La fitness (ici le temps de survie) du meilleur individu de la génération
var fitnessMax: int
var meilleurGene: Genes
## 1 si c'est la 1ère génération, 2 si c'est la 2ème...
var nbGeneration: int

func _init():
	individus = []
	fitnessMax = 0

func addIndividu(genes: Genes):
	individus.append(genes)
	
	# Quand l'individu porteur du gène meurt, on recalcule la fitness max
	genes.mort.connect(
		func ():
			if genes.fitness > fitnessMax:
				fitnessMax = genes.fitness
				meilleurGene = genes)
