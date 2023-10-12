//
//  MatchViewModel.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import Foundation
import RxSwift
import RxRelay
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
    func formatDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM/dd"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
}
