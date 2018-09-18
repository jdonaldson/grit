import sys.io.Process;
class WhenDid {

    public static function log(metric : String, value : Float){
        var p = new Process("git", ["log"]);
        var exit = p.exitCode(true);
        trace(exit + " is the value for exit");
    }
}

