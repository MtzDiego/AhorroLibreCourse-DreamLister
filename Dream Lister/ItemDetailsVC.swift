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


    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var imagepick: UIImageView!
    @IBOutlet weak var titleIt: CustomTextField!
    @IBOutlet weak var Price: CustomTextField!
    @IBOutlet weak var details: CustomTextField!
    
    
    var stores = [Store]()
    var itemtype = [ItemType]()
    var itemtoedit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        //keyboard neede to hidde
        super.viewDidLoad()
        titleIt.delegate = self
        Price.delegate = self
        details.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target:nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        getStores()
        gettypes()
        if itemtoedit != nil{
            loadItemData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == storePicker{
            let store = stores[row]
            return store.name
        }else if pickerView == typePickerView{
            let types = itemtype[row]
            return types.type
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == storePicker{
            return stores.count
        }else if pickerView == typePickerView{
            return itemtype.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
    func gettypes(){
        let fetchRequest: NSFetchRequest<ItemType>=ItemType.fetchRequest()
        do{
            self.itemtype = try context.fetch(fetchRequest)
            self.typePickerView.reloadAllComponents()
        }catch{
            //errors
        }

    }
    //para ocultar keyboard
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
        item.toItemType = itemtype[typePickerView.selectedRow(inComponent: 0)]
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
            if let typei = item.toItemType{
                var index = 0
                repeat{
                    let s = itemtype[index]
                    if s.type == typei.type{
                        typePickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while (index < itemtype.count)
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
