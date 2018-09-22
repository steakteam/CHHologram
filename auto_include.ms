proc _get_holograms() {
	@hologram_files = list_files('holograms')
	@holograms = array()
	foreach(@hologram_file in @hologram_files) {
		@hologram = replace(@hologram_file, '.json', '')
		@holograms[] = @hologram
	}
	return(@holograms)
}
proc _create_hologram(@id, @loc, @display) {
	@path = 'holograms/'.@id.'.json'
	try {
		create_file(@path)
		@return = 'Success'
	} catch(Exception @exception) {
		@return = @exception['classType']
	}
	if(@return == 'Success') {
		if(is_array(@loc)) {
			if(array_index_exists(@loc, 'x') && array_index_exists(@loc, 'y') && array_index_exists(@loc, 'z') && array_index_exists(@loc, 'world')) {
				spawn_entity('ARMOR_STAND', 1, @loc, closure(@uuid) {
					set_entity_spec(@uuid, array(
						'baseplate': false,
						'gravity': false,
						'marker': true,
						'visible': false
					))
					if(@display != '') {
						set_mob_name(@uuid, @display)
						set_name_visible(@uuid, true)
					}
					@data = array(
						'location': @loc,
						'lores': array(
							array(
								'display': @display,
								'uuid': @uuid
							)
						)
					)
					async_write_file(@path, json_encode(@data), 'OVERWRITE')
				})
			} else {
				@return = 'FormatException'
			}
		} else {
			@return = 'CastException'
		}
	}
	return(@return)
}
proc _remove_hologram(@id) {
	@path = 'holograms/'.@id.'.json'
	@return = file_exists(@path)
	if(@return) {
		async_read_file(@path, closure(@callback) {
			@data = json_decode(@callback)
			foreach(@lore in @data['lores']) {
				if(entity_exists(@lore['uuid'])) {
					entity_remove(@lore['uuid'])
				}
			}
			delete_file(@path)
		})
		@return = 'Success'
	} else {
		@return = 'IOException'
	}
	return(@return)
}
proc _add_hologram_lore(@id, @display) {
	@path = 'holograms/'.@id.'.json'
	@return = file_exists(@path)
	if(@return) {
		async_read_file(@path, closure(@callback) {
			@data = json_decode(@callback)
			@loc = array('x': @data['location']['x'], 'y': @data['location']['y'] - array_size(@data['lores']) * 0.25 , 'z': @data['location']['z'], 'world': @data['location']['world'])
			spawn_entity('ARMOR_STAND', 1, @loc, closure(@uuid) {
				set_entity_spec(@uuid, array(
					'baseplate': false,
					'gravity': false,
					'marker': true,
					'visible': false
				))
				if(@display != '') {
					set_mob_name(@uuid, @display)
					set_name_visible(@uuid, true)
				}
				@data['lores'][] = array(
					'display': @display,
					'uuid': @uuid
				)
				async_write_file(@path, json_encode(@data), 'OVERWRITE')
			})
		})
		@return = 'Success'
	} else {
		@return = 'IOException'
	}
	return(@return)
}
proc _set_hologram_lore(@id, @number, @display) {
	@path = 'holograms/'.@id.'.json'
	@return = file_exists(@path)
	if(@return) {
		if(@number >= 1 && typeof(integer(@number)) == 'int') {
			async_read_file(@path, closure(@callback) {
				@data = json_decode(@callback)
				if(@number - 1 < array_size(@data['lores'])) {
					@data['lores'][@number - 1]['display'] = @display
					@uuid = @data['lores'][@number - 1]['uuid']
					if(@display != '') {
						set_mob_name(@uuid, @display)
						set_name_visible(@uuid, true)
					} else {
						set_mob_name(@uuid, @display)
						set_name_visible(@uuid, false)
					}
					async_write_file(@path, json_encode(@data), 'OVERWRITE')
				} else {
					_add_hologram_lore(@id, @display)
				}
			})
			@return = 'Success'
		} else {
			@return = 'CastException'
		}
	} else {
		@return = 'IOException'
	}
	return(@return)
}
proc _del_hologram_lore(@id, @number) {
	@path = 'holograms/'.@id.'.json'
	@return = file_exists(@path)
	if(@return) {
		if(@number >= 1 && typeof(integer(@number)) == 'int') {
			async_read_file(@path, closure(@callback) {
				@data = json_decode(@callback)
				if(array_size(@data['lores']) > 1) {
					if(@number - 1 < array_size(@data['lores'])) {
						@key = @number - 1
					} else {
						@key = array_size(@data['lores']) - 1
					}
					@uuid = @data['lores'][@key]['uuid']
					if(entity_exists(@uuid)) {
						entity_remove(@uuid)
					}
					array_remove(@data['lores'], @key)
					async_write_file(@path, json_encode(@data), 'OVERWRITE', closure() {
						_update_hologram(@id)
					})
				} else {
					_remove_hologram(@id)
				}
			})
			@return = 'Success'
		} else {
			@return = 'CastException'
		}
	} else {
		@return = 'IOException'
	}
	return(@return)
}
proc _update_hologram(@id) {
	@path = 'holograms/'.@id.'.json'
	@return = file_exists(@path)
	if(@return) {
		async_read_file(@path, closure(@callback) {
			@data = json_decode(@callback)
			foreach(@key: @lore in @data['lores']) {
				@loc = array('x': @data['location']['x'], 'y': @data['location']['y'] - @key * 0.25 , 'z': @data['location']['z'], 'world': @data['location']['world'])
				if(!array_index_exists(@lore, 'uuid') || !entity_exists(@lore['uuid'])) {
					@display = @data['lores'][@key]['display']
					spawn_entity('ARMOR_STAND', 1, @loc, closure(@uuid) {
						set_entity_spec(@uuid, array(
							'baseplate': false,
							'gravity': false,
							'marker': true,
							'visible': false
						))
					if(@display != '') {
						set_mob_name(@uuid, @display)
						set_name_visible(@uuid, true)
					} else {
						set_mob_name(@uuid, @display)
						set_name_visible(@uuid, false)
					}
						@data['lores'][@key]['uuid'] = @uuid
					})
				} else {
					set_entity_loc(@lore['uuid'], @loc)
					@display = @data['lores'][@key]['display']
					if(@display != '') {
						set_mob_name(@lore['uuid'], @display)
						set_name_visible(@lore['uuid'], true)
					} else {
						set_mob_name(@lore['uuid'], @display)
						set_name_visible(@lore['uuid'], false)
					}
				}
			}
			async_write_file(@path, json_encode(@data), 'OVERWRITE')
		})
		@return = 'Success'
	} else {
		@return = 'IOException'
	}
	return(@return)
}
proc _set_hologram_loc(@id, @loc) {
	@path = 'holograms/'.@id.'.json'
	@return = file_exists(@path)
	if(@return) {
		if(is_array(@loc)) {
			if(array_index_exists(@loc, 'x') && array_index_exists(@loc, 'y') && array_index_exists(@loc, 'z') && array_index_exists(@loc, 'world')) {
				async_read_file(@path, closure(@callback) {
					@data = json_decode(@callback)
					@data['location'] = @loc
					async_write_file(@path, json_encode(@data), 'OVERWRITE', closure() {
						_update_hologram(@id)
					})
				})
				@return = 'Success'
			} else {
				@return = 'FormatException'
			}
		} else {
			@return = 'CastException'
		}
	} else {
		@return = 'IOException'
	}
	return(@return)
}
proc _create_holograms_directory() {
	try {
		create_dir('holograms')
		@return = 'Success'
	} catch(Exception @exception) {
		@return = @exception['classType']
	}
	return(@return)
}