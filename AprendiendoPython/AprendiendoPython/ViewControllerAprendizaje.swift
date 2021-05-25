//
//  ViewControllerAprendizaje.swift
//  AprendiendoPython
//
//  Created by Diego Garcia Rodriguez del Campo on 20/04/21.
//

import UIKit

extension String {
  func toJSON() -> Any? {
    guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  }
}

class ViewControllerAprendizaje: UIViewController, UITableViewDataSource, UITableViewDelegate, ProtocolSelectTemplate {
    

    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fwdBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var chooseTempBtn: UIButton!
    
    var cont = 0
    var if_return = 0
    
    var arr: [Linea] = []
    var pasos: [Paso] = []
    
    var selectedTemplate = 1
    
    /*
    var arr = [
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
        Paso(numLinea: 8, op: [["x",["var7","-",["10", "*", "cont"]]]]),
    ]
    
     
     var arr = [
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
     ]*/
     
     
    
    var vars: [String] = []
    
    var currStep = -1
    
    var isInEdit = false
    
    var templates : [Template] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        templates = configValues.getPlist()
        loadCodeView()
        chooseTempBtn.setTitle(templates[selectedTemplate].title, for: .normal)
    }
    
    func loadCodeView() {
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
        // Do any additional setup after loading the view.
    }
    
    func clearCodeView() {
        cont = 0
        if_return = 0
        vars = []
        tableView.reloadData()
        currStep = -1
        codeView.subviews.forEach { view in
            view.removeConstraints(view.constraints)
            view.removeFromSuperview()
        }
    }
    
    func getRandomNum() -> Int {
        return Int.random(in: 1...15)
    }
    
    func resetStepVars() {
        if(currStep != -1){
            vars = []
            for p in pasos[currStep].op {
                // print(p[0] + ": " + getOpRes(p: p))
                vars.append("\(p[0]): \(getOpRes(p: p[1]))")
            }
            tableView.reloadData()
        }
    }
    
    func evalCond(st : [Any]) -> Bool {
        if st.count != 3 {
            return true
        }
        let fst : Int = Int(getOpRes(p: st[0]))!
        let snd : Int = Int(getOpRes(p: st[2]))!
        
        switch "\(st[1])" {
            case ">":
                return (fst > snd)
            case "<":
                return (fst < snd)
            case ">=":
                return (fst >= snd)
            case "<=":
                return (fst <= snd)
            case "==":
                return (fst == snd)
            default:
                return false
        }
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
    
    @IBAction func simBack(_ sender: UIButton) {
        if currStep - 1 >= 0 {
            if pasos[currStep].cond != nil {
                
                // Quita color paso actual
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .clear
                
                // Si entra es while si no es if
                if pasos[currStep].cond![1] is Array<Int> {
                    if (pasos[currStep].cond![0] as! [Any]).count > 0 && cont == 0 {
                        currStep -= 1
                    } else {
                        let bef = pasos[currStep].cond![1] as! [Int]
                        currStep = bef[0];
                        if (pasos[currStep].cond![0] as! [Any]).count > 0 {
                            cont -= 1
                        }
                    }
                } else {
                    if pasos[currStep].cond!.count == 4 {
                        if if_return == 1 {
                            currStep = pasos[currStep].cond![2] as! Int
                        } else if if_return == -1 {
                            currStep = pasos[currStep].cond![3] as! Int
                        }
                    }
                    else if (pasos[currStep].cond![0] as! [Any]).count > 0 {
                        currStep -= 1
                    } else {
                        let bef = pasos[currStep].cond![2] as! Int
                        currStep = bef
                    }
                }
                // Pon color a nuevo paso
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .red
            }
            else {
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .clear
                currStep -= 1
                
                if pasos[currStep].cond != nil &&
                    pasos[currStep].cond![1] is Array<Int> {
                    let aft = pasos[currStep].cond![1] as! [Int]
                    currStep = aft[1]
                }
                
                // Cambiar fondo
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .red
                
            }
            
            // Mostrar variables
            resetStepVars()
        }
    }
    
    @IBAction func simFwd(_ sender: UIButton) {
        if currStep + 1 < pasos.count {
            if currStep > -1 && pasos[currStep].cond != nil {
                
                // Quita color paso actual
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .clear
                
                
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
                    print(evalCond(st: pasos[currStep].cond![0] as! [Any]))
                    print(currStep)
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
                    print(currStep)
                    
                }
                
                // Pon color a nuevo paso
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .red
            }
            else {
                currStep += 1
                // Cambiar fondo
                arr[pasos[currStep].numLinea].lb!.backgroundColor = .red
                if currStep > 0 {
                    arr[pasos[currStep - 1].numLinea].lb!.backgroundColor = .clear
                }
            }
            
            // Mostrar variables
            resetStepVars()
        }
    }
    
    @IBAction func editTF(_ sender: UIButton) {
        var isValid = true
        if isInEdit {
            for i in 0...arr.count - 1 {
                if arr[i].hasTF {
                    if let _ = Int(arr[i].tf!.text!) {}
                    else {
                        isValid = false
                        break
                    }
                }
            }
            if(isValid) {
                for i in 0...arr.count - 1 {
                    if arr[i].hasTF {
                        arr[i].tf!.isEnabled = false
                        arr[i].tf!.backgroundColor = .clear
                    }
                }
                isInEdit = false
                sender.setTitle("Editar", for: .normal)
                fwdBtn.isHidden = false
                backBtn.isHidden = false
                resetStepVars()
            } else {
                let alert = UIAlertController(title: "Error", message: "Los datos tienen que ser numeros enteros", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        } else {
            for i in 0...arr.count - 1 {
                if arr[i].hasTF {
                    arr[i].tf!.isEnabled = true
                    arr[i].tf!.backgroundColor = .white
                }
            }
            isInEdit = true
            sender.setTitle("Guardar", for: .normal)
            fwdBtn.isHidden = true
            backBtn.isHidden = true
        }
    }
    
    @IBAction func generateRandomTF(_ sender: Any) {
        for i in 0...arr.count - 1 {
            if arr[i].hasTF {
                arr[i].tf!.text = String(getRandomNum())
            }
        }
        resetStepVars()
    }
    
    
    @IBAction func returnMenu(segue: UIStoryboardSegue) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // print(vars[indexPath.row])
        cell.textLabel?.text = vars[indexPath.row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(30)
        return cell
    }
    
    func chooseTemplate(templateId: Int) {
        
        arr = []
        pasos = []
        
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
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let templateSelector = segue.destination as! ViewControllerTemplateSelector
        templateSelector.selected = selectedTemplate
        templateSelector.templates = templates
        templateSelector.delegate = self
        
        templateSelector.preferredContentSize = CGSize(width: 375, height: 236)

    }
    
    func selectTemplate(position: Int) {
        selectedTemplate = position
        clearCodeView()
        loadCodeView()
        chooseTempBtn.setTitle(templates[position].title, for: .normal)
    }

}
