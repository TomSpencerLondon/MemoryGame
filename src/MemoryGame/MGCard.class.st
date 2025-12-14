"
I represent a card in a Memory matching game.

I have a symbol that players try to match, and I can be flipped face-up or face-down. I use an Announcer to notify observers when my state changes.

Instance Variables:
- symbol: The character or object displayed on my face (e.g., $A, $B)
- flipped: Boolean indicating whether I am face-up (true) or face-down (false)
- announcer: An Announcer that broadcasts MGCardFlippedAnnouncement and MGCardDisappearAnnouncement

Example:
    card := MGCard new symbol: $A.
    card flip.  ""flips the card and announces the change""
    card isFlipped. ""returns true""

Collaborators:
- MGCardFlippedAnnouncement: Announced when I am flipped
- MGCardDisappearAnnouncement: Announced when I disappear (matched)
"
Class {
	#name : 'MGCard',
	#superclass : 'Object',
	#instVars : [
		'symbol',
		'flipped',
		'announcer'
	],
	#classInstVars : [
		'announcer'
	],
	#category : 'MemoryGame',
	#package : 'MemoryGame'
}

{ #category : 'as yet unclassified' }
MGCard class >> notifyDisappear [
	self announcer announce: MGCardDisappearAnnouncement new
]

{ #category : 'accessing' }
MGCard >> announcer [
	^ announcer
]

{ #category : 'accessing' }
MGCard >> disappear [
	self notifyDisappear
]

{ #category : 'accessing' }
MGCard >> flip [
	flipped := flipped not.
	self notifyFlipped
]

{ #category : 'accessing' }
MGCard >> initialize [
	super initialize.
	flipped := false.
	announcer := Announcer new
	
]

{ #category : 'accessing' }
MGCard >> isFlipped [
	^ flipped
]

{ #category : 'notifying' }
MGCard >> notifyFlipped [
	self announcer announce: MGCardFlippedAnnouncement new
]

{ #category : 'accessing' }
MGCard >> printOn: aStream [
	aStream
		nextPutAll: 'Card';
		nextPut: Character space;
		nextPut: $(;
		nextPut: self symbol;
		nextPut: $)
]

{ #category : 'accessing' }
MGCard >> symbol [
	^ symbol
]

{ #category : 'accessing' }
MGCard >> symbol: aSymbol [
	symbol := aSymbol
]
