register_command('hg', array(
	'description': 'hologram',
	'tabcompleter': closure(@alias, @sender, @args) {
	return(array())
	},
	'executor': closure(@alias, @sender, @args) {
		if(array_size(@args) == 0) {
			tmsg(@sender, colorize('&c/hg help'))
		} else {
		switch(@args[0]) {
			case 'create':
				if(array_size(@args) > 2) {
					@display_args = @args[cslice(2, array_size(@args) - 1)]
					@display = array_implode(@display_args, ' ')
					@return = _create_hologram(@args[1], ploc(@sender), colorize(@display))
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b홀로그램을 생성하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램을 생성할 수 없거나,\n이미 홀로그램이 존재합니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg create <id> <lore>'))
				}
			case 'remove':
				if(array_size(@args) == 2) {
					@return = _remove_hologram(@args[1])
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b홀로그램을 제거하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg remove <id>'))
				}
			case 'update':
				if(array_size(@args) == 2) {
					@return = _update_hologram(@args[1])
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b홀로그램을 새로고침 하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg update <id>'))
				}
			case 'add':
				if(array_size(@args) > 1) {
					if(array_size(@args) == 2) {
						@display = ''
					} else {
						@display_args = @args[cslice(2, array_size(@args) - 1)]
						@display = array_implode(@display_args, ' ')
					}
					@return = _add_hologram_lore(@args[1], colorize(@display))
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b로어를 추가하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg add <id> [lore]'))
				}
			case 'del':
				if(array_size(@args) == 3) {
					@return = _del_hologram_lore(@args[1], @args[2])
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b로어를 제거하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					case 'CastException':
						tmsg(@sender, colorize('&c숫자가 너무 작습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg del <id> <number>'))
				}
			case 'set':
				if(array_size(@args) > 2) {
					if(array_size(@args) == 3) {
						@display = ''
					} else {
						@display_args = @args[cslice(3, array_size(@args) - 1)]
						@display = array_implode(@display_args, ' ')
					}
					@return = _set_hologram_lore(@args[1], @args[2], colorize(@display))
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b로어를 설정하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					case 'CastException':
						tmsg(@sender, colorize('&c숫자가 너무 작습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg set <id> <number> [lore]'))
				}
			case 'tphere':
				if(array_size(@args) == 2) {
					@loc = ploc(@sender)
					@return = _set_hologram_loc(@args[1], @loc)
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b홀로그램을 이동하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg tphere <id>'))
				}
			case 'tp':
				if(array_size(@args) == 5) {
					@loc = array('x': @args[2], 'y': @args[3], 'z': @args[4], 'world': ploc(@sender)['world'])
					@return = _set_hologram_loc(@args[1], @loc)
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b홀로그램을 이동하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c홀로그램이 존재하지 않습니다.'))
					case 'CastException':
					case 'FormatException':
						tmsg(@sender, colorize('&c위치가 올바르지 않습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg tp <id> <x> <y> <z>'))
				}
			case 'help':
				if(array_size(@args) == 1) {
					tmsg(@sender, colorize(' &e===[ CH Hologram Help ]==='))
					tmsg(@sender, colorize('&e/hg createdirectory'))
					tmsg(@sender, colorize('&e/hg create <id> <lore>'))
					tmsg(@sender, colorize('&e/hg remove <id>'))
					tmsg(@sender, colorize('&e/hg update <id>'))
					tmsg(@sender, colorize('&e/hg add <id> [lore]'))
					tmsg(@sender, colorize('&e/hg set <id> <number> [lore]'))
					tmsg(@sender, colorize('&e/hg del <id> <number>'))
					tmsg(@sender, colorize('&e/hg tp <id> <x> <y> <z>'))
					tmsg(@sender, colorize('&e/hg tphere <id>'))
				} else {
					tmsg(@sender, colorize('&c/hg help'))
				}
			case 'createdirectory':
				if(array_size(@args) == 1) {
					@return = _create_holograms_directory()
					switch(@return) {
					case 'Success':
						tmsg(@sender, colorize('&b홀로그램폴더를 생성하였습니다.'))
					case 'IOException':
						tmsg(@sender, colorize('&c폴더가 이미 존재하거나,\n폴더를 생성할수 없습니다.'))
					default:
						tmsg(@sender, colorize('&c'.@return))
					}
				} else {
					tmsg(@sender, colorize('&c/hg createdirectory'))
				}
			default:
				tmsg(@sender, colorize('&c/hg help'))
			}
		}
	}
))