--Activity
CREATE OR REPLACE FUNCTION get_flight_duration(p_flight_id INT)
RETURNS INTERVAL AS $$
DECLARE
    v_duration INTERVAL;
BEGIN
    SELECT arrival_time - departure_time
    INTO v_duration
    FROM flights
    WHERE flight_id = p_flight_id;

    IF v_duration IS NULL THEN
        RAISE EXCEPTION 'Flight ID % is not found or has NULL timestamps on it', p_flight_id;
    END IF;

    RETURN v_duration;
END;
$$ LANGUAGE plpgsql;


--Activity 2
CREATE OR REPLACE FUNCTION get_price_category(p_flight_id INT)
RETURNS TEXT AS $$
DECLARE
    v_price NUMERIC(10,2);
BEGIN
    SELECT base_price
    INTO v_price
    FROM flights
    WHERE flight_id = p_flight_id;

    IF v_price IS NULL THEN
        RAISE EXCEPTION 'Flight ID % not found', p_flight_id;
    END IF;

    IF v_price < 300 THEN
        RETURN 'Budget';
    ELSIF v_price BETWEEN 300 AND 800 THEN
        RETURN 'Standard';
    ELSE
        RETURN 'Premium';
    END IF;
END;
$$ LANGUAGE plpgsql;

--Activity 3
CREATE OR REPLACE PROCEDURE book_flight(
    p_passenger_id INT,
    p_flight_id INT,
    p_seat_number VARCHAR
) AS $$
BEGIN
    INSERT INTO bookings (
        flight_id,
        passenger_id,
        booking_date,
        seat_number,
        status
    )
    VALUES (
        p_flight_id,
        p_passenger_id,
        CURRENT_DATE,
        p_seat_number,
        'Confirmed'
    );

    RAISE NOTICE 'Booking confirmed: passenger %, flight %, seat %',
        p_passenger_id, p_flight_id, p_seat_number;
END;
$$ LANGUAGE plpgsql;

--Activity 4
CREATE OR REPLACE PROCEDURE increase_prices_for_airline(
    p_airline_id INT,
    p_percentage_increase NUMERIC
) AS $$
DECLARE
    rec RECORD;
    v_multiplier NUMERIC;
BEGIN
    v_multiplier := 1 + (p_percentage_increase / 100);

    FOR rec IN
        SELECT flight_id, base_price
        FROM flights
        WHERE airline_id = p_airline_id
    LOOP
        UPDATE flights
        SET base_price = rec.base_price * v_multiplier
        WHERE flight_id = rec.flight_id;

        RAISE NOTICE 'Flight % updated: % → %',
            rec.flight_id,
            rec.base_price,
            rec.base_price * v_multiplier;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
