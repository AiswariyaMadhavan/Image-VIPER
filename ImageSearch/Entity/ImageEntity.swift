//
//  ImageEntity.swift
//  ImageSearch
//
//  Created by Iswariya Madhavan on 14/05/21.
//

import Foundation
struct ImageEntity: Decodable {
    var query: Query
    
}
struct Query: Decodable {
    var pages:Pages
}
struct Pages: Decodable {
    var pagesArray: [PageDecoderArray]
    //Dynamic coding keys implemented to parse the data
    struct codingKey: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKey.self)
        var tempPage = [PageDecoderArray]()
        for key in container.allKeys {
            let decodedObject = try container.decode(PageDecoderArray.self, forKey: codingKey(stringValue: key.stringValue)!)
            tempPage.append(decodedObject)
        }
        pagesArray = tempPage
    }
}
struct PageDecoderArray: Decodable {
    var pageidKey: String?
    var pageid: Int?
    var title: String?
    var thumbnail: ThumbNail?
    enum CodingKeys: CodingKey {
        case title
        case thumbnail
        case pageid
        case pageidKey
    }
    init(from decoder: Decoder) throws {

    let container = try decoder.container(keyedBy: CodingKeys.self)
        pageidKey = container.codingPath.first?.stringValue
        title = try container.decode(String.self, forKey: .title)
        thumbnail = try? container.decode(ThumbNail.self, forKey: .thumbnail)
        pageid = try container.decode(Int.self, forKey: .pageid)
    }
}

struct ThumbNail: Decodable {
    var source: String?
    var width: Int?
    var height: Int?
    
    enum CodingKeys: CodingKey {
        case source
        case width
        case height
    }
    init(from decoder: Decoder) throws {

    let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(String.self, forKey: .source)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }
}
