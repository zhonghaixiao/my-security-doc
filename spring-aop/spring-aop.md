## https://blog.csdn.net/canot/article/details/80855439
## 基本概念
1. Aspect    @Aspect
2. Join point   切点（方法的执行，异常的抛出）
3. Advice       增强，Action taken by an aspect at a particular join point.(around, before, after)
4. Pointcut     匹配切点的断言.Advice is associated with a pointcut expression and runs at any join point matched by the pointcut.
5. Introduction     Declare additional methods or fields on behalf of a type.Spring AOP允许为被增强的对象introduce新的接口。
6. Target Object: An Object being advised by one or more aspectes.(advised object)(proxied object)
7. AOP proxy: An object created by the AOP framework in order to implement the aspect contracts.(JDK dynamic proxy,CGLIB proxy)
8. Weaving: linking aspects with other application types or objects to create an advised object.(compile time using the AspectJ compiler, load time,runtime).spring AOP performs weaving at runtime.

## Spring AOP有以下几类增强
1. before advice:       在切点之前执行，但是不能阻止切点出代码的执行
2. after returning:     切点运行后执行
3. after throwing:      抛出异常后执行
4. after(finally) advice 只要切点存在就执行
5. around :             在切点周围执行，负责决定是否继续执行切点处代码，或者切断执行流返回自己的值或抛出异常

### 选择合适的advice

### spring AOP目前只支持创建method execution join points
advise the execution of methods on Spring Beans

## AOP Proxies
1. jdk 动态代理
2. CGLIB 动态代理

## @AspectJ
```
@Pointcut("execution(* transfer(..))")//the pointcut expression
private void anyOldTransfer(){}//the pointcut signature
```

1. execution
2. within
3. this
4. target
5. args
6. @target
7. @args
8. @within
9. @annotation

### combining pointcut expression
```
@Pointcut("execution(public * *(..))")
private void anyPublicOperation() {} 

@Pointcut("within(com.xyz.someapp.trading..*)")
private void inTrading() {} 

@Pointcut("anyPublicOperation() && inTrading()")
private void tradingOperation() {} 
```

visibility does not affect pointcut matching

## Declaring Advice
leakcanary

## AspectJProxyFactory
```
// create a factory that can generate a proxy for the given target object
AspectJProxyFactory factory = new AspectJProxyFactory(targetObject);

// add an aspect, the class must be an @AspectJ aspect
// you can call this as many times as you need with different aspects
factory.addAspect(SecurityManager.class);

// you can also add existing aspect instances, the type of the object supplied must be an @AspectJ aspect
factory.addAspect(usageTracker);

// now get the proxy object...
MyInterfaceType proxy = factory.getProxy();
```

## note
1. 运行时织入
2. 加载时织入
3. 编译期织入

- 编译时织入：在代码编译时，把切面代码融合进来，生成完整功能的Java字节码，这就需要特殊的Java编译器了，AspectJ属于这一类
- 类加载时织入：在Java字节码加载时，把切面的字节码融合进来，这就需要特殊的类加载器，AspectJ和AspectWerkz实现了类加载时织入
- 运行时织入：在运行时，通过动态代理的方式，调用切面代码增强业务功能，Spring采用的正是这种方式。动态代理会有性能上的开销，但是好处就是不需要神马特殊的编译器和类加载器啦，按照写普通Java程序的方式来就行了！

## Spring AOP的代理实现
- JDK动态代理：JDK动态代理技术。通过需要代理的目标类的getClass().getInterfaces()方法获取到接口信息（这里实际上是使用了Java反射技术。getClass()和getInterfaces()函数都在Class类中，Class对象描述的是一个正在运行期间的Java对象的类和接口信息），通过读取这些代理接口信息生成一个实现了代理接口的动态代理Class（动态生成代理类的字节码），然后通过反射机制获得动态代理类的构造函数，并利用该构造函数生成该Class的实例对象（InvokeHandler作为构造函数的入参传递进去），在调用具体方法前调用InvokeHandler来处理。



























