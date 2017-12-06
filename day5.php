<?php
    if(count($argv) === 1)
        die("Invalid arguments!");
    if(!file_exists($argv[1]))
        die("Specified file is non-existant!");
    if(!($contents = array_map('intval', file($argv[1]))))
        die("File is empty!");
    $i = $steps = 0;
    do {
        $steps++;
        // Part 1
        // $contents[$i]++;
        $offset = $contents[$i] >= 3 ? -1 : 1;
        $contents[$i] += $offset;
        $i += $contents[$i] - $offset;
    } while($i < count($contents));
    echo "Escaped the maze after {$steps} Steps!";
?>
