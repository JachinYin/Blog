<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2018/5/31
  Time: 9:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.js"></script>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <%
        pageContext.setAttribute("App_Path", request.getContextPath());
    %>

    <link rel="stylesheet" href="public/main.css">
    <link rel="stylesheet" href="public/article.css">
    <style>

    </style>
</head>
<body>
<div class="wrap    ">
    <div class="container left">
        <div class="bg shadow" id="bg">
        </div>
        <div class="nav">
            <br>
            <%--<img src="public/head.png" alt="" class="img-circle" style="width: 50%">--%>
            <h1 id="myName" style="color: aliceblue">柒夕影</h1>
            <p>深自缄默</p>
            <%--<p>缘起一个小伙伴的无心之语，便萌发了创建个人站点的念头，于是便有了这个地方。</p>--%>
            <a id="p1" class="text list">计算机</a><br>
            <a id="p2" class="text list">MineCraft</a><br>
            <a id="p3" class="text list">日常随笔</a><br>
            <a id="p4" class="text list">相关说明</a><br>
        </div>
    </div>

    <div class="container right" id="Lists"></div>
</div>
<script type="text/javascript">
    $(function () {
        Lists(["","","",""],$("#Lists"));
        buildHome();
    });

    function buildHome(){
        $("")
    }

    // 芬兰
    {
        // 分类栏事件，改变背景图片，去对应的页面
        $(".list").click(function () {
            $(".list").each(function () {
                $(this).parent().removeClass("active");
            });
            $(this).parent().addClass("active");
            GoTo($(this));
        });

        function GoTo(ele) {
            var id = ele.attr("id");
            var pngUrl = "url(${App_Path}/public/image/" + id + ".png)";
            $("#bg").css("background-image", pngUrl);

            switch (id) {
                case "p1":
                    toComputer();
                    break;
                case "p2":
                    toMineCraft();
                    break;
                case "p3":
                    toEssay();
                    break;
                case "p4":
                    toAbout();
                    break;
            }

        }

        // 点击柒夕影回到首页
        $("#myName").click(function () {
            var url = "${App_Path}";
            $(window).attr("location", url);
        });

        function toComputer() {
            var kind = [];
            $.ajax({
                url:"tag.do",
                data:"kind=Computer",
                type:"GET",
                success:function (result) {
                    var tags = result.extendInfo.tags;
                    $.each(tags,function (index,tag) {
                        // 标签 id + 标签 name，在显示标签面板时进行处理
                        kind[index] = tag.tagid + tag.name;
                    });
                    buildTag(kind);
                }
            });
        }

        function toMineCraft() {
            var kind = [];
            $.ajax({
                url:"tag.do",
                data:"kind=Game",
                type:"GET",
                success:function (result) {
                    var tags = result.extendInfo.tags;
                    $.each(tags,function (index,tag) {
                        // 标签 id + 标签 name，在显示标签面板时进行处理
                        kind[index] = tag.tagid + tag.name;
                    });
                    buildTag(kind);
                }
            });
        }

        function toEssay() {
            $("#Lists").empty();
            // 根据标签 ID 获取的年份
            var years = ["2018", "2017", "2016"];
            // 按年份构建列表块
            $.each(years, function (index, year) {
                var div = $("<div class='container content'></div>").append($("<h1 class='year'></h1>").append(year));
                // 根据 id 和年份获取文章
                var arts = ["aaa","bbb","ccc","ddd"];
                Lists(arts,div);
                $("#Lists").append(div);
            })
        }

        function toAbout() {
            $("#Lists").empty();
            var div = $("<div class='container'></div>");
            var bg = $("<img src='public/image/aboutBG.Jpeg' width='700'>").appendTo(div);
            $("#Lists").append(div);
        }

    }

    // 构建标签列表
    function buildTag(data) {
        $("#Lists").empty();
        $.each(data, function (index, item) {
            var id = item.substring(0,1);
            var name = item.substring(1,this.length);
            var articlePanel = $("<div class='panel panel-default list-panel'></div>");
            var articleBody = $("<div class='panel-body'></div>");
            var h1 = $("<h1 class='title'></h1>").append(name).attr("id", id).attr("name",name);
            var p = $("<p class='intro'></p>").append("Basic panel example Basic panel example");
            articleBody.append(h1).append(p);
            articlePanel.append(articleBody);
            $("#Lists").append(articlePanel);
        });
    }

    // 构建年份列表
    function toArtList(id) {
        /**
         * 根据标签 id 获取所有的年份
         * 遍历年份，构建每一个列表块
         * 在列表块中，根据 id 和年份来获取结果集，并显示文章列表
         */


        // 根据标签 ID 获取的年份

        $.ajax({
            url:"years.do",
            data:"tagid="+id,
            type:"GET",
            success:function (result) {
                $("#Lists").empty();

                var years = result.extendInfo.years;
                // 按年份构建列表块
                $.each(years, function (index, year) {
                    var div = $("<div class='container content'></div>").append($("<h1 class='year'></h1>").append(year));
                    var arts = [];
                    // 根据 id 和年份获取文章
                    $.ajax({
                        url:"articles.do",
                        data:"tagid="+id + "&year="+year,
                        type:"GET",
                        success:function (result) {
                            var articles = result.extendInfo.articles;
                            $.each(articles, function (index, article) {
                                var art = [];
                                art[0] = article.artid;
                                art[1] = article.title;
                                art[2] = article.intro.substring(0,18);
                                arts[index] = art;
                            });
                            Lists(arts,div);
                            $("#Lists").append(div);
                        }
                    });

                });
            }
        });


    }

    // 显示文章列表
    function Lists(arts,ele) {
        $.each(arts, function (index, art) {
            var articlePanel = $("<div class='panel panel-default col-md-3 list-panel'></div>");
            var articleBody = $("<div class='panel-body'></div>");
            var h1 = $("<h2 class='art'></h2>").append("Article " + art[1]).attr("id", art[0]);
            var intro = $("<p class='intro'></p>").append(art[2]);
            articleBody.append(h1).append(intro);
            articlePanel.append(articleBody);
            ele.append(articlePanel);
        });
    }

    // 显示文章内容
    function buildArt(id){
        /**
         * h1
         * block-quote
         * p
         */
        $.ajax({
            url:"article.do",
            data:"articleid="+id,
            type:"GET",
            success:function (res) {
                $("#Lists").empty();
                var art = res.extendInfo.article;
                var title = art.title;
                var intro = art.intro;
                var cont = art.text;

                var div = $("<div class='artcontent'></div>");
                var title = $("<h1></h1>").append(title);
                var quote = $("<blockquote></blockquote>").append(intro);
                var p = $("<p></p>").append(cont);

                div.append(title).append(quote).append(p);
                $("#Lists").append(div);
            }
        });

    }

    // 所有可以点击的 h1 元素
    $(document).on("click", ".title", function () {
        var id = $(this).attr("id");
        toArtList(id);
    });

    $(document).on("click", ".art", function () {
        var id = $(this).attr("id");
        buildArt(id);
    });

</script>
</body>
</html>
