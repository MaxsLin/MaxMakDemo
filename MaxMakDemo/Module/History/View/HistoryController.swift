//
//  HistoryController.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

class HistoryController: UIViewController {
    /// 数据表
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .groupTableViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView)
        return tableView
    }()

    var presenter : HistoryPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HistoryPresenter(vc: self)
        makeConstraints()
        
    }
    /// 设置约束
    private func makeConstraints(){
        

        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }

    

}
