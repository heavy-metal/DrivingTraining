//
//  CheckStudentVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/6.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

enum CheckStudentType {
    
    case studentList
    case didAttention
    
    case SchoolCheckCoach
    case checkCar
}

class CheckStudentVC: UITableViewController {
    
    var checkType:CheckStudentType = .studentList
    
    lazy var coachList = [CoachModel]()
    
    lazy var searchRequirementArray = ["姓名","手机号","证件号"]
    
    lazy var searchController:UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.hidesNavigationBarDuringPresentation = false//禁止向上移动
        let searchBar = searchController.searchBar
        searchBar.placeholder = "搜索"
        searchBar.sizeToFit()
        searchBar.delegate = self
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        searchField.tintColor = GlobalColor
        searchField.font = UIFont.systemFont(ofSize: 15)
        let searchFieldBackgroudView = searchField.subviews.first
        searchFieldBackgroudView?.backgroundColor = UIColor.white
        searchFieldBackgroudView?.layer.cornerRadius = 15
        searchFieldBackgroudView?.layer.masksToBounds = true
//        searchBar.setValue("取消", forKey: "_cancelButtonText")
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = UIColor.white
        
        searchBar.scopeButtonTitles = ["姓名","手机号","证件号"]
        searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedStringKey.foregroundColor.rawValue:UIColor.white,NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 15)], for: .normal)

        searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedStringKey.foregroundColor.rawValue:UIColor.darkGray,NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 15)], for: .selected)
        searchBar.showsScopeBar = false
        return searchController
    }()
    
    lazy var requirementBtn:UIButton = {
        var btn = UIButton(imageName: "jiantou")
        btn.setTitle("姓名", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 70, height: 20)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(searchRequirement), for: .touchUpInside)
        return btn
    }()
    
    var currentPage = 1
    var page:Page?
    lazy var array = [CheckStudentModel]()
    lazy var checkCarArray = [CheckCarModel]()
    var searchText = ""
    var loginModel:LoginModel?
    var studentID = ""
    
    var index:NSInteger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            
            navigationItem.titleView = searchController.searchBar
            searchController.searchBar.scopeButtonTitles = nil
            searchController.searchBar.showsCancelButton = false
            searchController.searchBar.searchTextField.backgroundColor = UIColor.white
            searchController.searchBar.searchTextField.tintColor = GlobalColor
            searchController.hidesNavigationBarDuringPresentation = false//禁止向上移动
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: requirementBtn)

