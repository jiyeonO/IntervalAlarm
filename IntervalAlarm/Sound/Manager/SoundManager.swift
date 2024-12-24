//
//  SoundManager.swift
//  IntervalAlarm
//
//  Created by 오지연 on 12/11/24.
//
import SwiftUI
import AVFoundation

class SoundManager: NSObject {
    
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    private var generator: UIImpactFeedbackGenerator?
    private var timer: Timer?
    
}

// MARK: - Sound
extension SoundManager: AVAudioPlayerDelegate {
    
    func playSound(_ name: String) {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: filePath)

        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            player = nil
            DLog.e("audioPlayer error \(error.localizedDescription)")
            return
        }

        if let player = player {
            player.delegate = self
            player.prepareToPlay()
            player.numberOfLoops = -1
            player.play()
            
            self.startVibration()
        }
    }
    
    func stopSound() {
        player?.stop()
        player = nil
        
        self.startVibration()
    }
    
}

// MARK: - Vibration
extension SoundManager {
    
    func startVibration() {
        generator = UIImpactFeedbackGenerator(style: .heavy)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.generator?.impactOccurred()
        }
    }
    
    func stopVibration() {
        timer?.invalidate()
        timer = nil
        generator = nil
    }
    
}
