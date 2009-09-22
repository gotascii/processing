package quickhull3d;

import maspack.geometry.*;
import net.java.games.jogl.*;

import javax.swing.event.*;
import java.awt.event.*;

import java.util.*;

class QuickHull3DAnimation extends QuickHull3D implements GLSelectable
{
	Material material;

	boolean select = false;
	int selectX;
	int selectY;

	private void setPick (int x, int y)
	 {
	   selectX = x;
	   selectY = y;
	   select = true;
	 }

	Vertex eyeVtx;
	GLViewer viewer;

	class MouseHandler extends MouseInputAdapter
	 {
	   public void mousePressed (MouseEvent e)
	    { 
	      if (((e.getModifiers() & MouseEvent.BUTTON1_MASK) != 0) &&
		  ((e.getModifiers() & MouseEvent.SHIFT_MASK) != 0))
	       { setPick (e.getX(), e.getY());
		 viewer.repaint();
	       }
	    }
	 }

	public QuickHull3DAnimation (GLViewer viewer)
	 {
	   this.viewer = viewer; 
	   viewer.getCanvas().addMouseListener (new MouseHandler());
	   material = Material.createSpecial (Material.GOLD);
	   viewer.addRenderable (this);
	 }

	private void pauseForInput()
	 {
	   try
	    { System.in.read();
	    } 
	   catch (Exception e)
	    { 
	    }
	 }

	protected void buildHull ()
	 { 
	   int cnt = 0;

	   computeMaxAndMin ();
	   double size = charLength;
	   System.out.println ("charLength=" + charLength);
	   viewer.setAxisLength (size);
	   viewer.setView (30, 20*size/1000.0, 20*size, size*5);

	   createInitialSimplex ();
	   while ((eyeVtx = nextPointToAdd()) != null)
	    { viewer.repaint();
	      pauseForInput();
	      addPointToHull (eyeVtx);
	      cnt++;
	      if (debug)
	       { System.out.println ("iteration " + cnt + " done"); 
	       }
	    }
	   reindexFacesAndVertices();
	   if (debug)
	    { System.out.println ("hull done");
	    }
	 }

