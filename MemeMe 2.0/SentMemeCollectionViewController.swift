//
//  SentMemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Tabassum Tamanna on 12/24/20.
//
import Foundation
import UIKit


// MARK:- SentMemeCollectionViewController: UICollectionViewController
class SentMemeCollectionViewController: UICollectionViewController{

    // MARK:- Properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate

        return appDelegate.memes
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView?.reloadData()
    }
    
    // MARK: - Collection View  Number Of Items In Section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // MARK: - Collection View Cell For Item At
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.memedImageView?.image = meme.memedImage

        return cell
    }
    
    //MARK: - Collection View Did Selected Item At
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        // Grab the detailController from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.memeIndex = (indexPath as NSIndexPath).row

        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)

    }
    
    //MARK: - Add Meme
    @IBAction func addMeme(_ sender: Any) {
        
        let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(memeEditorViewController, animated: true, completion: nil)
    }

    
}

