class Field {
  float xo = 0;
  float yo = 0;
  float t = 0;
  float zoom;

  Field(float zoom) {
    this.zoom = zoom;
  }

  float value(float x, float y) {
    return (noise((x + xo) * zoom, (y + yo) * zoom, t) * 2) - 1;
  }

  void shift(float xo, float yo, float t) {
    this.t = t;
    this.xo = xo;
    this.yo = yo;
  }
}
