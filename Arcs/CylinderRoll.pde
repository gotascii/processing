import penner.easing.*;
import java.util.Collections;  
import java.util.ArrayList;  
import java.util.Comparator; 

class CylinderRoll {
  // 0 means it grows all time. mainly for root ribbons
  // 1 means it stops when reached segment number (age is used to reset ribbon)
  int _type;

  float minNoise, maxNoise;

  int _facets;
  int[] yTable;
  Vector3[] _vertices;
  Vector3[] _texcoords; 
  Vector3[] _normals;

  Vector4  _color;

  boolean _doRenderHead;
  boolean _doUpdate;

  boolean _isDead;
  float _age;
  float _agePer;
  float _timeToLive;
  float _invTimeToLive;

  Vector3 _initPos;

  float _headSize;
  Vector3 _head;
  Vector3 _right;
  Vector3 _target;

  Vector3 _growingDirection;

  Vector3 _add;
  Vector3 _addAmount;
  float _addDamp;
  float _addIntensity;

  float _theta, _phi;
  float _thetaAdd, _phiAdd;
  float _rad;

  boolean _usePerlin;
  Vector3 _perlin;

  float _dispoffset;
  float _displaces;
  float _dispscale;

  Vector3 _gravity; 

  float _tailWidth;
  int  _tailRenderSegments;    // counts number of tail segments to render  
  int  _tailSize;
  Vector3[] _tail;

  int _flowerCount;
  int _numFlowers;
  ArrayList _flowers;
  ArrayList _flowersSizeValue;
  ArrayList _flowersDir;

  int _leafTexID; 
  float _leafCurrSizeX, _leafCurrSizeY;
  float _leafSizeX, _leafSizeY;
  float leafTime;
  float leafStartTime;
  float leafGrowTime;

  float _headRadius;
  float _headMaxRadius;

  // Tree related members
  CylinderRoll _parent;

  int _depth;
  int _maxDepth;

  float _timeChildCount;
  float _timeToAddChild;
  int _maxChildren;
  ArrayList _children;

  CylinderRoll(int tailSize, float tailWidth, int facets, float headSize, boolean renderHead) {
    _parent = null;

    _doRenderHead = renderHead;
    _doUpdate = true;

    _isDead = false;

    _tailSize = tailSize;
    _tailRenderSegments = 0;
    _tailWidth = tailWidth;

    _initPos = new Vector3();

    _headSize = headSize;
    _head = new Vector3();
    _target = new Vector3();
    _right = new Vector3();

    _growingDirection = new Vector3(1, 1, 1);

    _usePerlin = false;
    _perlin = new Vector3();

    _add = new Vector3();
    _addAmount = new Vector3();
    
    _addIntensity = 2.0;

    _age = 0.0;
    _agePer = 0.0;
    _timeToLive = 100;
    _invTimeToLive = 1.0 / _timeToLive;

    _color = new Vector4(1, 1, 1, 1);

    _gravity = new Vector3(0, 0.005, 0);

    _leafTexID = 0;
    _leafCurrSizeX = 0;
    _leafCurrSizeY = 0;
    _leafSizeX = 1;
    _leafSizeY = 2;
    leafTime = 0;
    leafStartTime = 0;
    leafGrowTime = random( 0.75, 1.5 );

    _headRadius = 0.0;
    _headMaxRadius = 10.0;

    _facets = facets;

    _dispoffset = 0;
    _displaces = 0;
    _dispscale = 9;

    _depth = 0;
    _maxDepth = 1;

    // time counter variable to handle "add new child"
    _timeChildCount = 0;    
    // take it takes to add a new child to the ribbon
    _timeToAddChild = 2;
    // max number of children per ribbon
    _maxChildren = 10;

    _children = new ArrayList();

    resetAngles();
  }

  void setRelation(CylinderRoll parent, int depth, int maxDepth) {
    _parent = parent;
    _depth = depth;
    _maxDepth = maxDepth;
  }

  float getRads(float val1, float val2, float mult, float div) {
    float rads = noise(val1/div, val2/div, frameCount/div);
    if (rads < minNoise) minNoise = rads;
    if (rads > maxNoise) maxNoise = rads;

    rads -= minNoise;
    rads *= 1.0/(maxNoise - minNoise);

    return rads * mult;
  }

