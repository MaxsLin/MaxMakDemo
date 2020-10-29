//
//  DBChatHandle.swift
//  CWChat
//
//  Created by maxmak on 2020/5/22.
//

import Foundation
import CoreData


extension Msg {
    /// 获取数据库实体对象
    class func insertRequest(into context: NSManagedObjectContext) -> Msg {
        NSEntityDescription.insertNewObject(forEntityName: "Msg", into: context) as! Msg
    }
    public override func didTurnIntoFault() {
        
    }
}

public class  DBMsgHandle: NSObject {
    let context : NSManagedObjectContext
    let queue : OperationQueue
    public static let shared = DBMsgHandle()

    override init() {
        let baseHandle = DBBaseHandle.shared
        self.context = baseHandle.context
        self.queue = baseHandle.queue
        super.init()
        
    }
    
    /// 分页查询数据库
    /// - Parameters:
    ///   - sessionId: 会话ID
    ///   - addtime: 消息添加的时间
    ///   - serverMsgId: 服务器的消息ID 用来排序
    ///   - size: 分页大小
    ///   - closure: 返回Msg 数组
    public func asyAllSelect(_ closure : @escaping ( ([Msg]) -> Void) ){
        queue.addOperation {[weak self] in
            guard let strongSelf = self else{return}
            let request : NSFetchRequest<Msg> = Msg.fetchRequest()
            let sort = NSSortDescriptor(key: "addtime", ascending: false)
            request.sortDescriptors = [sort]
            do{
                let msgs = try strongSelf.context.fetch(request)
                DispatchQueue.main.sync {
                    closure(msgs)
                }
            }catch{
                print(error)
            }
        }
    }
    /// 查询最后一条消息
    func lastMsg (_ closure : @escaping ( (Msg) -> Void) ){
        queue.addOperation {[weak self] in
            guard let strongSelf = self else{return}
            let request : NSFetchRequest<Msg> = Msg.fetchRequest()
            let sort = NSSortDescriptor(key: "addtime", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchLimit = 1
            do{
                let msgs = try strongSelf.context.fetch(request)
                if !msgs.isEmpty{
                    closure(msgs.first!)
                }
            }catch{
                print(error)
            }
        }
    }
}
//MARK:离线数据处理
extension DBMsgHandle{
    /// 插入离线数据
    func insert(response : String){
        queue.addOperation {[weak self] in
            guard let strongSelf = self else{return}
            let msg = Msg.insertRequest(into: strongSelf.context)
            strongSelf.migration(response: response, dbMsgModel: msg)
            do{
                try strongSelf.context.save()
                
                
            }catch{
                print(error)
            }
        }
    }
    private func migration(response : String , dbMsgModel : Msg){
        //时间戳
        let date = Date(timeIntervalSinceNow: 0)
        let timeStamp = "\(date.timeIntervalSince1970)"
        dbMsgModel.addtime = timeStamp
        dbMsgModel.response = response
    }

    
    
    
}
