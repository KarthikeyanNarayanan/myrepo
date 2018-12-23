#---------------------------------------------------------------------#
#               UDPipe Shiny App                               #
#---------------------------------------------------------------------#


library("shiny")

shinyUI(
  fluidPage(
  
    titlePanel("NLP Workflows using UDPipe Package"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("file1", "Upload text file"),
              
              fileInput("file2", "Upload trained udpipe model"),
    
              checkboxGroupInput('pos', 'List of POS tags:', choices =list("adjective(JJ)" = "JJ",
                                                                 "Noun(NN)" = "NN",
                                                                 "proper noun(NNP)" = "NNP",
                                                                 "adverb(RB)" = "RB",
                                                                 "verb(VB)" = "VB"), 
                                 selected = c("JJ","NN","NNP"))
              #hr() ,
              #fluidRow(column(3, verbatimTextOutput("value")))
              ),   # end of sidebar panel
              
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("How to use this APP")),
                               p("To use this app you need a document corpus in txt file format and a trained UDPipe model.The App supports English, Hindi and Spanish models.Make sure each document is separated from another document with a new line character. To execute the app, click on the two Browse buttons in left-sidebar panel and upload the txt file and trained models respectively. Once the file is uploaded it will do the computations in back-end with default inputs and accordingly results will be displayed in various tabs.
                                  The checkbox panel will allow for POS tags to be selected as desired, please note that if you upload Spanish text and model the panel will change to display UPOS tags, for English and Hindi models XPOS tags will be displayed.The checkbox inputs can be altered,accordingly results in other tabs will be refreshed.If an Hindi model is uploaded the tab Co-occurence Tables will just display the UTF encoded characters",align="justify"),
                               p("Sample corpus files can be downloaded here"),
                               br(),
                               h4(p("Download Sample text file")),
                               downloadButton('downloadData1', 'Download English txt file'),
                               downloadButton('downloadData12', 'Download Spanish txt file'),
                               downloadButton('downloadData3', 'Download Hindi txt file'),br(),br(),
                               p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                               img(src = "example1.png"),
                               #, height = 280, width = 400
                               verbatimTextOutput("start")),
                      tabPanel("Annotated Document", 
                               dataTableOutput('annotate_doc')),
                   
                      tabPanel("Co-occurence Tables",h4("Sentence Co-occurrences"),
                         verbatimTextOutput("summary"),
                         br(),
                         br(),
                         h4("General (non-sentence based) Co-occurrences"),
                         verbatimTextOutput("summary1"),
                         br(),
                         br(),
                         h4("Skipgram based Co-occurrences"),
                         verbatimTextOutput("summary2")),
                         
                      tabPanel("Co-occurences Plot",
                         plotOutput('cooc_plot')),
                  
                      tabPanel("Word Cloud",
                           h4("Word Cloud"),
                           plotOutput("wordcloud",height = 700, width = 700))
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
                ) # end of UI
  


