From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 3/3] hw/intc/arm_gic: Initialize the vgic in the realize
 function
Date: Wed,  4 Mar 2015 14:16:17 +0000
Message-ID: <1425478577-32556-4-git-send-email-eric.auger@linaro.org>
References: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7FB478D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hyijfbhcCnTK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 09:10:55 -0500 (EST)
Received: from mail-we0-f169.google.com (mail-we0-f169.google.com
 [74.125.82.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7637B47A3B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:55 -0500 (EST)
Received: by wesx3 with SMTP id x3so45684wes.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 06:16:57 -0800 (PST)
In-Reply-To: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, christoffer.dall@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, pbonzini@redhat.com, mst@redhat.com, b.reynal@virtualopensystems.com
Cc: alex.williamson@redhat.com, patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch forces vgic initialization in the vgic realize function.
It uses a new group/attribute that allows such operation:
KVM_DEV_ARM_VGIC_GRP_CTRL/KVM_DEV_ARM_VGIC_CTRL_INIT

This earlier initialization allows, for example, to setup VFIO
signaling and irqfd after vgic initialization, on a reset notifier.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/intc/arm_gic_kvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index 1ad3eb0..1395c9e 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -573,6 +573,12 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
         kvm_gic_access(s, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, 0, &numirqs, 1);
     }
 
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
