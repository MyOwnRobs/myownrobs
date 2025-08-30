
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MyOwnHadley

**A Cursor-style AI Coding Agent for RStudio**

MyOwnHadley is a comprehensive AI-powered coding agent that seamlessly
integrates as an RStudio extension, bringing state-of-the-art AI
capabilities directly to R developers through an autonomous agent-based
approach.

## 🚀 Features

- **🤖 Autonomous AI Agent**: True coding agent that automatically
  selects and executes appropriate tools based on natural language
  requests
- **💬 Integrated Chat Interface**: Familiar Shiny-based chat experience
  directly in RStudio
- **🔧 Comprehensive Toolkit**: Complete set of development tools
  including file operations, code execution, and project management
- **🎯 Context Awareness**: Automatically detects project structure,
  active files, and working directory
- **⚡ Multi-step Workflows**: Handles complex tasks like “Build a Shiny
  app that visualizes my dataset” through intelligent tool orchestration
- **🔍 Code Analysis**: Read, analyze, and understand existing code to
  provide contextual assistance
- **✏️ Intelligent Editing**: Refactor, optimize, and enhance code based
  on natural language instructions

## 📦 Installation

Install the development version of `{myownhadley}` from
[GitHub](https://github.com/jcrodriguez1989/myownhadley) with:

``` r
# install.packages("remotes")
remotes::install_github("jcrodriguez1989/myownhadley")
```

## 🎯 Getting Started

1.  **Launch the Agent**: After installation, you can launch the agent
    by calling `myownhadley()` in the R console, or by opening the
    MyOwnHadley addin through the RStudio Addins menu:
    - Go to `Addins` \> `MyOwnHadley` in RStudio
    - Or use the command palette: `Ctrl/Cmd + Shift + P` → “MyOwnHadley”
2.  **Start Coding**: Simply describe what you want to accomplish in
    natural language:
    - “Create a function to clean this dataset”
    - “Build a ggplot visualization of the iris dataset”
    - “Refactor this code to be more efficient”
    - “Add error handling to my function”

## 💡 Example Use Cases

### Data Analysis Workflow

    "Analyze the mtcars dataset and create a comprehensive report with visualizations"

The agent will:

1.  Load and examine the dataset
2.  Generate exploratory data analysis code
3.  Create meaningful visualizations
4.  Compile results into a report

### Package Development

    "Help me create a new R package for time series analysis"

The agent will:

1.  Set up the package structure
2.  Create function templates
3.  Generate documentation
4.  Set up testing framework

### Code Optimization

    "Optimize this function for better performance and add proper error handling"

The agent will:

1.  Analyze your existing code
2.  Identify performance bottlenecks
3.  Implement optimizations
4.  Add robust error handling

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
For major changes, please open an issue first to discuss what you would
like to change.

## 📄 License

This project is licensed under the MIT License - see the
[LICENSE](LICENSE) file for details.

------------------------------------------------------------------------

**MyOwnHadley** - Democratizing AI-assisted development for the R
community 🎉
