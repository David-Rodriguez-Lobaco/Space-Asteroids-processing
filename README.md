# Space-Asteroids-processing
Interactive game created with processing, giving the option of using an arduino and a piezoelectric as a button

You just need to run the program with processing to start playing.

controls:
Mouse (move) -> Move ship
Mouse (left click) -> Shoot


To run without the piezoelectric, comment above in the file Space_Asteroids.p from lines 105 to 108:
"while (myPort.available() > 0)
{
    pulsePiezo(myPort.read());
}"
