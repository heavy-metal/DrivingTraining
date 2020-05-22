

//
//  StudentFindTimeVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/2.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import MWPhotoBrowser
class StudentFindTimeVC: UITableViewController {

    var subjectIndex:NSInteger?
    var page:Page?
    var currentPage = 1
    lazy var array = [StudyTimeModel]()
    lazy var photoArray = [MWPhoto]()
    var userId = ""
    var stuId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackground
        
        setUpHeaderReFresh()
        
        setUpFootReFresh()
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "StudentFindTimeCell", bundle: nil), forCellReuseIdentifier: "StudentFindTimeCell")
    }
    
}
extension StudentFindTimeVC  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentFindTimeCell", for: indexPath) as! StudentFindTimeCell
        cell.model = self.array[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.array[indexPath.row]
        photoArray.removeAll()
        photoArray.append(MWPhoto(url: URL(string: model.PhotoFile1)))
        photoArray.append(MWPhoto(url: URL(string: model.PhotoFile2)))
        photoArray.append(MWPhoto(url: URL(string: model.PhotoFile3)))
        let browser = MWPhotoBrowser(delegate: self)
        browser?.displayNavArrows = true
        browser?.alwaysShowControls = true
        self.navigationController?.pushViewController(browser!, animated: true)
    }
    
}

extension StudentFindTimeVC {
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.currentPage = 1
            self?.getHomeData(firstGet: true)
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.array.count != 0 {
                self?.currentPage += 1
            }
            
            if self?.page?.currentPage==self?.page?.totalPage {
                
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
                self?.getHomeData(firstGet: false)
            }
        })
        
    }
    
}
extension StudentFindTimeVC {
    func getHomeData (firstGet:Bool) {
        
        let stuid = stuId == "" ? userId : stuId
        HomeNetTool.getStudentStudyTimeData(currentPage: currentPage, subject: subjectIndex ?? 0, UserId: userId , stuId: stuid , Success: {[weak self] (page, array) in
            self?.page = page
            if firstGet == true {
                
                self?.array = array
                
            }else{
                self?.array.append(contentsOf: array)
            }
            self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.array.count == 0
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }) { [weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.array.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
}
extension StudentFindTimeVC : MWPhotoBrowserDelegate{
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photoArray.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < self.photoArray.count {
            return self.photoArray[NSInteger(index)]
        }
        return nil
    }
    

}
