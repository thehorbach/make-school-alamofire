//
//  DisplayCell.swift
//  Trash Sorter
//
//  Created by Alex Dao on 6/24/16.
//  Copyright © 2016 Alex Dao. All rights reserved.
//

import UIKit

class DisplayCell: UITableViewCell {
    
    @IBOutlet weak var trashNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
