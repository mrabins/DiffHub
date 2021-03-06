//
//  ViewController.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/25/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pulls: [Pull] = []
    var pullCell = PullCell()
    
    @IBOutlet weak var pullTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullTableView.delegate = self
        pullTableView.dataSource = self
        navigationItem.title = "Pulls"
        
        APIHandler.callAPI({ pulls in
            self.pulls = pulls
            
            DispatchQueue.main.async {
                self.pullTableView.reloadData()
            }
            
        }) { (errorMessage) in
            print("An error occured \(errorMessage.debugDescription)")}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDiff" {
            let vc = segue.destination as! DiffVC
            let pull = sender as! Pull
            vc.pull = pull
            vc.previousOrientation = UIDevice.current.orientation.rawValue
            let backItem = UIBarButtonItem()
            backItem.title = "Return to Pulls"
            navigationItem.backBarButtonItem = backItem
            
        }
    }
}

//MARK: TableViewDelegate & TableViewDataSource Extension
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PullCell {
            
            let pull = pulls[indexPath.row]
            
            cell.avatarImageView.imageFromServerURL(urlString: pull.avatarImage!, defaultImage: "noAvatar")
            cell.authorLabel.text = "Authored By: \(String(describing: pull.author!))"
            cell.pullTextView.text = pull.pullTitle
            return cell
        }
        return PullCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulls.count
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = pullTableView.indexPathForSelectedRow
        let thePull = pulls[(indexPath?.row)!]
        APIHandler.diffRequest(diffURL: thePull.diffUrl!)
        
        performSegue(withIdentifier: "segueToDiff", sender: thePull)
        
        
    }
}
