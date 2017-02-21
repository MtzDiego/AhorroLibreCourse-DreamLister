//
//  ViewController.swift
//  Dream Lister
//
//  Created by Macbook on 2/20/17.
//  Copyright © 2017 ahorro libre. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        //generateData()
        attempFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! itemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: itemCell, indexPath: NSIndexPath){
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count>0{
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    destination.itemtoedit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attempFetch(){
        let fetchRequest: NSFetchRequest<Item>= Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: true)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        let selector = segment.selectedSegmentIndex
        if selector == 0{
            fetchRequest.sortDescriptors=[dateSort]
        }else if selector == 1{
            fetchRequest.sortDescriptors=[priceSort]
        }else if selector == 2{
            fetchRequest.sortDescriptors=[titleSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do{
            try controller.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func degmentchange(_ sender: Any) {
        attempFetch()
        tableview.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case.insert:
            if let indexPath = newIndexPath{
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath{
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath{
                let cell = tableview.cellForRow(at: indexPath) as! itemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
}

