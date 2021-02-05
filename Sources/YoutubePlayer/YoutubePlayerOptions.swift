//
//  YoutubePlayerOptions.swift
//  YoutubePlayer
//
//  Created by Nicholas Mata on 2/4/21.
//

import Foundation
import UIKit

public enum YoutubeParameterBool: String, Codable {
    case `true` = "1"
    case `false` = "0"
}

/// This class represents the options that the iframe api is able to take in.
/// https://developers.google.com/youtube/iframe_api_reference
public class YoutubePlayerOptions: Encodable {
    typealias Events = [String: String]
    /// The YouTube video ID that identifies the video that the player will load
    /// If playlist is allow to be ignored
    var videoId: String?
    /// The width of the html video player
    /// Shouldn't need to change this in typical cases.
    let width: String = "100%"
    /// The height of the html video player
    /// Shouldn't need to change this in typical cases.
    let height: String = "100%"
    /// The object's properties identify player parameters that can be used to customize the player.
    var playerVars: Parameters
    /// The object's properties identify the events that the API fires and the functions (event listeners) that the API will call when those events occur. In the example, the constructor indicates that the onPlayerReady function will execute when the onReady event fires and that the onPlayerStateChange function will execute when the onStateChange event fires.
    @available(*, deprecated, message: "This has been moved to the html file. Use the delegate method")
    var events: Events?

    /// This class represents the player parameters that the iframe api is able to use.
    /// https://developers.google.com/youtube/player_parameters
    public class Parameters: Codable {
        public static var `default` = Parameters(autoplay: .false, modestBranding: .true, playsInline: .false)
        /**
         This parameter specifies whether the initial video will automatically start to play when the player loads. Supported values are 0 or 1. The default value is 0.

         If you enable Autoplay, playback will occur without any user interaction with the player; playback data collection and sharing will therefore occur upon page load.
         */
        public var autoplay: YoutubeParameterBool?
        /**
         This parameter specifies the default language that the player will use to display captions. Set the parameter's value to an ISO 639-1 two-letter language code.

         If you use this parameter and also set the `ccLoadPolicy` parameter to 1, then the player will show captions in the specified language when the player loads. If you do not also set the `ccLoadPolicy` parameter, then captions will not display by default, but will display in the specified language if the user opts to turn captions on.
         */
        public var ccLangPref: String?
        /**
         Setting the parameter's value to 1 causes closed captions to be shown by default, even if the user has turned captions off. The default behavior is based on user preference.
         */
        public var ccLoadPolicy: YoutubeParameterBool?
        /**
         This parameter specifies the color that will be used in the player's video progress bar to highlight the amount of the video that the viewer has already seen. Valid parameter values are red and white, and, by default, the player uses the color red in the video progress bar. See the YouTube API blog for more information about color options.

         Note: Setting the color parameter to white will disable the modestbranding option.
         */
        public var color: String?
        /**
         This parameter indicates whether the video player controls are displayed:
         - If set to false  - Player controls do not display in the player.
         - If set to true (default) – Player controls display in the player.
         */
        public var controls: YoutubeParameterBool?
        /**
         Setting the parameter's value to 1 causes the player to not respond to keyboard controls. The default value is 0, which means that keyboard controls are enabled. Currently supported keyboard controls are:
         Spacebar or [k]: Play / Pause
         Arrow Left: Jump back 5 seconds in the current video
         Arrow Right: Jump ahead 5 seconds in the current video
         Arrow Up: Volume up
         Arrow Down: Volume Down
         [f]: Toggle full-screen display
         [j]: Jump back 10 seconds in the current video
         [l]: Jump ahead 10 seconds in the current video
         [m]: Mute or unmute the video
         [0-9]: Jump to a point in the video. 0 jumps to the beginning of the video, 1 jumps to the point 10% into the video, 2 jumps to the point 20% into the video, and so forth.
         */
        public var disableKeyboard: YoutubeParameterBool?
        /**
         This parameter specifies the time, measured in seconds from the start of the video, when the player should stop playing the video. The parameter value is a positive integer.

         Note that the time is measured from the beginning of the video and not from either the value of the start player parameter or the startSeconds parameter, which is used in YouTube Player API functions for loading or queueing a video.
         */
        public var end: Int?
        /**
         This parameter causes the player to begin playing the video at the given number of seconds from the start of the video. The parameter value is a positive integer.

         Note that similar to the seekTo function, the player will look for the closest keyframe to the time you specify. This means that sometimes the play head may seek to just before the requested time, usually no more than around two seconds.
         */
        public var start: Int?
        /**
         Setting this parameter to 0 prevents the fullscreen button from displaying in the player. The default value is 1, which causes the fullscreen button to display.
         */
        public var fullScreen: YoutubeParameterBool?
        /**
         Setting the parameter's value to 1 causes video annotations to be shown by default, whereas setting to 3 causes video annotations to not be shown by default. The default value is 1.
         */
        public var ivLoadPolicy: String?
        /**
         The list parameter, in conjunction with the listType parameter, identifies the content that will load in the player.

         If the listType parameter value is user_uploads, then the list parameter value identifies the YouTube channel whose uploaded videos will be loaded.
         If the listType parameter value is playlist, then the list parameter value specifies a YouTube playlist ID. In the parameter value, you need to prepend the playlist ID with the letters PL as shown in the example below.
          `https://www.youtube.com/embed?listType=playlist&list=PLC77007E23FF423C6`
         If the listType parameter value is search, then the list parameter value specifies the search query. Note: This functionality is deprecated and will no longer be supported as of 15 November 2020.
         Note: If you specify values for the list and listType parameters, the IFrame embed URL does not need to specify a video ID.

         */
        public var list: String?
        /**
         The listType parameter, in conjunction with the list parameter, identifies the content that will load in the player. Valid parameter values are playlist and user_uploads.

         If you specify values for the list and listType parameters, the IFrame embed URL does not need to specify a video ID.

         Note: A third parameter value, search, has been deprecated and will no longer be supported as of 15 November 2020.
         */
        public var listType: YoutubePlayerListType?
        /**
         In the case of a single video player, a setting of 1 causes the player to play the initial video again and again. In the case of a playlist player (or custom player), the player plays the entire playlist and then starts again at the first video.

         Supported values are 0 and 1, and the default value is 0.

         Note: This parameter has limited support in IFrame embeds. To loop a single video, set the loop parameter value to 1 and set the playlist parameter value to the same video ID already specified in the Player API URL: `https://www.youtube.com/embed/VIDEO_ID?playlist=VIDEO_ID&loop=1`
         */
        public var loop: YoutubeParameterBool?
        /**
         This parameter lets you use a YouTube player that does not show a YouTube logo. Set the parameter value to 1 to prevent the YouTube logo from displaying in the control bar.

         Note that a small YouTube text label will still display in the upper-right corner of a paused video when the user's mouse pointer hovers over the player.
         */
        public var modestBranding: YoutubeParameterBool?
        /**
         This parameter provides an extra security measure for the IFrame API and is only supported for IFrame embeds.

         If you are using the IFrame API, which means you are setting the enablejsapi parameter value to 1, you should always specify your domain as the origin parameter value.
         */
        public var origin: String?
        /**
         This parameter specifies a comma-separated list of video IDs to play.

         If you specify a value, the first video that plays will be the VIDEO_ID specified in the URL path, and the videos specified in the playlist parameter will play thereafter.
         */
        public var playlist: String?
        /**
         This parameter controls whether videos play inline or fullscreen in an HTML5 player on iOS. Valid values are:

         - If set to 0 this value causes fullscreen playback. This is currently the default value, though the default is subject to change.
         - If set to 1 this value causes inline playback for UIWebViews created with the allowsInlineMediaPlayback property set to TRUE.
         */
        public var playsInline: YoutubeParameterBool?
        
