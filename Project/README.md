
### Ball Tracking and Detection


* ***Ball Detection*** is achieved by comparing the colour of the object to be detected and the colour of the video frames. The colour of the object to be detected is gven as a range. 
Then there will be a few parts of the video frame to be detected by the computer to be the object that we want to  detect as they share the same colour range. 
If there are some parts in the frame that we would not like to detect but unfortunately detected by the computer, one way to eliminate them is to set a threadhold for the area of the detected spot.

  ***In the case when the object to be detected is very small***, we can deploy the following techniques: 1. `Blurring`. The main idea is to increase the area of the colour space to be detected;
  2. `Bit masking`. This basically enables the object to be easily spotted by the computer as the picture is black and white. 3.`Cropping`. Cropping is a very nice technique because it aloows you to 
  focus on a region of a frame so the detection of the samll object will be very accurate. And the nicest of all is that we can embed the cropped picture with dectection to its original location in the 
  original frame as frame is just matrix.
  
* ***Ball Tracking*** is achieve by using opencv tracking and draw function to trace the object and store the historical ball locations to show its trail.
