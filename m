From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 27/26] KVM: arm/arm64: GICv4: Prevent userspace from
 changing doorbell affinity
Date: Thu, 19 Oct 2017 16:48:35 +0100
Message-ID: <20171019154835.17942-1-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBE249D15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 11:47:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ouB835nfE+Le for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 11:47:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 495B64078A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 11:47:46 -0400 (EDT)
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We so far allocate the doorbell interrupts without taking any
special measure regarding the affinity of these interrupts. We
simply move them around as required when the vcpu gets scheduled
on a different CPU.

But that's counting without userspace (and the evil irqbalance) that
can try and move the VPE interrupt around, causing the ITS code
to emit VMOVP commands and remap the doorbell to another redistributor.
Worse, this can happen while the vcpu is running, causing all kind
of trouble if the VPE is already resident, and we end-up in UNPRED
territory.

So let's take a definitive action and prevent userspace from messing
with us. This is just a matter of adding IRQ_NO_BALANCING to the
set of flags we already have, letting the kernel in sole control
of the affinity.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v4.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

This extra patch goes on top of the current GICv4 patches, and is hence
being posted with a weird sequence number...

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index b87806fea554..c3dbab714328 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -89,6 +89,8 @@
  * reason), the doorbell interrupt is disabled.
  */
 
+#define DB_IRQ_FLAGS	(IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY | IRQ_NO_BALANCING)
+
 static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 {
 	struct kvm_vcpu *vcpu = info;
@@ -149,7 +151,7 @@ int vgic_v4_init(struct kvm *kvm)
 		 * doorbell could kick us out of the guest too
 		 * early...
 		 */
-		irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
+		irq_set_status_flags(irq, DB_IRQ_FLAGS);
 		ret = request_irq(irq, vgic_v4_doorbell_handler,
 				  0, "vcpu", vcpu);
 		if (ret) {
@@ -187,7 +189,7 @@ void vgic_v4_teardown(struct kvm *kvm)
 		struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
 		int irq = its_vm->vpes[i]->irq;
 
-		irq_clear_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
+		irq_clear_status_flags(irq, DB_IRQ_FLAGS);
 		free_irq(irq, vcpu);
 	}
 
-- 
2.14.1
