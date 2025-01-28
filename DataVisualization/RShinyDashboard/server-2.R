#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



function(input, output, session) {
  
  
  
  ### Sidepanel rendering small text to show user what they have selected
  output$res <- renderText({
    paste("You're viewing:", input$tabs)
  })
  
  ### Begin Overview tab outputs
    
  
  ### Define function to alert when a tab is selected
 
  
  
  ### Data Dictionary
 output$data_dict <-renderTable({
   tibble::tibble(
    'Variable' = names(ponies),
    'Data Type' = ponies %>% map_chr(~paste(class(.),collapse = ' ')),
    'Unique Values' = ponies %>% map_dbl(n_distinct),
    'Missing values' = ponies%>%
      map_dbl(~sum(is.na(.)))
  )})
 
 
 ### Data Glimpse
 output$glimpse <- renderPrint({
   ponies %>% glimpse()
   })
   
### plots for overview page tabs
 
 ### Categorical Counts
 output$plot_barchart_1 <- renderPlot({
   ponies %>% 
     ggplot(aes(y = .data[[input$user_choice_1]]))+
     geom_bar(fill = 'lightblue') +
     theme_bw()
   
   
 })
 
 ### Histograms
 
 output$plot_histogram_1 <- renderPlot({
   ponies %>%
     ggplot(aes(x = .data[[input$user_choice_2]])) +
     geom_histogram(fill = 'red') +
     theme_bw()
 })
   
   ### Heatmaps
   
   
   output$plot_heatmap_1 <- renderPlot({
     ponies %>%
       count(.data[[input$user_choice_3]], .data[[input$user_choice_4]]) %>%
       ggplot(aes(x = .data[[input$user_choice_3]], y = .data[[input$user_choice_4]])) +
       geom_tile(aes(fill = n),
                 color = "black"
                 ) +
       theme_bw()
     
   })
   

 ### Relationship Plots Tab
   output$plot_scatter_1 <- renderPlot({
     ponies %>% 
       ggplot(aes(x = .data[[input$user_choice_5]], y = .data[[input$user_choice_6]])) +
       geom_point(color = 'blue') +
       geom_smooth(method = lm, linetype = 'dashed',
                   color = 'darkred', fill = 'blue') +
       theme_bw()
   })
   
 ### Race Results Page
   
 ### create reactive ui
  
output$race_data_1 <- renderDataTable({
  results_df %>%
    group_by(DATE) %>%
    filter(DATE == input$race_date) %>%
    filter(RACE == input$race_selected)
  
})



### Plots to show stats
  



### value boxes


  




output$marginvictoryBox <- renderValueBox({
  valueBox(avg_marg_stat,"Average Margin of Victory (seconds)",
           icon = icon("flag-checkered")
    
  )
})


output$tophorseBox<- renderValueBox({
  valueBox(by_odds$`STARTER NAME`[1], "Biggest Upset (odds)",
           icon = icon("horse"),
           color = "purple")
})
   
output$distancetraveled <- renderValueBox({
  valueBox(in_miles, "Total Miles Ran",
           icon = icon("route"),
           color = "orange")
})

### Jockey Tab tables

output$jockey_chart <- renderDataTable({
  by_jockey})


### Trainer Tab Table
output$trainer_chart <- renderDataTable({
  by_trainer})

}
 
 
 
  
