import Flutter
import UIKit

import MLKitTextRecognition
import MLKitVision


public class SwiftSimpleOcrPlugin: NSObject, FlutterPlugin {
    
    static var PARAM_IMAGE_PATH:String = "imagePath";
    static var PARAM_DELIMITER:String = "delimiter";
    static var PARAM_DEFAULT_NEWLINE:String = "\n";
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_ocr_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftSimpleOcrPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        // [tbd]
        /*case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion);
        */
        case "performOCR":
            let _params:[String:Any] = _extractParamsForMethodPerformOCR(args: call.arguments);
            guard let _imagePath:String = _params[SwiftSimpleOcrPlugin.PARAM_IMAGE_PATH] as? String else {
                result("expecting a parameter '\(SwiftSimpleOcrPlugin.PARAM_IMAGE_PATH)', BUT missing");
                return;
            }
            // testing whether filepath provided exists or not (as it might be another path instead...)
            #if DEBUG
                print("imagePath exists? \(_fileExists(filepath: _imagePath))");
            #endif
            
            guard let _delimiter:String = _params[SwiftSimpleOcrPlugin.PARAM_DELIMITER] as? String else {
                result("expecting a parameter '\(SwiftSimpleOcrPlugin.PARAM_DELIMITER)', BUT missing");
                return;
            }
            
            // so becoz... there is no return in this method... all async methods could be handle without an issue... callbacks/ closures will handle the situation perfectly
            let _engine:TextRecognizer = TextRecognizer.textRecognizer();
            let _vImage:VisionImage = VisionImage(image: UIImage.init(contentsOfFile: _imagePath)!);
            let _resultObject:ResultObject = ResultObject(code: 200, description: "ok");
            
            _engine.process(_vImage) { (regResult, error) in
                guard error == nil else {
                    _resultObject.code = 500;
                    _resultObject.description = "excpetion in recognizing the text: \(error!)";
                    
                    result("""
                        {
                          "code": 500,
                          "exception": "\(error!)"
                        }
                        """);
                    return;
                }
                if let _regResult = regResult {
                    _resultObject.text = _regResult.text.replacingOccurrences(
                        of: SwiftSimpleOcrPlugin.PARAM_DEFAULT_NEWLINE,
                        with: _delimiter);
                    _resultObject.numBlocks = _regResult.blocks.count;
                    
                    result("""
                        {
                            "code": \(_resultObject.code),
                            "text": "\(_resultObject.text)",
                            "blocks": \(_resultObject.numBlocks)
                        }
                    """);
                }
            };
            
            
        default:
            result("unknown method \(call.method)");
        }
    }
    
    func _extractParamsForMethodPerformOCR(args:Any?) -> [String:Any] {
        var params:[String:Any] = [:];
        
        guard let _args = args else {
            print("something is wrong, arguments are not supplied at all~ Expect to have a param named 'imagePath'");
            return params;
        }
        params = _args as! [String : Any];
        
        return params;
    }
    
    func _fileExists(filepath:String) -> Int {
        let fileManager = FileManager.default;
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: filepath, isDirectory: &isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                return 1;
            } else {
                // file exists and is not a directory
                return 0;
            }
        } else {
            // file does not exist
            return -1;
        }
    }
    
}


// all the following ARE obsolete for now... since this approach didn't work due to background threading issues (PITY) //


class MLKitOcr {
    // ocr engine from MLKit
    let engine:TextRecognizer = TextRecognizer.textRecognizer();
    private let _resultObject:ResultObject = ResultObject(code: 200, description: "ok");
    
    /**
        perform OCR through MLKit TextRecognizer
     
        - returns:
            a ResultObject with status code and recognized text information
     
        - parameters:
            - imagePath: path for the image
            - langs: optional language for detection (not used in this version since MLKit could only recognize latin languages)
     */
    func performOCR(_ imagePath: String, with langs: [String]) -> Result<ResultObject, SimpleOCRError> {
        var _r:Result<ResultObject, SimpleOCRError> = .failure(SimpleOCRError.runtimeError("not yet init Result"));
        
        
        // load the image from path
        if imagePath == "" {
            self._resultObject.code = 500;
            self._resultObject.description = "imagePath is invalid [\(imagePath)]";
            _r = .failure(SimpleOCRError.invalidInput("imagePath is invalid [\(imagePath)]"));
            
            return _r;
        }
        
        let _uiImage:UIImage = UIImage.init(contentsOfFile: imagePath)!;
        // build a VisionImage
        let _vImage:VisionImage = VisionImage(image: _uiImage);
        
        
        // approach async failed to "wait"
        /*
        //let semaphore = DispatchSemaphore(value: 0);
        
        engine.process(_vImage) { (regResult, error) in
            guard error == nil else {
                self._resultObject.code = 500;
                self._resultObject.description = "excpetion in recognizing the text: \(error!)";
                
                _r = .failure(SimpleOCRError.runtimeError("excpetion in recognizing the text: \(error!)"));
                
                //semaphore.signal();
                return;
            }
            if let _regResult = regResult {
                self._resultObject.text = _regResult.text;
                self._resultObject.numBlocks = _regResult.blocks.count;
                
                _r = .success(self._resultObject);
                //semaphore.signal();
            }
        };
        
        //let _newValue = semaphore.wait(timeout: .distantFuture);
        //print("value => \(_newValue):\(_newValue.hashValue) vs \(semaphore.hashValue)");
 */
        
        // approach sync... failed
        /*
        if let _text:Text = try? self.engine.results(in: _vImage) {
            self._resultObject.text = _text.text;
            self._resultObject.numBlocks = _text.blocks.count;
            
            _r = .success(self._resultObject);
            
        } else {
            self._resultObject.code = 500;
            self._resultObject.description = "excpetion in recognizing the text~";
            
            _r = .failure(SimpleOCRError.runtimeError( "excpetion in recognizing the text~" ));
        }*/
    
        // approach async and hard code; didn't wait as well
        let semaphore = DispatchSemaphore(value: 0);
        
        engine.process(_vImage, completion: { (regResult:Text?, error:Error?) -> Void in
            guard error == nil else {
                self._resultObject.code = 500;
                self._resultObject.description = "excpetion in recognizing the text: \(error!)";
                
                _r = .failure(SimpleOCRError.runtimeError("excpetion in recognizing the text: \(error!)"));
                semaphore.signal();
                return;
            }
            if let _regResult = regResult {
                self._resultObject.text = _regResult.text;
                self._resultObject.numBlocks = _regResult.blocks.count;
                
                _r = .success(self._resultObject);
                semaphore.signal();
            }
        });
        
        semaphore.wait();
        
                
        
        return _r;
    }
    
}

/// object / VO to encapsulate the OCR recognized results and status code (e.g. 200 is OK, 500 is error with description)
class ResultObject {
    var code:Int = 200;
    var description:String = "";
    var meta:Any;
    
    var text:String = "";
    var numBlocks:Int = 0;
    
    
    init(code:Int, description:String, meta:Any = "") {
        self.code = code;
        self.description = description;
        self.meta = meta;
    }
}


enum SimpleOCRError: Error {
    case runtimeError(String)
    case invalidInput(String)
}
