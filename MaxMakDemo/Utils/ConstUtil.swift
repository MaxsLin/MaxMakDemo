//
//  ConstUtil.swift
//  CWChat
//
//  Created by maxmak on 2020/5/19.
//

import Foundation
import UIKit
internal struct ConstUtil{
    /// 屏幕的宽
    static let winWidth = UIScreen.main.bounds.size.width
    /// 屏幕的高
    static let winHeight = UIScreen.main.bounds.size.height
    /// 缩放大小
    static var winScale: CGFloat{
        if winWidth == 320 {
            return 0.853
        }
        if winWidth == 414{
            return 1.104
        }
        return 1
    }
    /// 文字缩放
    static func fontScale(fontSize:CGFloat)->CGFloat{
        return fontSize * ConstUtil.winScale
    }
}
