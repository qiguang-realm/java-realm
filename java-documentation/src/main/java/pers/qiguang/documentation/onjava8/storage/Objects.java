package pers.qiguang.documentation.onjava8.storage;

/**
 * Objects Everywhere 万物皆对象
 *
 * @author qig
 * @since 2022-09-19
 */
public class Objects {

    // 对象操纵

    String s;

//    String s = "asdf";

    // 对象创建

//    String s = new String("asdf");

    /**
     * 数据存储
     *
     * 那么，程序在运行时是如何存储的呢？尤其是内存是怎么分配的。有5个不同的地方可以存储数据：
     *
     * 1.寄存器（Registers）最快的存储区域，位于 CPU 内部 ^2。然而，寄存器的数量十分有限，所以寄存器根据需求进行分配。
     * 我们对其没有直接的控制权，也无法在自己的程序里找到寄存器存在的踪迹（另一方面，C/C++ 允许开发者向编译器建议寄存器的分配）。
     *
     * 2.栈内存（The stack）存在于常规内存 RAM（随机访问存储器，Random Access Memory）区域中，可通过栈指针获得处理器的直接支持。
     * 栈指针下移分配内存，上移释放内存。这是一种仅次于寄存器的非常快速有效的分配存储方式。创建程序时，Java 系统必须知道栈内保存的所有项的生命周期。这种约束限制了程序的灵活性。因此，虽然在栈内存上存在一些 Java 数据（如对象引用），但 Java 对象本身的数据却是保存在堆内存的。
     *
     * 3.堆内存（The heap）这是一种通用的内存池（也在 RAM 区域），所有 Java 对象都存在于其中。
     * 与栈内存不同，编译器不需要知道对象必须在堆内存上停留多长时间。因此，用堆内存保存数据更具灵活性。
     * 创建一个对象时，只需用 new 命令实例化对象即可，当执行代码时，会自动在堆中进行内存分配。
     * 这种灵活性是有代价的：分配和清理堆内存要比栈内存需要更多的时间（如果可以用 Java 在栈内存上创建对象，就像在 C++ 中那样的话）。
     * 随着时间的推移，Java 的堆内存分配机制现在已经非常快，因此这不是一个值得关心的问题了。
     *
     * 4.常量存储（Constant storage）常量值通常直接放在程序代码中，因为它们永远不会改变。如需严格保护，可考虑将它们置于只读存储器 ROM （只读存储器，Read Only Memory）中 ^3。
     *
     * 5.非 RAM 存储（Non-RAM storage）数据完全存在于程序之外，在程序未运行以及脱离程序控制后依然存在。
     * 两个主要的例子：（1）序列化对象：对象被转换为字节流，通常被发送到另一台机器；（2）持久化对象：对象被放置在磁盘上，即使程序终止，数据依然存在。
     * 这些存储的方式都是将对象转存于另一个介质中，并在需要时恢复成常规的、基于 RAM 的对象。Java 为轻量级持久化提供了支持。
     * 而诸如 JDBC 和 Hibernate 这些类库为使用数据库存储和检索对象信息提供了更复杂的支持。
     */

    /**
     * 基本类型的存储
     * <p>
     * 通常 new 出来的对象都是保存在堆内存中的
     * <p>
     * Java 使用了和 C/C++ 一样的策略,不是使用 new 创建变量，而是使用一个“自动”变量。 这个变量直接存储”值”，并置于栈内存中，因此更加高效。
     */

//    基本类型	    大小	    最小值	        最大值	        包装类型
//    boolean	     —	          —	              —	            Boolean
//    char	       16 bits	   Unicode 0	 Unicode 216 -1	    Character
//    byte	        8 bits	    -128  	        +127	        Byte
//    short	       16 bits	   - 215	       + 215 -1	        Short
//    int	       32 bits	   - 231	       + 231 -1	        Integer
//    long	       64 bits	   - 263	       + 263 -1	        Long
//    float	       32 bits	   IEEE754	        IEEE754	        Float
//    double	   64 bits	   IEEE754	        IEEE754	        Double
//    void	         —	          —	              —	            Void


    // 在堆内存里表示基本类型的数据，就需要用到它们的包装类。
    char c = 'x';
    Character ch = new Character(c);

//    Character ch = new Character('x');


    // 基本类型自动转换成包装类型（自动装箱）

//    Character ch = 'x';

    // 相对的，包装类型转化为基本类型（自动拆箱）：

//    char c = ch;

}
