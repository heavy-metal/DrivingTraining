
//
//  ReplySuggestVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ReplySuggestVC: UITableViewController {
    
    lazy var titleArray = ["反馈时间","反馈类型","处理状态","主题内容","反馈内容","回复内容","处理时间"]
    lazy var typeArray = ["投诉","咨询","建议","求助","系统反馈"]
    
    var suggestModel:SuggestModel?
    
    lazy var contentArray = [suggestModel?.FeedbackTime,typeArray[suggestModel!.FeedbackType-1],suggestModel?.opState,suggestModel?.Title,suggestModel?.Content,suggestModel?.OpContent ?? "暂无",suggestModel?.OpTime ?? "暂无"]

    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.register(UINib(nibName: "ReplySuggestCell", bundle: nil), forCellReuseIdentifier: "ReplySuggestCell")
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplySuggestCell", for: indexPath) as! ReplySuggestCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.contentLabel.text = contentArray[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let str = contentArray[indexPath.row] else { return 0 }
        
        let strHeight = getTextHeigh(textStr: str)
        
        return strHeight > 50 ? strHeight + 30 : 60
    }

}
extension ReplySuggestVC {//计算label高度
    
    func getTextHeigh(textStr:String) -> CGFloat{
        
        return textStr.boundingRect(with: CGSize(width: SCREEN_WIDTH-106, height: 8000), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 14.0)], context: nil).height
        
    }
    
}
