From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Simplify active_change_prepare and plug race
Date: Wed, 10 May 2017 12:01:18 +0200
Message-ID: <20170510100118.4189-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We don't need to stop a specific VCPU when changing the active state,
because private IRQs can only be modified by a running VCPU for the
VCPU itself and it is therefore already stopped.

However, it is also possible for two VCPUs to be modifying the active
state of SPIs at the same time, which can cause the thread being stuck
in the loop that checks other VCPU threads for a potentially very long
time, or to modify the active state of a running VCPU.  Fix this by
serializing all accesses to setting and clearing the active state of
interrupts using the KVM mutex.

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  2 --
 arch/arm64/include/asm/kvm_host.h |  2 --
 virt/kvm/arm/arm.c                | 20 ++++----------------
 virt/kvm/arm/vgic/vgic-mmio.c     | 18 ++++++++++--------
 virt/kvm/arm/vgic/vgic.c          | 11 ++++++-----
 5 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d488b88..b77a3af 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -234,8 +234,6 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
-void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
-void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
 
 int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 578df18..7a38d5a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -334,8 +334,6 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
-void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
-void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
 
 u64 __kvm_call_hyp(void *hypfn, ...);
 #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9f6f522a4b..ba771b40 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -542,27 +542,15 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
 }
 
-void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.pause = true;
-	kvm_vcpu_kick(vcpu);
-}
-
-void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
-{
-	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
-
-	vcpu->arch.pause = false;
-	swake_up(wq);
-}
-
 void kvm_arm_resume_guest(struct kvm *kvm)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arm_resume_vcpu(vcpu);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.pause = false;
+		swake_up(kvm_arch_vcpu_wq(vcpu));
+	}
 }
 
 static void vcpu_sleep(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 1c17b2a..9ebb9b0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -231,23 +231,21 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
  * be migrated while we don't hold the IRQ locks and we don't want to be
  * chasing moving targets.
  *
- * For private interrupts, we only have to make sure the single and only VCPU
- * that can potentially queue the IRQ is stopped.
+ * For private interrupts we don't have to do anything because userspace
+ * accesses to the VGIC state already require all VCPUs to be stopped, and
+ * only the VCPU itself can modify its private interrupts active state, which
+ * guarantees that the VCPU is not running.
  */
 static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (intid < VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_halt_vcpu(vcpu);
-	else
+	if (intid > VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_halt_guest(vcpu->kvm);
 }
 
 /* See vgic_change_active_prepare */
 static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (intid < VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_resume_vcpu(vcpu);
-	else
+	if (intid > VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
 
@@ -258,6 +256,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 
+	mutex_lock(&vcpu->kvm->lock);
 	vgic_change_active_prepare(vcpu, intid);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
@@ -265,6 +264,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 	vgic_change_active_finish(vcpu, intid);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
@@ -274,6 +274,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 
+	mutex_lock(&vcpu->kvm->lock);
 	vgic_change_active_prepare(vcpu, intid);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
@@ -281,6 +282,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 	vgic_change_active_finish(vcpu, intid);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index d40210a..d4233e5 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -33,11 +33,12 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif =
 
 /*
  * Locking order is always:
- * its->cmd_lock (mutex)
- *   its->its_lock (mutex)
- *     vgic_cpu->ap_list_lock
- *       kvm->lpi_list_lock
- *         vgic_irq->irq_lock
+ * kvm->lock (mutex)
+ *   its->cmd_lock (mutex)
+ *     its->its_lock (mutex)
+ *       vgic_cpu->ap_list_lock
+ *         kvm->lpi_list_lock
+ *           vgic_irq->irq_lock
  *
  * If you need to take multiple locks, always take the upper lock first,
  * then the lower ones, e.g. first take the its_lock, then the irq_lock.
-- 
2.9.0
