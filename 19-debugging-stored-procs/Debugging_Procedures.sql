-- Find given number is Even or Odd

SET N=1237;

EXECUTE IMMEDIATE 
$$
BEGIN
    IF($N % 2 = 0) THEN
        RETURN 'Given number is Even Number';
    ELSE
        RETURN 'Given Number is ODD Number';
END;
$$
;

--------------------------

-- Find prime numbers upto given number
CREATE OR REPLACE PROCEDURE EMP.PROCS.SP_WHILE_PRIME_NUMBERS("N" INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
	i INTEGER default 3;
    j INTEGER;
    flag INTEGER;
    prime VARCHAR default '2 ';
BEGIN
    WHILE (i <= N) 
    DO
        flag := 0;
        FOR j IN 2 TO i-1 
        DO
            IF (i % j = 0) THEN
                flag := 1;
                --break;
            END IF;            
        END FOR;
        IF (flag = 0) THEN
            prime := prime || ', ' || i;
        END IF;
    i =: i+1;
    END WHILE;  

RETURN prime;                
END;

CALL EMP.PROCS.SP_WHILE_PRIME_NUMBERS(100);

-------------------
If you are not able to find the error follow below steps
1. Verify if ; is missing anywhere (or) all ; are placed correctly
2. Verify all variable assignments and expressions
3. Verify all IFs and Loops ended properly or not
4. Verify all variables have : infront of variable name if you are using them in SQL statement
5. Verify line by line code