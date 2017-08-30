final int RECT_NUM_X = 100;
final int RECT_NUM_Y = 100;

SelfOrganizingMap som;

void setup() {
  size( 500, 500 );
  som = new SelfOrganizingMap( RECT_NUM_X, RECT_NUM_Y );
  //frameRate(5);
}

void draw() {
  som.updateUnits();
  som.draw();
}

void mousePressed() {
  som.initialize();
}