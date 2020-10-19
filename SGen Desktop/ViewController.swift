//
//  ViewController.swift
//  SGen Desktop
//
//  Created by Conner Vieira on 8/17/19.
//  Copyright © 2019 V0LT. All rights reserved.
//

import Cocoa
import CoreFoundation

class ViewController: NSViewController {
    var defaults = UserDefaults.standard;
    
    @IBOutlet weak var LengthValue: NSTextField!
    @IBOutlet weak var AmountValue: NSTextField!
    
    @IBOutlet var OutputArea: NSTextView!
    
    var Numbers = true
    var Lowercase = true
    var Uppercase = true
    var Special = true
    
    @IBAction func NumbersCheck(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Numbers = true;
        case .off:
            Numbers = false;
        default: break
        }
    }
    
    @IBAction func LowercaseCheck(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Lowercase = true;
        case .off:
            Lowercase = false;
        default: break
        }
    }
    
    @IBAction func UppercaseCheck(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Uppercase = true;
        case .off:
            Uppercase = false;
        default: break
        }
    }
    
    @IBAction func SpecialCheck(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Special = true;
        case .off:
            Special = false;
        default: break
        }
    }
    
    @IBAction func Generate(_ sender: Any) {
        var alphabet = Array("")
        alphabet = alphabet + Array(self.defaults.string(forKey: "BaseCharacters") ?? "")
        if (Lowercase == true) {
            alphabet = alphabet + Array("abcdefghijklmnopqrstuvwxyz")
        }
        if (Uppercase == true) {
            alphabet = alphabet + Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
        if (Numbers == true) {
            alphabet = alphabet + Array("0123456789")
        }
        if (Special == true) {
            alphabet = alphabet + Array("~!@#$%^&*()_+-={}[];:'\",./<>?")
        }
        
        
        OutputArea.string = "" //Clear output before password generation begins
        if (self.defaults.string(forKey: "SafeMode") != "off") {
            if ((AmountValue.intValue * LengthValue.intValue) > 200000) {
                let alert: NSAlert = NSAlert()
                alert.messageText = "Failed to generate!"
                alert.informativeText = "The current settings require that over 200,000 characters be generated, which could cause SGen Desktop to crash. Since you've enabled 'Safe Mode' in Preferences, the process has been terminated. If you're sure you'd like to generate this many characters, open Preferences, and disable 'Safe Mode'."
                alert.addButton(withTitle: "OK")
                let res = alert.runModal()
            } else if (String(alphabet) == "") {
                let alert: NSAlert = NSAlert()
                alert.messageText = "Failed to generate!"
                alert.informativeText = "The current character set is empty. As a result, there are no characters for SGen Desktop to choose from when generating passwords! Please either check one or more of the preset boxes, or fill in your own custom character set by going into Preferences, and entering a character set in the Base Characters field."
                alert.addButton(withTitle: "OK")
                let res = alert.runModal()
            } else {
                for _ in 0..<AmountValue.intValue { //Run X amount of times to generate X amount of passwords
                    var randomString = ""
                    for _ in 0..<LengthValue.intValue { //Run X amount of times to generate X amount of characters
                        if (alphabet.count > 0) {
                            var randomValue = Int.random(in: 0 ... alphabet.count - 1)
                            randomString = randomString + String(alphabet[randomValue])
                        } else {
                            randomString = "";
                        }
                        
                    }
                    if (OutputArea.string == "") {
                        OutputArea.string = randomString
                    } else {
                        if (self.defaults.string(forKey: "DoubleLineBreaks") == nil) {
                            OutputArea.string = OutputArea.string + "\n" + randomString
                        } else if (self.defaults.string(forKey: "DoubleLineBreaks") == "on") {
                            OutputArea.string = OutputArea.string + "\n" + "\n" + randomString
                        } else if (self.defaults.string(forKey: "DoubleLineBreaks") == "off") {
                            OutputArea.string = OutputArea.string + "\n" + randomString
                        } else {
                            OutputArea.string = OutputArea.string + "\n" + randomString
                        }
                    }
                }
            }
        } else {
            for _ in 0..<AmountValue.intValue { //Run X amount of times to generate X amount of passwords
                var randomString = ""
                for _ in 0..<LengthValue.intValue { //Run X amount of times to generate X amount of characters
                    if (alphabet.count > 0) {
                        var randomValue = Int.random(in: 0 ... alphabet.count - 1)
                        randomString = randomString + String(alphabet[randomValue])
                    } else {
                        randomString = "";
                    }
                    
                }
                if (OutputArea.string == "") {
                    OutputArea.string = randomString
                } else {
                    if (self.defaults.string(forKey: "DoubleLineBreaks") == nil) {
                        OutputArea.string = OutputArea.string + "\n" + randomString
                    } else if (self.defaults.string(forKey: "DoubleLineBreaks") == "on") {
                        OutputArea.string = OutputArea.string + "\n" + "\n" + randomString
                    } else if (self.defaults.string(forKey: "DoubleLineBreaks") == "off") {
                        OutputArea.string = OutputArea.string + "\n" + randomString
                    } else {
                        OutputArea.string = OutputArea.string + "\n" + randomString
                    }
                }
            }
        }
    }
    
    @IBAction func CopyOutput(_ sender: Any) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.writeObjects([OutputArea.string as NSString])
    }
}

