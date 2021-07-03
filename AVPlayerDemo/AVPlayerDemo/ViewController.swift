//
//  ViewController.swift
//  AVPlayerDemo
//
//  Created by TIU-User on 16/04/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var gpVideoPlyer: AppVideoPlayer!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayerBackgroundView: UIView!

    @IBOutlet weak var tblView: UITableView!
    
    var arrUrls = ["http://dmwerp.com:1935/vod3/_definst_/mp4:amazons3/eteachepathshala/CBSE/ENGLISH/CLASS_X/SCIENCE/SOURCES_OF_ENERGY/5.mp4/playlist.m3u8","http://dmwerp.com:1935/vod3/_definst_/mp4:amazons3/eteachepathshala/eKids/CBSE/ENGLISH/Nursery/ACTIVITY/BIRDS_ON_THE_SNOW/1.mp4/playlist.m3u8","http://dmwerp.com:1935/vod3/_definst_/mp4:amazons3/eteachepathshala/CBSE/ENGLISH/Class_I/ENGLISH/ADJECTIVES/1.mp4/playlist.m3u8"]
    override func viewDidLoad() {
        super.viewDidLoad()
        gpVideoPlyer.videoURL = URL(string: arrUrls[1])!
        gpVideoPlyer.onFullScreenClicked { (isSelected) in
            self.rotate(isExpanded: isSelected)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell!.textLabel?.text = "Stream \(indexPath.row + 1)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = arrUrls[indexPath.row]
        
        if let player = gpVideoPlyer {
            player.videoURL = URL(string: url)!///loadVideo(with: URL(string: url)!)
           // player.playVideo()
        }
    }
    
    
    var previousConstraints: [NSLayoutConstraint] = []
    
    func rotate(isExpanded: Bool) {
        let views: [String:Any] = ["videoPlayer": gpVideoPlyer as Any,
                                   "backgroundView": videoPlayerBackgroundView as Any]
        
        var constraints: [NSLayoutConstraint] = []
        
        if !isExpanded {
            self.containerView.removeConstraints(self.gpVideoPlyer.constraints)
            
            self.view.addSubview(self.videoPlayerBackgroundView)
            self.view.addSubview(self.gpVideoPlyer)
            self.gpVideoPlyer.frame = self.containerView.frame
            self.videoPlayerBackgroundView.frame = self.containerView.frame
            
            let padding = (self.view.bounds.height - self.view.bounds.width) / 2.0
            
            var bottomPadding: CGFloat = 0
            
            if #available(iOS 11.0, *) {
                if self.view.safeAreaInsets != .zero {
                    bottomPadding = self.view.safeAreaInsets.bottom
                }
            }
            
            let metrics: [String:Any] = ["padding":padding,
                                         "negativePaddingAdjusted":-(padding - bottomPadding),
                                         "negativePadding":-padding]
            
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePaddingAdjusted)-[videoPlayer]-(negativePaddingAdjusted)-|",
                                                               options: [],
                                                               metrics: metrics,
                                                               views: views))
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[videoPlayer]-(padding)-|",
                                                               options: [],
                                                               metrics: metrics,
                                                               views: views))
            
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePadding)-[backgroundView]-(negativePadding)-|",
                                                               options: [],
                                                               metrics: metrics,
                                                               views: views))
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[backgroundView]-(padding)-|",
                                                               options: [],
                                                               metrics: metrics,
                                                               views: views))
            
            self.view.addConstraints(constraints)
        } else {
            self.view.removeConstraints(self.previousConstraints)
            
            let targetVideoPlayerFrame = self.view.convert(self.gpVideoPlyer.frame, to: self.containerView)
            let targetVideoPlayerBackgroundViewFrame = self.view.convert(self.videoPlayerBackgroundView.frame, to: self.containerView)
            
            self.containerView.addSubview(self.videoPlayerBackgroundView)
            self.containerView.addSubview(self.gpVideoPlyer)
            
            self.gpVideoPlyer.frame = targetVideoPlayerFrame
            self.videoPlayerBackgroundView.frame = targetVideoPlayerBackgroundViewFrame
            
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoPlayer]|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: views))
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoPlayer]|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: views))
            
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: views))
            constraints.append(contentsOf:
                                NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: views))
            
            self.containerView.addConstraints(constraints)
        }
        
        self.previousConstraints = constraints
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.gpVideoPlyer.transform = isExpanded == true ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
            self.videoPlayerBackgroundView.transform = isExpanded == true ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
            
            self.view.layoutIfNeeded()
        })
    }
}

