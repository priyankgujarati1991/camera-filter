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
        
        if #available(iOS 11.0, *) {
//            self.cameraView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
//        let btnRightMenu = UIButton.init(type: .custom)
//        btnRightMenu.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
////        btnRightMenu.setImage(#imageLiteral(resourceName: "Img-Ticket-Black"), for: UIControlState.normal)
//        btnRightMenu.setTitle("Add Image", for: .normal)
//        btnRightMenu.addTarget(self, action:#selector(self.btnRightMenu), for:.touchUpInside)
//        btnRightMenu.backgroundColor = UIColor.red
//        let barRightMenuBtn = UIBarButtonItem.init(customView: btnRightMenu)
//        self.navigationItem.rightBarButtonItem = barRightMenuBtn
        
//        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "test.png"), style: .plain, target: self, action: #selector(ViewController.clickButton))
        let barbuttonItem = UIBarButtonItem(title: "Next", style:.plain, target: self, action:#selector(btnRightMenu))
        self.navigationItem.rightBarButtonItem  = barbuttonItem
        
        self.imgForFilter.isHidden = true

         self.openCamera()
        
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
        self.imgForFilter.isHidden = true
        self.cameraView.isHidden = false
    
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
        
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDuoCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera,AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
//        for device in (deviceDiscoverySession.devices) {
//            if(device.position == AVCaptureDevice.Position.back){
//                do{
//                    let input = try AVCaptureDeviceInput(device: device)
//                    if(captureSession.canAddInput(input)){
//                        captureSession.addInput(input);
//
//                        if(captureSession.canAddOutput(sessionOutput)){
//                            captureSession.addOutput(sessionOutput);
//                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
//                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait;
//                            previewLayer.frame = self.cameraView.bounds
//                            self.cameraView.layer.addSublayer(previewLayer);
//
//                        }
//                    }
//                }
//                catch{
//                    print("exception!");
//                }
//            }
//        }
//        captureSession.startRunning()
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
        return smallImage!
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
            let cgimg = imgForFilter.image?.cgImage
            imgForFilter.image = self.imageFilter(filterName: self.filterNameList[indexPath.item], cgImage: cgimg!)
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

extension UIImage{
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

//extension ViewController: AVCapturePhotoCaptureDelegate {
//    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//                            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
//
//         if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
//            let image = UIImage(data: data) {
//
//
//        }
//
//        else {
//
//        }
//    }
//
//}
