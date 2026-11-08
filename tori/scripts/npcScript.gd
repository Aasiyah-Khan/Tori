class_name NPCController #Other scripts can refer to this script using that name
extends Sprite3D

#this a signal we created named finished
#it sends npc info from the NPC Controller class 
#(basically info from an npc [NPC Controller will contain multiple NPC's] ) 
#which is in this script but we call the class, which is a part of this 
#script that contains  the info!
#THE INFO IS IF THE NPC's DIALOGUE IS FINISHED (hence the name finished)
signal finished(npc: NPCController)

#These will be declared in the inpspector
@export var player: CharacterBody3D #Put in player in the inspector

#Speed of NPC
const SPEED = 1

#Bools
var can_move = false
var is_active = false

#Reference for Dialogue Manager
@onready var dialogue_manager: CanvasLayer = $"../../DialogueManager"

#Reference for Dialogue Data
@export var dialogue_data: DialogueData #Class Name that is in dialogue_data script
#The data type is just a resource we created that contains all of the dialogue_data DATA/INFO! IT INCLUDES
#THE OPENING DIALOGUE, GREEN OR RED DIALOGUE, AND MORE
#each resource is just a copy of the class Dialoge Data but we put our info in the inspector
#resources hold information like a box

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() #We can do this bc it extends each NPC's sprite 3d
	
	#Connect to DialogueManager
	#the signal of the dialogue_finished [WHICH IS IN DIALOGUE_MANAGER] is connected to the function (recieves if convo is over)
	#_on_dialogue_finished
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)
	#Basically if this signal is received then the function starts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move == true: #basic stuff
		position.z += SPEED * delta #we can just use position.z bc of the extend Sprite 3d

#Called by NPCManager when it's this NPC's turn
func activate_npc(): #FUNCTION TO ACTIVATE NPC
	is_active = true
	show()
	can_move = true

func _on_area_3d_body_entered(body): #assign body to player (player is assigned in the inspector as the PlayerController)
	if is_active == true and body == player: #if THIS NPC IS CURRENTLY ACTIVE AND the body detected is the player run this code:
		can_move = false #NO MORE MOVING
		
		#Specific resource for this npc with its specific dialogue will be used for this convo
		#AND Start dialogue with this resource!
		dialogue_manager.startDialogue(dialogue_data) #The arrays are filled up with the resource [COPIES CLASS BLUEPRINT] we select on the NPC

#Called when the conversation finishes
func _on_dialogue_finished(): #REMEMBER FUNCTION RUNS AFTER SIGNAL RECEIVED
	if is_active == true: #ONLY IF NPC IS ACTIVE SO THE OTHER ONES AREN'T INCLUDED
		is_active = false #MAKE IT INACTIVE
		finished.emit(self) #NOW USE THE NEW NPC SIGNAL WE CREATED
		#SEND THE ITSELF AS THE CURRENT NPC SO THE NPC MANAGER CAN DELETE IT AND THEN ADVANCE TO THE NEXT
