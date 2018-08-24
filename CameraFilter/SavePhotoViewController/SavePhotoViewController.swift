//
//  SavePhotoViewController.swift
//  CameraFilter
//
//  Created by Tosc189 on 03/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit
import Photos
import CropViewController
import iOSPhotoEditor
class SavePhotoViewController: UIViewController,PhotoEditorDelegate,CropViewControllerDelegate{
   
    

    @IBOutlet var imgFilterView: UIImageView!
    
    var imgPhoto: CGImage!
    var imgChange: UIImage?
    var filterName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        imgFilterView.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
         let imageAfterRotate = imgChange?.rotate(radians: .pi/2)
        imgFilterView.image = imageAfterRotate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let cgimg = imgPhoto?.cgImage
       
        //let newImage  = UIImage(ciImage: (filter?.outputImage)!, scale: (imgPhoto?.scale)!, orientation:(imgPhoto?.imageOrientation)!)
        
        
//        imgFilterView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        //imageFilter(filterName: filterName, cgImage:imgPhoto!)
//            imageFilter(filterName: filterName, cgImage:imgPhoto!)
        
    }
    
    func imageRotate(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnPenilPressed(_ sender: Any) {
        self.addTextToPhoto()
    }
    
    func addTextToPhoto(){
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        
        //PhotoEditorDelegate
        photoEditor.photoEditorDelegate = self
        
        //The image to be edited
        photoEditor.image = imgFilterView.image //(imgChange?.rotate(radians: .pi/2))
        
        //Stickers that the user will choose from to add on the image
//        photoEditor.stickers.append(UIImage(named: "sticker" )!)
        
        //Optional: To hide controls - array of enum control
        photoEditor.hiddenControls = [.sticker, .draw, .share, .crop]
        
        //Optional: Colors for drawing and Text, If not set default values will be used
        photoEditor.colors = [.red,.blue,.green]
        
        //Present the View Controller
        present(photoEditor, animated: true, completion: nil)
    }
    
    func doneEditing(image: UIImage) {
        imgFilterView.image = image
    }
    
    func canceledEditing() {
        
    }
    func presentCropViewController() {
        let image: UIImage = imgFilterView.image! //Load an image
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioPickerButtonHidden = true
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        imgFilterView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendPressed(_ sender: UIButton) {
//        self.addTextToPhoto()
        self.presentCropViewController()
//        sender.isSelected = !sender.isSelected
//        UIView.animate(withDuration: 1, animations: {
//            if sender.isSelected {
//                self.imgFilterView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
//            } else {
////                self.imgFilterView.transform = CGAffineTransform(rotationAngle: (.pi * 1.5))
//                self.imgFilterView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
////                self.imgFilterView.transform = CGAffineTransform(rotationAngle: 0)
//
//            }
//        })
//        self.imgFilterView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
//        try? PHPhotoLibrary.shared().performChangesAndWait {
//            PHAssetChangeRequest.creationRequestForAsset(from: (self.imgChange?.rotate(radians: .pi/2)!)!)
//        }
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
