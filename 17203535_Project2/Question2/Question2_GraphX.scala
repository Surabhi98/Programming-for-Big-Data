//SURABHI AGARWAL : 17203535

// A program to determine the significance of patents using GraphX in Scala

import org.apache.spark._
import org.apache.spark.graphx._

//Loading the edges from the file 
val graph = GraphLoader.edgeListFile(sc, "cit-Patents_1m.txt")

//Computing the vertex count from the Graph
val vertexCount = graph.numVertices
//Computing the vertices
val vertices = graph.vertices
vertices.count()
//Computing the edge count
val edgeCount = graph.numEdges
//Computing the edges
val edges = graph.edges
edges.count()
//Now printing out the patents sorted by the order of significance
graph.inDegrees.sortBy(_._2, ascending=false).take(10).foreach(println)