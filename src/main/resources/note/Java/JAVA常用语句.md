```text
@deprecated  过时注解 放于注释里面

BeanUtils.copyProperties(conditionVo, conditionVoTemp);

注解
@Column(name="loginname",columnDefinition=("varchar(50)  default null comment '登录名'"))


@SuppressWarnings({"rawtypes","unchecked","all"})

"'" + id + "'"


sql+=("matnr  like '%" + erpStorageInVo.getMatnr() + "%'");


for(int i=0;i<list.size();i++)

应该改为

for(int i=0,len=list.size();i<len;i++)


前者循环一百次则会计算一百次list的大小
判断元素在数组的位置

int positon = Arrays.binarySearch(array, "process_id");

Array和List的相互转换
list转array
Integer[] array= integerList.toArray(new Integer[0]); 
new Integer[0]是指定返回数组的类型
Array转List
一、不支持增删
List<Integer> integerList1=Arrays.asList(array);
二、支持增删
Integer[] intArray2 = new Integer[2];
List<Integer> list2 = new ArrayList<Integer>(Arrays.asList(intArray2)) ;
list2.add(2);
System.out.println(list2);

三、最高效
ArrayList< String> arrayList = new ArrayList<String>(strArray.length);
Collections.addAll(arrayList, strArray);


四、JAVA8Stream
List<Integer> intList= Arrays.stream(new int[] { 1, 2, 3, }).boxed().collect(Collectors.toList());
List<Long> longList= Arrays.stream(new long[] { 1, 2, 3 }).boxed().collect(Collectors.toList());
List<Double> doubleList= Arrays.stream(new double[] { 1, 2, 3 }).boxed().collect(Collectors.toList());

String[] arrays = {"tom", "jack", "kate"};
List<String> stringList= Stream.of(arrays).collect(Collectors.toList());


//List转Set
Set<String> set = new HashSet<>(list);
System.out.println("set: " + set);
//Set转List
List<String> list_1 = new ArrayList<>(set);
System.out.println("list_1: " + list_1);


//array转set
s = new String[]{"A", "B", "C", "D","E"};
set = new HashSet<>(Arrays.asList(s));
System.out.println("set: " + set);
//set转array
dest = set.toArray(new String[0]);
System.out.println("dest: " + Arrays.toString(dest));


//list转jsonArray
List<T> list = new ArrayList<T>();
JSONArray array= JSONArray.parseArray(JSON.toJSONString(list))；
//JSONARRY转list
JSONArray array = new JSONArray();
List<EventColAttr> list = JSONObject.parseArray(array.toJSONString(), EventColAttr.class);


先分组再排序
Map<String, List<Map<String, Object>>> listLinkedHashMap = new LinkedHashMap<>();
Map<String, List<Map<String, Object>>> temp = dataList.stream().collect(Collectors.groupingBy(map -> (String) map.get("id")));
temp.entrySet().stream().sorted(Map.Entry.comparingByKey()).forEachOrdered(e -> listLinkedHashMap.put(e.getKey(), e.getValue()));

先排序再分组 一定要确定类型
LinkedHashMap<Integer, List<Person>> ageMap = persons.stream().sorted(Comparator.comparingInt(Person::getAge)).collect(Collectors.groupingBy(Person::getAge, LinkedHashMap::new, Collectors.toList()));


数组复制
src - 源数组

srcPos - 源数组的开始位置

dest - 目标数组

destPos -目标数组的开始位置

length - 数组元素拷贝的数量

String[] array = {"1", "2", "3"};
String[] newArray = new String[array.length];
System.arraycopy(array, 0, newArray, 0, array.length);


map for循环

Map<String, String> map = new HashMap<String, String>();

for (Map.Entry<String, String> entry : map.entrySet()) {

    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());

}

数组和list分隔成字符串
String.join(",", list);
String.join(",", array);

给list中的每个元素都加上单引号并用逗号隔开

List<String> list = new ArrayList<>();
list.add("110");
list.add("120");
String ids = list.stream().map(s -> "\'" + s + "\'").collect(Collectors.joining(", "));
System.out.println(ids);

-Xms50m -Xmx80m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=D:/heapdump

启动java jar
java -Xms50m -Xmx50m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=D:/heapdump -jar  ssm.jar


```

## SpringBoot

```text

#   测试环境：

java -jar my-spring-boot.jar --spring.profiles.active=test
#   生产环境：

java -jar my-spring-boot.jar --spring.profiles.active=prod

```

