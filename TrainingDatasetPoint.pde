class TrainingDatasetPoint extends DatasetPoint {

  TrainingDatasetPoint(float x_axis_width, float y_axis_height) {
    super(x_axis_width, y_axis_height);
    //We would like to use any particular function
    float lineY = exact_function(x);
    if (y > lineY) {
      label = 1;
    } else {
      label = -1;
    }
  }

  //Draws the point on the display
  void show(boolean currentPoint) {
    stroke(0); 
    //  noStroke(); 
    if ( label == 1) {
      //      fill(255,0,0,80);
  fill(255);
      ellipse(pixelX(), pixelY(), 8, 8);
    } else {
//  fill(253,255,196);
stroke(0);
  fill(190,162,255,196);
      ellipse(pixelX(), pixelY(), 8, 8);
      //      fill(255);
      //fill(255,0,0,80);
      //      float traingleWidth = 10;
      //      float traingleHeight = 8;
      // float rectSize = 8;

      //   rect(pixelX()-rectSize/2, pixelY()-rectSize/2, rectSize, rectSize);
      //      triangle(pixelX()-traingleWidth/2, pixelY()+traingleHeight/2,pixelX(), pixelY()-traingleHeight/2,  pixelX()+traingleWidth/2, pixelY()+traingleHeight/2);

      //      fill(0,0,255,80);
      //  fill(0);
      //noStroke(); 
      //fill(253,255,196);
    }
    if ( currentPoint == true) {
      noFill();
      stroke(0);
      ellipse(pixelX(), pixelY(), 14, 14);
      fill(0);
      text("("+x+","+y+")", pixelX()+10, pixelY()+10);
    } else {
      
      ellipse(pixelX(), pixelY(), 8, 8);
    }
  }
}