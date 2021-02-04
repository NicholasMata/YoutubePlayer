//
//  File.swift
//
//
//  Created by Nicholas Mata on 2/4/21.
//

import Foundation

public protocol YoutubePlayerDelegate: class {
    func youtubePlayer(_ videoPlayer: YoutubePlayerView, fired event: YoutubePlayerEvent)
}
