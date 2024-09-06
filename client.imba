import 'op'
import './models'

tag app

	def	add-match
		Match.create(desc: "Another match")

	def render
		<self>
			<div> "Session is {OP.agent..id}"
			<div> "Found {Match.all!.size} matches"
			<button @click=add-match> "Add match"

imba.mount <app>