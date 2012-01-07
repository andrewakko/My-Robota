// check open GL easycam pEsayCam

 void keyPressed() {
   
  if(key == '='){
  zoom = zoom+0.1;// have to come after set view
  }
  
   if(key == '-'){
  zoom = zoom-0.1;// have to come after set view
  }
  
  if(key == 's'){
  saveFrame("filename-####.jpg");
  
  }
  
   if(key == 'c'){
   background(0); // clean screen
  
  }
  

  
   if(key == '1'){
  deg = deg-1;// have to come after set view
  }
   if(key == '2'){
  deg = deg+1;// have to come after set view
  }
  
  
  
  }
  



 


