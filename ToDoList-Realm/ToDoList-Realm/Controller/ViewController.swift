//
//  ViewController.swift
//  ToDoList-Realm
//
//  Created by Jervy Umandap on 6/25/21.
//

import UIKit
import RealmSwift

/*
 - To show list of current todo list items
 - to enter new todo list items
 - to show previoulsy entered todo list item
 
 - item
 - Date
 */

class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController {
    
    private var data = [ToDoListItem]()
    
    private let realm = try! Realm()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        title = "To-Do List"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        data = realm.objects(ToDoListItem.self).compactMap({ $0 })
        
        
        // userDefaults path
        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        let folder: String = path[0] as! String
        print("Your NSUserDefaults are stored in this folder: %@/Preferences: \(folder)")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
    }
    
    @objc private func didTapAdd() {
        let vc = EntryItemViewController()
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
    }
    
    func refresh() {
        data = realm.objects(ToDoListItem.self).compactMap({ $0 })
        tableView.reloadData()
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        cell.textLabel?.text = "Hello"
        cell.textLabel?.text = data[indexPath.row].item
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Item tapped: - \(data[indexPath.row].item)")
        
        //open the screen where we can see item info and delete
        
        let item = data[indexPath.row]
        
        let vc = ItemViewViewController()
        vc.title = item.item
        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
