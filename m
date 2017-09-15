From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 2/7] KVM: arm/arm64: Factor out functionality to get vgic mmio requester_vcpu
Date: Fri, 15 Sep 2017 15:19:49 -0700
Message-ID: <1505513994-77939-3-git-send-email-christoffer.dall@linaro.org>
References: <1505513994-77939-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1505513994-77939-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

We are about to distinguish between userspace accesses and mmio traps
for a number of the mmio handlers.  When the requester vcpu is NULL, it
mens we are handling a userspace acccess.

Factor out the functionality to get the request vcpu into its own
function, mostly so we have a common place to document the semantics of
the return value.

Also take the chance to move the functionality outside of holding a
spinlock and instead explicitly disable and enable preemption.  This
supports PREEMPT_RT kernels as well.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index c1e4bdd..f3087f6 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -120,6 +120,26 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+/*
+ * This function will return the VCPU that performed the MMIO access and
+ * trapped from twithin the VM, and will return NULL if this is a userspace
+ * access.
+ *
+ * We can disable preemption locally around accessing the per-CPU variable
+ * because even if the current thread is migrated to another CPU, reading the
+ * per-CPU value later will give us the same value as we update the per-CPU
+ * variable in the preempt notifier handlers.
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
@@ -180,23 +200,9 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool new_active_state)
 {
-	struct kvm_vcpu *requester_vcpu;
-	spin_lock(&irq->irq_lock);
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
+	spin_lock(&irq->irq_lock);
 
 	/*
 	 * If this virtual IRQ was written into a list register, we
@@ -208,6 +214,11 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
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
2.7.4
