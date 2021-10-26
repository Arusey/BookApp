//
//  ViewController.swift
//  BookApp
//
//  Created by Kevin Lagat on 26/10/2021.
//

import UIKit
import CoreData

class BookListViewController: UIViewController {
    
    //MARK: Variables
    
    var author: Author?
    
    var books = [Book]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Books written by Author"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }



}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil coalescing
        return author?.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)

        cell.textLabel?.text = (author?.books?[indexPath.row] as! Book).title
        return cell
    }
    
    
}

