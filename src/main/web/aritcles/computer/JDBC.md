# JDBC

JDBC(Java Data Base Connectivity) 是 Java 程序操作 数据库的 API，它是操作数据库的规范，由一组 Java 类和接口构成，它对数据库的操作提供了基本方法，具体实现由数据库厂商进行。使用 JDBC 操纵数据库需要数据库厂商提供的数据库驱动程序。

## 1.JDBC 连接过程

- **注册数据库驱动：**在连接数据库前，需要将数据库驱动类注册到 JDBC 的驱动管理器中。通常情况下是通过 JVM 的类加载机制将数据库驱动类加载到 JVM 来实现的。

  加载数据库驱动，住猜测到驱动管理器：

  ```java
  Class.forName("com.mysql.jdbc.Driver");
  ```

- **构建数据库连接 URL：**建立数据库连接需要构建数据库连接的 URL ，不同数据库的连接 URL 一般不同，但都遵循一个统一格式：`"JDBC协议+IP地址或域名+端口+数据库名称"`。如 MySql 连接 URL 为："jdbc:mysql://localhost:3306/test"。连接 mysql 的 test 数据库。

- **获取 Connection 对象：**该对象是 JDBC 封装的数据库连接对象，只有创建该对象才可以对数据库进行操作。

  ```java
  Connection conn = DriverManager.getConnection(url,username,password);
  ```

完整的一个数据库连接过程，示例代码：

``` java
Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/test";
String username = "root";
String password = "12345";
Connection conn=DriverManager.getConnection(url,username,password);
if(conn != null){
    System.out.println("数据库连接成功");
	conn.close();
}else{
	System.out.println("数据库连接失败");
}
```

## 2. JDBC API

- **Connection** 接口：该接口是与特定数据库的连接会话，只有获得连接对象才可以对数据库进行操作。
- **DriverManager** 类：该类是 JDBC 中的管理层，通过该类可以管理数据库厂商提供的驱动程序，并且它主要用于管理用户与驱动程序之间的连接。
- **Statement** 接口：在创建连接后，可以使用 SQL 语句对数据库进行操作，而该接口封装了这些操作，提供了执行语句和获取查询结果的基本方法。
- **PreparedStatement** 接口：该接口继承 Statement 接口，用于带参的 SQL 语句查询，参数使用占位符 ？来代替。
- **ResultSet** 接口：该接口对象用于接收查询结果集。

**以上接口的具体方法查看 J2SE 的 API**

**DriverManager 接口：**

| 方法                          | 描述                                           |
| ----------------------------- | ---------------------------------------------- |
| registerDriver(Driver driver) | 向 DriverManager 中注册给定的 JDBC 驱动程序    |
| getConnection(url, user, pwd) | 建立和数据库的连接，返回连接的 Connection 对象 |

**Connection 接口：** 

| 方法                         | 描述                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| getMetaData()                | 返回用于表示数据库元数据的对象                               |
| createStatement()            | 用于创建 Statement 对象并将 sql 语句发送到数据库             |
| prepareStatement(String sql) | 用于创建 prepareStatement 对象并将参数化的 sql 语句发送到数据库 |
| prepareCall(String sql)      | 用于创建 CallableStatement 对象来调用数据库的存储过程        |



## 3. JDBC 操作数据库

连接数据库：

JDBCUtils.java:

```java
package com.jachin.dbutils;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import com.mysql.jdbc.Driver;

public class JDBCUtils {
	/**
	 * 获得数据库连接 对象
	 * @version 1.0
	 * @return Connection
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 * @throws IOException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static Connection getConnection() throws ClassNotFoundException, SQLException, IOException, InstantiationException, IllegalAccessException{
		String driverClass = null;
		String url = null;
		String username = null;
		String password = null;

		InputStream in = JDBCUtils.class.getClassLoader().getResourceAsStream("JDBC.properties");

		Properties pro = new Properties();
		pro.load(in);
		driverClass = pro.getProperty("driver");
		url = pro.getProperty("url");
		username = pro.getProperty("username");
		password = pro.getProperty("password");
		//System.out.println("Driver:" + driverClass + "\nUrl:" + url + "\nUserName:" + username + "\nPassword:" + password);
		
		Driver driver = (Driver) Class.forName(driverClass).newInstance();
		Properties info = new Properties();
		info.put("user", username);
		info.put("password", password);
		Connection conn = driver.connect(url, info);
		return conn;
	}
	
	/**
	 * 释放数据库连接
	 * @param statement
	 * @param conn
	 */
	public static void release(Statement statement, Connection conn){
		if(statement != null){
			try{
				statement.close();
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if(conn != null){
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
```

