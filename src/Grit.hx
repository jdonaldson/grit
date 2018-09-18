import sys.io.Process;

class Grit {

    static function shell(cmd : String) : String {
        var args = ~/\s+/.split(cmd);
        var p = new Process('sh', args);
        var exit = p.exitCode(true);
        if (exit != 0){
            throw ('Error : ' + p.stderr.readAll().toString());
        }
        return p.stdout.readAll().toString();
    }
    static function git(cmdstr : String) : String {
        var args = ~/\s+/g.split(cmdstr);
        var cmd = args.shift();
        var p = new Process('git $cmd', args);
        var exit = p.exitCode(true);
        if (exit != 0){
            var err = p.stderr.readAll().toString();
            var out = p.stdout.readAll().toString();
            var msg = err.length > 0 ? err : out;
            throw ('Error : $cmdstr\n Message: $msg');
        }
        return p.stdout.readAll().toString();
    }

    public static function commit(branch : String, payload : String) : Void {
        git("add .");
        git('commit -m $branch --quiet');
        var payload = ~/"/.replace(payload, "\\\"");
        git('tag -a grit-$branch -m $payload');
    }

    public static function isDirty() : Bool {
        var message = "nothing to commit, working tree clean";
        var status = git('status');
        var index = status.lastIndexOf(message);
        return index == -1;
    }

    public static function log(metric : String, value : Float){
        var branch = git("rev-parse HEAD").substr(0,8);
        var payload = {metric : metric, value : value};
        var payload_str = haxe.Json.stringify(payload);
        if (isDirty()){
            commit(branch, payload_str);
        }


    }

}

