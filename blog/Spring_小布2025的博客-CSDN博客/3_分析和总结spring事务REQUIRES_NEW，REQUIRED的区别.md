# 分析和总结spring事务REQUIRES_NEW，REQUIRED的区别

> 原创 已于 2023-12-06 14:53:27 修改 · 公开 · 2.8k 阅读 · 1 · 5 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/121533704

> > #### REQUIRES_NEW的使用特性 即创建一个新事务，如果当前事务存在，则挂起当前事务。
> > 
> > #### REQUIRED的使用特性 即支持当前事务，如果不存在，则创建一个新事务。
> > 
> > 
> 
> 

### 模拟外层出现异常

##### TransactionalTest

```java
package com.xiaobu.junit;

import com.xiaobu.entity.Persons;
import com.xiaobu.entity.Salary;
import com.xiaobu.service.PersonsService;
import com.xiaobu.service.SalaryService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/10/27 16:36
 */
@SpringBootTest
public class TransactionalTest {
    @Autowired
    private PersonsService personsService;
    @Autowired
    private SalaryService salaryService;

    @Test
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
    public void test() {
        //add persons
        Persons persons = new Persons();
        persons.setFirstName("admin");
        personsService.insert(persons);
        //add salary
        Salary salary = Salary.builder().salary("100").userId(100).build();
        salaryService.insert(salary);
        //模拟出现了异常情况 结果：persons插入失败 salary插入成功
        int i = 1 / 0;
    }

}

```

##### PersonsService

```java
package com.xiaobu.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaobu.entity.Persons;
import com.xiaobu.mapper.PersonsMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * The type Persons service.
 *
 * @author xiaobu
 * @version 1.0.0
 * @className PersonsService.java
 * @createTime 2021年11月17日 19:25:00
 */
@Service
public class PersonsService extends ServiceImpl<PersonsMapper, Persons> {
    @Resource
    private PersonsMapper personsMapper;

    /**
     * Insert int.
     *
     * @param p the p
     * @return the int
     */
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
    public void insert(Persons p) {
        personsMapper.insert(p);
    }

}


```

##### SalaryService

```java
package com.xiaobu.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaobu.entity.Salary;
import com.xiaobu.mapper.SalaryMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author xiaobu
 * @version 1.0.0
 * @className SalaryService.java
 * @createTime 2021年11月25日 09:52:00
 */

@Service
public class SalaryService extends ServiceImpl<SalaryMapper, Salary> {

    @Resource
    private SalaryMapper salaryMapper;


    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public void insert(Salary s) {
        salaryMapper.insertSelective(s);
    }

}

```

### 模拟REQUIRES_NEW修饰方法出现异常情况，看看它是否对外层造成影响。

##### TransactionalTest

```java
package com.xiaobu.junit;

import com.xiaobu.entity.Persons;
import com.xiaobu.entity.Salary;
import com.xiaobu.service.PersonsService;
import com.xiaobu.service.SalaryService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/10/27 16:36
 */
@SpringBootTest
public class TransactionalTest {
    @Autowired
    private PersonsService personsService;
    @Autowired
    private SalaryService salaryService;

    @Test
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
    public void test() {
        //add persons
        Persons persons = new Persons();
        persons.setFirstName("admin");
        personsService.insert(persons);
        //add salary
        Salary salary = Salary.builder().salary("100").userId(100).build();
        salaryService.insert(salary);
    }

}

```

```java
    @Test
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
public void test(){
        //add persons
        Persons persons=new Persons();
        persons.setFirstName("admin126");
        personsService.insert(persons);
        //add salary
        Salary salary=Salary.builder().salary("100").userId(100).build();
        salaryService.insert(salary);
        int i=1/0;
        }

```

> 执行结果我们发现，外层事务出现异常，用户表更新操作被回滚，但REQUIRES_NEW修饰的salaryService.insert方法执行成功。

##### PersonsService

```java
package com.xiaobu.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaobu.entity.Persons;
import com.xiaobu.mapper.PersonsMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * The type Persons service.
 *
 * @author xiaobu
 * @version 1.0.0
 * @className PersonsService.java
 * @createTime 2021年11月17日 19:25:00
 */
@Service
public class PersonsService extends ServiceImpl<PersonsMapper, Persons> {
    @Resource
    private PersonsMapper personsMapper;

    /**
     * Insert int.
     *
     * @param p the p
     * @return the int
     */
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
    public void insert(Persons p) {
        personsMapper.insert(p);
    }

}


```

##### SalaryService

```java
package com.xiaobu.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaobu.entity.Salary;
import com.xiaobu.mapper.SalaryMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author xiaobu
 * @version 1.0.0
 * @className SalaryService.java
 * @createTime 2021年11月25日 09:52:00
 */

@Service
public class SalaryService extends ServiceImpl<SalaryMapper, Salary> {

    @Resource
    private SalaryMapper salaryMapper;


    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public void insert(Salary s) {
        salaryMapper.insertSelective(s);
        // 模拟REQUIRES_NEW修饰方法出现异常情况，看看它是否对外层造成影响。
        int i = 1 / 0;

    }

}

```

结果：persons和salary都未插入数据

> 总结，REQUIRES_NEW修饰方法的特性：它会对外层的事务有影响，如果它里面执行时出现异常不仅自己的内容回滚，也会导致外层事务也回滚

> > REQUIRES_NEW的事务，不受外层调用者影响，但会影响外层的事务。 REQUIRED的事务，即受外层调用者影响，也会影响外层的事务。
> 
> 

实际业务如何使用： 在同一个方法中，因为大多数情况是一系列业务要保证要么都成功要么都失败的，所以各个业务方法使用默认的REQUIRED方式即可。
如果中间有一个特殊的业务方法，和其他业务不关联，我们可以给它的方法设置REQUIRES_NEW，这样就能保证其他业务有异常时，它也不会被回滚。

#### 参考：

[分析和总结spring事务REQUIRES_NEW，REQUIRED的区别](https://www.codenong.com/cs105310177/) 