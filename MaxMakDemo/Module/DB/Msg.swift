//
//  Msg+CoreDataClass.swift
//  
//
//  Created by maxmak on 2020/6/6.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Msg)
public class Msg: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Msg> {
        return NSFetchRequest<Msg>(entityName: "Msg")
    }

    @NSManaged public var addtime: String
    @NSManaged public var response: String
}
