/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
describe('Ellipse', function() {
  const Ellipse = require('lib/world/ellipse');
  const Rectangle = require('lib/world/rectangle');
  const Vector = require('lib/world/vector');

  it('contains its own center', function() {
    const ellipse = new Ellipse(0, 0, 10, 10);
    return expect(ellipse.containsPoint(new Vector(0, 0))).toBe(true);
  });

  it('contains a point when rotated', function() {
    const ellipse = new Ellipse(0, -20, 40, 40, (3 * Math.PI) / 4);
    expect(ellipse.containsPoint(new Vector(0, 0))).toBe(true);
    return expect(ellipse.containsPoint(new Vector(0, 2))).toBe(false);
  });

  it('contains more points properly', function() {
    // ellipse with y major axis, off-origin center, and 45 degree rotation
    const ellipse = new Ellipse(1, 2, 4, 6, Math.PI / 4);
    expect(ellipse.containsPoint(new Vector(1, 2))).toBe(true);
    expect(ellipse.containsPoint(new Vector(-1, 3))).toBe(true);
    expect(ellipse.containsPoint(new Vector(0, 4))).toBe(true);
    expect(ellipse.containsPoint(new Vector(1, 4))).toBe(true);
    expect(ellipse.containsPoint(new Vector(3, 0))).toBe(true);
    expect(ellipse.containsPoint(new Vector(1, 0))).toBe(true);
    expect(ellipse.containsPoint(new Vector(0, 1))).toBe(true);
    expect(ellipse.containsPoint(new Vector(-1, 2))).toBe(true);
    expect(ellipse.containsPoint(new Vector(2, 2))).toBe(true);
    expect(ellipse.containsPoint(new Vector(0, 0))).toBe(false);
    expect(ellipse.containsPoint(new Vector(0, 5))).toBe(false);
    expect(ellipse.containsPoint(new Vector(3, 4))).toBe(false);
    expect(ellipse.containsPoint(new Vector(4, 0))).toBe(false);
    expect(ellipse.containsPoint(new Vector(2, -1))).toBe(false);
    expect(ellipse.containsPoint(new Vector(0, -3))).toBe(false);
    expect(ellipse.containsPoint(new Vector(-2, -2))).toBe(false);
    expect(ellipse.containsPoint(new Vector(-2, 0))).toBe(false);
    return expect(ellipse.containsPoint(new Vector(-2, 4))).toBe(false);
  });

  xit('correctly calculates distance to a faraway point', function() {
    // TODO: this is the correct distance if the ellipse were a rectangle, but need to update for actual ellipse expected distances.
    const ellipse = new Ellipse(100, 50, 20, 40);
    const p = new Vector(200, 300);
    let d = 10 * Math.sqrt(610);
    expect(ellipse.distanceToPoint(p)).toBeCloseTo(d);
    ellipse.rotation = Math.PI / 2;
    d = 80 * Math.sqrt(10);
    return expect(ellipse.distanceToPoint(p)).toBeCloseTo(d);
  });

  it('does not modify itself or target Vector when calculating distance', function() {
    const ellipse = new Ellipse(-100, -200, 1, 100);
    const ellipse2 = ellipse.copy();
    const p = new Vector(-100.25, -101);
    const p2 = p.copy();
    ellipse.distanceToPoint(p);
    expect(p.x).toEqual(p2.x);
    expect(p.y).toEqual(p2.y);
    expect(ellipse.x).toEqual(ellipse2.x);
    expect(ellipse.y).toEqual(ellipse2.y);
    expect(ellipse.width).toEqual(ellipse2.width);
    expect(ellipse.height).toEqual(ellipse2.height);
    return expect(ellipse.rotation).toEqual(ellipse2.rotation);
  });

  it('correctly calculates distance to contained point', function() {
    const ellipse = new Ellipse(-100, -200, 1, 100);
    const ellipse2 = ellipse.copy();
    const p = new Vector(-100.25, -160);
    const p2 = p.copy();
    expect(ellipse.distanceToPoint(p)).toBe(0);
    ellipse.rotation = 0.00000001 * Math.PI;
    return expect(ellipse.distanceToPoint(p)).toBe(0);
  });

  it('AABB works when not rotated', function() {
    const ellipse = new Ellipse(10, 20, 30, 40);
    const rect = new Rectangle(10, 20, 30, 40);
    const aabb1 = ellipse.axisAlignedBoundingBox();
    const aabb2 = ellipse.axisAlignedBoundingBox();
    return ['x', 'y', 'width', 'height'].map((prop) =>
      expect(aabb1[prop]).toBe(aabb2[prop]));
});

  it('AABB works when rotated', function() {
    const ellipse = new Ellipse(10, 20, 30, 40, Math.PI / 3);
    const rect = new Rectangle(10, 20, 30, 40, Math.PI / 3);
    const aabb1 = ellipse.axisAlignedBoundingBox();
    const aabb2 = ellipse.axisAlignedBoundingBox();
    return ['x', 'y', 'width', 'height'].map((prop) =>
      expect(aabb1[prop]).toBe(aabb2[prop]));
});

  return it('calculates ellipse intersections properly', function() {
    // ellipse with y major axis, off-origin center, and 45 degree rotation
    const ellipse = new Ellipse(1, 2, 4, 6, Math.PI / 4);
    expect(ellipse.intersectsShape(new Rectangle(0, 0, 2, 2, 0))).toBe(true);
    expect(ellipse.intersectsShape(new Rectangle(0, -1, 2, 3, 0))).toBe(true);
    expect(ellipse.intersectsShape(new Rectangle(-1, -0.5, 2 * Math.SQRT2, 2 * Math.SQRT2, Math.PI / 4))).toBe(true);
    expect(ellipse.intersectsShape(new Rectangle(-1, -0.5, 2 * Math.SQRT2, 2 * Math.SQRT2, 0))).toBe(true);
    expect(ellipse.intersectsShape(new Rectangle(-1, -1, 2 * Math.SQRT2, 2 * Math.SQRT2, 0))).toBe(true);
    expect(ellipse.intersectsShape(new Rectangle(-1, -1, 2 * Math.SQRT2, 2 * Math.SQRT2, Math.PI / 4))).toBe(false);
    expect(ellipse.intersectsShape(new Rectangle(-2, -2, 2, 2, 0))).toBe(false);
    expect(ellipse.intersectsShape(new Rectangle(-Math.SQRT2 / 2, -Math.SQRT2 / 2, Math.SQRT2, Math.SQRT2, 0))).toBe(false);
    expect(ellipse.intersectsShape(new Rectangle(-Math.SQRT2 / 2, -Math.SQRT2 / 2, Math.SQRT2, Math.SQRT2, Math.PI / 4))).toBe(false);
    expect(ellipse.intersectsShape(new Rectangle(-2, 0, 2, 2, 0))).toBe(false);
    expect(ellipse.intersectsShape(new Rectangle(0, -2, 2, 2, 0))).toBe(false);
    return expect(ellipse.intersectsShape(new Rectangle(1, 2, 1, 1, 0))).toBe(true);
  });
});
