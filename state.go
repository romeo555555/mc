package main

import (
	// "context"
	// "database/sql"
	"github.com/heroiclabs/nakama-common/runtime"
	"math/rand"
)

const (
	HAND_SIZE int = 7
	DECK_SIZE int = 12
)

type Effects struct{}

type Card interface {
	// CardId() string
	// CardName() string
	// CardDesc() string
	CardType() string
}

type Unit struct {
	Id   string
	Name string
	Desc string
	Cost []Mana
	// Effects  []Effects
	Healty int
	Attack int
}

func (c Unit) CardType() string {
	return "Unit"
}

type Build struct {
	Id   string
	Name string
	Desc string
	Add  Mana
	Sub  Mana
	One  Mana
}

func (c Build) CardType() string {
	return "Build"
}

// type Item struct {
// }
//
// func (c *Item) CardId() string {
// 	return c.CardData.Id
// }
//
// type Spell struct {
// }
//
// func (c *Spell) CardId() string {
// 	return c.CardData.Id
// }
//
// type Zone struct {
// }
//
// func (c *Zone) CardId() string {
// 	return c.CardData.Id
// }

type Mana struct {
	Red   int
	Blue  int
	Green int
	White int
	Black int
}

type Player struct {
	Id   string
	Name string
	// Zone Zone
	Mana  Mana
	Tabel []Unit
	Build []Build
	Dead  []Card

	deck []Card
	hand []Card
}

type MatchState struct {
	current_turn int
	presences    map[string]runtime.Presence
	emptyTicks   int
	Players      []Player
}

func GetRandomMana() Mana {
	return Mana{
		rand.Intn(5),
		rand.Intn(5),
		rand.Intn(5),
		rand.Intn(5),
		rand.Intn(5),
	}
}

func GetRandomCard(id string) Card {
	var (
		name = id
		desc = id + "dsdsdsds"
		cost []Mana
	)
	l := rand.Intn(5)
	for i := 0; i < l; i++ {
		cost[i] = GetRandomMana()
	}
	switch rand.Intn(2) { //6
	case 0:
		{
			return Build{
				id,
				name,
				desc,
				GetRandomMana(),
				GetRandomMana(),
				GetRandomMana(),
			}
		}
	default:
		{
			return Unit{
				id,
				name,
				desc,
				cost,
				rand.Intn(9),
				rand.Intn(9),
			}
		}
	}
}
