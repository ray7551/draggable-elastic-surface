const THREE = require('three');

class MouseManager {
  constructor(domElement) {
    if(MouseManager.instance) {
      return MouseManager.instance;
    }
    this.position = new THREE.Vector2();
    domElement.addEventListener('mousemove', this.onMove.bind(this), false);
    domElement.addEventListener('mousedown', this.onDown.bind(this), false);
    domElement.addEventListener('mouseup' , this.onUp.bind(this), false);
    this.dom = domElement;
    this.isPressing = false;

    MouseManager.instance = this;
  }

  onMove(e) {
    // e.preventDefault();
    this.position.x = (e.clientX / this.dom.clientWidth) * 2 - 1;
    this.position.y = -(e.clientY / this.dom.clientHeight) * 2 + 1;
  }
  addMoveListener(cb) {
    this.dom.addEventListener('mousemove', cb, false);
  }

  onDown() {
    this.isPressing = true;
  }
  addDownListener(cb) {
    this.dom.addEventListener('mousedown', cb, false);
  }

  onUp() {
    this.isPressing = false;
  }
  addUpListener(cb) {
    this.dom.addEventListener('mouseup', cb, false);
  }

  addLeaveListener(cb) {
    this.dom.addEventListener('mouseleave', cb, false);
  }

}
MouseManager.instance = null;

module.exports = MouseManager;