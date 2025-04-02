global class Note < OPEmbed

global class Org < OPObject
	id @key.r(OPANYONE).c(OPSRV)
	creator @ref(OPUser).as(OPOWNER) = OP.user
	members @refs(OPUser).as(OPMEMBER)
	name @string.w(OPANYONE)
	secret @string.r(OPOWNER | OPMEMBER)

	note @text.local
	sessionnote @text.session
	povnote @text.pov

	notes @embeds(Note)

	add_member @action(OPUser).dnd.x(OPOWNER) do(user)
		L 'add member!'
		members.add(user)

	add_related_org @action(Org).dnd.x(OPOWNER) do(org\Org)
		L 'add_related_org',org

		let note = org.notes.at(0)


global class Doc < OPObject
	id @key.r(OPOWNER | OPMEMBER)
	owner @ref(Org).parent.vias([OPOWNER]: OPOWNER,[OPMEMBER]: OPMEMBER)
	body @text.r(OPOWNER)

extend class OPServer

	deactivate @action.rpc do
		L 'called deactivate on server',id

	###
	Action for this example app that logs in with a name.
	Create new user if we cannot find a user with this name.
	###
	login @action.rpc do(name)
		OP.sudo do
			let user = await OPUser.find(name: name)
			user ||= await OPUser.create(name: name)
			OP.session.login(user)

# Creating a model type for the app itself
# Going to be built-in type in OP soon
extend class OPApp
	focus @ref(OPObject).session
	notes @embeds(Note).local

	data @pub do(pub)
		pub.add await OPUser.all!
		pub.add await Org.all!
		pub.add await Doc.all!

		# for type of OP.tables
		# 	continue if type.name.startsWith('OP') and type.name isnt ('OPSession' or 'OPUser')
		# 	L 'include',type.name
		# 	await type.fetch-all!
		# 	pub.add(type.all!)
		return