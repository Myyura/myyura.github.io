---

layout: post
title: Kramdown 语法
category:  工具使用
tags: [markdown, kramdown]

---

本文主要介绍了`kramdown`方面的一些语法。具体的可以参看[kramdown语法](http://kramdown.gettalong.org/syntax.html)

### 修饰字词
1. `**强调**`	：	**强调**
2. `*斜体*`		： 	*斜体*
3. 水平线 `- - - -` ： 
4. `{::comment} content ignored {:/comment}`
     试试下面的内容是否显示：

        	{::comment}
        	This is a comment!
        	{:/comment}


5. `[文字链接](link_address)`: [能止]({{ site.BASE_PATH }})
6. 
    `![图片链接](图片的位置)`，如：
	![Images]({{ site.BASE_PATH }}/assets/ico/logo.png){:height="36px" width="56px"}

7. `Blockquotes` :

- `>`	表示单层的blockquote
- `>>`	表示嵌套的blockquote

>A sample blockquote.

>>Nested blockquotes are also possible.
>>上面的空行是必要的，否则，嵌套的`blockquotes`是没有作用的。

### 列表

* 列表方式(`*`)
- 列表方式(`-`)
+ 列表方式(`+`)

1. Sequence(`1. `)
2. Sequence(`2. `)

### 代码

- 代码块

		def what?
			42
		end	

- 代码高亮
  在`kramdown`语法中的语法高亮不是很方便，需要安装`gem install coderay`才可以使用，而且，在github上没有coderay，所以最好使用自带的语法高亮进行显示。在这一点上，没有`vimwiki`方便。

  **采用外接的代码高亮方式：**

  1. 下载[jQuery Syntax Highlighter - Based on Google's Prettify](http://balupton.github.io/jquery-syntaxhighlighter/demo/)
  
  2. `jquery-syntaxhighlighter`设置
 
	   首先配置**jquery.min.js**，因为*jquery-syntaxhighlighter*需要**jquery**的支持

             <script type="text/javascript" src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
	      
	   其次，需要配置**jquery-syntaxhighlighter**，可以下载到本地，然后指向本地。这个网址有时可以访问，有时不可以访问。
            
            <script type="text/javascript" src="http://balupton.github.com/jquery-syntaxhighlighter/scripts/jquery.syntaxhighlighter.min.js"></script>

	   最后，设置**jquery-syntaxhighlighter**的启动参数

            $("pre").addClass("highlight");
            $.SyntaxHighlighter.init({
                    //如果要引用本地的资源，需要打开下面的注释。默认使用在线的资源，具体可参jquery.syntaxhighlighter.js
                    //'prettifyBaseUrl': '/assets/resources/jquery-syntaxhighlighter/prettify',
                    //'baseUrl': '/assets/resources/jquery-syntaxhighlighter'
            });


### Math block

[MathJax](http://www.mathjax.org/) 用来在网页中插入数学公式，这个在本地做的化比较麻烦，可以直接使用在线的方式比较简单。

- 链接	

		<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

- 实例：`$$a^2 + b^2 = c^2$$` 

  $$a^2 + b^2 = c^2$$