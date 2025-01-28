667#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.




dashboardPage(skin = "red",
  dashboardHeader(title = "Saratoga Juvenile Horse Racing Dashboard",
                  titleWidth = 450),
  
  dashboardSidebar(width = 150,
    sidebarMenu(id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("horse")),
      menuItem("Results/Stats",tabName = "results", icon = icon("trophy")),
      menuItem("Jockeys", tabName = "jockeys", icon= icon("people-group")),
      menuItem("Trainers", tabName = "trainers", icon = icon("user-secret"))
    
  ),
  textOutput("res")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              fluidRow(
                h2("Welcome to the Saratoga Juvenile Horse Racing Dashboard!"),
                box(title = "About Saratoga Race Track", background= "red", solidHeader = TRUE,
                  collapsibled = TRUE, "Located in Saratoga Springs, NY, Saratoga Race Track is a historic racing venue that opens its season in July and runs through September. The significance of this timing is that it is the end of the 'American Triple Crown' season and before the Breeders World Cup. Saratoga is a place where young horses can get their spotlight and champions can prove their might. Nicknamed 'The Graveyard of Champions' Saratoga has a reputation for upsets and crowd pleasing performances."),
                box(title = "About Juvenile Horses", background = "green", solidHeader = TRUE,
                    collapsible = TRUE, "What categorizes a horse as a juvenile is that the horse is considered 2 years old. Every race horse has a labeled age based on January 1. That is, all horses born in the same year share a birthday of January 1. So, all horses included in the dataset are 2 year old horses in 'Horse Racing' Years!")  
              ),
              fluidRow(
               tabBox(title = "Dataset Overview",
                      id = "tabset1", width = 15,height = "300px",
                      tabPanel("Data Dictionary", 
                               tableOutput("data_dict")),
                      tabPanel("Data Glimpse",
                               verbatimTextOutput("glimpse")),
                      tabPanel("Distributions & Counts", 
                               sidebarLayout(
                                 sidebarPanel(
                                
                                   conditionalPanel(condition = "input.sub_tabset_1==1",
                                                    selectInput('user_choice_1',
                                                                'Select variable:',
                                                                choices = cat_choices,
                                                                selected = cat_choices[1])),
                                   conditionalPanel(condition = "input.sub_tabset_1==2",
                                                    selectInput('user_choice_2',
                                                                'Select variable:',
                                                                choices = cont_choices,
                                                                selected = cont_choices[1])),
                                   conditionalPanel(condition = "input.sub_tabset_1==3",
                                                    selectInput('user_choice_3',
                                                                'Select x variable:',
                                                                choices = cat_choices,
                                                                selected = cat_choices[1]
                                                                ),
                                                    selectInput('user_choice_4',
                                                                'Select y variable:',
                                                                choices = cat_choices,
                                                                selected = cat_choices[2]
                                                    ))
                                   ),
                            
                                 mainPanel(
                                   tabsetPanel( id = "sub_tabset_1",
                                     tabPanel("Marginal Counts", value = 1,
                                              h5("Bar Charts"),
                                              plotOutput("plot_barchart_1")),
                                     tabPanel("Marginal Distributions", value = 2,
                                              h5("Histograms"),
                                              plotOutput("plot_histogram_1")),
                                     tabPanel("Heatmaps",value = 3,
                                              h5("Combinations of Categorical Variables"),
                                              plotOutput("plot_heatmap_1"))
                                     
                                   )
                                 )
                              )
                          ),
                      tabPanel("Relationship Plots",
                               sidebarLayout(
                                 sidebarPanel(
                                   selectInput('user_choice_5',
                                                          'Select x variable:',
                                                          choices = cont_choices,
                                                          selected = cont_choices[1]),
                                   selectInput('user_choice_6',
                                               'Select y variable:',
                                               choices = cont_choices,
                                               selected = cont_choices[2])),
                                 mainPanel(
                                   h4("Relationship Plots"),
                                   plotOutput("plot_scatter_1")
                                 )
                               ))
                      
                  
              ))),
      tabItem(tabName = "results",
            fluidRow(
              box(title = "Race Results", width = 120,height = "800px",
                  sidebarLayout(
                    sidebarPanel(width = 3,
                                 dateInput(inputId = 'race_date',
                                           label = "Date of race:", 
                                           value = ponies$DATE[1],
                                           min = ponies$DATE[1],
                                           max = ponies$DATE[-1],
                                           startview = "month"
                                 ),
                                 selectInput(inputId = 'race_selected',
                                             label = "Race #",
                                             choices = ponies$RACE,
                                             selected = ponies$RACE[1]
                                             )
                                ),
                    mainPanel(
                      dataTableOutput("race_data_1")
                    )
                  )
                  
                  
              )),
            fluidRow(
              valueBoxOutput("marginvictoryBox"),
              valueBoxOutput("tophorseBox"),
              valueBoxOutput("distancetraveled"))),
            
      tabItem(tabName = "jockeys",
              fluidRow(
                box(width = 14,
                  
                  h3("Jockey Performances"),
                  h4("Use search bar or arrows to filter:"),
                    dataTableOutput("jockey_chart"
                                    )
                  )
                )
                
              ),
      tabItem(tabName = "trainers",
              fluidRow(
                box(width = 14,
                    
                    h3("Trainer Performances"),
                    h4("Use search bar or arrows to filter:"),
                    dataTableOutput("trainer_chart"
                    )
                )
              )
              
      )
    )
      
))


