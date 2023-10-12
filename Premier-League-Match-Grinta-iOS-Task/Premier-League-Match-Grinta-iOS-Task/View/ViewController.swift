//
//  ViewController.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class ViewController: UIViewController {

    @IBOutlet weak var matchTableView: UITableView!
    let disposeBag = DisposeBag()
    let matchVM = MatchViewModel()
       override func viewDidLoad() {
           super.viewDidLoad()
           matchTableView.register(UINib(nibName: Constants.cellsResuable.MatchTVC, bundle: nil), forCellReuseIdentifier: Constants.cellsResuable.MatchTVC)
           matchVM.getMatches()
           showRecipesData()
           // Do any additional setup after loading the view.
       }


}
//MARK: - Rx Functions
extension ViewController {
    func showRecipesData() {
        matchVM.matchesList
            .bind(to: matchTableView
                .rx
                .items(cellIdentifier: Constants.cellsResuable.MatchTVC, cellType: MatchTableViewCell.self)) { [weak self] (tv, match, cell) in
                    guard let self = self else {
                        return
                    }
                    if let url = URL(string: match.homeTeam.crest) {
                        cell.homeTeamImage.sd_setImage(with: url, placeholderImage: .cardLive)
                    }
                    if let url = URL(string: match.awayTeam.crest) {
//                        cell.awayTeamImage.sd_setImage(with: url)
                        cell.awayTeamImage.sd_setImage(with: url, placeholderImage: .cardLive)
                    }
                    cell.homeTeamNameLabel.text = match.homeTeam.name
                    cell.awayTeamNameLabel.text = match.awayTeam.name
                    if match.score.winner == nil {
                        cell.statusLabel.text = matchVM.formatDate(dateString: match.utcDate) ?? "N/A"
                    } else {
                        let homeScore = String(match.score.fullTime.home ?? 0)
                        let awayScore = String(match.score.fullTime.away ?? 0)
                        cell.statusLabel.text = homeScore + "-" + awayScore
                    }
                    cell.onFavButtonTapped = {
                        print("Tappped")
                    }
                }
                .disposed(by: disposeBag)
    }
}
//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellsResuable.MatchTVC, for: indexPath) as! MatchTableViewCell
//        cell.homeTeamNameLabel.text = "Salah"
//        cell.awayTeamNameLabel.text = "Mohamed"
////        if let url = URL(string: (gamesArray?[indexPath.row].thumbnail)! ) {
//////            cell.gameImage.
////        }
////        cell.gameLabel.text = gamesArray?[indexPath.row].title ?? "Unknown"
//        return cell
//    }
//    
//    
//}


