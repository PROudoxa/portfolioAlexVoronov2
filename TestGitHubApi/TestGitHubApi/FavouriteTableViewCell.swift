//
//  FavouriteTableViewCell.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 12.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var stargazersCountLabel: UILabel!
    @IBOutlet weak var loginOwnerLabel: UILabel!
    @IBOutlet weak var nameRepoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // TODO: implement something awesome here
        // Configure the view for the selected state
    }
}