        enum CodingKeys: String, CodingKey {
            case autoplay
            case ccLangPref = "cc_lang_pref"
            case ccLoadPolicy = "cc_load_policy"
            case color
            case controls
            case disableKeyboard = "disablekb"
            case end
            case start
            case fullScreen = "fs"
            case ivLoadPolicy = "iv_load_policy"
            case list
            case listType
            case loop
            case modestBranding = "modestbranding"
            case origin
            case playlist
            case playsInline = "playsinline"
        }

        public init(autoplay: YoutubeParameterBool? = nil,
                    ccLangPref: String? = nil,
                    ccLoadPolicy: YoutubeParameterBool? = nil,
                    color: String? = nil,
                    controls: YoutubeParameterBool? = nil,
                    disableKeyboard: YoutubeParameterBool? = nil,
                    end: Int? = nil,
                    start: Int? = nil,
                    fullScreen: YoutubeParameterBool? = nil,
                    ivLoadPolicy: String? = nil,
                    list: String? = nil,
                    listType: YoutubePlayerListType? = nil,
                    loop: YoutubeParameterBool? = nil,
                    modestBranding: YoutubeParameterBool? = nil,
                    origin: String? = nil,
                    playlist: String? = nil,
                    playsInline: YoutubeParameterBool? = nil)
        {
            self.autoplay = autoplay
            self.ccLangPref = ccLangPref
            self.ccLoadPolicy = ccLoadPolicy
            self.color = color
            self.controls = controls
            self.disableKeyboard = disableKeyboard
            self.end = end
            self.start = start
            self.fullScreen = fullScreen
            self.ivLoadPolicy = ivLoadPolicy
            self.list = list
            self.listType = listType
            self.loop = loop
            self.modestBranding = modestBranding
            self.origin = origin
            self.playlist = playlist
            self.playsInline = playsInline
        }
    }

    init(videoId: String?, playerVars: Parameters = .default) {
        self.videoId = videoId
        self.playerVars = playerVars
    }
}
