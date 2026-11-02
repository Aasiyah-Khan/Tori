extends Resource #Makes this a reusable data resource instead of a scene node
class_name DialogueData #Lets your other scripts recognize the name DialogueData

@export var openingDialogue: Array[String]
@export var yesDialogue: Array[String]
@export var noDialogue: Array[String]
