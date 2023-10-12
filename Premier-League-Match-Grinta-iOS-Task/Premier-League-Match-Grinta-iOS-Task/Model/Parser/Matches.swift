//
//  Matches.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import OptionallyDecodable

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
    var name: CompetitionName?
    var code: CompetitionCode?
    var type: CompetitionType?
    var emblem: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case code = "code"
        case type = "type"
        case emblem = "emblem"
    }
}

enum CompetitionCode: String, Codable {
    case pl = "PL"
}

enum CompetitionName: String, Codable {
    case premierLeague = "Premier League"
}

enum CompetitionType: String, Codable {
    case league = "LEAGUE"
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
    var stage: Stage?
    var group: JSONNull?
    var lastUpdated: String
    var homeTeam: Team
    var awayTeam: Team
    var score: Score
    var odds: Odds
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
        case odds = "odds"
        case referees = "referees"
    }
}

// MARK: - Area
struct Area: Codable {
    var id: Int
    var name: NationalityEnum?
    var code: AreaCode?
    var flag: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case code = "code"
        case flag = "flag"
    }
}

enum AreaCode: String, Codable {
    case eng = "ENG"
}

enum NationalityEnum: String, Codable {
    case australia = "Australia"
    case england = "England"
}

// MARK: - Team
struct Team: Codable {
    var id: Int
    var name: AwayTeamName?
    var shortName: ShortName?
    var tla: TLA?
    var crest: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case shortName = "shortName"
        case tla = "tla"
        case crest = "crest"
    }
}

enum AwayTeamName: String, Codable {
    case afcBournemouth = "AFC Bournemouth"
    case arsenalFC = "Arsenal FC"
    case astonVillaFC = "Aston Villa FC"
    case brentfordFC = "Brentford FC"
    case brightonHoveAlbionFC = "Brighton & Hove Albion FC"
    case burnleyFC = "Burnley FC"
    case chelseaFC = "Chelsea FC"
    case crystalPalaceFC = "Crystal Palace FC"
    case evertonFC = "Everton FC"
    case fulhamFC = "Fulham FC"
    case liverpoolFC = "Liverpool FC"
    case lutonTownFC = "Luton Town FC"
    case manchesterCityFC = "Manchester City FC"
    case manchesterUnitedFC = "Manchester United FC"
    case newcastleUnitedFC = "Newcastle United FC"
    case nottinghamForestFC = "Nottingham Forest FC"
    case sheffieldUnitedFC = "Sheffield United FC"
    case tottenhamHotspurFC = "Tottenham Hotspur FC"
    case westHamUnitedFC = "West Ham United FC"
    case wolverhamptonWanderersFC = "Wolverhampton Wanderers FC"
}

enum ShortName: String, Codable {
    case arsenal = "Arsenal"
    case astonVilla = "Aston Villa"
    case bournemouth = "Bournemouth"
    case brentford = "Brentford"
    case brightonHove = "Brighton Hove"
    case burnley = "Burnley"
    case chelsea = "Chelsea"
    case crystalPalace = "Crystal Palace"
    case everton = "Everton"
    case fulham = "Fulham"
    case liverpool = "Liverpool"
    case lutonTown = "Luton Town"
    case manCity = "Man City"
    case manUnited = "Man United"
    case newcastle = "Newcastle"
    case nottingham = "Nottingham"
    case sheffieldUtd = "Sheffield Utd"
    case tottenham = "Tottenham"
    case westHam = "West Ham"
    case wolverhampton = "Wolverhampton"
}

enum TLA: String, Codable {
    case ars = "ARS"
    case avl = "AVL"
    case bha = "BHA"
    case bou = "BOU"
    case bre = "BRE"
    case bur = "BUR"
    case che = "CHE"
    case cry = "CRY"
    case eve = "EVE"
    case ful = "FUL"
    case liv = "LIV"
    case lut = "LUT"
    case mci = "MCI"
    case mun = "MUN"
    case new = "NEW"
    case not = "NOT"
    case she = "SHE"
    case tot = "TOT"
    case whu = "WHU"
    case wol = "WOL"
}

// MARK: - Odds
struct Odds: Codable {
    var msg: Msg?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
    }
}

enum Msg: String, Codable {
    case activateOddsPackageInUserPanelToRetrieveOdds = "Activate Odds-Package in User-Panel to retrieve odds."
}

// MARK: - Referee
struct Referee: Codable {
    var id: Int
    var name: String
    var type: RefereeType?
    var nationality: NationalityEnum?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case nationality = "nationality"
    }
}

enum RefereeType: String, Codable {
    case referee = "REFEREE"
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

enum Stage: String, Codable {
    case regularSeason = "REGULAR_SEASON"
}

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
