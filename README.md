# CHHologram
CommandHelper LocalPackage for handling holograms in minecraft.

# API Reference
## _create_holograms_directory()

: 이 proc가 있는 파일.ms가 있는 폴더에 'holograms'라는 폴더를 생성합니다.
## _get_holograms()

: holograms 파일 기준으로 존재하는 모든 홀로그램 id 반환합니다.
## _create_hologram(@id, @loc, @display)

: @loc위치 배열에 해당하는곳에 @display로 보이는 @id라는 id를 가진 홀로그램을 생성합니다.
## _remove_hologram(@id)

: 해당 홀로그램(모든 로어 포함)을 제거합니다.
## _add_hologram_lore(@id, @display)

: 해당 홀로그램 아래에 @display로 보이는 로어를 추가합니다.

> 단 @display가 ''일시 아머스탠드만 소환하고 머리위 닉네임은 설정하지 않은채로 로어가 생성되서 공란을 만들수 있습니다.
## _set_hologram_lore(@id, @number, @display)

: 해당 홀로그램의 @number번째 로어를 @display로 보이도록 수정합니다.

> @number가 해당 홀로그램의 로어의 갯수 보다 클시 _add_hologram_lore랑 같은 역할을 합니다.

> 단 @display가 ''일시 아머스탠드만 소환하고 머리위 닉네임은 설정하지 않은채로 로어가 생성되서 공란을 만들수 있습니다.
## _del_hologram_lore(@id, @number)

: 해당 홀로그램의 @number번쨰 로어를 제거합니다.

> 해당 홀로그램의 로어가 1개일시 _remove_hologram이랑 같은 역할을 합니다.
## _update_hologram(@id)

: 파일 정보를 바탕으로 해당 홀로그램 새로고침합니다.

> 엔티티가 없어졌을경우 새로 소환한후 해당 엔티티의 uuid를 파일에 저장합니다.

> 직접 파일을 작성할땐 uuid를 안적으니 그거 고려해서 display만 있는지 확인하고 그거에 맞게 엔티티 생성합니다.

> _del_hologram_lore로 중간에 낀홀로그램 제거한다음 줄맞추는 용도, set_hologram_loc로 위치 설정할때 사용되기도 합니다.
## _set_hologram_loc(@id, @loc)

: 해당 홀로그램의 위치를 설정합니다.
