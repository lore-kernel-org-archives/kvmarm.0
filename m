Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECA37C
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 08:40:17 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678264816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9bSFz9x8zTaosmdWMnNydvL4XGzHplCTGqn4bUJdVWk=;
	b=pb0ZNswCwuFlVBh37iJxZOFP31FQCzzyRndomNoObkdFZXk1rz5ZT/LS7uhlCuIVQOiR7q
	E3bqNn8DNrYPfEBpoWxRS3u/4e+HZyN9eFd18yffz+bEwzt2v3NLLFbOTq1GFcUyxfcDAS
	FPePmp2UKfuyAWM+MQjOtXmIFF2xHPM=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH] KVM: arm64: Avoid inverted vcpu->mutex v. kvm->lock ordering
Date: Wed,  8 Mar 2023 08:39:47 +0000
Message-Id: <20230308083947.3760066-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm->lock must be taken outside of the vcpu->mutex. Of course, the
locking documentation for KVM makes this abundantly clear. Nonetheless,
the locking order in KVM/arm64 has been wrong for quite a while; we
acquire the kvm->lock while holding the vcpu->mutex all over the shop.

All was seemingly fine until commit 42a90008f890 ("KVM: Ensure lockdep
knows about kvm->lock vs. vcpu->mutex ordering rule") caught us with our
pants down, leading to lockdep barfing:

 ======================================================
 WARNING: possible circular locking dependency detected
 6.2.0-rc7+ #19 Not tainted
 ------------------------------------------------------
 qemu-system-aar/859 is trying to acquire lock:
 ffff5aa69269eba0 (&host_kvm->lock){+.+.}-{3:3}, at: kvm_reset_vcpu+0x34/0x274

 but task is already holding lock:
 ffff5aa68768c0b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x8c/0xba0

 which lock already depends on the new lock.

Begrudgingly add a new lock, kvm->arch.lock, to protect the VM-scoped
state we care about that needs to be accessed from the context of a
vCPU. Fix up all the places we grab kvm->lock inside of vcpu->mutex by
using the new lock instead, which happens to be all over the place.

Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

I'm somewhat annoyed with the fix here, but annoyance alone isn't enough
to justify significantly reworking our locking scheme, and especially
not to address an existing bug.

I believe all of the required mutual exclusion is preserved, but another
set of eyes looking at this would be greatly appreciated. Note that the
issues in arch_timer were separately addressed by a patch from Marc [*].
With both patches applied I no longer see any lock inversion warnings w/
selftests nor kvmtool.

[*] https://lore.kernel.org/kvmarm/20230224191640.3396734-1-maz@kernel.org/

 arch/arm64/include/asm/kvm_host.h  |  3 +++
 arch/arm64/kvm/arm.c               |  6 ++++--
 arch/arm64/kvm/hypercalls.c        |  4 ++--
 arch/arm64/kvm/pmu-emul.c          | 18 +++++++++---------
 arch/arm64/kvm/psci.c              |  8 ++++----
 arch/arm64/kvm/reset.c             |  6 +++---
 arch/arm64/kvm/vgic/vgic-init.c    | 20 ++++++++++----------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  5 +++--
 arch/arm64/kvm/vgic/vgic-mmio.c    | 12 ++++++------
 9 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f6032..2b1070a526de 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
+#include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/psci.h>
 #include <asm/arch_gicv3.h>
@@ -185,6 +186,8 @@ struct kvm_protected_vm {
 };
 
 struct kvm_arch {
+	struct mutex lock;
+
 	struct kvm_s2_mmu mmu;
 
 	/* VTCR_EL2 value for this VM */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..267923d61cb7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -128,6 +128,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	mutex_init(&kvm->arch.lock);
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -593,9 +595,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.lock);
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 64c086c02c60..204de66f4227 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -377,7 +377,7 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 	if (val & ~fw_reg_features)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.lock);
 
 	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) &&
 	    val != *fw_reg_bmap) {
@@ -387,7 +387,7 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 
 	WRITE_ONCE(*fw_reg_bmap, val);
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..15923e1cef58 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -874,7 +874,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	struct arm_pmu *arm_pmu;
 	int ret = -ENXIO;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.lock);
 	mutex_lock(&arm_pmus_lock);
 
 	list_for_each_entry(entry, &arm_pmus, entry) {
@@ -894,7 +894,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	}
 
 	mutex_unlock(&arm_pmus_lock);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.lock);
 	return ret;
 }
 
