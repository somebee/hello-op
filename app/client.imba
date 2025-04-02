import 'op'
import 'op/ui'

import './models'

OP.init!

tag sign-in
	username = ''

	<self>
		<input bind=username>
		<button @click=OP.server.login(username)> "Sign in"

tag data-inspector

	<self>
		for field in data.$shape.$inspectable
			<div[d:hcl]>
				<div[w:100px]> field.name
				<.value> String(data[field.name])

		<h2> "Members"
		for member in data.members
			<div> member.name

tag App
	def addOrg
		Org.create(name: "Hello!")

	def render
		<self>
			<header[bg:blue6 d:hcc p:3]>
				<sign-in> unless OP.user
				<div[fl:1]> "Agent: {OP.agent..id}"
				<div[fl:1]> "Server: {OP.server..id}"
				<button @click=addOrg> "New Org"

			<div[d:htc]>
				<nav[w:200px bg:red3]>
					css section p:4
						h2 fw:bold

					<section>
						<h2> "Orgs"
						<ul> for org in Org.all!
							<op data=org @opdrop(org) @opdrag(org) @click=(OP.app.focus = org)> `{org.id} - {org.name} - {org.secret}`
					
					<section odata=100>
						<h2> "Users"
						<ul> for user in OPUser.all!
							<li @opdrag(user)> `{user.name}`

				<main[fl:1]>
					if OP.app.focus
						<data-inspector data=OP.app.focus>
						<div> "Note: {OP.app.focus.note}"
						<div> "Pov Note: {OP.app.focus.povnote}"

OP.ui
imba.mount <App>