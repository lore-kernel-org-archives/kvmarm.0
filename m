From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 04/37] KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
Date: Thu, 12 Oct 2017 12:41:08 +0200
Message-ID: <20171012104141.26902-5-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2627149D6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ux3YGXSJ6VyO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:05 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC4B049D5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:03 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id q124so11978656wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:48 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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
index 98089ff..34663a8 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -62,14 +62,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
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
index 4a879f6..1100170 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -153,9 +153,6 @@ struct kvm_vcpu_arch {
 	/* HYP trapping configuration */
 	u32 hcr;
 
-	/* Interrupt related fields */
-	u32 irq_lines;		/* IRQ and FIQ levels */
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index 0064b86..4286a89 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -313,5 +313,5 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
  */
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VA);
+	*vcpu_hcr(vcpu) |= HCR_VA;
 }
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 330c9ce..c3b9799 100644
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
index e5df3fc..1fbfe96 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -51,14 +51,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
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
index 806ccef..27305e7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -266,9 +266,6 @@ struct kvm_vcpu_arch {
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-	/* Interrupt related fields */
-	u64 irq_lines;		/* IRQ and FIQ levels */
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index bcf1a79..7703d63 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -168,12 +168,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 
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
index da6a8cf..45c7026 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -241,5 +241,5 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
  */
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+	*vcpu_hcr(vcpu) |= HCR_VSE;
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7f9296a..6e9513e 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -411,7 +411,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
+	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
+	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !v->arch.power_off && !v->arch.pause);
 }
 
@@ -771,18 +772,18 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
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
index b36945d..d93d56d 100644
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
2.9.0
