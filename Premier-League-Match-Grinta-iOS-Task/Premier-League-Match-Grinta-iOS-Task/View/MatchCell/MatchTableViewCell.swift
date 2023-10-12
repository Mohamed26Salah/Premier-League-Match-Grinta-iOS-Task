//
//  MatchTableViewCell.swift
//  Premier-League-Match-Grinta-iOS-Task
//
//  Created by Mohamed Salah on 12/10/2023.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var saveToFavouritesButton: RadioButton!
    var onFavButtonTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func saveToFavouritesButtonTapped(_ sender: RadioButton) {
        onFavButtonTapped?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
