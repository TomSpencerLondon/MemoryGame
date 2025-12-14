# Memory Game - Pharo Kata with Bloc

A Memory card matching game built with **Bloc** (Pharo's graphics library). This kata teaches Model-View architecture with Announcements, Bloc elements, layouts, and event handling.

## Quick Start

```smalltalk
| space game gameElement |
game := MGGame new initializeForSymbols: #(1 2 3 4 5 6 7 8).
gameElement := MGGameElement new.
gameElement memoryGame: game.
space := BlSpace new.
space root addChild: gameElement.
space extent: 500@500.
space show.
```

## What We Built

A card matching game where:
- 4x4 grid of 16 cards (8 pairs)
- Click cards to flip them and reveal numbers
- Match pairs to make them disappear
- Non-matching pairs flip back automatically
- Uses Model-View architecture with Announcements for loose coupling

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         VIEW LAYER                               │
│  ┌─────────────────┐         ┌─────────────────┐                │
│  │  MGGameElement  │ ───────>│  MGCardElement  │ (x16)          │
│  │  (BlGridLayout) │         │  (click handler)│                │
│  └─────────────────┘         └────────┬────────┘                │
│                                       │ subscribes               │
└───────────────────────────────────────┼─────────────────────────┘
                                        │
                              ┌─────────▼─────────┐
                              │   Announcements   │
                              │ (MGCardFlipped,   │
                              │  MGCardDisappear) │
                              └─────────┬─────────┘
                                        │ announces
┌───────────────────────────────────────┼─────────────────────────┐
│                         MODEL LAYER   │                          │
│  ┌─────────────────┐         ┌────────┴────────┐                │
│  │     MGGame      │ ───────>│     MGCard      │ (x16)          │
│  │ (game logic)    │         │ (flip, disappear)│               │
│  └─────────────────┘         └─────────────────┘                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Class Diagram

```
┌────────────────────────┐     ┌────────────────────────┐
│        MGGame          │     │        MGCard          │
├────────────────────────┤     ├────────────────────────┤
│ - availableCards       │────>│ - symbol               │
│ - chosenCards          │     │ - flipped              │
├────────────────────────┤     │ - announcer            │
│ + initializeForSymbols:│     ├────────────────────────┤
│ + chooseCard:          │     │ + flip                 │
│ + shouldCompleteStep   │     │ + disappear            │
│ + completeStep         │     │ + isFlipped            │
│ + shouldResetStep      │     │ + notifyFlipped        │
│ + resetStep            │     │ + notifyDisappear      │
│ + gridSize             │     └───────────┬────────────┘
│ + matchesCount         │                 │ announces
└────────────────────────┘                 ▼
                              ┌────────────────────────┐
                              │     Announcement       │
                              ├────────────────────────┤
                              │MGCardFlippedAnnouncement│
                              │MGCardDisappearAnnouncement│
                              └────────────────────────┘

┌────────────────────────┐     ┌────────────────────────┐
│    MGGameElement       │     │    MGCardElement       │
│    < BlElement         │     │    < BlElement         │
├────────────────────────┤     ├────────────────────────┤
│ - memoryGame           │────>│ - card                 │
├────────────────────────┤     │ - memoryGame           │
│ + memoryGame:          │     │ - backElement          │
│ + initialize           │     │ - frontElement         │
│   (BlGridLayout)       │     ├────────────────────────┤
└────────────────────────┘     │ + card:                │
                               │ + click                │
                               │ + showCardFace         │
                               │ + showFrontFace        │
                               │ + showBackFace         │
                               │ + onDisappear          │
                               └────────────────────────┘
```

---

## Sequence Diagrams

### 1. Card Click → Flip (Single Card)

```
┌──────┐     ┌───────────────┐     ┌────────┐     ┌────────┐
│ User │     │ MGCardElement │     │ MGGame │     │ MGCard │
└──┬───┘     └───────┬───────┘     └────┬───┘     └────┬───┘
   │                 │                   │              │
   │ click           │                   │              │
   │────────────────>│                   │              │
   │                 │                   │              │
   │                 │ chooseCard: card  │              │
   │                 │──────────────────>│              │
   │                 │                   │              │
   │                 │                   │ flip         │
   │                 │                   │─────────────>│
   │                 │                   │              │
   │                 │                   │              │ flipped := flipped not
   │                 │                   │              │
   │                 │                   │              │ announce:
   │                 │                   │              │ MGCardFlippedAnnouncement
   │                 │                   │<─ ─ ─ ─ ─ ─ ─│
   │                 │                   │              │
   │                 │ showCardFace      │              │
   │                 │<─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │
   │                 │                   │              │
   │                 │ removeChildren    │              │
   │                 │ addChild: front   │              │
   │                 │                   │              │
   │ see number      │                   │              │
   │<────────────────│                   │              │
```

### 2. Two Matching Cards → Disappear

```
┌──────┐     ┌───────────────┐     ┌────────┐     ┌─────────┐  ┌─────────┐
│ User │     │ MGCardElement │     │ MGGame │     │ Card #1 │  │ Card #2 │
└──┬───┘     └───────┬───────┘     └────┬───┘     └────┬────┘  └────┬────┘
   │                 │                   │              │            │
   │ click card 1    │                   │              │            │
   │────────────────>│                   │              │            │
   │                 │ chooseCard: c1    │              │            │
   │                 │──────────────────>│              │            │
   │                 │                   │ flip         │            │
   │                 │                   │─────────────>│            │
   │                 │ showCardFace      │              │            │
   │                 │<─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │            │
   │                 │                   │              │            │
   │ click card 2    │                   │              │            │
   │────────────────>│                   │              │            │
   │                 │ chooseCard: c2    │              │            │
   │                 │──────────────────>│              │            │
   │                 │                   │ flip         │            │
   │                 │                   │─────────────────────────>│
   │                 │ showCardFace      │              │            │
   │                 │<─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │
   │                 │                   │              │            │
   │                 │                   │ shouldCompleteStep = true │
   │                 │                   │              │            │
   │                 │                   │ completeStep │            │
   │                 │                   │─────────────>│ disappear  │
   │                 │                   │─────────────────────────>│ disappear
   │                 │                   │              │            │
   │                 │ onDisappear       │              │            │
   │                 │<─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │            │
   │                 │                   │              │            │
   │                 │ visibility: hidden│              │            │
   │                 │                   │              │            │
   │ cards vanish    │                   │              │            │
   │<────────────────│                   │              │            │
```

### 3. Two Non-Matching Cards → Reset

```
┌──────┐     ┌───────────────┐     ┌────────┐     ┌─────────┐  ┌─────────┐
│ User │     │ MGCardElement │     │ MGGame │     │ Card #1 │  │ Card #2 │
└──┬───┘     └───────┬───────┘     └────┬───┘     └────┬────┘  └────┬────┘
   │                 │                   │              │            │
   │ click card 1 (symbol: 3)           │              │            │
   │────────────────>│                   │              │            │
   │                 │ chooseCard: c1    │              │            │
   │                 │──────────────────>│              │            │
   │                 │                   │ flip         │            │
   │                 │                   │─────────────>│            │
   │                 │                   │              │            │
   │ click card 2 (symbol: 7)           │              │            │
   │────────────────>│                   │              │            │
   │                 │ chooseCard: c2    │              │            │
   │                 │──────────────────>│              │            │
   │                 │                   │ flip         │            │
   │                 │                   │─────────────────────────>│
   │                 │                   │              │            │
   │                 │                   │ shouldResetStep = true   │
   │                 │                   │              │            │
   │                 │                   │ resetStep    │            │
   │                 │                   │─────────────>│ flip (back)│
   │                 │                   │─────────────────────────>│ flip (back)
   │                 │                   │              │            │
   │                 │ showCardFace      │              │            │
   │                 │<─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │            │
   │                 │                   │              │            │
   │                 │ showBackFace      │              │            │
   │                 │                   │              │            │
   │ cards flip back │                   │              │            │
   │<────────────────│                   │              │            │
```

---

## Key Code Snippets

### The Announcer Pattern (Model-View Decoupling)

**1. Model announces changes:**
```smalltalk
MGCard >> flip
    flipped := flipped not.
    self notifyFlipped

MGCard >> notifyFlipped
    self announcer announce: MGCardFlippedAnnouncement new

MGCard >> disappear
    self notifyDisappear

MGCard >> notifyDisappear
    self announcer announce: MGCardDisappearAnnouncement new
```

**2. View subscribes to model:**
```smalltalk
MGCardElement >> card: aCard
    card := aCard.
    card announcer
        when: MGCardFlippedAnnouncement
        send: #showCardFace
        to: self.
    card announcer
        when: MGCardDisappearAnnouncement
        send: #onDisappear
        to: self.
    self fillUpFrontElement.
    self showCardFace
```

**3. View reacts to announcements:**
```smalltalk
MGCardElement >> showCardFace
    card isFlipped
        ifTrue: [ self showFrontFace ]
        ifFalse: [ self showBackFace ]

MGCardElement >> showFrontFace
    self removeChildren.
    self addChild: frontElement

MGCardElement >> showBackFace
    self removeChildren.
    self addChild: backElement

MGCardElement >> onDisappear
    self visibility: BlVisibility hidden
```

### Game Logic

**Choose a card and check for match/mismatch:**
```smalltalk
MGGame >> chooseCard: aCard
    "Handle card selection with full game logic"
    (self chosenCards includes: aCard) ifTrue: [ ^ self ].
    chosenCards add: aCard.
    aCard flip.
    self shouldCompleteStep ifTrue: [ ^ self completeStep ].
    self shouldResetStep ifTrue: [ ^ self resetStep ]

MGGame >> shouldCompleteStep
    "Two cards with same symbol = match"
    chosenCards size = 2 ifFalse: [ ^ false ].
    ^ chosenCards first symbol = chosenCards second symbol

MGGame >> completeStep
    "Match! Make cards disappear"
    chosenCards do: [ :card | card disappear ].
    chosenCards removeAll

MGGame >> shouldResetStep
    "Two cards with different symbols = mismatch"
    chosenCards size = 2 ifFalse: [ ^ false ].
    ^ chosenCards first symbol ~= chosenCards second symbol

MGGame >> resetStep
    "Mismatch! Flip cards back"
    chosenCards do: [ :card | card flip ].
    chosenCards removeAll
```

### Click Handling with Bloc

**Register click handler in initialize:**
```smalltalk
MGCardElement >> initialize
    super initialize.
    self initializeBackElement.
    self initializeFrontElement.
    self size: self cardExtent.
    self background: self backgroundPaint.
    self geometry: (BlRoundedRectangleGeometry cornerRadius: 12).
    self addEventHandlerOn: BlClickEvent do: [ :event | self click ].
    self card: (MGCard new symbol: $a)

MGCardElement >> click
    "Ignore if already flipped"
    card isFlipped ifTrue: [ ^ self ].
    memoryGame chooseCard: card
```

### Board Layout with BlGridLayout

```smalltalk
MGGameElement >> initialize
    super initialize.
    self background: Color veryLightGray.
    self layout: (BlGridLayout horizontal cellSpacing: 20).
    self constraintsDo: [ :c |
        c horizontal fitContent.
        c vertical fitContent ]

MGGameElement >> memoryGame: aGameModel
    memoryGame := aGameModel.
    self layout columnCount: memoryGame gridSize.
    memoryGame availableCards do: [ :aCard |
        | cardElement |
        cardElement := MGCardElement new.
        cardElement memoryGame: memoryGame.
        cardElement card: aCard.
        self addChild: cardElement ]
```

---

## CRC Cards

### MGCard
```
┌──────────────────────────────────────────────────────────┐
│ MGCard                                                    │
├──────────────────────────────────────────────────────────┤
│ Responsibilities              │ Collaborators             │
├───────────────────────────────┼───────────────────────────┤
│ Hold symbol and flipped state │ Announcer                 │
│ Announce state changes        │ MGCardFlippedAnnouncement │
│ Flip and disappear            │ MGCardDisappearAnnouncement│
└───────────────────────────────┴───────────────────────────┘
```

### MGGame
```
┌──────────────────────────────────────────────────────────┐
│ MGGame                                                    │
├──────────────────────────────────────────────────────────┤
│ Responsibilities              │ Collaborators             │
├───────────────────────────────┼───────────────────────────┤
│ Manage collection of cards    │ MGCard                    │
│ Track chosen cards            │ OrderedCollection         │
│ Determine matches/mismatches  │                           │
│ Complete or reset steps       │                           │
└───────────────────────────────┴───────────────────────────┘
```

### MGCardElement
```
┌──────────────────────────────────────────────────────────┐
│ MGCardElement < BlElement                                 │
├──────────────────────────────────────────────────────────┤
│ Responsibilities              │ Collaborators             │
├───────────────────────────────┼───────────────────────────┤
│ Display card visually         │ MGCard                    │
│ Handle click events           │ MGGame                    │
│ Show front/back face          │ BlElement, BlTextElement  │
│ Subscribe to card changes     │ Announcer                 │
│ Hide when card disappears     │ BlVisibility              │
└───────────────────────────────┴───────────────────────────┘
```

### MGGameElement
```
┌──────────────────────────────────────────────────────────┐
│ MGGameElement < BlElement                                 │
├──────────────────────────────────────────────────────────┤
│ Responsibilities              │ Collaborators             │
├───────────────────────────────┼───────────────────────────┤
│ Display game board            │ MGGame                    │
│ Arrange cards in grid         │ MGCardElement             │
│ Create card elements          │ BlGridLayout              │
└───────────────────────────────┴───────────────────────────┘
```

---

## Key Concepts Learned

### 1. Model-View Separation with Announcements
- Model knows nothing about views
- Views subscribe to model changes via `Announcer`
- Loose coupling enables testing model independently

### 2. Bloc Graphics
- `BlElement` is the base visual building block
- `BlGridLayout` arranges children in rows/columns
- `BlClickEvent` handles mouse clicks
- `BlVisibility hidden` hides elements without removing them

### 3. Event-Driven Architecture
- User clicks trigger view methods
- View delegates to model (`chooseCard:`)
- Model changes state and announces
- Views react to announcements and update display

---

## Loading Bloc (if not already loaded)

```smalltalk
Metacello new
    baseline: 'Bloc';
    repository: 'github://pharo-graphics/Bloc:master/src';
    load
```

---

## Notes

- Tested on Pharo 13
- Uses Bloc graphics library
- Pharo 13 requires `when:do:for:` (not just `when:do:`)
- All classes in single `MemoryGame` package
