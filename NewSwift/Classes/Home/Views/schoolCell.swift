//
//  schoolCell.swift
//  NewSwift
//
//  Created by gail on 2017/12/25.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class schoolCell: UICollectionViewCell {

    @IBOutlet weak var schoolicon: UIImageView!
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
        
    }

}
