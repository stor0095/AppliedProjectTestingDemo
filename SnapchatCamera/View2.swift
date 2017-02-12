//
//  View2.swift
//  SnapchatCamera
//
//  Created by Geemakun Storey on 8/26/15.
//  Copyright (c) 2015 StoreyOfGee. All rights reserved.
//

import UIKit
import PubNub
import Speech
import AVFoundation
import ApiAI

@available(iOS 10.0, *)
class View2: UIViewController, PNObjectEventListener, UITextFieldDelegate, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate{

    // MARK: Properties
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // Authorize Speech
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    // Responsible for audio input
    let audioEngine = AVAudioEngine()
    // Variable to hold speech voice string
    var voiceMessageString: String = ""
    // Array of colors
    var lowerColorsArray = ColorModel().lowerColors
    // Hold API AI text response
    var textTospeechVOICEResponse: String = ""
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Outlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var microPhoneButtonOutlet: CircleButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var messageOutputLabel: messageOutputLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegates
        appDelegate.client.addListener(self)
        self.messageTextField.delegate = self
        speechRecognizer?.delegate = self
        
        // Subscribe to PubNub test_channel
        appDelegate.client.subscribeToChannels(["test_Channel"], withPresence: true)
        
        // Disable record button until user allowes access to speech
        microPhoneButtonOutlet.isEnabled = false
        // Request access to record speech
        requestAuthorization()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        // MARK: Channel History
        // Prints out old messages from the test_channel
        self.appDelegate.client.historyForChannel("test_Channel", withCompletion: { (result, status) in
            if status == nil {
           //     print("History Output: \(result!.data.messages)")
               // let historyForChannel = result!.data.messages
            } else {
                print("Error loading history messages")
            }
            
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Recieved Message
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            
            print("Did Recieve Message: \(message.data.message!)")
            // Message has been received on channel group stored in message.data.subscription.
            // self.title = "New Message!"
        }
        else {
            
            // Message has been received on channel stored in message.data.channel.
            //self.title = "New Message!"
        }
        print("Received message: \(message.data.message) on channel \(message.data.channel) " +
            "at \(message.data.timetoken)")
        
        // UI Output if new messsage
        let recievedMessage = message.data.message as! String
        let lowerCased = recievedMessage.lowercased()
        changeBackGround(messageString: lowerCased)
       // messageOutputLabel.text = "\(recievedMessage)"
    }
    // MARK: SEND MESSAGE
    // This is where the magic happens
    // The voice or user types message is sent through the test_channel here
    func sendMessage() {
        if (messageTextField.text?.isEmpty)! {
            self.appDelegate.client.publish(voiceMessageString, toChannel: "test_Channel",
                                            compressed: false, withCompletion: { (status) in
                                                if !status.isError {
                                                    self.title = "Message Sent!"
                                                    // Message successfully published to specified channel.
                                                    //  print("SUCCESS")
                                                }
                                                else {
                                                    /**
                                                     Handle message publish error. Check 'category' property to find
                                                     out possible reason because of which request did fail.
                                                     Review 'errorData' property (which has PNErrorData data type) of status
                                                     object to get additional information about issue.
                                                     
                                                     Request can be resent using: status.retry()
                                                     */
                                                }
            })
        } else {
            let userTypedMessage = messageTextField.text
            self.appDelegate.client.publish(userTypedMessage!, toChannel: "test_Channel",
                                            compressed: false, withCompletion: { (status) in
                                                
                                                if !status.isError {
                                                    self.title = "Message Sent!"
                                                    // Message successfully published to specified channel.
                                                    //  print("SUCCESS")
                                                }
                                                else {
                                                    
                                                    /**
                                                     Handle message publish error. Check 'category' property to find
                                                     out possible reason because of which request did fail.
                                                     Review 'errorData' property (which has PNErrorData data type) of status
                                                     object to get additional information about issue.
                                                     
                                                     Request can be resent using: status.retry()
                                                     */
                                                }
            })
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microPhoneButtonOutlet.isEnabled = true
        } else {
            microPhoneButtonOutlet.isEnabled = false
        }
    }
    
    // MARK: IBOutlet to send message
    @IBAction func sendTheMessage(_ sender: UIButton) {
        //  print("Tappep")
        sendMessage()
        sendText()
        sendVoiceMessageToApiAI(message: voiceMessageString)
        messageTextField.text = ""
    }
    
    // MARK: Play Audio Outlet Action
    @IBAction func playAction(_ sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microPhoneButtonOutlet.isEnabled = false
            
        } else {
            startRecording()
            buttonStartedRecordingDesign()
        }
    }
    
    // MARK: UI Helper Methods
    func lowercasedBackgroundChange(message: String) {
        for color in lowerColorsArray {
            if message.lowercased().range(of: color) != nil {
                var newColor = UIColor.white
                switch color {
                case "blue": newColor = UIColor.blue
                case "green": newColor = UIColor.green
                case "red": newColor = UIColor.red
                case "yellow": newColor = UIColor.yellow
                case "black": newColor = UIColor.black
                case "purple": newColor = UIColor.purple
                case "orange": newColor = UIColor.orange
                case "brown": newColor = UIColor.brown
                case "silver": newColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1.0)
                case "aqua": newColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                case "gold": newColor = UIColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
                case "pink": newColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 180/255.0, alpha: 1.0)
                    
                default: break
                }
                self.view.backgroundColor = newColor
            }
        }
    }
    
    func changeBackGround(messageString: String) {
        lowercasedBackgroundChange(message: messageString)
    }
    
    func buttonStartedRecordingDesign() {
        microPhoneButtonOutlet.layer.borderWidth = 7
        microPhoneButtonOutlet.backgroundColor = UIColor.white
        microPhoneButtonOutlet.layer.borderColor = UIColor.white.cgColor
        recordLabel.text = "Recording..."
    }
    
    func buttonStoppedRecordingOriginalDesign() {
        // Reset the button and label
        self.microPhoneButtonOutlet.layer.borderWidth = 0
        self.microPhoneButtonOutlet.backgroundColor = UIColor.white
        self.microPhoneButtonOutlet.isEnabled = true
        self.recordLabel.text = "Record"
    }
    
    func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        sendMessage()
        sendText()
        messageTextField.text = ""
        return false
    }
}

