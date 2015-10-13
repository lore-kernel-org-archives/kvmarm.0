From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH] KVM: arm/arm64: Fix vGIC documentation
Date: Tue, 13 Oct 2015 10:01:25 +0300
Message-ID: <1444719685-8208-1-git-send-email-p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Correct some old mistakes in the API documentation:

1. VCPU is identified by index (using kvm_get_vcpu() function), but
   "cpu id" can be mistaken for affinity ID.
2. Some error codes are wrong.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
This is a small extraction from my vGICv3 live migration series. These
changes actually bring the documentation into correspondence with the
code, so they do not depend on any changes and can be applied right now
(including stable kernels, if you think it's appropriate).
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 3fb9054..9766b1e 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -44,28 +44,29 @@ Groups:
   Attributes:
     The attr field of kvm_device_attr encodes two values:
     bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   |   cpu id   |      offset     |
+    values:   |    reserved   | vcpu_index |      offset     |
 
     All distributor regs are (rw, 32-bit)
 
     The offset is relative to the "Distributor base address" as defined in the
     GICv2 specs.  Getting or setting such a register has the same effect as
-    reading or writing the register on the actual hardware from the cpu
-    specified with cpu id field.  Note that most distributor fields are not
-    banked, but return the same value regardless of the cpu id used to access
-    the register.
+    reading or writing the register on the actual hardware from the cpu whose
+    index is specified with vcpu_index field.  Note that most distributor fields
+    are not banked, but return the same value regardless of the VCPU index used
+    to access the register.
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
-    -ENODEV: Getting or setting this register is not yet supported
+    -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid CPU index supplied
 
   KVM_DEV_ARM_VGIC_GRP_CPU_REGS
   Attributes:
     The attr field of kvm_device_attr encodes two values:
     bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   |   cpu id   |      offset     |
+    values:   |    reserved   | vcpu_index |      offset     |
 
     All CPU interface regs are (rw, 32-bit)
 
@@ -91,8 +92,9 @@ Groups:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
-    -ENODEV: Getting or setting this register is not yet supported
+    -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid CPU index supplied
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
   Attributes:
-- 
2.4.4

