//
//  VideoViewController.swift
//  CameraFilter
//
//  Created by Tosc189 on 23/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher
class VideoViewController: UIViewController,VideoParserDelegate {
    
    @IBOutlet var tblView: UITableView!
    
    var player:AVPlayer?
    
    var arrGetVideoData = [VideoDataModelList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let videoparser = VideoParser()
        videoparser.delegate = self
        videoparser.getData()
        
    }
    
    func videoParserSuccess(_ arrVideoData: [VideoDataModelList]) {
        print(arrVideoData)
        if arrVideoData.count > 0 {
            
            self.arrGetVideoData = arrVideoData
            self.tblView.reloadData()
        }
    }
    
    func videoParserFailure(_ message: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension VideoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetVideoData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 2.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CustomCell
        
        let dataModel = self.arrGetVideoData[indexPath.row]
        
        let sourceURL = dataModel.sourceURL
        
        let url = URL(fileURLWithPath: sourceURL!)
        
        let pathRemoving = url.deletingLastPathComponent()
        
        let imageUrl = pathRemoving.appendingPathComponent(dataModel.thumb)
        
        cell.lblTitle.text = dataModel.subtitle
        
        cell.imgThumb.kf.setImage(with: imageUrl)
        if !dataModel.isplaying {
            cell.viewVideo.isHidden = true
            cell.imgThumb.isHidden = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let playerDidiSelect = self.player {
            
            if playerDidiSelect.rate > 0 {
                playerDidiSelect.pause()
            }
            else {
                self.player?.play()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let visibleINdexPaths = tblView.indexPathsForVisibleRows else{return}
        
        if visibleINdexPaths.count != 0 {
            if let cell = self.tblView.cellForRow(at: visibleINdexPaths[1]) as? CustomCell{
                
                let sec = visibleINdexPaths[1]
                
                let dataModel = self.arrGetVideoData[sec.row]
                
                if dataModel.isplaying{
                    UIView.animate(withDuration: 1, animations: {
                        self.player?.pause()
                        cell.viewVideo.isHidden = true
                        cell.imgThumb.isHidden = false
                    }, completion: nil)
                }else{
                    
                }
                
            }
        }

        
        //        let second = visibleINdexPaths[1];
        //        let dataModel = self.arrGetVideoData[second.row]
        //        if dataModel.isplaying {
        //            dataModel.isplaying = false
        //            self.player?.pause()
        //        }
        
        print("Scroll Start")
        //        let ce = tblView.indexPathsForVisibleRows!
        //        let second = ce[1];
        //
        //        print(ce.count)
        
        //        let isReachingEnd = scrollView.contentOffset.y >= 0
        //            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        //
        //        let middleindex = self.tblView.indexPathForRow(at:CGPoint(x: tblView.center.x, y: tblView.center.y))
        //
        //        let tempcell =  self.tblView.cellForRow(at: middleindex!)
        //
        //        print(tempcell)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate"{
            if let play = self.player{
                if play.rate > 0{
                    print("Video start")
                }
            }
            
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let visibleINdexPaths = tblView.indexPathsForVisibleRows else{return}
        
//        self.tblView.contentOffset = CGPoint(x: 0, y:self.tblView.frame.size.height)
        
        if visibleINdexPaths.count == 0 {
            print("Count 0")
        }else{
            print("Play video")
        }
        
        let second = visibleINdexPaths[1];
    
        if let cell = self.tblView.cellForRow(at: second) as? CustomCell{
            
            let dataModel = self.arrGetVideoData[second.row]
            
            cell.viewVideo.isHidden = false
            
            dataModel.isplaying = true
            
            cell.imgThumb.isHidden = true
            
            self.player = AVPlayer(url: URL(string: dataModel.sourceURL)!)
            
            self.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
            
//            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 600), queue: DispatchQueue.main, using: )
            
            let playerLayer = AVPlayerLayer(player: player)
            
            playerLayer.frame = cell.viewVideo.bounds
            
            cell.viewVideo.layer.addSublayer(playerLayer)
            
            self.player?.play()
        }
    }
    
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if let myCell = cell as? CustomCell
    //        {
    //            let ce = tblView.visibleCells
    //            //perform your code to cell
    ////            print(ce.count)
    //            let cellRect = tableView.rectForRow(at: indexPath)
    //            let completelyVisible = tableView.bounds.contains(cellRect)
    //            if completelyVisible {
    //                myCell.imgThumb.backgroundColor = UIColor.clear
    //            }
    //        }
    //    }
    
    
    
}
