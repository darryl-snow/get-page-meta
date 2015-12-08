Crawler = require "js-crawler"

class App

	constructor: ->

		@el =
			input: document.querySelector ".js-url-input"
			button: document.querySelector ".js-url-submit"
			table: document.querySelector ".js-results-table"
			tableBody: document.querySelector ".js-results-table-body"
			waiting: document.querySelector ".js-waiting"

		@urls = []

		@addEventListeners()

	addEventListeners: ->

		@el.button.addEventListener "click", =>

			@resetTable()
			@hideTable()
			@showWaiting()

			@crawl()

	crawl: ->

		@crawler = new Crawler().configure
			depth: window.depth
			ignoreRelative: false
			maxRequestsPerSecond: 5
			maxConcurrentRequests: 5

		@crawler.crawl
			url: @el.input.value
			success: (page) =>

				title = ""
				description = ""

				html = page.response.body
				titleRegex = /<title itemprop="name">(.*?)<\/title>/g
				matches = html.match(titleRegex)
				if matches
					title = html.match(titleRegex)[0].replace('<title itemprop="name">', '').replace('</title>', '')
				else
					titleRegex = /<title>(.*?)<\/title>/g
					matches = html.match(titleRegex)
					if matches
						title = html.match(titleRegex)[0].replace('<title>', '').replace('</title>', '')

				descriptionRegex = /(<meta name="Description" content=")(.*?)(" \/>)/
				matches = html.match(descriptionRegex)
				if matches
					description = html.match(descriptionRegex)[0].replace('<meta name="Description" content="', '').replace('" />', '')
				else
					descriptionRegex = /(<meta name="description" content=")(.*?)(" \/>)/
					matches = html.match(descriptionRegex)
					if matches
						description = html.match(descriptionRegex)[0].replace('<meta name="description" content="', '').replace('" />', '')

				@urls.push
					url: page.url
					title: title
					description: description

			failure: (page) ->
				# console.error page.status
			finished: (crawledUrls) =>
				@showTable()
				@hideWaiting()
				console.info "Here's what was returned:"
				console.table @urls

	resetTable: ->

		@el.tableBody.innerHTML = ""

	hideTable: ->

		@el.table.classList.add "u-hidden"

	showTable: ->

		for url in @urls
			@addRowToTable(url)

		@el.table.classList.remove "u-hidden"

	hideWaiting: ->

		@el.waiting.classList.add "u-hidden"

	showWaiting: ->

		@el.waiting.classList.remove "u-hidden"

	addRowToTable: (url) ->

		row = document.createElement "tr"

		for key, value of url

			cell = document.createElement "td"

			if key is "url"
				cell.innerHTML = "<a href='" + value + "'>" + value + "</a>"
			else
				cell.innerHTML = value

			row.appendChild cell

		@el.tableBody.appendChild row

app = new App