	public void render (
	   GLDrawable d, RenderProperties props, boolean selecting)
	 { 
	   int[] selectBuffer = null;
	   GL gl = d.getGL();

// 	   if (select)
// 	    { selectBuffer = new int[256];
// 	      gl.glSelectBuffer (selectBuffer.length, selectBuffer);
// 	      gl.glRenderMode (gl.GL_SELECT);
// 	      int[] viewport = new int[4];
// 	      gl.glGetIntegerv (gl.GL_VIEWPORT, viewport);
// 	      gl.glMatrixMode (gl.GL_PROJECTION);
// 	      gl.glPushMatrix();
// 	      gl.glLoadIdentity();
// 	      viewer.glu.gluPickMatrix (
// 		 (double)selectX, (double)(viewport[3]-selectY),
// 		 3.0, 3.0, viewport);
// 	      viewer.setViewVolume();
// 	      gl.glMatrixMode(gl.GL_MODELVIEW);
// 	    }

	   gl.glPushMatrix();
	   material.apply(gl, GL.GL_FRONT);

//	   gl.glDisable (gl.GL_CULL_FACE);

	   // draw filled faces
// 	   gl.glInitNames();
// 	   gl.glPushName(-1);

	   gl.glPolygonMode (gl.GL_FRONT_AND_BACK, gl.GL_FILL);
	   gl.glFrontFace (gl.GL_CCW);
	   int faceIndex = 0;
	   for (Iterator it=faces.iterator(); it.hasNext(); ) 
	    { Face face = (Face)it.next();

	      if (face.mark == Face.VISIBLE)
	       { 
		 if (selecting)
		  { gl.glLoadName (faceIndex);
		  }
		 gl.glBegin (gl.GL_POLYGON);
		 Vector3d nrm = face.getNormal();
		 gl.glNormal3d (nrm.x, nrm.y, nrm.z);
		 HalfEdge he = face.he0;
		 do
		  { Point3d pnt = he.head().pnt;
		    gl.glVertex3d (pnt.x, pnt.y, pnt.z);
		    he = he.next;
		  }
		 while (he != face.he0);
		 gl.glEnd();
		 if (selecting)
		  { gl.glLoadName (-1);
		  }
	       }
	      faceIndex++;
	    }

	   // draw faces again with lines

	   gl.glDisable (gl.GL_LIGHTING);
	   gl.glColor3f (0, 0, 0);
	   gl.glPolygonMode (gl.GL_FRONT, gl.GL_LINE);
	   gl.glEnable (gl.GL_POLYGON_OFFSET_LINE);
	   gl.glPolygonOffset (-1f, -1f);

	   for (Iterator it=faces.iterator(); it.hasNext(); ) 
	    { Face face = (Face)it.next();

	      if (face.mark == Face.VISIBLE)
	       { 
		 gl.glBegin (gl.GL_POLYGON);
		 Vector3d nrm = face.getNormal();
		 gl.glNormal3d (nrm.x, nrm.y, nrm.z);
		 HalfEdge he = face.he0;
		 do
		  { Point3d pnt = he.head().pnt;
		    gl.glVertex3d (pnt.x, pnt.y, pnt.z);
		    he = he.next;
		  }
		 while (he != face.he0);
		 gl.glEnd();
	       }
	    }

	   gl.glDisable (gl.GL_POLYGON_OFFSET_LINE);
	   gl.glPolygonMode (gl.GL_FRONT, gl.GL_FILL);


	   // draw points
	   gl.glPointSize (3);

	   for (int i=0; i<numPoints; i++)
	    { Vertex vtx = pointBuffer[i];
	      if (vtx == eyeVtx)
	       { gl.glColor3f (1f, 1f, 1f);
	       }
	      else if (i == findIndex)
	       { gl.glColor3f (0f, 1f, 0f);
	       }
	      else
	       { gl.glColor3f (1f, 0f, 0f); 
	       }
	      if (selecting)
	       { gl.glLoadName (i + faces.size()); 
	       }
	      gl.glBegin (gl.GL_POINTS);
	      gl.glVertex3d (vtx.pnt.x, vtx.pnt.y, vtx.pnt.z);
	      gl.glEnd();
	      if (selecting)
	       { gl.glLoadName (-1);
	       }
	    }
		 

// 	   for (int i=0; i<numPoints; i++)
// 	    { if (pointBuffer[i] != eyeVtx && i != findIndex)
// 	       { Point3d pnt = pointBuffer[i].pnt;
// 		 gl.glVertex3d (pnt.x, pnt.y, pnt.z);
// 	       }
// 	    }

// 	   gl.glBegin (gl.GL_POINTS);
// 	   gl.glColor3f (1f, 0, 0);
// 	   for (int i=0; i<numPoints; i++)
// 	    { if (pointBuffer[i] != eyeVtx && i != findIndex)
// 	       { Point3d pnt = pointBuffer[i].pnt;
// 		 gl.glVertex3d (pnt.x, pnt.y, pnt.z);
// 	       }
// 	    }
//  	   if (eyeVtx != null)
// 	    { gl.glColor3f (1f, 1f, 1f);
// 	      Point3d pnt = eyeVtx.pnt;
// 	      gl.glVertex3d (pnt.x, pnt.y, pnt.z);
// 	    }

// 	   gl.glEnd();

// 	   if (findIndex >= 0 && findIndex < numPoints)
// 	    { gl.glPointSize (4);
// 	      gl.glBegin (gl.GL_POINTS);
// 	      gl.glColor3f (0f, 1f, 0f);
// 	      Point3d pnt = pointBuffer[findIndex].pnt;
// 	      gl.glVertex3d (pnt.x, pnt.y, pnt.z);
// 	      gl.glEnd();
// 	    }


	   gl.glEnable (gl.GL_LIGHTING);

//	   gl.glEnable (gl.GL_CULL_FACE);

	   gl.glPopMatrix();

// 	   if (select)
// 	    { int hits = gl.glRenderMode (gl.GL_RENDER);
// 	      gl.glMatrixMode(gl.GL_PROJECTION);
// 	      gl.glPopMatrix();
// 	      gl.glMatrixMode(gl.GL_MODELVIEW);
// 	      processHits (hits, selectBuffer);
// 	      select = false;
// 	    }
	 }

	void processHits (int hits, int[] buf)
	 {
	   if (hits > 0)
	    { // just look at first hit
	      int faceIdx = buf[3];
	      if (faceIdx < faces.size())
	       { System.out.println (
		    "face: " + ((Face)faces.get(faceIdx)).getVertexString());
	       }
	    }
	 }

//	static QuickHull3D qhull;

