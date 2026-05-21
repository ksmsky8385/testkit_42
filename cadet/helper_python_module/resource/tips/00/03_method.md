# 파이썬 메서드 및 중첩 메서드(Nested Method)

파이썬에서 메서드(함수)는 **일급 객체(First-Class Object)**로 취급되므로, 다른 객체와 동일하게 다루어지며 함수 내부에서 또 다른 함수를 정의할 수 있습니다.

## 1. 기본 함수 정의 (`def`)

``` python
def 함수이름(매개변수):
    # 실행할 코드
    return 반환값
```

return문이 없으면 기본적으로 None을 반환합니다.

## 2. 중첩 함수 (함수 내부의 함수)

``` python
def outer_func(x):
    def inner_func(y):
        return y * 2
    
    return inner_func(x) + 1
```

inner_func는 outer_func 내부에서만 존재하고 호출할 수 있습니다. (외부 노출 제한)

클로저(Closure): 내부 함수는 외부 함수의 변수(위 예시의 x)에 접근할 수 있습니다.

## 3. 함수의 인자 및 리턴 타입 힌트 (Type Annotations)

`mypy`는 함수의 입력(매개변수)과 출력(리턴) 타입을 정적 분석하여 타입 불일치를 감지합니다.

### 기본 문법
``` python
def greet(name: str, age: int) -> str:
    return f"Hello {name}, you are {age} years old."
```