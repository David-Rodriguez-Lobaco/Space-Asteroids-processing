//David Rodriguez Lobaco
//Salvador Ruiz Sedeño

// Para controlar la nave se utiliza el raton y para disparar el raton o el piezoelectrico
//Colocar una resistencia de 1M ohm en paralelo conenctada a la entrada A0

import processing.serial.*;
Serial miPuerto;

import ddf.minim.*; //sonidos
Minim soundengine;
AudioSample sonidoDisparo;
AudioSample sonidoDisparo2;
AudioSample sonidoInicio;
AudioSample sonidoAsteroideDestruido;
AudioSample sonidoNave2Destruida;
AudioSample sonidoNaveDestruida;
AudioSample sonidoRayoMortal;
AudioSample sonidoWin;
AudioSample sonidoAttention;

ArrayList<Asteroide> listaAsteroide;
ArrayList<Nave> miNave;
ArrayList<Nave2> nEnemiga; //nave enemiga
ArrayList<disparo> listaPium; //mis disparos
ArrayList<disparo2> listaPium2; //disparo del jefe
ArrayList<rayoDeLaMuerte> rayoMortal;
PImage aste; //asteroide
PImage nav; //nave
PImage esp; //Espacio
PImage disp;
PImage nodr; //imagen de la nave del jefe final
PImage disp2;
PImage rayM;
int start = 0;
int textNivel = 60;
int nivelAct = 1;
int r = 0; //Contador para respawn de los asteorides
int rDif = 55; //cuando R = RD aparecera un asteroide. Lo pongo asi para poder cambiar la dificultad a medida que avanza el juego
int puntuacion = 0;
int astEli = 0; //numero de asteroides eliminados
int estado = 0; //estado del switch
int BG=0; //Transparencia del fondo
int nivel = 1;
int delayDisparo = 30;
int contadorDelay = 0;
int aniquilador = 0;
int rayo = 0;
int sI = 0; //para reproducir una vez el sonido de inicio
int sDisparoMortal = 0; //sonido del disparo
int sWin = 0; //sonido de victoria
//int valor = 0; 
float tiempo = millis();

void setup()
{
  fullScreen(P3D);     //FONDO Y PANTALLA COMPLETA
  esp = loadImage("fondo1366x768.png");
  image(esp, 0, 0, width, height);
  noCursor(); //Hace el cursor invisible

 // printArray(Serial.list());          //Comunicacion serie
  //String portName = Serial.list()[0];
 // miPuerto = new Serial(this, portName, 9600);

  soundengine = new Minim(this);  //CONFIGURACION DEL SONIDO
  sonidoInicio = soundengine.loadSample("sonidoInicio.mp3", 1024);
  sonidoWin = soundengine.loadSample("sonidoWin.mp3", 1024);

  listaAsteroide = new ArrayList<Asteroide>(); //Creacion lista asteroides
  aste = loadImage("aste.png");
  imageMode(CENTER);
  sonidoAsteroideDestruido = soundengine.loadSample("sonidoAsteroideDestruido.mp3", 1024);

  miNave = new ArrayList<Nave>(); //creacion de la nave
  imageMode(CENTER);
  nav = loadImage("nave.png");
  noStroke();
  Nave N = new Nave(30, height/2, nav);
  miNave.add(N);
  sonidoNaveDestruida = soundengine.loadSample("sonidoGameOver.mp3", 2024);

  listaPium = new ArrayList<disparo>(); //creacion lista de disparos, los que hare con el piezoelectrico
  disp = loadImage("disparo.png");
  imageMode(CENTER);
  sonidoDisparo = soundengine.loadSample("sonidoDisparo.mp3", 1024);

  listaPium2 = new ArrayList<disparo2>(); //DISPAROS DE LA NAVE ENEMIGA
  disp2 = loadImage("disparo2.png");
  imageMode(CENTER);
  sonidoDisparo2 = soundengine.loadSample("sonidoDisparo2.mp3", 1024); //sonido de los disparos
  sonidoRayoMortal = soundengine.loadSample("sonidoRayoMortal.mp3", 1024); //sonido del arma final
 
  rayoMortal = new ArrayList<rayoDeLaMuerte>();
  rayM =loadImage("rayoDeLaMuerteMortalDeLaMuerte.png");
  imageMode(CENTER);
  sonidoAttention = soundengine.loadSample("sonidoAttention.mp3", 1024);

  sonidoNave2Destruida = soundengine.loadSample("sonidoNave2Destruida.mp3", 1024);
}


