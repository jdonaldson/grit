import sys.io.Process;
import com.hurlant.crypto.prng.Random;

class Grit {

    static function git(cmd : String) : String {
        var args = ~/\s+/.split(cmd);
        var cmd = args.shift();
        var p = new Process('git $cmd', args);
        var exit = p.exitCode(true);
        if (exit != 0){
            throw ('Error : ' + p.stderr.readAll().toString());
        }
        return p.stdout.readAll().toString();
    }

    public static function commit(branch : String){
        git("add .");
        git('commit -m $branch --quiet');
        git('tag -l "grit-$branch"');
    }

    public static function log(metric : String, value : Float){
        var random = new Random();

        var branch = git("rev-parse HEAD").substr(0,8);
        trace(branch + " is the value for branch");
        var fout = sys.io.File.append("grit.log");
        var payload = {metric : metric, value : value};
        var payload_str = haxe.Json.stringify(payload);
        fout.writeString('grit-$branch $payload_str');
        fout.close();

    }

}

