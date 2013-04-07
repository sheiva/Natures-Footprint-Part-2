//BLOB DETECTION LIBRARIES
import hypermedia.video.*;
import java.awt.*;

//original bulge code
float i, j, x, y, r, t;
float q = 500;



//Declare image file
PImage img; 
//Declare the leaf

Maple[] leaf;
float xpos;
float ypos;

float newX;
float newY;

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

  //FISH CODE
  hand = new Hand(width/2, height/2);
  //END FISH CODE

  //FROM BLOB DETECTION
  size( w*2+30, h*2+30);
  opencv = new OpenCV( this );
  opencv.allocate(width, height);
  opencv.capture(width, height);

  //font = loadFont( "AndaleMono.vlw" );
  //textFont( font );

  println( "Drag mouse inside sketch window to change threshold" );
  println( "Press space bar to record background image" );
  //END FROM BLOB DETECTION 

  //size (600, 600, P3D);
  background (0);
  smooth ();
  noStroke ();

  smooth();
  img = loadImage("Leaf.png");
  leaf = new Maple[25];
  for (int i = 0; i < leaf.length; i ++) {
    leaf[i] = new Maple();
  }
}

void draw () {



  fill(255);
  //rectMode(CENTER);
  //rect (300,300,100,100);
  for (int i = 0; i < leaf.length; i++) {
    leaf[i].move();
    leaf[i].display();
  }

  //BLOB DETECTION
  opencv.read();
  //opencv.flip( OpenCV.FLIP_HORIZONTAL );

  //image( opencv.image(), 10, 10 );	            // RGB image
  //image( opencv.image(OpenCV.GRAY), 20+w, 10 );   // GRAY image
  //image( opencv.image(OpenCV.MEMORY), 10, 20+h ); // image in memory

  opencv.absDiff();
  opencv.threshold(threshold);
  //image( opencv.image(OpenCV.GRAY), 20+w, 20+h ); // absolute difference image
  PImage vidimg = opencv.image(OpenCV.GRAY);
  if (vidimg != null) {
    image( vidimg, 0, 0 ); // absolute difference image
  }
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


    fill(255, 0, 255, 64);
    stroke(255, 0, 255);
    if ( points.length>0 ) {
      beginShape();
      for ( int j=0; j<points.length; j++ ) {
        vertex( points[j].x, points[j].y );
      }
      endShape(CLOSE);
    }

    noStroke();
    fill(255, 0, 255);
    text( circumference, centroid.x+5, centroid.y+15 );

    fill (0, 100);
    rect (0, 0, width, height);
    fill (q);
    for (i = 0; i < q; i += 120)
      for (j = 0; j < q; j += 120) {
        //r = 2E4*0.8 / (dist (x=mouseX, y=mouseY, i, j) + 1E2);
        r = 2E4*0.8 / (dist (x=centroid.x, y=centroid.y, i, j) + 1E2);
        newX = (i + r*cos (t = atan2 ( j-y, i-x)));
        newY = (j+r* sin (t));
        image(img, int(newX), int(newY), 100, 100);
      }
  }
  popMatrix();

  //END BLOB DETECTION
}

void mousePressed() {
  for (int i = 0; i <leaf.length; i ++) {
    leaf[i].changeSpeed(3, 4);
  }
}

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

class Maple {
  // just a single leaf
  float xpos;
  float ypos;

  float a = random(2);
  float yspeed;

  Maple() {
    xpos = random(width);
    ypos = random(height);
  }

  void changeSpeed(float min, float max) {
    yspeed = random(min, max);
  }

  void display() {
    
    
    
    //begin rotation code

    a += 0.005;
    if (a > TWO_PI) { 
      a = 0.0;
    }
    
    pushMatrix();
    translate(xpos,ypos);
    float random1 = 0;
    rotateX(a * 3);
    rotateY(a * 4);
    //end rotation code
    image(img, random1, random1, 100, 100);
    popMatrix();
    
    
  }



  void move() {
    ypos = ypos + yspeed;
    if (ypos > width) {
      ypos = 0;
    }
  }
}
class Hand {


  float G;
  //float mass;
  public PVector location;

  Hand (float x, float y) {

    location = new PVector (x, y);
    //mass=20;
    G=5;
  }
  
  void update(float x, float y) {
    location.x = x;
    location.y = y;
  }

//  PVector attract (Fish f) {
//    PVector dir = PVector.sub(location, f.location);
//    float d= dir.mag();
//    dir.normalize();
//    d=constrain (d, 0, 50);
//    float force=G*d/1500;
//    dir.mult(force);
//    return dir;
//  }
}