void draw()
{
  while (miPuerto.available() > 0)
  {
    pulsarPiezoelectrico(miPuerto.read());
  }
  game();
}

//////////////////////////////////////////////////////////////FUNCIONES////////////////////////////////////////////////////////

void mousePressed() //REALIZA EL DISPARO
{
  if (estado == 5) //mas disparos contra el jefe
  {
    if (listaPium.size()<7)
    {
      sonidoDisparo.trigger();
      Nave posicion = miNave.get(0);
      disparo D = new disparo(117, posicion.y, disp);
      listaPium.add(D);
    }
  } else if (estado == 0 || estado == 3)
  {
    if (listaPium.size()<5) //normalmente solo puedes lanzar 5 disparos
    {
      sonidoDisparo.trigger();
      Nave posicion = miNave.get(0);
      disparo D = new disparo(117, posicion.y, disp);
      listaPium.add(D);
    }
  }
}

void pulsarPiezoelectrico(int Puerto)
{
  if (Puerto > 240)
  {
    if (tiempo + 250 <= millis())
    {
      tiempo = millis();

      if (estado == 5) //mas disparos contra el jefe
      {
        if (listaPium.size()<7)
        {
          sonidoDisparo.trigger();
          Nave posicion = miNave.get(0);
          disparo D = new disparo(117, posicion.y, disp);
          listaPium.add(D);
        }
      } else if (estado == 0 || estado == 3)
      {
        if (listaPium.size()<5) //normalmente solo puedes lanzar 5 disparos
        {
          sonidoDisparo.trigger();
          Nave posicion = miNave.get(0);
          disparo D = new disparo(117, posicion.y, disp);
          listaPium.add(D);
        }
      }
    }
  }
}

void respawnAsteroide() //hace que aparezcan los asteroides
{
  r++;
  if (r >= rDif) //cambiar valor para hacer que salgan mas o menos
  {
    r=0; 
    Asteroide A = new Asteroide(width, random(-120, height+120), aste);
    listaAsteroide.add(A);
  }
}

void moverAsteroide() //hace que se muevan los asteroides
{
  for (int i=0; i < listaAsteroide.size(); i++)
  {
    Asteroide A = listaAsteroide.get(i);
    A.dibujate();
  }
}

void destructorA() //Destruye los asteroides que se salen de la pantalla
{
  for (int i = listaAsteroide.size()-1; i>=0; i--)
  {
    Asteroide posicion = listaAsteroide.get(i);
    if (posicion.x < -45)
    {
      listaAsteroide.remove(i);
    }
  }
}

void destructorD() //destruye los disparos que se salgan de la pantalla
{
  for (int i = listaPium.size()-1; i>=0; i--)
  {
    disparo posicion = listaPium.get(i);
    if (posicion.x > width)
    {
      listaPium.remove(i);
      puntuacion = puntuacion-20;
    }
  }
}

void pium() //Mueve los disparos
{
  for (int i=0; i < listaPium.size(); i++)
  {
    disparo D = listaPium.get(i);
    D.disparar();
  }
}

void pium2() //Mueve los disparos de la nave enemiga
{
  for (int i = 0; i < listaPium2.size(); i++)
  {
    disparo2 E = listaPium2.get(i); 
    E.disparo();
  }
}

void colisionesAD() //Colisión entre asteroides y disparos
{
  for (int i = listaAsteroide.size()-1; i>=0; i--)
  {
    Asteroide posicion = listaAsteroide.get(i);
    for (int j = listaPium.size()-1; j>=0; j--)
    {
      disparo alcance = listaPium.get(j);

      float distancia = sqrt((posicion.x - alcance.x)*(posicion.x - alcance.x)
        +(posicion.y - alcance.y)*(posicion.y - alcance.y));
      //Con esta formula calculamos la distancia entre todos los disparos y todos los 
      //asteroides

      float Radios = 5 + 45; //Calculamos la suma de los radios del disparo y el asteroide
      if (distancia < Radios) //si es menor es que han colisionado
      {
        sonidoAsteroideDestruido.trigger();
        listaAsteroide.remove(i);
        listaPium.remove(j);
        puntuacion = puntuacion+100;
        astEli++;
      }
    }
  }
}

