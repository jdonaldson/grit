import sys.io.Process;
import com.hurlant.crypto.extra.UUID;
import com.hurlant.crypto.prng.Random;

class WhenDid {

    static function shell(cmd : String) : String {
        var args = ~/\s+/.split(cmd);
        var cmd = args.shift();
        var p = new Process(cmd, args);
        var exit = p.exitCode(true);
        if (exit != 0){
            throw ('Error : ' + p.stderr.readAll().toString());
        }
        return p.stdout.readAll().toString();
    }
    static function git(args : String){
        return shell('git $args --git-dir=.whendid');
    }

    public static function commit(branch : String){
        git("add .");
        git('commit -m $branch --quiet');
        git('checkout master --quiet');
        git('merge $branch --quiet');
        git('branch -d $branch --quiet');
    }
    static function checkStatus() {
        return false;
    }

    public static function log(metric : String, value : Float){
        var random = new Random();

        var branch = UUID.generateRandom(random).toString().substr(0,8);
        trace(branch + " is the value for branch");
        var fout = sys.io.File.append("whendid.log");

        if (!sys.FileSystem.isDirectory(".whendid")){
            init();
            var metric = haxe.Json.stringify({metric : metric, value : value});
            fout.writeString('$branch $metric\n');
            fout.close();
        } else if (!checkStatus()) {
            trace("HI");


        }



    }
    public static function init() {
        shell("echo '.whendid' >> .gitignore");
        shell("git init --separate-git-dir .whendid");
        git("add .");
        git("commit -m 'whendid-head'");
    }

}

