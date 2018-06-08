package com.jachin.blog.test;

import com.jachin.blog.mapper.ArticleMapper;
import com.jachin.blog.mapper.TagMapper;
import com.jachin.blog.po.Article;
import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Testt {

    private ApplicationContext ioc =
            new ClassPathXmlApplicationContext("classpath:applicationContext.xml");

    private TagMapper tagMapper = (TagMapper) ioc.getBean("tagMapper");

    private ArticleMapper articleMapper = (ArticleMapper) ioc.getBean("articleMapper");

    @Test
    public void test(){
        Article article = new Article();
//        article.setTitle();
        System.out.println(articleMapper.selectYears("1"));
    }

}
