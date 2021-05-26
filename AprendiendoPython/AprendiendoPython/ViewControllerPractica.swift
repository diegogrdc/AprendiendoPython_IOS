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
    var op : [[Any]]
    var cond : [Any]?
}

struct Pregunta {
    var texto : String
    var tf : UITextField?
    var lb : UILabel?
}

class ViewControllerPractica: UIViewController {
    
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var qView: UIView!
    
    var cont = 0
    var if_return = 0
    var currStep = -1
    var arr: [Linea] = []
    var pasos: [Paso] = []
    var preguntas : [Pregunta] = []
    var selectedTemplate = 0
    var templates : [Template] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        templates = configValues.getPlist()
        loadCodeView()
    }
    
    func loadCodeView () {
        chooseTemplate(templateId: selectedTemplate)
        for i in 0...arr.count - 1 {
            
            arr[i].lb = UILabel(frame: .zero);
            arr[i].lb!.text = arr[i].texto
            arr[i].lb!.font = UIFont.boldSystemFont(ofSize: 20)
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
                arr[i].tf!.text = String(getRandomNum())
                arr[i].tf!.isEnabled = false
                arr[i].tf!.backgroundColor = .clear
                codeView.addSubview(arr[i].tf!)
                NSLayoutConstraint.activate([
                    arr[i].tf!.leadingAnchor.constraint(equalTo: arr[i].lb!.trailingAnchor, constant: 20),
                    arr[i].tf!.topAnchor.constraint(equalTo: arr[i].lb!.topAnchor, constant: 0),
                    arr[i].tf!.widthAnchor.constraint(equalToConstant: 100)
                ])
            }
        }
        
        for i in 0...preguntas.count - 1 {
            
            preguntas[i].lb = UILabel(frame: .zero);
            preguntas[i].lb!.text = preguntas[i].texto
            preguntas[i].lb!.font = UIFont.boldSystemFont(ofSize: 20)
            preguntas[i].lb!.textColor = .black
            preguntas[i].lb!.contentMode = .scaleAspectFit
            preguntas[i].lb!.translatesAutoresizingMaskIntoConstraints = false
            preguntas[i].lb!.textAlignment = NSTextAlignment.center
            qView.addSubview(preguntas[i].lb!)
            if i == 0 {
                NSLayoutConstraint.activate([
                    preguntas[i].lb!.topAnchor.constraint(equalTo: qView.topAnchor, constant: 30),
                    preguntas[i].lb!.leadingAnchor.constraint(equalTo: qView.leadingAnchor, constant: 25)
                ])
            } else {
                NSLayoutConstraint.activate([
                    preguntas[i].lb!.topAnchor.constraint(equalTo: preguntas[i - 1].lb!.bottomAnchor, constant: 10),
                    preguntas[i].lb!.leadingAnchor.constraint(equalTo: qView.leadingAnchor, constant: 25)
                ])
            }
            
            preguntas[i].tf = UITextField()
            preguntas[i].tf!.backgroundColor = .white
            preguntas[i].tf!.contentMode = .scaleAspectFit
            preguntas[i].tf!.translatesAutoresizingMaskIntoConstraints = false
            preguntas[i].tf!.isEnabled = true
            qView.addSubview(preguntas[i].tf!)
            NSLayoutConstraint.activate([
                preguntas[i].tf!.leadingAnchor.constraint(equalTo: preguntas[i].lb!.trailingAnchor, constant: 20),
                preguntas[i].tf!.topAnchor.constraint(equalTo: preguntas[i].lb!.topAnchor, constant: 0),
                preguntas[i].tf!.widthAnchor.constraint(equalToConstant: 100)
                ])
        }
    }
    
    func chooseTemplate(templateId: Int) {
        
        arr = []
        pasos = []
        preguntas = []
        
        for code in templates[templateId].code {
            arr.append(Linea(texto: code.line, hasTF: code.hasTf, tf: nil, lb: nil))
        }
        
        for simulation in templates[templateId].simulation {
            if !simulation.hascond {
                pasos.append(Paso(numLinea: simulation.line, op: simulation.operation.toJSON() as! [[Any]]))
            } else {
                pasos.append(Paso(numLinea: simulation.line, op: simulation.operation.toJSON() as! [[Any]], cond: simulation.condition.toJSON() as? [Any]))
            }
        }
        
        for questions in templates[templateId].questions {
            preguntas.append(Pregunta(texto: questions.line, tf: nil, lb: nil))
        }
        
    }
    
    func clearCodeView() {
        cont = 0
        if_return = 0
        currStep = -1
        codeView.subviews.forEach { view in
            view.removeConstraints(view.constraints)
            view.removeFromSuperview()
        }
        qView.subviews.forEach { view in
            view.removeConstraints(view.constraints)
            view.removeFromSuperview()
        }
    }
    
    func getRandomNum() -> Int {
        return Int.random(in: 1...100)
    }
    
    func getNumber(num: String) -> Int {
        if num.hasPrefix("var") {
            let num2 = num.dropFirst(3)
            return Int(arr[Int(num2)!].tf!.text!)!
        } else if num.hasPrefix("cont") {
            return cont
        } else if num.hasPrefix("if_return") {
            return if_return
        }else {
            return Int(num)!
        }
    }
    
    func evalCond(st : [Any]) -> Bool {
        if st.count != 3 {
            return true
        }
        let fst = getOpRes(p: st[0])
        let snd = getOpRes(p: st[2])
        switch "\(st[1])" {
            case ">":
                return fst > snd
            case "<":
                return fst < snd
            case ">=":
                return fst >= snd
            case "<=":
                return fst <= snd
            case "==":
                return fst == snd
            default:
                return true
        }
    }
    
    
    func getOpRes(p : Any) -> String {
        if let pArr = p as? [Any] {
            var acum = 0
            switch "\(pArr[1])" {
                case "+":
                    acum = getNumber(num: getOpRes(p: pArr[0])) + getNumber(num: getOpRes(p: pArr[2]))
                case "-":
                    acum = getNumber(num: getOpRes(p: pArr[0])) - getNumber(num: getOpRes(p: pArr[2]))
                case "*":
                    acum = getNumber(num: getOpRes(p: pArr[0])) * getNumber(num: getOpRes(p: pArr[2]))
                case "/":
                    acum = getNumber(num: getOpRes(p: pArr[0])) / getNumber(num: getOpRes(p: pArr[2]))
                default:
                    return "1"
            }
            for index in stride(from: 3, to: pArr.count, by: 2){
                switch "\(pArr[index])" {
                    case "+":
                        acum += getNumber(num: getOpRes(p: pArr[index+1]))
                    case "-":
                        acum -= getNumber(num: getOpRes(p: pArr[index+1]))
                    case "*":
                        acum *= getNumber(num: getOpRes(p: pArr[index+1]))
                    case "/":
                        acum /= getNumber(num: getOpRes(p: pArr[index+1]))
                    default:
                        return "1"
                }
            }
            return String(acum)
        } else if let pStr = p as? String {
            return String(getNumber(num: pStr))
        } else {
            return "1"
        }
    }
    
    func simFwd() {
        while currStep + 1 < pasos.count {
            if currStep > -1 && pasos[currStep].cond != nil {
                
                // Si entra es while si no es if
                if pasos[currStep].cond![1] is Array<Int> {
                    if evalCond(st: pasos[currStep].cond![0] as! [Any]) {
                        let nxt = pasos[currStep].cond![1] as! [Int]
                        cont += (pasos[currStep].cond![0] as! [Any]).count > 0 ? 1 : 0
                        currStep = nxt[1]
                    }
                    else {
                        // Exit
                        let nxt = pasos[currStep].cond![1] as! [Int]
                        currStep = nxt[2]
                    }
                    
                } else {
                    if evalCond(st: pasos[currStep].cond![0] as! [Any]) {
                        let nxt = pasos[currStep].cond![1] as! Int
                        if (pasos[currStep].cond![0] as! [Any]).count != 0 {
                            if_return = 1
                        }
                        currStep = nxt
                    } else {
                        let nxt = pasos[currStep].cond![2] as! Int
                        if (pasos[currStep].cond![0] as! [Any]).count != 0 {
                            if_return = -1
                        }
                        currStep = nxt
                    }
                    
                }
                
            }
            else {
                currStep += 1
            }
        }
    }
    
    
    @IBAction func btRevisar(_ sender: UIButton) {
        simFwd()
        let p = pasos[pasos.count-1].op 
        for i in 0...preguntas.count - 1 {
            if let _ = Int((preguntas[i].tf?.text!)!){
                if preguntas[i].tf?.text == getOpRes(p: p[i][1]){
                    preguntas[i].tf?.textColor = .green
                }
                else {
                    preguntas[i].tf?.textColor = .red
                }
                preguntas[i].tf?.isEnabled = false
                preguntas[i].tf?.backgroundColor = .clear
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Tienes que llenar el campo de la pregunta " + String(i+1) + " con números enteros", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btNext(_ sender: UIButton) {
        if selectedTemplate < 7 {
            selectedTemplate += 1
            clearCodeView()
            loadCodeView()
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

/*var arr = [
    Linea(texto: "def suma(first, second)", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    s = first + second", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    return s", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "def main()", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    a = ", hasTF: true, tf: nil, lb: nil),
    Linea(texto: "    b = ", hasTF: true, tf: nil, lb: nil),
    Linea(texto: "    c = suma(a, b)", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "main()", hasTF: false, tf: nil, lb: nil)
]

var pasos = [
    Paso(numLinea: 10, op: []),
    Paso(numLinea: 5, op: []),
    Paso(numLinea: 6, op: [["a","var6"]]),
    Paso(numLinea: 7, op: [["a","var6"], ["b","var7"]]),
    Paso(numLinea: 8, op: [["a","var6"], ["b","var7"]]),
    Paso(numLinea: 0, op: [["first","var6"], ["second","var7"]]),
    Paso(numLinea: 1, op: [["first","var6"], ["second","var7"], ["s", ["var6", "+", "var7"]]]),
    Paso(numLinea: 2, op: [["first","var6"], ["second","var7"], ["s", ["var6", "+", "var7"]]]),
    Paso(numLinea: 8, op: [["a","var6"], ["b","var7"], ["c",["var6","+", "var7"]]])
]

var preguntas = [
    Pregunta(texto: "a = ?", tf: nil, lb: nil),
    Pregunta(texto: "b = ?", tf: nil, lb: nil),
    Pregunta(texto: "c = ?", tf: nil, lb: nil)
]*/

/*var arr = [
    Linea(texto: "def cond(n)", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    while n > 0:", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "        n = n - 10", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    return n", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "def main()", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    x = ", hasTF: true, tf: nil, lb: nil),
    Linea(texto: "    y = cond(x)", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "main()", hasTF: false, tf: nil, lb: nil)
]

var pasos = [
    Paso(numLinea: 10, op: []),
    Paso(numLinea: 6, op: []),
    Paso(numLinea: 7, op: [["x","var7"]]),
    Paso(numLinea: 8, op: [["x","var7"]]),
    Paso(numLinea: 0, op: [["n","var7"]]),
    Paso(numLinea: 1, op: [["n",["var7","-",["10", "*", "cont"]]]], cond: [[["var7","-",["10", "*", "cont"]],">","0"], [6, 6, 7]]),
    Paso(numLinea: 2, op: [["n",["var7","-",["10", "*", "cont"]]]], cond: [[], [5, 5, 0]]),
    Paso(numLinea: 3, op: [["n",["var7","-",["10", "*", "cont"]]]]),
    Paso(numLinea: 8, op: [["y",["var7","-",["10", "*", "cont"]]]]),
]

var preguntas = [
    Pregunta(texto: "y = ?", tf: nil, lb: nil)
]*/

/*var arr = [
    Linea(texto: "def cond(n)", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    if n > 0:", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "        n = n + 10", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    else:", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "        n = n - 10", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    return n", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "def main()", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "    x = ", hasTF: true, tf: nil, lb: nil),
    Linea(texto: "    y = cond(x)", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "", hasTF: false, tf: nil, lb: nil),
    Linea(texto: "main()", hasTF: false, tf: nil, lb: nil)
]

var pasos = [
    Paso(numLinea: 12, op: []),
    Paso(numLinea: 8, op: []),
    Paso(numLinea: 9, op: [["x","var9"]]),
    Paso(numLinea: 10, op: [["x","var9"]]),
    Paso(numLinea: 0, op: [["n","var9"]]),
    Paso(numLinea: 1, op: [["n","var9"]], cond: [["var9",">","0"], 6, 8]),
    Paso(numLinea: 2, op: [["n",["var9","+","10"]]], cond: [[], 9, 5]),
    Paso(numLinea: 3, op: [], cond: [[], 8, 5]),
    Paso(numLinea: 4, op: [["n",["var9","-","10"]]], cond: [[], 9, 5]),
    Paso(numLinea: 5, op: [["n",["var9","+",["10", "*", "if_return"]]]], cond: [[], 10, 6, 8]),
    Paso(numLinea: 10, op: [["y",["var9","+",["10", "*", "if_return"]]]]),
]

var preguntas = [
    Pregunta(texto: "y = ?", tf: nil, lb: nil)
]*/
