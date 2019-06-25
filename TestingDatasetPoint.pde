//The class TestingDatasetPoint extends the functionality of 
//by adding methods to detect whether the point was properly classified

class TestingDatasetPoint extends DatasetPoint {

  int predicted_label;
  boolean successful_prediction;
  float cross_size = 4;


  TestingDatasetPoint(float x_axis_width, float y_axis_height) {
    super(x_axis_width, y_axis_height);
  }

  boolean wasProperlyClassified() {

    float calculated_line_y = current_function_based_on_weights(x);
    if (y > calculated_line_y) {
      predicted_label = 1;
    } else {
      predicted_label = -1;
    }
    if (  predicted_label == label) {
      successful_prediction = true;
    } else {
      successful_prediction = false;
    }
    return successful_prediction;
  }


  //Draws the Testing Dataset Point.
  //It displays a red x if it has been missclassified
  //It displays a dot it it has been properly classified
  void show(boolean currentPoint) {

    if ( successful_prediction) {
      fill(149, 255, 166);
      if ( currentPoint == true) {
        noStroke();
        ellipse(pixelX(), pixelY(), 8, 8);
        noFill();
        stroke(149, 255, 166);
        ellipse(pixelX(), pixelY(), 14, 14);
        fill(0);
      } else {
        noStroke();
//        stroke(0);
        ellipse(pixelX(), pixelY(), 8, 8);
        fill(0);
        stroke(0);
      }
    } else {
      stroke(255, 0, 0);
      line(pixelX()-cross_size, pixelY()-cross_size, pixelX()+cross_size, pixelY()+cross_size);
      line(pixelX()-cross_size, pixelY()+cross_size, pixelX()+cross_size, pixelY()-cross_size);
      stroke(0);
    }
  }
}