//
//  favouriteMatch.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import RealmSwift

class FavouriteMatch: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var homeTeamImage: String
    @Persisted var awayTeamImage: String
    @Persisted var homeTeamName: String
    @Persisted var awayTeamName: String
    @Persisted var utcDate: String
    @Persisted var matchday: Int
    @Persisted var winner: String?
    @Persisted var fullTimeScoreHome: Int?
    @Persisted var fullTimeScoreAway: Int?
    @Persisted var competitionCode: String?
    @Persisted var competitionName: String?
    convenience init(id: Int, homeTeamImage: String, awayTeamImage: String, homeTeamName: String, awayTeamName: String, utcDate: String, matchday: Int, winner: String?, fullTimeScoreHome: Int?, fullTimeScoreAway: Int?, competitionCode: String?, competitionName: String?) {
        self.init()
        self.id = id
        self.homeTeamImage = homeTeamImage
        self.awayTeamImage = awayTeamImage
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.utcDate = utcDate
        self.matchday = matchday
        self.winner = winner
        self.fullTimeScoreHome = fullTimeScoreHome
        self.fullTimeScoreAway = fullTimeScoreAway
        self.competitionCode = competitionCode
        self.competitionName = competitionName
    }

}

//class ScoreObject: Object {
//    @Persisted var winner: String?
//    @Persisted var fullTimeHome: Int?
//    @Persisted var fullTimeAway: Int?
//}
//class CompetitionObject: Object {
//    @Persisted var id: Int
//    @Persisted var name: String?
//    @Persisted var code: String?
//}
