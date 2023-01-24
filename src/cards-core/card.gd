extends Node
class_name Card

enum Rank {TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13, ACE = 14}
enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var suit

var rank

func _init(new_rank, new_suit):
	rank = new_rank
	suit = new_suit
	#print("new card made: [" + rank + ", " + suit + "]")

func get_name_string() -> String:
	return (Rank.keys()[rank - 2].capitalize() + " of " + Suit.keys()[suit].capitalize())
