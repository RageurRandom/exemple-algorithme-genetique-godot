## Cette classe est la seule à modifier du TP.
##
## Ca veut pas dire que les autres servent à rien,
## juste que toute la logique intéressante se pass ici.
class_name AlgoGenetique extends Node

#region Constantes modifiables

## Nombre d'humains dans la simulation par génération
const NB_POPULATION = 10

## Jamais fait un patch aussi foireux
const FITNESS_INITIALE = -50

# Probabilités de mutation
const PROBA_MUTATION_VITESSE = 0.5
const PROBA_MUTATION_CHAMPS_VISION = 0.5
const PROBA_MUTATION_TAILLE = 0.5

# Valeurs de mutation d'une caractéristique.
# Va être soit positif soit négatif.
const CHANGEMEN_VITESSE = 50
const CHANGEMENT_TAILLE = 0.25
const CHANGEMENT_CHAMPS_VISION = 100

#endregion

## Toutes les populations passées sont stockées ici
var anciennesPopulations: Array[Population]
var populationActuelle: Population

## Première itération de l'algo.
## Ne devrait être utilisé qu'une fois. [br]
## [b] Si vous voulez modifier la 1ère génération c'est ici.
func intialise()-> Array[Genes]:
	populationActuelle = Population.new(1)
	
	for i in range(NB_POPULATION):
		var nouvelIndividu = Genes.new()
		nouvelIndividu.fitness = FITNESS_INITIALE
		nouvelIndividu = mutation(nouvelIndividu)
		populationActuelle.addIndividu(nouvelIndividu)
	
	return populationActuelle.individus


## Mute des gènes de façon aléatoire. Chaque caractéristique a une chance de changer. [br]
## Voir les constantes plus haut
func mutation(genes: Genes)->Genes:
	if randf() < PROBA_MUTATION_VITESSE :
		genes.vitesse += _getValMutation(CHANGEMEN_VITESSE)
	
	if randf() < PROBA_MUTATION_CHAMPS_VISION :
		genes.champsDeVision += _getValMutation(CHANGEMENT_CHAMPS_VISION)
	
	if randf() < PROBA_MUTATION_TAILLE :
		genes.taille += _getValMutation(CHANGEMENT_TAILLE)
		
	return genes


## Renvoie soit le paramètre, soit son opposé (une chance sur 2).
func _getValMutation(changement:float)->float:
	if randi() % 2 == 0 :
		return -changement
	return changement

## Renvoie la population avec le meilleur fitness dans [member anciennesPopulations]
func getMeilleureAnciennePop()->Population:
	assert(anciennesPopulations.size() > 0)
	
	var meilleurePop: Population = anciennesPopulations[0]
	
	for i in range(1, anciennesPopulations.size()):
		if anciennesPopulations[i].fitnessMax > meilleurePop.fitnessMax:
			meilleurePop = anciennesPopulations[i]
	
	return meilleurePop


## Créé une nouvelle génération à partir de l'actuelle.
func nouvelleGeneration()-> Population:
	if anciennesPopulations.size() > 0 :
		var meilleureAnciennePop: Population = getMeilleureAnciennePop()
		
		# Si la population a fait moins bien que les ancienne, elle ne sert à rien
		# (Les mauvaises mutations arrivent)
		if populationActuelle.fitnessMax < meilleureAnciennePop.fitnessMax:
			return Population.cloner(meilleureAnciennePop)
	
	var meilleurIndividu: Genes = populationActuelle.meilleurGene
	var nouvellePop: Population = Population.new(populationActuelle.nbGeneration + 1)
	
	# Le meilleur individu reste tel quel dans la nouvelle population
	# Je récréé un gene pour éviter de devoir réinitialiser le fitness
	nouvellePop.addIndividu(Genes.cloner(meilleurIndividu))
	
	for individu in populationActuelle.individus:
		if individu != meilleurIndividu:
			# chaque individu se reproduit avec le meilleur puis l'enfant mute
			var nouvelIndividu: Genes = Genes.crossover(meilleurIndividu, individu)
			nouvelIndividu = mutation(nouvelIndividu)
			nouvellePop.addIndividu(nouvelIndividu)
	
	return nouvellePop
	
	
## Appelée quand la génération a été tuée.
## Sauvegarde la génération actuelle puis en recréé une et la renvoie.
func finGeneration()->Population:
	var nouvellePop = nouvelleGeneration()
	anciennesPopulations.append(populationActuelle)
	populationActuelle = nouvellePop
	return populationActuelle
