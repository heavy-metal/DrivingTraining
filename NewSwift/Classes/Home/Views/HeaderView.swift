//
//  HeaderView.swift
//  NewSwift
//
//  Created by gail on 2017/12/15.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit
import SafariServices
class HeaderView: UIView {
    
    lazy var imagesURLStrings:[String] = [String]()
    lazy var titles:[String] = [String]()
    lazy var urlArray : [String] = [String]()

    lazy var containerView = { () -> UIScrollView in
        let containerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headViewHeight))
        addSubview(containerView)
        return containerView
    }()
    
    lazy var cycleScrollView : SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headViewHeight), delegate: self, placeholderImage: nil)
        cycleScrollView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView?.currentPageDotColor = UIColor.white
        return cycleScrollView!
    }()
    
    /// 传值
    var headerArray:[HeadInfo]? {
        
        didSet{
            guard let headerArray = headerArray else {return}
            titles.removeAll()
            urlArray.removeAll()
            imagesURLStrings.removeAll()
            for headInfo in headerArray {
                guard let InfoIcon = headInfo.InfoIcon else {return}
                imagesURLStrings.append(InfoIcon)
                titles.append(headInfo.InfoTitle ?? "")
                urlArray.append(headInfo.FileUrl ?? "")
            }
            cycleScrollView.imageURLStringsGroup = imagesURLStrings
            cycleScrollView.titlesGroup = titles
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetUpCycleScrollView()
    }
//    init(frame: CGRect ->()) {
//        <#statements#>
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func SetUpCycleScrollView() {
        backgroundColor = UIColor.groupTableViewBackground
        containerView.addSubview(cycleScrollView)
        containerView.contentSize = CGSize(width: width*CGFloat(imagesURLStrings.count), height: 0)
    }
}

// MARK: - 点击轮播图回调
extension HeaderView:SDCycleScrollViewDelegate {
        func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
            if urlArray.count==0 { return }

            let webVC = CZJWebViewController(urlString: urlArray[index])
//            let webVC = XWebViewController(urlString: urlArray[index])
            
            viewController().navigationController?.pushViewController(webVC, animated: true)
            
        }
    
}
