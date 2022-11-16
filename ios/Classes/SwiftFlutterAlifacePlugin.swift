import Flutter
import UIKit
import AliyunIdentityManager

//当前视图 ViewController;
var controller : UIViewController?;
//method管道
var channel : FlutterMethodChannel?;
//event管道
var eventChannel : FlutterEventChannel?;
//回调flutter
let eventStreamHandler = EventStreamHandler()
public class SwiftFlutterAlifacePlugin: NSObject, FlutterPlugin{

  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "flutter_aliface", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAlifacePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
    eventChannel = FlutterEventChannel(name: "ali_auth_person_plugin_event", binaryMessenger: registrar.messenger())
    eventChannel?.setStreamHandler((eventStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
    //初始化阿里SDK
    AliyunSdk.`init`();
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      //获取本机参数
      if(call.method == "getMetaInfos"){
          let info  = AliyunIdentityManager.getMetaInfo();
          var jsonData: Data? = nil
          do {
              if info != nil {
                  jsonData = try JSONSerialization.data(withJSONObject: info!, options: .prettyPrinted)
              }
          } catch  _ {
              print("(parseError.localizedDescription)");
          }
          var infoData : String? = "";
          if let jsonData = jsonData {
              infoData = String(data: jsonData, encoding: .utf8)
          };
         result(infoData);
      }else if(call.method == "verify"){
          controller = UIApplication.shared.delegate?.window??.rootViewController;
          //进行实名认证
          let  certifyId : String = String(describing: call.arguments!);
          print(certifyId);
          let extParams: [String : Any] = ["currentCtr": controller!];
          AliyunIdentityManager.sharedInstance()?.verify(with: certifyId, extParams: extParams, onCompletion: { (response) in
              DispatchQueue.main.async {
                  var resString = ""
                  switch response?.code {
                  case .ZIMResponseSuccess:
                    resString = "认证成功"
                      break;
                  case .ZIMInterrupt:
                      resString = "初始化失败"
                   break
                  case .ZIMTIMEError:
                   resString = "设备时间错误"
                   break
                  case .ZIMNetworkfail:
                   resString = "网络错误"
                   break
                  case .ZIMInternalError:
                   resString = "用户退出"
                   break
                  case .ZIMResponseFail:
                   resString = "刷脸失败"
                  default:
                      resString = "未知异常"
                      break
                  }
                  eventStreamHandler.sendEvent(event: "{'code':\(response?.code)},'msg':\(resString),'deviceToken':\(response?.deviceToken),'videoFilePath':\(response?.videoFilePath)");
              }
          })
      }else{
          result("")
      }
  }
}

class EventStreamHandler: FlutterStreamHandler {
    private var eventSink:FlutterEventSink? = nil
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    public func sendEvent(event:Any) {
        eventSink?(event)
    }
}
