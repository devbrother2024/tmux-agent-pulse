## 권한 요청 대기 상태(waiting) 감지 및 표시

### 핵심 변경 사항
- 새로운 상태 `waiting` 추가 (기본 아이콘: ❓)
- `responding` 상태에서 출력이 멈춘 후, pane 마지막 10줄에서 권한 요청 패턴(`Do you want to allow`) 감지
- 패턴 매칭 시 `done`(✅) 대신 `waiting`(❓) 상태로 전환
- `AGENT_PULSE_ICON_WAITING`, `AGENT_PULSE_WAITING_PATTERN` 환경변수로 커스터마이징 지원

### 설계 결정
- 감지 범위를 pane 마지막 10줄(`-S -10`)로 설정: 권한 프롬프트가 화면 하단에 표시되므로 충분하며, 성능 영향 최소화
- `waiting` 상태에서도 출력 변경 감지 시 `responding`로 복귀 (사용자가 승인하면 다시 작업 진행)
- `waiting` → `idle` 전환도 `done`과 동일하게 사용자가 윈도우를 보면 초기화

## TODO
### 검증
- [ ] 실제 Claude Code 권한 요청 시 ❓ 아이콘 표시 확인
- [ ] 권한 승인 후 💬로 복귀 확인
- [ ] 데모 GIF 업데이트
