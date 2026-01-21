return {
  "David-Kunz/gen.nvim",
  config = function()
    require("gen").setup({
      model = "deepseek-chat",  -- o "deepseek-coder"
      api_key = os.getenv("DEEPSEEK_API_KEY"),
      api = {
        endpoint = "https://api.deepseek.com/v1/chat/completions",
        stream = true,
        adapter = function(response)
          return response.choices[1].message.content
        end,
      },
      display_mode = "split", -- puedes usar "split" o "float"
    })
  end,
}

