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
    int table1boderThick = 2;
    int table1rowHeight = 20;
    int table1colWidth = 20;
    int table1col0;
    int table1col1;
    int table1col2;
    int table1row0;
    int table1row1;
    int table1row2;

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
    String connectivityName= screenNames[0], eegName = screenNames[1], concentrationName = screenNames[2], profileName = screenNames[3];
    String[] firstLabelNames = {"first screen",
    "second screen", "third screen", "fourth screen"};
    Map<String, ArrayList<String>> screenWidgetMap = new HashMap();
    Map<String, Boolean> screenIsShowingMapping = new HashMap();

    W_headPlotImp(PApplet _parent){
        super(_parent); //calls the parent CONSTRUCTOR method of Widget (DON'T REMOVE)
        
        showingScreen = "connectivity";
        navButtonHeight = 20;
        navButtonWidth = 100; 
        col0 = 150;
        headerHeight = navButtonHeight + rectOff;
        row0 = y + headerHeight + 30;
        table1col0 = 300;
        table1col1 = table1col0 + table1colWidth + table1boderThick;
        table1col2 = table1col0 + 2*(table1colWidth + table1boderThick);
        table1row0 = y + headerHeight + 75;
        table1row1 = table1row0 + table1rowHeight + table1boderThick;
        table1row2 = table1row0 + 2*(table1rowHeight + table1boderThick);
        topFrame = new ControlP5(pApplet);

        for(int i=0;i<screenNames.length;i++){
            screenWidgetMap.put(screenNames[i], new ArrayList());
            screenIsShowingMapping.put(screenNames[i], false);
        }
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
        showScreenWidgets(showingScreen);
        
        popStyle(); 
    }
    
    //only put widgets here that are drawn with ControlP5 topFrame. Anything else won't be drawn
    void initialize_UI(){        
        drawTransitionBtns();
        drawNavToWidgetBtns();
        drawLearningProfile();
        drawConcentrationPage();
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

    void drawLearningProfile(){
        String btn1Name = profileName+"_btn1";
        topFrame.addButton(btn1Name)
            .setPosition(table1col0, table1row0)                   
            .setSize(8*table1colWidth,20)           
            .setFont(f2)
            .setValueLabel("See Learning")     
            .setCaptionLabel("")                    
            .setVisible(false)        
            ;
        String btn2Name = profileName+"_btn2";
        topFrame.addButton(btn2Name)
            .setPosition(table1col0, table1row1)                   
            .setSize(8*table1colWidth,20)           
            .setFont(f2)                            
            .setColorBackground(BLACK)
            .setValueLabel("Another button")     
            .setCaptionLabel("")                    
            .setVisible(false)
            ;        
        screenWidgetMap.get(profileName).add(btn1Name);
        screenWidgetMap.get(profileName).add(btn2Name);
    }

    void drawConcentrationPage(){
        String btn1Name = concentrationName+"_btn1";
        topFrame.addButton(btn1Name)
            .setPosition(table1col1, table1row0)                   
            .setSize(6*table1colWidth,20)           
            .setFont(f2)
            .setValueLabel("Click Me!")     
            .setCaptionLabel("")                    
            .setVisible(false)                    
            ;
        screenWidgetMap.get(concentrationName).add(btn1Name);
    }

    //draws the widgets added to the top frame controlP5 by the screen
    // the widget name is assigned to in screenWidgetMap
    void showScreenWidgets(String screen){
        for(int i=0;i<screenNames.length;i++){
            if(screen.equals(screenNames[i])){
                if(!screenIsShowingMapping.get(screenNames[i])){
                    ArrayList<String> list = screenWidgetMap.get(screenNames[i]);
                    for(String s: list){
                        print("showing: "+s+"\n");
                        topFrame.get(controlP5.Controller.class, s).setVisible(true);
                    }
                    screenIsShowingMapping.put(screenNames[i], true);
                }                
            }else if(screenIsShowingMapping.get(screenNames[i])){
                ArrayList<String> list = screenWidgetMap.get(screenNames[i]);
                for(String s: list){
                    print("hiding: "+s+"\n");
                    topFrame.get(controlP5.Controller.class, s).setVisible(false);
                }
                screenIsShowingMapping.put(screenNames[i], false);
            }
        }        
    }

    //Draws gridlines to visualise grid coordinates
    void showWidgetGrid(){
        pushStyle();
        strokeWeight(1);
        stroke(255,0,0);
        line(x,row0,x+w,row0);
        line(col0,y,col0,y+h);
        //table 1
        stroke(0,255,0);
        line(x,table1row0,x+w,table1row0);
        line(table1col0,y,table1col0,y+h);
        line(x,table1row1,x+w,table1row1);
        line(table1col1,y,table1col1,y+h);
        line(x,table1row2,x+w,table1row2);
        line(table1col2,y,table1col2,y+h);
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