配置文件 JDBC.properties:

```properties
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/test?useSSL=true
username=root
password=ghostttt
```

###3.1 数据库更新操作

数据库更新包括了增删改，对应 Insert、Delete、Update



## 4 数据库连接池

JDBC 每一次的创建和断开连接都需要消耗一定的时间和资源，为了解决这个问题，出现了数据库连接池技术。

数据库连接池负责分配、管理、释放数据库连接，它允许应用程序使用现有的数据库连接，而不需要重新建立连接。

数据库连接池在初始化时会创建一定数量的 Connection 放到数据库连接池中，当应用程序访问数据库时，并不是直接创建 Connection ，而是需要向连接池申请一个 Connection，如果连接池中有空闲的 Connection，则将其返回，否则创建新的 Connection。当应用程序使用完毕后，连接池便会回收该 Connection 以供其他线程的使用。

### 4.1 DataSource 接口

为了获取数据库连接对象，JDBC 提供了 DataSource 接口，它负责与数据库建立连接，并定义了返回值为 Connection 对象的方法：

- Connection getConnection()
- Connection getConnection(String username, String password)

通常把实现了该接口的类称为数据源，在数据源中存储了所有建立数据库连接的信息。数据源中包含数据库连接池。一些开源组织提供了数据源的独立实现，常用的有 DBCP 数据源和 C3P0 数据源。

### 4.2 DBCP 数据源

DataBase Connection Pool，是 Apache 组织下的开源连接池实现，也是 Tomcat 服务器使用的连接池组件。单独使用的话，需要以下两个依赖包：

- commons-dbcp.jar：包含所有操作 数据库连接信息 和 数据库连接池初始化信息 的方法，并实现了 DataSource 接口的 getConnection() 方法。
- commons-pool.ar：该包为上面一个包的方法提供了支持。

再使用 DBCP 连接数据库前，需要了解一个 DataSource 的实现类：BasicDataSource，该类主要包括设置数据库源对象的方法。

| 方法                                  | 描述                       |
| ------------------------------------- | -------------------------- |
| setDriverClassName(String driverName) | 设置驱动名称               |
| setUrl(String url)                    | 设置数据库路径             |
| setUserName(String userName)          | 设置登陆账号               |
| setPassword(String password)          | 设置登陆密码               |
| setInitialSize(int size)              | 设置连接池初始化的连接数   |
| setMaxActive(int max)                 | 设置连接池活跃连接的最大值 |
| setMinldle(int min)                   | 设置连接池闲置连接的最小值 |
| getConnection()                       | 从连接池中获取一个连接     |

而 BasicDataSourceFactory 是创建 BasicDataSource 对象的工厂类，它包含一个返回 BD 对象的方法：**createDataSource()**，该方法通过读取配置文件信息生成数据源对象返回给调用者。

使用 DBCP 数据源连接数据库，首先需要创建数据库临街对象，创建方法有两种：

- 通过 BasicDataSource 类直接创建：需要手动设置属性值，再获取对象。
- 通过读取配置文件创建：使用 BasicDataSourceFactory 工厂类来读取配置文件，创建数据源对象，然后获取连接对象。

下面分别为这两种方法的代码示例：

```java
//1.直连
public class BasicDataSourceDemo {
	public static DataSource ds = null;
	static {
		// 获取实现类对象
		BasicDataSource bds = new BasicDataSource();
		bds.setDriverClassName("com.mysql.jdbc.Driver");
		bds.setUrl("jdbc:mysql://localhost:3306/test");
		bds.setUsername("myuser");
		bds.setPassword("mypassword");
		
		bds.setInitialSize(5);
		bds.setMinIdle(5);
		ds = bds;
	}
	public static void main(String[] args) throws SQLException {
		// 获取连接对象
		Connection conn = ds.getConnection();
		// 获取数据
		DatabaseMetaData metaData = conn.getMetaData();
		// 打印数据库连接信息
        System.out.println(metaData.getURL()+metaData.getUserName()
                   +metaData.getDriverName());
	}
}
```

