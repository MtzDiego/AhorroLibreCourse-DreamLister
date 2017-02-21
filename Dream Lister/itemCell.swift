//
//  itemCell.swift
//  Dream Lister
//
//  Created by Macbook on 2/20/17.
//  Copyright © 2017 ahorro libre. All rights reserved.
//

import UIKit

class itemCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item){
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        
    }

}
