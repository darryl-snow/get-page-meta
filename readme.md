# Automated SEO web crawler

Enter a URL and get a list of the Titles and Descriptions for every page on the site. Any unreachable URLs (i.e. broken links) will be reported as errors in the console.

Currently the crawler searches at a depth of 2 levels deep. To change this change the value of the 'depth' variable in the dev console, then run it again. e.g.

```
depth = 3;
``` 

> Note: it will take around 60 seconds (at depth level 2) to load the results because I've throttled the requests so as no to perform a DOS attack on the site :)


Install dependencies:

```
npm install
```

Install this Chrome extension:
https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiD866Bp8zJAhVCOJQKHT1VCxIQFggcMAA&url=https%3A%2F%2Fchrome.google.com%2Fwebstore%2Fdetail%2Fallow-control-allow-origi%2Fnlfbmbojpeacfghkpbjhddihlkkiljbi%3Fhl%3Den&usg=AFQjCNHSUFqc6ylxfxfbWzmmFJ6L5QUvyg&sig2=aG1gUxcJfksj3BvxKrYS9g&bvm=bv.109332125,d.dGo

to compile the JS: 

```
browserify -t coffeeify main.coffee > bundle.js
```

Then open index.html in your browser.