  void setColor(float r, float g, float b, float a) {
    _color.set(r, g, b, a);
  }

  void setCylinderDetail(int d) {
    _facets = d;
  }

  void setCylinderRadius(int r) {
    _tailWidth = r;
  }

  void loadHeadTexture(String file) {
  }

  void findPerlin() {
    float xyRads = getRads(_head.x, _head.z, 5.0, 15.0);
    float yRads = getRads(_head.x, _head.y, 5.0, 15.0);
    _perlin.set(cos(5.2*xyRads), sin(4*yRads), sin(5.2*xyRads));
    _perlin.mul(2.85);
  }

  void computeTail() {
    _tailRenderSegments = 0;
    if(_tail == null) {
      _tail = new Vector3[_tailSize];

      for(int i=0; i<_tailSize; i++) {
        _tail[i] = new Vector3();
        _tail[i] = _head.copy();
      }
    } else {
      for(int i=0; i<_tailSize; i++) {
        _tail[i] = _head.copy();
      }
    }

    if(yTable == null) yTable = new int[_tailSize];
    for(int i=0; i<_tailSize; i++)
      yTable[i] = i * (_facets+1);
    if(_vertices == null) _vertices = new Vector3[((_tailSize)*(_facets+1))];
    if(_normals == null) _normals = new Vector3[((_tailSize)*(_facets+1))];
    if(_texcoords == null) _texcoords = new Vector3[((_tailSize)*(_facets+1))]; 
    for(int i=0; i<((_tailSize)*(_facets+1)); i++) {
      _vertices[i] = new Vector3();
      _normals[i] = new Vector3();
      _texcoords[i] = new Vector3(); 
    }
  }

  boolean isDead(Vector3 p) {
    if(Vector3.distance(_tail[_tail.length-1], p) < 0.00001) {
      _isDead = true;
      return true;
    }
    return false;
  }

  boolean isDead() {
    if(_age >= _timeToLive) {
      _isDead = true;
      return true;
    }
    return false;
  }

  void setTailSize(int t) {
    _tailSize = t;
    computeTail();
  }

  void setTimeToLive(float t) {
    _timeToLive = t;
    _invTimeToLive = 1.0 / _timeToLive;
  }

  void setHeadY(float y) {
    _head.y = y;
    _initPos = _head.copy();
  }

  void setHead(float x, float y) {
    _head.set(x, y, 0);
    _initPos = _head.copy();
    _target = _head.copy();
  }

  void setHead(float x, float y, float z) {
    _head.set(x, y, z);
    _initPos = _head.copy();
  }

  void setHead(Vector3 h) {
    _head = h.copy();
    _initPos = _head.copy();
  }

  void addHead(float x, float y) {
    if(!_usePerlin) {
      _head.add(x, y, 0);
    }
  }

  void addHead(float x, float y, float z) {
    if(!_usePerlin) {
      _head.add(x, y, z);
    }
  }

  void addHead(Vector3 a) {
    if(!_usePerlin) {
      _head.add(a.copy());
    }
  }

  void doRenderHead(boolean f) {
    _doRenderHead = f;
  }

  void resetAngles() {
    _theta = 0;
    _phi = 0;
    _theta = atan2(_right.y, _right.x);
    _thetaAdd = PI*0.01;
    _phiAdd = 0;
    _rad = 1;

    float tmp = random(-1, 1);
    _growingDirection.set(tmp, tmp, tmp);
    if(_growingDirection.x < 0) _growingDirection.x = -1;
    else _growingDirection.x = 1;
    if(_growingDirection.y < 0) _growingDirection.y = -1;
    else _growingDirection.y = 1;
    if(_growingDirection.z < 0) _growingDirection.z = -1;
    else _growingDirection.z = 1;

    _addDamp = 0.95;
  }

