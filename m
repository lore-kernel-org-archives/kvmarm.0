From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 14/27] KVM: arm/arm64: GICv4: Handle MOVALL applied to a vPE
Date: Mon, 13 Nov 2017 10:17:39 +0100
Message-ID: <20171113091752.10663-15-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The current implementation of MOVALL doesn't allow us to call
into the core ITS code as we hold a number of spinlocks.

Let's try a method used in other parts of the code, were we copy
the intids of the candicate interrupts, and then do whatever
we need to do with them outside of the critical section.

This allows us to move the interrupts one by one, at the expense
of a bit of CPU time. Who cares? MOVALL is such a stupid command
anyway...

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 15e79285380d..78d11aed1e17 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1169,11 +1169,12 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 				      u64 *its_cmd)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
 	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
 	struct kvm_vcpu *vcpu1, *vcpu2;
 	struct vgic_irq *irq;
+	u32 *intids;
+	int irq_count, i;
 
 	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
 	    target2_addr >= atomic_read(&kvm->online_vcpus))
@@ -1185,19 +1186,19 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
 	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
 
-	spin_lock(&dist->lpi_list_lock);
+	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
+	if (irq_count < 0)
+		return irq_count;
 
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
-		spin_lock(&irq->irq_lock);
+	for (i = 0; i < irq_count; i++) {
+		irq = vgic_get_irq(kvm, NULL, intids[i]);
 
-		if (irq->target_vcpu == vcpu1)
-			irq->target_vcpu = vcpu2;
+		update_affinity(irq, vcpu2);
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(kvm, irq);
 	}
 
-	spin_unlock(&dist->lpi_list_lock);
-
+	kfree(intids);
 	return 0;
 }
 
-- 
2.14.2
