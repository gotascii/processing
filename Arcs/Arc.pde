class Arc {
  Arc _parent;

  ArrayList _path;
  Vector3[] _pathBuffer;

  CylinderRoll _rootRib;

  Color4 _color;

  float elevation;
  float _speed;
  float _speedY;

  Vector3 _pos;
  Vector3 _oldPos;

  Vector3 _vel;
  Vector3 _gravity;

  float _age;
  float _timeToLive;

  int _depth;
  int _maxDepth;

  int _maxChildren;
  ArrayList _children;

  boolean _isDead;
  boolean _isActive;

  public Arc() {
    reset(null, new Vector3());
  }

  public Arc(Arc parent, Vector3 pos) {
    reset(parent, pos);
  }

  public void reset(Arc parent, Vector3 pos) {
    _parent = parent;
    _isDead = false;
    _isActive = true;
    _age = 0;
    _timeToLive = 20;

    // compute color
    _color = new Color4();
    _color.set(0, 0, 0, 1);
//    if(_parent == null)
//      _color.set(random(0, 1), random(0, 1), random(0, 1), 1);
//    else
//      _color.set(_parent._rootRib._color.x*random(0, 1), _parent._rootRib._color.y*random(0, 1), _parent._rootRib._color.z*random(0, 1), 1); 

    // compute ribbon mesh    
    int _numOfSegments = 2000;
    _rootRib = new CylinderRoll(_numOfSegments, 20, 4, 0, false);
    _rootRib.computeTail();
    _rootRib._type = 0;
    _rootRib.setHead(pos.x, pos.y, pos.z);
    _rootRib._color.set(_color.r, _color.g, _color.b, _color.a);

    _speed = random(10, 15) * 0.75;
    _speedY = _speed * 1;
    elevation = radians(60 + random(-15, 25));

    _pos = pos.clone();
    _oldPos = pos.clone();

    _vel = new Vector3(random(-_speed, _speed), _speedY * sin(elevation), random(-_speed, _speed));

    if(_parent == null) _gravity = new Vector3(0, -0.35, 0);
    else  _gravity = new Vector3(0, -0.35*3, 0);

    _path = null;
    _path = new ArrayList();

    // add origin point to the path
    _path.add(_pos.clone());

    _depth = 0;
    _maxDepth = MAX_DEPTH;

    if(DO_CHILD)
      _maxChildren = (int)random(1, 4);
    else
      _maxChildren = 0;

    _children = new ArrayList();
  }

  public void run(float time, float frameTime) {
    if(_isDead) return;

    for(int i=0; i<_children.size(); i++) {
      Arc child = (Arc)_children.get(i);
      child.run(time, frameTime);
    }

    render(time);
    if(_isActive) update(time);

    _age += frameTime;
    if(_age > _timeToLive) _isDead = true;
  }

  public void runShadows() {
    if( _isDead ) return;

    for(int i=0; i<_children.size(); i++) {
      Arc child = (Arc)_children.get(i);
      child.runShadows();
    }

    renderShadow();
  }

  public void render(float time) {
    if(_path.size() >= 1) {
      vgl.enableTexture(false);
      vgl.setAlphaBlend();
      vgl.setDepthWrite(true);

      // Render
      _rootRib.setColor(_color.r, _color.g, _color.b, _color.a);
      _rootRib.renderTailCylinderFromBuffer(_pathBuffer, 0, 0);
    }
  }

  public void renderShadow() {
    if(_path.size() >= 1) {
      vgl.enableTexture(false);
      vgl.setAlphaBlend();
      vgl.setDepthWrite(true);

      // Render
      _rootRib.setColor(_color.r*0.25, _color.g*0.25, _color.b*0.25, _color.a*0.125);
      _rootRib.renderTailCylinderFromBuffer(_pathBuffer, 0, 0);
    }
  }

  public void update(float time) {
    if( !_isActive ) return;

    _oldPos = _pos.clone();
    _pos.add(_vel);
    _vel.add(_gravity);

    if(_pos.y > 0) {
      if(Vector3.distance(_oldPos, _pos) > 2.0)
        _path.add(_pos.clone());

      // Save path to an array to be used below for the render
      _pathBuffer = null;
      _pathBuffer = new Vector3[_path.size()+1];
      for(int i=0; i<_path.size(); i++) {
        Vector3 v0 = (Vector3)_path.get(i);
        _pathBuffer[i] = v0.clone();
      }

      _pathBuffer[_pathBuffer.length-1] = (Vector3)_path.get(_path.size()-1);
    } else {
      _isActive = false;
    }

    if(!_isActive) {
      // Create new children
      for(int i=0; i<_maxChildren; i++) {
        addChild(_pos);
      }
    }
  }

  void addChild(Vector3 pos) {    
    // an active arc, doesnt create new ones. only when it hits the end
    if(_isActive) return;
    if(_children.size() >= _maxChildren) return;
    if(_depth >= _maxDepth) return;

    Arc child = new Arc(this, pos);
    child._depth = _depth+1;
    _children.add( child );
  }
}