  void update(float time, float dt) {
    if(_type == 0) {
      for(int i=_tailRenderSegments; i>0; i--) {
        _tail[i] = _tail[i-1];
      }
      _tail[0] = _head.copy();

      _tailRenderSegments++;    
      if(_tailRenderSegments > _tailSize-1)
        _tailRenderSegments = _tailSize-1;
    } else if(_type == 1) {
      if(_age < _timeToLive) {
        if(_tailRenderSegments < _tailSize) {
          for(int i=_tailRenderSegments; i>0; i--) {
            _tail[i] = _tail[i-1];
          }
          _tail[0] = _head.copy();
          _tailRenderSegments++;
        } else {
          _doUpdate = false;
        }
      } else {
        _doUpdate = false;
      }
    }

    // Update variables for motion
    if(_doUpdate) {
      if(_usePerlin) {
        float target_distance = 200.0;
        float redirect_distance = 60.0;
        float d = Vector3.distance( _head, _target );
        if(d < target_distance) {
          _target.x += random(-redirect_distance, redirect_distance);
          _target.y += random(-redirect_distance, redirect_distance);
          _target.z += random(-redirect_distance, redirect_distance);
        }
        _add.x += (_target.x-_head.x) * 0.002;
        _add.y += (_target.y-_head.y) * 0.002;
        _add.z += (_target.z-_head.z) * 0.002;
        
        _head.add(_add);
        _add.mul(_addDamp);
      } else {
        // Does not apply to the root ribbon
        if(_parent != null) {
          // Add to position          
          _head.add(_add);

          float sinTheta = sin(_theta) * _rad;
          float sinPhi = sin(_phi);
          float cosTheta = cos(_theta) * _rad;
          float cosPhi = cos(_phi);

          float sinTheta2 = sin(_theta-(PI*0.5)) * _rad;
          float cosTheta2 = cos(_theta-(PI*0.5)) * _rad;

          float sinTheta3 = sin(_theta-(PI*2)) * _rad;
          float cosTheta3 = cos(_theta-(PI*2)) * _rad;

          // damp radius to form some nice ribbons
          _rad *= 0.95;
          _add.x += _addAmount.x*0.03 + sinTheta * -.03; 
          _add.y += _addAmount.y*0.03 + cosTheta * -.03;
          _add.z += sinTheta * sinPhi * .2;           
          _theta += _thetaAdd * 4;
          _phi += _phiAdd;
        }
      }

      if(_parent != null) {
        // compute direction to use as nebulas velocity vector
        Vector3 dir = Vector3.sub(_tail[1], _tail[0]);
        dir.mul(random(-1,1));
        dir.normalize();
      }
    }

    _headRadius += timer.getFrameTime() * 10;
    if(_headRadius > _headMaxRadius) _headRadius = _headMaxRadius;

    _age ++;
    _agePer = _age * _invTimeToLive;
  }

  void draw(float time, float dt) {
    renderTailCylinder();

    // Comment this loop to get back to using normal ribbon
    for(int i=0; i<_children.size(); i++) {
      CylinderRoll child = (CylinderRoll)_children.get(i);
      child.draw(time, dt);

      if(child.isDead(_tail[_tail.length-1]))
        child.resetChild(_head, _timeToLive);    
    }

    update(time, dt);
    addChild(dt);

    // Stop head motion once it completes its growth      
    if(!_doUpdate)
      _head = _tail[0].copy();    
  }

