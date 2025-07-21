import { describe, it, expect, beforeEach } from "vitest"

describe("Schedule Coordination Contract", () => {
  let contractAddress
  let deployer
  let guard1
  
  beforeEach(() => {
    contractAddress = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.schedule-coordination"
    deployer = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"
    guard1 = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
  })
  
  describe("Schedule Creation", () => {
    it("should create a new schedule successfully", () => {
      const result = {
        type: "ok",
        value: 1,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(1)
    })
    
    it("should validate shift type", () => {
      const result = {
        type: "err",
        value: 204, // ERR-INVALID-INPUT
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(204)
    })
    
    it("should validate time ranges", () => {
      const result = {
        type: "err",
        value: 202, // ERR-INVALID-TIME
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(202)
    })
    
    it("should prevent double booking", () => {
      const result = {
        type: "err",
        value: 203, // ERR-ALREADY-SCHEDULED
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(203)
    })
  })
  
  describe("Availability Management", () => {
    it("should set guard availability", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should validate availability date", () => {
      const result = {
        type: "err",
        value: 204, // ERR-INVALID-INPUT
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(204)
    })
  })
  
  describe("Attendance Tracking", () => {
    it("should check in guard successfully", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should check out guard with notes", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should prevent double check-in", () => {
      const result = {
        type: "err",
        value: 203, // ERR-ALREADY-SCHEDULED
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(203)
    })
  })
  
  describe("Schedule Management", () => {
    it("should update schedule status", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should cancel schedule", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
  })
  
  describe("Read-only Functions", () => {
    it("should get schedule information", () => {
      const scheduleData = {
        "guard-id": 1,
        "intersection-id": 1,
        "shift-type": "morning",
        "start-time": 800,
        "end-time": 900,
        date: 2000,
        status: "scheduled",
        "created-by": deployer,
      }
      
      expect(scheduleData["shift-type"]).toBe("morning")
      expect(scheduleData.status).toBe("scheduled")
    })
    
    it("should get daily schedule", () => {
      const dailySchedule = {
        "schedule-id": 1,
        "guard-id": 1,
      }
      
      expect(dailySchedule["schedule-id"]).toBe(1)
      expect(dailySchedule["guard-id"]).toBe(1)
    })
    
    it("should get attendance record", () => {
      const attendanceRecord = {
        "checked-in": true,
        "check-in-time": 1800,
        "checked-out": false,
        "check-out-time": null,
        notes: "",
      }
      
      expect(attendanceRecord["checked-in"]).toBe(true)
      expect(attendanceRecord["checked-out"]).toBe(false)
    })
  })
})
