Class {
	#name : 'MGCard',
	#superclass : 'Object',
	#instVars : [
		'symbol',
		'flipped',
		'announcer'
	],
	#category : 'MemoryGame',
	#package : 'MemoryGame'
}

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

{ #category : 'accessing' }
MGCard >> symbol [
	^ symbol
]

{ #category : 'accessing' }
MGCard >> symbol: aSymbol [
	symbol := aSymbol
]
