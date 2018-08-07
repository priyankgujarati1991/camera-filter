//
//  ViewController.swift
//  CameraFilter
//
//  Created by Tosc189 on 31/07/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
class ViewController: UIViewController {
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var imgForFilter: UIImageView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet var btnCaptureimage: UIButton!

    fileprivate var smallImage: UIImage?
    
    fileprivate var orignalImage: UIImage?
    
    var imagePicker:UIImagePickerController?
   
    var captureSession = AVCaptureSession();
    
    var sessionOutput = AVCapturePhotoOutput();
    
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG]);
    
    var previewLayer = AVCaptureVideoPreviewLayer();
    
    var photoOutput: AVCapturePhotoOutput?
    
    let cameraController = CameraController()
    
    fileprivate let filterNameList = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    fileprivate let filterDisplayNameList = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker?.delegate = self

        btnCaptureimage.layer.cornerRadius = 19.0
        
        let barbuttonItem = UIBarButtonItem(title: "Next", style:.plain, target: self, action:#selector(btnRightMenu))
        
        self.navigationItem.rightBarButtonItem  = barbuttonItem
        
        self.imgForFilter.isHidden = true

         self.openCamera()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapOnCameraView(_:)))
        
        tap.numberOfTapsRequired = 2
        
        cameraView.addGestureRecognizer(tap)
        
        cameraView.isUserInteractionEnabled = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.imgForFilter.isHidden = true
        self.cameraView.isHidden = false

    }
    
    @objc func doubleTapOnCameraView(_ sender: UITapGestureRecognizer) {
        do {
            try cameraController.switchCameras()
        }
        catch {
            print(error)
        }
    }

    func checkPermission(){
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied: break
        case .authorized: break
        case .restricted: break
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    
                    print("Granted access to \(cameraMediaType)")
                } else {
                    print("Denied access to \(cameraMediaType)")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnRightMenu(){
        let savePhotoViewController = AppDelegate.storyboard.instantiateViewController(withIdentifier: "savephotoviewcontroller") as! SavePhotoViewController
        savePhotoViewController.imgChange = smallImage!
        self.navigationController?.pushViewController(savePhotoViewController, animated: true)
        
//        self.imgForFilter.isHidden = true
//        self.cameraView.isHidden = false
        
    }
    
    @IBAction func btnCapturePhoto(_ sender: Any) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.orignalImage = image
            
            self.imgForFilter.isHidden = false
            
            self.imgForFilter.image = image
            
            self.cameraView.isHidden = true
        }
    }
    func openCamera(){
        
        self.checkPermission()
        
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.cameraView)
        }
    }
    
    
    func resetFilter(){
        let img = orignalImage
        self.imgForFilter.image = img
    }
    
    func imageFilter(filterName:String,cgImage:CGImage) -> UIImage{
        
        let context = CIContext(options: nil)
        
        let coreImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter (name: filterName)
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            
            let cgimgresult = context.createCGImage(output, from: output.extent)
            
            let result = UIImage (cgImage: cgimgresult!)
            
            smallImage = result
        }
        let imageAfterFilter = smallImage?.rotate(radians: .pi/2)
//        let newImage  = UIImage(ciImage: (filter?.outputImage)!, scale: (smallImage?.scale)!, orientation:(smallImage?.imageOrientation)!)
//
//        smallImage = newImage
        
        return imageAfterFilter!
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFilter", for: indexPath) as! CellFilter
      
        smallImage = #imageLiteral(resourceName: "placeimg.jpg")
        
        let cgimg = smallImage?.cgImage
        
        if indexPath.row != 0 {
            cell.imgFilter.image = self.imageFilter(filterName: self.filterNameList[indexPath.row], cgImage: cgimg!)
        }else
        {
            cell.imgFilter.image = #imageLiteral(resourceName: "placeimg.jpg")
        }
       
        cell.lblNameOfFilter.text = filterDisplayNameList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70.0, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        resetFilter()
        
        let filterIndex = indexPath.row
        
        if filterIndex != 0 {
            
            if imgForFilter.image != nil{
                
                let cgimg = imgForFilter.image?.cgImage
                
                imgForFilter.image = self.imageFilter(filterName: self.filterNameList[indexPath.item], cgImage: cgimg!)
            }
        
        } else {
            imgForFilter?.image = self.orignalImage
        }
    }
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgForFilter.image = (possibleImage as AnyObject).image
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
