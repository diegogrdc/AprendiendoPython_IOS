//
//  ViewControllerAprendizaje.swift
//  AprendiendoPython
//
//  Created by Diego Garcia Rodriguez del Campo on 20/04/21.
//

import UIKit

class ViewControllerAprendizaje: UIViewController {

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
        Paso(numLinea: 8, op: [["a","=","var6"], ["b","=","var7"]]),
        Paso(numLinea: 0, op: [["first","=","var6"], ["second","=","var7"]]),
        Paso(numLinea: 1, op: [["first","=","var6"], ["second","=","var7"], ["s", "+", "var6", "var7"]]),
        Paso(numLinea: 2, op: [["first","=","var6"], ["second","=","var7"], ["s", "+", "var6", "var7"]]),
        Paso(numLinea: 8, op: [["a","=","var6"], ["b","=","var7"], ["c","+","var6", "var7"]]),
    ]
    
    var currStep = -1

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
            
            if arr[i].hasTF {
                arr[i].tf = UITextField()
                arr[i].tf!.backgroundColor = .white
                arr[i].tf!.contentMode = .scaleAspectFit
                arr[i].tf!.translatesAutoresizingMaskIntoConstraints = false
                codeView.addSubview(arr[i].tf!)
                NSLayoutConstraint.activate([
                    arr[i].tf!.leadingAnchor.constraint(equalTo: arr[i].lb!.trailingAnchor, constant: 20),
                    arr[i].tf!.topAnchor.constraint(equalTo: arr[i].lb!.topAnchor, constant: 0),
                    arr[i].tf!.widthAnchor.constraint(equalToConstant: 100)
                ])
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func simBack(_ sender: UIButton) {
        if currStep - 1 >= 0 {
            currStep -= 1
            
            // Cambiar fondo
            arr[pasos[currStep].numLinea].lb!.backgroundColor = .red
            if currStep + 1 < pasos.count {
                arr[pasos[currStep + 1].numLinea].lb!.backgroundColor = .clear
            }
        }
    }
    
    func getNumber(num: String) -> Int {
        if num.hasPrefix("var") {
            let num2 = num.dropFirst(3)
            return Int(arr[Int(num2)!].tf!.text!)!
        } else {
            return Int(num)!
        }
    }
    
    func getOpRes(p : [String]) -> String {
        switch p[1] {
        case "+":
            var sum = 0
            for i in 2..<p.count {
                sum += getNumber(num: p[i])
            }
            return String(sum)
        case "=":
            return String(getNumber(num: p[2]))
        default:
            return "1"
        }
    }
    
    @IBAction func simFwd(_ sender: UIButton) {
        if currStep + 1 < pasos.count {
            currStep += 1
            
            // Cambiar fondo
            arr[pasos[currStep].numLinea].lb!.backgroundColor = .red
            if currStep > 0 {
                arr[pasos[currStep - 1].numLinea].lb!.backgroundColor = .clear
            }
            
            // Mostrar variables
            for p in pasos[currStep].op {
                print(p[0] + ": " + getOpRes(p: p))
                
            }
            
        }
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
