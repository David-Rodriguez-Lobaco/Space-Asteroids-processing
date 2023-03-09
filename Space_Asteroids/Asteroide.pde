class Asteroide {
  float x, y, vy, vx, angulo;
  PImage img;
  color c;

  Asteroide(float _x, float _y, PImage _img)
  {
    angulo = 0;
    x = _x;
    y = _y;
    if (y<height/2)
    {
      vy = random(0, height/350);
    } else { 
      vy = -random(0, height/350);
    }
    vx = -random(2, width/150);
    //vx = -random(1, width/200);
    img = _img;
    c = color(255, 0);
  }
  void dibujate()
  {
    x = x + vx;
    y = y + vy;

    push(); //pushMatrix() + pushStyle();
    angulo = angulo+0.10;
    fill(c);
    translate(x, y);
    rotate((angulo));
    ellipse(0, 0, 90, 90);
    image(img, 0, 0, 90, 90);
    pop(); //popMatrix() + popStyle();
  }
}
