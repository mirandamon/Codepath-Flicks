//
//  MovieCell.swift
//  Flicks
//
//  Created by Nathan Miranda on 1/5/16.
//  Copyright © 2016 Miraen. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.imageView?.tintColor = UIColor.grayColor()
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = UIColor.redColor()
        self.selectedBackgroundView = cellBackgroundView

        // Configure the view for the selected state
    }

}
