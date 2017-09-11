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
#define radius 14.0
#define maxZ 29.0
#define decayExp 3.5
#define upDuration 0.1
#define downDuration 0.8
// the render freq is about 50, so if you want more realistic effect, bounce freq should not like 25.0 / 50.0
#define bounceFreq 12.0

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
  // I don't know why (uTarget - position.xyz) here will cause a spike shape
  // vec3 initOffset = (uTarget - position.xyz) * 1.0 * force;
  vec3 initOffset = (uTarget - uGrabCenter.xyz) * 1.0 * force;
  vec3 offset;
  if(uReleaseStart > 0.0) {
    float releaseTime = min(uReleaseStart, uTime - uReleaseStart);
    offset = initOffset
      * decay(releaseTime / downDuration) * sin(
        clamp(releaseTime / downDuration, 0.0, 1.0) * bounceFreq * (2.0*PI)
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