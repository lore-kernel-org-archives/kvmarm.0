From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 3/6] KVM: arm/arm64: Reset mapped IRQs on VM reset
Date: Thu, 15 Mar 2018 17:16:45 +0000
Message-ID: <20180315171648.19501-4-marc.zyngier@arm.com>
References: <20180315171648.19501-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C47F49FC8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:09:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nfVeC7ZNJFrK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 13:09:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B62BE49F9E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:09:36 -0400 (EDT)
In-Reply-To: <20180315171648.19501-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@kernel.org>

We currently don't allow resetting mapped IRQs from userspace, because
their state is controlled by the hardware.  But we do need to reset the
state when the VM is reset, so we provide a function for the 'owner' of
the mapped interrupt to reset the interrupt state.

Currently only the timer uses mapped interrupts, so we call this
function from the timer reset logic.

Cc: stable@vger.kernel.org
Fixes: 4c60e360d6df ("KVM: arm/arm64: Provide a get_input_level for the arch timer")
Signed-off-by: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h    |  1 +
 virt/kvm/arm/arch_timer.c |  4 ++++
 virt/kvm/arm/vgic/vgic.c  | 26 ++++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cdbd142ca7f2..02924ae2527e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -360,6 +360,7 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
+void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid);
 
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 70f4c30918eb..3945021510a9 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -581,6 +581,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 {
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
@@ -594,6 +595,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	ptimer->cnt_ctl = 0;
 	kvm_timer_update_state(vcpu);
 
+	if (timer->enabled && irqchip_in_kernel(vcpu->kvm))
+		kvm_vgic_reset_mapped_irq(vcpu, vtimer->irq.irq);
+
 	return 0;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c7c5ef190afa..0001858a2c23 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -495,6 +495,32 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 	return ret;
 }
 
+/**
+ * kvm_vgic_reset_mapped_irq - Reset a mapped IRQ
+ * @vcpu: The VCPU pointer
+ * @vintid: The INTID of the interrupt
+ *
+ * Reset the active and pending states of a mapped interrupt.  Kernel
+ * subsystems injecting mapped interrupts should reset their interrupt lines
+ * when we are doing a reset of the VM.
+ */
+void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	unsigned long flags;
+
+	if (!irq->hw)
+		goto out;
+
+	spin_lock_irqsave(&irq->irq_lock, flags);
+	irq->active = false;
+	irq->pending_latch = false;
+	irq->line_level = false;
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
+out:
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 {
 	struct vgic_irq *irq;
-- 
2.14.2