``` java
// 2 读取配置文件
public class BasicDataSourceFactoryDemo {
    public DataSource ds = null;
	public void getConn(){
        // 通过类加载器找到文件路径，读取配置文件
		InputStream in = getClass().getClassLoader()
            .getResourceAsStream("JDBC.properties");
		// 把文件以流形式加载到配置对象中
		Properties pro = new Properties();
		pro.load(in);
        // 利用 createDataSource 方法创建数据源对象
		ds = BasicDataSourceFactory.createDataSource(prop);
	}
    @Test
    public void test(){
        Connection conn = ds.getConnection();
        DatabaseMetaData metaData = conn.getMetaData();
        System.out.println(metaData.getURL()+metaData.getUserName()
                   +metaData.getDriverName());
    }
}
```

### 4.3 C3P0 数据源

目前最流行的开源数据库连接池，实现了 Datasource 数据源接口，支持 JDBC2 和 JDBC3 标准规范，易于拓展且性能优越。Hibernate 和 Spring 都支持该数据源。

DataSource 接口的实现类 ComboPooledDataSource 是 C3P0 的核心类，提供了数据源对象的操作方法，常用方法如下:

| 方法                 | 描述                   |
| -------------------- | ---------------------- |
| setDriverClass()     |                        |
| setJDBCUrl()         |                        |
| setUser()            |                        |
| setPassword()        |                        |
| setMaxPoolSize()     | 设置连接池最大连接数   |
| setMinPoolSize()     | 设置最小连接数         |
| setInitialPoolSize() | 设置连接池初始化连接数 |
| getConnection()      |                        |

C3P0 和 DBCP 的方法基本一致。

使用 C3P0 创建数据源对象，需要用到核心类，该类有两个构造方法：

- ComboPooledDataSource()
- ComboPooledDataSource(String configName)

无参构造方法的使用基本和 DBCP 一致，创建一个 ComboPooledDataSource 对象后，再用该对象的设置属性方法为参数赋值，然后使用 getConnection() 方法获取数据库连接对象。

而带参的构造方法，需要通过读取配置文件 如：c3p0-config.xml ，来获取数据库连接初始化信息。

示例：c3p0-config.xml

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<c3p0-config>
	<!-- 默认配置，当构造方法参数为 "" 时或找不到指定配置节点时使用 -->
	<defaul-config>
		<property name="driverClass">com.mysql.jdbc.Driver</property>
		<property name="jdbcUrl">jdbc:mysql://localhost:3306/test</property>
		<property name="user">root</property>
		<property name="password">ghostttt</property>
		<property name="checkoutTimeout">30000</property>
		<property name="initialPoolSize">10</property>
		<property name="maxIdleTime">30</property>
		<property name="maxPoolSize">100</property>
		<property name="minPoolSize">10</property>
		<property name="maxStatements">200</property>
	</defaul-config>
	<!-- 其他的配置节点 -->
	<name-config name="jachin">
		<property name="driverClass">com.mysql.jdbc.Driver</property>
		<property name="jdbcUrl">jdbc:mysql://localhost:3306/test</property>
		<property name="user">root</property>
		<property name="password">ghostttt</property>
		<property name="initialPoolSize">10</property>
		<property name="maxPoolSize">100</property>
	</name-config>
</c3p0-config>
```

在这个配置文件中，配置了两套数据源，<defaul-config> 为默认配置，<name-config name="jachin"> 为自定义配置，一个配置文件中可以有 0-n 个自定义配置节点，当需要使用自定义的配置节点时，只需要给构造方法传入自定义节点的 name 的属性值即可，如：

```java
ComboPooledDataSource("jachin")
```

读取配置文件获取数据源，示例：ComboPooledDataSourceDemo.java

```java
public class ComboPooledDataSourceDemo {
	public static void main(String[] args) {
		ComboPooledDataSource cpds = new ComboPooledDataSource("jachin");
		cpds.getConnection();
	}
}
```



## 5. DBUtils 工具

DBUtils 是一个工具类库，它是操作数据库的一个组件，实现了对 JDBC 的简单封装，能在不影响性能的情路下，极大简化 JDBC 的编码工作。

DBUtils 的核心是 QueryRunner 类和 ResultSetHandler 接口。

### 5.1 QueryRunner 类

该类简化了执行 sql 语句的代码，它与 ResultSetHandler 组合在一起就能完成大部分的数据库操作。

该类提供了一个 带参的构造方法，传入的是 javax.sql.DataSource 对象以此来获取 Connection 对象。针对数据库的不同操作，该类提供了以下方法：

- query(String sql, ResultSetHandler rsh, Object ... params)：查询
- update(String sql, Object ... params)：带参数的增删改
- update(String sql)：不带参数的增删改

### 5.2 ReultSetHandler 接口

该接口用于处理结果集，它可以将结果集中的数据转为不同的形式。根据结果集中的数据类型不同，该接口提供了几种常见的实现类：

- BeanHandler：将结果集中的第一行数据封装到一个对应的 JavaBean 实例中。
- BeanListHandler：将结果集中的每一行数据都封装到一个对应的 JavaBean 实例中，并存放到 List 里。
- ScalarHandler：将结果集中的某一行记录的某一列的数据存储成 Object 对象。

另外，在该接口中还提供了一个 handle(java.sql.ResultSet rs) 方法，可以通过自定义类实现该接口，然后实现 handle() 方法来处理自己想要的结果集形式。

#### 5.2.1 BeanHandler 和 BeanListHandler  

这两个实现类是实际开发中使用得最多的，下面是示例代码：

user 表具有 id，name 和 birth 3个字段。下面是 user 对应的 JavaBean 类：User.java

```java
package com.jachin.dbutils;