// MARK: SpeechAPIRequest
@available(iOS 10.0, *)
extension View2: SpeechAPIRequest {
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                self.showAlert(title: "Whoops!", message: "User denied access to speech recognition. Change in your device settings.")
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                self.showAlert(title: "Whoops!", message: "Speech recognition restricted on this device. Change in your device settings.")
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microPhoneButtonOutlet.isEnabled = isButtonEnabled
            }
        }
        
    }
}

// MARK: SpeechAPIStartRecording
@available(iOS 10.0, *)
extension View2: SpeechAPIStartRecording {
    func startRecording() {
        // Check if recognition task is running
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
        } catch {
            print("Audio properities not set")
            showAlert(title: "Oh no!", message: "Audio properities not set. Try again later.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio Engine has no input node...")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.messageOutputLabel.text = result?.bestTranscription.formattedString
                
                let lowerCasedResultString = result!.bestTranscription.formattedString.lowercased()
                //    print("Voice output: \(lowerCasedResultString)")
                
                self.voiceMessageString = lowerCasedResultString
                
                // Setup change background
                //   self.changeBackGround(messageString: lowerCasedResultString)
                
                
                // MARK: SEND VOICE TO TEST IN REAL TIME
                self.appDelegate.client.publish(lowerCasedResultString, toChannel: "test_Channel",
                                                compressed: false, withCompletion: { (status) in
                                                    if !status.isError {
                                                        self.title = "Message Sent!"
                                                        // Message successfully published to specified channel.
                                                        //  print("SUCCESS")
                                                    }
                                                    else {
                                                        
                                                        /**
                                                         Handle message publish error. Check 'category' property to find
                                                         out possible reason because of which request did fail.
                                                         Review 'errorData' property (which has PNErrorData data type) of status
                                                         object to get additional information about issue.
                                                         
                                                         Request can be resent using: status.retry()
                                                         */
                                                    }
                })
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                
                // Reset the button and label
                self.buttonStoppedRecordingOriginalDesign()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            self.showAlert(title: "Whoops!", message: "Audio Engine didn't start. Try again later.")
            print("Audio Engine didn't start...")
        }
    }
}

@available(iOS 10.0, *)
extension View2 {
    
    func sendVoiceMessageToApiAI(message: String) {
        
        let request = ApiAI.shared().textRequest()
        
        request?.query = [message]
        
        
        request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
            
            if let jsonResult = response as? Dictionary<String, AnyObject> {
                // do whatever with jsonResult
                let result = jsonResult["result"] as? Dictionary<String, AnyObject>
                let apiMessageResult = result?["fulfillment"] as? Dictionary<String, AnyObject>
                let textToSpeechResponse = apiMessageResult!["speech"] as? String
                
                
             //   self.messageOutputLabel.text = textToSpeechResponse
                
               //  print(jsonResult)
                self.messageOutputLabel?.text = textToSpeechResponse!
            //    self.playMessage(message: textToSpeechResponse!)

                //print("VOICEAPI: \(textToSpeechResponse!)")
               // self.speak([(textToSpeechResponse!, 3.0), ("Is there anyone there?", 10.0), ("Hello?", 0.0)])
                
                self.textTospeechVOICEResponse = textToSpeechResponse!
            }
            
            //hud.hide(animated: true)
            }, failure: { (request, error) -> Void in
                print("\(error?.localizedDescription)")
                //  hud.hide(animated: true)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    func sendText() {
        
       // let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageTextField?.text {
            request?.query = [text]
        } else {
            request?.query = [""]
        }
        
        request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
            
            if let jsonResult = response as? Dictionary<String, AnyObject> {
                // do whatever with jsonResult
                let result = jsonResult["result"] as? Dictionary<String, AnyObject>
                let apiMessageResult = result?["fulfillment"] as? Dictionary<String, AnyObject>
                let textToSpeechResponse = apiMessageResult!["speech"] as? String
                
                self.messageOutputLabel.text = textToSpeechResponse
                
                // print(jsonResult)
                // self.textView?.text = textToSpeechResponse!
                self.playMessage(message: textToSpeechResponse!)
                
                self.messageTextField.resignFirstResponder()
            }
            
            //hud.hide(animated: true)
            }, failure: { (request, error) -> Void in
                print("\(error?.localizedDescription)")
              //  hud.hide(animated: true)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    func playMessage(message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        // utterance.rate = 1
        // utterance.pitchMultiplier = 0.25
        // utterance.volume = 0.75
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}



// MARK: Label Testing : IGNORE THIS

class messageOutputLabel: UILabel {
    override var text: String? {
        didSet {
            if let text = text {
            //print("Text changed.")
             //print("NEW TEXT: \(text)")
                DispatchQueue.global(qos: .background).async {
                    print("This is run on the background queue")
                    
                    let utterance = AVSpeechUtterance(string: text)
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    // utterance.rate = 1
                    
                    // utterance.pitchMultiplier = 0.25
                    
                    // utterance.volume = 0.75
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                    
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                    }
                }
            } else {
                print("Text not changed.")
            }
        }
    }
}

