package com.jachin.blog.service;

import com.jachin.blog.mapper.TagMapper;
import com.jachin.blog.po.Tag;
import com.jachin.blog.po.TagExample;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

public class TagService {

    private ApplicationContext ioc =
            new ClassPathXmlApplicationContext("classpath:applicationContext.xml");

    private TagMapper tagMapper = (TagMapper) ioc.getBean("tagMapper");

    public List<Tag> getTags(String kind){
        TagExample tagExample = new TagExample();
        TagExample.Criteria criteria = tagExample.createCriteria();
        criteria.andKindEqualTo(kind);
        List<Tag> tags = tagMapper.selectByExample(tagExample);
        return tags;
    }
}