//            tableView.tableHeaderView = searchController.searchBar
        }else if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            
        }
        switch checkType {
            case .studentList:
                navigationItem.title = "学员名单"
                getStudentAtId()//获取关注学员Id
                tableView.register(UINib(nibName: "CheckStudentListCell", bundle: nil), forCellReuseIdentifier: "CheckStudentListCell")
            case .SchoolCheckCoach:
                navigationItem.title = "教练名单"
                tableView.register(UINib(nibName: "CoachListCell", bundle: nil), forCellReuseIdentifier: "CoachListCell")
            case .didAttention:
                navigationItem.title = "已关注学员"
                tableView.register(UINib(nibName: "CheckStudentListCell", bundle: nil), forCellReuseIdentifier: "CheckStudentListCell")
            default:
                navigationItem.title = "车辆名单"
                searchController.searchBar.scopeButtonTitles = nil
                tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "public_CELL")
        }
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        
        setUpHeaderReFresh()
        
        setUpFootReFresh()
        
        view.backgroundColor = grayBackColor
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch checkType {
        case .studentList:
             return array.count
        case .SchoolCheckCoach:
            return coachList.count
        case .didAttention:
            return array.count
        default:
           return checkCarArray.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if checkType == .SchoolCheckCoach {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoachListCell", for: indexPath) as! CoachListCell
            let model = coachList[indexPath.row]
            cell.applyBtn.setTitle("车型:\(model.TeachPermitted)", for: .normal)
            cell.applyBtn.isEnabled = false
            cell.model = model
            return cell
        }
        
        if checkType == .checkCar {
            let cell = tableView.dequeueReusableCell(withIdentifier: "public_CELL", for: indexPath) as! HomeTableViewCell
            cell.checkCarModel = checkCarArray[indexPath.row]
            return cell
        }
        
        let model = array[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckStudentListCell", for: indexPath) as! CheckStudentListCell
        cell.checkType = checkType
        cell.studentId = studentID
        cell.model = model
        cell.attentionBtn.tag = indexPath.row + 300
        cell.attentionBtn.addTarget(self, action: #selector(attentionBtnClick), for: .touchUpInside)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkType == .SchoolCheckCoach {

            let vc = UserMessageVC()
            let coachModel = coachList[indexPath.row]
            vc.coachModel = coachModel
            vc.isSchoolCheckCoach = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        if checkType == .checkCar {
            let vc = UserMessageVC()
            let model = checkCarArray[indexPath.row]
            vc.checkCarModel = model
            vc.isCheckCar = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let model = array[indexPath.row]
        let vc = CommonPageViewController()
        
        let messageVC = UserMessageVC()
        messageVC.userId = loginModel?.userId
        messageVC.stuId = model.StuId
        messageVC.loginType = .student
        
        let findTimeVC = FindStuyTimeViewController()
        findTimeVC.userId = loginModel?.userId ?? ""
        findTimeVC.stuId = model.StuId
        
        let stateVC = StateStudyVC()
        stateVC.userId = loginModel?.userId ?? ""
        stateVC.stuId = model.StuId
        
        vc.titles = ["基本信息","学时查询","学习进度"]
        vc.vcArray = [messageVC,findTimeVC,stateVC]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
extension CheckStudentVC:UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchController.searchBar.showsScopeBar = true
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        currentPage = 1
        searchText = ""
        getData(firstGet: true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currentPage = 1
        getData(firstGet: true)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if #available (iOS 13.0, *) {
            searchBarSearchButtonClicked(searchBar)
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available (iOS 13.0, *) {self.searchController.searchBar.resignFirstResponder()}
    }
    
}

extension CheckStudentVC {
    
    func getData(firstGet:Bool) {
        
        
        if #available(iOS 13.0, *) {
            index = searchRequirementArray.index(of: requirementBtn.titleLabel!.text!) ?? 0
        }else {
            index = self.searchController.searchBar.selectedScopeButtonIndex
        }
        
        switch checkType {
            
            case .studentList:
                HomeNetTool.checkStudentList(currentPage: currentPage, index: index, searchText: searchText, UserId: loginModel?.userId ?? "", Success: {[weak self] (page, array) in
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
                }) {[weak self] (error) in
                    self?.tableView.mj_footer.isHidden = self?.array.count == 0
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }
            break
            
            case .didAttention:
                
                HomeNetTool.checkAttensionList(currentPage: currentPage, index: index, searchText: searchText, UserId: loginModel?.userId ?? "", Success: {[weak self] (page, array) in
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
                }) {[weak self] (error) in
                    self?.tableView.mj_footer.isHidden = self?.array.count == 0
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }
            break
            
            case .SchoolCheckCoach:
                
                HomeNetTool.checkCoachList(currentPage: currentPage, index: index, searchText: searchText, UserId: loginModel?.userId ?? "", Success: {[weak self] (page, array) in
                    self?.page = page
                    if firstGet == true {
                        self?.coachList = array
                    }else{
                        self?.coachList.append(contentsOf: array)
                    }
                    self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.coachList.count == 0
                    self?.tableView.reloadData()
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }) {[weak self] (error) in
                    self?.tableView.mj_footer.isHidden = self?.coachList.count == 0
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }
            break
            
            case .checkCar:
                HomeNetTool.searchCarList(currentPage: currentPage, searchText: searchText, UserId: loginModel?.userId ?? "", Success: {[weak self] (page, array) in
                    self?.page = page
                    if firstGet == true {
                        self?.checkCarArray = array
                    }else{
                        self?.checkCarArray.append(contentsOf: array)
                    }
                    self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.checkCarArray.count == 0
                    self?.tableView.reloadData()
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }) {[weak self] (error) in
                    self?.tableView.mj_footer.isHidden = self?.checkCarArray.count == 0
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }
            break
        }
        
    }
    func getStudentAtId(){//获取关注学员Id
        HomeNetTool.GetStudentAtId(UserId: loginModel?.userId ?? "") {[weak self] (str) in
            self?.studentID = str
        }
    }
}


extension CheckStudentVC {
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.currentPage = 1
            self?.getData(firstGet: true)
            self?.getStudentAtId()
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.checkType == .SchoolCheckCoach {
                if self?.coachList.count != 0 {
                    self?.currentPage += 1
                }
            }else if self?.checkType == .checkCar{
                if self?.checkCarArray.count != 0 {
                    self?.currentPage += 1
                }
            }else {
                if self?.array.count != 0 {
                    self?.currentPage += 1
                }
            }
            
            if self?.page?.currentPage==self?.page?.totalPage {
                
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
                self?.getData(firstGet: false)
            }
        })
    }
    
    @objc func attentionBtnClick (btn:UIButton) {
        let model = array[btn.tag-300]
        if checkType == .studentList {//添加关注
            HomeNetTool.StudentAtAdd(UserId: loginModel?.userId ?? "", stuID: model.StuId) {[weak self] in
                btn.setTitle("已关注", for: .normal)
                self?.studentID.append(model.StuId)
                self?.tableView.reloadData()
            }
        }else {//取消关注
            HomeNetTool.studentAtDel(UserId: loginModel?.userId ?? "", stuID: model.StuId) {[weak self] in
                self?.array.remove(at: btn.tag-300)
                self?.tableView.deleteRows(at: [IndexPath(row: btn.tag-300, section: 0)], with: .left)
                self?.tableView.reloadData()
            }
        }
    }
    @objc func searchRequirement () {
        BRStringPickerView.showStringPicker(withTitle: "请选择搜索条件", dataSource: searchRequirementArray, defaultSelValue: nil, isAutoSelect: false) {[weak self] (str) in
            self?.requirementBtn.setTitle((str as! String), for: .normal)
            self?.index = self?.searchRequirementArray.index(of: str as! String)
        }
    }
}
