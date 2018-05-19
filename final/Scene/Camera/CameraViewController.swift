//
//  CameraViewController.swift
//  final
//
//  Created by Haik Ampardjian on 12.05.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import UIKit
import AVFoundation

enum RecordMode {
    case video
    case still
    
    mutating func next() {
        switch self {
        case .video:
            self = .still
        case .still:
            self = .video
        }
    }
}

final class CameraViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    
    var recordMode: RecordMode = .video
    
    var captureSession: AVCaptureSession?
    var movieFileOut = AVCaptureMovieFileOutput()
    var stillImageOut = AVCapturePhotoOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    @IBAction func toggleMode(_ sender: Any) {
        recordMode.next()
        
        captureSession?.beginConfiguration()
        try? captureDevice?.lockForConfiguration()
        
        switch recordMode {
        case .video:
            captureSession?.removeOutput(stillImageOut)
            captureSession?.addOutput(movieFileOut)
        case .still:
            captureSession?.removeOutput(movieFileOut)
            captureSession?.addOutput(stillImageOut)
        }
        
        captureDevice?.unlockForConfiguration()
        captureSession?.commitConfiguration()
    }
    
    @IBAction func recordVideo(_ sender: Any) {
        switch recordMode {
        case .video:
            shootVideo()
        case .still:
            capturePhoto()
        }
    }
    
    @IBAction func flashToggle(_ sender: Any) {
        captureSession?.beginConfiguration()
        try? captureDevice?.lockForConfiguration()
        
        let mode = captureDevice?.torchMode ?? .off
        switch mode {
        case .off:
            captureDevice?.torchMode = .on
        default:
            captureDevice?.torchMode = .off
        }
        
        captureDevice?.unlockForConfiguration()
        captureSession?.commitConfiguration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let micDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let micInput = try AVCaptureDeviceInput(device: micDevice!)
            captureSession?.addInput(micInput)
            
            captureSession?.addOutput(movieFileOut)
            setupVideoLayer()
        } catch {
            print(error)
        }
        
    }
    
    func setupVideoLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
    }
    
    private func shootVideo() {
        if movieFileOut.isRecording {
            movieFileOut.stopRecording()
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
            let fileUrl = paths.first?.appendingPathComponent("output.mov")
            
            try? FileManager.default.removeItem(at: fileUrl!)
            
            movieFileOut.startRecording(to: fileUrl!, recordingDelegate: self)
        }
    }
    
    private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        stillImageOut.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            
            let movie = try! Data(contentsOf: outputFileURL)
            FirebaseManager.shared.uploadData(data: movie) { (error) in
                print(error == nil ? "Success" : error!.localizedDescription)
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let sampleBuffer = photoSampleBuffer,
            let previewPhoto = previewPhotoSampleBuffer,
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhoto),
            let image = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
