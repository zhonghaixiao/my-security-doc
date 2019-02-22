## @component
```
@Target(ElementType.TYPE)     //可用于class , interface
@Retention(RetentionPolicy.RUNTIME) //运行期识别

public @interface Component {
    string value() default "";
}
```

## 1. BeanFactory

### methods
1. getBean
2. getBeanProvider
3. containsBean
4. isSingleton
5. isPrototype
6. isTypeMatch
7. getType
8. getAliases

- spring bean 容器的根接口,提供bean容器的客户接口，子接口有ListableBeanFactory,ConfigurableBeanFactory
- bean容器实现该接口，容器中持有一些bean的定义，用beanName字符串标识。根据bean的定义，Bean容器返回一个新的bean（prototype），或者一个共享bean(singleton)；具体返回bean的类型取决于容器的配置，使用同一个getBean接口。
- spring2.0新增了多个scopes (request, session,) in web application context
- BeanFactory是application组件的注册中心
- 容器中的bean自己不会去读取配置，依赖于DI，容器通过setters or constructors来配置应用对象。而不是对象拉取配置并在beanFactory中查找依赖的对象。
- BeanFactory负责从配置文件（xml,ldap,props file）中读取配置，然后使用bean package中的组件配置对象。

### subinterfaces
1. ListableBeanFactory
2. HierarchicalBeanFactory
HierarchicalBeanFactory在当前容器查不到bean时，还会检查所有的parent容器，子容器中的同名bean覆盖父容器中的bean。


## Bean生命周期
1. BeanNameAware.setBeanName
2. BeanClassLoaderAware.setBeanClassLoader
3. BeanFactoryAware.setBeanFactory
4. EnvironmentAware.setEnviroment
5. EmbeddedValueResolverAware.setEmbededValueResolver
6. ResourceLoaderAware.setResourceLoader
7. ApplicationEventPublisherAware.setApplicationEventPublisher
8. MessageSourceAware.setMessageSource
9. ApplicationContextAware.setApplicationContext
10. ServletContextAware.setServletContext
11. BeanPostProcessors.postProcessBeforeInitialization
12. InitializingBean.afterPropertiesSet
13. BeanPostProcessors.postProcessAfterInitialization
14. DestructionAwareBeanPostProcessors.postProcessBeforeDestruction
15. DisposableBean.destroy

---

## ListableBeanFactory extends BeanFactory

1. containsBeanDefinition   容器中是否存在某个名字的bean
2. getBeanDefinitionCount
3. getBeanDefinitionNames   返回所有bean的名字
4. getBeansOfType
5. getBeanNamesForType  获取某一类型的所有bean，包括子类。
6. getBeanNamesForAnnotation
7. getBeansWithAnnotation
8. findAnnotationOnBean

### note:
1. 只返回本factory创建的bean,不包含其他容器创建的singleton bean
2. 除了getBeanDefinitionCount，containsBeanDefinition，接口中的其他方法都不适合高频率调用

## HierarchicalBeanFactory extends BeanFactory

1. BeanFactory getParentBeanFactory 
2. containsLocalBean

## SingletonBeanRegistry

- 为share bean 提供注册接口
- 容器实现该接口以统一方式暴露单例管理

ConfigurableBeanFactory.setParentBeanFactory 设置parent
1. *registerSingleton(String beanName, Object singletonObject)*   向容器中注册单例对象，该对象已初始化
   
- 向beanFactory中注册一个bean definition而不是一个已初始化的对象，该bean才可以接收到初始化和销毁回调
- 可以在配置时注册，也可以在运行时注册单例对象。注册实现需要自己实现同步访问单例对象
- 如果容器延迟初始化一个单例对象，必须要处理对单例对象的同步访问。

2. *Object getSingleton(beanName)* 
3. *containsSingleton*
4. *getSingletonNames*
5. *getSingletonCount*
6. *getSingletonMutex*

## ConfigurableBeanFactory extends HierarchicalBeanFactory,SingletonBeanRegistry

- 提供配置bean factory的额外功能

1. *setParentBeanFactory(BeanFactory parentBeanFactory)*
2. *setBeanClassLoader(ClassLoader beanClassLoader)* 默认thread context class loader， 只适用于还没有初始化过bean的bean definition
   - 在spring2.0中，Bean Definitions only carry bean class names,在factory处理bean 定义时resolved
3. *getBeanClassLoader*
4. *setTempClassLoader* 指定一个临时的classLoader来做类型匹配
5. *getTempClassLoader*
6. *setCacheBeanMetadata* 是否缓存bean definitions
7. *isCacheBeanMetadata*
8. *addBeanPostProcessor*
9. *getBeanPostProcessorCount*
10. *registerScope(String scopeName, Scope scope);*
11. *getRegisteredScopeNames*
12. *getRegisteredScope*
13. *getAccessControlContext*
14. *copyConfigurationFrom*
15. *registerAlias* Given a bean name, create an alias
16. *isFactoryBean*
17. *registerDependentBean*
18. *getDependentBeans*
19. *getDependenciesForBean*
20. *destroyBean(String beanName, Object beanInstance);*
21. *destroyScopedBean(String beanName);*
22. *destroySingletons();*

---
## AutowireCapableBeanFactory extends BeanFactory

- 实现autowire功能
- 第三方框架可以利用该接口wirespring不能初始化的bean
- ApplicationContext不实现该接口，可以通过ApplicationContext#getAutowireCapableBeanFactory()获取

1. createBean(Class<T> beanClass) 创建一个新的bean
2. autowireBean(Object existingBean)
3. configureBean(Object existingBean, String beanName)
4. 
5. createBean
6. autowire
7. autowireBeanProperties
8. applyBeanPropertyValues
9. initializeBean
10. applyBeanPostProcessorsBeforeInitialization
11. applyBeanPostProcessorsAfterInitialization
12. destroyBean
13. resolveDependency

## ConfigurableListableBeanFactory extends ListableBeanFactory, AutowireCapableBeanFactory, ConfigurableBeanFactory

1. *ignoreDependencyType* Ignore the given dependency type for autowiring:
2. *ignoreDependencyInterface* 
3. *registerResolvableDependency*
4. *getBeanDefinition*
5. *getBeanNamesIterator* 返回说有的bean name,包括bean definition names和单例bean 
6. *clearMetadataCache* clear cache, remove entries for beans;已创建bean的元数据保留
7. *freezeConfiguration* 不再修改bean definitions
8. *isConfigurationFrozen*
9. *preInstantiateSingletons* 确保所有非延时单例被初始化


## 


---
### scope identifier
- singleton
- prototype


---
## DefaultListableBeanFactory


# 设计模式

## 单例模式
## 原型模式































