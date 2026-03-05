shader_type spatial;
render_mode ambient_light_disabled, specular_disabled;
uniform vec3 unlit_area_color: source_color = vec3(0.0);
uniform vec3 main_albedo_color: source_color = vec3(1.0);
uniform vec3 emissive_color: source_color = vec3(1.0);
uniform vec3 metal_color: source_color = vec3(1.0);
uniform sampler2D albedo_greyscale_texture: source_color;
uniform sampler2D albedo_twilight_texture: source_color;
uniform bool has_metal_matcap = false;
uniform bool flip_matcap_horizontal = false;
uniform sampler2D metal_matcap;
uniform float metal_threshold:hint_range(0.0, 1.0, 0.05) = 0.5;
uniform bool has_normals = false;
uniform sampler2D normal_map: source_color;
uniform float normal_scale = 1.0;
uniform sampler2D light_noise: source_color;
uniform float light_cuts: hint_range(1.0, 100.0, 1.0) = 20.0;
uniform float shadow_scale: hint_range(0.1, 10.0, 0.1) = 0.1;
uniform float direct_light_strength: hint_range(0.0, 1.0, 0.1) = 0.5;
uniform vec2 matcap_uv_offset = vec2(0.0, 0.0);
uniform vec2 matcap_uv_scale = vec2(1.0, 1.0);

varying vec2 base_uv;
varying vec2 matcap_uv;
varying vec3 albedo_map;
varying vec3 twilight_map;

void vertex() {
    vec4 view_pos = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
    vec3 view_dir = normalize(-view_pos.xyz);
    vec3 view_normal = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    
    vec3 up_vector = vec3(0.0, 1.0, 0.0);
    vec3 right_vector = vec3(1.0, 0.0, 0.0);
    
    vec3 ref_vector = (abs(view_dir.y) > 0.9) ? right_vector : up_vector;
    
    vec3 tangent = normalize(cross(ref_vector, view_dir));
    vec3 bitangent = cross(view_dir, tangent);
    
    vec2 coords = vec2(
        dot(view_normal, tangent),
        dot(view_normal, bitangent)
    );

    coords.x = flip_matcap_horizontal ? -coords.x : coords.x;
    coords.y = -coords.y; // Flip Y coordinate
    
    matcap_uv = (coords * 0.496 + 0.5) * matcap_uv_scale + matcap_uv_offset;
}

void fragment() {
	// Base UV just in case
	base_uv = UV;
	//
	albedo_map = texture(albedo_greyscale_texture,base_uv).rgb;
	twilight_map = texture(albedo_twilight_texture,base_uv).rgb;
	vec3 normal_map_sample = texture(normal_map, base_uv).rgb;
	
	// check for normal_map
	if (has_normals){
	NORMAL_MAP = normal_map_sample;
	NORMAL_MAP_DEPTH = normal_scale;
	}
	
	//sets the Albedo to a Main albedo color
	ALBEDO = albedo_map * main_albedo_color;
	//makes the glowy areas glow
	ALBEDO = mix(ALBEDO,emissive_color,twilight_map.g);
	
	// applies a matcap (if any) to pixels marked in blue on the twilight map
	if (has_metal_matcap){
		ALBEDO = mix(ALBEDO,texture(metal_matcap,matcap_uv).rgb * metal_color,twilight_map.b);
		
	}
	
	
	//to show the chosen colors of the model accurately and apply unique Ambient Light
	EMISSION = ALBEDO * unlit_area_color;
}

void light() {
	// maxed Normal/Light Dot Product
	float mNdotL = max(clamp(dot(LIGHT,NORMAL),0.0,1.0), 0.0);
	
	
	// Basic Shading
	DIFFUSE_LIGHT += ATTENUATION * ALBEDO * mNdotL * length(LIGHT_COLOR);

	//paint HighlightChanels with pure light color but avoid directional light 
	//* Used to show Albdeo color instead
		if (LIGHT_IS_DIRECTIONAL == false){
		if(1.0 - clamp(ATTENUATION,0.0,1.0) <= direct_light_strength){
			vec3 direct_light = LIGHT_COLOR * mNdotL * ATTENUATION * albedo_map;
			DIFFUSE_LIGHT = mix(DIFFUSE_LIGHT,direct_light,twilight_map.r);
		}
		
		DIFFUSE_LIGHT += LIGHT_COLOR * PI * ALBEDO * ATTENUATION;
		}

	
	//// assign the result
	SPECULAR_LIGHT = DIFFUSE_LIGHT;
	
	//// Posterize lights and then blur them back out with noise
	vec3 diffuse_dummy = DIFFUSE_LIGHT;
	vec3 light_noise_map = texture(light_noise,base_uv *.5).rgb;
	SPECULAR_LIGHT = round(DIFFUSE_LIGHT*light_cuts - 0.5)/light_cuts; 
	SPECULAR_LIGHT = mix(diffuse_dummy,SPECULAR_LIGHT,light_noise_map.r);
	
	
	
	// cancel all contribution of the diffuse_light variable
	SPECULAR_LIGHT -= ALBEDO * DIFFUSE_LIGHT;

}
