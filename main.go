package main

import (
	"context"
	"database/sql"
	"math/rand"
	"mc/protos"
	"strconv"

	"github.com/heroiclabs/nakama-common/runtime"
	"google.golang.org/protobuf/encoding/protojson"
	// "google.golang.org/protobuf/proto"
)

var (
	errUnableToCreateMatch = runtime.NewError("unable to create match", 13)
)

func InitModule(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, initializer runtime.Initializer) error {
	logger.Info("Hello World!")

	if err := initializer.RegisterMatchmakerMatched(func(ctx context.Context, logger runtime.Logger, db *sql.DB, nk runtime.NakamaModule, entries []runtime.MatchmakerEntry) (string, error) {
		matchId, err := nk.MatchCreate(ctx, "lobby", map[string]interface{}{"invited": entries})
		if err != nil {
			return "", errUnableToCreateMatch
		}

		return matchId, nil
	}); err != nil {
		logger.Error("unable to register matchmaker matched hook: %v", err)
		return err
	}

	if err := initializer.RegisterMatch("lobby", func(ctx context.Context, logger runtime.Logger, db *sql.DB, nk runtime.NakamaModule) (runtime.Match, error) {
		return &MatchHandler{
			marshal: &protojson.MarshalOptions{
				UseEnumNumbers: true,
			},
			unmarshaler: &protojson.UnmarshalOptions{
				DiscardUnknown: false,
			},
		}, nil
	}); err != nil {
		logger.Error("unable to register: %v", err)
		return err
	}
	return nil
}

func GetRandomMana() *protos.Mana {
	return &protos.Mana{
		Red:   rand.Int63n(5),
		Blue:  rand.Int63n(5),
		Green: rand.Int63n(5),
		White: rand.Int63n(5),
		Black: rand.Int63n(5),
	}
}

func GetRandomCard(id string) *protos.Card {
	var (
		name = id
		desc = id + "dsdsdsds"
		cost []*protos.Mana
	)
	l := rand.Intn(5)
	for i := 0; i < l; i++ {
		cost[i] = GetRandomMana()
	}
	switch rand.Intn(2) { //6
	case 0:
		{
			build := protos.Build{
				Add: GetRandomMana(),
				Sub: GetRandomMana(),
				One: GetRandomMana(),
			}
			return &protos.Card{
				Id:       id,
				Name:     name,
				Desc:     desc,
				CardType: &protos.Card_Build{Build: &build},
			}
		}
	default:
		{
			return &protos.Card{
				Id:   id,
				Name: name,
				Desc: desc,
				CardType: &protos.Card_Unit{Unit: &protos.Unit{
					Healty: rand.Int63n(9),
					Cost:   cost,
				},
				},
			}
		}
	}
}
func GetRandomPlayer(Id string, card_count int) protos.Player {
	cards := []*protos.Card{}
	for j := 0; j < card_count; j++ {
		cards = append(cards, GetRandomCard(Id+strconv.Itoa(j)))

	}
	hand := []*protos.Card{}
	for j := 0; j < 5; j++ {
		hand = append(hand, GetRandomCard(Id+strconv.Itoa(j+card_count)))

	}
	return protos.Player{
		Id:   Id,
		Name: Id,
		Deck: cards,
		Hand: hand,
	}
}

const (
	HAND_SIZE  int = 7
	DECK_SIZE  int = 12
	MAX_CLIENT int = 2
)

func player_to_enemy(p *protos.Player) *protos.Enemy {
	return &protos.Enemy{
		Id:      p.Id,
		Name:    p.Name,
		Mana:    p.Mana,
		Tabel:   p.Tabel,
		Build:   p.Build,
		Deads:   p.Deads,
		HandLen: int64(len(p.Hand)),
	}
}

type MatchState struct {
	emptyTicks  int
	currentTurn int
	queueTurn   []string
	players     map[string]protos.Player
	presences   map[string]runtime.Presence
}

func (m *MatchState) new() MatchState {
	return *m
}

type MatchHandler struct {
	marshal     *protojson.MarshalOptions
	unmarshaler *protojson.UnmarshalOptions
}

func (m *MatchHandler) MatchInit(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, params map[string]interface{}) (interface{}, int, string) {

	state := &MatchState{}
	tickRate := 1
	label := ""

	state.queueTurn[len(state.players)] = "Oleg"
	state.presences["Oleg"] = nil
	state.players["Oleg"] = GetRandomPlayer("Oleg", 15)
	return state, tickRate, label
}

func (m *MatchHandler) MatchJoinAttempt(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, dispatcher runtime.MatchDispatcher, tick int64, match_state interface{}, presence runtime.Presence, metadata map[string]string) (interface{}, bool, string) {
	return match_state, true, ""
}

