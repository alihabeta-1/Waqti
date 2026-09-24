enum BookingFailureReason {
  startTimeNotFound,
  bookedSlot,
  unavailableSlot,
  notEnoughConsecutiveSlots,
  exceedsWorkingHours,
  createsInvalidGap,
}
