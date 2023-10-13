//
//  Matches.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import OptionallyDecodable
import RxDataSources

// MARK: - Matches
struct Matches: Codable {
//    var competition: Competition
    var matches: [Match]
}

// MARK: - Competition
struct Competition: Codable {
    var name: String?
    var code: String?
//    var type: String?
//    var emblem: String
}

// MARK: - Match
struct Match: Codable {
    var competition: Competition
    var id: Int
    var utcDate: String
    var matchday: Int
    var homeTeam: Team
    var awayTeam: Team
    var score: Score
}

// MARK: - Team
struct Team: Codable {
//    var id: Int
    var name: String?
    var crest: String
}

// MARK: - Score
struct Score: Codable {
    var winner: Winner?
    var fullTime: Time
//    var halfTime: Time
}

// MARK: - Time
struct Time: Codable {
    var home: Int?
    var away: Int?
}
// MARK: - Winner
enum Winner: String, Codable {
    case awayTeam = "AWAY_TEAM"
    case draw = "DRAW"
    case homeTeam = "HOME_TEAM"
}

extension Match: IdentifiableType, Equatable {
    var identity: Int { return id }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
}
