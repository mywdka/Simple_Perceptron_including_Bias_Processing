//Code forked from the following Daniel Shiffman's video tutorial: 
//https://www.youtube.com/watch?v=ntKn5TPHHAk

//The perceptron is a simple neuron with a sign(threshold) activation function. It can be used to solve simple
//binary classification problems. Formally it can be described with the following equation:
//y = sgn(w.x) ∈ {−1, 1}.
//The Perceptron Algorithm:
//1. Provide the perceptron with inputs for which there is a known answer
//2. Ask the perceptron to guess an answer
//3. Compute the error. (Did it get the answer right or wrong?)
//4. Adjust all the weights according with the error
//5. Return to Step 1 (click mousePressed again) and repeat!

//Our perceptron
Perceptron perceptron;

//Set the size of the Training Dataset
final int number_training_points = 20;

//Datasets
TrainingDatasetPoint[] trainingDataset = new TrainingDatasetPoint[number_training_points];
ArrayList<TestingDatasetPoint> testingDataset = new ArrayList<TestingDatasetPoint>();

//Index current data item
int currentDataTraining = -1;

//Size of the axis
float x_axis_width = 400;
float y_axis_height = 400;


PFont mathsFont;

final float text_x_separation = 10.0;
final float text_y_separation = 20.0;
float current_text_y = text_y_separation;


//Exact line that classifies the 2 groups
Point exact_line_p_left;
Point exact_line_p_right;

//We draw the current line based on the adjusted weights
// Formula is weights[0]*x + weights[1]*y + weights[2]*bias (1) = 0
Point calculated_line_p_left;
Point calculated_line_p_right;

float prev_calculated_line_p_left_y = 0.0;
float prev_calculated_line_p_right_y = 0.0;

float margin_x;
float margin_y;


boolean drawNextFrame = true;

boolean verbose = true;

boolean wasThereChange = false;

final int TRAINING = 1;
final int TESTING = 2;

int newTestingDataPoint = -1;

int currentState = TRAINING;


int epoch = 1;

float current_error_testing_set = 0.0;

void setup() {
  size(1920, 1080); 
  perceptron = new Perceptron();  

  //Generate training set
  for (int i = 0; i < trainingDataset.length; i++) {
    trainingDataset[i] = new TrainingDatasetPoint(x_axis_width, y_axis_height);
  }  

  mathsFont = createFont("SourceCodePro-Regular.ttf", 12);
  textFont(mathsFont);

  margin_x = (width - x_axis_width) / 2.0;
  margin_y = (height - y_axis_height) / 2.0;

  frameRate(30);

  //we uses x=-1 and x=1 as the two points for drawing the line
  //we calculate the ys by calling the function f(x)
  exact_line_p_left = new Point(x_axis_width, y_axis_height, -1, exact_function(-1), false);
  exact_line_p_right = new Point(x_axis_width, y_axis_height, 1, exact_function(1), false);

}

