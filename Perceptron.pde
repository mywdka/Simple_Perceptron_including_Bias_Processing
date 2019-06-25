class Perceptron {

  float[] weights = new float[3];
  float[] prev_weights = new float[3];
  //  float lr = 0.001;
  float lr = 0.04;
  float error;

  Perceptron() {
    // Start with random weights
    for (int i = 0; i < weights.length; i++) {
      //      weights[i] = random(-1,1); 
      weights[i] = random(-1.0, 1.0);
    }
  }

  //The activation function
  int sign(float n) {
    if (n > 0) {
      return 1;
    } else {
      return -1;
    }
  }

  //inputs[] -> x,y of the point and bias (always 1)
  //weights[] -> initially random(-1,1)
  int feedforward(float[] inputs, boolean printText) {
    float sum = 0;

    for ( int i = 0; i< weights.length; i++) {
      sum+=inputs[i]*weights[i];
    }
    int output =sign(sum);

    if (printText == true) {
      stroke(0);
      fill(0);

      text("Training epoch "+epoch, text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
      text("Training point "+(currentDataTraining+1)+"/"+trainingDataset.length, text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
      text("x = "+inputs[0]+" y = "+inputs[1]+" bias = "+inputs[2], text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
      text("w0 = "+weights[0]+" w1 = "+weights[1]+" w2 = "+ weights[2], text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
      text("sum = (x * w0) -> ( "+inputs[0]*weights[0]+" ) + (y * w1) -> "+inputs[1]*weights[1]+" + (bias*w2) -> "+inputs[2]*weights[2]+" =  "+sum, text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
      text("sign(sum) = if (sum > 0) = 1 else = -1 -> "+output, text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
    }

    return output;
  }



  //Formula of the line 
  //weights[0]*x + weights[1]*y + weights[2]*bias (1) = 0
  //Only used for the points of the line. It's not used during the training
  float caulculateY(float x) {
    //float m = weights[0] /  weights[1];
    //float b = weights[2];
    //return m*x + b;
    float w0 = weights[0];
    float w1 = weights[1];
    float w2 = weights[2]; 
    float bias = 1;

    //w0*x + w1*y + w2*bias = 0
    //w1*y = -w0*x - w2*bias
    //y = -w0/w1*x - w2/w1*bias
    float calculated_y = - (w0/w1)*x -(w2/w1)*bias ;
    return calculated_y;
  }



  //1. For every input, multiply that input by its weight
  //2.     Sum all of the weighted inputs
  //3.     Compute the output of the perceptron based on that sum passed through an 
  //       activation function (the sign of the sum)
  //       New weight = weight + ( Error * Input * LearningRate)
  boolean train(float[] inputs, int target) {
    // Guess the result
    int guess = feedforward(inputs, true);

    stroke(0);
    fill(0);

    if (verbose) {
      current_text_y+=text_y_separation;
      text("Calculating error", text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
      text("guessed output = "+guess+" target output = "+target, text_x_separation, current_text_y); 
      current_text_y+=text_y_separation;
    }

    // Compute the factor for changing the weight based on the error
    // Error = desired output - guessed output
    // Note this can only be 0, -2, or 2
    // Multiply by learning constant
    error = target - guess;
    prev_weights[0] = weights[0];
    prev_weights[1] = weights[1];
    prev_weights[2] = weights[2];

    // Adjust weights based on weightChange * input
    for (int i = 0; i < weights.length; i++) {
      weights[i] +=  error * inputs[i] * lr;
    }

    text("error = target - guess = " + error, text_x_separation, current_text_y); 
    current_text_y+=text_y_separation;

    if ( error != 0) {
      if (verbose) {
        printWeightsAdjustment(inputs);
      }

      return true;
    } else {
      current_text_y+=text_y_separation; 
      text("Weights don't change!! Calculated points Left & Right stays the same.", text_x_separation, current_text_y);    
      current_text_y+=text_y_separation;

      return false;
    }
  }


  void printWeightsAdjustment(float[] inputs) {
    text("Increment w0 = (error*x*lr) -> ("+error+"*"+inputs[0]+"*"+lr+") = "+ (error*inputs[0]*lr), text_x_separation, current_text_y); 
    current_text_y+=text_y_separation;
    text("Increment w1 = (error*y*lr) -> ("+error+"*"+inputs[1]+"*"+lr+") = "+ (error*inputs[1]*lr), text_x_separation, current_text_y); 
    current_text_y+=text_y_separation;
    text("Increment w2 = (error*bias*lr) -> ("+error+"*"+inputs[2]+"*"+lr+") = "+ (error*inputs[2]*lr), text_x_separation, current_text_y); 
    current_text_y+=text_y_separation;


    current_text_y+=text_y_separation; 
    text("Adjusting weights", text_x_separation, current_text_y); 
    current_text_y+=text_y_separation;

    text("prev w0 = "+prev_weights[0]+" new  w0 = "+weights[0], text_x_separation, current_text_y);     
    current_text_y+=text_y_separation;
    text("prev w1 = "+prev_weights[1]+" new  w1 = "+weights[1], text_x_separation, current_text_y);     
    current_text_y+=text_y_separation;
    text("prev w2 = "+prev_weights[2]+" new  w2 = "+weights[2], text_x_separation, current_text_y);     
    current_text_y+=text_y_separation;
  }
}