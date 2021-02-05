//
//  YoutubePlayer.swift
//  YoutubePlayer
//
//  Created by Nicholas Mata on 12/21/14.
//

#if canImport(UIKit)
import UIKit
import WebKit

open class YoutubePlayerView: UIView {
    public var baseURL = "about:blank"

    fileprivate var webView: WKWebView!

    /** The readiness of the player */
    open fileprivate(set) var ready = false

    /** The current state of the video player */
    open fileprivate(set) var playerState = YoutubePlayerState.unstarted

    /** The current playback quality of the video player */
    open fileprivate(set) var playbackQuality = YoutubePlaybackQuality.small

    /** Used to respond to player events */
    open weak var delegate: YoutubePlayerDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        buildWebView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildWebView()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        // Remove web view in case it's within view hierarchy, reset frame, add as subview
        webView.removeFromSuperview()
        webView.frame = bounds
        addSubview(webView)
    }

    fileprivate func buildWebView() {
//        let jsScript  = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        let userScript = WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptEnabled = true
        configuration.userContentController = userContentController

        webView = WKWebView(frame: frame, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
    }
}

extension YoutubePlayerView {
    open func loadVideo(withOptions options: YoutubePlayerOptions) throws {
        try loadWebView(with: options)
    }

    open func loadVideo(withId videoId: String,
                        playerVars: YoutubePlayerOptions.Parameters = .default) throws
    {
        let playerOptions = YoutubePlayerOptions(videoId: videoId, playerVars: playerVars)
        try loadWebView(with: playerOptions)
    }

    open func loadVideo(withUrl videoURL: URL,
                        playerVars: YoutubePlayerOptions.Parameters = .default) throws
    {
        if let videoId = YoutubeURL.videoId(for: videoURL) {
            try loadVideo(withId: videoId, playerVars: playerVars)
        }
    }

    open func loadPlaylist(with playlistId: String) throws {
        // No videoId necessary when listType = .playlist, list = [playlist Id]
        let playerOptions = YoutubePlayerOptions(videoId: nil, playerVars: .default)
        playerOptions.playerVars.listType = .playlist
        playerOptions.playerVars.list = playlistId
        try loadWebView(with: playerOptions)
    }
}

extension YoutubePlayerView {
    open func mute() {
        evaluatePlayerCommand("mute()")
    }

    open func unMute() {
        evaluatePlayerCommand("unMute()")
    }

    open func play() {
        evaluatePlayerCommand("playVideo()")
    }

    open func pause() {
        evaluatePlayerCommand("pauseVideo()")
    }

    open func stop() {
        evaluatePlayerCommand("stopVideo()")
    }

    open func clear() {
        evaluatePlayerCommand("clearVideo()")
    }

    open func seekTo(_ seconds: Float, seekAhead: Bool) {
        evaluatePlayerCommand("seekTo(\(seconds), \(seekAhead))")
    }

    open func getDuration(completion: ((Double?) -> Void)? = nil) {
        evaluatePlayerCommand("getDuration()") { result in
            completion?(result as? Double)
        }
    }

    open func getCurrentTime(completion: ((Double?) -> Void)? = nil) {
        evaluatePlayerCommand("getCurrentTime()") { result in
            completion?(result as? Double)
        }
    }

    open func previousVideo() {
        evaluatePlayerCommand("previousVideo()")
    }

    open func nextVideo() {
        evaluatePlayerCommand("nextVideo()")
    }

    fileprivate func evaluatePlayerCommand(_ command: String, completion: ((Any?) -> Void)? = nil) {
        let fullCommand = "player." + command + ";"
        webView.evaluateJavaScript(fullCommand) { result, error in
            if let error = error, (error as NSError).code != 5 { // NOTE: ignore :Void return
                print(error)
                printLog("Error executing javascript")
                completion?(nil)
            }

            completion?(result)
        }
    }
}

private extension YoutubePlayerView {
    func loadWebView(with options: YoutubePlayerOptions) throws {
        // Get HTML from player file in bundle
        // Using exclamation points because if this fails it is packaging issue.
        guard let playerHtmlPath = Bundle(for: Self.self)
            .url(forResource: "YoutubePlayer", withExtension: "html")
        else {
            return
        }

        let html = try String(contentsOf: playerHtmlPath, encoding: .utf8)

        let jsonPlayerOptions = String(data: try! JSONEncoder().encode(options), encoding: .utf8)!

        // Replace INSERT_OPTIONS_HERE in html contents with json object.
        let finalHtml = html.replacingOccurrences(of: "INSERT_OPTIONS_HERE", with: jsonPlayerOptions)

        // Load HTML in web view
        webView.loadHTMLString(finalHtml, baseURL: URL(string: baseURL))
    }
}

extension YoutubePlayerView: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?
        defer {
            decisionHandler(action ?? .allow)
        }

        guard let url = navigationAction.request.url else { return }

        if url.scheme == "ytplayer" {
            handleJSEvent(url)
            action = .cancel
        }
    }

    fileprivate func handleJSEvent(_ eventURL: URL) {
        // Grab the last component of the queryString as string
        let data = eventURL.queryStringComponents()["data"] as? String

        if let host = eventURL.host {
            let event = YoutubePlayerEvent(eventName: host, data: data)
            // Check event type and handle accordingly
            switch event {
            case .iFrameReady:
                ready = true
            case .stateChanged(let newState):
                playerState = newState
            case .playbackQualityChanged(let newQuality):
                playbackQuality = newQuality
            default:
                break
            }
            delegate?.youtubePlayer(self, fired: event)
        }
    }
}

private func printLog(_ strings: CustomStringConvertible...) {
    let toPrint = ["[YoutubePlayer]"] + strings
    print(toPrint, separator: " ", terminator: "\n")
}
#endif
