From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5] hw/intc/arm_gic: Initialize the vgic in the realize
 function
Date: Wed, 11 Mar 2015 17:17:06 +0000
Message-ID: <1426094226-8515-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01766487FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 13:11:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C4pfS7-dcYvP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 13:11:10 -0400 (EDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B2C04879C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 13:11:09 -0400 (EDT)
Received: by wggy19 with SMTP id y19so10782844wgg.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:17:30 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch forces vgic initialization in the vgic realize function.
It uses a new group/attribute that allows such operation:
KVM_DEV_ARM_VGIC_GRP_CTRL/KVM_DEV_ARM_VGIC_CTRL_INIT

This earlier initialization allows, for example, to setup VFIO
signaling and irqfd after vgic initialization, on a reset notifier.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v4 -> v5:
- add a comment to clarify what the new gic accesses aim at
- header sync removed. The series becomes a singleton.

v1 -> v2:
- The init is not mandated to be done in a machine init done notifier
  anymore since only the number of vcpus and number of IRQs must be
  known at init time.
---
 hw/intc/arm_gic_kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index 1ad3eb0..0d20750 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -573,6 +573,13 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
         kvm_gic_access(s, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, 0, &numirqs, 1);
     }
 
+    /* Tell the kernel to complete VGIC initialization now */
+    if (kvm_gic_supports_attr(s, KVM_DEV_ARM_VGIC_GRP_CTRL,
+                              KVM_DEV_ARM_VGIC_CTRL_INIT)) {
+        kvm_gic_access(s, KVM_DEV_ARM_VGIC_GRP_CTRL,
+                          KVM_DEV_ARM_VGIC_CTRL_INIT, 0, 0, 1);
+    }
+
     /* Distributor */
     memory_region_init_reservation(&s->iomem, OBJECT(s),
                                    "kvm-gic_dist", 0x1000);
-- 
1.8.3.2
