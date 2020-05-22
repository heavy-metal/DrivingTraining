//
//  CZJWebViewController.swift
//  NewSwift
//
//  Created by gail on 2017/12/20.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit
import WebKit
class CZJWebViewController: UIViewController {
    
    lazy var web : WKWebView = {
       var web = WKWebView(frame: CGRect(x: 0, y: NavBarHeight, width: SCREEN_WIDTH , height: SCREEN_HEIGHT-NavBarHeight))
//        web.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        web.scrollView.bounces = false
        web.navigationDelegate = self
       return web
    }()
    
    lazy var progressView = { () -> UIProgressView in
       var progressView = UIProgressView(frame: CGRect(x: 0, y: NavBarHeight, width: SCREEN_WIDTH, height: 2))
        progressView.setProgress(0.9, animated: true)
        progressView.progressTintColor = GlobalColor
        progressView.trackTintColor = UIColor.white
        progressView.backgroundColor = UIColor.clear
        return progressView
    }()
    
    lazy var backButton = UIButton(directionType: .left, target: self, action: #selector(backBtnClick), ImgName: "subBack.png")
    
    lazy var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(web)
        
        view.addSubview(progressView)
    
        web.load(URLRequest(url: NSURL(string: self.url)! as URL))

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadBtnClick))
        ///监听进度
       
    }
    init(urlString:String) {
        super.init(nibName: nil, bundle: nil)
        
        self.url = urlString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
//        web.removeObserver(self, forKeyPath: "title")
        web.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}
extension CZJWebViewController {
    
    /// 只要观察对象属性有新值就会调用
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        self.navigationItem.title = web.title
        progressView.progress = Float(web.estimatedProgress)
        progressView.isHidden = progressView.progress==1.0
    }
}
// MARK: - BtnClick
extension CZJWebViewController : WKNavigationDelegate  {
     @objc fileprivate func reloadBtnClick () {
        web.reload()
    }
    @objc fileprivate func backBtnClick () {
        
        navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //修改字体大小
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'", completionHandler: nil)
//        webView.evaluateJavaScript("document.getElementById('title').style.display='none'", completionHandler: nil)//隐藏网页title
    }
}
