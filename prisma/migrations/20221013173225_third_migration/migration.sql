/*
  Warnings:

  - A unique constraint covering the columns `[ticketId]` on the table `Passanger` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Passanger_ticketId_key" ON "Passanger"("ticketId");