@@ -908,16 +908,16 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.lock);
 	if (!kvm->arch.arm_pmu) {
 		/* No PMU set, get the default one */
 		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
 		if (!kvm->arch.arm_pmu) {
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.lock);
 			return -ENODEV;
 		}
 	}
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.lock);
 
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
@@ -961,17 +961,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		     filter.action != KVM_PMU_EVENT_DENY))
 			return -EINVAL;
 
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.lock);
 
 		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.lock);
 			return -EBUSY;
 		}
 
 		if (!kvm->arch.pmu_filter) {
 			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
 			if (!kvm->arch.pmu_filter) {
-				mutex_unlock(&kvm->lock);
+				mutex_unlock(&kvm->arch.lock);
 				return -ENOMEM;
 			}
 
@@ -992,7 +992,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		else
 			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
 
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.lock);
 
 		return 0;
 	}
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 7fbc4c1b9df0..a3d15f241a14 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -254,9 +254,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
 	case PSCI_0_2_FN64_CPU_ON:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.lock);
 		val = kvm_psci_vcpu_on(vcpu);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.lock);
 		break;
 	case PSCI_0_2_FN_AFFINITY_INFO:
 		kvm_psci_narrow_to_32bit(vcpu);
@@ -405,9 +405,9 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.lock);
 		val = kvm_psci_vcpu_on(vcpu);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.lock);
 		break;
 	default:
 		val = PSCI_RET_NOT_SUPPORTED;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 49a3257dec46..c5abbfa83644 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,7 +205,7 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
 
 	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.lock);
 
 	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
 		/*
@@ -262,13 +262,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.lock);
 	ret = kvm_set_vm_width(vcpu);
 	if (!ret) {
 		reset_state = vcpu->arch.reset_state;
 		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
 	}
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.lock);
 
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index cd134db41a57..270ade658270 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -227,9 +227,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->arch.lock);
 		ret = vgic_register_redist_iodev(vcpu);
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->arch.lock);
 	}
 	return ret;
 }
@@ -250,7 +250,7 @@ static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
  * The function is generally called when nr_spis has been explicitly set
  * by the guest through the KVM DEVICE API. If not nr_spis is set to 256.
  * vgic_initialized() returns true when this function has succeeded.
- * Must be called with kvm->lock held!
+ * Must be called with kvm->arch.lock held!
  */
 int vgic_init(struct kvm *kvm)
 {
@@ -373,7 +373,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
-/* To be called with kvm->lock held */
+/* To be called with kvm->arch.lock held */
 static void __kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -389,9 +389,9 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
 
 void kvm_vgic_destroy(struct kvm *kvm)
 {
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.lock);
 	__kvm_vgic_destroy(kvm);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.lock);
 }
 
 /**
@@ -414,9 +414,9 @@ int vgic_lazy_init(struct kvm *kvm)
 		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
 			return -EBUSY;
 
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.lock);
 		ret = vgic_init(kvm);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.lock);
 	}
 
 	return ret;
@@ -441,7 +441,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (likely(vgic_ready(kvm)))
 		return 0;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.lock);
 	if (vgic_ready(kvm))
 		goto out;
 
@@ -459,7 +459,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		dist->ready = true;
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..680c795fa098 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -106,12 +106,13 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 				    unsigned long val)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct kvm *kvm = vcpu->kvm;
 
 	switch (addr & 0x0c) {
 	case GICD_CTLR: {
 		bool was_enabled, is_hwsgi;
 
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&kvm->arch.lock);
 
 		was_enabled = dist->enabled;
 		is_hwsgi = dist->nassgireq;
@@ -139,7 +140,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		else if (!was_enabled && dist->enabled)
 			vgic_kick_vcpus(vcpu->kvm);
 
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&kvm->arch.lock);
 		break;
 	}
 	case GICD_TYPER:
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index e67b3b2c8044..3f747d333a7e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -530,13 +530,13 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 val;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	val = __vgic_mmio_read_active(vcpu, addr, len);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.lock);
 
 	return val;
 }
@@ -625,13 +625,13 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.lock);
 }
 
 int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
@@ -662,13 +662,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.lock);
 }
 
 int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,

base-commit: 0d3b2b4d2364166a955d03407ddace9269c603a5
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

