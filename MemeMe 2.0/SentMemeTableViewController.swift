//
//  SentMemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Tabassum Tamanna on 12/24/20.
//
import Foundation
import UIKit

// MARK: - SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
class SentMemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: Properties
    @IBOutlet weak var sentMemeTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes
    }

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sentMemeTableView.delegate = self
        self.sentMemeTableView.dataSource = self
        
    }
    
    // MARK: - View Will Apear
    override func viewWillAppear(_ animated: Bool) {
           
        super.viewWillAppear(animated)
        sentMemeTableView.reloadData()
    }
    
    // MARK:- Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // MARK: -  Table View Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell") as! SentMemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        
        cell.memedImageView?.image = meme.memedImage
        cell.memedText?.text = "\(meme.topText) ... \(meme.bottomText)"
        
        return cell
    }
    
    // MARK: -  Table View  Can Edit Row At
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: -  Table View Did Select Row At
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.memeIndex = (indexPath as NSIndexPath).row
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: -  Table View  Commit Editing Style
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: (indexPath as NSIndexPath).row)
            
            sentMemeTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    //MARK:- Add Meme
    @IBAction func addMeme(_ sender: Any) {
        
        let memeEditorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(memeEditorViewController, animated: true, completion: nil)
    }
    
}

