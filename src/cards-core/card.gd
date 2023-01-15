extends Node
class_name Card

enum Rank {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE}

enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var suit

var rank

func _init(new_rank, new_suit):
	rank = new_rank
	suit = new_suit
	#print("new card made: [" + rank + ", " + suit + "]")

func print_name():
	print(Rank.keys()[rank].capitalize() + " of " + Suit.keys()[suit].capitalize())
