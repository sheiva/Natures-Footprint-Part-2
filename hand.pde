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
