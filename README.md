# tinypager

Tiny library for pager.

## Install

tinypager detects and supports CommonJS (node, browserify) and AMD (RequireJS). In the absence of those, it adds a object `TinyPager` to the global namespace.

### Bower

coming soon.

Install [`node`](https://nodejs.org/download/) and [`bower`](http://bower.io/) if you haven't already.

Get `tinypager`:

```
$ cd /project
$ bower install tinypager
```

Add this script to your `index.html`:

```
<script type="text/javascript" src="bower_components/tinypager/dist/tinypager.js">
</script>
```

To pull in updates and bug fixes:

```
$ bower update tinypager
```

### Node / npm

coming soon.

```
$ npm install tinypager
```

## Usage

```
var tinyPager = new TinyPager()
tinyPager
	.onPage(function(page) {
	  console.log('page: ' + page)
	})
	.total(50)
	.display(5)
	.current(3)
	.fixed(1)
	.draw(element)
	.draw(element);

```

## License

MIT License

* http://www.opensource.org/licenses/mit-license.php