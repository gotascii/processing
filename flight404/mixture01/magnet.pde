class Magnet {
  float x;
  float y;
  float z;
  float xOff,yOff;
  float counter;
  float aug = .13;
  CellDataStruct cd;

  Magnet(float _x, float _y, CellDataStruct _cd){
    x = _x;
    y = _y;
    z = 0;
    cd = _cd;
  }

  void exist(){
    findOffset();
    setPosition();
    counter += aug;
  }

  void setPosition(){
    x += xOff;
    y += yOff;
    z = sin(counter) * 50.0;
  }
  void findOffset(){
    xOff = ((float)cd.F[0]*width/1.7 - 100 - x)/3 ;
    yOff = ((float)cd.F[1]*height/1.7 - 300 - y)/3 ;
  }
}
