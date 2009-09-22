
class Camera{
// camera variables
  float xPos, yPos;
  float rotationVar;
  float elevation = 0;
  float azimuth = 0;
  float twist;
  float distance;
  float lensAngle;
  int toggleVar;
  
  boolean elevationAuto;
  boolean azimuthAuto = true;
  
  float elevationSpeed;
  float azimuthSpeed;

  Camera (float sentDistance, float sentLensAngle){
    distance     = sentDistance;
    lensAngle    = sentLensAngle;
    toggleVar    = 0;
  }
  
  void exist(){
    checkAuto();
    setCamera();
  }

  void increase(){
    azimuth       += .05;
    elevation     += .05;
  }
  
  void decrease(){
    azimuth       -= .05;
    elevation     -= .05;
  }
  
  void setRotateSpeed(float aug){
    azimuthAuto = true;
    azimuthSpeed += aug;
    elevationAuto = true;
    elevationSpeed += aug;
  }
  
  void resetAutoRotate(){
    azimuthAuto = false;
    elevationAuto = false;
    azimuthSpeed = 0.0;
    elevationSpeed = 0.0;
  }
  
  void checkAuto(){
    if (azimuthAuto){
      azimuth += azimuthSpeed;
    }
    
    if (elevationAuto){
      elevation += elevationSpeed;
    }
  }
  
  void setCamera(){  
    beginCamera();
    perspective(lensAngle, (float)xSize / (float)ySize, 1.0f, 200);
    translate(-(magnet.x), -(magnet.y), -distance);

    rotateX(elevation);
    rotateZ(-azimuth);
    endCamera();
  }
}


