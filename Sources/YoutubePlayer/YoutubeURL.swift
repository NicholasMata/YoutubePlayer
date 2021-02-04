//
//  File.swift
//
//
//  Created by Nicholas Mata on 2/4/21.
//

import Foundation

public enum YoutubeURL {
    public static func videoId(for videoURL: URL) -> String? {
        if videoURL.pathComponents.count > 1, (videoURL.host?.hasSuffix("youtu.be"))! {
            return videoURL.pathComponents[1]
        } else if videoURL.pathComponents.contains("embed") {
            return videoURL.pathComponents.last
        }
        return videoURL.queryStringComponents()["v"] as? String
    }
}

internal extension URL {
    func queryStringComponents() -> [String: AnyObject] {
        var dict = [String: AnyObject]()

        // Check for query string
        if let query = self.query {
            // Loop through pairings (separated by &)
            for pair in query.components(separatedBy: "&") {
                // Pull key, val from from pair parts (separated by =) and set dict[key] = value
                let components = pair.components(separatedBy: "=")
                if components.count > 1 {
                    dict[components[0]] = components[1] as AnyObject?
                }
            }
        }

        return dict
    }
}
