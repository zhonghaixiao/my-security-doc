# 高性能进程内缓存库

- 类比 jdk的 ConcurrentMap, 区别是ConcurrentMap持久存放元素直到被显示删除。Cache则可以自动剔除entry以限制内存。

- 有时候 LoadingCache, AsyncLoadingCache自动加载缓存，不自动淘汰entry

## Caffeine构造
1. automatic loading of entries into the cache,optionally asynchronously
2. size-based eviction when a maximum is exceeded based on frequency and recency
3. time-based expiration of entries, measured since last access or last write
4. asynchronously refresh when the first stale request for an entry occurs
5. keys automatically wrapped in weak references
6. values automatically wrapped in weak or soft references
7. notification of evicted (or otherwise removed) entries
8. writes propagated to an external resource
9. accumulation of cache access statistics































