//
//  CustomScrollView.swift
//  InternalSystem
//
//  Created by gail on 2018/3/19.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {

}
extension CustomScrollView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.state == UIGestureRecognizerState.began && self.contentOffset.x == 0 {
            return true
        }
        return false
    }
}
