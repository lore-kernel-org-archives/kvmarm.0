From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 28/55] KVM: arm/arm64: Prepare vgic state for the nested VM
Date: Mon,  9 Jan 2017 01:24:24 -0500
Message-ID: <1483943091-1364-29-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D02C2404F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PoKSPDMSG8RK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:27 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC69440194
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:27 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5CD006198
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:09 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 3D534A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:09 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id DE8F9AB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:08 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q8vg041176
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:08 -0500
Received: by mail-qk0-f198.google.com with SMTP id c69so110043503qkg.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:08 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When entering a nested VM, we set up the hypervisor control interface
based on what the guest hypervisor has set. Especially, we investigate
each list register written by the guest hypervisor whether HW bit is
set.  If so, we translate hw irq number from the guest's point of view
to the real hardware irq number if there is a mapping.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_emulate.h   |  5 ++
 arch/arm64/include/asm/kvm_emulate.h |  5 ++
 arch/arm64/kvm/context.c             |  4 ++
 include/kvm/arm_vgic.h               |  8 +++
 virt/kvm/arm/vgic/vgic-init.c        |  3 ++
 virt/kvm/arm/vgic/vgic-v2-nested.c   | 99 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h             | 11 ++++
 7 files changed, 135 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 0fa2f5a..05d5906 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -101,6 +101,11 @@ static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static inline bool vcpu_el2_imo_is_set(const struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_pc;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0987ee4..a9c993f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -178,6 +178,11 @@ static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
 	return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;
 }
 
+static inline bool vcpu_el2_imo_is_set(const struct kvm_vcpu *vcpu)
+{
+	return (vcpu_el2_reg(vcpu, HCR_EL2) & HCR_IMO);
+}
+
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index 0025dd9..7a94c9d 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -161,6 +161,8 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 		ctxt->hw_sys_regs = ctxt->sys_regs;
 		ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
 	}
+
+	vgic_v2_setup_shadow_state(vcpu);
 }
 
 /**
@@ -179,6 +181,8 @@ void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
 		*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
 		ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
 	}
+
+	vgic_v2_restore_shadow_state(vcpu);
 }
 
 void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9a9cb27..484f6b1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -312,6 +312,14 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+void vgic_v2_setup_shadow_state(struct kvm_vcpu *vcpu);
+void vgic_v2_restore_shadow_state(struct kvm_vcpu *vcpu);
+#else
+static inline void vgic_v2_setup_shadow_state(struct kvm_vcpu *vcpu) { }
+static inline void vgic_v2_restore_shadow_state(struct kvm_vcpu *vcpu) { }
+#endif
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 8cebfbc..06ab8a5 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -216,6 +216,9 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 			irq->config = VGIC_CONFIG_LEVEL;
 		}
 	}
+
+	vgic_init_nested(vcpu);
+
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_enable(vcpu);
 	else
diff --git a/virt/kvm/arm/vgic/vgic-v2-nested.c b/virt/kvm/arm/vgic/vgic-v2-nested.c
index b13128e..a992da5 100644
--- a/virt/kvm/arm/vgic/vgic-v2-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v2-nested.c
@@ -205,3 +205,102 @@ static void vgic_mmio_write_v2_gich(struct kvm_vcpu *vcpu,
 		vgic_mmio_read_v2_gich, vgic_mmio_write_v2_gich,
 		4 * VGIC_V2_MAX_LRS, VGIC_ACCESS_32bit),
 };
+
+/*
+ * For LRs which have HW bit set such as timer interrupts, we modify them to
+ * have the host hardware interrupt number instead of the virtual one programmed
+ * by the guest hypervisor.
+ */
+static void vgic_v2_create_shadow_lr(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct vgic_v2_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	struct vgic_v2_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_irq *irq;
+
+	int nr_lr = kvm_vgic_global_state.nr_lr;
+
+	for (i = 0; i < nr_lr; i++) {
+		u32 lr = cpu_if->vgic_lr[i];
+		int l1_irq;
+
+		if (!(lr & GICH_LR_HW))
+			goto next;
+
+		/* We have the HW bit set */
+		l1_irq = (lr & GICH_LR_PHYSID_CPUID) >>
+			GICH_LR_PHYSID_CPUID_SHIFT;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, l1_irq);
+
+		if (!irq->hw) {
+			/* There was no real mapping, so nuke the HW bit */
+			lr &= ~GICH_LR_HW;
+			vgic_put_irq(vcpu->kvm, irq);
+			goto next;
+		}
+
+		/* Translate the virtual mapping to the real one */
+		lr &= ~GICH_LR_EOI;
+		lr &= ~GICH_LR_PHYSID_CPUID;
+		lr |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+		vgic_put_irq(vcpu->kvm, irq);
+
+next:
+		s_cpu_if->vgic_lr[i] = lr;
+	}
+}
+
+/*
+ * Change the shadow HWIRQ field back to the virtual value before copying over
+ * the entire shadow struct to the nested state.
+ */
+static void vgic_v2_restore_shadow_lr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	struct vgic_v2_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	int nr_lr = kvm_vgic_global_state.nr_lr;
+	int lr;
+
+	for (lr = 0; lr < nr_lr; lr++) {
+		s_cpu_if->vgic_lr[lr] &= ~GICH_LR_PHYSID_CPUID;
+		s_cpu_if->vgic_lr[lr] |= cpu_if->vgic_lr[lr] &
+			GICH_LR_PHYSID_CPUID;
+	}
+}
+
+void vgic_v2_setup_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v2_cpu_if *cpu_if;
+
+	if (vcpu_el2_imo_is_set(vcpu) && !vcpu_mode_el2(vcpu)) {
+		vgic_cpu->shadow_vgic_v2 = vgic_cpu->nested_vgic_v2;
+		vgic_v2_create_shadow_lr(vcpu);
+		cpu_if = vcpu_shadow_if(vcpu);
+	} else {
+		cpu_if = &vgic_cpu->vgic_v2;
+	}
+
+	vgic_cpu->hw_v2_cpu_if = cpu_if;
+}
+
+void vgic_v2_restore_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	/* Not using shadow state: Nothing to do... */
+	if (vgic_cpu->hw_v2_cpu_if == &vgic_cpu->vgic_v2)
+		return;
+
+	/*
+	 * Translate the shadow state HW fields back to the virtual ones
+	 * before copying the shadow struct back to the nested one.
+	 */
+	vgic_v2_restore_shadow_lr(vcpu);
+	vgic_cpu->nested_vgic_v2 = vgic_cpu->shadow_vgic_v2;
+}
+
+void vgic_init_nested(struct kvm_vcpu *vcpu)
+{
+	vgic_v2_setup_shadow_state(vcpu);
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 9d9e014..2aef680 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -120,4 +120,15 @@ static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+void vgic_init_nested(struct kvm_vcpu *vcpu);
+#else
+static inline void vgic_init_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	vgic_cpu->hw_v2_cpu_if = &vgic_cpu->vgic_v2;
+}
+#endif
+
 #endif
-- 
1.9.1