public class User {
	private int id;
	private String name;
	private String birth;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", birth=" + birth + "]";
	}
}
```

下面是 BaseDAO.java，实现和数据库相关的操作，目前只有查询：

```java
package com.jachin.dbutils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.commons.dbutils.ResultSetHandler;

/**
 * 数据库操作
 * @author Jachin
 *
 */
public class BaseDAO {
	/**
	 * 优化查询
	 * @param sql 数据库语句
	 * @param rsh 数据库查询返回结果集
	 * @param params 可变参数
	 * @return 
	 * @throws ClassNotFoundException
	 */
	public static Object query(String sql, ResultSetHandler<?> rsh, Object... params) throws ClassNotFoundException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			// JDBCUtils 类请查看笔记第 3 节
			conn = JDBCUtils.getConnection();
			// 预编译 sql
			pstmt = conn.prepareStatement(sql);
			// 将参数传进去
			for(int i = 0; i < params.length; i++){
				pstmt.setObject(i+1, params[i]);
			}
			// 发送 sql
			rs = pstmt.executeQuery();
			// 让调用者去实现对结果集的处理
			Object obj = rsh.handle(rs);
			return obj;
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtils.release(pstmt, conn);
		}
		return rs;
	}
}
```

最后是结果查询测试：ResultSetDemo.java

```java
package com.jachin.dbutils;

import java.util.ArrayList;

import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

public class ResultSetDemo {
	/**
	 * 返回指定一行的结果，使用了 BeanHandler 实现类
	 * @throws ClassNotFoundException
	 */
	public static void testBH() throws ClassNotFoundException {
		String sql = "select * from user where id=?";
		User user = (User) BaseDAO.query(sql, new BeanHandler<Object>(User.class), 1);
		System.out.println(user.toString());
	}

	/**
	 * 返回多行结果的查询，使用了 BeanListHandler 实现类
	 * @throws ClassNotFoundException
	 */
	public static void testBLH() throws ClassNotFoundException {
		String sql = "select * from user";
		@SuppressWarnings("unchecked")
		ArrayList<User> user = (ArrayList<User>) BaseDAO.query(sql, new BeanListHandler<Object>(User.class));
		for (int i = 0; i < user.size(); i++) {
			System.out.println(user.get(i).toString());
		}
	}

	public static void main(String[] args) throws ClassNotFoundException {
		testBH();
		testBLH();
	}
}
```

#### 5.2.2 ScalarHandler 

如果在只需要输出结果集中一行数据的指定字段值，可以使用该实现类，示例代码：

在 ResultSetDemo.java 中加上以下方法：

```java
	public static void testSH() throws ClassNotFoundException {
		String sql = "select * from user where id=?";
		Object user = BaseDAO.query(sql, new ScalarHandler<Object>("name"),2);
		System.out.println(user);
	}
```

### 5.3 使用 BDUtils 实现增删查改

####5.3.1 创建 C3P0Utils 类

该类用于创建数据源：C3P0Utils.java

``` java
public class C3P0Utils {
	private static ComboPooledDataSource dataSource;//创建c3p0连接，整个项目有一个连接池就可以了，设为static只要实例化一次
    static {
        dataSource = new ComboPooledDataSource();
    }
    
