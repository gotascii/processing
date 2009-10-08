
int xSize           = 600;
int ySize           = 600;
int xMid            = xSize/2;
int yMid            = ySize/2;

int count           = 0;
int maxParticles    = 200;
ArrayList particles;

Gravity gravity;

boolean dragging;

void setup(){
  size(xSize, ySize);
  ellipseMode(CENTER);
  gravity   = new Gravity();
  particles = new ArrayList();
}

void draw(){
  background(255);
  iterateList();
  gravity.exist();
  if (dragging){
    if (count < maxParticles) {
      particles.add(new Particle(count, particles, mouseX, mouseY));
      count ++;
    }
  }
}

void iterateList(){
  for (Iterator it = particles.iterator();  it.hasNext();){
    Particle particle = (Particle) it.next();
    particle.exist();
  }
}


void mousePressed(){
  dragging = true;
}

void mouseReleased(){
  dragging = false;
}
