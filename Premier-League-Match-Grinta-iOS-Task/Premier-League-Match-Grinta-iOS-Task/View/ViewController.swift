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
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var matchTableView: UITableView!
    let disposeBag = DisposeBag()
    let matchVM = MatchViewModel()
       override func viewDidLoad() {
           super.viewDidLoad()
           matchTableView.register(UINib(nibName: Constants.cellsResuable.MatchTVC, bundle: nil), forCellReuseIdentifier: Constants.cellsResuable.MatchTVC)
           matchVM.getMatches()
           bindTableView()
           // Do any additional setup after loading the view.
       }


}
//MARK: - Rx Functions
extension ViewController {
    func bindTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<MatchSectionModel>(
            configureCell: { [weak self]  dataSource, tableView, indexPath, match in
                guard let self = self else {
                    return UITableViewCell()
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellsResuable.MatchTVC, for: indexPath) as! MatchTableViewCell
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
                    cell.statusLabel.text = matchVM.formatTime(dateString: match.utcDate) ?? "N/A"
                    cell.timeZoneLabel.text = TimeZone.current.identifier
                } else {
                    let homeScore = String(match.score.fullTime.home ?? 0)
                    let awayScore = String(match.score.fullTime.away ?? 0)
                    cell.statusLabel.text = homeScore + "-" + awayScore
                    cell.timeZoneLabel.text = ""
                }
                cell.onFavButtonTapped = {
                    print("Tappped")
                }
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
            }
        )
        
        matchVM.matchesList
            .map { matches in
                // Categorize your matches into sections based on the day
                let categorizedMatches = self.matchVM.categorizeMatches(matches)
 
                return categorizedMatches.map { date, matches in
                    MatchSectionModel(model: date, items: matches)
                }
            }
            .bind(to: matchTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
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


