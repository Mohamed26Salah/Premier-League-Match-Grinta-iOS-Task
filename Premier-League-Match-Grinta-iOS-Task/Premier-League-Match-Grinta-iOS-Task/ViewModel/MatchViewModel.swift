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
    //out
    var matchesList = PublishRelay<[Match]>.init()
    var showLoading = BehaviorRelay<Bool>(value: false)
    var errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    func getMatches(tag: String = "under_30_minutes") {
        self.showLoading.accept(true)
        let headers = [
         "X-Auth-Token": SecurityConstants.Links.apiKey
        ]
        APIManager().fetchGlobal(parsingType: Matches.self, baseURL: APIManager.EndPoint.matches(competitionCode: "PL").stringToUrl, headers: headers)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { matchesModel in
                    self.matchesModel = matchesModel
                    self.matchesList.accept(matchesModel.matches)
                    self.showLoading.accept(false)
                },
                onError: { error in
                    self.showLoading.accept(false)
                    self.errorSubject.onNext(error)
                }
            )
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
            dateFormatter.dateFormat = "h:mm a"
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
