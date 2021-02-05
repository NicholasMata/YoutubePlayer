//
//  ViewController.swift
//  YoutubePlayerExample
//
//  Created by Nicholas Mata on 2/4/21.
//

import UIKit
import YoutubePlayer

class ViewController: UIViewController {
    @IBOutlet var playerView: YoutubePlayerView!
    @IBOutlet var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerView.delegate = self
        loadVideo()
    }

    @IBAction func play(_ sender: UIButton) {
        if playerView.ready {
            if playerView.playerState != .playing {
                playerView.play()
                playButton.setTitle("Pause", for: .normal)
            } else {
                playerView.pause()
                playButton.setTitle("Play", for: .normal)
            }
        }
    }

    @IBAction func prev(_ sender: UIButton) {
        playerView.previousVideo()
    }

    @IBAction func next(_ sender: UIButton) {
        playerView.nextVideo()
    }

    @IBAction func loadVideo(_ sender: UIButton? = nil) {
        try! playerView.loadVideo(withId: "JLVXQn3fqgg", playerVars: YoutubePlayerOptions.Parameters(playsInline: .true))
    }

    @IBAction func loadPlaylist(_ sender: UIButton? = nil) {
        try? playerView.loadPlaylist(with: "RDe-ORhEE9VVg")
    }

    @IBAction func getCurrentTime() {
        playerView.getCurrentTime { result in
            let title: String
            let message: String
            switch result {
            case .success(let currentTime):
                title = "Current Time"
                message = self.format(currentTime) ?? "Unknown"
            case .failure(let error):
                title = "An error occurred"
                message = "\(error)"
            }
            self.displayAlert(title: title, message: message)
        }
    }

    @IBAction func getDuration() {
        playerView.getDuration { result in
            let title: String
            let message: String
            switch result {
            case .success(let duration):
                title = "Video Duration"
                message = self.format(duration) ?? "Unknown"
            case .failure(let error):
                title = "An error occurred"
                message = "\(error)"
            }
            self.displayAlert(title: title, message: message)
        }
    }

    func format(_ timeInterval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = .full
        return formatter.string(from: timeInterval)
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

extension ViewController: YoutubePlayerDelegate {
    func youtubePlayer(_ videoPlayer: YoutubePlayerView, fired event: YoutubePlayerEvent) {
        print(event)
        switch event {
        case .stateChanged(let state):
            switch state {
            case .playing:
                playButton.setTitle("Pause", for: .normal)
            case .paused:
                playButton.setTitle("Play", for: .normal)
            default:
                break
            }
        case .errorOccurred(let error):
            print(error)
        case .unknown(let eventName, let data):
            print(eventName)
            print(data)
        default:
            break
        }
    }
}
