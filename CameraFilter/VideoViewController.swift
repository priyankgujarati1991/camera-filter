//
//  VideoViewController.swift
//  CameraFilter
//
//  Created by Tosc189 on 23/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VideoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 2.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CustomCell
        
   
//
//        print(tempcell)
        cell.imgThumb.backgroundColor = UIColor.brown
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? CustomCell
        {
            let ce = tblView.indexPathsForVisibleRows!
            
            print(ce.count)
            //perform your code to cell
            
            let cellRect = tableView.rectForRow(at: indexPath)
            let completelyVisible = tableView.bounds.contains(cellRect)
            if completelyVisible {
                myCell.imgThumb.backgroundColor = UIColor.clear
            }
        }
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let ce = tblView.visibleCells
        let second = ce[1];
        if let cell = second as? CustomCell{
            cell.imgThumb.backgroundColor = UIColor.red
        }
        print(second)
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
