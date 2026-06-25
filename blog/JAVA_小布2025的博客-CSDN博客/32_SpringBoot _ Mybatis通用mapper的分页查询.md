# SpringBoot | Mybatis通用mapper的分页查询

> 原创 最新推荐文章于 2026-04-26 02:22:34 发布 · 公开 · 2.1k 阅读 · 0 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84864169

方法一

```java
    @Test
    public void findByPage() {
        PageHelper.startPage(1, 10, " id desc");
        PageInfo<Country> pageInfo = new PageInfo<>(this.countryMapper.selectAll());
        //pageInfo.getList().size():10
        //sql==>>SELECT Id, countryname, countrycode FROM country order by id desc LIMIT ?
        System.out.println("pageInfo.getList().size():"+pageInfo.getList().size());
        System.out.println("pageInfo = " + pageInfo);
    }
```

方法二

```java
  @Test
    public void findByPage2() {
        List<Country> countries = this.countryMapper.selectAll();
        PageHelper.startPage(1, 10, " id desc");
        PageInfo<Country> pageInfo = new PageInfo<>(countries);
        //pageInfo.getList().size():183
        //sql==>> SELECT Id,countryname,countrycode FROM country
        System.out.println("pageInfo.getList().size():"+pageInfo.getList().size());
        System.out.println("pageInfo = " + pageInfo);
    }
```

可以看出不能直接把数据放入PageInfo中，这样起不到分页查询的效果。还可以分页查询使用limit关键字，支持mysql数据库，