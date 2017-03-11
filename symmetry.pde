PImage img;
int wmin, wmax, hmin, hmax, 
    w,  //width of tile
    h,  //height of tile
    xo, //x origin point to sample img for tile
    yo; //y origin point to sample image for tile
    
int wcount, hcount, 
    xstart, //x origin point to begin drawing 
    ystart, //y origin point to begin drawing
    xpos,   //x position to draw tile at
    ypos;   //y position to draw tile at
int pass;

void setup(){
  size(800, 600);
  background(255);
  frameRate(30);
  img = loadImage("tomb.jpg");
  wmin = 50;     //width min
  wmax = 300;    //width max
  hmin = 25;     //height min
  hmax = 200;    //height max
  wcount = (width / wmin); //how many columns to draw
  hcount = (height / hmin); //how many rows to draw
  newOrigins();  //set starting point //<>//
  newTileSize(); //set tile size
}
void draw(){
  PImage tile = img.get(xo, yo, w, h);             //grab a tile from the image
  PImage tileFlipX =  getReversePImage(tile);      //flip tile on x
  PImage tileFlipY =  getFlipPImage(tile);         //flip tile on y
  PImage tileFlipXY =  getFlipReversePImage(tile); //flip tile on x and y
  xpos = xstart;
  ypos = ystart;
  
  //outer loop is columns
  for(int x = 0; x < wcount; x++){
    //inner loop is rows
    for(int y = 0; y < hcount; y++){
      //even column, even row, draw tile
      if ((x % 2) == 0 && (y % 2) == 0){
        image(tile, xpos, ypos);
      }
      //odd column, even row, draw tile flipped on x
      else if ((x % 2) > 0 && (y % 2) == 0){
        image(tileFlipX, xpos, ypos);
      }
      //even column, odd row, draw tile flipped on y
      else if ((x % 2) == 0 && (y % 2) > 0){
        image(tileFlipY, xpos, ypos);
      }
      //odd column, odd row, draw tile flipped on x and y
      else if ((x % 2) > 0 && (y % 2) > 0){
        image(tileFlipXY, xpos, ypos);
      }      
      //Tile drawn in column, move up height of tile for next one
      ypos = ypos + h;
    }
    ypos = ystart;   //Column drawn, restart at bottom row
    xpos = xpos + w; //Move over width of tile for next column
  }
  
  //Check if origin points keep the tile size within the image
  if (pass == 1 && xo < (img.width - w) && yo < (img.height - h)){
    //if we are on first pass increment the x/y origin and grow the tile size a pixel
    xo++;
    yo++;
    w++;
    h++;
    //now recalculate origin points
    setupTiles();
  }
  else{
    //if not, start second pass
    pass = 2;
    //make sure we aren't going under min tile size
    if (w < wmin || h < hmin){
      //if so, set a new origin point
      newOrigins();
      // could pick a new tile size, if not it will start growing up from min again
      //newTileSize();
    }
    //shrink the tile size
    else{
      xo--;
      yo--;
      w--;
      h--;
      //reset origin point
      setupTiles();
    }
  }
  //saveFrame("frames/mirrors-######.jpg");  //uncomment to save frames to use in moviemaker
}

//Set origin points
public void newOrigins(){
  pass = 1;
  xo = int(random(0, (img.width - w)));  //keeps new origin within existing tile, first call w = 0
  yo = int(random(0, (img.height - h))); //keeps new origin within existing tile, first call h = 0
}

//Sets tile size
public void newTileSize(){
  w = int(random(wmin, wmax));
  h = int(random(hmin, hmax));
  setupTiles();
}

//sets xstart, ystart for where to start drawing image with tiles from
//formula keeps center symmetry on center point
//((split width/height) - width/height of tile) 
// then subtract half number of columns/rows to draw (making sure that is an even number)
// multiplied by the width/height of the current tile size
// this results in a negative number and begins drawing the tiles off screen
// which ensures edge to edge coverage
public void setupTiles(){
  xstart = ((width / 2) - w) - (((wcount / 2) - 1) * w);  //<>//
  ystart = ((height / 2) - h) - (((hcount / 2) - 1) * h); 
}

//Reverses image on the x axis
public PImage getReversePImage( PImage image ) {
 PImage reverse = new PImage( image.width, image.height );
 for( int i=0; i < image.width; i++ ){
  for(int j=0; j < image.height; j++){
   reverse.set( image.width - 1 - i, j, image.get(i, j) );
  }
 }
 return reverse;
}

//Flips image on the y axis
public PImage getFlipPImage( PImage image ) {
 PImage reverse = new PImage( image.width, image.height );
 for( int i=0; i < image.width; i++ ){
  for(int j=0; j < image.height; j++){
   reverse.set(i, image.height -1 - j, image.get(i, j) );
  }
 }
 return reverse;
}

//Reverses image on the x and flips it on the y
public PImage getFlipReversePImage( PImage image ) {
 PImage reverse = new PImage( image.width, image.height );
 for( int i=0; i < image.width; i++ ){
  for(int j=0; j < image.height; j++){
   reverse.set( image.width - 1 - i, image.height -1 - j, image.get(i, j) );
  }
 }
 return reverse;
}