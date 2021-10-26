//
//  AuthorListViewController.swift
//  BookApp
//
//  Created by Kevin Lagat on 26/10/2021.
//

import UIKit
import CoreData

class AuthorListViewController: UIViewController {
    
    //MARK: Variables
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var author = [Author]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Authors"
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAuthors()
    }
    
    
    @IBAction func addData(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Author", message: "Enter the author and book title", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        
        let authorTextField = alert.textFields![0]
        let bookTextField = alert.textFields![1]
        
        authorTextField.placeholder = "Enter Author"
        bookTextField.placeholder = "Enter Book"
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in

            
            let newAuthor = Author(context: self.managedObjectContext)
            newAuthor.name = authorTextField.text!
            let newBook = Book(context:  self.managedObjectContext)
            newBook.title = bookTextField.text!
            newBook.author?.name = authorTextField.text!
            newAuthor.addToBooks(newBook)
            
            self.saveEntries()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
    
    func saveEntries() {
        do {
            try managedObjectContext.save()
            print("Save successful")
        } catch {
            print("Error \(error)")
        }
        
        fetchAuthors()
    }
    
    func fetchAuthors() {
        do {
            author = try managedObjectContext.fetch(Author.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    
}
 //MARK: Conforming to tableView delegates
extension AuthorListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return author.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath)
        cell.textLabel?.text = author[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookVc = storyboard?.instantiateViewController(withIdentifier: "bookVC") as! BookListViewController
        bookVc.author = author[indexPath.row]
        self.navigationController?.pushViewController(bookVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(author[indexPath.row])
        self.saveEntries()
    }


}
