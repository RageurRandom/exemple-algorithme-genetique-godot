class_name GenerationLabel extends Label

const TEXT = "Generation: %d\n
			Ancien fitness max : %d"
			
var generation: int = 1
var ancienFitnessMax: int = 0

func changeGeneration():
	generation += 1
	self.text = TEXT % [generation, ancienFitnessMax]

func changeFitnessMax(nb: int):
	ancienFitnessMax = nb
	self.text = TEXT % [generation, ancienFitnessMax]
