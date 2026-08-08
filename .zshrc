#zmodload zsh/zprof
# 헬퍼 함수 정의 파일 로드
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh

# =====================================================================
# (p10k Instant Prompt 활성화)
# =====================================================================
# 이 코드가 있어야 터미널이 켜지자마자 0.00초 만에 프롬프트가 뜹니다.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==========================================
# 환경 변수 및 기본 설정 (Environment Variables)
# ==========================================

# 역사(History) 파일 설정 (이전 명령어 기억)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # 세션 간 명령어 역사 공유
setopt HIST_IGNORE_ALL_DUPS   # 중복 명령어 저장 안 함
setopt HIST_REDUCE_BLANKS     # 불필요한 공백 제거하고 저장

# Mise
is_command mise && eval "$(mise activate zsh)"

# ==========================================
# 2. Antidote (플러그인 매니저) 초기화 및 로드
# ==========================================

# 플러그인 목록 파일 설정 (기본값: ~/.zsh_plugins.txt)
zsh_plugins_txt="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
zsh_plugins_zsh="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"

# 컴파일이 필요한 상황인지 체크
if [[ ! "$zsh_plugins_zsh" -nt "$zsh_plugins_txt" ]]; then
  # 첫 번째 존재하는 Antidote 경로 획득
  local antidote_funcs=$(find_first \
    "/opt/homebrew/opt/antidote/share/antidote/functions" \
    "/usr/share/zsh-antidote/functions" \
    "${HOME}/.local/share/antidote/functions"
  )
  echo "DEBUG:$antidote_funcs"
  if [[ "$antidote_funcs" ]]; then
    fpath=("$antidote_funcs" $fpath)
    autoload -Uz antidote
    antidote bundle < "$zsh_plugins_txt" > "$zsh_plugins_zsh"
  fi
fi
[[ -f "$zsh_plugins_zsh" ]] && source "$zsh_plugins_zsh"

  
# ------------------------------------------
# 플러그인 세부 설정 (Plugin Configurations)
# ------------------------------------------

#autoload -Uz compinit && compinit
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

# fzf-tab 설정
zstyle ':completion:*' menu no # 기본 zsh 메뉴 자동완성 비활성화
# ★ tmux 안에서 실행 중일 때만 tmux popup 창을 띄우도록 설정
# (tmux 외부에서는 일반 fzf-tab으로 작동)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# fzf-tab의 다양한 비주얼 설정 (옵션 - 취향껏 변경 가능)
zstyle ':fzf-tab:*' fzf-flags '--height=40%' # 일반 터미널에서의 높이
zstyle ':fzf-tab:*' popup-min-size 80 15     # tmux 팝업의 최소 크기 (가로 80, 세로 15)
zstyle ':fzf-tab:*' popup-pad 30 0           # 팝업 여백 설정


# ==========================================
# 기타 터미널 유틸리티 초기화
# ==========================================

#is_command starship && eval "$(starship init zsh)"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==========================================
# Override
# ==========================================
# 1. Emacs 모드 강제 활성화
bindkey -e
# 2. 줄의 맨 앞/뒤 이동 명시적 바인딩 (Zsh 빌트인 명령어 매핑)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

#zprof
