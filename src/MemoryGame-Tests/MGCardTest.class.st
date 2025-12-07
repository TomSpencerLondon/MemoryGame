Class {
	#name : 'MGCardTest',
	#superclass : 'TestCase',
	#category : 'MemoryGame-Tests',
	#package : 'MemoryGame-Tests'
}

{ #category : 'tests' }
MGCardTest >> testCardHasSymbol [
	| card |
	card := MGCard new symbol: $A.
	self assert: card symbol equals: $A
]

{ #category : 'tests' }
MGCardTest >> testCardIsNotFlippedInitially [
	| card |
	card := MGCard new.
	self deny: card isFlipped
]

{ #category : 'tests' }
MGCardTest >> testFlipAnnouncesFlipped [
	| card announced |
	card := MGCard new.
	announced := false.
	card announcer
		when: MGCardFlippedAnnouncement
		do: [  announced := true ]
		for: self.
	card flip.
	self assert: announced 
]

{ #category : 'tests' }
MGCardTest >> testFlipTogglesState [
	| card |
	card := MGCard new.
	self deny: card isFlipped.
	card flip.
	self assert: card isFlipped.
	card flip.
	self deny: card isFlipped
]
