//BLOB DETECTION LIBRARIES
import hypermedia.video.*;
import java.awt.*;


//original bulge code
float i, j, x, y, r, t;
float q = 500;


//IMPORT DAN'S KINECT LIBRARY
import org.openkinect.*;
import org.openkinect.processing.*;


//SimpleOpenNI Library from SceneDepth ex
//import SimpleOpenNI.*;
//SimpleOpenNI  context;
//SimpleOpenNI  kinect;
//int smap;


//IMPORT THE KINECT OBJECT FOR DAN'S LIBARY
// Kinect Library object
//line below brings this error "Duplicate field MichelleAvoidBulge07_KinectOpenCV.kinect"
Kinect kinect;
PImage kinectImg;

//LEAF CODE
PImage img;
Leaf[] leaf = new Leaf[500];


//FROM FISH CODE
Hand hand;
//END FISH CODE


//FROM BLOB DETECTION
OpenCV opencv;

int w = 320;
int h = 240;
int threshold = 80;

boolean find=true;

PFont font;
//END BLOB DETETION VARIABLES


void setup () {
  //LEAF CODE
  size(630,480, P3D);
  img = loadImage("Leaf.png");
  for (int i = 0; i < leaf.length; i++){
      leaf[i] = new Leaf();
  }
  
  
  //FISH CODE
  hand = new Hand(width/2, height/2);
  //END FISH CODE
  
  //INITIALIZE KINECT OBJECT & start depth map
  kinect = new Kinect(this);
  kinect.start();
   //OPEN KINECT IMAGE
   kinect.enableIR(true);
  kinect.enableDepth(true);
  
  

  //FROM BLOB DETECTION
  //size( w*2+30, h*2+30);
  opencv = new OpenCV( this );
  opencv.allocate(width, height);
  //opencv.capture(width, height);

  //font = loadFont( "AndaleMono.vlw" );
  //textFont( font );

  println( "Drag mouse inside sketch window to change threshold" );
  println( "Press space bar to record background image" );
  //END FROM BLOB DETECTION 

  //size (600, 600, P3D);
  background (0);
  smooth ();
  noStroke ();

//  smooth();
//  img = loadImage("Leaf.png");
//  leaf = new Maple[25];
//  for (int i = 0; i < leaf.length; i ++) {
//    leaf[i] = new Maple();
//  }
}

void draw () {
  
  //KINECT
  kinectImg = kinect.getDepthImage();
  //image(kinectImg,0,0);
  
  //IMPORT THE KINECT IMAGE to pass into opencv
  //PImage depthImage =  kinect.depthImage();
   //PImage depthImage =  context.enableDepth();
   
  //to do BLOB DETECTION USING KINECT
  //you can then copy this image into OpenCV, like:
  //opencv.copy(depthImage);
  opencv.copy(kinectImg);


  //BLOB DETECTION
  opencv.read();
  //opencv.flip( OpenCV.FLIP_HORIZONTAL );

  //image( opencv.image(), 10, 10 );	            // RGB image
  //image( opencv.image(OpenCV.GRAY), 20+w, 10 );   // GRAY image
  //image( opencv.image(OpenCV.MEMORY), 10, 20+h ); // image in memory
  
  //BLOB DETECTION CONTINUED
  //opencv.absDiff();
  //opencv.threshold(threshold);
  //image( opencv.image(OpenCV.GRAY), 20+w, 20+h ); // absolute difference image
  
//  PImage vidimg = opencv.image(OpenCV.GRAY);
//  if (vidimg != null) {
//    image( vidimg, 0, 0 ); // absolute difference image
//  }
  // working with blobs
  Blob[] blobs = opencv.blobs( 100, w*h/3, 1, true );

  noFill();

  //FROM FISH CODE

  if (blobs.length >0) {//we need to pu the "if" statement in bcuz when we take the imaes of the background there is no blob detected
    Rectangle bounding_rect = blobs[0].rectangle;
    Point centroid = blobs[0].centroid;
    fill(255, 0, 0);

    fill(255);
    ellipse(centroid.x, centroid.y-0.5*bounding_rect.height, 20, 20);//plug in the fish
    hand.update(centroid.x, centroid.y-0.5*bounding_rect.height);//calls hand class

    //END FROM FISH CODE
  }

  pushMatrix();
  //translate(20+w, 20+h);

  for ( int i=0; i<blobs.length; i++ ) {

    Rectangle bounding_rect	= blobs[i].rectangle;
    float area = blobs[i].area;
    float circumference = blobs[i].length;
    Point centroid = blobs[i].centroid;
    Point[] points = blobs[i].points;

    //rectangle
    noFill();
    stroke( blobs[i].isHole ? 128 : 64 );
    rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );


    // centroid
    stroke(0, 0, 255);
    line( centroid.x-5, centroid.y, centroid.x+5, centroid.y );
    line( centroid.x, centroid.y-5, centroid.x, centroid.y+5 );
    noStroke();
    fill(0, 0, 255);
    text( area, centroid.x+5, centroid.y+5 );

//    fill(255, 0, 255, 64);
//    stroke(255, 0, 255);
//    if ( points.length>0 ) {
      int totalPoints = points.length;
      if (totalPoints > 300){
       totalPoints = 300; 
      }
//      beginShape();
//      for ( int j=0; j<totalPoints; j++ ) {
//        vertex( points[j].x, points[j].y );
//      }
//      endShape(CLOSE);
//    }

    noStroke();
    fill(255, 0, 255);
    text( circumference, centroid.x+5, centroid.y+15 );

//LEAF CODE
  background(0);
    for (int f = 0; f < leaf.length; f++){
         //leaf[i].calc(mouseX, mouseY);
         leaf[f].calc(centroid.x, centroid.y);
   leaf[f].render();
  }  

//    fill (0, 100);
//    rect (0, 0, width, height);
//    fill (q);
//    for (i = 0; i < q; i += 120)
//      for (j = 0; j < q; j += 120) {
//        //r = 2E4*0.8 / (dist (x=mouseX, y=mouseY, i, j) + 1E2);
//        r = 2E4*0.8 / (dist (x=centroid.x, y=centroid.y, i, j) + 1E2);
//        newX = (i + r*cos (t = atan2 ( j-y, i-x)));
//        newY = (j+r* sin (t));
//        image(img, int(newX), int(newY), 100, 100);
//      }
  }
  popMatrix();
  pushMatrix();
  translate(0,0,20);
text (frameRate,30,30);
  //END BLOB DETECTION
}

//void mousePressed() {
//  for (int i = 0; i <leaf.length; i ++) {
//    leaf[i].changeSpeed(3, 4);
//  }
//}

//BLOB DETECTION FUNCTIONS

void keyPressed() {
  if ( key==' ' ) opencv.remember();
}

void mouseDragged() {
  threshold = int( map(mouseX, 0, width, 0, 255) );
}

public void stop() {
  opencv.stop();
  super.stop();
}

