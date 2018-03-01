From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 22/23] arm64: KVM: Allow mapping of vectors outside of the
 RAM region
Date: Thu,  1 Mar 2018 15:55:37 +0000
Message-ID: <20180301155538.26860-23-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A8349FD1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:51:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LJjX6BJAbtsD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:51:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F02049E12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:32 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We're now ready to map our vectors in weird and wonderful locations.
On enabling ARM64_HARDEN_EL2_VECTORS, a vector slots gets allocated
if this hasn't been already done via ARM64_HARDEN_BRANCH_PREDICTOR
and gets mapped outside of the normal RAM region, next to the
idmap.

That way, being able to obtain VBAR_EL2 doesn't reveal the mapping
of the rest of the hypervisor code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/arm64/memory.txt   |  3 +-
 arch/arm64/Kconfig               | 16 ++++++++
 arch/arm64/include/asm/kvm_mmu.h | 81 ++++++++++++++++++++++++++++++++++------
 arch/arm64/include/asm/mmu.h     |  5 ++-
 arch/arm64/kernel/Makefile       |  4 +-
 arch/arm64/kvm/va_layout.c       |  3 ++
 6 files changed, 96 insertions(+), 16 deletions(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index c58cc5dbe667..c5dab30d3389 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -90,7 +90,8 @@ When using KVM without the Virtualization Host Extensions, the
 hypervisor maps kernel pages in EL2 at a fixed (and potentially
 random) offset from the linear mapping. See the kern_hyp_va macro and
 kvm_update_va_mask function for more details. MMIO devices such as
-GICv2 gets mapped next to the HYP idmap page.
+GICv2 gets mapped next to the HYP idmap page, as do vectors when
+ARM64_HARDEN_EL2_VECTORS is selected for particular CPUs.
 
 When using KVM with the Virtualization Host Extensions, no additional
 mappings are created, since the host kernel runs directly in EL2.
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7381eeb7ef8e..e6be4393aaad 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -904,6 +904,22 @@ config HARDEN_BRANCH_PREDICTOR
 
 	  If unsure, say Y.
 
+config HARDEN_EL2_VECTORS
+	bool "Harden EL2 vector mapping against system register leak" if EXPERT
+	default y
+	help
+	  Speculation attacks against some high-performance processors can
+	  be used to leak privileged information such as the vector base
+	  register, resulting in a potential defeat of the EL2 layout
+	  randomization.
+
+	  This config option will map the vectors to a fixed location,
+	  independent of the EL2 code mapping, so that revealing VBAR_EL2
+	  to an attacker does no give away any extra information. This
+	  only gets enabled on affected CPUs.
+
+	  If unsure, say Y.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 3da9e5aea936..433d13d0c271 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -360,33 +360,90 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
+     defined(CONFIG_HARDEN_EL2_VECTORS))
+/*
+ * EL2 vectors can be mapped and rerouted in a number of ways,
+ * depending on the kernel configuration and CPU present:
+ *
+ * - If the CPU has the ARM64_HARDEN_BRANCH_PREDICTOR cap, the
+ *   hardening sequence is placed in one of the vector slots, which is
+ *   executed before jumping to the real vectors.
+ *
+ * - If the CPU has both the ARM64_HARDEN_EL2_VECTORS and BP
+ *   hardening, the slot containing the hardening sequence is mapped
+ *   next to the idmap page, and executed before jumping to the real
+ *   vectors.
+ *
+ * - If the CPU only has ARM64_HARDEN_EL2_VECTORS, then an empty slot
+ *   is selected, mapped next to the idmap page, and executed before
+ *   jumping to the real vectors.
+ *
+ * Note that ARM64_HARDEN_EL2_VECTORS is somewhat incompatible with
+ * VHE, as we don't have hypervisor-specific mappings. If the system
+ * is VHE and yet selects this capability, it will be ignored.
+ */
 #include <asm/mmu.h>
 
+extern void *__kvm_bp_vect_base;
+extern int __kvm_harden_el2_vector_slot;
+
 static inline void *kvm_get_hyp_vector(void)
 {
 	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
-	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
+	int slot = -1;
+
+	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn)
+		slot = data->hyp_vectors_slot;
+
+	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS) &&
+	    !has_vhe() && slot == -1)
+		slot = __kvm_harden_el2_vector_slot;
 
-	if (data->fn) {
-		vect = __bp_harden_hyp_vecs_start +
-		       data->hyp_vectors_slot * SZ_2K;
+	if (slot != -1) {
+		void *vect;
 
 		if (!has_vhe())
-			vect = lm_alias(vect);
+			vect = __kvm_bp_vect_base;
+		else
+			vect = __bp_harden_hyp_vecs_start;
+		vect += slot * SZ_2K;
+
+		return vect;
 	}
 
-	vect = kern_hyp_va(vect);
-	return vect;
+	return kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
 }
 
+/*  This is only called on a !VHE system */
 static inline int kvm_map_vectors(void)
 {
-	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
-				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
-				   PAGE_HYP_EXEC);
-}
+	phys_addr_t vect_pa = virt_to_phys(__bp_harden_hyp_vecs_start);
+	unsigned long size = __bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start;
+
+	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
+		int ret;
+
+		ret = create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
+					  kvm_ksym_ref(__bp_harden_hyp_vecs_end),
+					  PAGE_HYP_EXEC);
+
+		if (ret)
+			return ret;
+
+		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs_start);
+		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
+	}
+
+	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
+		__kvm_harden_el2_vector_slot = atomic_inc_return(&arm64_el2_vector_last_slot);
+		BUG_ON(__kvm_harden_el2_vector_slot >= BP_HARDEN_EL2_SLOTS);
+		return create_hyp_exec_mappings(vect_pa, size,
+						&__kvm_bp_vect_base);
+	}
 
+	return 0;
+}
 #else
 static inline void *kvm_get_hyp_vector(void)
 {
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 3baf010fe883..0b0cc69031c1 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -51,10 +51,12 @@ struct bp_hardening_data {
 	bp_hardening_cb_t	fn;
 };
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
+     defined(CONFIG_HARDEN_EL2_VECTORS))
 extern char __bp_harden_hyp_vecs_start[], __bp_harden_hyp_vecs_end[];
 extern atomic_t arm64_el2_vector_last_slot;
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 static inline struct bp_hardening_data *arm64_get_bp_hardening_data(void)
@@ -81,6 +83,7 @@ static inline struct bp_hardening_data *arm64_get_bp_hardening_data(void)
 
 static inline void arm64_apply_bp_hardening(void)	{ }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
+#endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS */
 
 extern void paging_init(void);
 extern void bootmem_init(void);
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index b87541360f43..e7fc471c91a6 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -54,8 +54,8 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
 arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
 
-ifeq ($(CONFIG_KVM),y)
-arm64-obj-$(CONFIG_HARDEN_BRANCH_PREDICTOR)	+= bpi.o
+ifneq ($(filter y,$(CONFIG_HARDEN_BRANCH_PREDICTOR) $(CONFIG_HARDEN_EL2_VECTORS)),)
+arm64-obj-$(CONFIG_KVM)			+= bpi.o
 endif
 
 obj-y					+= $(arm64-obj-y) vdso/ probes/
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 7ef3d920c8d4..5d17bb50287c 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -153,6 +153,9 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 	}
 }
 
+void *__kvm_bp_vect_base;
+int __kvm_harden_el2_vector_slot;
+
 void kvm_patch_vector_branch(struct alt_instr *alt,
 			     __le32 *origptr, __le32 *updptr, int nr_inst)
 {
-- 
2.14.2
