//
//  Networking.swift
//  FlickrSearch
//
//  Created by Jacob Banks on 2/26/24.
//

import Combine
import Foundation

struct Networking {

    static func requestImages(_ searchTerms: String) -> AnyPublisher<[ImageData], Error> {
        var urlComponents = URLComponents(string: "https://api.flickr.com/services/feeds/photos_public.gne")
        urlComponents?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]

        if !searchTerms.isEmpty {
            urlComponents?.queryItems?.append(URLQueryItem(name: "tags", value: searchTerms))
        }

        guard let url = urlComponents?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode)
                else { throw URLError(.badServerResponse) }
                return data
            }
            .decode(type: ImageList.self, decoder: JSONDecoder())
            .map(\.items)
            .eraseToAnyPublisher()
    }

}
