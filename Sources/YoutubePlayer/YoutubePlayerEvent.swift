//
//  YoutubePlayerEvent.swift
//  YoutubePlayer
//
//  Created by Nicholas Mata on 2/4/21.
//

import Foundation

public enum YoutubePlayerEvent {
    case iFrameReady
    /**
     This event fires whenever a player has finished loading and is ready to begin receiving API calls.
     
     Your application should implement this function if you want to automatically execute certain operations, such as playing the video or displaying information about the video, as soon as the player is ready.
     */
    case ready
    /**
     This event fires whenever the player's state changes. The data property of the event object that the API passes to your event listener function will specify an integer that corresponds to the new player state.
     
     Possible values are:
     - -1 (unstarted)
     - 0 (ended)
     - 1 (playing)
     - 2 (paused)
     - 3 (buffering)
     - 5 (video cued).
     
     When the player first loads a video, it will broadcast an unstarted (-1) event. When a video is cued and ready to play, the player will broadcast a video cued (5) event. In your code, you can specify the integer values or you can use one of cases available in `YoutubePlayerState`
     */
    case stateChanged(YoutubePlayerState)
    /**
     This event fires whenever the video playback quality changes.
     
     It might signal a change in the viewer's playback environment. See the YouTube Help Center for more information about factors that affect playback conditions or that might cause the event to fire.

     The data property value of the event object that the API passes to the event listener function will be a string that identifies the new playback quality. Possible values are:
     - small
     - medium
     - large
     - hd720
     - hd1080
     - highres
     
     In your code, you can specify the string values or you can use one of cases available in `YoutubePlaybackQuality`
     */
    case playbackQualityChanged(YoutubePlaybackQuality)
    /**
     This event fires whenever the video playback rate changes.
     
     For example, if you call the setPlaybackRate(suggestedRate) function, this event will fire if the playback rate actually changes. Your application should respond to the event and should not assume that the playback rate will automatically change when the setPlaybackRate(suggestedRate) function is called. Similarly, your code should not assume that the video playback rate will only change as a result of an explicit call to setPlaybackRate.

     The data property value of the event object that the API passes to the event listener function will be a number that identifies the new playback rate. The getAvailablePlaybackRates method returns a list of the valid playback rates for the currently cued or playing video.
     */
    case placybackRateChanged(Int)
    /**
     This event fires if an error occurs in the player.
     
     The API will pass an event object to the event listener function. That object's data property will specify an integer that identifies the type of error that occurred. Possible values are:
     - 2 – The request contains an invalid parameter value. For example, this error occurs if you specify a video ID that does not have 11 characters, or if the video ID contains invalid characters, such as exclamation points or asterisks.
     - 5 – The requested content cannot be played in an HTML5 player or another error related to the HTML5 player has occurred.
     - 100 – The video requested was not found. This error occurs when a video has been removed (for any reason) or has been marked as private.
     - 101 – The owner of the requested video does not allow it to be played in embedded players.
     - 150 – This error is the same as 101. It's just a 101 error in disguise!
     */
    case errorOccurred(YoutubePlayerError)
    /**
     This event is fired to indicate that the player has loaded (or unloaded) a module with exposed API methods.
     
     Your application can listen for this event and then poll the player to determine which options are exposed for the recently loaded module. Your application can then retrieve or update the existing settings for those options.
     */
    case apiChanged(String?)
    /**
     This event is called in case any of the other events can't fully parse an event or youtube api is changed.
     */
    case unknown(String, String?)
    init(eventName: String, data: String?) {
        switch eventName {
        case "iFrameReady":
            self = .iFrameReady
        case "ready":
            self = .ready
        case "stateChanged":
            if let stateValue = data, let state = YoutubePlayerState(rawValue: stateValue) {
                self = .stateChanged(state)
            } else {
                self = .unknown(eventName, data)
            }
        case "playbackQualityChanged":
            if let qualityValue = data, let quality = YoutubePlaybackQuality(rawValue: qualityValue) {
                self = .playbackQualityChanged(quality)
            } else {
                self = .unknown(eventName, data)
            }
        case "playbackRateChanged":
            if let rateValue = data, let rate = Int(rateValue) {
                self = .placybackRateChanged(rate)
            } else {
                self = .unknown(eventName, data)
            }
        case "errorOccurred":
            if let errorValue = data, let error = YoutubePlayerError(rawValue: errorValue) {
                self = .errorOccurred(error)
            } else {
                self = .unknown(eventName, data)
            }
        case "apiChanged":
            self = .apiChanged(data)
        default:
            self = .unknown(eventName, data)
        }
    }
}
