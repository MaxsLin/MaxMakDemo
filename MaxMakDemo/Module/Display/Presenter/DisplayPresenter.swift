//
//  DisplayPresenter.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

class DisplayPresenter: NSObject {
    weak var vc : DisplayController?
    /// 数据源
    var dataArr = [DisplayModel]()
    /// 定时器
    lazy private var timer : DispatchSourceTimer = {
        /// DispatchQueue(label: DisplayPresenter.description(), attributes: DispatchQueue.Attributes.concurrent)
        /// 放在主线程中
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main)
        timer.schedule(deadline: DispatchTime.now() + 5, repeating: DispatchTimeInterval.seconds(5), leeway: DispatchTimeInterval.seconds(0))
        timer.setEventHandler(handler: {[weak self] in
            guard let strongSelf = self else{return}
            print(Thread.current)
            strongSelf.infoHttpRequest()
        })
        return timer
    }()
    init(vc : DisplayController) {
        self.vc = vc
        super.init()
        tableViewConfig()
        vc.tableView.reloadData()
        
        timer.resume()
        getLastDataArr()
    }
    /// 表的配置
    private func tableViewConfig(){
        /// 注册cell
        self.vc?.tableView.register(DisplayCell.self, forCellReuseIdentifier: DisplayCell.description())
        /// 设置代理
        self.vc?.tableView.delegate = self
        self.vc?.tableView.dataSource = self
    }
    /// 刷新cell
    private func refresh(cell : DisplayCell , model : DisplayModel){
        cell.nameLbl.text = "name：" + model.name
        cell.urlLbl.text  = "url：" + model.url
    }
}
//MARK:数据请求
extension DisplayPresenter{
    /// 获取数据库中最后一条数据
    private func getLastDataArr(){
        DBMsgHandle.shared.lastMsg { (msg) in
            print(msg.addtime)
            let response = msg.response
            if let data = response.data(using: .utf8){
                self.analysisData(data)
            }
        }
    }
    /// 网络请求
    private func infoHttpRequest(){
        let http = HttpRequestUtil(path: "https://api.github.com/", method: .get, onView: self.vc?.view)
        self.vc?.indicatorView.startAnimating()
        http.successClosure { (data) in
            self.analysisData(data)
        }
        http.completeClosure {
            self.vc?.indicatorView.stopAnimating()
        }
    }
    /// 解析数据
    private func analysisData(_ data : Data){
        /// 开启异步线程
        DispatchQueue.global().async {
            guard let object: Any = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) else{return}
            let response = String(data: data, encoding: String.Encoding.utf8) ?? ""
            print(response)
            /// 存入数据库
            DBMsgHandle.shared.insert(response: response)
            /// 解析数据
            if let dic = object as? [String : String]{
                var displayModels = [DisplayModel]()
                for (key , value) in dic {
                    let model = DisplayModel(name: key, url: value)
                    displayModels.append(model)
                }
                self.dataArr = displayModels
            }
            /// 在主线程中刷新
            DispatchQueue.main.async {
                self.vc?.tableView.reloadData()
                self.vc?.tableView.isHidden = false
            }
        }
    }
}
//MARK:表的代理
extension DisplayPresenter : UITableViewDelegate , UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataArr.count
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: DisplayCell.description()) as! DisplayCell
       let model = dataArr[indexPath.row]
       refresh(cell: cell, model: model)
       return cell
   }
}
