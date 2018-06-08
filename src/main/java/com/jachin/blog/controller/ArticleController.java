package com.jachin.blog.controller;

import com.jachin.blog.bean.Msg;
import com.jachin.blog.po.Article;
import com.jachin.blog.service.ArticleService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ArticleController {

    private ArticleService articleService = new ArticleService();

    //  根据 tag id 获取年份列表
    @RequestMapping("/years.do")
    @ResponseBody
    public Msg getYears(@RequestParam("tagid")String tagId){
        List<String> years= articleService.getYears(tagId);
        return Msg.success().add("years",years);
    }


    // 根据便签 id 和年份获取文章列表
    @RequestMapping("/articles.do")
    @ResponseBody
    public Msg getArticles(@RequestParam("tagid")String tagId,@RequestParam("year")String year){
        List<Article> articles = articleService.getArticles(tagId, year);
        return Msg.success().add("articles",articles);
    }

    // 根据文章 id 来获取文章
    @RequestMapping("/article.do")
    @ResponseBody
    public Msg getArticle(@RequestParam("articleid")Integer artId){
        Article article = articleService.getArticle(artId);
        return Msg.success().add("article",article);
    }
}
