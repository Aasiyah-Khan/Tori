extends Node3D

#NPCs already inside ToriMain
#npc_list is the name of the array
@export var npc_list: Array[NPCController] #It contains NPCController datatype
#That basically means NPC's that have the npcScript with it since the NPCController class extends off it
#Technically making it a datatype and open to any script or node
#Meaning the info in npcScript is open to all nodes or scripts 
#NPCController is just a 3D Sprite (npc with the npcSprite)

#Player
@export var player: CharacterBody3D

#Current NPC
var current_npc: NPCController #The 3DAnimatedSprite with the npcScript (the datatype is NPCController class but holds different NPC info depending on which is the current NPC)
#Starts at the first NPC

#Next NPC to spawn 
#Integer to organize the NPC Order
var next_npc_index = 0 #Starts with the first NPC

#Timer Used to Spawn NPC's
@onready var spawn_timer: Timer = $"../SpawnTimer"

func _ready() -> void:
	#Hide all NPCs when the game starts
	for npc in npc_list:
		npc.hide()
		npc.can_move = false
		npc.is_active = false
	
#Called when the node enters the scene tree for the first time.
func activate_next_npc():
	#Check if there are NPCs remaining
	if next_npc_index >= npc_list.size():
		print("All NPCs finished!")
		return
	
	#Get the next NPC
	current_npc = npc_list[next_npc_index] #WHICH IS 0 AT FIRST
	
	#Connect the finished signal
	#ONLY CONNECTS WHEN SIGNAL IS RECIEVED
	#WHICH IS SENT TO THE FUNCTION ONCE THE DIALOGUE IS FINISHED IN DIALOGUE MANAGER WHICH SENDS
	#dialogue_finished signal to the npcScript
	#which then activates a function that sends a signal to this script
	#that signal holds the current NPC and sends itself to get deleted
	#in the _on_npc_finished function
	current_npc.finished.connect(_on_npc_finished)
	
	#Activate the NPC
	#SINCE THE DATATYPE IS A CLASS (which is in the script of the NPC)
	#We can access the info of the NPC script so we can use the activate_npc() function
	current_npc.activate_npc()
	
	#Move to the next NPC in the list
	next_npc_index += 1

func _on_npc_finished(npc: NPCController):
	#Delete previous NPC
	npc.queue_free() #deletes nodes or NPC in this context
	
	spawn_timer.start() #Start the timer to spawn the next NPC in line


func _on_spawn_timer_timeout() -> void:
	activate_next_npc() #when the timer is done activate the next npc
