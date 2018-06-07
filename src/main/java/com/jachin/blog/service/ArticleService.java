package com.jachin.blog.service;

import com.jachin.blog.mapper.ArticleMapper;
import com.jachin.blog.po.Article;
import com.jachin.blog.po.ArticleExample;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

@Controller
public class ArticleService {

    private ApplicationContext ioc =
            new ClassPathXmlApplicationContext("classpath:applicationContext.xml");

    private ArticleMapper articleMapper = (ArticleMapper) ioc.getBean("articleMapper");

    public List<Article> getArticles(String kind, String year){
        List<String> list = new ArrayList<>();
        list.add(kind);
        ArticleExample articleExample = new ArticleExample();
        ArticleExample.Criteria criteria = articleExample.createCriteria();
        criteria.andTagIn(list);
        criteria.andYearEqualTo(year);
        List<Article> articles = articleMapper.selectByExample(articleExample);
        return articles;
    }
}
