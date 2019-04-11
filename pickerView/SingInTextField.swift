//
//  SingInTextField.swift
//  lima2019
//
//  Created by Mattia La Spina on 04/04/2019.
//  Copyright © 2019 Atos. All rights reserved.
//

import UIKit

@IBDesignable
class SingInTextField: SingInTextFieldUIVIew, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var view: SingInTextFieldUIVIew!
    
    @IBInspectable var titleText: String = "Title"
    @IBInspectable var placeholderText: String = "Placeholder"
    @IBInspectable var isDatePicker: Bool = false
    
    var myPickerView : UIPickerView!
    var datePicker = UIDatePicker()
    var pickerData = ["Picker 1" , "Picker 2" , "Picker 3" , "Picker 4","Picker 5","Picker 6"]
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! SingInTextFieldUIVIew
        
        return view
    }
    
    func setup() {
        //--
        view = loadViewFromNib() as? SingInTextFieldUIVIew
        view.frame = bounds
        
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
        //---
        view.textField.delegate = self
        view.title.text = titleText
        view.textField.placeholder = placeholderText
        
        //---
        let tapGesture = UITapGestureRecognizer(target: self.view.superview, action: #selector(self.dismissKeyboard (_:)))
        self.view.superview?.superview?.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.textField.resignFirstResponder()
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        view.textField.text = pickerData[row]
    }
    
    //MARK:- Button
    @objc func doneClick() {
        view.textField.resignFirstResponder()
    }
    
    //MARK:- TextFiled Delegate
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        if(isDatePicker){
            self.showDatePicker()
        }else{
            self.pickUp(view.textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(!isDatePicker){
            var pickerValue = true
            
            for posiblepick in pickerData {
                if(textField.text == posiblepick){
                    pickerValue = false
                }
            }
            
            if pickerValue {
                textField.text = ""
            }
        }
    }
 
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.view.textField.inputAccessoryView = toolbar
        self.view.textField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.view.textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}
