## 환경변수/임시경로 리브랜딩 및 README 장점 섹션 추가

### 핵심 변경 사항
- 환경변수 `CLAUDE_NOTIFY_*` → `AGENT_PULSE_*` 리네이밍 (daemon.sh, README.md, README.ko.md)
- 임시 디렉토리 `/tmp/claude-tmux-*` → `/tmp/agent-pulse-*` 리네이밍
- daemon.sh 주석에 Gemini CLI 추가
- README 양쪽에 "Why tmux-agent-pulse?" 섹션 추가 (제로 설정, 심플 & 비침투적)

### 설계 결정
- 환경변수 prefix를 `AGENT_PULSE_`로 통일하여 플러그인명과 일치시킴
- 경쟁 플러그인(tmux-agent-status, tmux-agent-indicator)과의 차별점을 README에 명시
