Class {
	#name : 'MGCardDisappearAnnouncement',
	#superclass : 'Announcement',
	#category : 'MemoryGame',
	#package : 'MemoryGame'
}

{ #category : 'accessing' }
MGCardDisappearAnnouncement class >> announcer [
	self shouldBeImplemented.
]

{ #category : 'as yet unclassified' }
MGCardDisappearAnnouncement >> disappear [
	self notifyDisappear
]

{ #category : 'as yet unclassified' }
MGCardDisappearAnnouncement >> notifyDisappear [
	self announcer announce: MGCardDisappearAnnouncement new
]
