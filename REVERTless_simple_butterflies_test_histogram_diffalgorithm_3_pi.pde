/* @pjs preload="butterflies_350x458.jpg"; */

PImage input;       // Source image
PImage output;  // Destination image
//PImage output;  // Destination image
int gutter_size = 300;
int frame_size = 20;
int startcont = 2; 
float gbrightness=0.00;
int gcontrast=1; 
int[] hist = new int[256];
int origrVal = 249; 
int origgVal=110; 
int origbVal=64;
int rVal = origrVal;
int gVal = origgVal;
int bVal = origbVal;
color picked = color(249,110,64);
//int sliderVal2 = 0;


void setup() {
  //size(700+(2*frame_size)+gutter_size, 400+(2*frame_size)+gutter_size); 
  // 700+(2*20)+300, 400+2*20+300 = 1040, 740
  //size(1040, 740);
  size(1040, 800);
  //size(800,400); 
  input = loadImage("butterflies_350x458.jpg");
  // Create an empty image with same dimensions as source
  output = createImage(input.width, input.height, RGB);
  textSize(12); 
  colorMode(RGB);
}

void draw() {  
  background(255);
  fill(0); 
 
  //image(input,0,0);
 
  //2. call output function with values calculated by other functions
  processFunction(input, output, gcontrast, gbrightness);
 
  //3. DISPLAY IMAGE 
  input.updatePixels();
  output.updatePixels();
  image(input,0+frame_size,0+frame_size-2);// frame_size-2 b/c it just looked better
  text("original", 0+frame_size+458-20, 0+frame_size-2+350+15);
  image(output,input.width+2*frame_size,0+frame_size-2); // frame_size-2 b/c it just looked better
  text("processed", 0+2*frame_size+2*458-10, 0+frame_size-2+350+15);
  
  //4. Draw Histogram
  //if(histButtonClicked)
  //else if (formula button clicked)
  drawHistogram(output);
  
  //5. Draw Equation
  drawEquation();
}

void changeBrightness(float tbrightness){
  // have to force brightness to be an integer in order for algorithm to work
 gbrightness=int((tbrightness/50)*50); 
 println(gbrightness);
}

void changeContrast(int tcontrast){
  gcontrast=(int)tcontrast/50; 
  println(gcontrast);
}

void drawHistogram(PImage img){
  //PImage img= loadImage("butterflies_350x458.jpg");
  int[] hist = new int[256];
// Calculate the histogram
for (int i = 0; i < img.width; i++) {
  for (int j = 0; j < img.height; j++) {
    int bright = int(brightness(img.get(i, j)));
    hist[bright]++; 
  }
}

// Find the largest value in the histogram
int histMax = max(hist);

stroke(50);
// Draw half of the histogram (skip every second value)
//for (int i = 0; i < (img.width)/2; i += 2) {
for (int i = 0; i < (img.width); i += 2) {
  // Map i (from 0..img.width) to a location in the histogram (0..255)
  int which = int(map(i, 0, img.width, 0, 255));
  int histHeight=150;
  // Convert the histogram value to a location between 
  // the bottom and the top of the picture
  //int y = int(map(hist[which], 0, histMax, img.height, 0));
  int x = int(map(i, 0, (img.width)-1, 0, 200));
  int y = int(map(hist[which], 0, histMax, histHeight, 0));
  line(x+800, (histHeight)+400, x+800, y+400);
}
}

void processFunction(PImage input2, PImage output2, int gcont, float gbright){
  
//we assume the images are of equal dimension 
   //so test this here and if it's not true just return with a warning
   if(input2.width !=output2.width || input2.height != output2.height)
   {
     println("error: image dimensions must agree");
     return;
   }
   
  //loop through source pixels 
  for (int x = 0; x < input2.width; x++) {
    for (int y = 0; y < input2.height; y++ ) {
      // calculate pixel location
      int loc = x + y*input2.width;
      //BRIGHTNESS
      //float bright = 255 * ( 2*mouseY / (float)width - 1); // change so range from black to white
      color inColor = input2.pixels[loc];
      
      //int r = (int) red(input2.pixels[loc]);
      //int g = (int) green(input2.pixels[loc]);
      //int b = (int) blue(input2.pixels[loc]);
      
        //here the much faster version (uses bit-shifting) courtesy of dr.mo: http://forum.processing.org/one/topic/increase-contrast-of-an-image.html
       int r = (inColor >> 16) & 0xFF; //like calling the function red(), but faster
       int g = (inColor >> 8) & 0xFF;
       int b = inColor & 0xFF;      
      
      // brightness is linear arithmetic
      // contrast is multiplication, but normalize brightness we first subtract 128, multiply, then add back in. 
      // default brightness: 0
      // default contrast: 1
      r = (int)(((r-128)*gcont +128) + gbright); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      g = (int)(((g-128)*gcont +128) + gbright);
      b = (int)(((b-128)*gcont +128) + gbright);
      
      //r = (int)(r + 50*gcont); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      //g = (int)(g + 50*gcont);
      //b = (int)(b + 50*gcont);
            
      // restricts values to between 0 and 255
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;
      
      //output.pixels[loc] = color(r,g,b);
      output.pixels[loc]= 0xff000000 | (r << 16) | (g << 8) | b; //this does the same but faster; again, courtesy of dr.mo
    }
  }
 }
 
