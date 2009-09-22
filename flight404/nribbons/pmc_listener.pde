
class Listener implements PMListener {
  public void buttonPressed(int device){
    if (device == 0){

    } else if (device == 1){

    } else if (device == 2){

    } else if (device == 3){

    }
  }

  public void buttonUp(int device){
    if (device == 0){

    } else if (device == 1){

    } else if (device == 2){

    } else if (device == 3){

    }
  }

  public void knobTurnedRight(int device){
    if (device == 0){
      camera.distance -= 10.0;
    } else if (device == 1){
      
    } else if (device == 2){

    } else if (device == 3){
      magnet.z += 5.0;
    }
  }

  public void knobTurnedLeft(int device){
    if (device == 0){
      camera.distance += 10.0;
    } else if (device == 1){

    } else if (device == 2){

    } else if (device == 3){
      magnet.z -= 5.0;
    }
  }

  public void pressTurnRight(int device){
    if (device == 0){

    } else if (device == 1){

    } else if (device == 2){

    } else if (device == 3){

    }
  }

  public void pressTurnLeft(int device){
    if (device == 0){

    } else if (device == 1){

    } else if (device == 2){

    } else if (device == 3){

    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////  ^^^^^^^^^^^^^^
////////////////////////////////////////////////////////////////////////////////////////////////////////////  LISTENER CLASS
////////////////////////////////////////////////////////////////////////////////////////////////////////////
