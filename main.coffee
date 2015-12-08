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
				titleRegex = /<title( itemprop="name")?>(.*?)<\/title>/g
				matches = html.match titleRegex
				if matches
					title = matches[0].replace(/<title( itemprop="name")?>/g, "").replace(/<\/title>/g, "")

				descriptionRegex = /(<meta name="(D|d)escription"(\n  )? content=")(.*?)("( |  )\/>)/
				matches = html.toString().match descriptionRegex
				if matches
					description = matches[0].replace(/(<meta name="(D|d)escription"(\n  )? content=")/g, "").replace(/("( |  )\/>)/g, "")
				else
					description = "check this"

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
				console.log @urls

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
				if value is "check this" then cell.classList.add "u-warning"

			row.appendChild cell

		@el.tableBody.appendChild row

app = new App