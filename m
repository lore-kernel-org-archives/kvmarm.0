From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 31/55] KVM: arm/arm64: Inject maintenance interrupts to the
 guest hypervisor
Date: Mon,  9 Jan 2017 01:24:27 -0500
Message-ID: <1483943091-1364-32-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6967D4075C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aEi041k3QVI7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:32 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C7B9404CC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:32 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9dK018086
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:13 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id C1B1396
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:13 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id D239680
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:12 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QCir042537
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:12 -0500
Received: by mail-qk0-f200.google.com with SMTP id a195so63263047qkg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:12 -0800 (PST)
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

From: Christoffer Dall <christoffer.dall@linaro.org>

If we exit a nested VM with a pending maintenance interrupt from the
GIC, then we need to forward this to the guest hypervisor so that it can
re-sync the appropriate LRs and sample level triggered interrupts again.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/context.c           |  3 +++
 include/kvm/arm_vgic.h             |  2 ++
 virt/kvm/arm/vgic/vgic-v2-nested.c | 16 ++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index 7a94c9d..a93ffe4 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -140,6 +140,9 @@ static void sync_shadow_el1_state(struct kvm_vcpu *vcpu, bool setup)
 void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+	vgic_handle_nested_maint_irq(vcpu);
+
 	if (unlikely(vcpu_mode_el2(vcpu))) {
 		ctxt->hw_pstate = *vcpu_cpsr(vcpu) & ~PSR_MODE_MASK;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 484f6b1..fc882d6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -315,9 +315,11 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 #ifdef CONFIG_KVM_ARM_NESTED_HYP
 void vgic_v2_setup_shadow_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_shadow_state(struct kvm_vcpu *vcpu);
+void vgic_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 #else
 static inline void vgic_v2_setup_shadow_state(struct kvm_vcpu *vcpu) { }
 static inline void vgic_v2_restore_shadow_state(struct kvm_vcpu *vcpu) { }
+static inline void vgic_handle_nested_maint_irq(struct kvm_vcpu *vcpu) { }
 #endif
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
diff --git a/virt/kvm/arm/vgic/vgic-v2-nested.c b/virt/kvm/arm/vgic/vgic-v2-nested.c
index a992da5..85f646b 100644
--- a/virt/kvm/arm/vgic/vgic-v2-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v2-nested.c
@@ -300,6 +300,22 @@ void vgic_v2_restore_shadow_state(struct kvm_vcpu *vcpu)
 	vgic_cpu->nested_vgic_v2 = vgic_cpu->shadow_vgic_v2;
 }
 
+void vgic_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+
+	/*
+	 * If we exit a nested VM with a pending maintenance interrupt from the
+	 * GIC, then we need to forward this to the guest hypervisor so that it
+	 * can re-sync the appropriate LRs and sample level triggered interrupts
+	 * again.
+	 */
+	if (vcpu_el2_imo_is_set(vcpu) && !vcpu_mode_el2(vcpu) &&
+	    (cpu_if->vgic_hcr & GICH_HCR_EN) &&
+	    vgic_mmio_read_v2_misr(vcpu, 0, 0))
+		kvm_inject_nested_irq(vcpu);
+}
+
 void vgic_init_nested(struct kvm_vcpu *vcpu)
 {
 	vgic_v2_setup_shadow_state(vcpu);
-- 
1.9.1
