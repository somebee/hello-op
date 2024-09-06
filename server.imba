import http from 'http'
import 'op'
import './models'

# initialize the OP server
const app = await OP.create-server({
	name: 'hello'
})

###
Just for testing - returns all models!
###
app.pub('common') do(pub)
	for type of OP.tables
		continue if type.name.startsWith('OP')
		await type.fetch-all!
		L 'publishing',type..name,type.all!.size
		pub.add(type.all!)
	return

app.get('/') do(req,res)

	res.sub('common')

	res.html <html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<link rel="icon" href="data:;base64,=">
			<title> "OP Fullstack Playground"
			<style src='*'>
		<body>
			<script type="module" src="./client.imba">

let port = process.env.OP_PORT or 9013

app.listen('::',port) do
	console.log "http://localhost:{port}"


# Temporary hack to make imba auto-reloading of client things work.
if $dev$
	let server = http.createServer do(req,res) res.end('')
	let listener = server.listen(process.env.SERVE_PORT or 3009) do
		if process.argv.has('--quit')
			process.exit!
		else
			process..send('ready')
	imba.serve listener