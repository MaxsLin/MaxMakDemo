//
//  HistoryPresenter.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

class HistoryPresenter: NSObject {
    weak var vc : HistoryController?
    /// 数据源
    var dataArr = [(addtime : String , responses: [DisplayModel])]()
    init(vc : HistoryController) {
        self.vc = vc
        super.init()
        tableViewConfig()
        loadAllInfo()
        
    }
    /// 表的配置
    private func tableViewConfig(){
        /// 注册cell
        self.vc?.tableView.register(DisplayCell.self, forCellReuseIdentifier: DisplayCell.description())
        /// 注册头部信息
        self.vc?.tableView.register(HistoryHeadView.self, forHeaderFooterViewReuseIdentifier: HistoryHeadView.description())
        /// 设置代理
        self.vc?.tableView.delegate = self
        self.vc?.tableView.dataSource = self
    }
    /// 刷新cell
    private func refresh(cell : DisplayCell , model : DisplayModel){
        cell.nameLbl.text = "name：" + model.name
        cell.urlLbl.text  = "url：" + model.url
    }
    /// 刷新头部
    private func refresh(head : HistoryHeadView , addtime : String){
        let date = Date(timeIntervalSince1970: TimeInterval(addtime) ?? 0)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        
        
        head.timeLbl.text = dformatter.string(from: date)
    }
}
//MARK:数据请求
extension HistoryPresenter{
    /// 从数据库中获取所有的信息
    private func loadAllInfo(){
        DBMsgHandle.shared.asyAllSelect { (msgs) in
            DispatchQueue.global().async {
                for msg in msgs{
                    let addtime = msg.addtime
                    guard let reponseData = msg.response.data(using: .utf8) else{return}
                    guard let object: Any = try? JSONSerialization.jsonObject(with: reponseData, options: JSONSerialization.ReadingOptions.mutableLeaves) else{return}
                    /// 解析数据
                    if let dic = object as? [String : String]{
                        var displayModels = [DisplayModel]()
                        for (key , value) in dic {
                            let model = DisplayModel(name: key, url: value)
                            displayModels.append(model)
                        }
                        self.dataArr.append((addtime: addtime, responses: displayModels))
                        /// 回到主线程
                        DispatchQueue.main.async {
                            self.vc?.tableView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
}
//MARK:表的代理
extension HistoryPresenter : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let responses = dataArr[section].responses
        return responses.count
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayCell.description()) as! DisplayCell
        let model = dataArr[indexPath.section].responses[indexPath.row]
        refresh(cell: cell, model: model)
        return cell
   }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryHeadView.description()) as! HistoryHeadView
        refresh(head: headView , addtime: self.dataArr[section].addtime)
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * ConstUtil.winScale
    }
}
