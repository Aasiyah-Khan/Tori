extends Resource #This is a reusable data resource instead of a scene node
class_name DialogueData #Lets other scripts recognize the name DialogueData

#This script will be used to store dialogue for different 
#NPCs so that the DialogueManager can use that dialogue without 
#having to hardcode every NPC's conversations into it.

#WE can edit these in the resource's inspector (the resource id kind of like a node but instead holds resuable data)
@export var openingDialogue: Array[String] #Opening Dialogue so when they first greet you
@export var yesDialogue: Array[String] #This is after you select yes (or green)
@export var noDialogue: Array[String] #This is after you select no (or red)

#THESE NAMES WILL BE CHANGED LATER and we might need to add another dialogue array for the advisor
#But I don't reccomend doing that since it would BE SO MUCH WORK but idm doing it if you guys want me too
#I instead think we can just use the opening dialogue but I'll figure out a way to fix this lol

#Fix is here lol (THIS SHOWS THE CHOICES)
@export var greenChoiceText: String
@export var redChoiceText: String 

#To make advisor appear or not
@export var useAdvisorPortrait: bool = false
@export var useNPCPortrait: bool = true

#Line where the Advisor appears
@export var advisorAppearsAtLine: int = 0

#Which NPC portrait should appear?
@export var NPCPortrait: int = 0
#0 is npc 1
#1 is npc 2
#2 is npc 3
