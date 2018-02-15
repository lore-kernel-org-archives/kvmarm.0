From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 06/40] KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
Date: Thu, 15 Feb 2018 22:02:58 +0100
Message-ID: <20180215210332.8648-7-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
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
index 9003bd19cb70..e27caa4b47a1 100644
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
index 248b930563e5..6137195ab815 100644
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
index ae45ae96aac2..e86679daddff 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -44,7 +44,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu, u32 *fpexc_host)
 		isb();
 	}
 
-	write_sysreg(vcpu->arch.hcr | vcpu->arch.irq_lines, HCR);
+	write_sysreg(vcpu->arch.hcr, HCR);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(HSTR_T(15), HSTR);
 	write_sysreg(HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11), HCPTR);
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4610bc818097..9ee316b962c8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -69,14 +69,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
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
 
 static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 618cfee7206a..b027a7f025d4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -272,9 +272,6 @@ struct kvm_vcpu_arch {
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-	/* Interrupt related fields */
-	u64 irq_lines;		/* IRQ and FIQ levels */
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 53f3e3486a19..b51638490d85 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -178,12 +178,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 
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
index 60666a056944..c1e179d34e6a 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -167,7 +167,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 static void pend_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
 {
 	vcpu_set_vsesr(vcpu, esr);
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+	*vcpu_hcr(vcpu) |= HCR_VSE;
 }
 
 /**
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 932e61858c55..49d13510e9c2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -420,7 +420,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
+	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
+	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !v->arch.power_off && !v->arch.pause);
 }
 
@@ -814,18 +815,18 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
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
index ec62d1cccab7..9ebff8e530f9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2035,7 +2035,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
  */
 void kvm_set_way_flush(struct kvm_vcpu *vcpu)
 {
-	unsigned long hcr = vcpu_get_hcr(vcpu);
+	unsigned long hcr = *vcpu_hcr(vcpu);
 
 	/*
 	 * If this is the first time we do a S/W operation
@@ -2050,7 +2050,7 @@ void kvm_set_way_flush(struct kvm_vcpu *vcpu)
 		trace_kvm_set_way_flush(*vcpu_pc(vcpu),
 					vcpu_has_cache_enabled(vcpu));
 		stage2_flush_vm(vcpu->kvm);
-		vcpu_set_hcr(vcpu, hcr | HCR_TVM);
+		*vcpu_hcr(vcpu) = hcr | HCR_TVM;
 	}
 }
 
@@ -2068,7 +2068,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	/* Caches are now on, stop trapping VM ops (until a S/W op) */
 	if (now_enabled)
-		vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) & ~HCR_TVM);
+		*vcpu_hcr(vcpu) &= ~HCR_TVM;
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
-- 
2.14.2
