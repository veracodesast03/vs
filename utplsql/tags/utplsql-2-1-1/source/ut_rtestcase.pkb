/* Formatted on 2001/07/13 12:29 (RevealNet Formatter v4.4.1) */
CREATE OR REPLACE PACKAGE BODY utrtestcase
IS
   PROCEDURE initiate (
      run_id_in        IN   utr_testcase.run_id%TYPE,
      testcase_id_in   IN   utr_testcase.testcase_id%TYPE,
      start_on_in      IN   DATE := SYSDATE
   )
   IS
      &start81 
      PRAGMA autonomous_transaction;
   &end81
   BEGIN
      INSERT INTO utr_testcase
                  (run_id, testcase_id, start_on)
           VALUES (run_id_in, testcase_id_in, start_on_in);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         -- Run has already been initiated. Ignore...
         NULL;
         &start81 
         ROLLBACK;
      &end81
      WHEN OTHERS
      THEN
         &start81 
         ROLLBACK;
         &end81
         utrerror.tc_report (
            run_id_in,
            testcase_id_in,
            SQLCODE,
            SQLERRM,
               'Unable to initiate testcase for run '
            || run_id_in
            || ' testcase ID '
            || testcase_id_in
         );
   END initiate;

   PROCEDURE terminate (
      run_id_in        IN   utr_testcase.run_id%TYPE,
      testcase_id_in   IN   utr_testcase.testcase_id%TYPE,
      end_on_in        IN   DATE := SYSDATE
   )
   IS
      &start81 
      PRAGMA autonomous_transaction;

      &end81
      CURSOR start_cur
      IS
         SELECT start_on, end_on
           FROM utr_testcase
          WHERE run_id = run_id_in
            AND testcase_id_in = testcase_id;

      rec        start_cur%ROWTYPE;
      l_status   utr_testcase.status%TYPE;
   BEGIN
      l_status := utresult2.run_status (run_id_in);
      OPEN start_cur;
      FETCH start_cur INTO rec;

      IF      start_cur%FOUND
          AND rec.end_on IS NULL
      THEN
         UPDATE utr_testcase
            SET end_on = end_on_in,
                status = l_status
          WHERE run_id = run_id_in
            AND testcase_id_in = testcase_id;
      ELSIF      start_cur%FOUND
             AND rec.end_on IS NOT NULL
      THEN
         -- Run is already terminated. Ignore...
         NULL;
      ELSE
         INSERT INTO utr_testcase
                     (run_id, testcase_id, status, end_on)
              VALUES (run_id_in, testcase_id_in, l_status, end_on_in);
      END IF;

      CLOSE start_cur;
      CLOSE start_cur;
      &start81 
      COMMIT;
   &end81
   EXCEPTION
      WHEN OTHERS
      THEN
         &start81 
         ROLLBACK;
         &end81
         utrerror.oc_report (
            run_id_in,
            testcase_id_in,
            SQLCODE,
            SQLERRM,
               'Unable to insert or update the utr_testcase table for run '
            || run_id_in
            || ' testcase ID '
            || testcase_id_in
         );
   END terminate;
END utrtestcase;
/
