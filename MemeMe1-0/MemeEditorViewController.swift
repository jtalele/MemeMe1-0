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
    @IBOutlet weak var NaviBar: UINavigationBar!
    @IBOutlet weak var ToolBar: UIToolbar!
    
    var imagePickerController:UIImagePickerController!
    var memedImage:UIImage!
    var selectedTextField:UITextField!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let textFieldArray = [topText, bottomText]
        configureTextFields(textFieldArray)
        
        //Disable the Share button:
        shareButton.enabled = false
        cancelButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        //Subscribe to keyboard notifications:
        subscribeToKeyboardNotification()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTextFields(textFields: [UITextField!]){
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        for textField in textFields{
            textField.textAlignment = .Center
            textField.delegate = self
            textField.defaultTextAttributes = memeTextAttributes
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func displayKeyboard(notification: NSNotification) {
        if bottomText.isFirstResponder()==true/*selectedTextField == bottomText*/ && self.view.frame.origin.y == 0.0 {
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
    
    func imagePickerController(picker:UIImagePickerController, didFinishPickingImage image:UIImage, editingInfo:[String : AnyObject]?){
        self.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = image
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    func createMemedImage() -> UIImage {
        ToolBar.hidden=true
        NaviBar.hidden=true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ToolBar.hidden=false
        NaviBar.hidden=false
        return memedImage
    }
    
    func save(){
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: createMemedImage())
        print("Insdie save method")
    }
    
    func pickImageFrom(source: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        imagePickerController.allowsEditing = false
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            pickImageFrom(UIImagePickerControllerSourceType.PhotoLibrary)
        }
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
               pickImageFrom(UIImagePickerControllerSourceType.Camera)
        
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        let imageToShare = createMemedImage()
        let activityItems = [imageToShare]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler={
            (activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            if (!completed) {
                return
            }
        self.save()
        self.dismissViewControllerAnimated(true, completion:nil)
        }
    }
}

