From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 3/7] KVM: arm/arm64: Fix the documentation
Date: Mon, 28 Sep 2015 18:27:30 +0300
Message-ID: <5b6b8e9e002bc6a9cc5e6a881032d6b930830e74.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

During refactoring we noticed some mistakes in the documentation.
Correct them.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 3fb9054..4727829 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -44,28 +44,29 @@ Groups:
   Attributes:
     The attr field of kvm_device_attr encodes two values:
     bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   |   cpu id   |      offset     |
+    values:   |    reserved   |  cpu idx   |      offset     |
 
     All distributor regs are (rw, 32-bit)
 
     The offset is relative to the "Distributor base address" as defined in the
     GICv2 specs.  Getting or setting such a register has the same effect as
-    reading or writing the register on the actual hardware from the cpu
-    specified with cpu id field.  Note that most distributor fields are not
-    banked, but return the same value regardless of the cpu id used to access
-    the register.
+    reading or writing the register on the actual hardware from the cpu whose
+    index is specified with cpu idx field.  Note that most distributor fields
+    are not banked, but return the same value regardless of the cpu idx used to
+    access the register.
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
+    values:   |    reserved   |  cpu idx   |      offset     |
 
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

