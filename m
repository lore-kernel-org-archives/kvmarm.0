From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 06/41] KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
Date: Fri, 12 Jan 2018 13:07:12 +0100
Message-ID: <20180112120747.27999-7-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E212749D62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mfeNEmdSnxPC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:12 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0898E49DD5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:11 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id r78so11482007wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:01 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently have a separate read-modify-write of the HCR_EL2 on entry
to the guest for the sole purpose of setting the VF and VI bits, if set.
Since this is most rarely the case (only when using userspace IRQ chip
and interrupts are in flight), let's get rid of this operation and
instead modify the bits in the vcpu->arch.hcr[_el2] directly when
needed.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h   |  9 ++-------
 arch/arm/include/asm/kvm_host.h      |  3 ---
 arch/arm/kvm/emulate.c               |  2 +-
 arch/arm/kvm/hyp/switch.c            |  2 +-
 arch/arm64/include/asm/kvm_emulate.h |  9 ++-------
 arch/arm64/include/asm/kvm_host.h    |  3 ---
 arch/arm64/kvm/hyp/switch.c          |  6 ------
 arch/arm64/kvm/inject_fault.c        |  2 +-
 virt/kvm/arm/arm.c                   | 11 ++++++-----
 virt/kvm/arm/mmu.c                   |  6 +++---
 10 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 3d22eb87f919..d5e1b8bf6422 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -92,14 +92,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr = HCR_GUEST_MASK;
 }
 
-static inline unsigned long vcpu_get_hcr(const struct kvm_vcpu *vcpu)
+static inline unsigned long *vcpu_hcr(const struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.hcr;
-}
-
-static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
-{
-	vcpu->arch.hcr = hcr;
+	return (unsigned long *)&vcpu->arch.hcr;
 }
 
 static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 6394fb99da7f..7f96b3541939 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -155,9 +155,6 @@ struct kvm_vcpu_arch {
 	/* HYP trapping configuration */
 	u32 hcr;
 
-	/* Interrupt related fields */
-	u32 irq_lines;		/* IRQ and FIQ levels */
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index cdff963f133a..fa501bf437f3 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -174,5 +174,5 @@ unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu)
  */
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VA);
+	*vcpu_hcr(vcpu) |= HCR_VA;
 }
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 330c9ce34ba5..c3b9799e2e13 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -43,7 +43,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu, u32 *fpexc_host)
 		isb();
 	}
 
-	write_sysreg(vcpu->arch.hcr | vcpu->arch.irq_lines, HCR);
+	write_sysreg(vcpu->arch.hcr, HCR);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(HSTR_T(15), HSTR);
 	write_sysreg(HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11), HCPTR);
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 8ff5aef44656..b36aaa1fe332 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -62,14 +62,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 }
 
-static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
+static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.hcr_el2;
-}
-
-static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
-{
-	vcpu->arch.hcr_el2 = hcr;
+	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
 static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6ce0b428a4db..59150c75f9a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -269,9 +269,6 @@ struct kvm_vcpu_arch {
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-	/* Interrupt related fields */
-	u64 irq_lines;		/* IRQ and FIQ levels */
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f6189d08753e..11ec1c6f3b84 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -171,12 +171,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	u64 val;
-
-	val = read_sysreg(hcr_el2);
-	val |= vcpu->arch.irq_lines;
-	write_sysreg(val, hcr_el2);
-
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_restore_state(vcpu);
 	else
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 8ecbcb40e317..2d38ede2eff0 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -173,5 +173,5 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
  */
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+	*vcpu_hcr(vcpu) |= HCR_VSE;
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 360df72692ee..46c125f1da56 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -419,7 +419,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
+	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
+	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !v->arch.power_off && !v->arch.pause);
 }
 
@@ -806,18 +807,18 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
 {
 	int bit_index;
 	bool set;
-	unsigned long *ptr;
+	unsigned long *hcr;
 
 	if (number == KVM_ARM_IRQ_CPU_IRQ)
 		bit_index = __ffs(HCR_VI);
 	else /* KVM_ARM_IRQ_CPU_FIQ */
 		bit_index = __ffs(HCR_VF);
 
-	ptr = (unsigned long *)&vcpu->arch.irq_lines;
+	hcr = vcpu_hcr(vcpu);
 	if (level)
-		set = test_and_set_bit(bit_index, ptr);
+		set = test_and_set_bit(bit_index, hcr);
 	else
-		set = test_and_clear_bit(bit_index, ptr);
+		set = test_and_clear_bit(bit_index, hcr);
 
 	/*
 	 * If we didn't change anything, no need to wake up or kick other CPUs
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b36945d49986..d93d56d4cc5b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1987,7 +1987,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
  */
 void kvm_set_way_flush(struct kvm_vcpu *vcpu)
 {
-	unsigned long hcr = vcpu_get_hcr(vcpu);
+	unsigned long hcr = *vcpu_hcr(vcpu);
 
 	/*
 	 * If this is the first time we do a S/W operation
@@ -2002,7 +2002,7 @@ void kvm_set_way_flush(struct kvm_vcpu *vcpu)
 		trace_kvm_set_way_flush(*vcpu_pc(vcpu),
 					vcpu_has_cache_enabled(vcpu));
 		stage2_flush_vm(vcpu->kvm);
-		vcpu_set_hcr(vcpu, hcr | HCR_TVM);
+		*vcpu_hcr(vcpu) = hcr | HCR_TVM;
 	}
 }
 
@@ -2020,7 +2020,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	/* Caches are now on, stop trapping VM ops (until a S/W op) */
 	if (now_enabled)
-		vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) & ~HCR_TVM);
+		*vcpu_hcr(vcpu) &= ~HCR_TVM;
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
-- 
2.14.2
