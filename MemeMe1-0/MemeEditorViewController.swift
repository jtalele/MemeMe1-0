//
//  MemeEditorViewController.swift
//  MemeMe1-0
//
//  Created by Jitendr Talele on 6/1/16.
//  Copyright © 2016 JTalele. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var imagePickerController:UIImagePickerController!
    var memedImage:UIImage!
    var selectedTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let textFieldArray = [topText, bottomText]
        configureTextFields(textFieldArray)
        
        //Disable the Share button:
        shareButton.enabled = false
        cancelButton.enabled = false
    }
    
    func configureTextFields(textFields: [UITextField!]){
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 4.0
        ]
        
        for textField in textFields{
            //Configure and position the top textfield
            textField.textAlignment = .Center
            textField.delegate = self
            textField.defaultTextAttributes = memeTextAttributes
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        //Subscribe to keyboard notifications:
        subscribeToKeyboardNotification()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func displayKeyboard(notification: NSNotification) {
        if selectedTextField == bottomText && self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func hideKeyboard(notification: NSNotification) {
        if -self.view.frame.origin.y > 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.displayKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        imagePickerController=UIImagePickerController()
        imagePickerController.delegate=self
        imagePickerController.sourceType=UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerController,animated: true, completion: nil)
        
    }

}

