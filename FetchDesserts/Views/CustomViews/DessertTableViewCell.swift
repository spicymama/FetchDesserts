//
//  DessertTableViewCell.swift
//  FetchDesserts
//
//  Created by Gavin Woffinden on 4/24/22.
//

import UIKit

class DessertTableViewCell: UITableViewCell {

    @IBOutlet weak var dessertName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var dessert: Dessert? {
        didSet {
            dessertName.text = dessert?.name
        }
    }

}
