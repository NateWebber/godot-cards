extends Node2D

#Other Scenes
const UICard = preload("res://src/cards-core/UICard.tscn")

#Card Rank/Suit enums
enum Rank {TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13, ACE = 14}
enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

#UI Game elements
var full_ui_deck = []
var player_one_ui_deck = []
var player_two_ui_deck = []
var player_one_current_ui_card = null
var player_two_current_ui_card = null
onready var DealButton = $UI/MasterContainer/ButtonContainer/ButtonBG/DealButton

#Anchors for "animation" of game elements
onready var DeckSpawnPos = $DeckSpawnPoint
onready var DeckDealAnchor1 = $DeckDealAnchor1
onready var DeckDealAnchor2 = $DeckDealAnchor2
onready var P1DeckAnchor = $P1DeckAnchor
onready var P2DeckAnchor = $P2DeckAnchor
onready var P1PlayAnchor = $P1PlayAnchor
onready var P2PlayAnchor = $P2PlayAnchor

#Constants
export var CARD_ANIM_MOVE_SPEED = 20

#Signals
signal deck_spawn_anim_complete
signal deck_split_anim_complete
signal start_animations_complete
signal deal_anim_complete

#Game logic variables
var player_one_game_deck: Deck
var player_two_game_deck: Deck
var player_one_current_card: Card
var player_two_current_card: Card

func _ready():
	DealButton.disabled = true #everything explodes if the player can click the deal button when they shouldn't
	randomize()
	initialize_game_decks()
	do_start_animations()
	yield(self, "start_animations_complete")
	DealButton.disabled = false

func _on_DealButton_pressed():
	DealButton.disabled = true
	play_round()
	do_deal_anim()
	yield(self, "deal_anim_complete")
	DealButton.disabled = false

#set up the decks for the game logic (as opposed to UI)
func initialize_game_decks():
	var p1_cards = []
	var p2_cards = []
	var master_deck = Deck.new()
	for i in range (52):
		if i % 2 == 0:
			p1_cards.append(master_deck.deal())
		else:
			p2_cards.append(master_deck.deal())
	player_one_game_deck = Deck.new(p1_cards)
	player_two_game_deck = Deck.new(p2_cards)

#no game logic yet, just testing anims
func play_round():
	player_one_current_card = player_one_game_deck.deal()
	player_two_current_card = player_two_game_deck.deal()
	print("Player one drew: " + player_one_current_card.get_name_string())
	print("Player two drew: " + player_two_current_card.get_name_string())

#"start animations" includes spawning the UI deck, and then moving and splitting it into the two player's decks
func do_start_animations():
	draw_ui_deck()
	yield(self, "deck_spawn_anim_complete")
	do_deck_split_anim()
	yield(self, "deck_split_anim_complete")
	emit_signal("start_animations_complete")

#set up ui decks/cards (as opposed to logical elements)
func draw_ui_deck():
	for i in range(52):
		var newUICard = UICard.instance()
		newUICard.set_position(Vector2(DeckSpawnPos.position.x + (i * 0.5), DeckSpawnPos.position.y))
		add_child(newUICard)
		full_ui_deck.append(newUICard)
	#first animation stage, fly up from bottom
	while full_ui_deck[51].position.y > DeckDealAnchor1.position.y:
		#move all cards before yield so that animation is simultaneous
		for i in range(52):
			full_ui_deck[i].position.y -= CARD_ANIM_MOVE_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	#second animation stage, fly over to left of screen
	while full_ui_deck[51].position.x > DeckDealAnchor2.position.x:
		#move all cards before yield so that animation is simultaneous
		for i in range(52):
			full_ui_deck[i].position.x -= CARD_ANIM_MOVE_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	#signal this animation is done
	emit_signal("deck_spawn_anim_complete")

#second stage of initial animations
#looks kind of strange currently since the full deck clips weirdly with the two new ones as it splits
func do_deck_split_anim():
	for i in range(51, -1, -1):
		var current_ui_card = full_ui_deck[i]
		#redo horizontal adjustment (may look weird/need further attention)
		current_ui_card.position.x = P1DeckAnchor.position.x + 26 - (0.5 * i)
		current_ui_card.z_index = (51 - i) #layer cards correctly
		if (i % 2 == 0):
			player_one_ui_deck.append(current_ui_card)
			while (current_ui_card.position.y < P1DeckAnchor.position.y):
				current_ui_card.position.y += CARD_ANIM_MOVE_SPEED
				yield(get_tree().create_timer(0.01), "timeout")
		else:
			player_two_ui_deck.append(current_ui_card)
			while (current_ui_card.position.y > P2DeckAnchor.position.y):
				current_ui_card.position.y -= CARD_ANIM_MOVE_SPEED
				yield(get_tree().create_timer(0.01), "timeout")
	emit_signal("deck_split_anim_complete")

#update/animate UI cards to reflect game state
func do_deal_anim():
	var new_z_index = 0
	if player_one_current_ui_card != null:
		new_z_index = player_one_current_ui_card.z_index + 1
	player_one_current_ui_card = player_one_ui_deck.pop_back()
	player_two_current_ui_card = player_two_ui_deck.pop_back()
	#layer cards corrrectly
	player_one_current_ui_card.z_index = new_z_index
	player_two_current_ui_card.z_index = new_z_index
	#move cards to anchors
	while player_two_current_ui_card.position.x < P2PlayAnchor.position.x:
		player_one_current_ui_card.position.x += CARD_ANIM_MOVE_SPEED
		player_two_current_ui_card.position.x += CARD_ANIM_MOVE_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	#fix "overshooting" on horizontal movement
	player_one_current_ui_card.position.x = P1PlayAnchor.position.x
	player_two_current_ui_card.position.x = P2PlayAnchor.position.x
	#flip cards (and update sprites)
	player_one_current_ui_card.do_flip_anim(player_one_current_card)
	#yield(p1_ui_card, "flip_finished") #maybe do some ordered reveal instead?
	player_two_current_ui_card.do_flip_anim(player_two_current_card)
	emit_signal("deal_anim_complete")
