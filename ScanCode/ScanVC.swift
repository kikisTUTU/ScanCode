//
//  ScanVC.swift
//  tv_benesse
//
//  Created by TH-011 on 2018/3/28.
//

import UIKit
import AVFoundation
class ScanVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate{
    var session: AVCaptureSession?
    var deviceInput: AVCaptureDeviceInput?
    var dataOutPut: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var error: NSError?
    override func viewDidLoad() {
        super.viewDidLoad()
        let isCamera = self.cameraPermissions()
        print("isCamera: \(isCamera)")
        self.getScanCodeMessage()
        addView()
    }
    func getScanCodeMessage() {
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSessionPresetHigh
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            try deviceInput = AVCaptureDeviceInput(device: device)
            session?.addInput(deviceInput!)
        } catch {
            print("error \(error)")
        }
        dataOutPut = AVCaptureMetadataOutput()
        dataOutPut?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        dataOutPut?.rectOfInterest = CGRect(x: 0.5, y: 0, width: 0.5, height: 1)
        session?.addOutput(dataOutPut)//少判断
        dataOutPut?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        //先添加输入输出流,后设置支持的扫码所支持的格式,不然报错如下:Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[AVCaptureMetadataOutput setMetadataObjectTypes:] Unsupported type found - use -availableMetadataObjectTypes'
        //http://stackoverflow.com/questions/31063846/avcapturemetadataoutput-setmetadataobjecttypes-unsupported-type-found
        //设置扫码支持的编码格式
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(previewLayer!, at: 0)
        session?.startRunning()
    }
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            session?.stopRunning()
            let metadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject//AVMetadataMachineReadableCodeObject
            let value = metadata.stringValue
            print("value : \(String(describing: value))")
        }
    }
    let scanFrame = UIImageView()
    let scanBar = UIImageView()
    func addView() {
        scanFrame.frame = CGRect(x: 70, y: 216, width: 300, height: 300)
        scanFrame.image = #imageLiteral(resourceName: "scan_frame")
        scanBar.image = #imageLiteral(resourceName: "scan_bar")
        view.addSubview(scanFrame)

        let lbx = LineAnimation()
        lbx.startAnimatingWithRect(animationRect: CGRect(x: 70, y: 216, width: 300, height: 300), parentView: self.view, image: scanBar.image)
    }
    /**
     判断相机权限
     
     - returns: 有权限返回true，没权限返回false
     */
    func cameraPermissions() -> Bool{
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
///扫码区域动画效果
public enum LineMove
{
    case LineMoveUp   //线条上下移动
    case LineMoveDown//网格
}
