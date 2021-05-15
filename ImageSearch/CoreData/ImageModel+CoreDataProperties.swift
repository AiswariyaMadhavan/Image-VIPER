//
//  ImageModel+CoreDataProperties.swift
//  
//
//  Created by Iswariya Madhavan on 15/05/21.
//
//

import Foundation
import CoreData


extension ImageModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageModel> {
        return NSFetchRequest<ImageModel>(entityName: "ImageModel")
    }

    @NSManaged public var id: Int16
    @NSManaged public var imageData: Data?

}
