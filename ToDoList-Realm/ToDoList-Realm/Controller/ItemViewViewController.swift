//
//  ItemViewViewController.swift
//  ToDoList-Realm
//
//  Created by Jervy Umandap on 6/25/21.
//

import UIKit
import RealmSwift

class ItemViewViewController: UIViewController {
    
    public var item: ToDoListItem?
    
    private let realm = try! Realm()
    
    public var deletionHandler: (() -> Void)?
    
    private let itemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(itemLabel)
        view.addSubview(dateLabel)
        
        configure()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrash))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        itemLabel.frame = CGRect(x: 20, y: view.safeAreaInsets.top+20, width: view.width-40, height: 50)
        dateLabel.frame = CGRect(x: 20, y: itemLabel.bottom, width: view.width-40, height: 50)
    }
    
    @objc func didTapTrash() {
        guard let itemToDelete = item else {
            return
        }
        
        realm.beginWrite()
        
        realm.delete(itemToDelete)
        
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func configure() {
        guard let itemItem = item?.item,
              let itemdate = item?.date else {
            return
        }
        itemLabel.text = itemItem
        dateLabel.text = Self.dateFormatter.string(from: itemdate)
    }

}
