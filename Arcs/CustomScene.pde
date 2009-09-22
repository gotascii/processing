class CustomScene extends vitamin.fx.Effect {
  GL _gl;
  ArrayList _arcs;
  VTexture2D _groundTex;
  float _arcAddTime = 1.0;
  float _lastArcAddTime = 0.0;
  Matrix matWorld, matView;
  int subsurfaceID;

  public boolean Init(GL gl) {
    _gl = gl;
    _arcs = new ArrayList();
    _arcs.add(new Arc());
    // Ground texture
    _groundTex = new VTexture2D(vgl.gl(), dataPath("groundtex.png")); 
    // Load shaders
    subsurfaceID = vgl.addEffectFromFile(dataPath("subsurface.cgfx"));
    return true;
  }

  public void Render(float time) {
    vgl.perspective(45, aspectRatio, 1, 6000);
    vgl.camera(cam.getPosition(), cam.getTarget(), cam.getUp());
    matView = vgl.getTransposeViewMatrix();

    // Draw floor
    _groundTex.enable();
    vgl.pushMatrix();
    vgl.fill(0.68, 1);
    vgl.rectXZ(2000, 2000);
    vgl.popMatrix();

    // Draw planar shadow
    vgl.enableTexture(false);
    vgl.setDepthMask(false);

    Plane plane = new Plane(new Vector3(0, 0, 0), new Vector3(0, 1, 0));
    float[] P = {0, 0, 0, 1};
    float[] P2 = {plane._normal.x, plane._normal.y, plane._normal.z, plane._d};
    float[] L2 = {lightPos.x, lightPos.y, lightPos.z, 1};

    vgl.gl().glEnable(GL.GL_POLYGON_OFFSET_FILL);
    vgl.gl().glPolygonOffset(-1, 1);

    vgl.pushMatrix();
    CreateShadowProjection(L2, P, P2);

    for(int i=0; i<_arcs.size(); i++) {
      Arc a = (Arc)_arcs.get(i);
      a.runShadows();
    }

    vgl.gl().glDisable(GL.GL_POLYGON_OFFSET_FILL);
    vgl.popMatrix();

    // Set SUBSURFACE shader
    vgl.setDepthMask(true);
    vgl.setShader(subsurfaceID);
    vgl.setParameter4f("lightPos", lightPos);

    vgl.setParameter3f("cameraPos", cam.getPosition());
    vgl.setParameter1f("kC", 0);
    vgl.setParameter1f("kL", 0);
    vgl.setParameter1f("kQ", 0);
    vgl.setParameter1f("fogDensity", 0);
    vgl.setParameter1f("useSpecular", 1);
    vgl.setParameter1f("specularLevel", 64);

    vgl.pushMatrix();
    vgl.identity();
    vgl.rotateY(time*4);
    matWorld = vgl.getTransposeViewMatrix();
    vgl.popMatrix();

    vgl.setMatrixParameterSemantic("WORLDVIEWPROJECTION", ShaderSemantics.WORLDVIEWPROJECTION_MATRIX, ShaderSemantics.IDENTITY_MATRIX);
    vgl.setMatrixParameterSemantic("VIEWINVERSETRANSPOSE", ShaderSemantics.VIEW_MATRIX, ShaderSemantics.INVERSE_TRANSPOSE_MATRIX);
    vgl.setMatrixParameterSemantic("WORLDMATRIX", matWorld.getArray());
    vgl.setMatrixParameterSemantic("VIEWMATRIX", matView.getArray());
    vgl.setMatrixParameterSemantic("MODELVIEWMATRIX", ShaderSemantics.VIEW_MATRIX, ShaderSemantics.IDENTITY_MATRIX);
    vgl.getActiveEffect().setFirstTechnique();
    vgl.getActiveEffect().setPass();

    for(int i=0; i<_arcs.size(); i++) {
      Arc a = (Arc)_arcs.get(i);
      a.run(time, timer.getFrameTime());
    }

    vgl.getActiveEffect().resetPass();
    vgl.disableShader();
  }

  public void Update(float time) {
    if(((time - _lastArcAddTime) >= _arcAddTime)) {
      _lastArcAddTime = time - ((time - _lastArcAddTime)%_arcAddTime);
      Arc c = new Arc();
      _arcs.add(c);
    }

    // Update camera
    if(!offlineRenderSequence) {
      updateCamera( 10 );
    } else {
      cam.setPosition(sin(time*.5)*600, sin(time*.4)*100+300, cos(time*.5)*650);
    }
  }

  public void Release() {
  }

  void updateCamera(float s) {
    // Get input
    if( keyPressed && keyCode == LEFT )
      cam.strafe( -s );
    else if( keyPressed && keyCode == RIGHT )
      cam.strafe( s );
    if( keyPressed && keyCode == UP )
      cam.move( s );
    else if( keyPressed && keyCode == DOWN )
      cam.move( -s );
    if( keyPressed && key == 'q' )
      cam.lift( s );
    else if( keyPressed && key == 'a' )
      cam.lift( -s );

    if( mousePressed )
      cam.rotateByMouse( mouseX, mouseY, width/2, height/2 ); 
  } 

  /*
   * This is where the "magic" is done:
   *
   * Multiply the current ModelView-Matrix with a shadow-projetion
   * matrix.
   *
   * l is the position of the light source
   * e is a point on within the plane on which the shadow is to be
   *   projected.  
   * n is the normal vector of the plane.
   *
   * Everything that is drawn after this call is "squashed" down
   * to the plane. Hint: Gray or black color and no lighting 
   * looks good for shadows *g*
   */
  void CreateShadowProjection(float[] l, float[] e, float[] n) {
    float d, c;
    float[] mat = new float[16];

    // These are c and d (corresponding to the tutorial)
    d = n[0]*l[0] + n[1]*l[1] + n[2]*l[2];
    c = e[0]*n[0] + e[1]*n[1] + e[2]*n[2] - d;

    // Create the matrix. OpenGL uses column by column ordering
    mat[0]  = l[0]*n[0]+c;
    mat[4]  = n[1]*l[0];
    mat[8]  = n[2]*l[0];
    mat[12] = -l[0]*c-l[0]*d;

    mat[1]  = n[0]*l[1];
    mat[5]  = l[1]*n[1]+c;
    mat[9]  = n[2]*l[1];
    mat[13] = -l[1]*c-l[1]*d;

    mat[2]  = n[0]*l[2];
    mat[6]  = n[1]*l[2];
    mat[10] = l[2]*n[2]+c;
    mat[14] = -l[2]*c-l[2]*d;

    mat[3]  = n[0];
    mat[7]  = n[1];
    mat[11] = n[2];
    mat[15] = -d;

    // Finally multiply the matrices together *plonk*
    vgl.gl().glMultMatrixf(mat, 0);
  }
}

