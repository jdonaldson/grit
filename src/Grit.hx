import sys.io.Process;
using StringTools;
import sys.FileSystem;
import sys.io.File;

class Grit {

    static function shell(cmd : String) : String {
        var p = new Process(cmd);
        var exit = p.exitCode(true);
        if (exit != 0){
            throw (new ProcessFail(exit, p));
        }
        return p.stdout.readAll().toString().trim();
    }


    static function git(cmdstr : String) : String {
        var p = new Process('git $cmdstr');
        var exit = p.exitCode(true);
        if (exit != 0){
            throw (new ProcessFail(exit,p));
        }
        return p.stdout.readAll().toString();
    }

    static function succeed(cmd : String) : Bool {
        try {
            shell(cmd);
            return true;
        } catch (p : ProcessFail){
            return false;
        }
    }

    public static function commit() : String {
        var prevbranch = curbranch();
        var branchname = 'grit-prev-$prevbranch';

        var verify_code = -1;
        var check_code = function(code){
            verify_code = code;
            return '';
        }

        var exists = succeed(git('git rev-parse --verify $branchname '));
        var mode = exists ? "-b" : "";
        git('checkout $mode $branchname');

        git("add .");
        git('commit -m "checkpoint from $prevbranch" --quiet');
        var newhash = curhash();
        git('git reset --hard $prevbranch');
        git('git checkout $prevbranch');
        return newhash;
    }

    public static function curhash() : String {
        return git("rev-parse HEAD").substr(0,8);
    }

    public static function curbranch() : String {
        return shell('git rev-parse --abbrev-ref HEAD --');
    }



    public static function isDirty() : Bool {
        var message = "nothing to commit, working tree clean";
        var status = git('status');
        var index = status.lastIndexOf(message);
        return index != -1;
    }

    public static function max(metric : String) : GritStamp {
        var arr = toArr();
        var max = Math.NEGATIVE_INFINITY;
        var grit = arr[0];
        for (stamp in arr){
            if (stamp.value > max){
                grit = stamp;
            }
        }
        return grit;
    }
    public static function toArr() : Array<GritStamp>{
        var f = File.getContent(".grit.csv");
        var lines = f.split("\n");
        return [for (l in lines) {
            var parts = l.split(", ");
            {hash:parts[0], metric:parts[1], value:Std.parseFloat(parts[2])}
        }];
    }

    public static function log(metric : String, value : Float){

        var hash = isDirty()? commit() : curhash();

        var payload = {hash : hash, metric : metric, value : value};
        var payload_str = haxe.Json.stringify(payload);

        var logfilePath = ".grit.csv";
        var logstr =  '$hash, $metric, $value';

        if (!FileSystem.exists(".grit.csv")){
            File.saveContent(".grit.csv",logstr + "\n");
            File.append(".gitignore").writeString("\n.grit.csv\n");
        } else {
            var result = "";
            if (!succeed('grep -Fxq "$logstr" .grit.csv')){
                File.append(".grit.csv").writeString(logstr + "\n");
            }

        }


    }

}

class ProcessFail {
    public var code (default, null) : Int;
    public var process (default, null) : Process;
    public function new(code : Int, process : Process){
        this.code = code;
        this.process = process;

    }
}

typedef GritStamp = {
    metric : String,
    hash : String,
    value : Float
}

