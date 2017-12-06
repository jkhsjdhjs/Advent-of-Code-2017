<?php
    if(count($argv) === 1)
        die("Invalid arguments!");
    $filename = $argv[1];
    if(!file_exists($filename))
        die("Specified file is non-existant!");
    $contents = array_map(intval, file($filename));
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
