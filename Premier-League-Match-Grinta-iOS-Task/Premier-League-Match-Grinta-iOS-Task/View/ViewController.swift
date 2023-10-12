//
//  ViewController.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    @IBOutlet weak var matchTableView: UITableView!
    let disposeBag = DisposeBag()
       override func viewDidLoad() {
           super.viewDidLoad()
           matchTableView.register(UINib(nibName: Constants.cellsResuable.MatchTVC, bundle: nil), forCellReuseIdentifier: Constants.cellsResuable.MatchTVC)
           // Do any additional setup after loading the view.
       }


}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellsResuable.MatchTVC, for: indexPath) as! MatchTableViewCell
        cell.homeTeamNameLabel.text = "Salah"
        cell.awayTeamNameLabel.text = "Mohamed"
//        if let url = URL(string: (gamesArray?[indexPath.row].thumbnail)! ) {
////            cell.gameImage.
//        }
//        cell.gameLabel.text = gamesArray?[indexPath.row].title ?? "Unknown"
        return cell
    }
    
    
}

//let headers = [
// "X-Auth-Token": SecurityConstants.Links.apiKey
//]
//
//APIManager().fetchGlobal(parsingType: Matches.self, baseURL: APIManager.EndPoint.matches(competitionCode: "PL").stringToUrl, headers: headers)
//    .observe(on: MainScheduler.instance)
//    .subscribe(
//        onNext: { test in
//         print(test)
//        },
//        onError: { error in
//            print(error)
//        }
//    )
//    .disposed(by: disposeBag)
