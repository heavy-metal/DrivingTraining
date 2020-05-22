//
//  TouchTableView.swift
//  NewSwift
//
//  Created by gail on 2018/1/3.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit

class TouchTableView: UITableView {

}
extension TouchTableView : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
