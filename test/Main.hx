import Grit;
class Main {
    static function main() {
        Grit.log("bing", 2);
        Grit.log("bar", 2);
        Grit.log("baz", 2);
        var max = Grit.max("baz");
        trace(max.hash + " is the value for max.hash");
        trace(max.value + " is the value for max.value");
    }
}
