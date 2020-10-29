//
//  DisplayController.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

class DisplayController: UIViewController {
    
    /// 加载指示器
    lazy var indicatorView : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    /// 数据表
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .groupTableViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        self.view.addSubview(tableView)
        return tableView
    }()
    /// 处理器
    var presenter : DisplayPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        presenter = DisplayPresenter(vc: self)
        makeConstraints()
        addHistroyBtn()
        
    }
    /// 设置约束
    private func makeConstraints(){
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    /// 添加历史按钮
    private func addHistroyBtn(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History", style: .done, target: self, action: #selector(historyClicked))
    }

}
//MARK:按钮的点击事件
extension DisplayController{
    /// 历史按钮点击事件
    @objc private func historyClicked(){
        let vc = HistoryController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
