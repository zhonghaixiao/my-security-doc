## AliasRegistry
1. registerAlias
2. removeAlias
3. isAlias
4. getAliases

## BeanDefinitionRegistry
1. registerBeanDefinition
2. removeBeanDefinition
3. getBeanDefinition
4. containsBeanDefinition
5. getBeanDefinitionNames
6. getBeanDefinitionCount
7. isBeanNameInUse

## ConfigurableListableBeanFactory
1. ignoreDependencyType
2. ignoreDependencyInterface
3. registerResolvableDependency
4. isAutowireCandidate
5. getBeanDefinition
6. getBeanNamesIterator
7. clearMetadataCache
8. preInstantiateSingletons


## DefaultSingletonBeanRegistry#getSingleton

## AbstractAutowireCapableBeanFactory#createBean

## AbstractBeanDefinition

## AbstractBeanFactory#getType，doGetBean


# AbstractAutowireCapableBeanFactory 
bean抽象工厂类，实现从RootBeanDefinition创建bean的功能

主要功能：
- 从构造函数创建bean(包括自动装配)
- property polulation(属性注入) property by name,property by type
- 初始化(initialization)

note:
- 不具备bean definition注册功能
- 实现resolveDependency方法 根据type自动装配,自定义注入规则

## 成员变量：
1. InstantiationStrategy 创建bean实例的策略
2. ParameterNameDiscoverer 根据方法参数名
3. NamedThreadLocal<String> currentlyCreatedBean当前正在创建bean的名称
4. ConcurrentMap<String, BeanWrapper> factoryBeanInstanceCache， 未完成FactoryBean实例缓存，（factoryName,BeanWrapper）
5. ConcurrentMap<Class<?>, Method[]> factoryMethodCandidateCache, Cache of candidate factory methods per factory class
6. Set<Class<?>> ignoredDependencyInterfaces，Dependency interfaces to ignore on dependency check and autowire
7. Set<Class<?>> ignoredDependencyTypes， Dependency types to ignore on dependency check and autowire


- allowCircularReferences = true: 允许循环引用并自动处理，这意味着一个初始化中的bean会被注入一个未完全初始化的bean。false时，当遇到循环引用时会抛出异常。通常建议不要依赖于自动循环注入，将循环引用的bean注入一个第三者中，

- allowRawInjectionDespiteWrapping = false：是否允许将bean的原始实例注入其他bean中，这是当遇到循环引用时的最后一招，宁愿注入一个原始bean也不愿意注入失败。当存在自动代理时，不建议依赖自动循环注入

## 创建bean的相关方法（creating,polulating）
1. createBean
```
    RootBeanDefinition bd = new RootBeanDefinition(beanClass);
    bd.setScope(SCOPE_PROTOTYPE);
    bd.allowCaching = ClassUtils.isCacheSafe(beanClass, getBeanClassLoader());//判断该类是否是该classLoader加载的
    调用createBean
```
```
Object createBean(String beanName, RootBeanDefinition mbd, @Nullable Object[] args){
    RootBeanDefinition mbdToUse = mbd;
    //确定bean的Class对象，将className转为Class对象并存储在BeanDefinition中
    Class<?> resolvedClass = resolveBeanClass(mbd, beanName);
    if (resolvedClass != null && !mbd.hasBeanClass() && mbd.getBeanClassName() != null) {
		mbdToUse = new RootBeanDefinition(mbd);
		mbdToUse.setBeanClass(resolvedClass);
	}
    //Prepare method overrides ？？？？？
    mbdToUse.prepareMethodOverrides();

    //BeanPostProcessors可以注入代理类
    Object bean = resolveBeforeInstantiation(beanName, mbdToUse);

    //实际创建bean的方法，bean的实例化方式有（factory method, autowire a constructor）
    Object beanInstance = doCreateBean(beanName, mbdToUse, args);

}
```
```
Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final @Nullable Object[] args){
    BeanWrapper instanceWrapper = null;
    //如果
    if (mbd.isSingleton()) {
		instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
	}
    if (instanceWrapper == null) {
		instanceWrapper = createBeanInstance(beanName, mbd, args);
	}
    if (instanceWrapper == null) {
		instanceWrapper = createBeanInstance(beanName, mbd, args);
	}
    // Allow post-processors to modify the merged bean definition.
	synchronized (mbd.postProcessingLock) {
		if (!mbd.postProcessed) {
			try {
				applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
			}
			catch (Throwable ex) {
				throw new BeanCreationException(mbd.getResourceDescription(), beanName,
						"Post-processing of merged bean definition failed", ex);
			}
			mbd.postProcessed = true;
		}
	}
    // Initialize the bean instance.
	Object exposedObject = bean;
	try {
		populateBean(beanName, mbd, instanceWrapper);
		exposedObject = initializeBean(beanName, exposedObject, mbd);
	}
    // Register bean as disposable.
	try {
		registerDisposableBeanIfNecessary(beanName, bean, mbd);
	}
}

```
```
void populateBean(String beanName, RootBeanDefinition mbd, @Nullable BeanWrapper bw) {
    hasInstantiationAwareBeanPostProcessors() -> InstantiationAwareBeanPostProcessor#postProcessAfterInstantiation
    RootBeanDefinition.hasPropertyValues() 
    RootBeanDefinition.getResolvedAutowireMode() -> autowireByName, autowireByType
    hasInstantiationAwareBeanPostProcessors() -> ibp.postProcessProperties,postProcessPropertyValues
    checkDependencies(beanName, mbd, filteredPds, pvs);
}
```
```
Object initializeBean(final String beanName, final Object bean, @Nullable RootBeanDefinition mbd) {
    invokeAwareMethods(beanName, bean);
    applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName);
    invokeInitMethods(beanName, wrappedBean, mbd);
    applyBeanPostProcessorsAfterInitialization(wrappedBean, beanName);
}
```
```
void invokeInitMethods(String beanName, final Object bean, @Nullable RootBeanDefinition mbd){
    if isInitializingBean -> ((InitializingBean) bean).afterPropertiesSet();
    String initMethodName = mbd.getInitMethodName();
    invokeCustomInitMethod(beanName, bean, mbd);
    Method initMethod = (mbd.isNonPublicAccessAllowed() ?
				BeanUtils.findMethod(bean.getClass(), initMethodName) :
				ClassUtils.getMethodIfAvailable(bean.getClass(), initMethodName));
    ReflectionUtils.makeAccessible(initMethod);
	initMethod.invoke(bean);
}
```
2. autowire
```
        RootBeanDefinition bd = new RootBeanDefinition(ClassUtils.getUserClass(existingBean));
		bd.setScope(BeanDefinition.SCOPE_PROTOTYPE);
		bd.allowCaching = ClassUtils.isCacheSafe(bd.getBeanClass(), getBeanClassLoader());
		BeanWrapper bw = new BeanWrapperImpl(existingBean);
		initBeanWrapper(bw);
		populateBean(bd.getBeanClass().getName(), bd, bw);
```

# AbstractBeanFactory

# BeanUtils

# ClassUtils

# InitializingBean

# InstantiationAwareBeanPostProcessors # postProcessProperties, postProcessPropertyValues

postProcessBeforeInitialization


# AbstractBeanFactory # createBean



































