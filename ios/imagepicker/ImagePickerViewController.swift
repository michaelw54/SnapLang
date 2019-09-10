// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import SwiftyJSON
import SwiftGoogleTranslate

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var labelResults: UITextView!
    @IBOutlet weak var languagePicker: UIPickerView!
    var pickerData: [String] = [String]()
    //    @IBOutlet weak var faceResults: UITextView!
    
    var googleAPIKey = ProcessInfo.processInfo.environment["gcp_api_key"]
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        labelResults.isHidden = true
//        faceResults.isHidden = true
        spinner.hidesWhenStopped = true
        // Connect data:
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        pickerData = ["Afrikaans",
                      "Albanian",
                      "Amharic",
                      "Arabic",
                      "Armenian",
                      "Azerbaijani",
                      "Basque",
                      "Belarusian",
                      "Bengali",
                      "Bosnian",
                      "Bulgarian",
                      "Catalan",
                      "Cebuano",
                      "Chichewa",
                      "Chinese (Simplified)",
                      "Chinese (Traditional)",
                      "Corsican",
                      "Croatian",
                      "Czech",
                      "Danish",
                      "Dutch",
                      "English",
                      "Esperanto",
                      "Estonian",
                      "Filipino",
                      "Finnish",
                      "French",
                      "Frisian",
                      "Galician",
                      "Georgian",
                      "German",
                      "Greek",
                      "Gujarati",
                      "Haitian Creole",
                      "Hausa",
                      "Hawaiian",
                      "Hebrew",
                      "Hindi",
                      "Hmong",
                      "Hungarian",
                      "Icelandic",
                      "Igbo",
                      "Indonesian",
                      "Irish",
                      "Italian",
                      "Japanese",
                      "Javanese",
                      "Kannada",
                      "Kazakh",
                      "Khmer",
                      "Korean",
                      "Kurdish (Kurmanji)",
                      "Kyrgyz",
                      "Lao",
                      "Latin",
                      "Latvian",
                      "Lithuanian",
                      "Luxembourgish",
                      "Macedonian",
                      "Malagasy",
                      "Malay",
                      "Malayalam",
                      "Maltese",
                      "Maori",
                      "Marathi",
                      "Mongolian",
                      "Myanmar (Burmese)",
                      "Nepali",
                      "Norwegian",
                      "Pashto",
                      "Persian",
                      "Polish",
                      "Portuguese",
                      "Punjabi",
                      "Romanian",
                      "Russian",
                      "Samoan",
                      "Scots Gaelic",
                      "Serbian",
                      "Sesotho",
                      "Shona",
                      "Sindhi",
                      "Sinhala",
                      "Slovak",
                      "Slovenian",
                      "Somali",
                      "Spanish",
                      "Sundanese",
                      "Swahili",
                      "Swedish",
                      "Tajik",
                      "Tamil",
                      "Telugu",
                      "Thai",
                      "Turkish",
                      "Ukrainian",
                      "Urdu",
                      "Uzbek",
                      "Vietnamese",
                      "Welsh",
                      "Xhosa",
                      "Yiddish",
                      "Yoruba",
                      "Zulu"]
        // Input the data into the array
        
        SwiftGoogleTranslate.shared.start(with: googleAPIKey)
