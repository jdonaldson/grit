import Grit;
class Main {
    static function main() {
        Grit.deleteGritTags();
        Grit.log("bing", 2);
        Grit.log("bar", 2);
        Grit.log("baz", 2);
        var max = Grit.max("baz");
        trace(max.value + " is the value for max.value");
    }
}
