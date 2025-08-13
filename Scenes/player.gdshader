shader_type canvas_item;

uniform bool enabled = false;
uniform vec2 player_pos = vec2(0,0);
uniform float max_distance = 60.0;
uniform float num = 0;
instance uniform vec2 tree_pos = vec2(0, 0);

void fragment() {
	if(enabled == true) {
		if (COLOR.a!=0.0){
			vec2 place = FRAGCOORD.xy;
			float distance_to_player = distance(FRAGCOORD.xy, player_pos);
			COLOR.a = clamp(((distance_to_player-max_distance)/max_distance*4.0),0.2,1);
		};
	};
}