//        SwiftGoogleTranslate.shared.languages { (languages, error) in
//            if let languages = languages {
//                for language in languages {
//                    print("else if (languageName == \"" + language.name + "\") { return \"" + language.language + "\" }")
//                }
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func getLanguageCode(languageName: String) -> String? {
        if (languageName == "Afrikaans") { return "af" }
        else if (languageName == "Albanian") { return "sq" }
        else if (languageName == "Amharic") { return "am" }
        else if (languageName == "Arabic") { return "ar" }
        else if (languageName == "Armenian") { return "hy" }
        else if (languageName == "Azerbaijani") { return "az" }
        else if (languageName == "Basque") { return "eu" }
        else if (languageName == "Belarusian") { return "be" }
        else if (languageName == "Bengali") { return "bn" }
        else if (languageName == "Bosnian") { return "bs" }
        else if (languageName == "Bulgarian") { return "bg" }
        else if (languageName == "Catalan") { return "ca" }
        else if (languageName == "Cebuano") { return "ceb" }
        else if (languageName == "Chichewa") { return "ny" }
        else if (languageName == "Chinese (Simplified)") { return "zh" }
        else if (languageName == "Chinese (Traditional)") { return "zh-TW" }
        else if (languageName == "Corsican") { return "co" }
        else if (languageName == "Croatian") { return "hr" }
        else if (languageName == "Czech") { return "cs" }
        else if (languageName == "Danish") { return "da" }
        else if (languageName == "Dutch") { return "nl" }
        else if (languageName == "English") { return "en" }
        else if (languageName == "Esperanto") { return "eo" }
        else if (languageName == "Estonian") { return "et" }
        else if (languageName == "Filipino") { return "tl" }
        else if (languageName == "Finnish") { return "fi" }
        else if (languageName == "French") { return "fr" }
        else if (languageName == "Frisian") { return "fy" }
        else if (languageName == "Galician") { return "gl" }
        else if (languageName == "Georgian") { return "ka" }
        else if (languageName == "German") { return "de" }
        else if (languageName == "Greek") { return "el" }
        else if (languageName == "Gujarati") { return "gu" }
        else if (languageName == "Haitian Creole") { return "ht" }
        else if (languageName == "Hausa") { return "ha" }
        else if (languageName == "Hawaiian") { return "haw" }
        else if (languageName == "Hebrew") { return "iw" }
        else if (languageName == "Hindi") { return "hi" }
        else if (languageName == "Hmong") { return "hmn" }
        else if (languageName == "Hungarian") { return "hu" }
        else if (languageName == "Icelandic") { return "is" }
        else if (languageName == "Igbo") { return "ig" }
        else if (languageName == "Indonesian") { return "id" }
        else if (languageName == "Irish") { return "ga" }
        else if (languageName == "Italian") { return "it" }
        else if (languageName == "Japanese") { return "ja" }
        else if (languageName == "Javanese") { return "jw" }
        else if (languageName == "Kannada") { return "kn" }
        else if (languageName == "Kazakh") { return "kk" }
        else if (languageName == "Khmer") { return "km" }
        else if (languageName == "Korean") { return "ko" }
        else if (languageName == "Kurdish (Kurmanji)") { return "ku" }
        else if (languageName == "Kyrgyz") { return "ky" }
        else if (languageName == "Lao") { return "lo" }
        else if (languageName == "Latin") { return "la" }
        else if (languageName == "Latvian") { return "lv" }
        else if (languageName == "Lithuanian") { return "lt" }
        else if (languageName == "Luxembourgish") { return "lb" }
        else if (languageName == "Macedonian") { return "mk" }
        else if (languageName == "Malagasy") { return "mg" }
        else if (languageName == "Malay") { return "ms" }
        else if (languageName == "Malayalam") { return "ml" }
        else if (languageName == "Maltese") { return "mt" }
        else if (languageName == "Maori") { return "mi" }
        else if (languageName == "Marathi") { return "mr" }
        else if (languageName == "Mongolian") { return "mn" }
        else if (languageName == "Myanmar (Burmese)") { return "my" }
        else if (languageName == "Nepali") { return "ne" }
        else if (languageName == "Norwegian") { return "no" }
        else if (languageName == "Pashto") { return "ps" }
        else if (languageName == "Persian") { return "fa" }
        else if (languageName == "Polish") { return "pl" }
        else if (languageName == "Portuguese") { return "pt" }
        else if (languageName == "Punjabi") { return "pa" }
        else if (languageName == "Romanian") { return "ro" }
        else if (languageName == "Russian") { return "ru" }
        else if (languageName == "Samoan") { return "sm" }
        else if (languageName == "Scots Gaelic") { return "gd" }
        else if (languageName == "Serbian") { return "sr" }
        else if (languageName == "Sesotho") { return "st" }
        else if (languageName == "Shona") { return "sn" }
        else if (languageName == "Sindhi") { return "sd" }
        else if (languageName == "Sinhala") { return "si" }
        else if (languageName == "Slovak") { return "sk" }
        else if (languageName == "Slovenian") { return "sl" }
        else if (languageName == "Somali") { return "so" }
        else if (languageName == "Spanish") { return "es" }
        else if (languageName == "Sundanese") { return "su" }
        else if (languageName == "Swahili") { return "sw" }
        else if (languageName == "Swedish") { return "sv" }
        else if (languageName == "Tajik") { return "tg" }
        else if (languageName == "Tamil") { return "ta" }
        else if (languageName == "Telugu") { return "te" }
        else if (languageName == "Thai") { return "th" }
        else if (languageName == "Turkish") { return "tr" }
        else if (languageName == "Ukrainian") { return "uk" }
        else if (languageName == "Urdu") { return "ur" }
        else if (languageName == "Uzbek") { return "uz" }
        else if (languageName == "Vietnamese") { return "vi" }
        else if (languageName == "Welsh") { return "cy" }
        else if (languageName == "Xhosa") { return "xh" }
        else if (languageName == "Yiddish") { return "yi" }
        else if (languageName == "Yoruba") { return "yo" }
        else if (languageName == "Zulu") { return "zu" }
        else {
            return "en"
        }
    }
}


/// Image processing

extension ViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            do {
            // Use SwiftyJSON to parse results
            let json = try JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            let controller = self
            
            self.imageView.isHidden = true
//            self.labelResults.isHidden = false
//            self.faceResults.isHidden = false
//            self.faceResults.text = ""
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            } else {
                // Parse the response
//                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
//                print(labelAnnotations)
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = "Labels found: "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
//                    print(labelResultsText)
                    DispatchQueue.main.async(execute: {
                        SwiftGoogleTranslate.shared.translate(labels[0], self.getLanguageCode(languageName: self.pickerData[self.languagePicker.selectedRow(inComponent: 0)])!, "en") { (text, error) in
                            print (text, error)
                            if let t = text {
                                controller.labelResults.text = t
                                controller.labelResults.isHidden = false
                                controller.spinner.stopAnimating()
                                controller.storeWord(word: labels[0], translated: t)
                            }
                        }
                    })
                } else {
                    self.labelResults.text = "No labels found"
                    self.labelResults.isHidden = false
                    self.spinner.stopAnimating()
                }
            }
            } catch let parseError as NSError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        })
    }
    
    func storeWord(word: String?, translated: String?) {
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["english_definition": word, "foreign_definition": translated]
        //create the url with URL
        let url = URL(string: "http://3501b435.ngrok.io/api/v2/images/")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true // You could optionally display the image here by setting imageView.image = pickedImage
            spinner.startAnimating()
//            faceResults.isHidden = true
            labelResults.isHidden = true
            
            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


/// Networking

extension ViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
