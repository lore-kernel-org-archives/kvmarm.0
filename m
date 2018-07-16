From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v4 10/10] KVM: arm/arm64: vgic: Update documentation of the
 GIC devices wrt IIDR
Date: Mon, 16 Jul 2018 15:06:27 +0200
Message-ID: <1531746387-7033-11-git-send-email-christoffer.dall@arm.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B7974A11D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:54:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SCxBKasxvg+b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 08:54:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34DA24A180
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:54:08 -0400 (EDT)
In-Reply-To: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Update the documentation to reflect the ordering requirements of
restoring the GICD_IIDR register before any other registers and the
effects this has on restoring the interrupt groups for an emulated GICv2
insttance.

Also remove some outdated limitations in the documentation while we're
at it.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  8 ++++++++
 Documentation/virtual/kvm/devices/arm-vgic.txt    | 15 +++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 2408ab7..eba20ae 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -100,6 +100,14 @@ Groups:
     Note that distributor fields are not banked, but return the same value
     regardless of the mpidr used to access the register.
 
+    GICD_IIDR.Revision is updated when the KVM implementation is changed in a
+    way directly observable by the guest or userspace.  Userspace should read
+    GICD_IIDR from KVM and write back the read value to confirm its expected
+    behavior is aligned with the KVM implementation.  Userspace should set
+    GICD_IIDR before setting any other registers.  to ensure the expected
+    behavior.
+
+
     The GICD_STATUSR and GICR_STATUSR registers are architecturally defined such
     that a write of a clear bit has no effect, whereas a write with a set bit
     clears that value.  To allow userspace to freely set the values of these two
diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index b3ce126..4ff7635 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -49,9 +49,15 @@ Groups:
     index is specified with the vcpu_index field.  Note that most distributor
     fields are not banked, but return the same value regardless of the
     vcpu_index used to access the register.
-  Limitations:
-    - Priorities are not implemented, and registers are RAZ/WI
-    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
+
+    GICD_IIDR.Revision is updated when the KVM implementation of an emulated
+    GICv2 is changed in a way directly observable by the guest or userspace.
+    Userspace should read GICD_IIDR from KVM and write back the read value to
+    confirm its expected behavior is aligned with the KVM implementation.
+    Userspace should set GICD_IIDR before setting any other registers (both
+    KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to ensure
+    the expected behavior.  Unless GICD_IIDR has been set from userspace, writes
+    to the interrupt group registers (GICD_IGROUPR) are ignored.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
@@ -94,9 +100,6 @@ Groups:
     use the lower 5 bits to communicate with the KVM device and must shift the
     value left by 3 places to obtain the actual priority mask level.
 
-  Limitations:
-    - Priorities are not implemented, and registers are RAZ/WI
-    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
-- 
2.7.4
