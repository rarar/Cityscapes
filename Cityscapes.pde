import processing.pdf.*;
import org.processing.wiki.triangulate.*;


ArrayList triangles = new ArrayList();
ArrayList points = new ArrayList();
ArrayList colors = new ArrayList();

PImage img;

void setup() {
  background(0);
  img = loadImage("MassAveChristianScience.jpg");
  noLoop();
  size(img.width, img.height, PDF, "TEST.pdf");
  smooth();

  // looking at left pixels, so skip first column
  for (int y = 0; y < height; y++) {
    for (int x = 1; x < width; x++) {
      int loc = x + y * width;
      color pix = img.pixels[loc];

      int leftLoc = (x-1) + y * width;
      color leftPix = img.pixels[leftLoc];
      float diff = abs(brightness(pix) - brightness(leftPix));
      if (diff > 42 ) {
        points.add(new PVector(x, y, 0));
        colors.add(color(pix));
      }
    }
  }

  //tint(190, 153, 185, 200);

  // get the triangulated mesh
  triangles = Triangulate.triangulate(points);
}

void draw() {
  noStroke();
  tint(255, 145);
  image(img, 0, 0);
  for (int i = 0; i < points.size(); i++) {
    PVector p = (PVector)points.get(i);
    color c = (Integer)colors.get(i);
    if (i%10==0) println(c);
    fill(c, 10);
    ellipse(p.x + random(-10, 10), p.y + random(-10, 10), 2, 2);
  } 

  // draw the mesh of triangles
  //stroke(noise(20), noise(20), noise(30), 80*noise(10));

  noFill();
  beginShape(TRIANGLES);

  for (int i = 0; i < triangles.size(); i++) {
    Triangle t = (Triangle)triangles.get(i);
    if (i%3==0 && i < colors.size()) {
      color c = (Integer)colors.get(i);
      noStroke();
      fill(c, 140 + int(random(-20, 20)));
    } 
    else {
      noFill();
      stroke(255, 20 + int(random(-20, 20)));
    }

    //stroke(255, 60*noise(0.05));
    //stroke(c, 20);
    vertex(t.p1.x  + random(-5, 5), t.p1.y  + random(-5, 5));
    vertex(t.p2.x  + random(-5, 5), t.p2.y  + random(-5, 5));
    vertex(t.p3.x  + random(-5, 5), t.p3.y  + random(-5, 5));
  }
  endShape();
  exit();
}

void keyPressed() {
  if (key==' ')
    save("MassAveChristianScience-Triangles.jpg");
}