void draw() {


  if (drawNextFrame == true) {
    current_text_y = text_y_separation;

    background(255);
    noStroke();
    fill(255, 237, 247);

    rect(margin_x, margin_y, x_axis_width, y_axis_height);

    noFill();
    stroke(0);
/*
    //we are going to draw the line that we use to classify the 2 groups
    line(exact_line_p_left.pixelX(), exact_line_p_left.pixelY(), exact_line_p_right.pixelX(), exact_line_p_right.pixelY());
    //    exact_line_p_left.show(false, true, false);
    //    exact_line_p_right.show(false, true, false);
    exact_line_p_left.show();
    exact_line_p_right.show();
*/   
    //we are going to draw the current line according with the weights (initially random)
    //we calculate the ys by calling the function f(x)

    if (currentState == TRAINING) {

      currentDataTraining++;
      if ( currentDataTraining == trainingDataset.length) {
        currentDataTraining = 0;
        epoch++;
      }
    } else if (currentState == TESTING) {
      //Visualize testing data
      for (int i = 0; i < testingDataset.size(); i++) {
        if (newTestingDataPoint == i) {
          //        testingDataset.get(i).show(true, false, false);
          testingDataset.get(i).show(true);
        } else {
          //      testingDataset.get(i).show(false, false, false);
          testingDataset.get(i).show(false);
        }
      }
    }

    //Visualize training data
    for (int i = 0; i < trainingDataset.length; i++) {
      if (currentDataTraining == i && currentState == TRAINING) {
        trainingDataset[i].show(true);
      } else {
        trainingDataset[i].show(false);
      }
    }  

    if (currentState == TRAINING) {

      //Training
      float[] inputs = {trainingDataset[currentDataTraining].x, trainingDataset[currentDataTraining].y, trainingDataset[currentDataTraining].bias};
      wasThereChange = perceptron.train( inputs, trainingDataset[currentDataTraining].label);
    }
    stroke(255, 0, 0);

    //We try to find the optimal weights for a line 
    //We draw the current line based on the adjusted weights. The line should ended up dividing the two groups (A,B) we are classifying
    // Formula is weights[0]*x + weights[1]*y + weights[2]*bias (1) = 0
    calculated_line_p_left = new Point( x_axis_width, y_axis_height, -1, perceptron.caulculateY(-1), true);
    calculated_line_p_right = new Point( x_axis_width, y_axis_height, 1, perceptron.caulculateY(1), true);
    line(calculated_line_p_left.pixelX(), calculated_line_p_left.pixelY(), calculated_line_p_right.pixelX(), calculated_line_p_right.pixelY());
    calculated_line_p_left.show();
    calculated_line_p_right.show();

    drawNextFrame = false;

    stroke(0);
    fill(0);


    if (currentState == TRAINING) {


      if ( wasThereChange == true) {

        if (verbose) {
          printTrainingProcess();
        }

        prev_calculated_line_p_left_y = calculated_line_p_left.y;
        prev_calculated_line_p_right_y = calculated_line_p_right.y;
      }
    } else if (currentState == TESTING) {

      if (verbose) {
        printTestingProcess();
      }
    }
  }
}
void printTestingProcess() {
  current_text_y+=text_y_separation;
  text("Training Process Finished!", text_x_separation, current_text_y);       
  current_text_y+=text_y_separation;
  text("Size of Training Dataset = "+trainingDataset.length, text_x_separation, current_text_y);       
  current_text_y+=text_y_separation;
  text("Number of epochs for the training process = " + epoch, text_x_separation, current_text_y);       
  current_text_y+=text_y_separation;
  current_text_y+=text_y_separation;
  text("Testing Process", text_x_separation, current_text_y);   
  current_text_y+=text_y_separation;
  text("Size of Testing Dataset = "+testingDataset.size(), text_x_separation, current_text_y);   
  current_text_y+=text_y_separation;
  text("Classifiying Success Rate = "+current_error_testing_set+"%", text_x_separation, current_text_y);   
  current_text_y+=text_y_separation;
}

void addTestingDatasetPoint() {
  testingDataset.add(new TestingDatasetPoint(x_axis_width, y_axis_height));
  ++newTestingDataPoint;
}

void calculateError() {

  float countingHits = 0;
  //Visualize testing data
  for (int i = 0; i < testingDataset.size(); i++) {
    if (testingDataset.get(i).wasProperlyClassified() == true) {
      countingHits++;
    }
  }  

  current_error_testing_set = (countingHits /  float(testingDataset.size()))*100.0;
}



void mouseClicked() {
  if (currentState != TESTING) {
    currentState = TESTING;
  } else {

    addTestingDatasetPoint();
    calculateError();
  }
  drawNextFrame = true;
}

void keyPressed() {

  drawNextFrame = true;
}

//w0 = x, w1 = y, w2 = b

//we arbitrarily decide the initial line that we would use to separate the 2 groups that
//we would like to classify
float exact_function(float x) {

  float m = 0.3;
  float b = 0.2;
  //y = mx + b
  float y = m*x + b;  
  return y;
}

