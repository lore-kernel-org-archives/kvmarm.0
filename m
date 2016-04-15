From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 39/45] KVM: arm/arm64: vgic-new: vgic_init: implement vgic_create
Date: Fri, 15 Apr 2016 18:11:50 +0100
Message-ID: <1460740316-8755-40-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the vgic_creation function which is
called on CREATE_IRQCHIP VM IOCTL (v2 only) or KVM_CREATE_DEVICE

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h       |  1 +
 virt/kvm/arm/vgic/vgic_init.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index e16bfeb..2bea557 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -198,6 +198,7 @@ struct vgic_cpu {
 };
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+int kvm_vgic_create(struct kvm *kvm, u32 type);
 int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
index d7c50bb..80bf283 100644
--- a/virt/kvm/arm/vgic/vgic_init.c
+++ b/virt/kvm/arm/vgic/vgic_init.c
@@ -24,6 +24,90 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+/* CREATION */
+
+/**
+ * kvm_vgic_create: triggered by the instantiation of the VGIC device by
+ * user space, either through the legacy ARM specific VM IOCTL (CREATE_IRQCHIP)
+ * or through the generic VM IOCTL, KVM_CREATE_DEVICE API.
+ * Completion can be tested by irqchip_in_kernel
+ */
+int kvm_vgic_create(struct kvm *kvm, u32 type)
+{
+	int i, vcpu_lock_idx = -1, ret;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm->lock);
+
+	if (irqchip_in_kernel(kvm)) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	/*
+	 * This function is also called by the KVM_CREATE_IRQCHIP handler,
+	 * which had no chance yet to check the availability of the GICv2
+	 * emulation. So check this here again. KVM_CREATE_DEVICE does
+	 * the proper checks already.
+	 */
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+		!kvm_vgic_global_state.can_emulate_gicv2) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/*
+	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
+	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
+	 * that no other VCPUs are run while we create the vgic.
+	 */
+	ret = -EBUSY;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!mutex_trylock(&vcpu->mutex))
+			goto out_unlock;
+		vcpu_lock_idx = i;
+	}
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.has_run_once)
+			goto out_unlock;
+	}
+	ret = 0;
+
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
+		kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
+	else
+		kvm->arch.max_vcpus = VGIC_V3_MAX_CPUS;
+
+	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
+		ret = -E2BIG;
+		goto out_unlock;
+	}
+
+	kvm->arch.vgic.in_kernel = true;
+	kvm->arch.vgic.vgic_model = type;
+
+	/*
+	 * kvm_vgic_global_state.vctrl_base is set on vgic probe (kvm_arch_init)
+	 * it is stored in distributor struct for asm save/restore purpose
+	 */
+	kvm->arch.vgic.vctrl_base = kvm_vgic_global_state.vctrl_base;
+
+	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
+	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
+	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
+
+out_unlock:
+	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
+		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
+		mutex_unlock(&vcpu->mutex);
+	}
+
+out:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 /* GENERIC PROBE */
 
 static void vgic_init_maintenance_interrupt(void *info)
-- 
2.7.3

