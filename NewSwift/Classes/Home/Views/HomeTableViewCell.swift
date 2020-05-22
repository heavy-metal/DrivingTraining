//
//  HomeTableViewCell.swift
//  NewSwift
//
//  Created by gail on 2017/12/19.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var applyBtn: ApplyBtn!
    @IBOutlet weak var timeLabel: UILabel!
    
    var schoolModel:SchoolModel? {
        didSet{
            mainTitleLabel.text = schoolModel?.ShortName
            subtitleLabel.text = schoolModel?.District
            icon.sd_setImage(with: URL(string: schoolModel?.SchImage ?? ""))
        }
    }
    var registModel:RegistModel? {
        didSet{
            mainTitleLabel.text = registModel?.SchoolName
            subtitleLabel.text = registModel?.District
            icon.sd_setImage(with: URL(string: registModel?.RegSiteImage ?? ""))
        }
    }
    var publicModel:PublicModel? {
        didSet{
            mainTitleLabel.text = publicModel?.InfoTitle
            subtitleLabel.text = publicModel?.InfoFrom
            icon.sd_setImage(with: URL(string: publicModel?.InfoIcon ?? ""))
            applyBtn.isHidden = true
            timeLabel.text = publicModel?.PublishTime
            
        }
    }
    var checkCarModel:CheckCarModel? {
        didSet{
            mainTitleLabel.text = checkCarModel?.LicNum
            subtitleLabel.text = checkCarModel?.SyncState
            icon.sd_setImage(with: URL(string: checkCarModel?.CarImage ?? ""))
            applyBtn.isHidden = true
            timeLabel.text = "购买于:\(checkCarModel?.BuyDate ?? "")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            
            newFrame.origin.x += LINE_SPACE
            newFrame.size.width -= LINE_SPACE*2
//            newFrame.origin.y += LINE_SPACE
            newFrame.size.height -= LINE_SPACE
            super.frame = newFrame
        }
    }
    
    @IBAction func applyBtnClick(_ sender: ApplyBtn) {
        
        let vc = ApplyViewController()
        if sender.tag == 300 {
            vc.insID = schoolModel?.InsId ?? ""
            vc.schoolName = schoolModel?.ShortName ?? ""
        }else if sender.tag == 301 {
            vc.insID = registModel?.InsId ?? ""
            vc.schoolName = registModel?.SchoolName ?? ""
            vc.registName = registModel?.RegSiteName ?? ""
            vc.registId = registModel?.RegSiteId ?? ""
        }
        
        self.viewController().navigationController?.pushViewController(vc, animated: true)
    }
}
