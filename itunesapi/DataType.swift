//
//  DataType.swift
//  itunesapi
//
//  Created by sunhaeng Heo on 2018. 5. 29..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import Foundation

struct FeedData: Codable {
    var feed: ListData
    
    static func parse(_ data: Data) -> ListData? {
        do {
            let feed = try JSONDecoder().decode(FeedData.self, from: data)
            return feed.feed
        } catch {
            return nil
        }
    }
}

struct ListData: Codable {
    var title: ImData
    var entry: [EntryData]
    
    enum CodingKeys: String, CodingKey {
        case title, entry
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        title = try values.decode(ImData.self, forKey: .title)
//        entry = try values.decode([EntryData].self, forKey: .entry)
//    }
    
}

struct EntryData: Codable {
    var id: ImData
    var name: ImData
    var category: ImData
    var image: [ImData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "im:name"
        case category
        case image = "im:image"
    }
}

struct ImData: Codable {
    var label: String
    var attributes: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case label, attributes
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = (try? values.decode(String.self, forKey: .label)) ?? ""
        attributes = try? values.decode([String: String].self, forKey: .attributes)
    }
}