void drawEquation(){
  //equation box
  fill(0);
  color myPurple = color(136, 63, 171);
  //black border
  rect(300, 400, 446, 234);
  //inner white rectangle 
  fill(255);
  rect(302, 402, 442, 230);
  // text label
  fill(0);
  //text("Equation Box", 320, 425);
  
  //if(brightness)
  String brighttext = "Brightness changes the pixel intensity by simply adding or subtracting values.";
  textLeading(12);
  textSize(14);
  text("BRIGHTNESS", 320, 429);
  textSize(12);
  text(brighttext, 320, 445);
  textSize(14);
  text("BRIGHTNESS ALGORITHM", 320, 485);
  fill(0);
  textSize(22);
  text("new = original + brightValue", 320, 509);
  textSize(14);
  text("BRIGHTNESS VALUES", 320, 547);
  //249 110 64
  if(mouseX >20 && mouseX < 478 && mouseY > 20 && mouseY < 370 && mousePressed){
  int x = mouseX-20;
  int y = mouseY-20;
  picked = input.get(x,y);  
}
  rVal = (int)red(picked) + gbrightness;
  if(rVal > 255){
    rVal = 255;
    }
    else  if(rVal < 0){
    rVal = 0;
    }
  gVal = (int)green(picked) + gbrightness;
    if(gVal > 255){
    gVal = 255;
    }
    else  if(gVal < 0){
    gVal = 0;
    }
  bVal = (int)blue(picked) + gbrightness;
    if(bVal > 255){
    bVal = 255;
    }
    else  if(bVal < 0){
    bVal = 0;
    }
// constrain values!!!!
// color text the intensity of each color
  color squareFill= color(rVal, gVal, bVal);
  rVal_orig = (int)red(picked);
  gVal_orig = (int)green(picked);
  bVal_orig = (int)blue(picked);
  color origSquareFill = color(rVal_orig, gVal_orig, bVal_orig);
//  //fill(rVal, gVal, bVal);
  fill(squareFill);
  //fill(picked);
  noStroke();
  rect(390, 552, 60, 60);
  fill(origSquareFill);
  noStroke();
  rect(320,552, 60, 60);
  //rect(mouseX, mouseY, 100, 100);
  String cords= rVal + "  " + bVal + "  " + gVal;
  fill(0);
//  text(cords, 380, 585);
  textSize(22);
  String stringRed = "Red:     " + rVal_orig + " + " + gbrightness + " = " + rVal;
  String stringG = "Green: " + gVal_orig + " + " + gbrightness + " = " + gVal;
  String stringB = "Blue:    " + bVal_orig + " + " + gbrightness + " = " + bVal;
  String RGBlabel = "("+rVal+", " + gVal + ", " + bVal+")";
  String RGBlabel = "("+rVal+", " + gVal + ", " + bVal+")";
  text(stringRed, 388+70, 570);
  text(stringG, 387+70, 590);
  text(stringB, 388+70, 610);
  int overallBrightSum = rVal + gVal + bVal;
  int overallBrightAvg = int(overallBrightSum/3);
  String imgBright = "Overall image brightness is the average of the red, green and blue intensities.";
  String imgBright1 = "OVERALL IMAGE BRIGHTNESS";
  String imgBright2 = "(" + rVal + " + " + gVal + " + " + bVal + ") /3 = " + overallBrightAvg;
//  textSize(12);
//  text(imgBright1, 30, 490);
//  fill(0);
//  text(imgBright, 30, 500, 250, 200);
//  textSize(22);
//  text(imgBright2, 30, 565);
}