  void renderHead(float time) {
    if( _parent == null ) return; // root has no leafs

    // only render head when end of the tail is reached
    if(_tailRenderSegments < _tailSize/2) {
      // get time taken to grow. use this to reset time that is used to make the leaf grow up
      leafStartTime = time;
      return;
    }

    // clamp time
    leafTime = time - leafStartTime;
    if(leafTime >= leafGrowTime) leafTime = leafGrowTime;

    // scale factor to grow leaf
    float ttt = Quart.easeOut(leafTime, 0, 1, leafGrowTime);

    // size of the leaf
    float sx = (1-(_depth/(float)_maxDepth))*4*ttt;
    float sy = (1-(_depth/(float)_maxDepth))*4*4*ttt;

    int i = 0;

    Vector3 dir = Vector3.sub(_tail[i], _tail[i+2]);
    dir.normalize();
    
    Vector3 up = new Vector3(0, 1, 0);
    Vector3[] rect= new Vector3[4];
    rect[0] = new Vector3(-1*sx, 0*sy, 0);
    rect[1] = new Vector3(-1*sx, 1*sy, 0);
    rect[2] = new Vector3(1*sx, 1*sy, 0);
    rect[3] = new Vector3(1*sx, 0*sy, 0);
    transformRect(up, dir, new Vector3(), rect);
    Vector3 p0 = Vector3.add(_tail[i], rect[0]);
    Vector3 p1 = Vector3.add(_tail[i], rect[1]);
    Vector3 p2 = Vector3.add(_tail[i], rect[2]);
    Vector3 p3 = Vector3.add(_tail[i], rect[3]);

    Vector3 N = Vector3.cross(up, dir);
    N.normalize();

    vgl.fill(1, 1);
    vgl.gl().glEnable(GL.GL_SAMPLE_ALPHA_TO_COVERAGE);
    vgl.enableTexture(true);
    vgl.gl().glBindTexture(GL.GL_TEXTURE_2D, _leafTexID);

    vgl.gl().glBegin(GL.GL_QUADS);
    vgl.gl().glNormal3f(N.x, N.y, N.z); 
    vgl.gl().glColor4f(vgl._r, vgl._g, vgl._b, vgl._a);
    vgl.gl().glTexCoord2f(0, 1); 
    vgl.gl().glVertex3f(p0.x, p0.y, p0.z);
    vgl.gl().glTexCoord2f(0, 0); 
    vgl.gl().glVertex3f(p1.x, p1.y, p1.z);
    vgl.gl().glTexCoord2f(1, 0);
    vgl.gl().glVertex3f(p2.x, p2.y, p2.z);	
    vgl.gl().glTexCoord2f(1, 1); 
    vgl.gl().glVertex3f(p3.x, p3.y, p3.z);
    vgl.gl().glEnd();

    vgl.gl().glBindTexture(GL.GL_TEXTURE_2D, 0);
    vgl.gl().glDisable(GL.GL_SAMPLE_ALPHA_TO_COVERAGE); 
  }

  void renderTail(float time) {
    float per;
    float xp, yp, zp;
    float xOff, yOff, zOff;

    vgl.gl().glBegin(GL.GL_QUAD_STRIP);
    for (int i=0; i<_tailSize-1; i++) {
      per = (((float)i/(float)(_tailSize)));

      if( per > 1.0 ) per = 1.0;
      if( per < 0.0 ) per = 0.0;

      Vector3 dir = Vector3.sub(_tail[i+1], _tail[i]);
      dir.normalize();

      Vector3 V = dir.cross(new Vector3( 0, 1, 0 ));
      V.normalize();
      Vector3 N = dir.cross(V);
      N.normalize();
      V = N.cross(dir);
      V.normalize();

      _right = V.copy();

      xp = _tail[i].x + _right.x*sin(i*.2+time*8)*3*(_tailSize-i)*.053;
      yp = _tail[i].y - 30;
      zp = _tail[i].z + _right.z*sin(i*.2+time*8)*3*(_tailSize-i)*.053;

      xOff = V.x * _tailWidth * per * 1.5;
      yOff = V.y * _tailWidth * per * 1.5;
      zOff = V.z * _tailWidth * per * 1.5;

      vgl.gl().glColor4f( 0, 0, 0, 1-_agePer );
      vgl.gl().glVertex3f( xp - xOff, yp - yOff, zp - zOff );
      vgl.gl().glVertex3f( xp + xOff, yp + yOff, zp + zOff );
    }
    vgl.gl().glEnd();
  }