func (m *MatchHandler) MatchJoin(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, dispatcher runtime.MatchDispatcher, tick int64, match_state interface{}, presences []runtime.Presence) interface{} {

	state, ok := match_state.(*MatchState)
	if !ok {
		logger.Error("state not a valid lobby state object")
		return nil
	}

	for i := 0; i < len(presences); i++ {
		player := GetRandomPlayer("Ivan", 15)

		data, err := m.marshal.Marshal(&player)
		if err != nil {
			logger.Error("Failed to encode address book:", err)
		}
		dispatcher.BroadcastMessage(int64(protos.OpCode_OPCODE_START), data, nil, nil, true)
		presence := presences[i]
		state.queueTurn[len(state.players)] = presence.GetUserId()
		state.presences[presence.GetUserId()] = presence
		state.players[presence.GetUserId()] = player

		logger.Debug("Player joinet:", player)
		// data_opp, err := m.marshal.Marshal(player_to_enemy(player))
		// if err != nil {
		// 	logger.Error("Failed to encode address book:", err)
		// }
		// dispatcher.BroadcastMessage(protos.OpCode_OPCODE_START, data_opp, nil, nil, true)
	}

	state.currentTurn = rand.Intn(len(state.players) - 1)

	return state
}

func (m *MatchHandler) MatchLoop(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, dispatcher runtime.MatchDispatcher, tick int64, match_state interface{}, messages []runtime.MatchData) interface{} {
	state, ok := match_state.(*MatchState)
	if !ok {
		logger.Error("state not a valid lobby state object")
		return nil
	}
	if len(state.players) == 0 {
		state.emptyTicks++
	}
	if state.emptyTicks > 100 {
		return nil
	}
	for _, msg := range messages {
		logger.Debug("Get Msg:", msg)
		switch protos.OpCode(msg.GetOpCode()) {
		case protos.OpCode_OPCODE_ADD_CARD:
			current_user := msg.GetUserId()
			deck := state.players[current_user].Deck
			lenght := len(deck)
			if lenght == 0 {
				break
			}
			sender := []runtime.Presence{msg}
			for user_id, player := range state.players {
				if user_id == current_user {
					card := player.Deck[lenght-1]
					player.Hand = append(player.Hand, card)
					player.Deck[lenght-1] = nil

					data, err := m.marshal.Marshal(card)
					if err != nil {
						logger.Error("Failed to encode address book:", err)
					}
					dispatcher.BroadcastMessage(int64(protos.OpCode_OPCODE_ADD_CARD), data, sender, sender[0], true)
				} else {
					dispatcher.BroadcastMessage(int64(protos.OpCode_OPCODE_ADD_CARD), nil, []runtime.Presence{state.presences[user_id]}, sender[0], true)
				}

			}
		case protos.OpCode_OPCODE_CAST_CARD:
			current_user := msg.GetUserId()
			hand := state.players[current_user].Hand
			lenght := len(hand)
			if lenght == 0 {
				break
			}
			// sender := []runtime.Presence{msg}
			// for user_id, player := range state.players {
			// 	if user_id == current_user {
			// 		card := player.Hand[lenght-1]
			// 		// player.Hand = append(player.Hand, card)
			// 		// player.Deck[lenght-1] = nil
			//
			// 		data, err := m.marshal.Marshal(&card)
			// 		if err != nil {
			// 			logger.Error("Failed to encode address book:", err)
			// 		}
			// 		dispatcher.BroadcastMessage(int64(protos.OpCode_OPCODE_ADD_CARD), data, sender, sender[0], true)
			// 	} else {
			// 		dispatcher.BroadcastMessage(int64(protos.OpCode_OPCODE_ADD_CARD), nil, []runtime.Presence{state.presences[user_id]}, sender[0], true)
			// 	}
			//
			// }
		case protos.OpCode_OPCODE_ATTACK:
		case protos.OpCode_OPCODE_END_TURN:
			// state.currentTurn += 1
			// if state.currentTurn > MAX_CLIENT {
			// 	state.currentTurn = 0
			// }
		case protos.OpCode_OPCODE_ADD_BUILD:
		default:
		}

	}

	return state
}

func (m *MatchHandler) MatchLeave(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, dispatcher runtime.MatchDispatcher, tick int64, match_state interface{}, presences []runtime.Presence) interface{} {
	state, ok := match_state.(*MatchState)
	if !ok {
		logger.Error("state not a valid lobby state object")
		return nil
	}

	for i := 0; i < len(presences); i++ {
		delete(state.players, presences[i].GetUserId())
	}

	return state
}

func (m *MatchHandler) MatchTerminate(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, dispatcher runtime.MatchDispatcher, tick int64, match_state interface{}, graceSeconds int) interface{} {
	return match_state
}

func (m *MatchHandler) MatchSignal(ctx context.Context, logger runtime.Logger, db *sql.DB,
	nk runtime.NakamaModule, dispatcher runtime.MatchDispatcher, tick int64, match_state interface{}, data string) (interface{}, string) {
	return match_state, ""
}
