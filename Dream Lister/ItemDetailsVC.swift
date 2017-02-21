//
//  ItemDetailsVC.swift
//  Dream Lister
//
//  Created by Macbook on 2/20/17.
//  Copyright © 2017 ahorro libre. All rights reserved.
//

import UIKit
import  CoreData

@available(iOS 10.0, *)
class ItemDetailsVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{


    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var imagepick: UIImageView!
    @IBOutlet weak var titleIt: CustomTextField!
    @IBOutlet weak var Price: CustomTextField!
    @IBOutlet weak var details: CustomTextField!
    var stores = [Store]()
    var itemtoedit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleIt.delegate = self
        Price.delegate = self
        details.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target:nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        let store = Store(context:context)
//        store.name = "Best Buy"
//        let store2 = Store(context:context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context:context)
//        store3.name = "Frys EA"
//        let store4 = Store(context:context)
//        store4.name = "Target"
//        let store5 = Store(context:context)
//        store5.name = "Amazon"
//        let store6 = Store(context:context)
//        store6.name = "K Mart"
//        ad.saveContext()
        
        getStores()
        if itemtoedit != nil{
            loadItemData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store>=Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }catch{
            //errors
        }
            }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func saveDatas(_ sender: Any) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = imagepick.image
        
        
        
        if itemtoedit  == nil{
            item = Item(context:context)
        }else {
            item = itemtoedit
        }
        item.toImage = picture
        
        if let title = titleIt.text{
            item.title = title
        }
        if let price = Price.text{
            item.price = (price as NSString).doubleValue
        }
        if let details = details.text{
            item.details = details
        }
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData(){
        if let item = itemtoedit {
            titleIt.text = item.title
            Price.text = "\(item.price)"
            details.text = item.details
            imagepick.image = item.toImage?.image as? UIImage
            if let store = item.toStore{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while (index < stores.count)
            }
        }
    }

    @IBAction func deletedpressed(_ sender: Any) {
        if itemtoedit != nil{
            context.delete(itemtoedit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func imagetake(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagepick.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
