From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 52/59] KVM: arm/arm64: vgic-new: vgic_init: implement
 vgic_create
Date: Tue, 24 May 2016 11:09:46 +0200
Message-ID: <1464080993-10884-53-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF0A149B7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKVx6XTIw7Tu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:07:25 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCB5749C52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:16 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id z87so15366486wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:49 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the vgic_creation function which is
called on CREATE_IRQCHIP VM IOCTL (v2 only) or KVM_CREATE_DEVICE

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/vgic/vgic.h       |  1 +
 virt/kvm/arm/vgic/vgic-init.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 393489f..0634d89 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -195,6 +195,7 @@ struct vgic_cpu {
 };
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+int kvm_vgic_create(struct kvm *kvm, u32 type);
 int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 4523beb..15d5428 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -22,6 +22,90 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+/* CREATION */
+
+/**
+ * kvm_vgic_create: triggered by the instantiation of the VGIC device by
+ * user space, either through the legacy KVM_CREATE_IRQCHIP ioctl (v2 only)
+ * or through the generic KVM_CREATE_DEVICE API ioctl.
+ * irqchip_in_kernel() tells you if this function succeeded or not.
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
2.1.2.330.g565301e.dirty
