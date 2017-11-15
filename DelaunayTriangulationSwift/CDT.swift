//
//  CDT.swift
//  DelaunaySwift
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 zero. All rights reserved.
//

import Foundation


/// Simply applying Constraines on result of Delauney Triangulation.  
open class CDT : Delaunay {
    
    override open func triangulate(_ vertices: [Vertex]) -> [Triangle] {
        return self.triangulate(vertices, nil)
    }
    
    open func triangulate(_ vertices: [Vertex], _ holesVertices:[[Vertex]]?) -> [Triangle] {
        
        var verticesCopy = vertices
        var holes = [Polygon2D]()
        if let _holesVertices = holesVertices {
            for holeVertices in _holesVertices {
                verticesCopy.append(contentsOf: holeVertices)
                holes.append(Polygon2D(holeVertices))
            }
        }
        
        let triangles = super.triangulate(verticesCopy)
        
        var trianglesCopy = [Triangle]()
        let polygon = Polygon2D(vertices)
        
        let start = Date().timeIntervalSince1970
        
        // filter triangles by polygon and holes
        for item in triangles {
            var inHole = false 
            for hole in holes {
                if hole.contain(vertex: item.centroid) {
                    inHole = true
                    break
                }
            }
            if !inHole && polygon.contain(vertex: item.centroid) {
                trianglesCopy.append(item)
            }   
        }
        
        let end = Date().timeIntervalSince1970
        print("filter time: \(end - start)")
        
        return trianglesCopy
    }
} 