# tmux-agent-pulse

[English](README.md) | **한국어**

tmux에서 AI CLI 도구의 응답 상태를 알려주는 플러그인입니다. Claude Code, Codex CLI, Gemini CLI를 기본 지원합니다.

AI CLI 도구가 동작 중일 때 윈도우 이름에 상태 아이콘을 표시합니다:

- **💬** — AI가 응답 중 (2.5초 이상 출력 감지)
- **✅** — AI 응답 완료 (출력 중단)
- 해당 윈도우로 전환하면 아이콘 자동 제거

## 왜 tmux-agent-pulse인가?

- **제로 설정** — 설치만 하면 바로 동작합니다. 훅 설정, API 키, 도구별 설정이 필요 없습니다.
- **심플 & 비침투적** — 윈도우 이름에 아이콘 하나만 표시합니다. 상태바를 차지하거나 색상을 바꾸지 않습니다.

다른 플러그인(tmux-agent-status, tmux-agent-indicator 등)은 Claude Code 훅이나 도구별 설정이 필요합니다. tmux-agent-pulse는 프로세스 트리 검사로 지원 CLI 도구를 자동 감지합니다.

## 동작 방식

백그라운드 데몬이 0.5초마다 모든 tmux pane을 폴링합니다. 각 pane의 자식 프로세스(`ps -eo pid,ppid,args`)를 검사하여 AI CLI 도구를 식별하고, 출력 스냅샷을 비교하여 활동 변화를 감지합니다. 별도 설정이 필요 없습니다.

## 설치

### 요구사항

- tmux 3.0+
- [TPM](https://github.com/tmux-plugins/tpm)

> **참고:** 플러그인 로드 시 tmux 상태바를 자동으로 활성화합니다 (`set -g status on`). 윈도우 이름에 아이콘을 표시하기 위해 필요합니다.

### TPM으로 설치

`~/.tmux.conf`에 추가:

```bash
set -g @plugin 'devbrother2024/tmux-agent-pulse'
```

`prefix + I`를 눌러 설치합니다.

### 수동 설치

```bash
git clone https://github.com/devbrother2024/tmux-agent-pulse ~/.tmux/plugins/tmux-agent-pulse
```

`~/.tmux.conf`에 추가:

```bash
run-shell ~/.tmux/plugins/tmux-agent-pulse/agent-pulse.tmux
```

## 설정

플러그인 로드 전에 설정할 수 있는 환경변수입니다 (모두 선택사항):

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `AGENT_PULSE_INTERVAL` | `0.5` | 폴링 간격 (초) |
| `AGENT_PULSE_THRESHOLD` | `5` | 응답 중 판정에 필요한 연속 변경 횟수 |
| `AGENT_PULSE_DONE_THRESHOLD` | `3` | 완료 판정에 필요한 연속 미변경 횟수 |
| `AGENT_PULSE_ICON_RESPONDING` | `💬` | 응답 중 아이콘 |
| `AGENT_PULSE_ICON_DONE` | `✅` | 완료 아이콘 |
| `AGENT_PULSE_CLI_PATTERN` | `claude\|codex\|gemini` | CLI 도구 감지용 정규식 패턴 |

`~/.tmux.conf` 설정 예시:

```bash
set-environment -g AGENT_PULSE_THRESHOLD 3
set-environment -g AGENT_PULSE_ICON_DONE "⏎"
```

## 제거

1. `~/.tmux.conf`에서 플러그인 줄 삭제
2. `prefix + alt + u` (TPM 제거)
3. 임시 파일 정리: `rm -rf /tmp/agent-pulse-*`

## 라이선스

MIT
