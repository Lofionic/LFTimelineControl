//
//  ViewController.swift
//  LFTimelineControl
//
//  Created by Chris Rivers on 23/10/2020.
//

import UIKit

import LFTimelineControl

class ViewController: UIViewController {

    @IBOutlet weak var timelineControl: TimelineControl!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineControl.addTarget(self, action: #selector(updateLabel), for: .valueChanged)
        updateLabel()
    }
    
    @IBAction func tapReset(_ sender: Any) {
        timelineControl.setLocation(0, animated: true)
        updateLabel()
    }
    
    @objc
    private func updateLabel() {
        label.text = "\(String(format: "%.02f", timelineControl.location))"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

