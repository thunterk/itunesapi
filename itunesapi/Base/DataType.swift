//
//  DataType.swift
//  itunesapi
//
//  Created by sunhaeng Heo on 2018. 5. 29..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import Foundation

// MARK: - List Data
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

// MARK: - App Detail Data

struct DetailData: Codable {
    var resultCount: Int
    var results: [AppData]
    
    static func parse(_ data: Data) -> AppData? {
        do {
            let detail = try JSONDecoder().decode(DetailData.self, from: data)
            
            guard detail.resultCount == detail.results.count && detail.resultCount > 0 else {
                return nil
            }
            
            return detail.results[0]
        } catch {
            return nil
        }
    }
}

struct AppData: Codable {
    var screenshotUrls: [String]
    var description: String
    var averageUserRating: Float
    var userRatingCount: Int
    
    var version: String
    var currentVersionReleaseDate: String
    var releaseNotes: String?
    var trackName: String
    var trackContentRating: String
    var genres: [String]
    
    var fileSizeBytes: String
    var sellerUrl: String?
    var sellerName: String
    var minimumOsVersion: String
    var artistName: String
}

