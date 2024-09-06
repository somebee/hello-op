import 'op'
import './models'

tag App

	def	add-match
		Match.create(desc: "Another match")

	def render
		<self>
			<div> "Session is {OP.agent..id}"
			<div> "Found {Match.all!.size} matches"
			<button @click=add-match> "Add match"

			<ul> for item in Match.all(!&.deleted?)
				<li> `{item.id} - {item.desc} - {item.deleted?}`


imba.mount <App>