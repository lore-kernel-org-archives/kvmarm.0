From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH] KVM: arm/arm64: Reset mapped IRQs on VM reset
Date: Mon,  5 Mar 2018 11:36:38 +0100
Message-ID: <20180305103638.1633-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently don't allow resetting mapped IRQs from userspace, because
their state is controlled by the hardware.  But we do need to reset the
state when the VM is reset, so we provide a function for the 'owner' of
the mapped interrupt to reset the interrupt state.

Currently only the timer uses mapped interrupts, so we call this
function from the timer reset logic.

Signed-off-by: Christoffer Dall <cdall@kernel.org>
---
This depends on "KVM: arm/arm64: Avoid vcpu_load for other vcpu ioctls
than KVM_RUN" from the VHE optimization series so that the reset doesn't
get called while vtimer->loaded is true.

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
index 70268c0bec79..09890a5268d1 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -571,6 +571,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 {
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
@@ -584,6 +585,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
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
