shader_type spatial;
render_mode cull_disabled;
//render_mode ambient_light_disabled;


uniform vec4 albedo : source_color = vec4(1.0f);
uniform sampler2D albedo_texture : source_color;
uniform bool clamp_diffuse_to_max = false;
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0) = 0.5;

uniform int cuts : hint_range(1, 8) = 3;
uniform float wrap : hint_range(-2.0f, 2.0f) = 0.0f;
uniform float steepness : hint_range(1.0f, 8.0f) = 1.0f;

uniform bool use_attenuation = true;


uniform bool use_ramp = false;
uniform sampler2D ramp : source_color;

uniform bool use_borders = false;
uniform float border_width = 0.01f;
uniform float sway_speed = 0.01f;
uniform float sway_angle = 0.0f;
uniform float seed = 0.01f;
varying vec3 vertex_pos;
varying vec3 normal;
varying vec3 world_coords;

float split_specular(float specular) {
	return step(0.5f, specular);
}

void vertex() {
	vertex_pos = VERTEX;
	normal = NORMAL;
	
	//calcultate mesh world position to pass to fragment
	world_coords = (MODELVIEW_MATRIX * vec4(VERTEX,1.0)).xyz;
	
	//calculate speed and angle --> = sway
	float sway = sin((TIME + seed) * sway_speed * 2.0 * PI) * radians(sway_angle);

	//quad rotation based on sway
	mat4 rotation = mat4(
		vec4(cos(sway),-sin(sway),0.0,0.0),
		vec4(sin(sway),cos(sway),0.0,0.0),
		vec4(0.0,0.0,1.0,0.0),
		vec4(0.0,0.0,0.0,1.0)
	);
	// apply rotation
	VERTEX =(rotation * vec4(VERTEX,1.0)).xyz;
}


void fragment() {
	ALBEDO = albedo.rgb * texture(albedo_texture, UV).rgb;
	ALPHA = texture(albedo_texture,UV).a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}

void light() {
	// Attenuation.
	float attenuation = 1.0f;
	if (use_attenuation) {
		attenuation = ATTENUATION;
	}

	// Diffuse lighting.
	float NdotL = dot(NORMAL, LIGHT);
	float diffuse_amount = NdotL + (attenuation - 1.0) + wrap;
	//float diffuse_amount = NdotL * attenuation + wrap;
	diffuse_amount *= steepness;
	float cuts_inv = 1.0f / float(cuts);
	float diffuse_stepped = clamp(diffuse_amount + mod(1.0f - diffuse_amount, cuts_inv), 0.0f, 1.0f);

	// Calculate borders.
	float border = 0.0f;
	if (use_borders) {
		float corr_border_width = length(cross(NORMAL, LIGHT)) * border_width * steepness;
		border = step(diffuse_stepped - corr_border_width, diffuse_amount)
				 - step(1.0 - corr_border_width, diffuse_amount);
	}

	// Apply diffuse result to different styles.
	vec3 diffuse = ALBEDO.rgb * LIGHT_COLOR / PI;
	if (use_ramp) {
		diffuse *= texture(ramp, vec2(diffuse_stepped * (1.0f - border), 0.0f)).rgb;
	} else {
		diffuse *= diffuse_stepped * (1.0f - border);
	}

	if (clamp_diffuse_to_max) {
		// Clamp diffuse to max for multiple light sources.
		DIFFUSE_LIGHT = max(DIFFUSE_LIGHT, diffuse);
	} else {
		DIFFUSE_LIGHT += diffuse;
	}
}

