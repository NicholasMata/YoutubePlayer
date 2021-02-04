//
//  YoutubePlayerError.swift
//  YoutubePlayer
//
//  Created by Nicholas Mata on 2/4/21.
//

import Foundation

public enum YoutubePlayerError: String {
    /**
     The request contains an invalid parameter value. For example, this error occurs if you specify a video ID that does not have 11 characters, or if the video ID contains invalid characters, such as exclamation points or asterisks.
     */
    case invalidParameter = "2"
    /**
     The requested content cannot be played in an HTML5 player or another error related to the HTML5 player has occurred.
     */
    case html5Error = "5"
    /**
     The video requested was not found. This error occurs when a video has been removed (for any reason) or has been marked as private.
     */
    case videoNotFound = "100"
    /**
     The owner of the requested video does not allow it to be played in embedded players.
     */
    case ownerBlocked = "101"
    /**
     150 – This error is the same as 101. It's just a 101 error in disguise!

     https://developers.google.com/youtube/iframe_api_reference#Events
      */
    case ownerBlockedDisguised = "105"
}
