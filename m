From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 4/9] KVM: arm/arm64: vgic: Add group field to struct irq
Date: Sat, 14 Jul 2018 19:05:35 +0200
Message-ID: <1531587940-2490-5-git-send-email-christoffer.dall@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2826E4A0FC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7GIeuLW3Kt5f for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:18 -0400 (EDT)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04hn0217.outbound.protection.outlook.com [104.47.12.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C1EC4A130
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:17 -0400 (EDT)
In-Reply-To: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
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

In preparation for proper group 0 and group 1 support in the vgic, we
add a field in the struct irq to store the group of all interrupts.

We initialize the group to group 0 when emulating GICv2 and to group 1
when emulating GICv3, just like we treat them today.  LPIs are always
group 1.  We also continue to ignore writes from the guest, preserving
existing functionality, for now.

Finally, we also add this field to the vgic debug logic to show the
group for all interrupts.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/kvm/arm_vgic.h         |  1 +
 virt/kvm/arm/vgic/vgic-debug.c |  8 +++++---
 virt/kvm/arm/vgic/vgic-init.c  | 19 +++++++++++++++++--
 virt/kvm/arm/vgic/vgic-its.c   |  1 +
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7e64c46..c661d0e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -133,6 +133,7 @@ struct vgic_irq {
        u8 source;                      /* GICv2 SGIs only */
        u8 active_source;               /* GICv2 SGIs only */
        u8 priority;
+       u8 group;                       /* 0 == group 0, 1 == group 1 */
        enum vgic_irq_config config;    /* Level or edge */

        /*
diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index c589d4c..d3a403f 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -148,6 +148,7 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)

        seq_printf(s, "P=pending_latch, L=line_level, A=active\n");
        seq_printf(s, "E=enabled, H=hw, C=config (level=1, edge=0)\n");
+       seq_printf(s, "G=group\n");
 }

 static void print_header(struct seq_file *s, struct vgic_irq *irq,
@@ -162,8 +163,8 @@ static void print_header(struct seq_file *s, struct vgic_irq *irq,
        }

        seq_printf(s, "\n");
-       seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
-       seq_printf(s, "---------------------------------------------------------------\n");
+       seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHCG     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
+       seq_printf(s, "----------------------------------------------------------------\n");
 }

 static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
@@ -182,7 +183,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,

        seq_printf(s, "       %s %4d "
                      "    %2d "
-                     "%d%d%d%d%d%d "
+                     "%d%d%d%d%d%d%d "
                      "%8d "
                      "%8x "
                      " %2x "
@@ -197,6 +198,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
                        irq->enabled,
                        irq->hw,
                        irq->config == VGIC_CONFIG_LEVEL,
+                       irq->group,
                        irq->hwintid,
                        irq->mpidr,
                        irq->source,
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 230c922..a7c19cd 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -175,10 +175,13 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
                irq->vcpu = NULL;
                irq->target_vcpu = vcpu0;
                kref_init(&irq->refcount);
-               if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+               if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
                        irq->targets = 0;
-               else
+                       irq->group = 0;
+               } else {
                        irq->mpidr = 0;
+                       irq->group = 1;
+               }
        }
        return 0;
 }
@@ -227,6 +230,18 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
                        /* PPIs */
                        irq->config = VGIC_CONFIG_LEVEL;
                }
+
+               /*
+                * GICv3 can only be created via the KVM_DEVICE_CREATE API and
+                * so we always know the emulation type at this point as it's
+                * either explicitly configured as GICv3, or explicitly
+                * configured as GICv2, or not configured yet which also
+                * implies GICv2.
+                */
+               if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+                       irq->group = 1;
+               else
+                       irq->group = 0;
        }

        if (!irqchip_in_kernel(vcpu->kvm))
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4ed79c9..92840c0 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -71,6 +71,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
        kref_init(&irq->refcount);
        irq->intid = intid;
        irq->target_vcpu = vcpu;
+       irq->group = 1;

        spin_lock_irqsave(&dist->lpi_list_lock, flags);

--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