void colisionesAN() //Detector de colisiones entre la nave y un asteroide
{
  for (int i = listaAsteroide.size()-1; i>=0; i--)
  {
    Asteroide posicionA = listaAsteroide.get(i);

    Nave posicionN = miNave.get(0);

    //Calculamos la distancia a los 3 vertives de la nave y del centro de dos 
    //de los laterales para mayor exactitud en la colision
    float distancia1 = sqrt((posicionA.x - (posicionN.x+87))*(posicionA.x - (posicionN.x+87)) //vertice cabeza
      +(posicionA.y - posicionN.y)*(posicionA.y - posicionN.y));                    

    float distancia2 = sqrt((posicionA.x - (posicionN.x+10))*(posicionA.x - (posicionN.x+10))  //vertice posterior superior
      +(posicionA.y - (posicionN.y-50))*(posicionA.y - (posicionN.y-50)));  //le sumo 10 porque el vertice del triangulo esta por detras de la cola de la nave

    float distancia3 = sqrt((posicionA.x - (posicionN.x+10))*(posicionA.x - (posicionN.x+10))   //vertive posterior inferior
      +(posicionA.y - (posicionN.y+50))*(posicionA.y - (posicionN.y+50)));

    float distancia4 = sqrt((posicionA.x - (posicionN.x+43.5))*(posicionA.x - (posicionN.x+43.5))   //lateral entre la cabeza y vert. post. sup.
      +(posicionA.y - (posicionN.y-25))*(posicionA.y - (posicionN.y-25)));

    float distancia5 = sqrt((posicionA.x - (posicionN.x+43.5))*(posicionA.x - (posicionN.x+43.5))  //lateral entra la cabeza y vert. post. inf.
      +(posicionA.y - (posicionN.y+25))*(posicionA.y - (posicionN.y+25)));

    float Radios = 2 + 45; //Calculamos la suma de los radios del disparo y el asteroide

    if (distancia1 < Radios || distancia2 < Radios || distancia3 < Radios || distancia4 < Radios || distancia5 < Radios) //si es menor es que han colisionado
    {
      listaAsteroide.remove(i);
      int eliminarA = listaAsteroide.size();
      for (int j = 0; j < eliminarA; j++) //Como han golpeado la nave y es game over, tengo que eliminar los asteroides y los disparos par aque no 
                                          //aparezcan al volver al estado inicial del juego
      {
        listaAsteroide.remove(0);
      }
      int eliminarD = listaPium.size(); //elimino los disparos
      for (int j = 0; j < eliminarD; j++)
      {
        listaPium.remove(0);
      }
      estado=1; //estado de game over
      break;
    }
  }
}

void marcador()
{
  textSize(height/27.7); //Puntuacion
  fill(255);
  textAlign(CENTER);
  text(puntuacion, width-height/13.65, height/27.7);
}

void starting() //Texto de Start del principio del juego
{
  if (start < 60)
  {
    textSize(width/10);
    fill(random(0, 255), random(0, 255), random(0, 255));
    textAlign(CENTER);
    text("START", width/2, height/2);
    start++;
    if (sI == 0) {
      sonidoInicio.trigger();
      sI = 1;
    }
  }
}

void keyPressed() //para empezar de nuevo
{
  if (estado == 1 || (estado == 7 && BG >= 255))
  {
    estado = 2; //reinicia los parametros a su valor inicial
  }
}

void municion() //Cuenta los disapros de los que dispongo
{
  textSize(height/25);
  fill(255);
  textAlign(CENTER);
  if (estado == 5)
  {
    text(7-listaPium.size(), height/25, height/25); //text(7-listaPium.size(), 50, 50);
  } else
  {
    text(5-listaPium.size(), height/25, height/25);
  }
}

void actualizarDificultad()
{
  if (astEli/6 < 1) //Cuando se eliminan 6 asteroides se sube de nivel
  {
    rDif = 50;
    nivel = 1;
  } else
  {
    nivel = astEli/6+1;
    rDif = 55 - 5*nivel;
  }

  if (nivel == 6) //Si se llega al nivel 6 aparece el jefe Final
  {
    estado = 3; //estado en el que dejan de salir asteroides y elimino los que quedan para que aparezca el boss
  }
}

