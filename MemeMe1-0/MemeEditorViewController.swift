//
//  MemeEditorViewController.swift
//  MemeMe1-0
//
//  Created by Jitendr Talele on 6/1/16.
//  Copyright © 2016 JTalele. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var imagePickerController:UIImagePickerController!
    var memedImage:UIImage!
    var selectedTextField:UITextField!
    
    func imagePickerController(picker:UIImagePickerController, didFinishPickingImage image:UIImage, editingInfo:[String : AnyObject]?){
        self.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = image
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePickerController = UIImagePickerController()
            imagePickerController.delegate=self
            imagePickerController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.allowsEditing=false
            self.presentViewController(imagePickerController,animated: true, completion: nil)
        }
    }

}

