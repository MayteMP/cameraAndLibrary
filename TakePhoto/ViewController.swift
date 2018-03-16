//
//  ViewController.swift
//  TakePhoto
//
//  Created by Mayte Mejia Palacios on 06/03/18.
//  Copyright © 2018 Mayte. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePicked: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButt(sender: AnyObject) {
        /*if imagePicked.image != nil {
        
            let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
            let compressedJPGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
            
            let alert = UIAlertController(title: "Guardado", message: "Su foto ha sido guardada en la galería.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .Default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Ha ocurrido un error al guardar", preferredStyle: .Alert)
            alert.view.tintColor = UIColor.redColor()
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .Default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            presentViewController(alert, animated: true, completion: nil)
        }*/
        if let capturePhotoImage = self.imagePicked.image {
            if let imageData = UIImagePNGRepresentation(capturePhotoImage) {
                let encodedImageData = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                //base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
                let url = NSURL(string: "http://172.16.200.70:3000/create-image")!
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                
                let postString = "image=\(encodedImageData)"
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    guard let data = data where error == nil else {
                        print("error=(error)")
                        return
                    }
                    /*if let httpStatus = response as? HTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is (httpStatus.statusCode)")
                        print("response = (response)")
                    }*/
                    let responseString = String(data: data, encoding: NSUTF8StringEncoding)
                    print("responseString = (responseString)")
                }
                task.resume()
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Ha ocurrido un error al guardar", preferredStyle: .Alert)
            alert.view.tintColor = UIColor.redColor()
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .Default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }

}

