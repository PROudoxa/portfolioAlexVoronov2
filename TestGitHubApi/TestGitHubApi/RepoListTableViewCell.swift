//
//  TableViewCell.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 08.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class RepoListTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    
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
