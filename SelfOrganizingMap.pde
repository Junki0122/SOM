class SelfOrganizingMap {
  int numX, numY;
  int rectWidth, rectHeight;
  Color [][] colors;
  Color inputColor;
  PointF BMU;
  int n, numInstances;
  float initialLearningRate, initialRadius, lambda;

  SelfOrganizingMap( int _numX, int _numY ) {
    numX = _numX;
    numY = _numY;
    rectWidth = width/numX;
    rectHeight = height/numY;
    colors = new Color[numX][numY];
    for ( int j=0; j<numY; j++ ) {
      for ( int i=0; i<numX; i++ ) {
        colors[i][j] = new Color( (int)random(256), (int)random(256), (int)random(256) );
      }
    }
    numInstances = 1000;
    initialLearningRate = 0.2;
    initialRadius = min(width, height) / 15;
    lambda = numInstances / log(initialRadius);
    n = 0;
  }

  void initialize() {
    colors = new Color[numX][numY];
    for ( int j=0; j<numY; j++ ) {
      for ( int i=0; i<numX; i++ ) {
        colors[i][j] = new Color( (int)random(256), (int)random(256), (int)random(256) );
      }
    }
    n = 0;
  }


  void updateUnits() {
    float radius = initialRadius * exp( -n / lambda );
    float learningRate = initialLearningRate * exp( -n / lambda );
    inputColor = new Color( (int)random(256), (int)random(256), (int)random(256) );
    BMU = findBestMatchingUnit(inputColor);
    for ( int y=0; y<numY; y++ ) {
      for (int x=0; x<numX; x++ ) {
        float dist = dist( x, y, BMU.x, BMU.y );
        float phi = exp( -pow( dist, 2 ) / (2*pow(radius, 2)));

        colors[x][y].r = int(colors[x][y].r + phi * learningRate * (inputColor.r - colors[x][y].r));
        colors[x][y].g = int(colors[x][y].g + phi * learningRate * (inputColor.g - colors[x][y].g));
        colors[x][y].b = int(colors[x][y].b + phi * learningRate * (inputColor.b - colors[x][y].b));
      }
    }
    //println("半径:"+radius);
    if (radius < 0.1 ) {
      println("finish:n=" + n);
      save("after.png");
      exit();
    } else {
      n++;
    }
  }


  PointF findBestMatchingUnit( Color _input ) {
    PointF BMU = new PointF();
    float tempDistance;
    float minDistance = Float.MAX_VALUE;
    for ( int y=0; y<numY; y++ ) {
      for ( int x=0; x<numX; x++ ) {
        tempDistance = calculateDistance( _input, colors[x][y] );
        if ( tempDistance < minDistance ) {
          minDistance = tempDistance;
          BMU.x = x;
          BMU.y = y;
        }
      }
    }
    return BMU;
  }


  float calculateDistance( Color _temp, Color _temp2 ) {
    float distance;
    distance = dist( _temp.r, _temp.g, _temp.b, _temp2.r, _temp2.g, _temp2.b );
    return distance;
  }



  void draw() {
    background(255);
    for ( int y=0; y<numY; y++ ) {
      for ( int x=0; x<numX; x++ ) {
        noStroke();
        fill( colors[x][y].r, colors[x][y].g, colors[x][y].b );
        rect( x*rectWidth, y*rectHeight, rectWidth, rectHeight );
      }
    }
    if( n == 1 ){
      save("before.png");
    }
  }
}