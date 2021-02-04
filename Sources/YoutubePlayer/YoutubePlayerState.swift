//
//  YoutubePlayerState.swift
//  YoutubePlayer
//
//  Created by Nicholas Mata on 2/4/21.
//

import Foundation

public enum YoutubePlayerState: String {
    case unstarted = "-1"
    case ended = "0"
    case playing = "1"
    case paused = "2"
    case buffering = "3"
    case cued = "5"
}