class AnalysisController: NSViewController {
    
    @IBOutlet var CharacterSet: NSTextView!
    @IBOutlet var AnalysisOutput: NSTextView!
    
    
    func specificLetterCount(_ str:String, _ char:Character) -> Int {
        var count = 0
        var pos = str.startIndex
        while let range = str[pos...].range(of: String(char), options: .literal) {
            count += 1
            pos = range.upperBound
        }
        return count
    }
    
    @IBAction func RunAnalysis(_ sender: Any) {
        AnalysisOutput.string = ""
        let CharacterArray = Array(CharacterSet.string)
        
        var CharactersInString = "";
        
        for (_,element) in CharacterArray.enumerated() {
            if (CharactersInString.contains(String(element)) == false) {
                CharactersInString = CharactersInString + String(element)
            }
        }
        
        let CharactersInStringArray = Array(CharactersInString)
        
        for (_,element) in CharactersInStringArray.enumerated() {
            AnalysisOutput.string = AnalysisOutput.string + String(element) + " - " + String(specificLetterCount(CharacterSet.string, element)) + "\n"
        }
    }
}


class CharacterListController: NSViewController {
    
    @IBOutlet var CharacterSet: NSTextView!
    @IBOutlet var AnalysisOutput: NSTextView!
    
    @IBAction func RunListSystem(_ sender: Any) {
        AnalysisOutput.string = ""
        let CharacterArray = Array(CharacterSet.string)
        
        var CharactersInString = "";
        
        for (_,element) in CharacterArray.enumerated() {
            if (CharactersInString.contains(String(element)) == false) {
                CharactersInString = CharactersInString + String(element)
            }
        }
        
        AnalysisOutput.string = CharactersInString
    }
}

class DifferentCharacterCountController: NSViewController {
    
    
    @IBOutlet var CharacterSet: NSTextView!
    @IBOutlet weak var Output: NSTextField!
    
    @IBAction func RunListSystem(_ sender: Any) {
        Output.stringValue = ""
        let CharacterArray = Array(CharacterSet.string)
        
        var CharactersInString = "";
        
        for (_,element) in CharacterArray.enumerated() {
            if (CharactersInString.contains(String(element)) == false) {
                CharactersInString = CharactersInString + String(element)
            }
        }
        
        Output.stringValue = String(CharactersInString.count)
    }
}


class PossibilityCalculatorController: NSViewController {
    
    @IBOutlet weak var OutputField: NSTextField!
    
    @IBOutlet weak var CharactersSize: NSTextField!
    @IBOutlet weak var Length: NSTextField!
    
    
    
    @IBAction func CalculatePossiblities(_ sender: Any) {
        OutputField.stringValue = String(pow(CharactersSize.floatValue, Length.floatValue))
    }
}


//Preferences Class
class PreferencesController: NSViewController {
    var defaults = UserDefaults.standard;
    
    @IBOutlet weak var BaseCharacters: NSTextField!
    
    @IBOutlet weak var DoubleLineBreaks: NSButton!
    @IBOutlet weak var SafeMode: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.defaults.string(forKey: "DoubleLineBreaks") == nil) {
            DoubleLineBreaks.state = .off
        } else if (self.defaults.string(forKey: "DoubleLineBreaks") == "on") {
            DoubleLineBreaks.state = .on
        } else if (self.defaults.string(forKey: "DoubleLineBreaks") == "off") {
            DoubleLineBreaks.state = .off
        } else {
            DoubleLineBreaks.state = .off
        }
        
        if (self.defaults.string(forKey: "SafeMode") == nil) {
            SafeMode.state = .on
        } else if (self.defaults.string(forKey: "SafeMode") == "on") {
            SafeMode.state = .on
        } else if (self.defaults.string(forKey: "SafeMode") == "off") {
            SafeMode.state = .off
        } else {
            SafeMode.state = .off
        }
        
        if (self.defaults.string(forKey: "BaseCharacters") != nil) {
            BaseCharacters.stringValue = self.defaults.string(forKey: "BaseCharacters") ?? ""
        }
    }
    
    @IBAction func UpdateBaseCharacters(_ sender: Any) {
        self.defaults.register(defaults: ["BaseCharacters" : ""]);
        self.defaults.set(self.BaseCharacters.stringValue, forKey: "BaseCharacters")
    }
    
    @IBAction func SafeMode(_ sender: NSButton) {
        switch sender.state {
        case .on:
            defaults.register(defaults: ["SafeMode" : "on"]);
            defaults.set("on", forKey: "SafeMode")
        case .off:
            defaults.register(defaults: ["SafeMode" : "on"]);
            defaults.set("off", forKey: "SafeMode")
        default: break
        }
    }
    
    @IBAction func DoubleLineBreaks(_ sender: NSButton) {
        switch sender.state {
        case .on:
            defaults.register(defaults: ["DoubleLineBreaks" : "on"]);
            defaults.set("on", forKey: "DoubleLineBreaks")
        case .off:
            defaults.register(defaults: ["DoubleLineBreaks" : "off"]);
            defaults.set("off", forKey: "DoubleLineBreaks")
        default: break
        }
    }
    
}

