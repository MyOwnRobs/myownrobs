# Initialize a new env for this package, with just the default api_key.
.state <- new.env(parent = emptyenv())
assign("api_key", Sys.getenv("MYOWNROBS_API_KEY"), envir = .state)
