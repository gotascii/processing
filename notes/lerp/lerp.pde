void setup() {
  size(100, 100);
  noFill();
  smooth();

  // normalize a number in a range to 0-1 range
  float n = norm(50, 0, 100);
  println(n);

  // interpolate a number in 0-1 range into a differnt range
  float l = lerp(0, 100, 0.5);
  println(l);
  
  // normalize then interpolate to change ranges...or use map
  float m = map(50, 0, 100, 0, 200);
  println(m);

  // y = x ^ 4
  // Drawn in a 100 x 100 window
  // calculate all values in 0-1 range
  // then interpolate to 0-100
  int x;
  float nx;
  float y;
  for(x = 0; x < 100; x++) {
    nx = norm(x, 0, 99);
    y = pow(nx, 4);
    y = lerp(0, 99, y);
    point(x, y);
  }

  // screen goes from 0-99 so drawing at x = 100 won't show
  // for(x = 0; x <= 100; x += 5)
  // drawing in increments of 5 means the higest number we'll reach is 95
  // if we draw the line at 0 we'll never draw the line at 100 (we couldn't see it anyways)
  // so start the lines at 5 instead of 0
  // for(x = 0; x < 100; x += 5)
  for(x = 5; x < 100; x += 5) {
    // our range is 5 - 95
    nx = map(x, 5, 95, -1, 1);
    y = pow(nx, 4);
    y = lerp(0, 99, y);
    line(x, 0, x, y);
  }

  for(x = 0; x < 100; x++) {
    nx = norm(x, 0, 99);
    float y1 = pow(nx, 4);
    float y2 = nx;
    y1 = lerp(0, 254, y1);
    y2 = lerp(0, 254, y2);
    stroke(y1);
    line(x, 0, x, height/2);
    stroke(y2);
    line(x, height/2, x, height);
  }
}
