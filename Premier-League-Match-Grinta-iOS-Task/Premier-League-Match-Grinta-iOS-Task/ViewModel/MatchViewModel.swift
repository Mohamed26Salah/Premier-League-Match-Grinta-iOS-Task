//
//  MatchViewModel.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

typealias MatchSectionModel = AnimatableSectionModel<String, Match>

class MatchViewModel {
    let apiManager: APIClientProtocol
    init(apiManager: APIClientProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    var matchesModel: Matches?
    //In
    let selectedSegmentIndex = BehaviorRelay<Int>(value: 0)

    //out
    var currentMatchesList = PublishRelay<[Match]>.init()
//    var matchesList = PublishRelay<[Match]>.init()
    var matchesList = BehaviorRelay<[Match]>(value: [])
    var favoruiteMatchesList = BehaviorRelay<[Match]>(value: FavouritesManager.shared().getAllFavoriteMatches())
    var showLoading = BehaviorRelay<Bool>(value: false)
    var errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    func inialize() {
        getMatches()
        setupBinding()
    }
    func getMatches() {
        self.showLoading.accept(true)
        let headers = [
         "X-Auth-Token": SecurityConstants.Links.apiKey
        ]
        let request = FetchGlobalRequest(parsingType: Matches.self, baseURL: APIManager.EndPoint.matches(competitionCode: "PL").stringToUrl, headers: headers)
        apiManager.fetchGlobal(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { matchesModel in
                    self.showLoading.accept(false)
                    self.matchesModel = matchesModel
                    self.matchesList.accept(matchesModel.matches)
                    self.currentMatchesList.accept(matchesModel.matches)
                },
                onError: { error in
                    self.showLoading.accept(false)
                    self.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    private func setupBinding() {
        favoruiteMatchesList
            .subscribe(onNext: { [weak self] favoriteMatches in
                guard let self = self else { return }
                
                if self.selectedSegmentIndex.value == 1 {
                    self.currentMatchesList.accept(favoriteMatches)
                }
            })
            .disposed(by: disposeBag)
    }
}
extension MatchViewModel {
    func formatDate(dateString: String, yearly: Bool = false) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = yearly ? "MM/dd/yyyy" : "MM/dd"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    func formatTime(dateString: String, timeZone: TimeZone = .current) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.timeZone = timeZone
//            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }

        return nil
    }

    func categorizeMatches(_ matches: [Match]) -> [(String, [Match])] {
        let categorizedMatches = Dictionary(grouping: matches) { match in
            return formatDate(dateString: match.utcDate, yearly: true) ?? "Unknown"
        }

        var sections = categorizedMatches.map { key, value in
            return (key, value)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        sections.sort { section1, section2 in
            if let date1 = dateFormatter.date(from: section1.0), let date2 = dateFormatter.date(from: section2.0) {
                return date1 < date2
            }
            return false
        }
        
        let today = Date()
        if let todayIndex = sections.firstIndex(where: { dateFormatter.date(from: $0.0) ?? Date.distantFuture >= today }) {
            let todaySection = sections.remove(at: todayIndex)
            sections.insert(todaySection, at: 0)
        }

        return sections
    }


}
//MARK: - DataManager Helper Functions
extension MatchViewModel {
    func createFavouriteObject(match: AnimatableSectionModel<String, Match>.Item) -> FavouriteMatch {
        return FavouriteMatch(id: match.id,
                              homeTeamImage: match.homeTeam.crest,
                              awayTeamImage: match.awayTeam.crest,
                              homeTeamName: match.homeTeam.name ?? "N/A",
                              awayTeamName: match.awayTeam.name ?? "N/A",
                              utcDate: match.utcDate,
                              matchday: match.matchday,
                              winner: match.score.winner?.rawValue,
                              fullTimeScoreHome: match.score.fullTime.home,
                              fullTimeScoreAway: match.score.fullTime.away,
                              competitionCode: match.competition.code,
                              competitionName: match.competition.name)
    }
    //Update the old matches, that was saved before it was played
    func updateMatches() {
        let favouriteDataManger = FavouritesManager.shared()
        let matchesToUpdate = favouriteDataManger.fetchMatchesToUpdate()
        var somethingChanged: Bool = false
        matchesToUpdate.forEach { match in
            if let updatedMatch = matchesModel?.matches.first(where: { $0.id == match.id }), updatedMatch.score.winner != nil {
                somethingChanged = true
                favouriteDataManger.updateMatchInRealm(match: match, with: updatedMatch)
            }
        }
        if somethingChanged {
            favoruiteMatchesList.accept(favouriteDataManger.getAllFavoriteMatches())
        }
    }
}
