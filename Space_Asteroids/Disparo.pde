class disparo {
  float x, y;
  PImage img;
  color c;
  disparo(float _x, float _y, PImage _img)
  {
    x = _x;
    y = _y;
    img = _img;
    c=color(250, 250, 250, 0); // transparente    //c = color(random(75,200),0,0); //rojo
  }


  void disparar() //movimiento del disparo
  {
    if (estado != 5)
    {
      x = x + 3;
    } else
    {
      x = x+7;
    }
    push(); 
    fill(c);
    ellipse(x+10, y, 10, 5);
    image(img, x+10, y, 10, 5);
    pop(); //pop
  }
}

class disparo2 {
  float x, y;
  PImage img;
  color c;
  disparo2(float _x, float _y, PImage _img)
  {
    x = _x;
    y = _y;
    img = _img;
    c=color(250, 250, 250, 0); // transparente    //c = color(random(75,200),0,0); //rojo
  }

  void disparo()
  {
    x = x - 6;
    push(); 
    fill(c);
    ellipse(x-10, y, 10, 5);
    image(img, x-10, y, 10, 5);
    pop(); //pop
  }
}

class rayoDeLaMuerte {  /////ES TAN MORTAL QUE SI TE MATA RENACES MUERTO//////
  float x, y;
  PImage img;
  color c;
  rayoDeLaMuerte(float _x, float _y, PImage _img)
  {
    x = _x;
    y = _y;
    img = _img;
    c=color(250, 250, 250, 0);
  }

  void disparoDeLaMuerteMortalDeLaMuerte()
  {
    if (rayo < 40) // && aniquilador == 1
    {
      fill(0, 255, 150,0);
      rect(0, y-50, width-130, 100);
      image(img, width/2-130, y, width, 200);
      rayo++;
      if(sDisparoMortal == 0)
      {
        sDisparoMortal = 1;
        sonidoRayoMortal.trigger();
      }
    } else {
      aniquilador = 0;
      sDisparoMortal = 0;
      for (int M = 0; M < rayoMortal.size(); M++)
      {
        rayoMortal.remove(M);
      }
      rayo = 0;
    }
  }
}
