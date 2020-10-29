//
//  HistoryHeadView.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

class HistoryHeadView: UITableViewHeaderFooterView {
    let winScale = ConstUtil.winScale
    let fontScale = ConstUtil.fontScale
    /// 刷新时间
    lazy var timeLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: fontScale(12))
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        self.contentView.addSubview(lbl)
        return lbl
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didSetupConstraints{
            didSetupConstraints = true
            makeConstraints()
        }
    }
    private var didSetupConstraints = false
    /// 约束
    private func makeConstraints(){
        
        timeLbl.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant: 0).isActive = true
        timeLbl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        timeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        timeLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .groupTableViewBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
