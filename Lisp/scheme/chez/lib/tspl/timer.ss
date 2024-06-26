(library (tspl timer)
  (export start-timer stop-timer decrement-timer)
  (import (rnrs))

  (define clock 0)
  (define handler #f)

  (define (start-timer ticks new-handler)
    (set! handler new-handler)
    (set! clock ticks))

  (define (stop-timer)
    (let ([time-left clock])
      (set! clock 0)
      time-left))

  (define (decrement-timer)
    (when (> clock 0)
      (set! clock (- clock 1))
      (when (= clock 0) (handler))))
)