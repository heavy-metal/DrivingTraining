//
//  TeachingStatisticsView.swift
//  NewSwift
//
//  Created by gail on 2019/8/12.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class TeachingStatisticsView: UIView {

    @IBOutlet weak var timeBtn: ApplyBtn!
    @IBOutlet weak var lichengBtn: ApplyBtn!
    @IBOutlet weak var studentCountBtn: ApplyBtn!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeBtn.setTitle("总学时:0.0", for: .normal)
        lichengBtn.setTitle("总里程:0.0", for: .normal)
        studentCountBtn.setTitle("学员数:0", for: .normal)
        
        timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        lichengBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        studentCountBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
