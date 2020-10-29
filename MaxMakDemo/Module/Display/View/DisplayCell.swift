//
//  DisplayCell.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

class DisplayCell: UITableViewCell {
    let winScale = ConstUtil.winScale
    let fontScale = ConstUtil.fontScale
    /// 名字标签
    lazy var nameLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: fontScale(12))
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lbl)
        return lbl
    }()
    /// url值标签
    lazy var urlLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: fontScale(14))
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        self.contentView.addSubview(lbl)
        return lbl
    }()
    /// 约束
    private func makeConstraints(){
        nameLbl.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10 * winScale).isActive = true
        nameLbl.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10 * winScale).isActive = true
        nameLbl.heightAnchor.constraint(equalToConstant: 20 * winScale).isActive = true
        nameLbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8 * winScale).isActive = true
        
        urlLbl.leftAnchor.constraint(equalTo: nameLbl.leftAnchor, constant: 0).isActive = true
        urlLbl.rightAnchor.constraint(equalTo: nameLbl.rightAnchor, constant: 0).isActive = true
        urlLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 8).isActive = true
        urlLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8 * winScale).isActive = true
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
