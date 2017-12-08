import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

class Program {
    String name;
    int weight;
    int totalWeight;
    ArrayList<Program> disk = new ArrayList<Program>();
    public boolean insertProgram(Program program) {
        for(int i = 0; i < this.disk.size(); i++) {
            if(this.disk.get(i).name.equals(program.name)) {
                this.disk.get(i).weight = program.weight;
                for(Program diskprogram: program.disk)
                    this.disk.get(i).disk.add(diskprogram);
                return true;
            }
            if(this.disk.get(i).insertProgram(program))
                return true;
        }
        return false;
    }
    public void calcTotalWeight() {
        this.totalWeight = this.weight;
        for(Program p: this.disk) {
            p.calcTotalWeight();
            this.totalWeight += p.totalWeight;
        }
    }
    public int getWrongWeight() {
        if(this.disk.size() > 0) {
            Collections.sort(this.disk, new Comparator<Program>() {
                @Override
                public int compare(Program p1, Program p2) {
                    return p1.totalWeight > p2.totalWeight ? 1 : -1;
                }
            });
        }
        if(this.disk.size() > 2) {
            int result;
            if(this.disk.get(0).totalWeight != this.disk.get(1).totalWeight) {
                result = this.disk.get(0).getWrongWeight();
                if(result == -1)
                    return this.disk.get(1).totalWeight - this.disk.get(0).totalWeight + this.disk.get(0).weight;
            }
            else if(this.disk.get(this.disk.size() - 1).totalWeight != this.disk.get(this.disk.size() - 2).totalWeight) {
                result = this.disk.get(this.disk.size() - 1).getWrongWeight();
                if(result == -1)
                    return this.disk.get(this.disk.size() - 1).weight - (this.disk.get(this.disk.size() - 1).totalWeight - this.disk.get(this.disk.size() - 2).totalWeight);
            }
            else
                result = -1;
            return result;
        }
        else if(this.disk.size() > 0) {
            int first = this.disk.get(0).getWrongWeight();
            if(first == -1) {
                int second = this.disk.get(1).getWrongWeight();
                if(second == -1)
                    return this.disk.get(1).totalWeight - this.disk.get(0).totalWeight + this.disk.get(0).weight;
                return second;
            }
            return first;
        }
        return -1;
    }
}

final class ProgramTree {
    static Program start;

    public static void createTree(ArrayList<Program> programs) {
        int i = 0, j = 0, failedInsertions = 0;
        while(programs.size() > 1) {
            if(programs.get(i % programs.size()).insertProgram(programs.get(j % programs.size()))) {
                programs.remove(j % programs.size());
                j++;
            }
            else {
                i++;
                failedInsertions++;
                if(failedInsertions >= programs.size()) {
                    failedInsertions = 0;
                    j++;
                }
            }
        }
        start = programs.get(0);
    }
}

class day7 {
    private static Pattern parseRegex = Pattern.compile("(\\w+)\\s\\((\\d+)\\)(?:\\s->\\s(.*))?");

    private static Program parseLine(String line) {
        Matcher matcher = parseRegex.matcher(line);
        Program p = new Program();
        if(matcher.find()) {
            p.name = matcher.group(1);
            p.weight = Integer.parseInt(matcher.group(2));
            if(matcher.group(3) != null) {
                String disk[] = matcher.group(3).split(", ");
                for(String subprogram: disk) {
                    Program subp = new Program();
                    subp.name = subprogram;
                    p.disk.add(subp);
                }
            }
        }
        return p;
    }

    public static void main(String[] args) throws Exception {
        if(args.length < 1) {
            System.err.println("Invalid arguments!");
            System.exit(1);
        }
        File file = new File(args[0]);
        if(!file.exists() || file.isDirectory()) {
            System.err.println("File is non-existant!");
            System.exit(1);
        }
        Stream<String> lines = new BufferedReader(new InputStreamReader(new FileInputStream(file))).lines();
        ArrayList<Program> tempList = new ArrayList<Program>();
        lines.forEach(line -> tempList.add(parseLine(line)));
        System.out.println("Creating Program Tree...");
        ProgramTree.createTree(tempList);
        System.out.println("Program Tree created!");
        System.out.println("Bottom Program has the name " + ProgramTree.start.name + "!");
        ProgramTree.start.calcTotalWeight();
        System.out.println("Some program should have weight " + ProgramTree.start.getWrongWeight() + " instead!");
    }
}
