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

    @RequestMapping("/articles.do")
    @ResponseBody
    public Msg getArticles(@RequestParam("tagid")String tagId,@RequestParam("year")String year){
        List<Article> articles = articleService.getArticles(tagId, year);
        return Msg.success().add("articles",articles);
    }

}
