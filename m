From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v6 2/8] KVM: arm/arm64: Factor out functionality to get vgic mmio requester_vcpu
Date: Mon,  4 Dec 2017 21:05:00 +0100
Message-ID: <20171204200506.3224-3-cdall@kernel.org>
References: <20171204200506.3224-1-cdall@kernel.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204200506.3224-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We are about to distinguish between userspace accesses and mmio traps
for a number of the mmio handlers.  When the requester vcpu is NULL, it
mens we are handling a userspace acccess.

Factor out the functionality to get the request vcpu into its own
function, mostly so we have a common place to document the semantics of
the return value.

Also take the chance to move the functionality outside of holding a
spinlock and instead explicitly disable and enable preemption.  This
supports PREEMPT_RT kernels as well.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 44 +++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index deb51ee16a3d..747b0a3b4784 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -122,6 +122,27 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+/*
+ * This function will return the VCPU that performed the MMIO access and
+ * trapped from twithin the VM, and will return NULL if this is a userspace
+ * access.
+ *
+ * We can disable preemption locally around accessing the per-CPU variable,
+ * and use the resolved vcpu pointer after enabling preemption again, because
+ * even if the current thread is migrated to another CPU, reading the per-CPU
+ * value later will give us the same value as we update the per-CPU variable
+ * in the preempt notifier handlers.
+ */
+static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
+{
+	struct kvm_vcpu *vcpu;
+
+	preempt_disable();
+	vcpu = kvm_arm_get_running_vcpu();
+	preempt_enable();
+	return vcpu;
+}
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
@@ -184,24 +205,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool new_active_state)
 {
-	struct kvm_vcpu *requester_vcpu;
 	unsigned long flags;
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
 
-	/*
-	 * The vcpu parameter here can mean multiple things depending on how
-	 * this function is called; when handling a trap from the kernel it
-	 * depends on the GIC version, and these functions are also called as
-	 * part of save/restore from userspace.
-	 *
-	 * Therefore, we have to figure out the requester in a reliable way.
-	 *
-	 * When accessing VGIC state from user space, the requester_vcpu is
-	 * NULL, which is fine, because we guarantee that no VCPUs are running
-	 * when accessing VGIC state from user space so irq->vcpu->cpu is
-	 * always -1.
-	 */
-	requester_vcpu = kvm_arm_get_running_vcpu();
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	/*
 	 * If this virtual IRQ was written into a list register, we
@@ -213,6 +220,11 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * vgic_change_active_prepare)  and still has to sync back this IRQ,
 	 * so we release and re-acquire the spin_lock to let the other thread
 	 * sync back the IRQ.
+	 *
+	 * When accessing VGIC state from user space, requester_vcpu is
+	 * NULL, which is fine, because we guarantee that no VCPUs are running
+	 * when accessing VGIC state from user space so irq->vcpu->cpu is
+	 * always -1.
 	 */
 	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
 	       irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
-- 
2.14.2
