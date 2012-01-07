// by andre wakko - A big tv arrived in the interactive media department
// in Calarts this week. The machinery looks so ruff that we had to put
// some sharming like the little pixel guy that looks at u when u cross over. 

import processing.opengl.*;
import processing.pdf.*;
import javax.media.opengl.GL;

import SimpleOpenNI.*; 


//Kinect
SimpleOpenNI kinect;

//OPENGL
PGraphicsOpenGL pgl; //need to use this to stop screen tearing
GL gl;

// VALUES

int closestValue; 
int lastValue;
int closestX; 
int closestY;  
float closestZ; 
float lastX; 
float lastY; 
float lastZ; 

//view
float zoom = 1;
float deg =0;


// eye
float eyeLeft;
float eyeRight;


////////////////////////////



 public void init(){
  // to make a frame not displayable, you can
  // use frame.removeNotify()

  frame.removeNotify();

  frame.setUndecorated(true); // true makes away

  // addNotify, here i am not sure if you have 
  // to add notify again.  
  frame.addNotify();
  super.init();
}



void setup() {

  size(1400, 1050,OPENGL); // 1400, 1050
  hint(ENABLE_OPENGL_4X_SMOOTH);
  background(0);

  //  background(0,0,40,10);'

  frameRate( 30 );
  hint(ENABLE_OPENGL_4X_SMOOTH);

  pgl = (PGraphicsOpenGL) g; //processing graphics object
  gl = pgl.beginGL(); //begin opengl
  gl.setSwapInterval(1); //set vertical sync on
  pgl.endGL(); //end opengl


  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  

  smooth();
}


void draw() {


  closestValue = 8000;
  kinect.update();
  
  
  
  // get the depth array from the kinect
  int[] depthValues = kinect.depthMap();


  // for each row in the depth image 
  for(int x = 0; x < 640; x++) {

    // look at each pixel in the row 
    for(int y = 0; y < 480; y++) {
      // pull out the corresponding value from the depth array 
      // the array is offset now but the image project is not direct camera not.
      int reversedX = (640-x-1); 

      int i =  reversedX + (y * 640); // position of a value in the array // offset with -x
      int currentDepthValue = depthValues[i]; 

      // look for values more enar the cam.

      int minDistance = 610;
      int maxDistance = 4000;
      // if that pixel is the closest one we've seen so far
      // 1525 is blocking how far the sensor can go.
      if(currentDepthValue > minDistance && currentDepthValue < maxDistance
        && currentDepthValue <  closestValue) { // the closest points are alreay saying 0 


        // save its value
        closestValue = currentDepthValue; // in milimeters
        // and save its position (both X and Y coordinates)
        closestX = x; // is the lowest value in the [] cause small is more milimeters 
        closestY = y;
        closestZ = map(closestValue,minDistance,maxDistance,60,0); // m
        // closestZ = currentDepthValue;
      }
    }
  }



  /////////////////// drawing code
  smooth();
  background(0); 
  
   
  //draw the depth image on the screen
  // image(kinect.depthImage(),0,0);

  //  setView();
  // scale(0.5);
  
  //strokeWeight(3);
  //stroke(0,200,colorZ,20);
  //interpolation smooth transition between last point
  // and closest point

  float interpolatedX = lerp(lastX, closestX, 0.3f);
  float interpolatedY = lerp(lastY, closestY, 0.3f);
  float interpolatedZ = lerp(lastZ, closestZ, 0.3f); 

  float colorZ = map(lastZ,0,100,255,0);
  
 // println("x:"+interpolatedX);
 // println("y:"+interpolatedY);
 // println("z:"+interpolatedZ);
  
  //float factorZ = mapinterpolatedZ
 
  
   // alpha  // blue cool
  rectMode(CENTER);  
  fill(255,255,255); // alpha  // blue cool
  rect(width/4,height/4,350,350);
  rect(width/4+ width/2,height/4,350,350);
  
  
  rectMode(CORNER);
  rect(width/4,height/6+height/2,width/2,175);


  rectMode(CENTER);
  fill(255,10,10);
  eyeLeft = map(interpolatedX,0,640,width/6,2*width/6);
  eyeRight = map(interpolatedX,0,640,(width/6)+width/2,(2*width/6)+width/2);
  
  rect(eyeLeft,height/4,50+interpolatedZ,50+interpolatedZ);
  rect(eyeRight,height/4,50+interpolatedZ,50+interpolatedZ);
  
  noStroke();

 

  //  }

  //save the previous as current.
  lastX = interpolatedX;
  lastY = interpolatedY;
  lastZ = interpolatedZ;
  lastValue = closestValue; // is the same as Z
  
};



