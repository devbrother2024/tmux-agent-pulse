## 완료 아이콘 소멸 버그 수정

### 핵심 변경 사항
- `grep -qF` → `grep -qFx`로 변경하여 윈도우 번호 부분 매칭 버그 수정 (main:1이 main:10에 매칭되던 문제)
- done 상태의 visible 체크를 CLI 프로세스 체크 앞으로 이동하여, CLI 종료 후에도 done 아이콘 정리 가능
- sed 이모지 처리를 character class에서 alternation(`($ICON_DONE|$ICON_RESPONDING)`)으로 변경하여 multi-byte 이모지 안정화

### 설계 결정
- 루프 초반에 state 파일만 읽어서 done 상태를 먼저 확인하고, CLI 프로세스 체크는 그 이후에 수행
- done 상태 정리에 필요한 변수(WINDOW_NAME, CLEAN_NAME)는 해당 블록 내에서만 계산하여 불필요한 연산 방지

## TODO
### 검증
- [ ] tmux 윈도우 10개 이상 환경에서 부분 매칭 버그 재현 불가 확인
- [ ] CLI 종료 후 done 아이콘이 윈도우 전환 시 정리되는지 확인
