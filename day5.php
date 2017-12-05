<?php
    if(count($argv) == 1)
        exit("Invalid arguments!");
    $filename = $argv[1];
    if(!file_exists($filename))
        exit("Specified file is non-existant!");
    $contents = file($filename);
    $contents = array_map(function ($x) {
        return intval($x);
    }, $contents);
    $i = 0;
    $steps = 0;
    while($i < count($contents)) {
        $steps++;
        // Part 1
        // $contents[$i]++;
        $offset = $contents[$i] >= 3 ? -1 : 1;
        $contents[$i] += $offset;
        $i += $contents[$i] - $offset;
    }
    echo "Escaped the maze after " . $steps . " Steps!";
?>