void textoNivel()  //Indica el nivel en el que se está
{
  if (nivelAct != nivel && start==60)
  {
    nivelAct = nivel;
    textNivel = 0;
  }
  if (nivel >= 6 && textNivel < 60)
  {
    if (textNivel == 0)
    {
      sonidoAttention.trigger();
    }
    textSize(width/10);
    fill(255);
    textAlign(CENTER);
    text("FINAL BOSS", width/2, height/2);
    textNivel++;
  } else if (textNivel < 60) //Contador para que aparezca el texto durante un tiempo corto
  {
    textSize(width/10);
    fill(255);
    textAlign(CENTER);
    textLeading(width/10);
    text("Nivel ", width/2, height/2);
    text(nivel, width/2, height/2+height/4);
    textNivel++;
  }
}

void disparoEnemigo() //"""timer""" que hace que la nave enemiga dispare de forma continuada
{
  if (contadorDelay == delayDisparo)
  {
    Nave2 posicion2 = nEnemiga.get(0);
    disparo2 D2 = new disparo2(posicion2.x-88, posicion2.y, disp2);
    listaPium2.add(D2);
    contadorDelay = 0;
    sonidoDisparo2.trigger();
  } else
  {
    contadorDelay++;
  }
}

void disparoRayo() //Dispara un rayo cuando la nave enemiga ha sufrido cierto daño
{
  Nave2 posicion3 = nEnemiga.get(0);
  rayoDeLaMuerte RM = new rayoDeLaMuerte(posicion3.x-88, posicion3.y, rayM);
  rayoMortal.add(RM);
  RM.disparoDeLaMuerteMortalDeLaMuerte();
}

void colisionesDisparo2Nave() //Detector de colisiones entre la nave y un disparo
{
  for (int i = listaPium2.size()-1; i>=0; i--)
  {
    disparo2 posicionD2 = listaPium2.get(i);

    Nave posicionN = miNave.get(0);

    //Calculamos la distancia a los 3 vertives de la nave y del centro de dos 
    //de los laterales para mayor exactitud en la colision
    float distancia1 = sqrt((posicionD2.x - (posicionN.x+87))*(posicionD2.x - (posicionN.x+87)) //vertice cabeza
      +(posicionD2.y - posicionN.y)*(posicionD2.y - posicionN.y));                    

    float distancia2 = sqrt((posicionD2.x - (posicionN.x+10))*(posicionD2.x - (posicionN.x+10))  //vertice posterior superior
      +(posicionD2.y - (posicionN.y-50))*(posicionD2.y - (posicionN.y-50)));

    float distancia3 = sqrt((posicionD2.x - (posicionN.x+10))*(posicionD2.x - (posicionN.x+10))   //vertive posterior inferior
      +(posicionD2.y - (posicionN.y+50))*(posicionD2.y - (posicionN.y+50)));

    float distancia4 = sqrt((posicionD2.x - (posicionN.x+43.5))*(posicionD2.x - (posicionN.x+43.5))   //lateral entre la cabeza y vert. post. sup.
      +(posicionD2.y - (posicionN.y-25))*(posicionD2.y - (posicionN.y-25)));

    float distancia5 = sqrt((posicionD2.x - (posicionN.x+43.5))*(posicionD2.x - (posicionN.x+43.5))  //lateral entra la cabeza y vert. post. inf.
      +(posicionD2.y - (posicionN.y+25))*(posicionD2.y - (posicionN.y+25)));

    float RadiosPicos = 6;
    float RadiosLaterales = 20;

    if (distancia1 < RadiosPicos || distancia2 < RadiosPicos || distancia3 < RadiosPicos || distancia4 < RadiosLaterales || distancia5 < RadiosLaterales) //si es menor es que han colisionado
    {
      int eliminarD2 = listaPium2.size(); //elimino los disparos
      for (int j = 0; j < eliminarD2; j++)
      {
        listaPium2.remove(0);
      }
      estado=1;
      break;
    }
  }
}

