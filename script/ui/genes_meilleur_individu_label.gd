class_name GenesMeilleurIndividuLabel extends Label

const TEXT = "Genes meilleur individu :
	Vitesse : %f
	Taille: %f
	Champs de vision : %s"

func changeGenes(genes: Genes):
	self.text = TEXT % [genes.vitesse, genes.taille, genes.champsDeVision]