  void renderTailCylinder() {
    float invsteps = 1.0 / (float)(_tailSize);
    float invfacets = 1.0 / (float)(_facets);

    float pi2OverSteps = TWO_PI / (_tailSize);
    float pi2OverFacets = TWO_PI / _facets;
    float pi2MulInvsteps = TWO_PI * invsteps;
    float pi2MulInvfacets = TWO_PI * invfacets;

    // Draw vine mesh
    for(int j=0; j<_tailRenderSegments-1; j++) {
      float per = 1.0;
      int sss = _tailSize/8;
      if(j <= sss)  // make head
        per = 1.1 - ((sss-j) / (float)sss);
      else
        per = 1.1;

      per *= _tailWidth;

      // first point
      Vector3 center = new Vector3();
      center = _tail[j];//.copy();

      // next point
      Vector3 nextPoint = new Vector3();
      nextPoint = _tail[j+1];//.copy();

      // get TBN matrix for transformation
      Vector3 T = new Vector3();
      T.x = nextPoint.x - center.x;
      T.y = nextPoint.y - center.y;
      T.z = nextPoint.z - center.z;
      T.normalize();

      Vector3 N = new Vector3( 0, 1, 1 );

      Vector3 B = T.cross(N);
      B.normalize();
      N = B.cross(T);
      N.normalize();

      // Compute right vector for the head. since we grow children from the head, this works just fine
      if(j == 0) {
        _right = N.copy();
      }

      // go through facets and tweak a bit with some distortions
      for(int i=0; i<_facets+1; i++) {
        float x = (sin(i * pi2OverFacets) * per);
        float y = (cos(i * pi2OverFacets) * per);        

        // distort knot along the curve
        if(_displaces != 0.0) {
          x *= (1 + (sin(_dispoffset + _displaces * j * pi2OverSteps) * _dispscale));
          y *= (1 + (cos(_dispoffset + _displaces * j * pi2OverSteps) * _dispscale));
        }

        int idx = yTable[j] + i;
        _vertices[ idx ].x = N.x * x + B.x * y + center.x;
        _vertices[ idx ].y = N.y * x + B.y * y + center.y;
        _vertices[ idx ].z = N.z * x + B.z * y + center.z;

        _texcoords[ idx ].x = ((float)i / (float)_facets) * 1;
        _texcoords[ idx ].y = ((float)(j) / (float)_tailRenderSegments) * 10; 

        // get vertex normal
        _normals[ idx ].x = _vertices[ idx ].x - center.x;
        _normals[ idx ].y = _vertices[ idx ].y - center.y;
        _normals[ idx ].z = _vertices[ idx ].z - center.z;
        // normalize
        _normals[ idx ].normalize();
      }

      // duplicate sideways vertices/normals
      int idxSrc = yTable[j] + 0;
      int idxDest = yTable[j] + _facets;

      _vertices[ idxDest ].x = _vertices[ idxSrc ].x;
      _vertices[ idxDest ].y = _vertices[ idxSrc  ].y;
      _vertices[ idxDest ].z = _vertices[ idxSrc ].z;
      _texcoords[ idxDest ].x = _texcoords[ idxSrc ].x;
      _texcoords[ idxDest ].y = _texcoords[ idxSrc ].y;
      _normals[ idxDest ].x = _normals[ idxSrc ].x;
      _normals[ idxDest].y = _normals[ idxSrc ].y;
      _normals[ idxDest ].z = _normals[ idxSrc ].z;
    }

    int j = 0;
    float umul= 1;
    float vmul = 10;
    float u, v1, v2;
    v1 = vmul*j * invsteps;
    v2 = vmul*(j+1) * invsteps;

    for(j=0; j<_tailRenderSegments-2; j++) {
      vgl.gl().glBegin(GL.GL_TRIANGLE_STRIP);
      for(int i=0; i<_facets+1; i++) {
        vgl.gl().glColor4f( _color.x, _color.y, _color.z, _color.w );

        vgl.gl().glNormal3f( _normals[yTable[j]+i].x, _normals[yTable[j]+i].y, _normals[yTable[j]+i].z );
        vgl.gl().glTexCoord2f( _texcoords[yTable[j]+i].x, _texcoords[yTable[j]+i].y ); 
        vgl.gl().glVertex3f( _vertices[yTable[j]+i].x, _vertices[yTable[j]+i].y, _vertices[yTable[j]+i].z );

        vgl.gl().glNormal3f( _normals[yTable[j+1]+i].x, _normals[yTable[j+1]+i].y, _normals[yTable[j+1]+i].z );
        vgl.gl().glTexCoord2f( _texcoords[yTable[j+1]+i].x, _texcoords[yTable[j+1]+i].y ); 
        vgl.gl().glVertex3f( _vertices[yTable[j+1]+i].x, _vertices[yTable[j+1]+i].y, _vertices[yTable[j+1]+i].z );
      }      
      vgl.gl().glEnd();
    }
  }

