options(shiny.maxRequestSize=30*1024^2) 
shinyServer(function(input, output, session)  {

 
  dataset <- reactive({
    if (is.null(input$file1)) {return(NULL)}
      else {
        Document = readLines(input$file1$datapath, encoding = 'UTF-8')
        clean_doc=str_replace_all(Document, "<.*?>", "") 
        return(Document)}
      })
  

  observe({ 
    
    if (is.null(input$file2)) {return(NULL)}
    else {
          if (substring(input$file2$name,1,3) == "spa"){
            
            updateCheckboxGroupInput(session,'pos', choices =list("adjective(ADJ)" = "ADJ",
                                                                                 "Noun" = "NOUN",
                                                                                 "proper noun(PROPN)" = "PROPN",
                                                                                 "adverb(ADV)" = "ADV",
                                                                                 "VERB" = "VERB"), 
                                     selected = c("ADJ","NOUN","PROPN"))}
          }

  }) 
  
  udpipemodel <- reactive({
    if (is.null(input$file2)) {return(NULL)}
    else {
      
      model = udpipe_load_model(input$file2$datapath)
          x <- udpipe_annotate(model, x = dataset())
          x <- as.data.frame(x)
      return(x)}
  })
  
  output$annotate_doc <- renderDataTable({
   
    if (is.null(input$file2)) {return(NULL)}
    else {
          
          if (substring(input$file2$name,1,3) == "spa"){
              filter = udpipemodel() %>% subset(., upos %in% input$pos)
              out = head(filter)}
              
          else {
              filter = udpipemodel() %>% subset(., xpos %in% input$pos)}
              
          if (substring(input$file2$name,1,3) == "hin"){
              windowsFonts(devanew=windowsFont("Devanagari new normal"))}
          
          out = head(filter)
          
          out}
    
    })
  cooc_main <- reactive({

    if (substring(input$file2$name,1,3) == "spa"){
          cooc_out <- cooccurrence(x = subset(udpipemodel(), upos %in% input$pos), 
                                   term = "lemma", 
                                   group = c("doc_id", "paragraph_id", "sentence_id"))}
    else{
        cooc_out <- cooccurrence(x = subset(udpipemodel(), xpos %in% input$pos), 
                                 term = "lemma", 
                                 group = c("doc_id", "paragraph_id", "sentence_id"))}
  })
  
 output$summary  <- renderPrint({
   windowsFonts(devanew=windowsFont("Devanagari new normal"))
   head(cooc_main())
  })
 
 output$summary1  <- renderPrint({
   if (substring(input$file2$name,1,3) == "spa"){
       cooc_gen <- cooccurrence(x = udpipemodel()$lemma, 
                            relevant = udpipemodel()$upos %in% input$pos)}
   else{
       cooc_gen <- cooccurrence(x = udpipemodel()$lemma, 
                            relevant = udpipemodel()$xpos %in% input$pos)}
   
   head(cooc_gen)
 })
 
 output$summary2  <- renderPrint({

   if (substring(input$file2$name,1,3) == "spa"){
        cooc_skipgm <- cooccurrence(x = udpipemodel()$lemma, 
                       relevant = udpipemodel()$upos %in% input$pos,skip =4)}
   else{
        cooc_skipgm <- cooccurrence(x = udpipemodel()$lemma, 
                       relevant = udpipemodel()$xpos %in% input$pos,skip =4)}
   
   head(cooc_skipgm)
 })
 
 output$cooc_plot <- renderPlot({
   
   wordnetwork <- head(cooc_main(), 50)
   wordnetwork <- igraph::graph_from_data_frame(wordnetwork) 
   
   ggraph(wordnetwork, layout = "fr") +  
     
     geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
     geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
     
     theme_graph(base_family = "Arial Narrow") +  
     theme(legend.position = "none") +
     
     labs(title = "Cooccurrences within 3 words distance", subtitle = "Based on POS Keywords Selected")
   
 })

 
 output$wordcloud <- renderPlot({
   
   all_nouns = udpipemodel() %>% subset(., upos %in% "NOUN")
   top_nouns = txt_freq(all_nouns$lemma)
   wordcloud(words = top_nouns$key, 
             freq = top_nouns$freq, 
             min.freq = 2, 
             scale=c(5,2), 
             max.words = 100,
             random.order = FALSE, rot.per=0.35, use.r.layout=FALSE,
             colors = brewer.pal(6, "Dark2"))
 })
 
 
 output$downloadData1 <- downloadHandler(
   filename = function() { "Nokia_Lumia_reviews.txt" },
   content = function(file) {
     writeLines(readLines("https://github.com/KarthikeyanNarayanan/myrepo/blob/master/data/Nokia_Lumia_reviews.txt"), file)
   }
 )
 output$downloadData2 <- downloadHandler(
   filename = function() { "Spanish.txt" },
   content = function(file) {
     writeLines(readLines("https://github.com/KarthikeyanNarayanan/myrepo/blob/master/data/Spanish.txt"), file)
   }
 )
 output$downloadData3 <- downloadHandler(
   filename = function() { "Hindi.txt" },
   content = function(file) {
     writeLines(readLines("https://github.com/KarthikeyanNarayanan/myrepo/blob/master/data/Hindi.txt"), file)
   }
 )
 
  
})
