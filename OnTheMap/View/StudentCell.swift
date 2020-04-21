//
//  StudentCell.swift
//  OnTheMap
//
//  Created by Jan Gundorf on 16/04/2020.
//  Copyright © 2020 Jan Gundorf. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
        
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var imageURL: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
