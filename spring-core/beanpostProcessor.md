## 使用BeanPostProcessor注入Field
```
@Target({ElementType.FIELD}) //声明应用在属性上
@Retention(RetentionPolicy.RUNTIME) //运行期生效
@Documented //Java Doc
@Component
public @interface Boy {
    String value() default "";
}
```
```
@Component //注意：Bean后置处理器本身也是一个Bean
public class BoyAnnotationBeanPostProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        /**
         * 利用Java反射机制注入属性
         */
        Field[] declaredFields = bean.getClass().getDeclaredFields();
        for (Field declaredField : declaredFields) {
            Boy annotation = declaredField.getAnnotation(Boy.class);
            if (null == annotation) {
                continue;
            }
            declaredField.setAccessible(true);
            try {
                declaredField.set(bean, annotation.value());
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object o, String s) throws BeansException {
        return o; //这里要返回o，不然启动时会报错
    }
}
```
```
@Service
public class HelloBoy {

    @Boy("小明")
    String name = "world";

    public void sayHello() {
        System.out.println("hello, " + name);
    }
}
```

## 动态数据源切换

- https://blog.csdn.net/LoveFly826/article/details/86525894

DataSourceComponent
```
@Documented
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface DataSourceComponent {
	/**
	 * 数据源
	 * @return
	 */
	DatasourceEnum DataSource() default DatasourceEnum.DB1;
    /**
     * 是否要将标识此注解的类注册为Spring的Bean
     *
     * @return
     */
    boolean registerBean() default false;
}
```



















