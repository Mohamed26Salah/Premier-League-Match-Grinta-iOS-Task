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
    var filters: Filters
    var resultSet: ResultSet
    var competition: Competition
    var matches: [Match]

    enum CodingKeys: String, CodingKey {
        case filters = "filters"
        case resultSet = "resultSet"
        case competition = "competition"
        case matches = "matches"
    }
}

// MARK: - Competition
struct Competition: Codable {
    var id: Int
    var name: String?
    var code: String?
    var type: String?
    var emblem: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case code = "code"
        case type = "type"
        case emblem = "emblem"
    }
}

// MARK: - Filters
struct Filters: Codable {
    var season: String

    enum CodingKeys: String, CodingKey {
        case season = "season"
    }
}

// MARK: - Match
struct Match: Codable {
    var area: Area
    var competition: Competition
    var season: Season
    var id: Int
    var utcDate: String
    var status: Status?
    var matchday: Int
    var stage: String?
    var group: JSONNull?
    var lastUpdated: String
    var homeTeam: Team
    var awayTeam: Team
    var score: Score
//    var odds: Odds
    var referees: [Referee]

    enum CodingKeys: String, CodingKey {
        case area = "area"
        case competition = "competition"
        case season = "season"
        case id = "id"
        case utcDate = "utcDate"
        case status = "status"
        case matchday = "matchday"
        case stage = "stage"
        case group = "group"
        case lastUpdated = "lastUpdated"
        case homeTeam = "homeTeam"
        case awayTeam = "awayTeam"
        case score = "score"
//        case odds = "odds"
        case referees = "referees"
    }
}

// MARK: - Area
struct Area: Codable {
    var id: Int
    var name: String?
    var code: String?
    var flag: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case code = "code"
        case flag = "flag"
    }
}

// MARK: - Team
struct Team: Codable {
    var id: Int
    var name: String?
    var shortName: String?
    var tla: String?
    var crest: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case shortName = "shortName"
        case tla = "tla"
        case crest = "crest"
    }
}

// MARK: - Odds
//struct Odds: Codable {
//    var msg: Msg?
//
//    enum CodingKeys: String, CodingKey {
//        case msg = "msg"
//    }
//}
//
//enum Msg: String, Codable {
//    case activateOddsPackageInUserPanelToRetrieveOdds = "Activate Odds-Package in User-Panel to retrieve odds."
//}

// MARK: - Referee
struct Referee: Codable {
    var id: Int
    var name: String
    var type: String?
    var nationality: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case nationality = "nationality"
    }
}

// MARK: - Score
struct Score: Codable {
    var winner: Winner?
    var duration: Duration?
    var fullTime: Time
    var halfTime: Time

    enum CodingKeys: String, CodingKey {
        case winner = "winner"
        case duration = "duration"
        case fullTime = "fullTime"
        case halfTime = "halfTime"
    }
}

enum Duration: String, Codable {
    case regular = "REGULAR"
}

// MARK: - Time
struct Time: Codable {
    var home: Int?
    var away: Int?

    enum CodingKeys: String, CodingKey {
        case home = "home"
        case away = "away"
    }
}

enum Winner: String, Codable {
    case awayTeam = "AWAY_TEAM"
    case draw = "DRAW"
    case homeTeam = "HOME_TEAM"
}

// MARK: - Season
struct Season: Codable {
    var id: Int
    var startDate: String
    var endDate: String
    var currentMatchday: Int
    var winner: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case startDate = "startDate"
        case endDate = "endDate"
        case currentMatchday = "currentMatchday"
        case winner = "winner"
    }
}

//enum Stage: String, Codable {
//    case regularSeason = "REGULAR_SEASON"
//}

enum Status: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}

// MARK: - ResultSet
struct ResultSet: Codable {
    var count: Int
    var first: String
    var last: String
    var played: Int

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case first = "first"
        case last = "last"
        case played = "played"
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
extension Match: IdentifiableType, Equatable {
    var identity: Int { return id }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
}
