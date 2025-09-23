#' Validate MyOwnRobs Policy Acceptance
#'
#' Checks if the user already accepted the usage policy. If the user didn't it prompts the policies.
#'
#' @importFrom shiny runGadget
#' @importFrom yaml read_yaml
#'
#' @keywords internal
#'
validate_policy_acceptance <- function() {
  policy <- read_yaml(system.file(".", "policy.yaml", package = "myownrobs"))
  accepted <- isTRUE(as.numeric(get_config("accepted_policy")) >= policy$version)
  if (!accepted) {
    accepted <- runGadget(policy_ui(policy), policy_server(policy))
  }
  accepted
}

# nocov start

#' Policy Acceptance Shiny UI
#'
#' @param policy A list with the policy.
#'
#' @importFrom shiny actionButton fluidPage icon markdown modalDialog tagList
#'
#' @keywords internal
#'
policy_ui <- function(policy) {
  fluidPage(modalDialog(
    title = policy$title,
    markdown(policy$content),
    footer = tagList(
      actionButton("accept", "Accept", class = "btn-success", icon = icon("check")),
      actionButton("decline", "Decline", class = "btn-danger", icon = icon("times"))
    )
  ))
}

#' Policy Acceptance Shiny Server
#'
#' @param policy A list with the policy.
#'
#' @importFrom shiny observeEvent stopApp
#'
#' @keywords internal
#'
policy_server <- function(policy) {
  function(input, output, session) {
    observeEvent(input$decline, {
      stopApp(FALSE)
    })
    observeEvent(input$accept, {
      set_config("accepted_policy", as.character(policy$version))
      stopApp(TRUE)
    })
  }
}

# nocov end
