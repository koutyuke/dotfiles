{
  config,
  inputs,
  system,
  ...
}:
let
  home = config.home.homeDirectory;
in
{
  # eMudhra 中間証明書を拒否する 0.13.5 が nixpkgs-unstable に届くまで、固定したコミットから取る。
  home.packages = [
    inputs.nixpkgs-uv.legacyPackages.${system}.uv
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
