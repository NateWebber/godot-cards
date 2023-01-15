extends Node2D

enum Rank {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE}

enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

func _ready():
	randomize()
	var deck = Deck.new()
	var card = deck.deal()
	card.print_name()
