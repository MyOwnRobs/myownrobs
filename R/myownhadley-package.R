.state <- new.env(parent = emptyenv())
assign("api_key", Sys.getenv("MYOWNHADLEY_API_KEY"), envir = .state)
