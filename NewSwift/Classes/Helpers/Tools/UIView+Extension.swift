//
//  UIView+Extension.swift
//  NewSwift
//
//  Created by gail on 2017/12/11.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

// MARK: - UIView快速修改frame
extension UIView {
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.origin.x = newVal
            self.frame = frame
        }
    }
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.origin.y = newVal
            self.frame = frame
        }
    }
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.size.width = newVal
            self.frame = frame
        }
    }
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.size.height = newVal
            self.frame = frame
        }
    }
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.size = newVal
            self.frame = frame
        }
    }
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newVal) {
            var center: CGPoint = self.center
            center.x = newVal
            self.center = center
        }
    }
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newVal) {
            var center: CGPoint = self.center
            center.y = newVal
            self.center = center
        }
    }
}

