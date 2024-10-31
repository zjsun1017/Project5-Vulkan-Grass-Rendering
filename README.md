Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

* Zhaojin Sun
  * www.linkedin.com/in/zjsun
* Tested on: Windows 11, i9-13900HX @ 2.2GHz 64GB, RTX 4090 Laptop 16GB

### Demo GIF
The following GIF demonstrates the result of grass rendering with all culling techniques applied. To make the effects more noticeable, I’ve increased the forces acting on the grass blades. The normal of each grass blade is calculated according to the method provided in the paper, but because the shading model is relatively simple, the actual effect looks a bit peculiar.
![demo.gif](img%2Fdemo.gif)

### 1. Project Overview
This project uses Vulkan to render a grass model, with the specific algorithm primarily based on this paper: [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf). This is my first time working with Vulkan. As an API that bridges the gap between graphics engines and game engines, Vulkan exposes many low-level operations to users, which has allowed me to learn many new concepts, such as tessellation operations, while programming. Overall, although it has been challenging, it has also been very rewarding.

**Features implemented**
- Vulkan Grass Rendering Pipeline
- Grass Blades from Bezier Curve
- Grass Blades Force Simulation
- Grass Blades Culling
- Grass Blades Tessellation


### 2. Features and Performance Analysis
#### (i) Tessellation and Rendering
The following image shows the shape of the grass blades without any external forces applied. The tessellation levels for both the inner and outer contours of the grass blades are set to 10, so the grass blades appear relatively smooth.
![blades.png](img%2Fblades.png)

#### (ii) Force Simulation
The following GIF shows the rendering effect with applied forces but without any culling. Regarding wind direction, I modified the fixed wind direction in the original paper to a slowly changing direction over a larger period, making the grass effect look more realistic.
![no_culling.gif](img%2Fno_culling.gif)

#### (iii) Culling Tests
The first GIF below shows the effect of orientation culling, and the second GIF shows the effect of distance culling. Since view-frustum culling removes grass blades outside the field of view, it’s not possible to display it here. For orientation culling, I initially tried using the third column of the view matrix as the camera direction, but the result was incorrect because the view matrix is in the camera coordinate system, not the world coordinate system. After numerous attempts, I found that using the direction from the camera origin to v0 as the camera direction produced the correct effect.
![no_culling.gif](img%2Fori_culling.gif)
![no_culling.gif](img%2Fdist_culling.gif)


#### (iv) Performance Analysis
Performance analysis for grass rendering is challenging because culling largely depends on the current camera position. To observe the effects of certain culling techniques, the camera needs to be moved, but it’s difficult to ensure that each movement angle and distance is the same. Therefore, the test on how the number of grass blades impacts performance is conducted without any culling applied, as shown in the image below.
![blade_number.png](img%2Fblade_number.png)
As we can see, starting from 2^13, the GPU has already reached thread saturation, and the growth rate becomes approximately linear with the increase in the number of grass blades. When the number of grass blades is very low, the FPS estimate isn’t very accurate, but even with just one blade, the maximum FPS is around 10000. This indicates that when the GPU is not yet saturated, it can render sparse grass extremely quickly.

The following image reflects the performance improvement from culling. Interestingly, although it generally corresponds to the linear relationship shown in the previous graph, the combined effect of the three culling techniques yields a result where 1+1+1 > 3. This may be due to the compounded reduction in workload when multiple culling methods work together. Since a tolerance was set for the view-frustum, view-frustum culling only takes effect when the camera is very close to the grass, but this effect is quite significant.
![culling.png](img%2Fculling.png)