//
//  PlacesListTableViewCell.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 17.06.2020.
//

import UIKit

class PlacesListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
