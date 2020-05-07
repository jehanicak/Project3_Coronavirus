/*
  ReceiveData
  by Scott Kildall
  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch)
  ** second fied is 0-4095 (potentiometer)
  ** third field is 0-4095 (LDR) —— NOT YET IMPLEMENTED
  
  
    Will change the background to red when the button gets pressed
    Will change speed of ball based on the potentiometer
    
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort; 



// Data coming in from the data fields
String [] data;
int switchValue = 0;    // index from data fields
int potValue = 1;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 4;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems

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





void setup ( ) {
  size (1400,  800);
  
  frameRate(5);

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
  //COMEBACK AT END --------------------------------------------------------------------------!!!!!!!!!!!!!!!!!!!!!!!
  myPort  =  new Serial (this, Serial.list()[serialIndex],  115200); 
  
  ////making all my timers
  //timerOne = new Timer(5000);
  
  ////starting the timers 
  //timerOne.start();
  
} 




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
    potValue = int(data[1]);
  }
} 

//-- change background to red if we have a button
void draw () {  
  
  background(0);
  
  checkSerial();
  
  //State Machine
  
  if(state == openingTitlePage){
    drawOpeningTitlePage();
  }
  
  else if(state == MaskState){
    drawMaskState();
    
    if( switchValue == 1 ){
      image(maskTextOne, width/2 - 550, height/2 + 100, 111, 113);
      image(maskTextTwo, width/2 + 450, height/2 + 100, 128, 113);

    }
    
    else if(potValue > 0 && potValue < 500){
     if(bStarted == false ) {
       normalTimer.start();
       image(normal, 0, 0, 1400, 800);
     }
  }
    
  } 
  else if(state == PersonState){
    drawPersonState();
    
    if(potValue >= 0 && potValue < 1000){
      image(person,width/2 - 105, height/2 - 75, 164, 369);
     }
     
    else if(potValue >= 1000 && potValue < 2000){
      image(poolboy,width/2 - 180, height/2 - 75, 350, 369);
    }
    
    else if(potValue >= 2000 && potValue < 5000){
      image(hasmat,width/2 - 145, height/2 - 100, 264, 401);
    }
  } 
  
  else if(state == HouseBubbleState){
    drawHouseBubbleState();
    image(house, width/2 - 320, height/2 - 75, 614, 381); 
    
     if( switchValue == 1 ){
      image(housebreak, width/2 - 320, height/2 - 75, 614, 381);

    }
  }
  
  else if(state == OuterSpaceState){
    drawOuterSpaceState();
    image(planet, width/2 - 500, height/2 + 50, 298, 298);
    
     drawBall();
    
  }
  
    else if(state == EndTitleState){
    drawEndTitleState();
  }
  
}

//--------------- these are all of my states ------------------
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

//-- animate ball left to right, use potValue to change speed
void drawBall() {
    fill(255,0,0);
    image(ship, xShipPos, yShipPos, shipDiameter, 54);
    float speed = map(potValue, minPotValue, maxPotValue, minShipSpeed, maxShipSpeed);
    
    //-- change speed
    xShipPos = xShipPos + (speed * direction);
    
    //-- make adjustments for boundaries
    adjustBall();
}

//-- check for boundaries of ball and make adjustments for it to "bounce"
void adjustBall() {
  if( xShipPos > xShipMax ) {
    direction = -1;    // go left
    xShipPos = xShipMax;
  }
  else if( xShipPos < xShipMin ) {
    direction = 1;    // go right
    xShipPos = xShipMin;
  }
}

// THIS IS HOW TO SWITCH INBETWEEN MY STATES - USE NUMBERS 0 - 5 TO GET TO STATES
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
