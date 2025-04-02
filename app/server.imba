# import http from 'http'

import 'op'
import './models'

# initialize the OP server
const app = await OP.create-server({name: 'hello'})

# The main entrypoint rendering the full application
app.get('/') do(req,res)
	res.private(0s)
	res.sub(OP.app)

	res.html <html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<link rel="icon" href="data:;base64,=">
			<title> "OP"
			<style src='*'>
		<body>
			<script type="module" src="./client.imba">

let port = process.env.OP_PORT or 9013

app.listen('::',port) do
	console.log "http://localhost:{port}"


# Temporary hack to make imba auto-reloading of client things work.
# if false
# 	let server = http.createServer do(req,res) res.end('')
# 	let listener = server.listen(process.env.SERVE_PORT or 3009) do
# 		if process.argv.has('--quit')
# 			process.exit!
# 		else
# 			process..send('ready')
# 	imba.serve listener