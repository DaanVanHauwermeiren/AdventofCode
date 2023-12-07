#=
Created on 07/12/2023 09:04:17
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 7: Playing poker
=#

using StatsBase: countmap 

pint(string) = parse(Int, string)

const CARDVALUES = Dict(c=>v for (v, c) in enumerate(reverse("AKQJT987654321")))

struct Hand
    cards::NTuple{5,Char}
    bet::Int
end

""""
Five of a kind, where all five cards have the same label: AAAAA
Four of a kind, where four cards have the same label and one card has a different label: AA8AA
Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
High card, where all cards' labels are distinct: 23456
"""
function handvalue(cards)
    cards_count = countmap(cards)
    maximum(values(cards_count)) == 5 && return 7
    if length(cards_count) == 2
        maximum(values(cards_count)) == 4 && return 6
        maximum(values(cards_count)) == 3 && return 5
    elseif length(cards_count) == 3
        maximum(values(cards_count)) == 3 && return 4
        return 3
    elseif length(cards_count) == 4
        return 2
    else
        return 1
    end
end

handvalue(h::Hand) = handvalue(h.cards)

cardsvalues(c) = (CARDVALUES[c[1]], CARDVALUES[c[2]], CARDVALUES[c[3]], CARDVALUES[c[4]], CARDVALUES[c[5]])
cardsvalues(h::Hand) = cardsvalues(h.cards)


Base.isless(h1::Hand, h2::Hand) = (handvalue(h1), cardsvalues(h1)) < (handvalue(h2), cardsvalues(h2))

bet(h::Hand) = h.bet

data = rstrip("32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483")

data = data = read("data/input_2023_7.txt", String) |> rstrip

lines = split.(split(data, "\n"), Ref(" "))

hands = [Hand(Tuple(h), pint(b)) for (h,b) in lines]

sort!(hands)

solution1 = sum(prod,enumerate(bet.(hands)))

# WITH JOKERS

CARDVALUES['J'] = 0

function handvalue(cards)
    cards_count = countmap(cards)
    if 'J' in cards && maximum(values(cards_count)) < 5
        _, c = maximum(((n, c) for (c, n) in cards_count if c != 'J'))
        cards = replace(cards, 'J'=>c)
        cards_count = countmap(cards)
    end
    maximum(values(cards_count)) == 5 && return 7
    if length(cards_count) == 2
        maximum(values(cards_count)) == 4 && return 6
        maximum(values(cards_count)) == 3 && return 5
    elseif length(cards_count) == 3
        maximum(values(cards_count)) == 3 && return 4
        return 3
    elseif length(cards_count) == 4
        return 2
    else
        return 1
    end
end

sort!(hands)

solution2 = sum(prod,enumerate(bet.(hands)))