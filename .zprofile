# 헬퍼 함수 정의 파일 로드
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh

# ==========================================
# 1. 전역 시스템 인코딩 및 기본 에디터 설정
# ==========================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="vim"

# ==========================================
# 2. OS별 바인딩
# ==========================================

# 첫 번째 존재하는 brew 경로 획득
BREW_PATH=$(find_first \
  "/opt/homebrew/bin/brew" \
  "/usr/local/bin/brew" \
  "/home/linuxbrew/.linuxbrew/bin/brew"
)
[[ "$BREW_PATH" ]] && eval "$("$BREW_PATH" shellenv)"

. ~/bin/my-ssh-agent.sh

#alias m="mise"
alias vi="vim"
is_command nvim && alias vim="nvim"
if [ -d ~/.config/lazyvim ]; then
    alias lv='NVIM_APPNAME=lazyvim nvim ${NVIM:+--server ${NVIM} --remote-tab}'
    alias lvi='NVIM_APPNAME=lazyvim nvim ${NVIM:+--server ${NVIM} --remote-tab}'
fi
is_command mise && alias mx="mise x --"

export PATH=~/bin:${PATH}
