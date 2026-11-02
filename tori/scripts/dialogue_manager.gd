extends CanvasLayer

#Dialogue Stuff
@onready var dialogueBox: Control = $DialogueBox
@onready var dialogueText: Label = $DialogueBox/DialogueText

#Dialogue Buttons
@onready var yes_button: Area2D = $ButtonContainer/YesButton
@onready var no_button: Area2D = $ButtonContainer/NoButton

#Dialogue Choices
var currentDialogueData: DialogueData

#Check if choices should appear
var showChoicesAfterDialogue: bool = false

#Timer for Typing Animation
@onready var timer: Timer = $Timer

#Array Organiztion
var dialogueLines: Array[String] = []
var currentLineIndex: int = 0
var isDialogueActive: bool = false

#Will be used to make dialogueBox disappear after convo is over
var branchDialogueFinished: bool = false
var isBranchDialogue: bool = false

func _ready() -> void:
	dialogueBox.visible = false
	yes_button.visible = false
	no_button.visible = false
	
	#Connect button signals
	yes_button.choice_selected.connect(_on_dialogue_button_selected)
	no_button.choice_selected.connect(_on_dialogue_button_selected)

func startDialogue(data: DialogueData):
	currentDialogueData = data
	branchDialogueFinished = false
	isBranchDialogue = false

	dialogueLines = data.openingDialogue
	currentLineIndex = 0
	isDialogueActive = true
	showChoicesAfterDialogue = true

	dialogueBox.visible = true
	yes_button.visible = false
	no_button.visible = false

	dialogueText.text = dialogueLines[currentLineIndex]
	dialogueText.visible_characters = 0
	timer.start()
	
	
func _input(event):
	if not isDialogueActive:
		return
	
	if event.is_action_pressed("mouse_click"):
		#Don't advance dialogue when buttons are visible
		if yes_button.visible or no_button.visible:
			return

		if dialogueText.visible_ratio < 1:
			dialogueText.visible_characters = -1
			timer.stop()

		#Check if this is the final sentence
		if currentLineIndex == dialogueLines.size() - 1:
			if showChoicesAfterDialogue == true:
				yes_button.visible = true
				no_button.visible = true
			else:
				advanceDialogue()
		
		else:
			advanceDialogue()

func advanceDialogue():
	if currentLineIndex < dialogueLines.size() - 1:
		currentLineIndex += 1

		dialogueText.text = dialogueLines[currentLineIndex]

		#Reset typing animation
		dialogueText.visible_characters = 0

		#Start typing again
		timer.start()

	else:
		isDialogueActive = false
		showChoicesAfterDialogue = false
		dialogueBox.visible = false
		yes_button.visible = false
		no_button.visible = false
		timer.stop()
		
		#Check if the YES or NO dialogue has finished
		if isBranchDialogue == true:
			branchDialogueFinished = true


func _on_timer_timeout() -> void:
	if dialogueText.visible_characters < dialogueText.get_total_character_count():
		dialogueText.visible_characters += 1
	
	else:
		timer.stop()
	
	#Only show choices after the final sentence has finished typing
		if currentLineIndex == dialogueLines.size() - 1:
			if showChoicesAfterDialogue == true:
				yes_button.visible = true
				no_button.visible = true

func _on_dialogue_button_selected(choice: String) -> void:
	#Testing
	print("Dialogue Manager received: ", choice)

	if choice == "YES":
		playBranchDialogue(currentDialogueData.yesDialogue)

	elif choice == "NO":
		playBranchDialogue(currentDialogueData.noDialogue)

func playBranchDialogue(lines: Array[String]):
	if lines.is_empty():
		print("There is no dialogue")
		return
	
	showChoicesAfterDialogue = false
	isBranchDialogue = true
	
	dialogueLines = lines
	currentLineIndex = 0

	yes_button.visible = false
	no_button.visible = false

	dialogueText.text = dialogueLines[currentLineIndex]
	dialogueText.visible_characters = 0

	isDialogueActive = true
	branchDialogueFinished = false
	timer.start()
