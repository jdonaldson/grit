import Grit;
class Main {
    static function main() {
        Grit.log("lag", 250);
        Grit.log("accuracy", .9);
        Grit.log("logloss", 0.4);
        var max = Grit.max("baz");
        trace(max.hash + " is the value for max.hash");
        trace(max.value + " is the value for max.value");
    }
}
