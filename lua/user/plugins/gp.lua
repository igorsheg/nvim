local M = {
  "robitx/gp.nvim",
  event = "VeryLazy",
  lazy = false,
}

local default_chat_system_prompt = "You are a general AI assistant.\n\n"
    .. "The user provided the additional info about how they would like you to respond:\n\n"
    .. "- If you're unsure don't guess and say you don't know instead.\n"
    .. "- Ask question if you need clarification to provide better answer.\n"
    .. "- Think deeply and carefully from first principles step by step.\n"
    .. "- Zoom out first to see the big picture and then zoom in to details.\n"
    .. "- Use Socratic method to improve your thinking and coding skills.\n"
    .. "- Don't elide any code from your output if the answer requires coding.\n"
    .. "- Take a deep breath; You've got this!\n"


function M.config()
  require("gp").setup {

    providers = {
      anthropic = {
        endpoint = "https://api.anthropic.com/v1/messages",
        secret = os.getenv("ANTHROPIC_API_KEY"),
      },
      -- openai = {
      --   disable = true,
      --   endpoint = "https://api.openai.com/v1/chat/completions",
      --   secret = os.getenv("OPENAI_API_KEY"),
      -- },
    },
    agents = {
      {
        provider = "anthropic",
        name = "ChatClaude-3-5-Sonnet",
        chat = true,
        command = false,
        model = { model = "claude-3-5-sonnet-20240620", temperature = 0.8, top_p = 1 },
        system_prompt = default_chat_system_prompt,
      },
      {
        disable = true,
        name = "ChatGPT4",
        chat = true,
        command = true,
        model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
        system_prompt = default_chat_system_prompt,
      },
    },
  }
end

return M
