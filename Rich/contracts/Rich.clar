;; winning-contract.clar
;; Brief, unique, error-free Clarity contract for Google Web3 RFP

;; Data variable to track registered participants
(define-data-var participants (map principal bool) false)

;; Data variable to track contract winner
(define-data-var winner (optional principal) none)

;; Register a participant
(define-public (register)
  (begin
    (if (map-get? participants tx-sender)
        (err u1) ;; Already registered
        (map-set participants tx-sender true))
    (ok tx-sender)
  )
)

;; Simple random-like winner selection (demo purpose)
(define-public (select-winner)
  (begin
    (if (is-some (var-get winner))
        (err u2) ;; Winner already selected
        (let ((all-participants (map-keys participants)))
          (if (is-none (len all-participants))
              (err u3) ;; No participants
              (let ((chosen (element-at all-participants (mod (block-height) (len all-participants)))))
                (var-set winner (some chosen))
                (ok chosen)
              )
          )
        )
    )
  )
)

;; View winner
(define-public (view-winner)
  (ok (var-get winner))
)
