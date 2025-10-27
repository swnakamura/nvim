local M = {}

-- 定数
local CACHE_KEY = "staged_char_count_cache"
local NEEDS_UPDATE = "UPDATE"
local AUTOCMD_GROUP = "CharCountCacheGroup"

--- @brief 現在のバッファが通常の編集可能なGitバッファであるかを確認
-- 特殊なバッファ（ヘルプ、ターミナルなど）を除外することで、エラーを防ぐ。
local function is_valid_git_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype

  -- 特殊なファイルタイプを除外
  if vim.tbl_contains({ 'help', 'terminal', 'fugitive', 'packer', 'NvimTree', 'TelescopePrompt', '' }, filetype) then
    return false
  end

  -- ファイルが存在しない（未保存）バッファを除外
  local current_file = vim.fn.expand('%:p')
  if current_file == '' or vim.fn.isdirectory(current_file) == 1 then
    return false
  end

  return true
end

--- @brief キャッシュを無効化（更新が必要な状態に）する関数
local function invalidate_staged_char_count_cache()
  if not is_valid_git_buffer() then
    return
  end

  -- 現在のバッファのローカル変数に NEEDS_UPDATE を設定
  vim.b[CACHE_KEY] = NEEDS_UPDATE
end

--- @brief ステージングされた変更文字数をカウントし、結果をキャッシュする関数
-- lualineのカスタムコンポーネントとして使用するために公開
function M.lualine_diff_with_char_count()
  -- 1. キャッシュの確認
  -- vim.b[CACHE_KEY] は現在のバッファのローカル変数にアクセス
  local cached_result = vim.b[CACHE_KEY]

  -- キャッシュが存在し、更新の必要がない場合はそれを返す
  -- nil のチェックも含め、文字列であることを確認
  if type(cached_result) == 'string' and cached_result ~= NEEDS_UPDATE then
    return cached_result
  end

  local result = "" -- デフォルトで "0" を返すことで nil エラーを防ぐ

  -- 2. コマンドの実行（キャッシュがない、または古い場合）
  local command = [==[
    git diff --word-diff-regex='.' HEAD |
    sed -e 's/{+/\n&/g' -e 's/+}/&\n/g' |
    rg '\{+[^\}]*\}' |
    sed -e 's/{+//' -e 's/+}//' |
    tr -d '\n' |
    wc -m |
    awk '{$1=$1};1'
  ]==]

  local ok, output = pcall(vim.fn.system, command)

  if ok and output then
    local trimmed_output = output:match("^%s*(.-)%s*$")
    local added_char = trimmed_output
    result = result .. added_char .. "文字追加"
  end

  local command = [==[
    git diff --word-diff-regex='.' HEAD |
    sed -e 's/\[-/\n&/g' -e 's/-\]/&\n/g' |
    rg '\[-[^\]]*\]' |
    sed -e 's/\[-//' -e 's/-\]//' |
    tr -d '\n' |
    wc -m |
    awk '{$1=$1};1'
  ]==]
  ok, output = pcall(vim.fn.system, command)

  if ok and output then
    local trimmed_output = output:match("^%s*(.-)%s*$")
    local removed_count = trimmed_output
    result = " " .. result .. removed_count .. "文字削除"
  end

  -- 3. キャッシュの更新
  vim.b[CACHE_KEY] = result
  return result
end

--- @brief モジュールを初期化し、Autocmdを設定する関数
function M.setup()
  -- 古いAutocmdグループがあればクリア
  vim.api.nvim_del_augroup_by_name(AUTOCMD_GROUP)

  -- Autocmdグループを作成
  vim.api.nvim_create_augroup(AUTOCMD_GROUP, { clear = true })

  -- Autocmd の設定: ファイル保存時とバッファ切り替え時にキャッシュを無効化
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    group = AUTOCMD_GROUP,
    callback = invalidate_staged_char_count_cache,
    desc = "ステージング文字数カウントキャッシュを無効化",
  })
end

return M
