//
//  MemeEditorViewController.swift
//  MemeMe 2.0
//
//  Created by Tabassum Tamanna on 12/23/20.
//

import UIKit
protocol updateMemeDelegate {
    func updateMeme(meme: Meme)
}

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var font: UIBarButtonItem!
    
    var topText: String!
    var bottomText: String!
    var memeIndex: Int!
    var image: UIImage!
    var memeDelegate: updateMemeDelegate?
    
    // MARK: - Meme Text Attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment    = .center
        bottomTextField.textAlignment = .center
        
        if(self.isEditing){
            self.topTextField.text = self.topText
            self.bottomTextField.text = self.bottomText
            self.imagePickerView.image = self.image
            self.shareButton.isEnabled = true
            
        } else {
            prepareTextField(textField: topTextField, defaultText:"TOP")
            prepareTextField(textField: bottomTextField, defaultText:"BOTTOM")
            self.shareButton.isEnabled = false
        }
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    // MARK: - View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Prepare Text Field
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText;
    }
    
    // MARK: - Pick an Image from camera or library
    func pickAnImage(source: UIImagePickerController.SourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Pick an Image From Album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(source: .photoLibrary)
    }
    
    // MARK: - Pick An Image From Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(source: .camera)
    }
    
    // MARK: - Choose a Font
    @IBAction func chooseFont(_ sender: Any) {
        let fontPicker = UIFontPickerViewController()
        fontPicker.delegate = self
        present(fontPicker, animated: true)
    }
    
    
    // MARK: - Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
            dismiss(animated: true, completion: nil)
            self.shareButton.isEnabled = true
        }
    }
       
    // MARK: - Image Picker Controller Did Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Font Picker View Controller Did Picj Font
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        // attempt to read the selected font descriptor, but exit quietly if that fails
        guard let descriptor = viewController.selectedFontDescriptor else { return }

        let font = UIFont(descriptor: descriptor, size: 40)
        topTextField.font = font
        bottomTextField.font = font
    }
    
    // MARK: - Text Field Did Begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    // MARK: - Text Field Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    // MARK: - Keyboard Will Show
    @objc func keyboardWillShow(_ notification: Notification){
        
        if(bottomTextField.isEditing && view.frame.origin.y == 0 ){
            view.frame.origin.y = -getKeyboardHight(notification)
        }
    }
     
    // MARK: - Keyboard Will Hide
    @objc func keyboardWillHide(_ notification: Notification){
        
            view.frame.origin.y = 0
        
    }
        
    // MARK: - Get Keyboard Hight
    func  getKeyboardHight(_ notification: Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboredSize =  userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboredSize.cgRectValue.height
    }
    
    // MARK: - Subscribe TO keyboard Notifications
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Unsubscribe TO keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Save Meme
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        if (self.isEditing){
            //Update the meme
            appDelegate.memes.remove(at: memeIndex)
            appDelegate.memes.insert(meme, at: memeIndex)
            
            memeDelegate?.updateMeme(meme: meme)
            
        } else {
            
            // Add it to the memes array in the Application Delegate
            appDelegate.memes.append(meme)
        }
         
    }
    
    // MARK: - change Tool Bar State
    func changeToolBarState(_ flag: Bool){
        self.topToolBar.isHidden = flag
        self.bottomToolBar.isHidden = flag
    }
    
    // MARK: - Generate Memed Image
    func generateMemedImage() -> UIImage {

        //  Hide toolbar and navbar
        changeToolBarState(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        changeToolBarState(false)
        
        return memedImage
    }
    
    // MARK: - Share Image
    @IBAction func shareImage(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {activity, completed, items, error in
            if completed{
                self.save()
                self.memeEditorView()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
                
    }
    
    // MARK: - Cancel Meme
    @IBAction func cancelMeme(_ sender: Any) {
        self.memeEditorView()
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Meme Editor View
    func memeEditorView(){
        
        prepareTextField(textField: topTextField, defaultText:"TOP")
        prepareTextField(textField: bottomTextField, defaultText:"BOTTOM")
        self.imagePickerView.image = nil
        self.shareButton.isEnabled = false
   }
}


