# SpringBoot | Mybatis通用mapper的分页查询

> 原创 于 2019-07-10 17:58:59 发布 · 公开 · 2.6k 阅读 · 1 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/95359886

> 方式一

```java
 @Test
    public void findByPageHleper() {
        DogInfo dogInfo = new DogInfo();
        dogInfo.setDogId("7");
        Example example = new Example(DogInfo.class);
        Example.Criteria criteria = example.createCriteria();
        if (StringUtil.isNotNullOrNotEmpty(dogInfo.getDogId())) {
            // property是实体类的字段属性
            criteria.andLike("dogId", dogInfo.getDogId() + "%");
        }
        // orderBy的key是表的字段
        //sql ==>SELECT * FROM dog_info WHERE (dog_id LIKE ?) order by record_id desc LIMIT ?
        PageHelper.startPage(1, 10, "record_id desc");
        PageInfo<DogInfo> pageInfo = new PageInfo<>(dogInfoMapper.selectByExample(example));
        System.out.println("pageInfo.getSize() = " + pageInfo.getSize());//10
        System.out.println("pageInfo.getTotal() = " + pageInfo.getTotal());//459
    }
```

> 方式二

```java
@Test
    public void findByPageHleper2() {
        DogInfo dogInfo = new DogInfo();
        dogInfo.setDogId("7");
        Example example = new Example(DogInfo.class);
        Example.Criteria criteria = example.createCriteria();
        if (StringUtil.isNotNullOrNotEmpty(dogInfo.getDogId())) {
            // property是实体类的字段属性
            criteria.andLike("dogId", dogInfo.getDogId() + "%");
        }
        // orderBy的key是表的字段
        //sql ==>SELECT * FROM dog_info WHERE (dog_id LIKE ?) order by record_id desc LIMIT ?
        PageHelper.startPage(1, 10, "record_id desc");
        List<DogInfo> dogInfoList = dogInfoMapper.selectByExample(example);
        PageInfo<DogInfo> pageInfo = new PageInfo<>(dogInfoList);
        System.out.println("pageInfo.getSize() = " + pageInfo.getSize());//10
        System.out.println("pageInfo.getTotal() = " + pageInfo.getTotal());//459
    }
```

> 方式三

```java
 @Test
    public void findByPageHleper3() {
        DogInfo dogInfo = new DogInfo();
        dogInfo.setDogId("7");
        Example example = new Example(DogInfo.class);
        Example.Criteria criteria = example.createCriteria();
        if (StringUtil.isNotNullOrNotEmpty(dogInfo.getDogId())) {
            // property是实体类的字段属性
            criteria.andLike("dogId", dogInfo.getDogId() + "%");
        }
        // orderBy的key是表的字段
        // sql==> SELECT * FROM dog_info WHERE ( dog_id like ? )
        List<DogInfo> dogInfoList = dogInfoMapper.selectByExample(example);
        PageHelper.startPage(1, 10, "record_id desc");
        PageInfo<DogInfo> pageInfo = new PageInfo<>(dogInfoList);
        System.out.println("pageInfo.getSize() = " + pageInfo.getSize());//459
        System.out.println("pageInfo.getTotal() = " + pageInfo.getTotal());//459
    }
```