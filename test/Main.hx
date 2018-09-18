import Grit;
class Main {
    static function main() {
        Grit.deleteGritTags();
        Grit.log("foo", 2);
        Grit.log("bar", 2);
        Grit.log("baz", 2);
        Grit.log("bing", 2);
    }
}
