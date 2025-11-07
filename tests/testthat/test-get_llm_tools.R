test_that("get_llm_tools - ask", {
  expect_equal(
    get_llm_tools("ask"), list(
      ai_tool_read_file,
      ai_tool_read_currently_open_file,
      ai_tool_ls_tool,
      ai_tool_file_glob_search,
      ai_tool_grep_search,
      ai_tool_fetch_url_content,
      ai_tool_search_web
    )
  )
})

test_that("get_llm_tools - agent", {
  expect_equal(
    get_llm_tools("agent"), list(
      ai_tool_read_file,
      ai_tool_read_currently_open_file,
      ai_tool_ls_tool,
      ai_tool_file_glob_search,
      ai_tool_grep_search,
      ai_tool_fetch_url_content,
      ai_tool_search_web,
      ai_tool_create_new_file,
      ai_tool_edit_existing_file,
      ai_tool_search_and_replace_in_file,
      ai_tool_run_r_command
    )
  )
})
