//
//  MoodCalendar.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation

// MoodCalendar Model: represents a user's mood calendar, with emojis assigned to mood per day
struct MoodCalendar: Identifiable, Codable {
    enum Mood: String, Codable {
        case happy = "😄"
        case sad = "😢"
        case neutral = "😐"
        case excited = "😃"
        case angry = "😡"
    }

    var calendar: [Date: Mood] = [:]
    // var mood: Mood?
    
    let id: String
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
}
