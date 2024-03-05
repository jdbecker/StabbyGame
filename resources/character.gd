class_name Character extends Resource

@export var rank: Rank
@export var clan: Clan
@export var clue_color: Clan
var ability_description: String : get = _get_ability_description
@export var wound_pool: Array[Wound] = [Wound.RANK]
@export var wounds: Array[Wound] = []

enum Rank {ELDER, ASSASSIN, HARLEQUIN, ALCHEMIST, MENTALIST, GUARDIAN, BERSERKER, MAGE, COURTESAN, INQUISITOR}
enum Clan {UNKNOWN, BLUE, RED, PURPLE}
enum Wound {UNKNOWN, BLUE, RED, RANK}


func _get_ability_description() -> String:
	match rank:
		Rank.ELDER: return "You may play a [color=dark_blue]Quill[/color] for your clan. (While a clan has a [color=dark_blue]Quill[/color], the player with the highest rank - rather than the lowest - is their Leader.)"
		Rank.ASSASSIN: return "You may force any player to suffer 2 [color=dark_red]Wounds[/color]. If you do, give that player the dagger."
		Rank.HARLEQUIN: return "You may view any two players character cards. (Also, your clue color matches the enemy clan's color.)"
		Rank.ALCHEMIST: return "(Only used if you intervened) You may force the player for whom you intervened to suffer or heal 1 [color=dark_red]Wound[/color]."
		Rank.MENTALIST: return "You may force another player to suffer their rank token as a [color=dark_red]Wound[/color]. If you do, give that player the dagger."
		Rank.GUARDIAN: return "You may give a [color=dark_blue]Shield[/color] to another player and take a [color=dark_blue]Sword[/color] for yourself. (Players with a [color=dark_blue]Shield[/color] cannot suffer wounds until the player with a matching [color=dark_blue]Sword[/color] has 3 [color=dark_red]Wounds[/color].)"
		Rank.BERSERKER: return "You may force the player who attacked you to suffer 1 [color=dark_red]Wound[/color]."
		Rank.MAGE: return "You may give a [color=dark_blue]Staff[/color] to any other player and take a [color=dark_blue]Staff[/color] for yourself. (Players with a [color=dark_blue]Staff[/color] can only take \"?\" wounds or their rank token.)"
		Rank.COURTESAN: return "You may give a [color=dark_blue]Fan[/color] to a player. (Players cannot intervene for players with a [color=dark_blue]Fan[/color].)"
		Rank.INQUISITOR: return "You may attempt to predict the leader of the clan who will win. If you are right, you win instead! (Also, you have no allies, but you can take any color wounds.)"
	assert(false, "Ability description not available for Rank: %s" % rank)
	return ""


func suffer_wound(wound: Wound) -> void:
	assert(wound_pool.has(wound), "%s %s has no %s wounds in its wound pool!" % [Clan.keys()[clan], Rank.keys()[rank], Wound.keys()[wound]])
	wound_pool.erase(wound)
	wounds.append(wound)