    public static DataSource getDataSource() {
        return dataSource;
    }
    public static QueryRunner getQueryRunner(){//创建DButils常用工具类QueryRunner的对象
        return new QueryRunner(dataSource);
    }  
}
```

c3p0-config.xml 配置文件，该文件必须放在 src 路径下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<c3p0-config>
<default-config>
    <property name="user">root</property>
  	<property name="password">ghostttt</property>
    <property name="driverClass">com.mysql.jdbc.Driver</property>
    <property name="jdbcUrl">jdbc:mysql://localhost:3306/test?useSSL=true</property>
   
    <property name="acquireIncrement">50</property>
    <property name="initialPoolSize">100</property>
    <property name="minPoolSize">50</property>
    <property name="maxPoolSize">1000</property>

    <property name="maxStatements">10</property> 
    <property name="maxStatementsPerConnection">5</property>
  </default-config>
</c3p0-config>
```

#### 5.3.2 创建 DBUtilsDAO 类

该类用于实现对数据库表的增删查改基本操作：DBUtilsDAO.java

````java
public class DBUtilsDAO {
	// 查询所有，返回 List 集合
	// 查询单个，返回对象
	// 增删改操作

	@SuppressWarnings("rawtypes")
	public List findAll() throws SQLException {
		// 创建 QueryRunner 对象，写 sql 语句，调用 query 方法，返回结果
		QueryRunner queryRunner = C3P0Utils.getQueryRunner();
		String sql = "select * from user";
		return (List) queryRunner.query(sql, new BeanListHandler<>(User.class));
	}

	public User find(int id) throws SQLException {
		// 创建 QueryRunner 对象，写 sql 语句，调用 query 方法，返回结果
		QueryRunner queryRunner = C3P0Utils.getQueryRunner();
		String sql = "select * from user where id=?";
		return (User) queryRunner.query(sql, new BeanHandler<>(User.class), new Object[] { id });
	}

	public Boolean insert(User user) throws SQLException {
		// 创建 QueryRunner 对象，写 sql 语句，调用 update 方法，返回结果
		QueryRunner queryRunner = C3P0Utils.getQueryRunner();
		String sql = "insert into user (name, birth) values (?,?)";
		int num = queryRunner.update(sql,  new Object[] { user.getName(),user.getBirth() });
		if (num > 0)
			return true;
		return false;
	}

	public Boolean update(User user) throws SQLException {
		// 创建 QueryRunner 对象，写 sql 语句，调用 query 方法，返回结果
		QueryRunner queryRunner = C3P0Utils.getQueryRunner();
		String sql = "update user set name=?, birth=? where id=?";
		int num = queryRunner.update(sql, new Object[] { user.getName(),user.getBirth(),user.getId() });
		if (num > 0)
			return true;
		return false;
	}

	public Boolean delete(int id) throws SQLException {
		// 创建 QueryRunner 对象，写 sql 语句，调用 query 方法，返回结果
		QueryRunner queryRunner = C3P0Utils.getQueryRunner();
		String sql = "delete from user where id=?";
		int num = queryRunner.update(sql, id);
		if (num > 0)
			return true;
		return false;
	}
}
````

#### 5.3.3 测试

进行增删查改的测试，ResultSetDemo.java：

```java
public class ResultSetDemo {
	private static DBUtilsDAO dao = new DBUtilsDAO();
	// 插入
	public static void testInsert() throws SQLException{
		User user = new User();
		user.setName("Mike");
		user.setBirth("1995-04-25");
		if(dao.insert(user)){
			System.out.println("1 条记录插入成功。");
		}else{
			System.err.println("插入失败。");
		}
	}
	// 修改
	public static void testUpdate() throws SQLException{
		User user = new User();
		user.setName("Mike");
		user.setBirth("1995-04-28");
		user.setId(8);
		if(dao.update(user)){
			System.out.println("1 条记录修改成功。");
		}else{
			System.err.println("修改失败。");
		}
	}
	// 删除
	public static void testDelete() throws SQLException{
		if(dao.delete(8)){
			System.out.println("1 条记录删除成功。");
		}else{
			System.err.println("删除失败。");
		}
	}
	// 查单
	public static void testFind(int id) throws ClassNotFoundException, SQLException {
		User user = (User) dao.find(id);
		System.out.println(user.toString());
	}
	// 查多
	public static void testFindAll() throws ClassNotFoundException, SQLException {
		@SuppressWarnings("unchecked")
		ArrayList<User> user = (ArrayList<User>) dao.findAll();
		for (int i = 0; i < user.size(); i++) {
			System.out.println(user.get(i).toString());
		}
	}
	public static void main(String[] args) throws SQLException, ClassNotFoundException {
		testFindAll();
		testInsert();
		testFindAll();
		testUpdate();
		testFindAll();
		testDelete();
		testFindAll();
	}
}
```

## 6. 编写通用的 DAO

























