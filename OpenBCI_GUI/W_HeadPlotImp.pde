//author: Drose

class W_headPlotImp extends Widget {

    String showingScreen;

    ControlP5 topFrame;
    int widgetColorBkgr = 255;
    /* header */
    Button backBtn;
    Button nextBtn;
    Button headConnBtn;
    Button eegBtn;
    Button concenBtn;
    Button trainingBtn;
    int rectOff = 8;
    public String intensity_data_uV;    
    int navButtonWidth, navButtonHeight; //dims of nav buttons

    /* widget grid */
    int col0;
    int row0;
    int colWidth = 150;

    /* widget dims */
    final int screenTitleTextSizeW = 120, screenTitleTextSizeH = 20;
    int headerHeight;
    int titleTextSize = 14;

    /* screens */
    Boolean headConnVisible;
    Boolean eegVisible;
    Boolean concenVisible;
    Boolean trainingVisible;

    String[] screenNames = {"connectivity","eeg","concentration","profile"};
    String[] firstLabelNames = {"first screen",
    "second screen", "third screen", "fourth screen"};

    W_headPlotImp(PApplet _parent){
        super(_parent); //calls the parent CONSTRUCTOR method of Widget (DON'T REMOVE)
        
        showingScreen = "connectivity";
        navButtonHeight = 20;
        navButtonWidth = 100; 
        col0 = 150;
        headerHeight = navButtonHeight + rectOff;
        row0 = y + headerHeight + 30;
        topFrame = new ControlP5(pApplet);
               
        initialize_UI();   
        topFrame.setAutoDraw(false);   
    }

    public void update(){
        super.update();
    }

    public void draw(){
        super.draw();
        background(color(widgetColorBkgr));
        
        drawHeader();
        //showWidgetGrid();

        pushStyle();
        topFrame.draw();

        //build anything that does not have to be init and hidden
        widgetFactory(showingScreen);
        //show and hide widgets on screen change
        //showScreenWidgets(showingScreen);
        
        popStyle(); 
    }
    
    //only put widgets here that are drawn with ControlP5 topFrame. Anything else won't be drawn
    void initialize_UI(){        
        drawTransitionBtns();
        drawNavToWidgetBtns();
    }

    public void screenResized(){
        super.screenResized();
    }

    public void mousePressed(){
        super.mousePressed();
    }

    //Draws the header bar
    void drawHeader(){
        pushStyle();
        fill(color(128));
        stroke(0);
        rect(x, y, x + w, headerHeight);
        popStyle();
    }

    //This draws the header buttons that allows the use to nav thru the widgets
    void drawTransitionBtns(){         
        backBtn = createButton(topFrame, "buttonID1", "Back", x + 10, y+5, navButtonWidth, navButtonHeight, 0, p4, 14, WHITE, BLACK, BUTTON_HOVER, BUTTON_PRESSED, OBJECT_BORDER_GREY, 0);
        backBtn.onRelease(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                print("back button pressed\n");
                int ind = 0;
                int size = screenNames.length;
                for(int i=0;i<size;i++){
                    if(screenNames[i].equals(showingScreen)){
                        ind = i;
                    }
                }
                showingScreen = screenNames[(ind+size-1)%size];
            }
        });
        backBtn.setDescription("Click here to go back.");
        nextBtn = createButton(topFrame, "buttonID2", "Forward", x + w - navButtonWidth - 10, y+5, navButtonWidth, navButtonHeight, 0, p4, 14, WHITE, BLACK, BUTTON_HOVER, BUTTON_PRESSED, OBJECT_BORDER_GREY, 0);
        nextBtn.onRelease(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                print("next button pressed\n");
                int ind = 0;
                int size = screenNames.length;
                for(int i=0;i<size;i++){
                    if(screenNames[i].equals(showingScreen)){
                        ind = i;
                    }
                }                
                showingScreen = screenNames[(ind+1)%size];
            }
        });
        nextBtn.setDescription("Click here to go forward.");              
    }

    //This draws the buttons to navigate directly to each widget
    void drawNavToWidgetBtns(){
        headConnBtn = createButton(topFrame, "buttonID3", "gotoHeadConn", x + 102 + navButtonWidth, y+5, navButtonWidth, navButtonHeight, 0, p4, 14, WHITE, BLACK, BUTTON_HOVER, BUTTON_PRESSED, OBJECT_BORDER_GREY, 0);
        headConnBtn.onRelease(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                print("nav to head connection\n");
                showingScreen = "connectivity";
            }
        });
        eegBtn = createButton(topFrame, "buttonID4", "gotoEEG", x + 104 + navButtonWidth*2, y+5, navButtonWidth, navButtonHeight, 0, p4, 14, WHITE, BLACK, BUTTON_HOVER, BUTTON_PRESSED, OBJECT_BORDER_GREY, 0);
        eegBtn.onRelease(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                print("nav to eeg plot\n");
                showingScreen = "eeg";
            }
        });
        concenBtn = createButton(topFrame, "buttonID5", "gotoConcen", x + 106 + navButtonWidth*3, y+5, navButtonWidth, navButtonHeight, 0, p4, 14, WHITE, BLACK, BUTTON_HOVER, BUTTON_PRESSED, OBJECT_BORDER_GREY, 0);
        concenBtn.onRelease(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                print("nav to concentration algo\n");
                showingScreen = "concentration";
            }
        });
        trainingBtn = createButton(topFrame, "buttonID6", "gotoProfile", x + 108 + navButtonWidth*4, y+5, navButtonWidth, navButtonHeight, 0, p4, 14, WHITE, BLACK, BUTTON_HOVER, BUTTON_PRESSED, OBJECT_BORDER_GREY, 0);
        trainingBtn.onRelease(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                print("nav to my profile\n");
                showingScreen = "profile";
            }
        });
    }

    //Draws gridlines to visualise grid coordinates
    void showWidgetGrid(){
        pushStyle();
        strokeWeight(1);
        stroke(255,0,0);
        line(x,row0,x+w,row0);
        line(col0,y,col0,y+h);
        popStyle();
    }

    //Build the required widgets given its name.
    void widgetFactory(String showingScreen){
        titleTextFactory(showingScreen);
    }

    void titleTextFactory(String shownScreen){
        pushStyle();
        int txtW = (int) textWidth(shownScreen);
        int txtH = titleTextSize;
        txtW+=10;
        txtH+=4;
        strokeWeight(2);
        stroke(0);
        fill(255);
        rect(col0, row0, txtW, -20, BUTTON_ROUNDING);
        int topLeftPadding = 5;
        fill(0);
        textSize(titleTextSize);
        text(shownScreen,col0+topLeftPadding,row0-topLeftPadding); 
        popStyle();
    }

};

