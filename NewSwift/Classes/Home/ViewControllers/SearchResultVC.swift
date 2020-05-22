//
//  SearchResultVCT.swift
//  NewSwift
//
//  Created by gail on 2019/5/22.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

enum SearchType : Int {
    case school = 100
    case coach = 101
    case regist = 102
}

class SearchResultVC: UITableViewController {
    
    var cityNumber:NSInteger?
    var searchtext = ""
    var currentPage = 1
    var page:Page?
    var searhType:SearchType?
    lazy var schoolList = [SchoolModel]()
    lazy var coachList = [CoachModel]()
    lazy var registArray = [RegistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        getHomeData()
        setUpFootReFresh()
        
        switch searhType {
        case .school?:
            tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "SCHOOL_CELL")
            self.title = "驾校"
            break
        case .coach?:
            tableView.register(UINib(nibName: "CoachListCell", bundle: nil), forCellReuseIdentifier: "CoachListCell")
            self.title = "教练"
            break
        default:
            tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "SCHOOL_CELL")
            self.title = "报名点"
            break
        }
    }
   
}
extension SearchResultVC {
    
    fileprivate func getHomeData() {
        switch searhType {
        case .school?:
            HomeNetTool.getSchoollistData(currentPage: currentPage, cityNumber: cityNumber, searchText: searchtext, Success: {[weak self] (page, array) in
                self?.page = page
                self?.schoolList.append(contentsOf: array)
                self?.tableView.reloadData()
                self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.schoolList.count == 0
                self?.tableView.mj_footer.endRefreshing()
            }) {[weak self] (error) in
                self?.tableView.mj_footer.isHidden = self?.schoolList.count == 0
                self?.tableView.mj_footer.endRefreshing()
            }
            break
        case .coach?:
            HomeNetTool.getCoachListData(currentPage: currentPage, cityNumber: cityNumber, searchText: searchtext, Success: {[weak self] (page, array) in
                self?.page = page
                self?.coachList.append(contentsOf: array)
                self?.tableView.reloadData()
                self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.coachList.count == 0
                self?.tableView.mj_footer.endRefreshing()
            }) {[weak self] (error) in
                self?.tableView.mj_footer.isHidden = self?.coachList.count == 0
                self?.tableView.mj_footer.endRefreshing()
            }
            break
        default:
            HomeNetTool.getRegSiteData(currentPage: currentPage, cityNumber: cityNumber, searchText: searchtext, Success: {[weak self] (page, array) in
                self?.page = page
                self?.registArray.append(contentsOf: array)
                self?.tableView.reloadData()
                self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.registArray.count == 0
                self?.tableView.mj_footer.endRefreshing()
            }) {[weak self] (error) in
                self?.tableView.mj_footer.isHidden = self?.registArray.count == 0
                self?.tableView.mj_footer.endRefreshing()
            }
            
           break
        }
    }
    
    
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.schoolList.count != 0 {
                self?.currentPage += 1
            }
            
            if self?.page?.currentPage==self?.page?.totalPage {
                
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
                self?.getHomeData()
            }
        })
    }
}
extension SearchResultVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searhType {
        case .school?:
            return schoolList.count
        case .coach?:
            return coachList.count
        default:
            return registArray.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searhType {
            
        case .school?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SCHOOL_CELL", for: indexPath) as! HomeTableViewCell
            cell.applyBtn.tag = 300
            cell.schoolModel = schoolList[indexPath.row]
            cell.selectionStyle = .none
            return cell
            
            
        case .coach?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoachListCell", for: indexPath) as! CoachListCell
            cell.model = self.coachList[indexPath.row]
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SCHOOL_CELL", for: indexPath) as! HomeTableViewCell
            cell.registModel = registArray[indexPath.row]
            cell.applyBtn.tag = 301
            cell.selectionStyle = .none
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let vc = DetailVC()
        switch searhType {
        case .school?:
            vc.schoolModel = schoolList[indexPath.row]
            vc.detailType = .school
        case .coach?:
            vc.coachModel = coachList[indexPath.row]
            vc.detailType = .coach
        default:
            vc.registModel = registArray[indexPath.row]
            vc.detailType = .regist
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
