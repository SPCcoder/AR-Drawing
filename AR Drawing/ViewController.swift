//
//  ViewController.swift
//  AR Drawing
//
//  Created by Apple on 11/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
    }
    @IBAction func drawButtonPressed(_ sender: Any) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // 60fps
        guard let pointOfView = sceneView.pointOfView else {return}
        
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)// transform matrix - need to learn more about this, 3rd col, row 1
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPostionOfCamera = orientation + location
        //print(orientation.x, orientation.y,orientation.z)
        
        DispatchQueue.main.async {
            if self.drawButton.isHighlighted {
                let sphereNode = SCNNode.init(geometry: SCNSphere.init(radius: 0.02))
                sphereNode.position = currentPostionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
            }else {
                let pointer = SCNNode.init(geometry: SCNSphere.init(radius: 0.01))
                pointer.position = currentPostionOfCamera
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    node.removeFromParentNode()
                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }
    }



}

func +(left: SCNVector3, right: SCNVector3)->SCNVector3{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
