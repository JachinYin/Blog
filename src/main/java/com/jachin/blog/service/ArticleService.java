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

    // 获取所有年份
    public List<String> getYears(String tagId){
        List<String> years = articleMapper.selectYears(tagId);
        return years;
    }

    // 根据 tagid 和 year 获取文章列表
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

    // 根据文章 id 来获取文章
    public Article getArticle(int artId){
        Article article = articleMapper.selectByPrimaryKey(artId);
        return article;
    }
}