void colisionesDisparoNave2() //Detector de colisiones entre la nave y un disparo
{
  for (int i = listaPium.size()-1; i>=0; i--)
  {
    disparo posicionD = listaPium.get(i);

    Nave2 posicionN2 = nEnemiga.get(0);


    float distancia1 = sqrt((posicionD.x - (posicionN2.x-87))*(posicionD.x - (posicionN2.x-87)) //vertice cabeza
      +(posicionD.y - posicionN2.y)*(posicionD.y - posicionN2.y));                    

    float distancia2 = sqrt((posicionD.x - posicionN2.x)*(posicionD.x - posicionN2.x)  //vertice posterior superior
      +(posicionD.y - (posicionN2.y-50))*(posicionD.y - (posicionN2.y-50)));

    float distancia3 = sqrt((posicionD.x - posicionN2.x)*(posicionD.x - posicionN2.x)   //vertive posterior inferior
      +(posicionD.y - (posicionN2.y+50))*(posicionD.y - (posicionN2.y+50)));

    float distancia4 = sqrt((posicionD.x - (posicionN2.x-43.5))*(posicionD.x - (posicionN2.x-43.5))   //lateral entre la cabeza y vert. post. sup.
      +(posicionD.y - (posicionN2.y-25))*(posicionD.y - (posicionN2.y-25)));

    float distancia5 = sqrt((posicionD.x - (posicionN2.x-43.5))*(posicionD.x - (posicionN2.x-43.5))  //lateral entra la cabeza y vert. post. inf.
      +(posicionD.y - (posicionN2.y+25))*(posicionD.y - (posicionN2.y+25)));

    float RadiosPicos = 7+3; //Calculamos la suma de los radios del disparo enemigo y nuestra nave
    float RadiosLaterales = 7+13;

    if (distancia1 < RadiosPicos || distancia2 < RadiosPicos || distancia3 < RadiosPicos || distancia4 < RadiosLaterales || distancia5 < RadiosLaterales) //si es menor es que han colisionado
    {
      listaPium.remove(i);
      posicionN2.vida--;
      puntuacion = puntuacion + 250;
      if (posicionN2.vida == 15 || posicionN2.vida == 5)
      {
        aniquilador = 1;
      }
    }
    if (posicionN2.vida == 0)
    {
      estado = 6;
      sonidoNave2Destruida.trigger();
    }
  }
}

void colisionDisparoDeLaMuerte_Nave() //Calcula si el rayo mortal colisiona con mi nave
{
  Nave posicionN = miNave.get(0);

  Nave2 posicionN2 = nEnemiga.get(0);
  //La forma facil de detectar colision es que el disparo toque la parte superior o inferior de la nave
  //El radio del disparo sera la mitad de la anchura, que seria 50. Pero vamos a ponerle menos distancia, para que no te de si te roza un poco 

  float distancia1 = sqrt((posicionN.x - 30)*(posicionN.x - 30) 
    + ((posicionN.y - 50) - posicionN2.y)*((posicionN.y-50) - posicionN2.y));   //Vertice superior     

  float distancia2 = sqrt((posicionN.x - 30)*(posicionN.x - 30) 
    + ((posicionN.y+50) - posicionN2.y)*((posicionN.y+50) - posicionN2.y));    //colision con vertice inferior

  float RadiosPicos = 40; //Calculamos la suma de los radios del disparo enemigo y nuestra nave

  if (distancia1 < RadiosPicos || distancia2 < RadiosPicos)
  {
    int eliminarD2 = listaPium.size();
    for (int j = 0; j < eliminarD2; j++)
    {
      listaPium2.remove(0);
    }
    estado = 1;
  }
}

//////////////////////////////////////////////////////////GAME///////////////////////////////////////////////

