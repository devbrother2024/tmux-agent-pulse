## done 판정 threshold 적용 및 status bar 자동 활성화

### 핵심 변경 사항
- done 판정에 threshold 도입: 연속 N회(기본 3회, 1.5초) 출력 미변경 시에만 done(✅) 전환
  - 기존: 1회 미변경으로 즉시 done → Claude Code가 잠깐 멈추면 💬↔✅ 깜빡임 발생
  - 개선: 출력 재개 시 done 카운터 즉시 리셋 → 깜빡임 방지
- `CLAUDE_NOTIFY_DONE_THRESHOLD` 환경변수 추가 (기본값 3)
- 플러그인 로드 시 `tmux set -g status on` 자동 실행 (status bar 필수이므로)
- README (영문/한국어) 업데이트

### 설계 결정
- responding threshold(5)와 동일한 패턴으로 done threshold 구현하여 일관성 유지
- `status on`은 멱등이라 기존 유저 설정과 충돌 없음

## TODO
### 검증
- [ ] 데몬 재시작 후 깜빡임 감소 확인
- [ ] done threshold 값 튜닝 (3이 적절한지)
