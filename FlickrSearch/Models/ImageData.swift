//
//  ImageData.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/26/24.
//

import Foundation
import SwiftSoup
import SwiftUI

struct ImageData: Codable, Identifiable {

    let id: UUID = UUID()

    let title: String
    let media: Media
    let description: String
    let published: String
    let author: String
    let tags: String

    init(
        title: String,
        media: Media,
        description: String,
        published: String,
        author: String,
        tags: String
    ) {
        self.title = title
        self.media = media
        self.description = description
        self.published = published
        self.author = author
        self.tags = tags
    }

    private enum CodingKeys: String, CodingKey {
        case title, media, description, published, author, tags
    }

    var publishedDate: String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: published)

        guard let date else { return "" }

        formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    var username: String {
        return author.slice(from: "(\"", to: "\")") ?? "Unknown User"
    }

    var formattedDescription: String? {
        do {
            let doc: Document = try SwiftSoup.parse(description)
            let elements = try doc.body()?.getElementsByTag("p")
            guard let elements, elements.count > 2 else { return nil }
            return try elements.last()?.text()
        } catch {
            print(error)
            return nil
        }
    }

    var dimensions: String? {
        do {
            let doc: Document = try SwiftSoup.parse(description)

            guard let img = try doc.getElementsByTag("img").first() else { return nil }

            let width = try img.attr("width")
            let height = try img.attr("height")

            return "\(width)x\(height)"
        } catch {
            print(error)
            return nil
        }
    }

}

struct Media: Codable {
    let m: String
    var url: URL? { URL(string: m) }
}

extension ImageData {

    static func mock() -> Self {
        self.init(
            title: "Test Image",
            media: .init(m: "https://live.staticflickr.com/65535/53542477887_c910f8667e_m.jpg"),
            description: "<p><a href=\"https://www.flickr.com/people/mdgovpics/\">MDGovpics</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/mdgovpics/53554331736/\" title=\"International High School Exchange Group\"><img src=\"https://live.staticflickr.com/65535/53554331736_6283dd1217_m.jpg\" width=\"240\" height=\"160\" alt=\"International High School Exchange Group\" /></a></p> <p>Lt. Governor Miller and Governor Moore Meet with the ASSE International High School Exchange Group by Patrick Siebert, Joe Andrucyk at 100 State Circle, Annapolis, MD 21401</p>",
            published: "2024-02-21T16:43:43Z",
            author: "nobody@flickr.com (\"samdjoyce\")",
            tags: ""
        )
    }

}
