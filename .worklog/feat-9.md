## 프로세스 트리 기반 감지로 전환 및 Codex/Gemini CLI 지원

### 핵심 변경 사항
- 감지 방식을 `pane_current_command` 버전 패턴(`N.N.N`)에서 `ps -eo pid,ppid,args` 기반 자식 프로세스 검사로 전환
- 매 poll 사이클마다 `ps` 1회 호출 후 in-memory 필터링으로 모든 pane 처리
- Claude Code, Codex CLI, Gemini CLI 기본 지원
- `CLAUDE_NOTIFY_CLI_PATTERN` 환경변수로 감지 패턴 커스터마이징 가능

### 테스트 결과
- Claude Code: `claude --dangerously-skip-permissions` → `claude` 매칭 확인
- Codex CLI: `node .../bin/codex` → `codex` 매칭 확인
- Gemini CLI: `node .../bin/gemini` → `gemini` 매칭 확인
- 성능: poll당 ~45ms (기존 ~4ms + ps 1회 ~40ms), 0.5초 대비 9%

### 설계 결정
- 모든 pane에 pgrep+ps를 개별 실행하면 ~460ms로 너무 느림 → `ps -eo pid,ppid,args` 1회 호출 후 awk 필터링으로 해결
- `pane_title` 기반 감지는 사용자 변경 가능성으로 배제