	public static void main (String[] args) 
	 {

	   GLViewerFrame frame =
	      new GLViewerFrame ("QuickHull", 400, 400);
	   GLViewer viewer = frame.getViewer();

	   QuickHull3DAnimation animatedHull =
	      new QuickHull3DAnimation (viewer);

	   frame.setVisible(true);

           double[] pnts = new double[] {
0.20850193336487832, 0.5, 0.5,
-0.2958570559576923, -0.5, 0.5,
0.1110071461285631, -0.4403639424486443, -0.03399382057045752,
0.34637797845571194, 0.4743675969917447, 0.5,
0.23123970099966007, 0.4726011752308441, 0.5,
0.5, -0.27330152310986344, 0.4381633645903855,
0.16043041242879763, -0.5, 0.05548894780237146,
0.4401284796826373, 0.4999999999999984, -0.49999999999999917,
0.5, 0.5, 0.5,
-0.5, 0.5, -0.5,
0.19296885721886592, -0.20702421938789883, -0.04328129681029713,
0.5, 0.22825649239894852, 0.37549226201639185,
-0.5, -0.1643407151051426, 0.28264054971898367,
0.5, -0.29621404183537003, -0.3977400858970961,
0.5, -0.021075840834457793, 0.5,
-0.5, 0.5, 0.5,
-0.5, -0.5, -0.48581843102006794,
0.49999999999999895, -0.4512760039508545, -0.39106546710853746,
0.4999999999999969, -0.4512760039508601, -0.3910654671085343,
0.5, -0.5, 0.4230803918507222,
0.5, 0.5, -0.5,
-0.3005580036538109, -0.5, -0.5,
0.5, 0.12710646442429852, -0.5,
0.2044785765299555, -0.06356257099294904, 0.5,
0.1834409665330985, 0.5, 0.42285758824022257,
0.4468507486259965, -0.5000000000000027, 0.1510644956922647,
-0.5, -0.009711500089978786, -0.20227751013393913,
0.30024467040117253, -0.39619937624348833, -0.5,
-0.37653757957283407, 0.20976479063337528, -0.5,
0.5, 0.5, -0.5,
0.5, 0.17780342607450716, 0.5,
0.5, 0.3631542698459922, 0.5,
-0.5, -0.4610815441154421, -0.09947897993776422,
-0.5, -0.11827416307347094, -0.5,
-0.2927846385586268, 0.008437545298275895, 0.41290504333553035,
0.3550000812859957, -0.25229518235488047, -0.40298485529156536,
0.12142318472541502, 0.0749764436499114, -0.5,
0.5, -0.2803508189496564, -0.34385112176846633,
-0.5, 0.1748576319251236, -0.45294295933523565,
-0.5, -0.04966138751759397, 0.5,
-0.0076039422173226345, -0.005003107489910841, -0.5,
0.5, 0.5, 0.11438693517901699,
-0.5, -0.5, 0.5,
-0.5, 0.154327654296736, -0.5,
0.5, 0.5, 0.05355896026312679,
-0.4999999999999983, 0.5000000000000011, -0.5000000000000038,
0.24457661495520133, 0.5, -0.5,
-0.5, 0.3476793177835722, -0.5,
-0.5, 0.12364039372733227, 0.443399530019045,
-0.5, -0.5, -0.5,
-0.37714033279824877, 0.5, -0.5,
-0.32809048250117545, 0.4204261771147597, 0.5,
0.028497935616356163, 0.45602656158484867, -0.5,
-0.40107407712312626, -0.5, 0.5,
-0.5, -0.2406579075260582, 0.19520599004463945,
-0.1522136153065341, 0.5, 0.30790840384534457,
0.22169029344264368, -0.3010893970319515, 0.1670727244632919,
-0.5, 0.5, 0.5,
0.17777743593481055, -0.5, -0.5,
-0.4303966858130599, 0.5, 0.2783773226348778,
-0.5, 0.01378356462918684, 0.026900504207408193,
-0.5, 0.5, 0.16288549693359622,
0.3292432403479073, 0.1617889100826999, -0.2481463950098044,
-0.5, 0.5, -0.16634255356641958,
-0.4802853950246255, -0.48061886626381667, 0.5,
-0.5, 0.45820939514027015, 0.011370438578669928,
-0.023731447757247004, 0.5, 0.5,
-0.5, 0.3033590250329694, -0.5,
0.5, 0.5, 0.14245208276121124,
0.5, -0.4512760039508581, -0.3910654671085374,
0.1184830519690514, -0.1041216287710216, 0.3642445351984871,
0.31553976990455146, -0.5, -0.5,
-0.5, -0.2962917316264928, -0.21768007742518125,
-0.5, 0.5, -0.3874934493261728,
0.5, 0.5, -0.11942701707363246,
-0.5, 0.3310883786941121, 0.4471130857691563,
0.5, -0.43881176361159335, 0.013687868874663112,
-0.3228746588064053, 0.5, 0.5,
0.22918802851082076, 0.4201261891151049, -0.1219201358919022,
0.4999999999999981, -0.5000000000000019, 0.42308039185072366,
0.3754252329777854, -0.5, 0.21050827238066772,
-0.5, 0.15000252637603517, 0.5,
-0.4999999999999956, -0.12259063342341574, 0.5000000000000018,
-0.07677821619031633, -0.5, 0.32791066815043624,
0.49999999999999795, -0.27980192295644246, 0.4781244214723769,
-0.5, -0.060845412403597754, 0.39212451901706635,
0.14387678123323377, 0.28635792049446884, -0.398109385075855,
0.2674751483785427, 0.5, -0.09018903010765422,
0.3155397699045525, -0.4999999999999998, -0.5000000000000006,
0.11179168372605064, 0.04262821634035774, 0.3033342278137696,
0.5, -0.19229088208411294, 0.5,
-0.2557743127418759, -0.2924723632751689, 0.49482350782444695,
-0.30230069683417726, 0.5, 0.5,
-0.5, -0.5, -0.39087261397996476,
-0.5, 0.43127833523324854, 0.5,
-0.3650976861999604, -0.3821382391850974, -0.06945860420850525,
-0.5, 0.006955633152686547, 0.15271346323037172,
-0.30783110282724624, -0.5, -0.5,
0.15465536844281558, 0.5, 0.5,
0.24796818162808765, -0.5, -0.5,
-0.2647341088300892, -0.5000000000000004, -0.500000000000001,
-0.5, 0.5, -0.39664922699106997,
-0.34148179023934233, 0.5, -0.5,
0.008759466580053665, -0.5, -0.5,
0.20608801411754074, -0.5, -0.26805328319418553,
-0.2646926693115472, 0.30802418479417604, -0.5,
0.35519899579469727, -0.5, -0.3180057740932094,
0.5, 0.051103483700379426, 0.2720984895459235,
0.152798723486258, -0.12180864111806078, -0.5,
-0.5, 0.09472666241825434, 0.046619174228559546
	   };
	
	   pnts = new double[]
	      {21, 0, 0,
                 0, 21, 0,
                 0, 0, 0,
                 18, 2, 6,
                 1, 18, 5,
                 2, 1, 3,
                 14, 3, 10,
                 4, 14, 14,
                 3, 4, 10,
                 10, 6, 12,
	       5, 10, 15 
	      };

	   pnts = new double[]
	      {
	       -0.0832416676665641, -0.6268380000000001, 0.01618810170993468,
	       -0.06645753064772378, -0.6268380000000001, 0.03209558106510184,
	       -0.08250583595837066, -0.6268380000000003, 0.04640936607592372,
	       -0.09540550752166321, -0.6268380000000001, 0.040022311619207926,
	       -0.09923240116000509, -0.6268380000000006, 0.032169760608348266,
	       -0.09733909231830243, -0.6268380000000006, 0.02260186781147554,
	      };

	   pnts = new double[]
	      {
		13.542167125341255, -34.901568513192224, -8.890685532927796,
		13.391226992741338, -35.09872975912735, -8.73215356825621,
		13.936534328788532, -34.38643814012903, -9.304886575446039,
		13.18962755585526, -35.36206301078714, -8.520415089733193
	      };

	   animatedHull.setDebug (true);
	   animatedHull.build (pnts, pnts.length/3);
	   animatedHull.check (System.out);
	   System.out.println ("hull checked");
	 }

	public boolean isTranslucent()
	 {
	   return false;
	 }

	public void updateBounds (maspack.matrix.Point3d pmin, 
				  maspack.matrix.Point3d pmax)
	 { 
	   maspack.matrix.Point3d tmpPnt = new maspack.matrix.Point3d();
	   for (int i=0; i<numPoints; i++)
	    { Vertex vtx = pointBuffer[i]; 
	      tmpPnt.set (vtx.pnt.x, vtx.pnt.y, vtx.pnt.z);
	      tmpPnt.updateBounds (pmin, pmax);
	    }
	 }

	public void addObjectsToSelectionPath(
	   java.util.LinkedList list, int[] idList, int idIdx)
	 { 
	   int id = idList[idIdx];
	   int numFaces = faces.size();
	   if (id >= 0)
	    { if (id < numFaces)
	       { System.out.println ("Selected face " + id); 
	       }
	      else if (id < numFaces + numPoints)
	       { System.out.println ("Selected point " + (id-numFaces)); 
	       }
	    }	   
	 }
	
}


