import controlP5.*;

ControlP5 cp5;
public int myColor = color(0,0,0);

public float sliderPosition; 

public int sliderTicks2 = 255; // not sure what this does. 
Slider abc;

void setup() {
  size(900,515);
  noStroke();
  cp5 = new ControlP5(this);
  
 
  cp5.addSlider("sliderTicks2")
     .setPosition(400,300)
     .setWidth(400)
     .setRange(-3,3) // values can range from big to small as well
     .setValue(0)
     .setNumberOfTickMarks(7)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
  // by default it is Slider.FIX
  

}

void draw() {
  /* these just move all the other sliders.
  background(sliderTicks1);

  fill(sliderValue);
  rect(0,0,width,100);
  
  fill(myColor);
  rect(0,280,width,70);*/
  sliderPosition = cp5.getValue("sliderTicks2");
  
 PImage img;
  if(sliderPosition==0){
  img = loadImage("jellyfish-brightness1.png");
  }
  else if(sliderPosition == -1)
  img = loadImage("jellyfish-brightness8.png");
  else if(sliderPosition == -2)
  img = loadImage("jellyfish-brightness9.png");
    else if(sliderPosition == -3)
  img = loadImage("jellyfish-brightness10.png");
  else if(sliderPosition == 1)
  img = loadImage("jellyfish-brightness3.png");
  else if(sliderPosition == 2)
  img = loadImage("jellyfish-brightness4.png");
   else if(sliderPosition == 3)
  img = loadImage("jellyfish-brightness5.png");
  else
  img = loadImage("jellyfish-brightness4.png");
  
  
  image(img, 20, 20, 900, 515);
  textSize(12);
  fill(0);
  text("BRIGHTNESS", 400, 295);
  
  
}

void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
}










