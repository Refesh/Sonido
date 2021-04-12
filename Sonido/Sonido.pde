import processing.sound.*;
Amplitude nivel ;
SoundFile file;
ArrayList<float[]> drop = new ArrayList<float[]>();
float fallSpeed = 2;

int frecuencies = 512;
float[] spectrum = new float[frecuencies];
float radius = 30;
FFT fft;

void setup() {
  size(850, 650, P3D);
  file = new SoundFile(this, "Imagine.mp3");
  fft = new FFT(this, frecuencies);
  
  // patch the AudioIn
  fft.input(file);
  nivel = new Amplitude(this);
  nivel.input(file);
  file.loop();
  frameRate(400);
}

void draw(){
  background(230,230,250);
  float[] newDrop = {random(0, width), 0};
  drop.add(newDrop);
  radius = radius * 0.92 + (100 * nivel.analyze() + 30)*0.08;
  for(int i = 0; i < drop.size(); i++){    
    line(drop.get(i)[0], drop.get(i)[1], drop.get(i)[0]+1, drop.get(i)[1] + 2);
    float[]newVal = {drop.get(i)[0], drop.get(i)[1] + fallSpeed};
    drop.set(i, newVal);
    if (drop.get(i)[1] > height) drop.remove(i);
  }
  
  fft.analyze(spectrum);
  
  drawCircle();
}

void drawCircle(){
  float angle = 0;
  for(int i = 1; i < frecuencies; i++){
    angle = radians(frecuencies * 360 / i);
    line(radius * cos(angle) + width/2, radius*sin(angle)+ height/2, spectrum[i]*height * cos(angle)+ radius * cos(angle)+ width/2, height/2+spectrum[i]*height * sin(angle)  + radius*sin(angle));
  } 
}
