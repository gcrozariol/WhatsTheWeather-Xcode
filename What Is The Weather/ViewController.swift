//
//  ViewController.swift
//  What Is The Weather
//
//  Created by Guilherme Henrique Crozariol on 2016-12-18.
//  Copyright © 2016 Lion. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if error != nil {
                    print(error as Any)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                }
                            }
                        }
                    }
                }
                
                if message == "" {
                    message = "The weather couldn't be found. Please try again."
                }
                
                DispatchQueue.main.sync(execute: {
                    self.resultLabel?.text = message
                })
                
            }
            task.resume()
            resignFirstResponder()
        } else {
            resultLabel.text = "The weather couldn't be found. Please try again."
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeather(true)
        cityTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

