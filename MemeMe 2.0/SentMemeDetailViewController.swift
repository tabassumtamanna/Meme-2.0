//
//  SentMemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Tabassum Tamanna on 12/26/20.
//

import UIKit

// MARK:- SentMemeDetailViewController : UIViewController
class SentMemeDetailViewController: UIViewController {

    // MARK: -  Properties
    var meme: Meme!
    var memeIndex: Int!
    
    
    //Mark: -  Outlet
    @IBOutlet weak var memedImage: UIImageView!
    
    //Mark: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editMeme))
        
    }
    
    // MARK:- View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImage!.image = self.meme.memedImage
    }

    // MARK:- Edit Meme
    @objc func editMeme(){
        let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorViewController.isEditing = true
        memeEditorViewController.memeDelegate = self
        
        memeEditorViewController.topText = self.meme.topText
        memeEditorViewController.bottomText = self.meme.bottomText
        memeEditorViewController.image = self.meme.originalImage
        memeEditorViewController.memeIndex = self.memeIndex
       
        self.present(memeEditorViewController, animated: true, completion: nil)
    }
    
   
}
// MARK:- Extension:  Sent Meme Detail View Controller: Update Meme Delegate
extension SentMemeDetailViewController: updateMemeDelegate{
    
    func updateMeme(meme: Meme){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.meme = appDelegate.memes[memeIndex]
        self.reloadInputViews()
    }

}
