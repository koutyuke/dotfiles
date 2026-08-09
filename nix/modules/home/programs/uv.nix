{
  config,
  pkgs,
  ...
}:
let
  home = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    uv
  ];

  # uv tool の実行ファイル配置先を明示し、下の sessionPath と一致させる。
  # これがないと `uv tool install` した serena などが PATH から解決できず、
  # MCP サーバーの起動に失敗する
  home.sessionVariables = {
    UV_TOOL_BIN_DIR = "${home}/.local/bin";
  };

  home.sessionPath = [
    "${home}/.local/bin"
  ];
}
