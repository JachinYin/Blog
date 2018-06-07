package com.jachin.blog.controller;

import com.jachin.blog.bean.Msg;
import com.jachin.blog.po.Tag;
import com.jachin.blog.service.TagService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class TagController {

    private TagService tagService = new TagService();

    @RequestMapping("/tag.do")
    @ResponseBody
    public Msg getTags(@RequestParam("kind")String kind){
        List<Tag> list = tagService.getTags(kind);
        return Msg.success().add("tags",list);
    }
}
