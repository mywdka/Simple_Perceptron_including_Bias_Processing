
//Simple class Point
class Point {
  float x;
  float y;
  float x_axis_width;
  float y_axis_height;
  float margin_x;
  float margin_y;
  boolean calculatedLine = false;

  void show() {    
    if (calculatedLine == true) {
      noFill();
 //     fill(255, 0, 0);
      stroke(255, 0, 0);
      ellipse(pixelX(), pixelY(), 6, 6);
  //    text("("+x+","+y+")", pixelX()-120, pixelY()+20);
       fill(255, 0, 0);
      text("("+map(pixelX(),margin_x, width-margin_x,-10,10)+","+map(pixelY(),margin_y+y_axis_height, margin_y,-10,10)+")", pixelX()-120, pixelY()+20);
    } else {
      noFill();
      //fill(0);
      stroke(0);
      ellipse(pixelX(), pixelY(), 6, 6);
//      text("("+x+","+y+")", pixelX()+10, pixelY()+10);
fill(0);
      text("("+pixelX()+","+pixelY()+")", pixelX()+10, pixelY()+10);
    }
  }

  Point() {
  }

  //Create points for representing a line -> no need of label
  Point(float x_axis_width, float y_axis_height, float px, float py, boolean calculatedLine) {
    x = px;
    y = py;
    this.x_axis_width = x_axis_width;
    this.y_axis_height = y_axis_height;
    this.calculatedLine=calculatedLine;
    calculateMargins();
  }


  void calculateMargins() {
    margin_x = (width-x_axis_width)/2.0;
    margin_y   = (height-y_axis_height)/2.0;
  }


  //It maps the coordinates from -1,1 into screen pixel coordinates
  float pixelX() {
    //    float result = map(x, -1, 1, margin_x, width-margin_x);
    float result = map(x, -1, 1, margin_x, width-margin_x);
    return result;
  }

  float pixelY() {
    float result = map(y, -1, 1, margin_y+y_axis_height, margin_y);
    return result;
  }
}