SSH_AGENT_ENV=~/.ssh/ssh-agent-env.txt
. $SSH_AGENT_ENV
if ! ps -p "$SSH_AGENT_PID" -o pid,uid,comm 2>/dev/null | grep -e '^\s*'$SSH_AGENT_PID'\s\s*'$UID'\s\s*ssh-agent' > /dev/null; then
	ssh-agent -s | grep -v echo > $SSH_AGENT_ENV
	. $SSH_AGENT_ENV
	# GUI apps (Claude Code, etc.) don't inherit this shell's SSH_AUTH_SOCK --
	# they get launchd's copy instead. Only the socket path changes here (a
	# fresh agent), so this is the only branch where launchd needs updating;
	# the reused-agent path leaves the path (and launchd's copy) unchanged.
	# launchctl is macOS-only; guard both so this is a silent no-op elsewhere.
	if [ "$(uname)" = "Darwin" ] && command -v launchctl > /dev/null 2>&1; then
		launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
	fi
fi
