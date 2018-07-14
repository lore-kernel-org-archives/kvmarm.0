From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 5/9] KVM: arm/arm64: vgic: Signal IRQs using their
 configured group
Date: Sat, 14 Jul 2018 19:05:36 +0200
Message-ID: <1531587940-2490-6-git-send-email-christoffer.dall@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 504214A135
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ArbH9im84nq6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:21 -0400 (EDT)
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02hn0215.outbound.protection.outlook.com [104.47.4.215])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 151804A14F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:21 -0400 (EDT)
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

Now when we have a group configuration on the struct IRQ, use this state
when populating the LR and signaling interrupts as either group 0 or
group 1 to the VM.  Depending on the model of the emulated GIC, and the
guest's configuration of the VMCR, interrupts may be signaled as IRQs or
FIQs to the VM.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/linux/irqchip/arm-gic.h | 1 +
 virt/kvm/arm/vgic/vgic-v2.c     | 3 +++
 virt/kvm/arm/vgic/vgic-v3.c     | 6 +-----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 484f5bf..6c4aaf0 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -104,6 +104,7 @@
 #define GICH_LR_PENDING_BIT            (1 << 28)
 #define GICH_LR_ACTIVE_BIT             (1 << 29)
 #define GICH_LR_EOI                    (1 << 19)
+#define GICH_LR_GROUP1                 (1 << 30)
 #define GICH_LR_HW                     (1 << 31)

 #define GICH_VMCR_ENABLE_GRP0_SHIFT    0
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index a5f2e44..df5e6a6 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -159,6 +159,9 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
                }
        }

+       if (irq->group)
+               val |= GICH_LR_GROUP1;
+
        if (irq->hw) {
                val |= GICH_LR_HW;
                val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index cdce653..530b849 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -197,11 +197,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
        if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT))
                irq->line_level = false;

-       /*
-        * We currently only support Group1 interrupts, which is a
-        * known defect. This needs to be addressed at some point.
-        */
-       if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
+       if (irq->group)
                val |= ICH_LR_GROUP;

        val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
