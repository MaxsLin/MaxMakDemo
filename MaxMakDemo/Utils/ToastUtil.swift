//
//  ToastUtil.swift
//  CWChat
//
//  Created by maxmak on 2020/6/2.
//

import Foundation
import UIKit
struct ToastUtil {
    static func show(text:String,onView:UIView?){
        let fontScale = ConstUtil.fontScale
        let scale = ConstUtil.winScale
        
        //背景
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.8
        bgView.layer.cornerRadius = 8 * scale
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.clipsToBounds = true
        bgView.isUserInteractionEnabled = false
        let appWindow = UIApplication.shared.delegate?.window!
        
        if onView != nil {
            onView!.addSubview(bgView)
        }else{
            appWindow!.addSubview(bgView)
        }
        //标题
        let label = UILabel(frame: CGRect.zero)
        label.text = text
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontScale(14))
        bgView.addSubview(label)
        bgView.widthAnchor.constraint(equalTo: label.widthAnchor,constant: 20 * scale).isActive = true
        bgView.heightAnchor.constraint(equalTo: label.heightAnchor,constant: 30 * scale).isActive = true
        bgView.centerXAnchor.constraint(equalTo: bgView.superview!.centerXAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bgView.superview!.bottomAnchor,constant: -50 * scale).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 280 * scale).isActive = true
        label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            UIView.animate(withDuration: 0.4, animations: {
                bgView.alpha = 0
            }) { (isSuccess) in
                bgView.removeFromSuperview()
            }
        }
    }
    /*
    static func showLoading(text : String , onView : UIView?){
        
        let appWindow = UIApplication.shared.delegate?.window!
        if onView != nil {
            //onView!.addSubview(bgView)
        }else{
            //appWindow!.addSubview(bgView)
        }
        
    }
    static func hidenLoading(){
        
    }*/
}