float current_function_based_on_weights(float x) {

  /*  float m = 0.3;
   float b = 0.2;
   //y = mx + b
   float y = m*x + b;  
   return y;*/

  return perceptron.caulculateY(x);
}

void printTrainingProcess() {

  String tempText ="";
  current_text_y+=text_y_separation;
  //calculated_y = - (w0/w1)*x -(w2/w1)*bias ;
  text("Calculating Left Point  x = "+calculated_line_p_left.x, text_x_separation, current_text_y);     
  current_text_y+=text_y_separation;
  //    text("calculated_y = -(w0/w1)*x -(w2/w1)*bias -> ( - "+perceptron.weights[0]+"/"+perceptron.weights[1]+ ") * "+calculated_line_p_left.x + " - ( "+perceptron.weights[2]+"/"+perceptron.weights[1]+ ") * "+calculated_line_p_left.bias, text_x_separation, current_text_y);      current_text_y+=text_y_separation;
  text("calculated_y = -(w0/w1)*x -(w2/w1)*bias", text_x_separation, current_text_y);      
  current_text_y+=text_y_separation;
  text("calculated_y =  -("+perceptron.weights[0]+"/"+perceptron.weights[1]+ ") * "+calculated_line_p_left.x + " - ( "+perceptron.weights[2]+"/"+perceptron.weights[1]+ ") * "+1, text_x_separation, current_text_y);     
  current_text_y+=text_y_separation;

  if ( calculated_line_p_left.y > prev_calculated_line_p_left_y) {
    tempText=" Point Left moves UP! "+(calculated_line_p_left.y - prev_calculated_line_p_left_y);
  } else if (calculated_line_p_left.y < prev_calculated_line_p_left_y) {
    tempText=" Point Left moves DOWN! "+(calculated_line_p_left.y - prev_calculated_line_p_left_y);
  } else {
    tempText=" Point Left Freezes!";
  }

  text("prev_calculated_y = "+prev_calculated_line_p_left_y+" calculated_y = "+calculated_line_p_left.y+tempText, text_x_separation, current_text_y);     
  current_text_y+=text_y_separation;
  current_text_y+=text_y_separation;
  text("Calculating Right Point  x = "+calculated_line_p_right.x, text_x_separation, current_text_y);     
  current_text_y+=text_y_separation;
  //    text("calculated_y = -(w0/w1)*x -(w2/w1)*bias -> ( - "+perceptron.weights[0]+"/"+perceptron.weights[1]+ ") * "+calculated_line_p_right.x + " - ( "+perceptron.weights[2]+"/"+perceptron.weights[1]+ ") * "+calculated_line_p_right.bias, text_x_separation, current_text_y);     current_text_y+=text_y_separation;
  text("calculated_y = -(w0/w1)*x -(w2/w1)*bias", text_x_separation, current_text_y);     
  current_text_y+=text_y_separation;
  text("calculated_y =  -("+perceptron.weights[0]+"/"+perceptron.weights[1]+ ") * "+calculated_line_p_right.x + " - ( "+perceptron.weights[2]+"/"+perceptron.weights[1]+ ") * "+1, text_x_separation, current_text_y);     
  current_text_y+=text_y_separation;


  if ( calculated_line_p_right.y > prev_calculated_line_p_right_y) {
    tempText=" Point Right moves UP! "+ (calculated_line_p_right.y-prev_calculated_line_p_right_y);
  } else if (calculated_line_p_right.y < prev_calculated_line_p_right_y) {
    tempText=" Point Right moves DOWN! "+ (calculated_line_p_right.y-prev_calculated_line_p_right_y);
  } else {
    tempText=" Point Right Freezes!";
  }

  text("prev_calculated_y = "+prev_calculated_line_p_right_y+" calculated_y = "+calculated_line_p_right.y+tempText, text_x_separation, current_text_y);  
  current_text_y+=text_y_separation;
}