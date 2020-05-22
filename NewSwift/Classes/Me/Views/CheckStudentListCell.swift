//
//  CheckStudentListCell.swift
//  NewSwift
//
//  Created by gail on 2019/8/7.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class CheckStudentListCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sub_TitleLabel: UILabel!
    @IBOutlet weak var attentionBtn: ApplyBtn!
    
    var checkType:CheckStudentType?
    
    var studentId = ""
    
    var model:CheckStudentModel? {
        didSet{
            icon.sd_setImage(with: URL(string: (model?.StuImage)!))
            titleLabel.text = model?.Name
            sub_TitleLabel.text = model?.SchoolName
            
            if checkType == .studentList {
                attentionBtn.setTitle(studentId.contains(model?.StuId ?? "") ? "已关注" : "+ 关注", for: .normal)
                attentionBtn.isEnabled = !studentId.contains(model?.StuId ?? "")
            }else{
                attentionBtn.setTitle("取关", for: .normal)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        attentionBtn.setTitle("+ 关注", for: .normal)
        icon.layer.cornerRadius = icon.width/2
        icon.layer.masksToBounds = true
        icon.contentMode = .scaleAspectFill
    }

//    @IBAction func AttentionClick(_ sender: ApplyBtn) {
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.setDefaultAnimationType(.native)
//        SVProgressHUD.show()
//
//        StudentAtAdd()
//    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.x += LINE_SPACE
            newFrame.size.width -= LINE_SPACE*2
            newFrame.origin.y += LINE_SPACE
            newFrame.size.height -= LINE_SPACE
            super.frame = newFrame
        }
    }
//    func StudentAtAdd(){//添加关注学员
//        HomeNetTool.StudentAtAdd(UserId: userId, stuID: model?.StuId ?? "") {[weak self] in
//            self?.attentionBtn.setTitle("已关注", for: .normal)
//        }
//    }
//    func studentAtDel(){
//
//    }
    
}
