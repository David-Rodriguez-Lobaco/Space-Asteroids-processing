class Nave {
  float x, y;
  PImage img;
  color c;
  Nave(float _x, float _y, PImage _img)
  {
    x = _x;
    y = _y;
    img = _img;
    c=color(250, 250, 250, 0); // transparente    //c = color(random(75,200),0,0); //rojo
  }

  void mover() //realiza el movimiento de la nave
  {
    posicion();
    push();
    fill(c);
    triangle(x, y-50, x, y+50, x+87, y);
    image(img, x+47, y, 100, 100);
    pop();
  }

  void posicion() //calula la distancia al raton. Cuanto mas lejos este mas rapido
    //se mueve
  {
    if (y < mouseY)
    {
      float distancia = mouseY - y;
      distancia = distancia/20;
      if (distancia<0.01)
      {
        distancia = 0;
      }
      y = y+distancia;
    } else if (y > mouseY)
    {
      float distancia = y - mouseY;
      distancia = distancia/20;
      if (distancia<0.01)
      {
        distancia = 0;
      }
      y = y-distancia;
    }
  }
}

class Nave2
{
  float tiempo = 0;
  int vida = 25;
  float x, y;
  PImage img;
  float colorExplosion;
  int tiempoExplosion = 0;
  Nave2(float _x, float _y, PImage _img)
  {
    x = _x;
    y = _y;
    img = _img;
  }

  void mover()
  {
    posicion();
    push();
    fill(0, 255, 255, 0);
    triangle(x, y-50, x, y+50, x-87, y);
    imageMode(CENTER);
    image(img, x-47, y, 100, 100);
    pop();
  }

  float dist = 0;
  void posicion() //Le doy posiciones aleatorias a las que moverse
  {
    if (tiempo == 0)
    {
      dist = random(-50, height+50);
    }
    if (y < dist)
    {
      float distancia = dist - y;
      distancia = distancia/40;
      if (distancia<0.01)
      {
        distancia = 0;
      }
      y = y+distancia;
    } else if (y > dist)
    {
      float distancia = y - dist;
      distancia = distancia/40;
      if (distancia<0.01)
      {
        distancia = 0;
      }
      y = y-distancia;
    }
    tiempo++;
    if (tiempo == 50)
    {
      tiempo = 0;
    }
  }

  void estatica()
  {
    push();
    fill(0, 255, 255, 0);
    triangle(x, y-50, x, y+50, x-87, y);
    imageMode(CENTER);
    image(img, x-47, y, 100, 100);
    pop();
  }

  void destruir()
  {
    push();
    fill(0, 255, 255, 0);
    if (tiempo >= 9)
    {
      colorExplosion = random(50, 200);
      tiempo = 0;
    }
    triangle(x, y-50, x, y+50, x-87, y);
    imageMode(CENTER);
    tint(colorExplosion, colorExplosion, 0);
    image(img, x-47, y, 100, 100);
    pop();
    tiempoExplosion++;
    tiempo++;
    if (tiempoExplosion == 300)
    {
      estado = 7;
    }
  }
}
