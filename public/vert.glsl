uniform vec3 uGrabCenter;
uniform vec3 uTarget;
uniform float uTime;
uniform float uGrabStart;
uniform float uReleaseStart;
// uniform vec2 uMousePosition;
// uniform vec2 uResolution;
varying vec3 vNorm;
varying vec2 vUv;

#define PI 3.14159
#define radius 24.0
#define maxZ 29.0
#define decayExp 4.1
#define upDuration 0.1
#define downDuration 0.8
#define bouncy 500.0

float decay(float f) {
  return max(0.0, pow(
    cos(clamp(f, 0.0, 1.0) * PI/2.0),
    decayExp
  ));
}
float grabForce(vec2 p) {
  return decay(distance(p.xy, uGrabCenter.xy) / radius);
}

void main() {
  vUv = uv;
  float force = grabForce(position.xy);
  vec3 initOffset = (uTarget - position.xyz) * 0.5 * force;
  vec3 offset;
  if(uReleaseStart > 0.0) {
    float releaseTime = min(uReleaseStart, uTime - uReleaseStart);
    offset = initOffset
      * decay(releaseTime / downDuration) * sin(
        clamp(releaseTime / downDuration, 0.0, 1.0) * bouncy
      ); // grab release animation
  } else {
    offset = initOffset;
    //* clamp((uTime - uGrabStart) / upDuration, 0.0, 1.0) // grab up animation
  }
  vec3 p = position.xyz + offset;

  vNorm = position.xyz;
  gl_Position = projectionMatrix *
    modelViewMatrix * vec4(p, 1.0);
}