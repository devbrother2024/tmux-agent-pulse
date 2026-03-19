# tmux-claude-notify

[English](README.md) | **한국어**

tmux에서 Claude Code 응답 상태를 알려주는 플러그인입니다. Claude Code 설정 변경 없이 사용할 수 있습니다.

백그라운드 윈도우에서 Claude Code가 동작 중일 때 윈도우 이름에 상태 아이콘을 표시합니다:

- **💬** — Claude가 응답 중 (2.5초 이상 출력 감지)
- **✅** — Claude 응답 완료 (출력 중단)
- 해당 윈도우로 전환하면 아이콘 자동 제거

## 동작 방식

백그라운드 데몬이 0.5초마다 모든 tmux pane을 폴링합니다. 프로세스 이름의 버전 패턴(예: `2.1.78`)으로 Claude Code pane을 식별하고, 출력 스냅샷을 비교하여 활동 변화를 감지합니다. Claude Code 훅이나 별도 설정이 필요 없습니다.

## 설치

### 요구사항

- tmux 3.0+
- [TPM](https://github.com/tmux-plugins/tpm)

> **참고:** 플러그인 로드 시 tmux 상태바를 자동으로 활성화합니다 (`set -g status on`). 윈도우 이름에 아이콘을 표시하기 위해 필요합니다.

### TPM으로 설치

`~/.tmux.conf`에 추가:

```bash
set -g @plugin 'devbrother2024/tmux-claude-notify'
```

> **중요:** 이 줄은 반드시 `run '~/.tmux/plugins/tpm/tpm'` **앞에** 위치해야 합니다. TPM은 실행 시점 이전에 선언된 플러그인만 인식합니다.

`prefix + I`를 눌러 설치합니다.

### 수동 설치

```bash
git clone https://github.com/devbrother2024/tmux-claude-notify ~/.tmux/plugins/tmux-claude-notify
```

`~/.tmux.conf`에 추가:

```bash
run-shell ~/.tmux/plugins/tmux-claude-notify/claude-notify.tmux
```

## 설정

플러그인 로드 전에 설정할 수 있는 환경변수입니다 (모두 선택사항):

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `CLAUDE_NOTIFY_INTERVAL` | `0.5` | 폴링 간격 (초) |
| `CLAUDE_NOTIFY_THRESHOLD` | `5` | 응답 중 판정에 필요한 연속 변경 횟수 |
| `CLAUDE_NOTIFY_DONE_THRESHOLD` | `3` | 완료 판정에 필요한 연속 미변경 횟수 |
| `CLAUDE_NOTIFY_ICON_RESPONDING` | `💬` | 응답 중 아이콘 |
| `CLAUDE_NOTIFY_ICON_DONE` | `✅` | 완료 아이콘 |

`~/.tmux.conf` 설정 예시:

```bash
set-environment -g CLAUDE_NOTIFY_THRESHOLD 3
set-environment -g CLAUDE_NOTIFY_ICON_DONE "⏎"
```

## 제거

1. `~/.tmux.conf`에서 플러그인 줄 삭제
2. `prefix + alt + u` (TPM 제거)
3. 임시 파일 정리: `rm -rf /tmp/claude-tmux-*`

## 라이선스

MIT
