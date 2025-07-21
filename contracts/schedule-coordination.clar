;; Schedule Coordination Contract
;; Handles morning and afternoon shift assignments

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-SCHEDULE-NOT-FOUND (err u201))
(define-constant ERR-INVALID-TIME (err u202))
(define-constant ERR-ALREADY-SCHEDULED (err u203))
(define-constant ERR-INVALID-INPUT (err u204))

;; Data Variables
(define-data-var next-schedule-id uint u1)

;; Data Maps
(define-map schedules
  { schedule-id: uint }
  {
    guard-id: uint,
    intersection-id: uint,
    shift-type: (string-ascii 10),
    start-time: uint,
    end-time: uint,
    date: uint,
    status: (string-ascii 20),
    created-by: principal
  }
)

(define-map daily-schedules
  { date: uint, intersection-id: uint, shift-type: (string-ascii 10) }
  { schedule-id: uint, guard-id: uint }
)

(define-map guard-availability
  { guard-id: uint, date: uint }
  {
    morning-available: bool,
    afternoon-available: bool,
    notes: (string-ascii 100)
  }
)

(define-map attendance-records
  { schedule-id: uint }
  {
    checked-in: bool,
    check-in-time: (optional uint),
    checked-out: bool,
    check-out-time: (optional uint),
    notes: (string-ascii 100)
  }
)

;; Public Functions

;; Create a new schedule
(define-public (create-schedule (guard-id uint) (intersection-id uint) (shift-type (string-ascii 10)) (start-time uint) (end-time uint) (date uint))
  (let
    (
      (schedule-id (var-get next-schedule-id))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (or (is-eq shift-type "morning") (is-eq shift-type "afternoon")) ERR-INVALID-INPUT)
    (asserts! (< start-time end-time) ERR-INVALID-TIME)
    (asserts! (>= date block-height) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? daily-schedules { date: date, intersection-id: intersection-id, shift-type: shift-type })) ERR-ALREADY-SCHEDULED)

    (map-set schedules
      { schedule-id: schedule-id }
      {
        guard-id: guard-id,
        intersection-id: intersection-id,
        shift-type: shift-type,
        start-time: start-time,
        end-time: end-time,
        date: date,
        status: "scheduled",
        created-by: tx-sender
      }
    )

    (map-set daily-schedules
      { date: date, intersection-id: intersection-id, shift-type: shift-type }
      { schedule-id: schedule-id, guard-id: guard-id }
    )

    (var-set next-schedule-id (+ schedule-id u1))
    (ok schedule-id)
  )
)

;; Set guard availability
(define-public (set-availability (guard-id uint) (date uint) (morning-available bool) (afternoon-available bool) (notes (string-ascii 100)))
  (begin
    (asserts! (>= date block-height) ERR-INVALID-INPUT)
    (asserts! (<= (len notes) u100) ERR-INVALID-INPUT)

    (map-set guard-availability
      { guard-id: guard-id, date: date }
      {
        morning-available: morning-available,
        afternoon-available: afternoon-available,
        notes: notes
      }
    )

    (ok true)
  )
)

;; Check in for shift
(define-public (check-in (schedule-id uint))
  (let
    (
      (schedule-data (unwrap! (map-get? schedules { schedule-id: schedule-id }) ERR-SCHEDULE-NOT-FOUND))
      (current-attendance (default-to
        { checked-in: false, check-in-time: none, checked-out: false, check-out-time: none, notes: "" }
        (map-get? attendance-records { schedule-id: schedule-id })
      ))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (not (get checked-in current-attendance)) ERR-ALREADY-SCHEDULED)

    (map-set attendance-records
      { schedule-id: schedule-id }
      (merge current-attendance
        {
          checked-in: true,
          check-in-time: (some block-height)
        }
      )
    )

    (ok true)
  )
)

;; Check out from shift
(define-public (check-out (schedule-id uint) (notes (string-ascii 100)))
  (let
    (
      (schedule-data (unwrap! (map-get? schedules { schedule-id: schedule-id }) ERR-SCHEDULE-NOT-FOUND))
      (current-attendance (unwrap! (map-get? attendance-records { schedule-id: schedule-id }) ERR-SCHEDULE-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (get checked-in current-attendance) ERR-INVALID-INPUT)
    (asserts! (not (get checked-out current-attendance)) ERR-ALREADY-SCHEDULED)
    (asserts! (<= (len notes) u100) ERR-INVALID-INPUT)

    (map-set attendance-records
      { schedule-id: schedule-id }
      (merge current-attendance
        {
          checked-out: true,
          check-out-time: (some block-height),
          notes: notes
        }
      )
    )

    (ok true)
  )
)

;; Update schedule status
(define-public (update-schedule-status (schedule-id uint) (new-status (string-ascii 20)))
  (let
    (
      (schedule-data (unwrap! (map-get? schedules { schedule-id: schedule-id }) ERR-SCHEDULE-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (> (len new-status) u0) ERR-INVALID-INPUT)

    (map-set schedules
      { schedule-id: schedule-id }
      (merge schedule-data { status: new-status })
    )

    (ok true)
  )
)

;; Cancel schedule
(define-public (cancel-schedule (schedule-id uint))
  (let
    (
      (schedule-data (unwrap! (map-get? schedules { schedule-id: schedule-id }) ERR-SCHEDULE-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set schedules
      { schedule-id: schedule-id }
      (merge schedule-data { status: "cancelled" })
    )

    (map-delete daily-schedules
      {
        date: (get date schedule-data),
        intersection-id: (get intersection-id schedule-data),
        shift-type: (get shift-type schedule-data)
      }
    )

    (ok true)
  )
)

;; Read-only Functions

(define-read-only (get-schedule (schedule-id uint))
  (map-get? schedules { schedule-id: schedule-id })
)

(define-read-only (get-daily-schedule (date uint) (intersection-id uint) (shift-type (string-ascii 10)))
  (map-get? daily-schedules { date: date, intersection-id: intersection-id, shift-type: shift-type })
)

(define-read-only (get-guard-availability (guard-id uint) (date uint))
  (map-get? guard-availability { guard-id: guard-id, date: date })
)

(define-read-only (get-attendance-record (schedule-id uint))
  (map-get? attendance-records { schedule-id: schedule-id })
)

(define-read-only (get-next-schedule-id)
  (var-get next-schedule-id)
)
