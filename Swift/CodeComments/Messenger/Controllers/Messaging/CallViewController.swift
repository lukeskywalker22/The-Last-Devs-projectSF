//
//  CallViewController.swift
//  Messenger
//
//  Created by Luke Yeo on 11/7/22.
//

import UIKit

import AgoraUIKit
import AgoraRtcKit
import AgoraRtmKit
import AgoraRtmControl

class CallViewController: UIViewController {
    
    var agoraView: AgoraVideoViewer!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var agSettings = AgoraSettings()
        func leaveChannel(){
            agoraView.leaveChannel()
        }
        
        func initButtons(){
            agSettings.enabledButtons = [.micButton,
                                         .cameraButton,
                                         .flipButton]
        }
        initButtons()
        view.backgroundColor = .secondarySystemBackground
        self.title = "Call"
        self.agoraView = AgoraVideoViewer(
            connectionData: AgoraConnectionData(
                appId: "f4c986bfe3414f2a857d946a0663322a",
                appToken: "006f4c986bfe3414f2a857d946a0663322aIABFDOF5ScY7N8vhBLlSxKi7t//Z41HpeVbEDrqw1iQfcQx+f9gAAAAAEACQKMvt8bfQYgEAAQDxt9Bi"
            ),
            agoraSettings: agSettings,
            delegate: self
        )
        
        // frame the view
        self.view.addSubview(agoraView)
        agoraView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 95, width: self.view.frame.width, height: self.view.frame.height - 95)
        agoraView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the layout style (default .grid)
        agoraView.style = .grid // or .floating
        
        // join the channel "test"
        agoraView.join(channel: "test", as: .broadcaster)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AgoraRtcEngineKit.destroy()
    }
    
}

extension CallViewController: AgoraVideoViewerDelegate {
    public func extraButtons() -> [UIButton] {
        let button = UIButton()
        button.setImage(UIImage(
            systemName: "phone.down.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        ), for: .normal)
        
        button.addTarget(
            self,
            action: #selector(clickedBolt),
            for: .touchUpInside
        )
        return [button]
    }
    
    @objc func clickedBolt(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        AgoraRtcEngineKit.destroy()
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ?
            .systemRed : .systemRed
    }
}
