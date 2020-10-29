

import UIKit
import CoreData
class DBBaseHandle: NSObject {
    
    /// 数据库路径
    static let dbPath : URL = {
        let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        let appPath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!.appendingPathComponent("Demo")
        let dbPath = appPath.appendingPathComponent("DataBase")
        return dbPath
    }()
    /// 操作数据库的串行队列
    lazy var queue : OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.name = "DBMsgHandleOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    let context : NSManagedObjectContext
    /// 数据库名称
    static let dbName = "Demo"
    //是否存在数据库
    var isExsitDb : Bool{
        get{
            let dbPath = DBBaseHandle.dbPath.appendingPathComponent(DBBaseHandle.dbName + ".db")
            return FileManager.default.fileExists(atPath: dbPath.path)
        }
    }
    static var shared = DBBaseHandle()
    override init() {
        let bundle = Bundle(for: DBBaseHandle.self)
        let momdPath = bundle.path(forResource: "DBModel", ofType: "momd")
        //加载模型文件
        let url = URL(fileURLWithPath: momdPath!)
        //let url = URL(string: momdPath!)!
        let model = NSManagedObjectModel(contentsOf: url)!
        //let container = NSPersistentContainer(name: "DBModel", managedObjectModel: model)
        //创建数据库
        let store = NSPersistentStoreCoordinator(managedObjectModel: model)
        let dbPath = DBBaseHandle.dbPath
        if !FileManager.default.fileExists(atPath: dbPath.path){
            //创建一个文件夹
            do{
                try FileManager.default.createDirectory(atPath: dbPath.path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("数据库路径成功")
            }
        }
        let db = DBBaseHandle.dbPath.appendingPathComponent(DBBaseHandle.dbName + ".db") //+ "/" + clsName! + ".db"
        print("数据库地址 = " + db.path)
        var dic = [AnyHashable : Any]()
        dic[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(value: true)
        dic[NSInferMappingModelAutomaticallyOption] = NSNumber(value: true)
//        container.loadPersistentStores(completionHandler: <#T##(NSPersistentStoreDescription, Error?) -> Void#>)
        do{
            try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URL(fileURLWithPath: db.path), options: dic)
            print("数据库创建成功")
            
        }catch{
            print("数据库创建成功异常")
        }
        self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        self.context.persistentStoreCoordinator = store
        super.init()
        
        
    }
}
