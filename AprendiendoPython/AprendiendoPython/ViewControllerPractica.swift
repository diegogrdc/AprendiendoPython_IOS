//
//  ViewControllerPractica.swift
//  AprendiendoPython
//
//  Created by Diego Garcia Rodriguez del Campo on 20/04/21.
//

import UIKit

struct Linea {
    var texto : String
    var hasTF : Bool
    var tf : UITextField?
    var lb : UILabel?
}

struct Paso {
    var numLinea : Int
    var op : [[String]]
}

class ViewControllerPractica: UIViewController {
    
    @IBOutlet weak var codeView: UIView!
    
    var arr = [
        Linea(texto: "def suma(first, second)", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "    s = first + second", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "    return s", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "\n", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "\n", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "def main()", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "    a = ", hasTF: true, tf: nil, lb: nil),
        Linea(texto: "    b = ", hasTF: true, tf: nil, lb: nil),
        Linea(texto: "    c = suma(a, b)", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "\n", hasTF: false, tf: nil, lb: nil),
        Linea(texto: "main()", hasTF: false, tf: nil, lb: nil)
    ]
    
    var pasos = [
        Paso(numLinea: 10, op: []),
        Paso(numLinea: 5, op: []),
        Paso(numLinea: 6, op: [["a","=","var6"]]),
        Paso(numLinea: 7, op: [["a","=","var6"], ["b","=","var7"]]),
        Paso(numLinea: 8, op: [["a","=","var6"], ["b","=","var7"], ["c","=","suma(a,b)"]]),
        Paso(numLinea: 0, op: [["first","=","var6"], ["second","=","var7"]]),
        Paso(numLinea: 1, op: [["first","=","var6"], ["second","=","var7"], ["s", "+", "var6", "var7"]]),
        Paso(numLinea: 8, op: [["a","=","var6"], ["b","=","var7"], ["c","+","var6", "var7"]]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /* let vs = UIStackView()
        vs.axis = .vertical
        vs.alignment = .center
        vs.sizeToFit() */
        
        for i in 0...arr.count - 1 {
            
            arr[i].lb = UILabel(frame: .zero);
            arr[i].lb!.text = arr[i].texto
            arr[i].lb!.textColor = .black
            arr[i].lb!.contentMode = .scaleAspectFit
            arr[i].lb!.translatesAutoresizingMaskIntoConstraints = false
            arr[i].lb!.textAlignment = NSTextAlignment.center
            codeView.addSubview(arr[i].lb!)
            if i == 0 {
                NSLayoutConstraint.activate([
                    arr[i].lb!.topAnchor.constraint(equalTo: codeView.topAnchor, constant: 30),
                    arr[i].lb!.leadingAnchor.constraint(equalTo: codeView.leadingAnchor, constant: 25)
                ])
            } else {
                NSLayoutConstraint.activate([
                    arr[i].lb!.topAnchor.constraint(equalTo: arr[i - 1].lb!.bottomAnchor, constant: 10),
                    arr[i].lb!.leadingAnchor.constraint(equalTo: codeView.leadingAnchor, constant: 25)
                ])
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func returnMenu(segue: UIStoryboardSegue) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
