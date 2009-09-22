import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
FFT fft;

void setup() {
  size(512, 300, P3D);
  minim = new Minim(this);
  player = minim.loadFile("snd.mp3", 512);
  player.loop();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.logAverages(100, 1);
  rectMode(CORNERS);
}
 
void draw() {
  background(0);  
  noStroke();
  fill(255);
 
  fft.forward(player.mix);

  rect(0, height, 100, height - fft.getAvg(0));
  rect(100, height, 200, height - fft.getAvg(1));
  rect(200, height, 300, height - fft.getAvg(2));
  rect(300, height, 400, height - fft.getAvg(3));
  rect(400, height, 500, height - fft.getAvg(4));
  println(fft.getAvg(3));
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
