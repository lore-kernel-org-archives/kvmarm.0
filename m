From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 14/21] KVM: arm/arm64: Fix vGIC documentation
Date: Wed,  4 Nov 2015 15:49:53 +0100
Message-ID: <1446648600-27297-15-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Pavel Fedin <p.fedin@samsung.com>

Correct some old mistakes in the API documentation:

1. VCPU is identified by index (using kvm_get_vcpu() function), but
   "cpu id" can be mistaken for affinity ID.
2. Some error codes are wrong.

  [ Slightly tweaked some grammer and did some s/CPU index/vcpu_index/
    in the descriptions.  -Christoffer ]

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 3fb9054..59541d4 100644
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
+    index is specified with the vcpu_index field.  Note that most distributor
+    fields are not banked, but return the same value regardless of the
+    vcpu_index used to access the register.
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
-    -ENODEV: Getting or setting this register is not yet supported
+    -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid vcpu_index supplied
 
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
+    -EINVAL: Invalid vcpu_index supplied
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
   Attributes:
-- 
2.1.2.330.g565301e.dirty

