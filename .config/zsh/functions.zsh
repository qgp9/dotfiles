# ==========================================
# 🛠️ 내 커스텀 헬퍼 함수 모음 (~/.config/zsh/functions.zsh)
# ==========================================

# 입력된 파일 후보 중, 실제로 존재하는 첫 번째 파일의 절대 경로를 반환합니다.
function find_first() {
  local candidate
  for candidate in "$@"; do
    if [[ -e "$candidate" ]]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1 # 하나도 찾지 못한 경우
}

# 입력된 인자가 실행 가능한 명령어(바이너리 또는 내장 명령)인지 확인
function is_command() {
  command -v "$1" &>/dev/null
}
