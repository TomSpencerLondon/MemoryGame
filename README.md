# Memory Game - Pharo Kata with Bloc

Build a Memory card matching game using **Bloc** (Pharo's graphics library). This tutorial teaches Bloc fundamentals: elements, layouts, events, announcements, and animations.

## What We're Building

A card matching game where:
- 4x4 grid of 16 cards (8 pairs)
- Click cards to flip them
- Match pairs to make them disappear
- Uses Model-View architecture with Announcements

## Key Concepts

- **Bloc Elements**: Visual building blocks (`BlElement` subclasses)
- **Layouts**: `BlGridLayout`, `BlLinearLayout`
- **Events**: `BlClickEvent`, event handlers
- **Announcements**: Model-View communication (loose coupling)
- **Animations**: `BlTransformAnimation`, `BlOpacityAnimation`

## Class Structure

### Model Classes
```
MGCard - A single card model
├── symbol (what's on the card)
├── flipped (boolean)
├── announcer (for notifications)
├── flip, disappear methods

MGGame - The game logic
├── availableCards (all cards)
├── chosenCards (selected cards)
├── gridSize, matchesCount
├── chooseCard:, completeStep, resetStep
```

### Announcement Classes
```
MGCardFlippedAnnouncement
MGCardDisappearAnnouncement
```

### View Classes (Bloc Elements)
```
MGCardElement < BlElement
├── card (model reference)
├── backElement, frontElement
├── showFrontFace, showBackFace
├── Event handling for clicks

MGGameElement < BlElement
├── memoryGame (model reference)
├── Grid layout for cards
```

## Progress Checklist

### Chapter 2: Game Model
- [x] Step 1: Create `MGCard` class with `symbol`, `flipped`, `announcer`
- [ ] Step 2: Add `flip`, `disappear`, `notifyFlipped`, `notifyDisappear`
- [ ] Step 3: Create `MGCardFlippedAnnouncement`, `MGCardDisappearAnnouncement`
- [ ] Step 4: Create `MGGame` class with `availableCards`, `chosenCards`
- [ ] Step 5: Add `gridSize`, `matchesCount`, `cardsCount`, `initializeForSymbols:`
- [ ] Step 6: Add game logic: `chooseCard:`, `shouldCompleteStep`, `completeStep`, `shouldResetStep`, `resetStep`

### Chapter 3: Card Graphical Element
- [ ] Step 7: Create `MGCardElement < BlElement` with `card` slot
- [ ] Step 8: Add `initialize` with size, background, rounded rectangle geometry
- [ ] Step 9: Add `backElement`, `frontElement` for two-sided card
- [ ] Step 10: Create `initializeBackElement` (cross pattern)
- [ ] Step 11: Create `initializeFrontElement` with `BlTextElement`
- [ ] Step 12: Add `showFrontFace`, `showBackFace`, `showCardFace`
- [ ] Step 13: Update `card:` setter to configure visual

### Chapter 4: Board View
- [ ] Step 14: Create `MGGameElement < BlElement`
- [ ] Step 15: Add `initialize` with `BlGridLayout`, `fitContent` constraints
- [ ] Step 16: Add `memoryGame:` to create card elements from model
- [ ] Step 17: Create `MGGame class >> withNumbers` convenience method
- [ ] Step 18: Create `MGGameElement class >> openWithNumber` to launch game

### Chapter 5: Game Interactions
- [ ] Step 19: Add click event handler to `MGCardElement`
- [ ] Step 20: Define `click` method to notify model and update view
- [ ] Step 21: Register for announcements in `card:` setter
- [ ] Step 22: Handle `MGCardFlippedAnnouncement` -> `showCardFace`
- [ ] Step 23: Handle `MGCardDisappearAnnouncement` -> `onDisappear`

### Chapter 6: Animations (Optional)
- [ ] Step 24: Add flip animation with `BlTransformAnimation`
- [ ] Step 25: Add disappear animation combining scale and opacity

## Step-by-Step Implementation

### Step 1: MGCard Class with Basic State

**Tests:**
```smalltalk
MGCardTest >> testCardHasSymbol
    | card |
    card := MGCard new symbol: $A.
    self assert: card symbol equals: $A

MGCardTest >> testCardIsNotFlippedInitially
    | card |
    card := MGCard new.
    self deny: card isFlipped

MGCardTest >> testCardHasAnnouncer
    | card |
    card := MGCard new.
    self assert: (card announcer isKindOf: Announcer)
```

**Implementation:**
```smalltalk
Object subclass: #MGCard
    instanceVariableNames: 'symbol flipped announcer'
    classVariableNames: ''
    package: 'MemoryGame'

MGCard >> initialize
    super initialize.
    flipped := false.
    announcer := Announcer new

MGCard >> symbol
    ^ symbol

MGCard >> symbol: aSymbol
    symbol := aSymbol

MGCard >> isFlipped
    ^ flipped

MGCard >> announcer
    ^ announcer
```

### Step 2: Flip and Notification Methods

**Tests:**
```smalltalk
MGCardTest >> testFlipTogglesState
    | card |
    card := MGCard new.
    self deny: card isFlipped.
    card flip.
    self assert: card isFlipped.
    card flip.
    self deny: card isFlipped

MGCardTest >> testFlipAnnouncesFlipped
    | card announced |
    card := MGCard new.
    announced := false.
    card announcer
        when: MGCardFlippedAnnouncement
        do: [ announced := true ].
    card flip.
    self assert: announced
```

**Implementation:**
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

### Step 3: Announcement Classes

**Implementation:**
```smalltalk
Announcement subclass: #MGCardFlippedAnnouncement
    instanceVariableNames: ''
    classVariableNames: ''
    package: 'MemoryGame'

Announcement subclass: #MGCardDisappearAnnouncement
    instanceVariableNames: ''
    classVariableNames: ''
    package: 'MemoryGame'
```

### Step 4: MGGame Class

**Tests:**
```smalltalk
MGGameTest >> testGameHasAvailableCards
    | game |
    game := MGGame new.
    self assert: game availableCards isCollection

MGGameTest >> testGameHasChosenCards
    | game |
    game := MGGame new.
    self assert: game chosenCards isEmpty
```

**Implementation:**
```smalltalk
Object subclass: #MGGame
    instanceVariableNames: 'availableCards chosenCards'
    classVariableNames: ''
    package: 'MemoryGame'

MGGame >> initialize
    super initialize.
    availableCards := OrderedCollection new.
    chosenCards := OrderedCollection new

MGGame >> availableCards
    ^ availableCards

MGGame >> chosenCards
    ^ chosenCards
```

### Step 5: Game Initialization

**Tests:**
```smalltalk
MGGameTest >> testGridSize
    | game |
    game := MGGame new initializeForSymbols: #($A $B $C $D $E $F $G $H).
    self assert: game gridSize equals: 4

MGGameTest >> testCardsCount
    | game |
    game := MGGame new initializeForSymbols: #($A $B $C $D $E $F $G $H).
    self assert: game cardsCount equals: 16

MGGameTest >> testMatchesCount
    | game |
    game := MGGame new initializeForSymbols: #($A $B $C $D $E $F $G $H).
    self assert: game matchesCount equals: 8
```

**Implementation:**
```smalltalk
MGGame >> initializeForSymbols: aCollection
    | cards |
    cards := (aCollection , aCollection)
        collect: [ :symbol | MGCard new symbol: symbol ].
    availableCards := cards shuffled

MGGame >> gridSize
    ^ availableCards size sqrt asInteger

MGGame >> cardsCount
    ^ availableCards size

MGGame >> matchesCount
    ^ availableCards size / 2
```

### Step 6: Game Logic

**Tests:**
```smalltalk
MGGameTest >> testChooseCardAddsToChosen
    | game card |
    game := MGGame new initializeForSymbols: #($A $B).
    card := game availableCards first.
    game chooseCard: card.
    self assert: (game chosenCards includes: card)

MGGameTest >> testShouldCompleteStepWhenTwoMatchingCards
    | game card1 card2 |
    game := MGGame new initializeForSymbols: #($A $B).
    card1 := game availableCards detect: [ :c | c symbol = $A ].
    card2 := game availableCards detect: [ :c | c symbol = $A and: [ c ~~ card1 ] ].
    game chooseCard: card1.
    game chooseCard: card2.
    self assert: game shouldCompleteStep
```

**Implementation:**
```smalltalk
MGGame >> chooseCard: aCard
    (chosenCards includes: aCard) ifTrue: [ ^ self ].
    chosenCards add: aCard.
    aCard flip

MGGame >> shouldCompleteStep
    chosenCards size = 2 ifFalse: [ ^ false ].
    ^ chosenCards first symbol = chosenCards second symbol

MGGame >> completeStep
    chosenCards do: [ :card | card disappear ].
    chosenCards removeAll

MGGame >> shouldResetStep
    chosenCards size = 2 ifFalse: [ ^ false ].
    ^ chosenCards first symbol ~= chosenCards second symbol

MGGame >> resetStep
    chosenCards do: [ :card | card flip ].
    chosenCards removeAll
```

## CRC Cards

### MGCard
```
+----------------------------------------------------------+
| MGCard                                                    |
+----------------------------------------------------------+
| Responsibilities              | Collaborators             |
+-------------------------------+---------------------------+
| Hold symbol and flipped state | Announcer                 |
| Announce state changes        | MGCardFlippedAnnouncement |
| Flip and disappear            | MGCardDisappearAnnouncement |
+-------------------------------+---------------------------+
```

### MGGame
```
+----------------------------------------------------------+
| MGGame                                                    |
+----------------------------------------------------------+
| Responsibilities              | Collaborators             |
+-------------------------------+---------------------------+
| Manage collection of cards    | MGCard                    |
| Track chosen cards            | OrderedCollection         |
| Determine matches             |                           |
| Complete or reset steps       |                           |
+-------------------------------+---------------------------+
```

### MGCardElement
```
+----------------------------------------------------------+
| MGCardElement                                             |
+----------------------------------------------------------+
| Responsibilities              | Collaborators             |
+-------------------------------+---------------------------+
| Display card visually         | MGCard                    |
| Handle click events           | BlElement                 |
| Show front/back face          | BlTextElement             |
| Subscribe to card changes     | Announcer                 |
+-------------------------------+---------------------------+
```

### MGGameElement
```
+----------------------------------------------------------+
| MGGameElement                                             |
+----------------------------------------------------------+
| Responsibilities              | Collaborators             |
+-------------------------------+---------------------------+
| Display game board            | MGGame                    |
| Arrange cards in grid         | MGCardElement             |
| Create card elements          | BlGridLayout              |
+-------------------------------+---------------------------+
```

## The Key Pattern: Model-View with Announcements

```smalltalk
"1. Model announces changes"
MGCard >> flip
    flipped := flipped not.
    self announcer announce: MGCardFlippedAnnouncement new

"2. View subscribes to model"
MGCardElement >> card: aCard
    card := aCard.
    card announcer
        when: MGCardFlippedAnnouncement send: #showCardFace to: self

"3. View updates when model changes"
MGCardElement >> showCardFace
    card isFlipped
        ifTrue: [ self showFrontFace ]
        ifFalse: [ self showBackFace ]
```

## Sequence Diagram: Card Click Flow

```
+---------+     +---------------+     +--------+     +--------+
|  User   |     | MGCardElement |     | MGCard |     | MGGame |
+----+----+     +-------+-------+     +----+---+     +----+---+
     |                  |                  |              |
     | click            |                  |              |
     |----------------->|                  |              |
     |                  |                  |              |
     |                  | chooseCard:      |              |
     |                  |-------------------------------->|
     |                  |                  |              |
     |                  |                  | flip         |
     |                  |                  |<-------------|
     |                  |                  |              |
     |                  |                  | announce     |
     |                  |                  |------------->|
     |                  |                  |              |
     |                  | showCardFace     |              |
     |                  |<-----------------|              |
     |                  |                  |              |
     | visual update    |                  |              |
     |<-----------------|                  |              |
```

## Loading the Complete Solution

If you want to see the finished implementation:
```smalltalk
Metacello new
    baseline: 'BlocMemoryTutorial';
    repository: 'github://pharo-graphics/Bloc-Memory-Tutorial/src';
    load
```

Then run: `MGGameElement openWithNumber`

## Notes

- Requires Pharo 11+ (tested on Pharo 13)
- Uses Bloc graphics library (included in Pharo)
- Model uses Announcements for loose coupling to View
- View registers for model changes, sends messages to model
