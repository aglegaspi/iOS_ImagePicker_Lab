//
//  ViewController.swift
//  iOS_ImagePicker_Lab
//
//  Created by Alexander George Legaspi on 10/1/19.
//  Copyright © 2019 Alexander George Legaspi. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var circularImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var photoLibraryAccess = false
    
    var image = UIImage() {
        didSet {
            circularImage.contentMode = .scaleAspectFill
            circularImage.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPhotoLibraryAccess()
        roundImageView()
        imagePicker.delegate = self
    }
    
    @IBAction func photoLibraryPressed(_ sender: UIBarButtonItem) {
        let imagePickerViewController = UIImagePickerController()
        
        if photoLibraryAccess {
            imagePickerViewController.delegate = self
            present(imagePickerViewController, animated: true, completion: nil
            )
        } else {
            
            let alertVC = UIAlertController(title: "No Access", message: "Camera access is required to use this app.", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction (title: "Deny", style: .destructive, handler: nil))
            
            self.present(alertVC, animated: true, completion: nil)
            
            alertVC.addAction(UIAlertAction (title: "I will let you in", style: .default, handler: { (action) in
                self.photoLibraryAccess = true
                self.present(imagePickerViewController, animated: true, completion: nil)
                }
                )
            )
        }
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,
                    animated: true,
                    completion: nil)
        } else {
            noCamera()
        }
    }
    
    private func roundImageView() {
        circularImage.layer.masksToBounds = true
        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
    }
    
    private func noCamera() {
        
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func checkPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case .authorized:
            print(status)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                switch status {
                case .authorized:
                    self.photoLibraryAccess = true
                    print(status)
                case .denied:
                    self.photoLibraryAccess = false
                    print("denied")
                case .notDetermined:
                    print("not determined")
                case .restricted:
                    print("restricted")
                default:
                    fatalError()
                }
            })
            
        case .denied:
            let alertVC = UIAlertController(title: "Denied", message: "Camera access is required to use this app. Please change your preference in the Settings app", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction (title: "Ok", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
            
        default:
            return
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\ninfo: \(info)\n") // keys: UIImagePickerController.InfoKey.originalImage
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("no image found")
            return
        }
        
        self.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
}