  void renderTailFromBuffer(Vector3[] buf, float yOffset) {
    float per;
    float xp, yp, zp;
    float xOff, yOff, zOff;

    vgl.gl().glBegin(GL.GL_QUAD_STRIP);
    int hlen = (int)((buf.length-1)*0.5);
    for(int ii=-hlen+1; ii<hlen+1; ii++) {
      int i = ii+hlen;
      per = 1.2 - (((float)(abs(ii))/(float)(hlen))*0.8);
      per *= _tailWidth * 0.5;

      Vector3 dir = Vector3.sub(buf[i+1], buf[i]);
      dir.normalize();
      Vector3 V = dir.cross(new Vector3( 0, 1, 0 ));
      V.normalize();
      Vector3 N = dir.cross(V);
      N.normalize();
      V = N.cross(dir);
      V.normalize();

      _right = V.copy();

      xp = buf[i].x;
      yp = buf[i].y;
      zp = buf[i].z;

      xOff = V.x * per;
      yOff = V.y * per;
      zOff = V.z * per;

      vgl.gl().glColor4f( 0, 0, 0, 0.5 );
      vgl.gl().glVertex3f(xp - xOff, (yp - yOff) - yOffset, zp - zOff);
      vgl.gl().glVertex3f(xp + xOff, (yp + yOff) - yOffset, zp + zOff);
    }
    vgl.gl().glEnd();
  }

  void renderTailCylinderFromBuffer(Vector3[] buffer, float uscale, float vscale) {
    if( buffer == null || buffer.length <= 0 ) return;

    int bufLength = buffer.length;

    float invsteps = 1.0 / (float)(bufLength);
    float invfacets = 1.0 / (float)(_facets);
    float pi2OverFacets = TWO_PI / (float)_facets;

    // Draw vine mesh
    for(int j=0; j<bufLength-1; j++) {
      float per = 1;
      per = (1.0 - (j * invsteps));
      per *= (buffer[j].y * 0.125) + invsteps;

      // first point
      Vector3 center = buffer[j];

      // next point
      Vector3 nextPoint = buffer[j+1];

      // get TBN matrix for transformation
      Vector3 T = Vector3.sub( nextPoint, center );
      T.normalize();

      Vector3 N = new Vector3( 0, 1, 0 );
      N.normalize();

      Vector3 B = Vector3.cross( T, N );
      B.normalize();
      
      N = Vector3.cross( B, T );
      N.normalize();

      T = Vector3.cross( N, B );
      T.normalize();

      // Compute right vector for the head point
      if(j == 0) {
        _right = B.copy();
      }

      // go through facets and tweak a bit with some distortions
      for(int i=0; i<_facets+1; i++) {
        float add = PI*0.25;
        float x = (sin(add+i*pi2OverFacets) * per);
        float y = (cos(add+i*pi2OverFacets) * per * 2);

        int idx = j*bufLength + i;
        _vertices[ idx ].x = N.x * x + B.x * y + center.x;
        _vertices[ idx ].y = N.y * x + B.y * y + center.y;
        _vertices[ idx ].z = N.z * x + B.z * y + center.z;

        _texcoords[ idx ].x = (i * invfacets) * uscale;
        _texcoords[ idx ].y = (j * invsteps) * vscale;

        // get vertex normal
        _normals[ idx ] = Vector3.sub( _vertices[idx], center );
        _normals[ idx ].normalize();
      }

      // duplicate sideways vertices/normals
      int idxSrc = j * bufLength + 0;
      int idxDest = j * bufLength + (_facets);

      _vertices[idxDest].set( _vertices[idxSrc] );
      _texcoords[idxDest].set( _texcoords[idxSrc] );
      _normals[idxDest].set( _normals[idxSrc] );
    }

    // RENDER RIBBON
    int i=0;
    int j=0;
    for(j=0; j<bufLength-2; j++) {
      vgl.gl().glBegin( GL.GL_TRIANGLE_STRIP );
      for(i=0; i<_facets+1; i++) {
        int idx0 = j * bufLength + i;
        int idx1 = (j+1) * bufLength + i;

        vgl.gl().glColor4f( _color.x, _color.y, _color.z*((i+1)*invsteps*0.4), _color.w );

        vgl.gl().glNormal3f( _normals[idx0].x, _normals[idx0].y, _normals[idx0].z );
        vgl.gl().glVertex3f( _vertices[idx0].x, _vertices[idx0].y, _vertices[idx0].z );

        vgl.gl().glNormal3f( _normals[idx1].x, _normals[idx1].y, _normals[idx1].z );
        vgl.gl().glVertex3f( _vertices[idx1].x, _vertices[idx1].y, _vertices[idx1].z );
      }      
      vgl.gl().glEnd();
    }
  }

