# Growing Code - Python Fundamentals Through Garden Data

## 0. 개요

### 인터프리터 언어, 파이썬(Python)
파이썬은 코드를 한 줄씩 읽어가며 즉시 실행하는 인터프리터(Interpreter) 방식의 언어입니다. 컴파일 과정 없이 결과를 바로 확인할 수 있어 직관적이며, 초보자가 데이터 분석이나 자동화 스크립트를 배우기에 가장 이상적인 언어입니다.

### 이번 모듈의 핵심 도메인 기술
가상의 커뮤니티 정원 데이터를 활용해 파이썬의 기초 뼈대를 다집니다.
* **기본 입출력 (`print`, `input`):** 입력받고 안내 메시지를 출력하는 기본 소통.
* **형변환 (`int`):** 텍스트 입력을 숫자로 바꿔 면적이나 수확량을 계산.
* **조건문 (`if-else`):** 식물 나이나 급수 상태를 판단해 수확 및 관리 알림.
* **반복문과 재귀 (`for`, `recursion`):** 정해진 날짜만큼 수확일을 카운트하는 효율적인 명령.

### Flake8과 Mypy를 사용하는 이유
C언어 과제의 `Norminette` 검사와 유사한, 단순 기능 구현을 넘어 '좋은 코드'를 작성하기 위한 작업입니다.

1. **Flake8 (스타일 린터)**
   * 파이썬 표준 코드 스타일 가이드(PEP 8)를 준수하는지 검사합니다.
   * 들여쓰기, 공백, 줄 바꿈 등 가독성을 일관되게 유지하여 협업 시 동료가 읽기 편한 코드를 만드는 습관을 기릅니다.

2. **Mypy (정적 타입 검사기)**
   * 파이썬은 실행 중에 타입이 결정되는 동적 타이핑 언어라 예기치 못한 타입 에러가 발생할 수 있습니다.
   * Mypy는 실제 코드를 실행하기 전에 타입 힌트 오류를 미리 찾아내 주는 도구로, 대규모 프로젝트에서 버그를 예방하는 강력한 역할을 합니다.
   * 강력한 검사를 위해 `--strict` 플래그를 넣어 검사를 권장합니다. 본 helper 스크립트는 항상 `mypy --strick` 로 실행됩니다.

## 1. main.py 수정

과제에서 제공해주는 **main.py** 파일은 모든 과제 파일이 동일 경로에 있을 경우에만 작동합니다. helper에서는 제출양식에 맞춰 각 ex폴더 내부에 .py 파일이 위치해 있어도 작동이 되도록 수정작업이 거친 파일을 사용합니다.

``` python
def test_ft_exercise(exercise_file_name):
    """
    This function tries to run one of your exercises.

    For example: test_ft_exercise("ft_plot_area") will:
    - Look for a file called ft_plot_area.py
    - Import it
    - Call the function ft_plot_area() inside it
    """
    print(f"\n=== Testing {exercise_file_name} ===")

    try:
        # Import your exercise file
        # This is like doing: import ft_plot_area
        import sys

        # 폴더경로 지정 및 임포트 시 폴더경로 맞춰 임포트
        import os
        mapping = {
                    "ft_hello_garden": "ex0",
                    "ft_garden_name": "ex1",
                    "ft_plot_area": "ex2",
                    "ft_harvest_total": "ex3",
                    "ft_plant_age": "ex4",
                    "ft_water_reminder": "ex5",
                    "ft_count_harvest_iterative": "ex6",
                    "ft_count_harvest_recursive": "ex6",
                    "ft_seed_inventory": "ex7"
                }
        folder_name = mapping.get(exercise_file_name, ".")
        current_dir = os.getcwd()
        target_path = os.path.join(current_dir, folder_name)
        if target_path not in sys.path:
            sys.path.append(target_path)

        # sys.path.append(".") <- 주석처리
        ....
```

## 2. shebang

파일 상단에 `#!/usr/bin/env python3` 를 넣어 이 파일을 어떤 프로그램으로 실행할지 운영체제에 알려줄 수 있습니다. 쉘스크립트 작성 시 상단에 넣는 `#!/bin/"쉘 이름"`또한 shebang의 일종 입니다.

현재 main.py는 윈도우(Windows) OS 환경에서 작성되었는지, `/usr/bin/env: ‘python3\r’: No such file or directory` 라는 문구가 출력됩니다.

아래 명령어로 모든 줄의 끝에서 \r을 지워주는 작업이 필요합니다
.
``` shell
sed -i 's/\r$//' main.py
chmod +x main.py
./main.py
```

- sed        텍스트를 찾아서 바꾸는 명령어
- -i         파일을 직접 수정(in-place)
- 's/.../.../'  치환(substitute)
- \r         캐리지 리턴 문자, Windows 줄바꿈의 일부
- $          줄 끝
- //         빈 문자열로 바꿈, 즉 삭제
- main.py    수정할 파일
