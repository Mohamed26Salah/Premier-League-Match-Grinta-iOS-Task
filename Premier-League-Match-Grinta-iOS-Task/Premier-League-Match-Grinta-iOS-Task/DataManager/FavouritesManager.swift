//
//  FavouritesManager.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import RealmSwift
import Differentiator

class FavouritesManager {
    private init() {}
    
    private static let sharedInstance = FavouritesManager()
    private let realm = try! Realm()

    static func shared() -> FavouritesManager {
        return FavouritesManager.sharedInstance
    }

    func addToFavorites(match: FavouriteMatch) {
        try! realm.write {
            if let existingMatch = realm.object(ofType: FavouriteMatch.self, forPrimaryKey: match.id) {
                if !existingMatch.isInvalidated {
                    realm.delete(existingMatch)
                }
            }
            //Safer Approach - To avoid crashes - if the user spam the RadioButton
            let newMatch = FavouriteMatch(id: match.id,
                                          homeTeamImage: match.homeTeamImage,
                                          awayTeamImage: match.awayTeamImage,
                                          homeTeamName: match.homeTeamName,
                                          awayTeamName: match.awayTeamName,
                                          utcDate: match.utcDate,
                                          matchday: match.matchday,
                                          winner: match.winner,
                                          fullTimeScoreHome: match.fullTimeScoreHome,
                                          fullTimeScoreAway: match.fullTimeScoreAway,
                                          competitionCode: match.competitionCode,
                                          competitionName: match.competitionName)
            realm.add(newMatch, update: .modified)
        }
    }

    func isMatchFavorited(id: Int) -> Bool {
        return realm.object(ofType: FavouriteMatch.self, forPrimaryKey: id) != nil
    }

    func removeFromFavorites(match: FavouriteMatch) {
        if let matchToDelete = realm.object(ofType: FavouriteMatch.self, forPrimaryKey: match.id) {
            try! realm.write {
                realm.delete(matchToDelete)
            }
        }
    }

    func getAllFavoriteMatches() -> [Match] {
        let favoriteMatches = realm.objects(FavouriteMatch.self)
        return convertFromRealmObjectToNormal(favoriteArray: Array(favoriteMatches))
    }
    func convertFromRealmObjectToNormal(favoriteArray: [FavouriteMatch]) -> [Match] {
        return favoriteArray.map { favoriteMatch in
            let competition = Competition(name: favoriteMatch.competitionName, code: favoriteMatch.competitionCode)
            let homeTeam = Team(name: favoriteMatch.homeTeamName, crest: favoriteMatch.homeTeamImage)
            let awayTeam = Team(name: favoriteMatch.awayTeamName, crest: favoriteMatch.awayTeamImage)

            var winner: Winner? = nil
            if let favoriteWinner = favoriteMatch.winner {
                winner = Winner(rawValue: favoriteWinner)
            }

            let fullTimeHome = Time(home: favoriteMatch.fullTimeScoreHome, away: favoriteMatch.fullTimeScoreAway)
            let score = Score(winner: winner, fullTime: fullTimeHome)

            return Match(competition: competition, id: favoriteMatch.id, utcDate: favoriteMatch.utcDate, matchday: favoriteMatch.matchday, homeTeam: homeTeam, awayTeam: awayTeam, score: score)
        }
    }

    func returnDataBaseURL() -> String {
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            return ("Realm database URL: \(realmURL)")
        }
        return "Couldn't Find the Database"
    }

}