  void transformRect(Vector3 up, Vector3 V, Vector3 offset, Vector3[] rect)  {
  	for(int i=0; i<4; i++) {
  		Vector3 v = rect[i];
  		Vector3 P = new Vector3(v.x, v.y, v.z);

  		Vector3 NY = up.copy();
  		NY.normalize();
  		Vector3 NV = V.copy();
  		NV.normalize();

  		Vector3 N = NY.cross( NV );	// axis of rotation
  		N.normalize();

  		float dot = NY.dot(NV);	// cos angle
  		float rad = (acos(dot));	// angle of rotation (radians)

  		// quat from an angle and a rotation axis
  		Quaternion quat = new Quaternion();
  		quat.rotateAxis(N, rad);

  		// transform vertex
  		Vector3 dv = quat.mul(P);
  		v.set(dv);                
  		v.add(offset);
  	}
  }

  void reset() {
    resetChild(_initPos, _timeToLive);
  }

  void resetChild(Vector3 newPos, float ttl) {
    setHead(newPos);
    computeTail();
    setTimeToLive(ttl);
    _tailRenderSegments = 0;
    _age = 0;

    // set add vector to the direction parent is going      
    Vector3 dir;

    if(_parent != null)
      dir = Vector3.sub(_parent._tail[0], _parent._tail[1]);
    else
      dir = Vector3.sub(_tail[0], _tail[1]);

    dir.normalize();
    _add = dir.clone();
    _add.normalize();
    _add.mul(_addIntensity); // intensity towards the direction
    _addAmount = _parent._right.clone();

    if(_parent != null)
      _maxChildren = (int)random(0, _parent._maxChildren);
    else
      _maxChildren = (int)random(0, _maxChildren);

    _leafCurrSizeX = 0;
    _leafCurrSizeY = 0;
    leafTime = 0;
    leafStartTime = 0;
    leafGrowTime = random(0.75, 1.5);

    for(int i=0; i<_children.size(); i++) {
      ((CylinderRoll)_children.get(i)).reset();
    }
    _children.clear();
    resetAngles();
    _doUpdate = true;
  }

  void addChild(float dt) {
    // If reached max depth. quit!
    if(_depth >= _maxDepth) return;

    // if reached end of segmentation bail out!
    if(_tailRenderSegments >= _tailSize-1) return;

    // Every n'th second we grow a child. check if it's time to give birth
    _timeChildCount += dt;
    if(_timeChildCount < _timeToAddChild) return;
    _timeChildCount = 0.0;

    if(_children.size() < _maxChildren) {
      CylinderRoll rib = new CylinderRoll((int)random(_tailSize/2, _tailSize), _tailWidth*0.5, _facets, 0, true);
      rib.setRelation(this, _depth+1, _maxDepth);
      rib._maxChildren = (int)random(_maxChildren/2);
      // Set maximum lifetime
      rib.setTimeToLive(_timeToLive);
      // Set same color of its parent
      rib._color.set(_color);
      // Set limited ribbon type. has age and size.. stops growing at some point
      rib._type = 1;
      // Set leaf texture
      rib._leafTexID = _leafTexID;
      // Compute the data
      rib.computeTail();
      // Set its head to start where its parent's head is.
      rib.setHead(_head);
      rib.resetAngles();

      // set add vector to the direction we're going
      Vector3 dir = Vector3.sub(_tail[0], _tail[1]);
      dir.normalize();
      rib._add = dir.clone();
      rib._add.normalize();
      rib._add.mul(_addIntensity); // intensity towards the direction

      _addAmount = _right.clone();

      // Finally add child to the list
      _children.add(rib);
    }
  }
}
