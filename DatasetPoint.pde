//The class DatasetPoint extends its functionality
class DatasetPoint extends Point {

  float bias = 1.0; //The bias is always equal to 1 because of the equation of the line 
  int label; //The label

  DatasetPoint(float x_axis_width, float y_axis_height) {
    x = random(-1, 1);
    y = random(-1, 1);
    this.x_axis_width = x_axis_width;
    this.y_axis_height = y_axis_height;
    calculateMargins();

    float exact_line_y = exact_function(x);
    if (y > exact_line_y) {
      label = 1;
    } else {
      label = -1;
    }
  }
}