//
//  EditFavouriteViewController.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 11.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit
import CoreData

// MARK: EditFavouriteViewController
protocol EditFavouriteViewControllerDelegate {
    func didFinish(viewController: EditFavouriteViewController, didSave: Bool)
}

class EditFavouriteViewController: UIViewController {

    // MARK: Properties
    // all come from FavouriteTableViewController
    var repositoryEntry: FavRepository?
    var context: NSManagedObjectContext!
    var delegate: EditFavouriteViewControllerDelegate?
    
    // MARK: IBOutlets
    @IBOutlet weak var numberOfStarsTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var myCommentTextView: UITextView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
}

// MARK: Private
private extension EditFavouriteViewController {
    
    func configureView() {
        
        let rate = repositoryEntry?.stargazersCount ?? 0
        
        numberOfStarsTextField.text = "\(rate)"
        nameTextField.text = repositoryEntry?.name ?? "name"
        myCommentTextView.text = repositoryEntry?.myComment ?? ""
    }
    
    func updateRepositoryEntry() {
        guard let entry = repositoryEntry else { return }
        
        entry.name = nameTextField.text! 
        entry.stargazersCount = Int32(numberOfStarsTextField.text!) ?? 0
        entry.myComment = myCommentTextView.text!         
    }
    
    func goBack(with conservation: Bool) {
        if delegate != nil {
            delegate?.didFinish(viewController: self, didSave: conservation)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: IBActions
extension EditFavouriteViewController {
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        goBack(with: false)
    }
    
    @IBAction func saveTaped(_ sender: UIBarButtonItem) {
        guard let _ = Int32(numberOfStarsTextField.text!), nameTextField.text! != "" else {
            var message = "Please retype data!\n"
            if nameTextField.text! == "" {
                message += "repo's name must not be empty"
            }
            
            showAlert(title: "Wrong data", message: message)
            
            return
        }
        
        updateRepositoryEntry()
        goBack(with: true)
    }
}
