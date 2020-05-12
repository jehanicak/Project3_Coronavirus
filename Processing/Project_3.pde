// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort; 



// Data coming in from the data fields
String [] data;
int switchValue = 0;
int LDRValue = 1;

// This is the index that my port was at (4)
int serialIndex = 4;

// animating and tracking min and max values 
//In class you told me to keep this value and to just set the pot value to the 
int minLDRValue = 0;
int maxLDRValue = 4095;    // will be 1023 on other systems

//timer
Timer normalTimer;
//boolean for timer
boolean bStarted = false;

// this is the start of my state machiene
int stateChange;
int state = 1;
int openingTitlePage = 1;
int MaskState = 2;
int PersonState = 3;
int HouseBubbleState = 4;
int OuterSpaceState = 5;
int EndTitleState = 6;

//opener assets
PImage opener;

//mask assets
PImage maskBackground;
PImage maskExpo;
PImage maskSmall;
PImage maskTextOne;
PImage maskTextTwo;
PImage normal;

//person assets
PImage person;
PImage hasmat;
PImage poolboy;
PImage distencersBackground;

//house assets
PImage house;
PImage housebreak;
PImage housebackground;

//outerspace
PImage spacebackground;
PImage planet;
PImage ship;

//end
PImage ending;

//for the spaceship (taken and modified from the ball example in class
int minShipSpeed = 0;
int maxShipSpeed = 150;
int hShipMargin = 40; 
int shipDiameter = 122;// margin for edge of screen
int xShipMin;        // calculate on startup
int xShipMax;        // calc on startup
float xShipPos;        // calc on startup, use float b/c speed is float
int yShipPos;        // calc on startup
int direction = -1;    // 1 or -1



//setup ----------------------------------------------------------------------------------

void setup ( ) {
  size (1400,  800);
  
  frameRate(5);

  // I am loading all of my images attached to the assets file here 
  opener = loadImage("assets/opener.png"); // Load the image
  maskSmall = loadImage("assets/mask_Small.png");
  maskBackground = loadImage("assets/mask_Background.png"); // Load the image
  maskTextOne = loadImage("assets/mask_Text_One.png"); // Load the image
  maskTextTwo = loadImage("assets/mask_Text_Two.png"); // Load the image
  person = loadImage("assets/dman_One.png"); // Load the image
  poolboy = loadImage("assets/dman_Two.png"); // Load the image
  hasmat = loadImage("assets/dman_Three.png"); // Load the image
  distencersBackground = loadImage("assets/The_Distincers_Background.png");
  housebackground = loadImage("assets/The_Bubblers.png");
  house = loadImage("assets/house_Under_Bubble.png");
  housebreak = loadImage("assets/House_Crack.png");
  spacebackground = loadImage("assets/the_Leavers_Background.png");
  planet = loadImage("assets/planet.png");
  ship = loadImage("assets/ufo.png");
  ending = loadImage("assets/end.png");
  normal = loadImage("assets/Normal.png");
  
  //variables for my ship animation
  xShipMin = width/2 - 300;
  xShipMax = width - hShipMargin;
  xShipPos = width/2;
  yShipPos = height/2;
  
  //timer
  normalTimer = new Timer(5000);

  normalTimer.start();
  
 
  
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, Serial.list()[serialIndex],  115200); 
  
} 


//check serial function ------------------------------------------------------------------

// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer = (trim(inBuffer));
    
    data = split(inBuffer, ',');
 
    // do an error check here?
    switchValue = int(data[0]);
    LDRValue = int(data[1]);
  }
} 


//draw function ----------------------------------------------------------------------
//-- change background to red if we have a button
void draw () {  
  
  background(0);
  
  checkSerial();
  
  //State Machine---------------------------------------------------------------------
  
  //first page
  if(state == openingTitlePage){
    drawOpeningTitlePage();
  }
  //second page
  else if(state == MaskState){
    drawMaskState();
    
    if( switchValue == 1 ){
      image(maskTextOne, width/2 - 550, height/2 + 100, 111, 113);
      image(maskTextTwo, width/2 + 450, height/2 + 100, 128, 113);

    }
    
    else if(LDRValue > 0 && LDRValue < 500){
     if(bStarted == false ) {
       normalTimer.start();
       image(normal, 0, 0, 1400, 800);
     }
  }
    
  } 
  //third page
  else if(state == PersonState){
    drawPersonState();
    
    if(LDRValue >= 0 && LDRValue < 1000){
      image(person,width/2 - 105, height/2 - 75, 164, 369);
     }
     
    else if(LDRValue >= 1000 && LDRValue < 2000){
      image(poolboy,width/2 - 180, height/2 - 75, 350, 369);
    }
    
    else if(LDRValue >= 2000 && LDRValue < 5000){
      image(hasmat,width/2 - 145, height/2 - 100, 264, 401);
    }
  } 
  
  //fourth page
  else if(state == HouseBubbleState){
    drawHouseBubbleState();
    image(house, width/2 - 320, height/2 - 75, 614, 381); 
    
     if( switchValue == 1 ){
      image(housebreak, width/2 - 320, height/2 - 75, 614, 381);

    }
  }
  
  //fifth page
  else if(state == OuterSpaceState){
    drawOuterSpaceState();
    image(planet, width/2 - 500, height/2 + 50, 298, 298);
    
     drawShip();
    
  }
    //sixth page
    else if(state == EndTitleState){
    drawEndTitleState();
  }
  
}

// these are all of my functions --------------------------------------------
void drawOpeningTitlePage(){
  image(opener, 0, 0, 1400, 800);
}

void drawMaskState(){
  image(maskBackground, 0, 0, 1400, 800);
  image(maskSmall, width/2 - 270, height/2 - 75, 518, 382);
  
}

void drawPersonState(){
  image(distencersBackground, 0, 0, 1400, 800);
  
}

void drawHouseBubbleState(){
  image(housebackground, 0, 0, 1400, 800);
}

void drawOuterSpaceState(){
  image(spacebackground, 0, 0, 1400, 800);
}

void drawEndTitleState(){
  image(ending, 0, 0, 1400, 800);
}

// (This ship code was taken an dmodified from our in class ball moving example)
//-- animate ship left to right, use LDRValue to change speed
void drawShip() {
    fill(255,0,0);
    image(ship, xShipPos, yShipPos, shipDiameter, 54);
    float speed = map(LDRValue, minLDRValue, maxLDRValue, minShipSpeed, maxShipSpeed);
    
    //-- change speed
    xShipPos = xShipPos + (speed * direction);
    
    //-- make adjustments for boundaries
    adjustShip();
}

//-- check for boundaries of ship and make adjustments for it to "bounce"
void adjustShip() {
  if( xShipPos > xShipMax ) {
    direction = -1;    // go left
    xShipPos = xShipMax;
  }
  else if( xShipPos < xShipMin ) {
    direction = 1;    // go right
    xShipPos = xShipMin;
  }
}

// THIS IS HOW TO SWITCH INBETWEEN MY STATES - USE NUMBERS 0 - 6 TO GET TO STATES
void keyPressed(){
  if(key == '1'){
    state = openingTitlePage;
  }
  

  else if(key == '2'){
    state = MaskState;
  }
  
  else if(key == '3') {
    state = PersonState;
  }
  
  else if(key == '4'){
    state = HouseBubbleState;
  }
  
   else if(key == '5'){
    state = OuterSpaceState;
  }
  
   else if(key == '6'){
    state = EndTitleState;
  }
  
}
