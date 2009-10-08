class OscHandler {
  void handle(OscMessage msg) {
    float val;
    if (msg.checkTypetag("if")) {
      val = msg.get(1).floatValue();
    } else if (msg.checkTypetag("f")) {
      val = msg.get(0).floatValue();
    } else {
      val = float(msg.get(1).intValue());
    }
    
    Gravity g;
    for(int i = 0; i < gravitons.size(); i++) {
      g = (Gravity)gravitons.get(i);
      if (msg.checkAddrPattern("/fcharge")) {
        g.fcharge = -val;
      } else if (msg.checkAddrPattern("/diameter")) {
        g.diameter = val;
      } else if (msg.checkAddrPattern("/bounce")) {
        g.bounce = val;
      }
    }
    
    if (msg.checkAddrPattern("/graviton/charge")) {
      int i = msg.get(0).intValue();
      g = (Gravity)gravitons.get(i);
      g.charge = val;
    }
    
    if (msg.checkAddrPattern("/gluiton/fcharge")) {
      int i = msg.get(0).intValue();
      g = (Gravity)gluiton.get(i);
      g.fcharge = -val;
    }
    
    if (msg.checkAddrPattern("/key")) {
      int k = msg.get(0).intValue();
      boolean state = (val != 0);
      if (state) {
        keyed[k] = true;
      } else {
        keyed[k] = false;
      }
    }
    
    if (msg.checkAddrPattern("/cam_rotateX")) {
      cam_rotateX = val;
    }
    
    if (msg.checkAddrPattern("/cam_rotateY")) {
      cam_rotateY = val;
    }
  }
}
