      ! return 1 if string1 is an anagram of string2. 0 otherwise
      FUNCTION CHECK_ANAGRAM(string1, string2) RESULT(res)
          CHARACTER(LEN = 20), INTENT(in) :: string1, string2
          REAL :: res
          INTEGER, DIMENSION(26) :: characters1, characters2
          INTEGER :: shortest_length

          res = 0
          IF (LEN_TRIM(string1) /= LEN_TRIM(string2)) RETURN
          
          DO i = 1, 26
              characters1(i) = 0
              characters2(i) = 0
          END DO

          ! iterate over string, counting characters
          DO i = 1, LEN_TRIM(string1)
              characters1(IACHAR(string1(i : i)) - 96) =
     &            characters1(IACHAR(string1(i : i)) - 96) + 1
              characters2(IACHAR(string2(i : i)) - 96) =
     &            characters2(IACHAR(string2(i : i)) - 96) + 1
          END DO

          ! check occurance of each character
          DO i = 1, 26
              IF (characters1(i) /= characters2(i)) RETURN
          END DO

          res = 1
      END FUNCTION CHECK_ANAGRAM

      ! return 1 if word occur more than once. return 0 otherwise
      FUNCTION CHECK_PASSPHRASE(string_array) RESULT(res)
          CHARACTER(LEN = 20), DIMENSION(20), INTENT(in) :: string_array
          REAL :: res
          res = 0
          DO i = 1, 20
              IF (LEN_TRIM(string_array(i)) == 0) RETURN
              DO j = i + 1, 20
                  IF (LEN_TRIM(string_array(j)) == 0) GO TO 5
                  IF (CHECK_ANAGRAM(string_array(i), string_array(j)) ==
     &                1) THEN
                  ! Part 1:
                  ! IF (string_array(i) == string_array(j)) THEN
                      res = 1
                      RETURN
                  END IF
              END DO
    5         CONTINUE
          END DO
      END FUNCTION CHECK_PASSPHRASE

      PROGRAM DAY4
          CHARACTER(LEN = 256) :: file_name
          INTEGER, PARAMETER :: read_unit = 99
          CHARACTER(LEN = 500) :: line
          CHARACTER(LEN = 20), DIMENSION(20) :: current_line_strings
          CHARACTER(LEN = 10) :: temp
          INTEGER :: ios, array_index = 1, string_index = 1,
     &        invalid_line_counter = 0, line_counter = 0

          ! get command line arguments and check if file name is valid
          CALL GET_COMMAND_ARGUMENT(1, file_name)
          IF (LEN_TRIM(file_name) == 0) ERROR STOP "Invalid Argument!"
          OPEN(UNIT = read_unit, FILE = file_name, STATUS = "old",
     &        ACTION = "read", IOSTAT = ios)
          IF (ios /= 0) ERROR STOP "Error opening " // file_name

          ! read file, split line and store words in array
          DO
              DO i = 1, 20
                  current_line_strings(i) = ""
              END DO
              READ(UNIT = read_unit, FMT = '(a)', END = 30) line
              DO i = 1, LEN_TRIM(line)
                  IF (line(i : i) == " ") THEN
                      string_index = 1
                      GO TO 10
                  END IF
                  current_line_strings(array_index)
     &                (string_index : string_index) = line(i : i)
                  string_index = string_index + 1
                  GO TO 20
   10             array_index = array_index + 1
   20             CONTINUE
              END DO
              invalid_line_counter = invalid_line_counter +
     &            CHECK_PASSPHRASE(current_line_strings)
              array_index = 1
              string_index = 1
              line_counter = line_counter + 1
          END DO
          ! print the result
   30     WRITE(temp, '(I3)') line_counter - invalid_line_counter
          PRINT *, "Number of valid lines: " // trim(temp)
      END PROGRAM DAY4
