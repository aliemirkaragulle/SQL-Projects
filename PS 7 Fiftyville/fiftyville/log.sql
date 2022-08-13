-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Address of the Theft: Humphrey Street
-- Date of the Theft: 28/07/2021

-- Check the crime_scene_reports table to get additional information about the theft.
-- From the table, we retrieve that;
    -- id: 295
    -- Time of the Theft: 10:15
    -- Location of the Theft: Bakery.
    -- Number of Witnesses: 3.
    -- Interviews were conducted today with three witnesses who were present at the time and each of their interview transcripts mentions the bakery.

SELECT id, description
FROM crime_scene_reports
WHERE year = 2021 AND month = 7 AND day = 28 AND street = "Humphrey Street";

-- Now, we'll examine the interviews table, looking for the "bakery" word.
-- From the result, we understand that the interviewees are Ruth (id: 161), Eugene (id: 162) and Raymond (id: 163).
-- From their interviews, we understand that:

-- Ruth:
-- Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
-- If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.

-- Eugene:
-- Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.

-- Raymond:
-- As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.

SELECT *
FROM interviews
WHERE transcript LIKE "%bakery%" AND year = 2021 AND month = 7 AND day = 28;

-- Ruth
-- bakery_security_logs
SELECT id, license_plate
FROM bakery_security_logs
WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit";

-- Eugene
-- atm_transactions
SELECT id, account_number, amount
FROM atm_transactions
WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = "Leggett Street" AND transaction_type = "withdraw";

-- Raymond
-- As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
-- phone_calls
SELECT id, caller, receiver
FROM phone_calls
WHERE  year = 2021 AND month = 7 AND day = 28 AND duration < 60;

-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
--  The thief then asked the person on the other end of the phone to purchase the flight ticket.

-- flights (Id: 36, Time: 8:20, Origin Airport Id: 8, Destination Airport Id: 4)
SELECT id, origin_airport_id, destination_airport_id, hour, minute
FROM flights
WHERE year = 2021 AND month = 7 AND day = 29;

-- passengers
SELECT passport_number, seat, origin_airport_id, destination_airport_id
FROM passengers
JOIN flights
ON passengers.flight_id = flights.id
WHERE passengers.flight_id = 36;

-- airports
-- The city the thief escaped to: New York City
SELECT city
FROM airports
WHERE id = 4;

-- passengers
SELECT passengers.passport_number, passengers.seat
FROM passengers
JOIN flights
ON flights.id = passengers.flight_id
WHERE flights.id = 36;


-- people
-- Compare the passport_number from the passengers table with the people table.
SELECT *
FROM people
WHERE passport_number IN (SELECT passengers.passport_number FROM passengers JOIN flights ON flights.id = passengers.flight_id WHERE flights.id = 36);

-- Compare the phone_number from the phone_calls table with the people table.
SELECT *
FROM people
WHERE phone_number IN (SELECT caller FROM phone_calls WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60)
UNION
SELECT *
FROM people
WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60);


SELECT *
FROM people
WHERE passport_number IN (SELECT passengers.passport_number FROM passengers JOIN flights ON flights.id = passengers.flight_id WHERE flights.id = 36)
    AND (phone_number IN (SELECT caller FROM phone_calls WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60)
        OR phone_number IN (SELECT receiver FROM phone_calls WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60))
    AND license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit");

-- The thief is: Bruce
SELECT *
FROM people
JOIN bank_accounts
ON people.id = bank_accounts.person_id
WHERE passport_number IN (SELECT passengers.passport_number FROM passengers JOIN flights ON flights.id = passengers.flight_id WHERE flights.id = 36)
    AND (phone_number IN (SELECT caller FROM phone_calls WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60)
        OR phone_number IN (SELECT receiver FROM phone_calls WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60))
    AND license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute < 25 AND activity = "exit");

-- The accomplice is: Robin
SELECT id, caller, receiver
FROM phone_calls
WHERE  year = 2021 AND month = 7 AND day = 28 AND duration < 60 AND (caller = "(367) 555-5533" OR receiver = "(367) 555-5533");

SELECT *
FROM people
WHERE phone_number = "(375) 555-8161";