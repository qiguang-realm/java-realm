package pers.qiguang.documentation.onjava8.strings;

/**
 * Immutable
 *
 * @author qig
 * @since 2022-09-19
 */
public class Immutable {
    public static String upCase(String s) {
        return s.toUpperCase();
    }

    public static void main(String[] args) {
        String q = "howdy";
        System.out.println(q); // howdy
        String qq = upCase(q);
        System.out.println(qq); // HOWDY
        System.out.println(q); // howdy
    }
}
/* Output:
howdy
HOWDY
howdy
*/
