package com.fluxshare.transfer

import java.util.concurrent.ConcurrentHashMap

data class ReservationKey(
    val fileId: String,
    val receiverId: String,
    val chunkId: Int
)

class ChunkReservationManager {

    private val reservations = ConcurrentHashMap<ReservationKey, Long>()

    /**
     * Attempts to reserve a chunk for a given file and receiver.
     * Returns true if reserved successfully, or false if already reserved.
     */
    fun reserveChunk(fileId: String, receiverId: String, chunkId: Int): Boolean {
        val key = ReservationKey(fileId, receiverId, chunkId)
        val existingTime = reservations.putIfAbsent(key, System.currentTimeMillis())
        val acquired = existingTime == null
        if (acquired) {
            com.fluxshare.network.SafeLog.d(com.fluxshare.network.SafeLog.TRANSFER, "RESERVATION_ACQUIRED fileId=$fileId chunkId=$chunkId receiver=$receiverId")
        } else {
            com.fluxshare.network.SafeLog.w(com.fluxshare.network.SafeLog.TRANSFER, "RESERVATION_BLOCKED chunkId=$chunkId already reserved by receiver=$receiverId")
        }
        return acquired
    }

    /**
     * Releases reservation on completion or failure.
     */
    fun releaseReservation(fileId: String, receiverId: String, chunkId: Int) {
        val key = ReservationKey(fileId, receiverId, chunkId)
        val removed = reservations.remove(key)
        if (removed != null) {
            com.fluxshare.network.SafeLog.d(com.fluxshare.network.SafeLog.TRANSFER, "RESERVATION_RELEASED fileId=$fileId chunkId=$chunkId receiver=$receiverId")
        }
    }

    /**
     * Returns true if chunk is currently reserved.
     */
    fun isReserved(fileId: String, receiverId: String, chunkId: Int): Boolean {
        val key = ReservationKey(fileId, receiverId, chunkId)
        return reservations.containsKey(key)
    }

    /**
     * Returns the count of active reservations.
     */
    fun getActiveReservationCount(): Int = reservations.size

    /**
     * Clears all reservations.
     */
    fun clear() {
        reservations.clear()
    }
}
