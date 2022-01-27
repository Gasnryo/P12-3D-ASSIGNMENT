import java.awt.Robot;

//colors
color black = #000000;
color white = #FFFFFF;

//textures
PImage mossyStone;
PImage oakPlanks;

//map variables
int gridSize;
PImage map;

//robot for mouse control
Robot cbt;

//camera variables
float eyeX, eyeY, eyeZ; //camera position
float focusX, focusY, focusZ; //point at which camera faces
float upX, upY, upZ; //tilt axis

//mouse movement
boolean skipFrame;

//keyboard variables
boolean wkey, akey, skey, dkey;

//rotation variables
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  //size(displayWidth, displayHeight, P3D);
  
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  textureMode(NORMAL);             
  try {
   cbt = new Robot(); 
  }
  catch(Exception e) {
   e.printStackTrace(); 
  }
  skipFrame = false;
  fullScreen(P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = height/2-100;
  upX = 0;
  upY = 1;
  upZ = 0;
  
  //initialize map
  map = loadImage("map.png");
  gridSize = 100;
  
  leftRightHeadAngle = radians(270);
  //noCursor();
  
}

void draw() {
  background(0);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  drawFloor(); 
  drawFocalPoint();
  controlCamera();
  drawMap();
  
  //move();
  //drawAxis();
  //drawFloor(-2000, 2000, height, 100);
  //drawFloor(-2000, 2000, 0, 100);
  //drawMap();
}

void drawMap() {
 for (int x = 0; x < map.width; x++) {
  for (int y = 0; y < map.height; y++) {
   color c = map.get(x, y);
   if (c != white) {
     //pushMatrix();
     //fill(c);
     //stroke(100);
     //translate(x*gridSize-2000, height/2, y*gridSize-2000);
     //box(gridSize,height,gridSize);
     //popMatrix();
     texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
     texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossyStone, gridSize);
     texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossyStone, gridSize);
   }
  }
 }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawFloor() {
  stroke(255);
  for (int x = -2000; x <= 2000; x = x+100) {
    line(x, height, -2000, x, height, 2000);
    line(-2000, height, x, 2000, height, x);
  }
}

void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2)*10;
  }
  if (skipFrame == false) {
  leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
  upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  
  //if (mouseX > width-2) cbt.mouseMove(3, mouseY);
  //else if (mouseX < 2) cbt.mouseMove(width-3, mouseY);
  if (mouseX < 2) {
    cbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else if (mouseX > width-2) {
    cbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else {
   skipFrame = false; 
  }
}


void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
