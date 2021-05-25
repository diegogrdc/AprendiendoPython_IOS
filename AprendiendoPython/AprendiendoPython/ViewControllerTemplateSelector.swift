//
//  ViewControllerTemplateSelector.swift
//  AprendiendoPython
//
//  Created by Daniel Trevino on 24/05/21.
//

import UIKit

protocol ProtocolSelectTemplate {
    func selectTemplate(position: Int)
}

class ViewControllerTemplateSelector: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    var templates : [Template]!
    var delegate: ProtocolSelectTemplate!
    var selected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false
        
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(selected, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }

    // MARK: - Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return templates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()//UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = templates[row].title
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.selectTemplate(position: row)
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
