import processing.xml.*;

XMLElement xml;
int count = 200;
String query = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.interestingness(" + count + ")&format=xml";
HashMap hm;

void setup() {
  size(200, 200);
  hm = new HashMap();
  xml = new XMLElement(this, query);
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
  
  Iterator i = hm.entrySet().iterator();
  while (i.hasNext()) {
    Map.Entry me = (Map.Entry)i.next();
    int diameter = ((Integer)me.getValue()) * 20;
    noStroke();
    fill(0, 0, 208, 40);
    ellipse(random(200), random(200), diameter, diameter);
  }
}

void draw() {
}
