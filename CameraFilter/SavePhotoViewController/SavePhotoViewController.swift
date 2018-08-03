//
//  SavePhotoViewController.swift
//  CameraFilter
//
//  Created by Tosc189 on 03/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit
import Photos
class SavePhotoViewController: UIViewController {

    @IBOutlet var imgFilterView: UIImageView!
    
    var imgPhoto: CGImage!
    var imgChange: UIImage?
    var filterName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        imgFilterView.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let cgimg = imgPhoto?.cgImage
        
        //let newImage  = UIImage(ciImage: (filter?.outputImage)!, scale: (imgPhoto?.scale)!, orientation:(imgPhoto?.imageOrientation)!)
        
        
//        imgFilterView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        imgFilterView.image = imageFilter(filterName: filterName, cgImage:imgPhoto!)
//            imageFilter(filterName: filterName, cgImage:imgPhoto!)
        
    }
    
    func imageFilter(filterName:String,cgImage:CGImage) -> UIImage{
        
        let context = CIContext(options: nil)
        
        let coreImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter (name: filterName)
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            
            let cgimgresult = context.createCGImage(output, from: output.extent)
            
            let result = UIImage (cgImage: cgimgresult!)
            
            imgChange = result
        }
        
        let newImage  = UIImage(ciImage: (filter?.outputImage)!, scale: (imgChange?.scale)!, orientation:(imgChange?.imageOrientation)!)
        
        return newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSendPressed(_ sender: Any) {
        try? PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetChangeRequest.creationRequestForAsset(from: self.imgChange!)
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
