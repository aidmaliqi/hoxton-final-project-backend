/*
  Warnings:

  - You are about to drop the `Airport` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `airportId` on the `Flight` table. All the data in the column will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Airport";
PRAGMA foreign_keys=on;

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Flight" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "departure" TEXT NOT NULL,
    "destination" TEXT NOT NULL,
    "departure_time" DATETIME NOT NULL,
    "arrival_time" DATETIME NOT NULL,
    "price" INTEGER NOT NULL,
    "seats" INTEGER NOT NULL,
    "airline" TEXT NOT NULL,
    "aircraft_id" INTEGER NOT NULL,
    "class" TEXT NOT NULL
);
INSERT INTO "new_Flight" ("aircraft_id", "airline", "arrival_time", "class", "departure", "departure_time", "destination", "id", "price", "seats") SELECT "aircraft_id", "airline", "arrival_time", "class", "departure", "departure_time", "destination", "id", "price", "seats" FROM "Flight";
DROP TABLE "Flight";
ALTER TABLE "new_Flight" RENAME TO "Flight";
CREATE UNIQUE INDEX "Flight_airline_key" ON "Flight"("airline");
CREATE UNIQUE INDEX "Flight_aircraft_id_key" ON "Flight"("aircraft_id");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
