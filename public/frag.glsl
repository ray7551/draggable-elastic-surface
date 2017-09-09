varying vec2 vUv;
uniform float iGlobalTime;
uniform sampler2D iChannel0;

vec3 sample(vec2 uv) {
  return texture2D(iChannel0, uv).rgb;
}

void main() {
  gl_FragColor = texture2D(iChannel0, vUv);
}