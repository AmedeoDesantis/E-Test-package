#!/bin/bash

# Usage: bash describe_gh_stats.sh [project_root]
DIR=${1:-.}

# Total lines of code in all .java files
LOC=$(find "$DIR" -name '*.java' -print0 \
      | xargs -0 cat 2>/dev/null \
      | wc -l)

# Number of class files (.java)
CLASS_FILES=$(find "$DIR" -name '*.java' | wc -l)

# Number of test suites (*Test.java or *Tests.java)
TEST_SUITE_FILES=$(find "$DIR" -type f \( -name '*Test.java' -o -name '*Tests.java' \))
TEST_SUITES=$(echo "$TEST_SUITE_FILES" | wc -l)

# Total number of test cases (@Test annotations in test suites)
TEST_CASES=$(find "$DIR" -type f \( -name '*Test.java' -o -name '*Tests.java' \) -print0 \
  | xargs -0 grep -h -E '@Test\b' 2>/dev/null | wc -l)

# Average test cases per test suite
if [ "$TEST_SUITES" -gt 0 ]; then
  AVG_TEST_CASES=$(awk "BEGIN { printf \"%.2f\", $TEST_CASES / $TEST_SUITES }")
else
  AVG_TEST_CASES="0.00"
fi

# Average lines of code per test suite
TS_LINES=$(cat $TEST_SUITE_FILES 2>/dev/null | wc -l)
if [ "$TEST_SUITES" -gt 0 ]; then
  AVG_LINES_PER_SUITE=$(awk "BEGIN { printf \"%.2f\", $TS_LINES / $TEST_SUITES }")
else
  AVG_LINES_PER_SUITE="0.00"
fi

# Output
printf "Total lines of code:          %10d\n" "$LOC"
printf "Number of classes:            %10d\n" "$CLASS_FILES"
printf "Number of test suites:        %10d\n" "$TEST_SUITES"
printf "Total number of test cases:   %10d\n" "$TEST_CASES"
printf "Average test cases per suite: %10s\n" "$AVG_TEST_CASES"
printf "Average LOC per test suite:   %10s\n" "$AVG_LINES_PER_SUITE"

