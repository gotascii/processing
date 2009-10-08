import processing.xml.*;

void setup() {
  size(800, 400);
  smooth();
  drawMap();
}

void draw() {
}

void drawMap() {
  background(255);

  int freq = 0;
  int amp = 8;
  float x = width/2;
  float y = height/2;
  float j = random(1);

  HashMap hm = serverCounts(1000);
  Iterator i = hm.entrySet().iterator();
  while (i.hasNext()) {
    Map.Entry me = (Map.Entry)i.next();
    freq = ((Integer)me.getValue()) * amp;

    float xpf = x + freq;
    float ypf = y + freq;
    float xmf = x - freq;
    float ymf = y - freq;
    if (xmf <= 0 || xpf >= width || ymf <= 0 || ypf >= height) {
      x = width/2;
      y = height/2;
      j += 0.5;
    }

    drawServer(x, y, freq, amp);

    j += 0.13;
    x = x + (cos(j) * freq);
    y = y + (sin(j) * freq);
  }
}

void drawServer(float x, float y, float freq, float amp) {
  noStroke();
  float ratio = amp * 7;
  float r = map(freq, 0, ratio, 0, 255);
  float b = map(freq, 0, ratio, 255, 0);
  fill(r, 0, b, r);
  ellipse(x, y, freq, freq);
}

HashMap serverCounts(int count) {
  String query = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.interestingness(" + count + ")&format=xml";
  HashMap hm = new HashMap();
  XMLElement xml = new XMLElement(this, query);
  XMLElement results = xml.getChild(1);

  for(int i = 0; i < results.getChildCount(); i++) {
    XMLElement result = results.getChild(i);
    String server = result.getStringAttribute("server");
    if(hm.get(server) == null) {
      hm.put(server, 1);
    } else {
      Integer sum = (Integer)hm.get(server);
      sum += 1;
      hm.put(server, sum);
    }
  }
  return hm;
}

void mouseClicked() {
  drawMap();
}
