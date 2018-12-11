
***Knowns***

In this taks, we know:
* We have 3 cameras looking at the same ping-pong ball trajectory.
* [camera rotation, camera translation](https://github.com/JYL123/Image-Processing/blob/16182877a0ec16d24a85800ac12d7d62052155f5/Project/Task2/generate_one_trajectory.m#L73), and [camera orientation](https://github.com/JYL123/Image-Processing/blob/16182877a0ec16d24a85800ac12d7d62052155f5/Project/Task2/generate_one_trajectory.m#L73). In other words, we know all 3 cameras' intrinsic and extrinsic parameters.
* All 3 cameras' 2D points for the same ping-pong trajectory.

***Task***

To find out the 3D corridinate points of a ping-pong ball in each frame of a video 

***From 2D to 3D***

Many matrials make use of [Epipolar Geometry](https://en.wikipedia.org/wiki/Epipolar_geometry) to recover a 3D scene from sets of 2D scenes of cameras which are positioned differently, looking at the same 3D scene. 

In this algorithm, we make use [Persepctive projection](http://glasnost.itcarlow.ie/~powerk/GeneralGraphicsNotes/projection/perspective_projection.html) to recover 3D scene from sets of 2D scenes of different cameras at different locations looking at the same 3D scene. This is because we are given the 2D points from 3 cameras that are looking at the same 3D scene. With these 2D points, we can use calculate the corresponding 3D point locations with [perspective equations](https://math.stackexchange.com/a/2338025) with easier computation than `Epipolar Geometry` which is usually used when 2D points are unknown. 
