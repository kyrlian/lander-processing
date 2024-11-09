int terrainResolution = 200;
float[] terrain = new float[terrainResolution];
float flatStart, flatEnd;
float landerX, landerY;
float landerVX, landerVY;
boolean leftThruster, rightThruster;
int score = 0;
boolean crashed = false;

void setup() {
  //size(800, 600);
  generateTerrain();
  resetGame();
}

void draw() {
  if (crashed) {
    background(255, 0, 0); // Flash red on crash
    delay(10); // Short delay to show the red flash
    resetGame(); // Reset game after crash
    return;
  } else {
    background(0);
  }
  drawTerrain();
  updateLander();
  drawLander();
  fill(255);
  textSize(16);
  text("Score: " + score, 10, height - 10);
}

void resetGame() {
  landerX = width / 2;
  landerY = 50;
  landerVX = 0;
  landerVY = 0;
  leftThruster = false;
  rightThruster = false;
  crashed = false;
}

void generateTerrain() {
  float noiseScale = 0.1;
  noiseSeed(int(random(1000)));
  for (int i = 0; i < terrainResolution; i++) {
    terrain[i] = noise(i * noiseScale) * height / 2 + height / 2;
  }
  int flatPosition = int(random(terrainResolution - terrainResolution / 10));
  flatStart = map(flatPosition, 0, terrainResolution, 0, width);
  flatEnd = map(flatPosition + terrainResolution / 10, 0, terrainResolution, 0, width);
  for (int i = flatPosition; i < flatPosition + terrainResolution / 10; i++) {
    terrain[i] = height - height / 4; // Flat surface
  }
}

void drawTerrain() {
  stroke(255);
  for (int i = 1; i < terrainResolution; i++) {
    float x1 = map(i - 1, 0, terrainResolution -1 ,0 , width);
    float y1 = terrain[i -1];
    float x2 = map(i ,0 ,terrainResolution -1 ,0 ,width);
    float y2 = terrain[i];
    
    line(x1,y1,x2,y2);
    
    if (x1 >= flatStart && x2 <= flatEnd) {
      stroke(0,255,0); // Green for flat surface
      line(x1,y1,x2,y2);
      stroke(255); // Reset color
    }
   }
}

void drawLander() {
   fill(255);
   rectMode(CENTER);
   rect(landerX, landerY,20 ,20); 
   fill(255,0,0); // Red color for thrusters
   if (leftThruster) {
     triangle(landerX -10 ,landerY+10 ,landerX-15 ,landerY +15 ,landerX-5 ,landerY+15 );
   }
   
   if (rightThruster) {
     triangle(landerX +10 ,landerY +10 ,landerX+15 ,landerY +15 ,landerX+5 ,landerY+15 );
   }
   fill(255);
}

void updateLander() {
   float thrustX=.05;
   float thrustY=.07;
   float gravity=.05;
   if (leftThruster) {
     landerVX +=thrustX;
     landerVY -=thrustY;
   }
   if (rightThruster) {
     landerVX -=thrustX;
     landerVY -=thrustY;
   }
   landerVY +=gravity; // Gravity effect
   landerX +=landerVX;
   landerY +=landerVY;
   // Wrap around screen
   if(landerX < -10) landerX = width +10;
   if(landerX> width+10) landerX = -10;
   checkCollision();
}

void checkCollision() {
   int index =(int) map(landerX ,0 ,width ,0 ,terrainResolution -1 );
   if (landerY >= terrain[index]) { // Collision with terrain
     if (landerX >flatStart && landerX <flatEnd && abs(landerVX) <3&& abs(landerVY) <3) { 
       score++;
       generateTerrain();
       resetGame(); // Successful landing
     } else {
       crashed = true; // Crash landing
       score=0;
     }
   }
}

void mousePressed() {
   if (mouseX <width /3) { 
     leftThruster=true;
   } else if (mouseX >width *2/3) { 
     rightThruster=true;
   } else { 
     leftThruster=true;
     rightThruster=true;
   }
}

void mouseReleased() {
   leftThruster=false;
   rightThruster=false;
}