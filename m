From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 40/59] KVM: arm/arm64: vgic-new: Add GICv3 SGI system register
 trap handler
Date: Tue, 24 May 2016 11:09:34 +0200
Message-ID: <1464080993-10884-41-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F37D49BBF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9mkBJQBIMZV1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:07:07 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B247849C3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:02 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id z87so15358288wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:36 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

In contrast to GICv2 SGIs in a GICv3 implementation are not triggered
by a MMIO write, but with a system register write. KVM knows about
that register already, we just need to implement the handler and wire
it up to the core KVM/ARM code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/vgic/vgic.h          |   8 +++
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 106 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index ff3f9c2..00e3dca 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -209,6 +209,14 @@ bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
+#else
+static inline void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
+{
+}
+#endif
+
 /**
  * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
  *
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 4dcef9e..a0c515a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -347,3 +347,109 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 
 	return ret;
 }
+
+/*
+ * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
+ * generation register ICC_SGI1R_EL1) with a given VCPU.
+ * If the VCPU's MPIDR matches, return the level0 affinity, otherwise
+ * return -1.
+ */
+static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
+{
+	unsigned long affinity;
+	int level0;
+
+	/*
+	 * Split the current VCPU's MPIDR into affinity level 0 and the
+	 * rest as this is what we have to compare against.
+	 */
+	affinity = kvm_vcpu_get_mpidr_aff(vcpu);
+	level0 = MPIDR_AFFINITY_LEVEL(affinity, 0);
+	affinity &= ~MPIDR_LEVEL_MASK;
+
+	/* bail out if the upper three levels don't match */
+	if (sgi_aff != affinity)
+		return -1;
+
+	/* Is this VCPU's bit set in the mask ? */
+	if (!(sgi_cpu_mask & BIT(level0)))
+		return -1;
+
+	return level0;
+}
+
+/*
+ * The ICC_SGI* registers encode the affinity differently from the MPIDR,
+ * so provide a wrapper to use the existing defines to isolate a certain
+ * affinity level.
+ */
+#define SGI_AFFINITY_LEVEL(reg, level) \
+	((((reg) & ICC_SGI1R_AFFINITY_## level ##_MASK) \
+	>> ICC_SGI1R_AFFINITY_## level ##_SHIFT) << MPIDR_LEVEL_SHIFT(level))
+
+/**
+ * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
+ * @vcpu: The VCPU requesting a SGI
+ * @reg: The value written into the ICC_SGI1R_EL1 register by that VCPU
+ *
+ * With GICv3 (and ARE=1) CPUs trigger SGIs by writing to a system register.
+ * This will trap in sys_regs.c and call this function.
+ * This ICC_SGI1R_EL1 register contains the upper three affinity levels of the
+ * target processors as well as a bitmask of 16 Aff0 CPUs.
+ * If the interrupt routing mode bit is not set, we iterate over all VCPUs to
+ * check for matching ones. If this bit is set, we signal all, but not the
+ * calling VCPU.
+ */
+void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_vcpu *c_vcpu;
+	u16 target_cpus;
+	u64 mpidr;
+	int sgi, c;
+	int vcpu_id = vcpu->vcpu_id;
+	bool broadcast;
+
+	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
+	broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
+	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
+	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
+	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
+	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
+
+	/*
+	 * We iterate over all VCPUs to find the MPIDRs matching the request.
+	 * If we have handled one CPU, we clear its bit to detect early
+	 * if we are already finished. This avoids iterating through all
+	 * VCPUs when most of the times we just signal a single VCPU.
+	 */
+	kvm_for_each_vcpu(c, c_vcpu, kvm) {
+		struct vgic_irq *irq;
+
+		/* Exit early if we have dealt with all requested CPUs */
+		if (!broadcast && target_cpus == 0)
+			break;
+
+		/* Don't signal the calling VCPU */
+		if (broadcast && c == vcpu_id)
+			continue;
+
+		if (!broadcast) {
+			int level0;
+
+			level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
+			if (level0 == -1)
+				continue;
+
+			/* remove this matching VCPU from the mask */
+			target_cpus &= ~BIT(level0);
+		}
+
+		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
+
+		spin_lock(&irq->irq_lock);
+		irq->pending = true;
+
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+	}
+}
-- 
2.1.2.330.g565301e.dirty
