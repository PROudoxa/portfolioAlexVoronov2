//
//  FavouriteTableViewController
//  TestGitHubApi
//
//  Created by Alex Voronov on 09.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit
import CoreData

class FavouriteTableViewController: UITableViewController {
    
    // MARK: Properties
    var coreDataStack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<FavRepository> = NSFetchedResultsController()
    var selectedIndexPath: IndexPath?
    
    // MARK: IBOutlets
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        coreDataStack = appDelegate.coreDataStack
        
        configureView()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editFavourite" {
            guard let navigationController = segue.destination as? UINavigationController,
                let editViewController = navigationController.topViewController as? EditFavouriteViewController,
                let indexPath = selectedIndexPath  else { fatalError("guard: Application storyboard mis-configuration") }
            
            let repositoryEntry = fetchedResultsController.object(at: indexPath)
            
            let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            childContext.parent = coreDataStack.mainContext
            let childEntry = childContext.object(with: repositoryEntry.objectID) as? FavRepository
            
            editViewController.repositoryEntry = childEntry
            editViewController.context = childContext
            editViewController.delegate = self
            
        } else if segue.identifier == "detailFavourite" {
            guard let detailViewController = segue.destination as? DetailRepoViewController,
                let indexPath = tableView.indexPathForSelectedRow else { fatalError("guard: Application storyboard mis-configuration") }
            
            let repositoryEntry = fetchedResultsController.object(at: indexPath)
            
            detailViewController.repositoryEntry = repositoryEntry
            detailViewController.saveButtonHidden = true
        }
    }
}

// MARK: IBActions
extension FavouriteTableViewController {
    
    //    @IBAction func exportButtonTapped(_ sender: UIBarButtonItem) {
    //        exportCSVFile()
    //    }
}

// MARK: Private
private extension FavouriteTableViewController {
    
    func configureView() {
        fetchedResultsController = favouriteListFetchedResultsController()
    }
    
    func configureCell(_ cell: FavouriteTableViewCell, indexPath: IndexPath) {
        let repositoryEntry = fetchedResultsController.object(at: indexPath)
        
        cell.loginOwnerLabel.text = repositoryEntry.owner ?? "some user"
        cell.stargazersCountLabel.text = "\(repositoryEntry.stargazersCount)"
        cell.nameRepoLabel.text = repositoryEntry.name ?? "user has not specified his name yet"
        cell.profileUserImageView.backgroundColor? = UIColor.gray
        
        DispatchQueue.global(qos: .background).sync {
            if let imageLink = repositoryEntry.ownerAvatarLink {
                cell.profileUserImageView.downloadedFrom(link: imageLink)
            }
        }
    }

    // MARK: Export
    // TODO: Implement export favourites to csv file
    func exportCSVFile() {
        // TODO: implement some button
        navigationItem.leftBarButtonItem = activityIndicatorBarButtonItem()
        
        coreDataStack?.storeContainer.performBackgroundTask { context in
            var results: [FavRepository] = []
            do {
                results = try context.fetch(self.favReposFetchRequest())
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
            
            let exportFilePath = NSTemporaryDirectory() + "export.csv"
            let exportFileURL = URL(fileURLWithPath: exportFilePath)
            FileManager.default.createFile(atPath: exportFilePath, contents: Data(), attributes: nil)
            
            let fileHandle: FileHandle?
            do {
                fileHandle = try FileHandle(forWritingTo: exportFileURL)
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
                fileHandle = nil
            }
            
            if let fileHandle = fileHandle {
                for repositoryEntry in results {
                    fileHandle.seekToEndOfFile()
                    guard let csvData = repositoryEntry
                        .csv()
                        .data(using: .utf8, allowLossyConversion: false) else {
                            continue
                    }
                    
                    fileHandle.write(csvData)
                }
                
                fileHandle.closeFile()
                
                print("Export Path: \(exportFilePath)")
                DispatchQueue.main.async {
                    //self.navigationItem.leftBarButtonItem = self.exportBarButtonItem()
                    self.showExportFinishedAlertView(exportFilePath)
                }
            } else {
                DispatchQueue.main.async {
                    //self.navigationItem.leftBarButtonItem = self.exportBarButtonItem()
                }
            }
        }
    }
    
    func activityIndicatorBarButtonItem() -> UIBarButtonItem {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        let barButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        
        return barButtonItem
    }
    
    //    func exportBarButtonItem() -> UIBarButtonItem {
    //        return UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportButtonTapped(_:)))
    //    }
    
    func showExportFinishedAlertView(_ exportPath: String) {
        let message = "The exported CSV file can be found at \(exportPath)"
        let alertController = UIAlertController(title: "Export Finished", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
}

// MARK: NSFetchedResultsController
private extension FavouriteTableViewController {
    
    func favouriteListFetchedResultsController() -> NSFetchedResultsController<FavRepository> {
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: favReposFetchRequest(), managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            fatalError("Error: \(error.localizedDescription)")
        }
        
        return fetchedResultController
    }
    
    func favReposFetchRequest() -> NSFetchRequest<FavRepository> {
        let fetchRequest:NSFetchRequest<FavRepository> = FavRepository.fetchRequest()
        fetchRequest.fetchBatchSize = 10
        let sortDescriptor = NSSortDescriptor(key: #keyPath(FavRepository.stargazersCount), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension FavouriteTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension FavouriteTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailFavourite", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            let repositoryEntry = self.fetchedResultsController.object(at: editActionsForRowAt)
            // TODO: add alert about deleting and give last chance to user to prevent deleting :)
            self.coreDataStack.mainContext.delete(repositoryEntry)
            self.coreDataStack.saveContext()
        }
        
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in

            self.selectedIndexPath = editActionsForRowAt
            
            self.performSegue(withIdentifier: "editFavourite", sender: nil)
        }
        
        edit.backgroundColor = .yellow
        
        return [edit, delete]
    }
}

// MARK: UITableViewDataSource
extension FavouriteTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "favouriteCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FavouriteTableViewCell else { fatalError("guard: something wrong with cell '\(cellIdentifier)'") }
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
}

// MARK: EditFavouriteViewControllerDelegate
extension FavouriteTableViewController: EditFavouriteViewControllerDelegate {
    
    func didFinish(viewController: EditFavouriteViewController, didSave: Bool) {
        
        guard didSave, let context = viewController.context, context.hasChanges else {
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
