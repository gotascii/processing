module Billboardable
  include Processing::Proxy
  include Math

  def self.included(base)
    base.class_eval do
      attr_accessor :cam
    end
  end

  def billboardable(cam)
    @cam = cam
  end

  def face_cam
    dx = cam.position[0] - coords.x
    dy = cam.position[1] - coords.y
    dz = cam.position[2] - coords.z
    angle_z = atan2(dy, dx)
    hyp = sqrt(sq(dx) + sq(dy))
    angle_y = atan2(hyp, dz)
    rotate_z(angle_z)
    rotate_y(angle_y)
  end
end