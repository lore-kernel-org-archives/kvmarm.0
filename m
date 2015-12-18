From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic-new: Try to insert multi-source SGIs at once
Date: Fri, 18 Dec 2015 13:00:09 +0000
Message-ID: <1450443609-2233-2-git-send-email-marc.zyngier@arm.com>
References: <1450443609-2233-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450443609-2233-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Improve handling of multi-source SGIs: instead of only inserting
one source per SGI per run, try to insert them all at once.

Hopefully this is a rare case.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c6f04a1..052f917 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -371,15 +371,22 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
 	struct vgic_irq *irq;
 	int count = 0;
 
-	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list)
-		count++;
-
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		spin_lock(&irq->irq_lock);
+		/* GICv2 SGIs can count for more than one... */
+		if (irq->intid < VGIC_NR_SGIS && irq->source)
+			count += hweight8(irq->source);
+		else
+			count++;
+		spin_unlock(&irq->irq_lock);
+	}
 	return count;
 }
 
 static void vgic_populate_lrs(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	struct vgic_irq *irq;
 	int count = 0;
 
@@ -390,8 +397,23 @@ static void vgic_populate_lrs(struct kvm_vcpu *vcpu)
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
-		if (vgic_target_oracle(irq) == vcpu)
+
+		if (unlikely(vgic_target_oracle(irq) != vcpu))
+			goto next;
+
+		/*
+		 * If we get an SGI with multiple sources, try to get
+		 * them in all at once.
+		 */
+		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+		    irq->intid < VGIC_NR_SGIS) {
+			while(irq->source && count < vcpu->arch.vgic_cpu.nr_lr)
+				vgic_populate_lr(vcpu, irq, count++);
+		} else {
 			vgic_populate_lr(vcpu, irq, count++);
+		}
+
+	next:
 		spin_unlock(&irq->irq_lock);
 
 		if (count == vcpu->arch.vgic_cpu.nr_lr)
-- 
2.1.4

