//
//  DetailRepoViewController.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 09.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit
import CoreData

class DetailRepoViewController: UIViewController {
    
    // MARK: Properties
    var repository: Repository?
    var avatarImageLink: String?
    var saveButtonHidden = false
    var searchMamager = SearchManager()
    var alertData: (title: String, message: String) = ("title", "message")
    
    // TODO: use generics to cast
    var repositoryEntry: FavRepository?
    //var context: NSManagedObjectContext!

    var coreDataStack: CoreDataStack = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.coreDataStack
    }()
    
    // MARK: IBOutlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var myCommentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var showRepoButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setImage), name: NSNotification.Name(rawValue: "Favourite->Detail"), object: nil)
        
        configureView()
        configureScrollView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureScrollView()
    }
    
    func configureScrollView() {
        // FIXME: bug with double landscape rotation
        scrollView.contentInset.bottom = 0.0
        
        let width = self.view.frame.width
        let height = self.view.frame.height

        let biggerValue: CGFloat = width > height ? width : height
        
        //print("showbutton \(showRepoButton.frame.maxY)")
        
        let bottomEmptySpace: CGFloat = biggerValue - showRepoButton.frame.maxY
        
        scrollView.contentInset.bottom = -bottomEmptySpace + 100.0 // -458 + 100 = 358
        
        //print("contins: \(scrollView.contentInset.bottom)")
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRepo" {
            guard let webViewController = segue.destination as? WebRepoViewController else { return }
            
            webViewController.url = (repository?.htmlURL) ?? "http://github.com"
        }
    }
    
    deinit {
        //print("\(self) is about to be released")
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: IBActions
extension DetailRepoViewController {
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showRepoTapped(_ sender: UIButton) {
        // segue to WebViewController
    }
    
    @IBAction func saveToFavouriteTapped(_ sender: UIBarButtonItem) {
    
        guard let repo = repository else { return }
        
        let newRepositoryEntry = FavRepository(context: coreDataStack.mainContext)
        
        // TODO: consider using generic
        newRepositoryEntry.name = repo.name
        newRepositoryEntry.createdAt = repo.createdAt
        newRepositoryEntry.updatedAt = repo.updatedAt
        newRepositoryEntry.owner = repo.owner
        newRepositoryEntry.descriptions = repo.descriptions
        newRepositoryEntry.htmlURL = repo.htmlURL
        newRepositoryEntry.language = repo.language
        newRepositoryEntry.url = repo.url
        newRepositoryEntry.stargazersCount = repo.stargazersCount ?? 0
        newRepositoryEntry.ownerAvatarLink = avatarImageLink
        
        coreDataStack.saveContext()
        
        changeAlertData(successfulSaving: true)
        showAlert(title: alertData.title, message: alertData.message)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

// MARK: Private
private extension DetailRepoViewController {
    
    func convertEntity(entry: FavRepository) -> Repository {
        
        let entryRepo = Repository(owner: entry.owner, name: entry.name, descriptions: entry.descriptions, url: entry.url, htmlURL: entry.htmlURL, language: entry.language, createdAt: entry.createdAt, updatedAt: entry.updatedAt, stargazersCount: entry.stargazersCount, myComment: entry.myComment, ownerAvatarLink: entry.ownerAvatarLink)
        
        return entryRepo
    }
    
    func configureView() {
        
        // TODO: consider to use generic
        // TODO: make this func more elegant
        if let entry = repositoryEntry {
            repository = convertEntity(entry: entry)
            self.avatarImageLink = repository?.ownerAvatarLink
        }
        
        self.navigationItem.title = "Details"
        
        if saveButtonHidden {  // need to hide if comes from favourites
            navigationItem.rightBarButtonItem = nil
        }
        
        let createdStr = "\(repository?.createdAt ?? "")"
        let updatedStr = "\(repository?.updatedAt ?? "")"
        
        // cut off a tail(time)
        // TODO: implement dateFormatter
        var cre = String(createdStr.characters.dropLast(10))
        var upd = String(updatedStr.characters.dropLast(10))
        var langString = (repository?.language) ?? "you know :)"
        
        cre = "created at:  " + cre
        upd = "updated at: " + upd
        langString = "lang: " + langString
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: cre)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: 11))
        self.createdAtLabel.attributedText = myMutableString

        myMutableString = NSMutableAttributedString(string: upd)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: 11))
        self.updatedAtLabel.attributedText = myMutableString
        
        myMutableString = NSMutableAttributedString(string: langString)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: 5))
        self.langLabel.attributedText = myMutableString

        
        // TODO: diff text colors
        //self.createdAtLabel.text = "created at:   \(cre)"
        //self.updatedAtLabel.text = "updated at:  \(upd)"
        //self.langLabel.text = "lang: " + ((repository?.language) ?? "you know :)")
        
        self.myCommentLabel.text = repositoryEntry?.myComment ?? ""
        self.numberOfStarsLabel.text = "\(repository?.stargazersCount ?? 0)"

        let descrText = repository?.descriptions ?? ""
        self.descriptionLabel.text = descrText
        
        setProfileImage(imageLinkString: self.avatarImageLink)
    }
    
    @objc func setImage(notification: Notification) { // "setProfileImage" launches request and notification gets it
        guard let userInfo = notification.userInfo, let imgLink = userInfo["avatarURL"] as? String  else { return }
        
        self.avatarImage.downloadedFrom(link: imgLink)
        self.avatarImageLink = imgLink
    }
    
    func changeAlertData(successfulSaving: Bool) {
        // TODO: check if saving was successful
        //let coreDataStack = CoreDataStack_old()

        //if coreDataStack.saveFavRepo(owner: selectedRepository?.owner, name: selectedRepository?.name, descriptions: selectedRepository?.descriptions, url: selectedRepository?.url, htmlURL: selectedRepository?.htmlURL, language: selectedRepository?.language, createdAt: selectedRepository?.createdAt, updatedAt: selectedRepository?.updatedAt, stargazersCount: selectedRepository?.stargazersCount) {
        
        if successfulSaving {
            alertData.title = "Great!"
            alertData.message = "The repository has been added to your favourite list!"
        } else {
            alertData.title = "Oops!"
            alertData.message = "Could not save repository to your list :(\nTry again!"
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setProfileImage(imageLinkString: String?) {
        DispatchQueue.global(qos: .background).sync {
            if let imageLink = imageLinkString {
                self.avatarImage.downloadedFrom(link: imageLink)
            } else {
                // TODO: image link comes AFTER(only from favourites) propriate time
                // now works in pair with notification + func "setImage"
                //guard let login = repository?.owner else { return }
                //searchMamager.getUser(with: login)
            }
        }
    }
}

// MARK: RepositoryEntryDelegate
extension DetailRepoViewController: EditFavouriteViewControllerDelegate {
    
    func didFinish(viewController: EditFavouriteViewController, didSave: Bool) {
        guard didSave,
            let context = viewController.context,
            context.hasChanges else {
                dismiss(animated: true)
                return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error: \(error.localizedDescription)")
            }
            
            self.coreDataStack.saveContext()
        }
        
        dismiss(animated: true)
    }
}

// MARK: -- Some other classes extensions --

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

extension String {
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