void game()
{
  switch(estado)
  {
  case 0: //Juego normal
     
    
    image(esp, width/2, height/2, width, height);
    //background(esp);
    starting();

    moverAsteroide(); //movimiento del asteroide

    Nave N = miNave.get(0); //Mueve la nave hacia el cursor
    N.mover();

    pium(); //Mueve los disparos

    respawnAsteroide(); //Funcion que crea asteroides al azar
    destructorA(); //Destruye los asteroides que se salgan de la pantalla para 
    //limitar la lista y que no llegue a infinito, realentizando el programa
    destructorD(); //Destructor de disparos
    textoNivel(); //Indica el nivel en el que se está
    colisionesAD(); //colision entre asteroide y disparo
    colisionesAN(); //colision entre asteroide y nave
    municion(); //Tienes 5 disparos
    actualizarDificultad();
    marcador();
    break;

  case 1: //game over

    //background(esp);
    //image(esp,width/2, height/2, width, height);
    fill(0, BG);
    rect(0, 0, width, height);
    if (BG == 0)
    {
      sonidoNaveDestruida.trigger();
    }
    if (BG < 100)
    {
      BG++;
    } else
    {
      textSize(height/10);
      fill(255);
      text("GAME OVER", width/2, height/2);
      textSize(height/20);
      textAlign(CENTER);
      text(puntuacion, width/2, height/2+150);
      textSize(height/30);
      text("Press any key", width/2, height/2 + height/4);
    }
    break;

  case 2: //Devuelve todo como al principio
    start = 0;
    r = 0; //Contador para respawn de los asteorides
    textNivel = 60;
    puntuacion = 0;
    astEli = 0;
    BG=0;
    estado = 0;
    aniquilador = 0;
    rayo = 0;
    sI = 0;
    sWin = 0;
    int eliminarD = listaPium.size(); //elimino los disparos antes de enfrentarme al boss
    for (int j = 0; j < eliminarD; j++)
    {
      listaPium.remove(0);
    }
    int eliminarD2 = listaPium2.size(); //elimino los disparos antes de enfrentarme al boss
    for (int j = 0; j < eliminarD2; j++)
    {
      listaPium2.remove(0);
    }
    break;

  case 3: //Cuando llegas al nivel 10 esperas hasta que no haya asteroides para enfrentarde al jefe
    //background(esp);
    image(esp,width/2, height/2, width, height);
    if (listaAsteroide.size() > 0) //Espero hasta que no haya mas asteroides
    {
      moverAsteroide();
      N = miNave.get(0);
      N.mover();
      pium();
      destructorA(); 
      destructorD();
      colisionesAD(); //colision entre asteroide y disparo
      colisionesAN(); //colision entre asteroide y nave
      municion(); //Tienes 5 disparos
      marcador();
    } else
    {
      eliminarD = listaPium.size(); //elimino los disparos antes de enfrentarme al boss
      for (int j = 0; j < eliminarD; j++)
      {
        listaPium.remove(0);
      }
      estado = 4;
    }
    break;

  case 4:  //Creo al jefe 
    //background(esp);
    image(esp,width/2, height/2, width, height);
    N = miNave.get(0);
    N.mover();
    destructorD();
    actualizarDificultad();
    municion();
    //Indica el nivel en el que se está
    nEnemiga = new ArrayList<Nave2>(); //creacion de la nave
    imageMode(CENTER);
    nodr = loadImage("BOSS.png");
    noStroke();
    Nave2 Z = new Nave2(width-30, height/2, nodr);
    nEnemiga.add(Z);
    estado = 5;
    break;

  case 5: //BATALLA FINAL
    //background(esp);
    image(esp,width/2, height/2, width, height);
    N = miNave.get(0);
    textoNivel();
    N.mover();
    Z = nEnemiga.get(0);  
    pium();
    destructorD();
    marcador();
    municion();
    if (aniquilador == 0)
    {
      Z.mover();
      disparoEnemigo();
    } else
    {
      disparoRayo();
      Z.estatica();
      colisionDisparoDeLaMuerte_Nave();
    }
    pium2();
    colisionesDisparoNave2();
    colisionesDisparo2Nave();
    break;

  case 6: //nave enemiga destruida
    //background(esp);
    image(esp,width/2, height/2, width, height);
    Z = nEnemiga.get(0); 
    Z.destruir();
    N = miNave.get(0);
    N.mover();
    pium();
    pium2();
    destructorD();
    break;

  case 7:  //pantalla de victoria
    //background(esp);
    image(esp,width/2, height/2, width, height);
    N = miNave.get(0);
    N.mover();
    fill(0, BG);
    rect(0, 0, width, height);

    if (BG < 255)
    {
      BG = BG + 2;
    } else
    {
      if (sWin == 0)
      {
        sonidoWin.trigger();
        sWin = 1;
      }
      textSize(height/10);
      fill(255);
      text("!!HAS SALVADO LA GALAXIA!!", width/2, height/2);
      textSize(height/20);
      textAlign(CENTER);
      text(puntuacion, width/2, height/2+150);
      textSize(height/30);
      text("Press any key", width/2, height/2 + height/4);
    }
    break;
  }
}
