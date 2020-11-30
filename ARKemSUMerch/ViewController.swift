//
//  ViewController.swift
//  ARKemSUMerch
//
//  Created by Sergey Borisov on 17.09.2020.
//  Copyright © 2020 Sergey Borisov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var currentAnchor: ARImageAnchor?
    var currentPlayer: AVPlayer?
    var currentNode: SCNNode? = nil
    var currentPlane: SCNPlane?
    
//    var scnNodeCrew: SCNNode?
//    var currentARImageAnchorIdentifier: UUID?
//    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "KemSU AR Resources", bundle: .main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
//        currentPlayer?.pause()
        if currentPlayer != nil {
            currentPlayer = nil
            sceneView.session.remove(anchor: currentAnchor!)
            currentPlane?.firstMaterial?.diffuse.contents = UIColor.clear
        }
        
        currentNode = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            currentPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //
            self.currentAnchor = imageAnchor
            
            var urlString: String = ""
            if let imageAnchorName = imageAnchor.name {
                
                switch imageAnchorName {
                case "LogoKemSU":
                    urlString = ""
                case "LogoIFS":
                    urlString = ""
                case "LabImage":
                    urlString = "https://mydoc.kemsu.ru/IFS2.mp4"
                case "StudentsImage":
                    urlString = "https://mydoc.kemsu.ru/IFS3.mp4"
                case "VRImage":
                    urlString = "https://mydoc.kemsu.ru/IFS1.mp4"
                default:
                    urlString = ""
                }
            }
            
            guard let url = URL(string: urlString) else {
                print("url doesn't exist")
                return currentNode
            }
            print("url does exist!!")
            currentPlayer = AVPlayer(url: url)
            
            currentPlayer?.play()
            
//            let videoNode = SKVideoNode(url: url)
//            videoNode.play()
//
//            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
//            videoScene.addChild(videoNode)
            
            currentPlane?.firstMaterial?.diffuse.contents = currentPlayer
            
            let planeNode = SCNNode(geometry: currentPlane)
            planeNode.eulerAngles.x = -.pi / 2
            currentNode?.addChildNode(planeNode)
        }
        
        return currentNode
    }
}
