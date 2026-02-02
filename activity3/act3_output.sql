--TASK 1
CREATE OR REPLACE FUNCTION log_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    --INSERT OPERATION
    IF TG_OP = 'INSERT' THEN
        INSERT INTO products_audit (product_id,change_type,new_name,new_price)
        VALUES (NEW.product_id,'INSERT',NEW.name,NEW.price);
        RETURN NEW;
    -- DELETE OPERATION    
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO products_audit (product_id,change_type,old_name,old_price)
        VALUES (OLD.product_id,'DELETE',OLD.name,OLD.price);
        RETURN OLD;
    --UPDATE OPERATION    
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.name IS DISTINCT FROM OLD.name
           OR NEW.price IS DISTINCT FROM OLD.price THEN
            INSERT INTO products_audit ( product_id,change_type,old_name,new_name,old_price,new_price)
            VALUES (OLD.product_id,'UPDATE',OLD.name,NEW.name, OLD.price,NEW.price );
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--TASK 2
--TRIGGER DEFINITION
CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_changes();

--BONUS CHALLENGE
--TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION set_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpqsql;

--TRIGGER DEFINITION
CREATE TRIGGER trigger_set_last_mofidied
BEFORE UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION set_last_modified();

--TEST THE TRIGGER
UPDATE PRODUCTS
SET price = price + 7
WHERE name = 'Basic Gizmo';

--TO VERIFY THE RESULT
SELECT product_id, name, last_modified
FROM products
WHERE name = 'Basic Gizmo';
