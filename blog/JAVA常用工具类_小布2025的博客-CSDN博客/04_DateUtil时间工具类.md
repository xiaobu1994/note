# DateUtil时间工具类

> 原创 最新推荐文章于 2024-08-26 14:35:51 发布 · 公开 · 1.7k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/87930760

```java
package com.xiaobu.base.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class DateUtil {

  private static final   Pattern PATTERN_ = Pattern.compile("^\\d{4}(\\-)\\d{2}(\\-)\\d{2}$");

    /**
     * 当前操作系统日期 Calendar.
     */
    private static Calendar calendar = new GregorianCalendar(TimeZone.getDefault());
    /**
     * 日期格式 默认：yyyyMMdd
     */
    private static final String PATTERN = "yyyyMMdd";

    /**
     * @author xiaobu
     * @date 2018/11/28 14:34
     * @descprition 日期格式 默认：yyyy-MM-dd
     * @version 1.0
     */
    private static final String DATE_PATTERN = "yyyy-MM-dd";
    /**
     * 时间格式 默认：HH:mm:ss
     */
    private static final String TIME_PATTERN = "HH:mm:ss";

    /***
     * @author xiaobu
     * @date 2018/11/28 14:26
     * @descprition 日期格式  yyyy-MM-dd HH:mm:ss
     * @version 1.0
     */
    private static final String DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss";

    /***
     * @author xiaobu
     * @date 2018/11/28 14:26
     * @descprition 日期格式  yyyy-MM-dd HH:mm:ss SSS
     * @version 1.0
     */
    private static final String LONG_DATE_TIME_PATTERN= "yyyy-MM-dd HH:mm:ss SSS";

    /**
     * 年
     */
    private static int year = 0;
    /**
     * 月
     */
    private static int month = 0;
    /**
     * 日
     */
    private static int day = 0;
    /**
     * 时
     */
    private static int hour = 0;
    /**
     * 分
     */
    private static int minute = 0;
    /**
     * 秒
     */
    private static int second = 0;

    /**
     * 静态初始化（默认系统当前日期和时间）
     */
    static {
        year = calendar.get(Calendar.YEAR);
        month = calendar.get(Calendar.MONTH) + 1;
        day = calendar.get(Calendar.DAY_OF_MONTH);
        hour = calendar.get(Calendar.HOUR_OF_DAY);
        minute = calendar.get(Calendar.MINUTE);
        second = calendar.get(Calendar.SECOND);
    }

    /**
     * 构造方法
     */
    public DateUtil() {
        // Do Nothing
    }

    /**
     * @author xiaobu
     * @date 2018/11/28 16:55
     * @return java.lang.String yyyy-MM-dd
     * @descprition  获取当前时间的年月日
     * @version 1.0
     */
    public static String getCurrentLocalTimeToStr(){
        return getLocalTime(DATE_PATTERN);
    }


    /**
     * @author xiaobu
     * @date 2018/11/28 16:55
     * @return java.lang.String yyyy-MM-dd HH:mm:ss
     * @descprition  获取当前时间的年月日
     * @version 1.0
     */
    public static String getCurrentLocalTimeToStr1(){
        return getLocalTime(DATE_TIME_PATTERN);
    }


    /**
     * @author xiaobu
     * @date 2018/11/28 16:55
     * @return java.lang.String yyyy-MM-dd HH:mm:ss SSS
     * @descprition  获取当前时间的年月日
     * @version 1.0
     */
    public static String getCurrentLocalTimeToStr2(){
        return getLocalTime(LONG_DATE_TIME_PATTERN);
    }

    /**
     * @author xiaobu
     * @date 2018/11/28 16:55
     * @return java.lang.String yyyy-MM-dd
     * @descprition  获取当前时间的年月日
     * @version 1.0
     */
    public static String getCurrentDateTimeToStr() {
        return getDateTime(DATE_PATTERN);
    }
    /**
     * @author xiaobu
     * @date 2018/11/28 16:59
     * @return java.lang.String
     * @descprition  获取当前日期 yyyy-MM-dd HH:mm:ss
     * @version 1.0
     */
    public static String getCurrentDateTimeToStr1() {
        return getDateTime(DATE_TIME_PATTERN);
    }

   /**
    * @author xiaobu
    * @date 2018/11/28 16:59
    * @return java.lang.String
    * @descprition  获取当前日期 yyyy-MM-dd HH:mm:ss SSS
    * @version 1.0
    */
    public static String getCurrentDateTimeToStr2() {
        return getDateTime(LONG_DATE_TIME_PATTERN);
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 年
     * @version 1.0
     */
    public static int getYear() {
        return year;
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 年 字符串类型
     * @version 1.0
     */
    public static String getStrYear() {
        return String.valueOf(year);
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 月
     * @version 1.0
     */
    public static int getMonth() {
        return month;
    }

    /**
     * @param strDate yyyyMMdd
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:29
     * @descprition 获取传入时间的年份
     * @version 1.0
     */
    public static int getYear(String strDate) {
        SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
        Date startDate;
        int intYear = 0;
        try {
            startDate = f.parse(strDate);
            Calendar starCal = Calendar.getInstance();
            starCal.setTime(startDate);
            intYear = starCal.get(Calendar.YEAR);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return intYear;
    }

    /**
     * @param strDate yyyyMMdd
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:29
     * @descprition 获取传入时间的月份
     * @version 1.0
     */
    public static int getMonth(String strDate) {
        SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
        Date startDate;
        int intMonth = 0;
        try {
            startDate = f.parse(strDate);
            Calendar starCal = Calendar.getInstance();
            starCal.setTime(startDate);
            intMonth = starCal.get(Calendar.MONTH) + 1;
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return intMonth;
    }

    /**
     * @param strDate yyyyMMdd
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 16:31
     * @descprition 将短时间格式字符串转换为时间 yyyy-MM-dd
     * @version 1.0
     */
    public static String shortToDate(String strDate) {
        return strDate.substring(0, 4) + "-" + strDate.substring(4, 6) + "-" + strDate.substring(6);
    }

    /**
     * @param strTime HHmmss
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 16:35
     * @descprition 将短时间格式字符串转换为时间 HH:mm:ss
     * @version 1.0
     */
    public static String shortToTime(String strTime) {
        return strTime.substring(0, 2) + ":" + strTime.substring(2, 4) + ":" + strTime.substring(4);
    }

  /**
   * @author xiaobu
   * @date 2018/11/28 17:17
   * @return java.lang.String
   * @descprition   获取系统当前日期---月
   * @version 1.0
   */
    public static String getStrMonth() {
        return month >= 10 ? String.valueOf(month) : "0"
                + String.valueOf(month);
    }
    /**
     * @author xiaobu
     * @date 2018/11/28 17:29
     * @param date Date
     * @descprition  获取这是这周的第一天
     * @version 1.0
     */
    public static int getWeek(Date date) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        dayOfWeek = dayOfWeek - 1;
        if (dayOfWeek == 0) {
            dayOfWeek = 7;
        }
        return dayOfWeek;
    }

   /**
    * @author xiaobu
    * @date 2018/11/28 17:16
    * @return int
    * @descprition   获取系统当前日期---日
    * @version 1.0
    */
    public static int getDay() {
        return day;
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 天
     * @version 1.0
     */
    public static String getStrDay() {
        return day < 10 ? "0" + String.valueOf(day) : String.valueOf(day);
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 小时
     * @version 1.0
     */
    public static int getHour() {
        return hour;
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 分
     * @version 1.0
     */
    public static int getMinute() {
        return minute;
    }

    /**
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:24
     * @descprition 获取系统时间 秒
     * @version 1.0
     */
    public static int getSecond() {
        return second;
    }

    /**
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 16:22
     * @descprition 获取当前的年月日 yyyyMMdd
     * @version 1.0
     */
    public static String getDate() {
        SimpleDateFormat format = new SimpleDateFormat(PATTERN);
        return format.format(System.currentTimeMillis());
    }

    /**
     * @param pattern 格式
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 16:17
     * @descprition 获取当前时间的字符串时间
     * @version 1.0
     */
    public static String getDateTime(String pattern) {
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        return format.format(System.currentTimeMillis());
    }

    /**
     * @author xiaobu
     * @date 2018/11/28 17:02
     * @param pattern 日期格式
     * @return java.lang.String
     * @descprition  将JDK8的日期格式化
     * @version 1.0
     */
    public static String getLocalTime(String pattern){
        DateTimeFormatter df = DateTimeFormatter.ofPattern(pattern);
        return df.format(LocalDateTime.now());
    }

    /**
     * @param strdate 格式yyyymmdd
     * @return boolean
     * @author xiaobu
     * @date 2018/11/28 16:14
     * @descprition 判断给定日期（是否在系统日期之前，是（或等于）：true，否：false
     * @version 1.0
     */
    public static boolean isBefore(String strdate) {
        Calendar cal = parseCalendar(strdate);
        assert cal != null;
        return cal.before(calendar);
    }

    /**
     * 功能描述：判断给定的两个日期的前后。strdate1在strdate2之前（或同一天），返回true，反之，false
     *
     * @param strdate1 日期1
     * @param strdate2 日期2
     * @return boolean
     */
    public static boolean isBefore(String strdate1, String strdate2) {
        Calendar cal1 = parseCalendar(strdate1);
        Calendar cal2 = parseCalendar(strdate2);
        return cal1.before(cal2);
    }

    /**
     * 功能描述：计算在当前系统日期增加或减少 n 天后的日期
     *
     * @param days 增加或减少的天数，正数增加，反之减少
     * @date 2008-11-24
     */
    public static String addByDay(int days) {
        Calendar calendar1 = new GregorianCalendar(TimeZone
                .getDefault());
        calendar1.add(Calendar.DATE, days);
        SimpleDateFormat format = new SimpleDateFormat(PATTERN);
        Date date = calendar1.getTime();
        return format.format(date);
    }

    /**
     * 功能描述：计算在给定的日期加上或减去 n 天后的日期
     *
     * @param datestr 给定的日期
     * @param days    正数增加，反之减少
     * @return String
     */
    public static String addByDay(String datestr, int days) {
        Calendar cal = parseCalendar(datestr);
        assert cal != null;
        cal.add(Calendar.DATE, days);
        SimpleDateFormat format = new SimpleDateFormat(PATTERN);
        Date date = cal.getTime();
        return format.format(date);
    }

    /**
     * 功能描述：计算在给定的日期加上或减去 n 天后的日期
     * @param datestr 给定的日期
     * @param days    正数增加，反之减少 格式  yyyyMMdd/yyyy-MM-dd
     * @return String
     */
    public static String addByDay(String datestr, int days, String pattern) {
        Calendar cal = parseCalendar(datestr);
        assert cal != null;
        cal.add(Calendar.DATE, days);
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        Date date = cal.getTime();
        return format.format(date);
    }

    public static String addBySecond(String datestr, int seconds, String pattern) {
        Calendar cal = parseCalendar(datestr);
        assert cal != null;
        cal.add(Calendar.SECOND, seconds);
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        Date date = cal.getTime();
        return format.format(date);
    }


    /**
     * 功能描述：获得给定日期与系统当前日期之间的天数
     * @param strdate 给定的日期字符串
     * @return long 天数
     * @date 2008-11-21
     */
    public static long getDaysDiffSystem(String strdate,String pattern) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        Date date=null;
        try {
            date= simpleDateFormat.parse(strdate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        assert date != null;
        long millis = date.getTime() - System.currentTimeMillis();
        return millis / (24L * 60L * 60L * 1000L);
    }


    /**
     * 功能描述：获得给定日期与系统当前日期之间的月数，不记天数
     * @param strdate 给定的日期字符串
     * @return long 月数
     * @date 2008-11-21
     */
    private static long getMonths(String strdate) {
        long months = getMonth() - Integer.parseInt(strdate.substring(4, 6));
        long years = getYear() - Integer.parseInt(strdate.substring(0, 4));
        if (!isBefore(strdate)) {
            months = -months;
            years = -years;
        }
        if (months >= 0) {
            return years * 12 + months;
        } else {
            return (years - 1) * 12 + months + 12;
        }
    }


    /**
     * 功能描述：获得给定日期与系统当前日期之间的月数和天数
     *
     * @param strdate 给定的日期字符串
     * @return long[] 下标0月数，1天数
     * @date 2008-11-21
     */
    public static long[] getMonthsAndDays(String strdate) {
        long m = getMonths(strdate);
        int d = getDay() - Integer.parseInt(strdate.substring(6, 8));
        String date = "";
        if (!isBefore(strdate)) {
            d = -d;
            date = strdate;
        } else {
            date = getDate();
        }
        while (d < 0) {
            m--;
            d += getDaysOfMonth(date);
        }
        long[] md = {m, d};
        return md;
    }


    /**
     * @param strdate 字符串
     * @return boolean
     * @author xiaobu
     * @date 2018/11/28 16:48
     * @descprition 判断字符串是否可以转换为日期型 是：true，否：false
     * @version 1.0
     */
    public static boolean isDateStr(String strdate) {
        if (strdate.length() != 8) {
            return false;
        }

        String reg = "^(\\d{4})((0([1-9]{1}))|(1[012]))((0[1-9]{1})|([1-2]([0-9]{1}))|(3[0|1]))$";

        if (Pattern.matches(reg, strdate)) {
            reg = null;
            return getDaysOfMonth(strdate) >= Integer.parseInt(strdate
                    .substring(6, 8));
        } else {
            return false;
        }
    }

    /**
     * @param strdate 预判断年 格式yyyymmdd 或 yyyy
     * @return boolean
     * @author xiaobu
     * @date 2018/11/28 16:47
     * @descprition 判断是否是闰年（年限1000--9999）是：true，否：false
     * @version 1.0
     */
    public static boolean isLeapYear(String strdate) {
        int y = Integer.parseInt(strdate.substring(0, 4));
        if (y <= 999) {
            return false;
        }
        if (y % 400 == 0 || (y % 4 == 0 && y % 100 != 0)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @param strdate 日期 格式：yyyymmdd 或 yyyymm
     * @return int
     * @author xiaobu
     * @date 2018/11/28 16:46
     * @descprition 获取某一月份的天数
     * @version 1.0
     */
    public static int getDaysOfMonth(String strdate) {
        int m = Integer.parseInt(strdate.substring(4, 6));
        switch (m) {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                return 31;
            case 4:
            case 6:
            case 9:
            case 11:
                return 30;
            case 2:
                if (isLeapYear(strdate)) {
                    return 29;
                } else {
                    return 28;
                }
            default:
                return 0;
        }
    }


    /**
     * @param strdate 字符串日期 格式 yyyyMMdd
     * @return java.util.Calendar
     * @author xiaobu
     * @date 2018/11/28 16:07
     * @descprition 把字符串日期转Calendar 对象
     * @version 1.0
     */
    public static Calendar parseCalendar(String strdate) {
        if (isDateStr(strdate)) {
            int year = Integer.parseInt(strdate.substring(0, 4));
            int month = Integer.parseInt(strdate.substring(4, 6)) - 1;
            int day = Integer.parseInt(strdate.substring(6, 8));
            return new GregorianCalendar(year, month, day);
        } else {
            return null;
        }
    }

    /**
     * @param strdate 传入的字符串日期, pattern 格式
     * @return java.util.Date
     * @author xiaobu
     * @date 2018/11/28 16:05
     * @descprition 将字符串转换为Date型日期 日期格式yyyymmdd
     * @version 1.0
     */
    public static Date parseDate(String strdate, String pattern) {
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        Date d = null;
        try {
            d = format.parse(strdate);
        } catch (Exception pe) {
            pe.printStackTrace();
        }
        return d;
    }


    /**
     * @param begin 开始日期, end 结束日期, betweenValue 中间值, DateFormat 日期格式, boundaryValue 是否包含边界值
     * @return boolean
     * @author xiaobu
     * @date 2018/11/28 16:04
     * @descprition 判断某个值是否处于两个日期之间
     * @version 1.0
     */
    public static boolean isBetween(String begin, String end,
                                    String betweenValue, String DateFormat, boolean boundaryValue) {
        boolean flag = false;
        SimpleDateFormat dateFormat = new SimpleDateFormat(DateFormat);


        try {
            Date beginDate = dateFormat.parse(begin);
            Date endDate = dateFormat.parse(end);
            Date betweenDate = dateFormat.parse(betweenValue);
            if (betweenDate.after(beginDate) && betweenDate.before(endDate)) {
                flag = true;
            }
            if (boundaryValue) {
                if (betweenDate.compareTo(beginDate) == 0) {
                    flag = true;
                }
                if (betweenDate.compareTo(endDate) == 0) {
                    flag = true;
                }
            }

        } catch (ParseException e) {
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * @param tempdate yyyyMMdd, days, format 自定义
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 15:51
     * @descprition
     * @version 1.0
     */
    public static String addDay(String tempdate, int days, String format) {
        int year = Integer.parseInt(tempdate.substring(0, 4));
        int month = 0;
        int day = 0;
        String sMonth = tempdate.substring(4, 6);
        String sDay = tempdate.substring(6, 8);
        if ("0".equals(sMonth.substring(0, 1))) {
            month = Integer.parseInt(tempdate.substring(5, 6));
        } else {
            month = Integer.parseInt(tempdate.substring(4, 6));
        }
        if ("0".equals(sDay.substring(0, 1))) {
            day = Integer.parseInt(tempdate.substring(7, 8));
        } else {
            day = Integer.parseInt(tempdate.substring(6, 8));
        }

        GregorianCalendar firstFlight = new GregorianCalendar(year, month - 1,
                day);

        DateFormat df = new SimpleDateFormat(format);

        Date date = firstFlight.getTime();

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DAY_OF_MONTH, days);
        return df.format(cal.getTime());
    }

    /**
     * @param begin, end, format]
     * @return long
     * @author xiaobu
     * @date 2018/11/28 15:35
     * @descprition 如果结束日期小余开始日期返回-1 相等返回0否则返回两个日期之间的天数
     * @version 1.0
     */
    public static long getDays(String begin, String end, String format) {
        long datanumber = 0;
        SimpleDateFormat df = new SimpleDateFormat(format);
        long lEnd;
        long lBegin;
        try {
            lEnd = df.parse(end).getTime();
            lBegin = df.parse(begin).getTime();
            long temp = lEnd - lBegin;
            datanumber = temp / (1000L * 60L * 60L * 24L);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (datanumber < 0) {
            datanumber = -1;
        }
        return datanumber;
    }

  /**
   * @author xiaobu
   * @date 2018/11/28 16:54
   * @param begin, end, format
   * @return boolean
   * @descprition   判断end是不是在begin之后.是返回true不是返回false
   * @version 1.0
   */
    public static boolean isAfter(String begin, String end, String format) {
        boolean flag = false;
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        try {
            Date beginDate = dateFormat.parse(begin);
            Date endDate = dateFormat.parse(end);
            flag = endDate.after(beginDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return flag;
    }

 /**
  * @author xiaobu
  * @date 2018/11/28 16:53
  * @param begin 日期, end 日期, format 格式]
  * @return int
  * @descprition   begin > end 返回 -1，begin = end 返回 0，begin < end 返回 1.
  * @version 1.0
  */
    public static int compareTo(String begin, String end, String format) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        int flag = 0;
        try {
            Date beginDate = dateFormat.parse(begin);
            Date endDate = dateFormat.parse(end);
            flag = endDate.compareTo(beginDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * @author xiaobu
     * @date 2018/11/28 16:52
     * @param year String yyyy
     * @return java.lang.String
     * @descprition   获得一年的天数
     * @version 1.0
     */
    public static String getDaysOfYear(String year) {
        if (isLeapYear(year)) {
            return "366";
        } else {
            return "365";
        }

    }


    /**
     * 验证日期格式是否符合xxxx-xx-xx这种格式（只验证格式，不验证日期是否正确）
     *
     * @param date 日期字符串
     * @return 符合：true 不符合：false
     */
    public static boolean testDate(String date) {
        boolean isDate = false;
        Matcher matcher = PATTERN_.matcher(date);
        isDate = matcher.matches();
        return isDate;
    }


    /**
     * @param begin1, end1, format
     * @return int
     * @author xiaobu
     * @date 2018/11/28 15:42
     * @descprition 获取两个日期相隔的月数 用Calendar操作的
     * @version 1.0
     */
    public static int getMonth(String begin1, String end1, String format)
            throws ParseException {

        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        Date s = dateFormat.parse(begin1);
        Date e = dateFormat.parse(end1);

        if (s.after(e)) {
            Date t = s;
            s = e;
            e = t;
        }
        Calendar start = Calendar.getInstance();
        start.setTime(s);
        Calendar end = Calendar.getInstance();
        end.setTime(e);
        Calendar temp = Calendar.getInstance();
        temp.setTime(e);
        temp.add(Calendar.DATE, 1);

        int y = end.get(Calendar.YEAR) - start.get(Calendar.YEAR);
        int m = end.get(Calendar.MONTH) - start.get(Calendar.MONTH);

        if ((start.get(Calendar.DATE) == 1) && (temp.get(Calendar.DATE) == 1)) {// 前后都不破月
            return y * 12 + m + 1;
        } else if ((start.get(Calendar.DATE) != 1)
                && (temp.get(Calendar.DATE) == 1)) {// 前破月后不破月
            return y * 12 + m;
        } else if ((start.get(Calendar.DATE) == 1)
                && (temp.get(Calendar.DATE) != 1)) {// 前不破月后破月
            return y * 12 + m;
        } else {// 前破月后破月
            return (y * 12 + m - 1) < 0 ? 0 : (y * 12 + m - 1);
        }
    }

    /**
     * @param begin1 , end1, format
     * @return int
     * @author xiaobu
     * @date 2018/11/28 15:23
     * @descprition 获取两个日期的相隔天数
     * @version 1.0
     */
    public static int getDay(String begin1, String end1, String format) {

        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        Date startDate = null;
        Date endDate = null;
        try {
            startDate = dateFormat.parse(begin1);
            endDate = dateFormat.parse(end1);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        assert startDate != null;
        assert endDate != null;
        if (startDate.after(endDate)) {
            Date t = startDate;
            startDate = endDate;
            endDate = t;
        }
        return (int) ((getMillis(endDate) - getMillis(startDate)) / (24 * 3600 * 1000));
    }

    public static long getMillis(Date date){
        return date.getTime();
    }
    /**
     * @param s Calendar.getInstance()
     * @return int
     * @author xiaobu
     * @date 2018/11/28 15:22
     * @descprition 获取当前日期与月底相隔几天
     * @version 1.0
     */
    public static int getDayP(Calendar s) {
        int d;
        if (s.get(Calendar.MONTH) == Calendar.FEBRUARY && s.get(Calendar.YEAR) % 4 == 0
                && s.get(Calendar.YEAR) % 100 != 0) {// 闰年2月
            d = 29;
        } else {
            Map<Integer, Integer> m = new HashMap<Integer, Integer>();
            m.clear();
            m.put(1, 31);
            m.put(3, 31);
            m.put(5, 31);
            m.put(7, 31);
            m.put(8, 31);
            m.put(10, 31);
            m.put(12, 31);
            m.put(4, 30);
            m.put(6, 30);
            m.put(9, 30);
            m.put(11, 30);
            m.put(2, 28);
            d = m.get(s.get(Calendar.MONTH) + 1);
        }
        return d - s.get(Calendar.DATE);
    }


    /**
     * @param begin 2018-11-28, end 2018-09-22  yyyy-MM-dd
     * @return int
     * @author xiaobu
     * @date 2018/11/28 15:13
     * @descprition 根据传入的日期 计算两个日期相隔的月数
     * @version 1.0
     */
    public static int getMonths(String begin, String end) {
        int iMonth = 0;
        int flag = 0;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date date1 = dateFormat.parse(begin);
            Date date2 = dateFormat.parse(end);
            Calendar objCalendarDate1 = Calendar.getInstance();
            objCalendarDate1.setTime(date1);

            Calendar objCalendarDate2 = Calendar.getInstance();
            objCalendarDate2.setTime(date2);

            if (objCalendarDate2.equals(objCalendarDate1)) {
                return 0;
            }
            //比较下大小如果objCalendarDate1大于objCalendarDate2 则互换下
            if (objCalendarDate1.after(objCalendarDate2)) {
                Calendar temp = objCalendarDate1;
                objCalendarDate1 = objCalendarDate2;
                objCalendarDate2 = temp;
            }
            if (objCalendarDate2.get(Calendar.DAY_OF_MONTH) < objCalendarDate1.get(Calendar.DAY_OF_MONTH)) {
                flag = 1;
            }
            if (objCalendarDate2.get(Calendar.DAY_OF_MONTH) == 30 && objCalendarDate1.get(Calendar.DAY_OF_MONTH) == 31
                    && objCalendarDate2.get(Calendar.YEAR) >= objCalendarDate1.get(Calendar.YEAR)) {
                flag = 0;// 草川禾 20110120 添加 处理特殊情况 此处是唯一一种
            }
            // 即结束日期是30天，开始日期日31时计划日期[)情况
            if (objCalendarDate2.get(Calendar.DAY_OF_MONTH) == 28 && objCalendarDate1.get(Calendar.DAY_OF_MONTH) == 31
                    && objCalendarDate2.get(Calendar.YEAR) >= objCalendarDate1.get(Calendar.YEAR)) {
                flag = 0;// 草川禾 20110120 添加 处理特殊情况 此处是唯一一种
            }
            // 即结束日期是30天，开始日期日31时计划日期[)情况
            if (objCalendarDate2.get(Calendar.DAY_OF_MONTH) == 28 && objCalendarDate1.get(Calendar.DAY_OF_MONTH) == 29
                    && objCalendarDate2.get(Calendar.YEAR) >= objCalendarDate1.get(Calendar.YEAR)) {
                flag = 0;// 处理getMonthsAndDays("20120229", "20130228")这种情况
            }
            if (objCalendarDate2.get(Calendar.DAY_OF_MONTH) == 29 && objCalendarDate1.get(Calendar.DAY_OF_MONTH) == 31
                    && objCalendarDate2.get(Calendar.YEAR) >= objCalendarDate1.get(Calendar.YEAR)) {
                flag = 0;// 草川禾 20110120 添加 处理特殊情况 此处是唯一一种
            }
            // 即结束日期是30天，开始日期日31时计划日期[)情况
            if (objCalendarDate2.get(Calendar.YEAR) > objCalendarDate1.get(Calendar.YEAR)) {
                iMonth = ((objCalendarDate2.get(Calendar.YEAR) - objCalendarDate1.get(Calendar.YEAR)) * 12 + objCalendarDate2.get(Calendar.MONTH) - flag)
                        - objCalendarDate1.get(Calendar.MONTH);
            } else {
                iMonth = objCalendarDate2.get(Calendar.MONTH) - objCalendarDate1.get(Calendar.MONTH) - flag;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return iMonth;
    }

    /**
     * @param beginDate, format]
     * @return boolean
     * @author xiaobu
     * @date 2018/11/28 15:45
     * @descprition 判断一个日期是否该月的月末
     * @version 1.0
     */
    public static boolean isLastDayOfMonth(String beginDate, String format) {
        boolean result = false;
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat(format);
            Date date = dateFormat.parse(beginDate);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.DATE, (calendar.get(Calendar.DATE) + 1));
            if (calendar.get(Calendar.DAY_OF_MONTH) == 1) {
                result = true;
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * @param monStr 201812
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 14:48
     * @descprition 获取下个月份
     * @version 1.0
     */
    public static String getNextMon(String monStr) {
        String result = "";
        int year = Integer.parseInt(monStr.substring(0, 4));
        int mon = Integer.parseInt(monStr.substring(4));

        mon++;
        if (mon == 13) {
            mon = 1;
            year++;
        }

        if (mon > 9) {
            result = year + "" + mon;
        } else {
            result = year + "0" + mon;
        }

        return result;

    }

    /**
     * @param monStr 201811
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/28 14:45
     * @descprition 获取上个月份
     * @version 1.0
     */
    public static String getPreMon(String monStr) {
        String result = "";
        int year = Integer.parseInt(monStr.substring(0, 4));
        int mon = Integer.parseInt(monStr.substring(4, 6));

        mon--;
        if (mon == 0) {
            mon = 12;
            year--;
        }

        if (mon < 10) {
            result = year + "0" + mon;
        } else {
            result = year + "" + mon;
        }
        return result;

    }

    /**
     * @param type 查询类型1.日；2.旬；3.月；4.季;5.半年；6.年, dateStr 201811
     * @return java.lang.String[]
     * @author xiaobu
     * @date 2018/11/28 14:44
     * @descprition
     * @version 1.0
     */
    public static String[] getDateArray(String type, String dateStr) {
        if (dateStr.length() == 6) {
            dateStr += "01";
        }
        String[] dateArray = new String[2];
        String yearStr = dateStr.substring(0, 4);
        String monthStr = dateStr.substring(4, 6);
        String dayStr = dateStr.substring(6, 8);
        if ("1".equals(type)) {//日
            dateArray[0] = dateStr;
            dateArray[1] = dateStr;
        }
        if ("2".equals(type)) {//计算旬
            int d = Integer.parseInt(dayStr);
            if (d >= 1 && d <= 10) {
                dateArray[0] = yearStr + monthStr + "01";
                dateArray[1] = yearStr + monthStr + "10";
            } else if (d >= 11 && d <= 20) {
                dateArray[0] = yearStr + monthStr + "11";
                dateArray[1] = yearStr + monthStr + "20";
            } else {

                dateArray[0] = yearStr + monthStr + "21";
                int y = Integer.parseInt(yearStr);
                if (Integer.parseInt(monthStr) == 12) {//如果本月加1等于12月则需推到下一年
                    y = y + 1;
                    monthStr = "01";
                } else {
                    int monVal = Integer.parseInt(monthStr);
                    monVal++;
                    if (monVal > 9) {
                        monthStr = String.valueOf(monVal);
                    } else {
                        monthStr = "0" + monVal;
                    }
                }


                String s = String.valueOf(y) + monthStr + "01";


                String ss = addByDay(s, -1);//下月第一天减去一天为本月一号

                dateArray[1] = ss;
            }
        }
        if ("3".equals(type)) {//月
            int y = Integer.parseInt(yearStr);

            dateArray[0] = yearStr + monthStr + "01";
            if (Integer.parseInt(monthStr) == 12) {//如果本月加1等于12月则需推到下一年
                y = y + 1;
                monthStr = "01";
            } else {
                monthStr = String.valueOf(Integer.parseInt(monthStr) + 1);

                if (Integer.parseInt(monthStr) < 10) {
                    monthStr = "0" + monthStr;
                }
            }
            String s = String.valueOf(y) + monthStr + "01";
            String ss = addByDay(s, -1);//下月第一天减去一天为本月一号

            dateArray[1] = ss;
        }
        //季
        if ("4".equals(type)) {
            int m = Integer.parseInt(monthStr);
            if (m >= 1 && m <= 3) {
                dateArray[0] = yearStr + "01" + "01";
                dateArray[1] = yearStr + "03" + "31";
            } else if (m >= 4 && m <= 6) {
                dateArray[0] = yearStr + "04" + "01";
                dateArray[1] = yearStr + "06" + "30";
            } else if (m >= 7 && m <= 9) {
                dateArray[0] = yearStr + "07" + "01";
                dateArray[1] = yearStr + "09" + "30";
            } else if (m >= 10 && m <= 12) {
                dateArray[0] = yearStr + "10" + "01";
                dateArray[1] = yearStr + "12" + "31";
            }
        }
        //半年
        if ("5".equals(type)) {
            int m = Integer.parseInt(monthStr);
            if (m >= 1 && m <= 6) {
                dateArray[0] = yearStr + "01" + "01";
                dateArray[1] = yearStr + "06" + "30";
            } else if (m >= 7 && m <= 12) {
                dateArray[0] = yearStr + "07" + "01";
                dateArray[1] = yearStr + "12" + "31";
            }
        }
        //年
        if ("6".equals(type)) {
            dateArray[0] = yearStr + "01" + "01";
            dateArray[1] = yearStr + "12" + "31";
        }
        return dateArray;
    }




    /**
     * @author xiaobu
     * @date 2019/2/26 10:07
     * @param unixTime , formats]
     * @return java.lang.String
     * @descprition  将10位unix时间戳(精确度为秒)转时间字符串
     * @version 1.0
     */
    public static String unixtime2date(long unixTime, String formats){
        long timestamp =unixTime*1000;
        return timestamp2date(timestamp,formats);
    }



    /**
     * @author xiaobu
     * @date 2019/2/26 10:08
     * @param timestamp , formats]
     * @return java.lang.String
     * @descprition  将13位的时间戳(精确度为毫秒)转时间字符串
     * @version 1.0
     */
    public static String timestamp2date(long timestamp, String formats){
        return new SimpleDateFormat(formats).format(new Date(timestamp));
    }


    /**
     * @author xiaobu
     * @date 2019/2/26 10:24
     * @param strDate, formats]
     * @return long
     * @descprition  时间字符串转时间戳
     * @version 1.0
     */
    public long strdate2timestamp(String strDate, String formats){
        try {
            return   new SimpleDateFormat(formats).parse(strDate).getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0;
    }


    /**
     * @author xiaobu
     * @date 2019/2/26 10:24
     * @param strDate , formats]
     * @return long
     * @descprition  时间字符串转unix时间戳
     * @version 1.0
     */
    public long strdate2unixtime(String strDate, String formats){
        long timeStamp = strdate2timestamp(strDate, formats);
        return timeStamp!=0  ? (timeStamp/1000) : 0;
    }

}
```