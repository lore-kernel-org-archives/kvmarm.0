From: Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 25/52] arm64: KVM: Use per-CPU vector when BP hardening is enabled
Date: Mon, 26 Feb 2018 16:19:59 +0800
Message-ID: <1519633227-29832-26-git-send-email-alex.shi@linaro.org>
References: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>, "moderated list:KERNEL VIRTUAL
        MACHINE KVM FOR ARM" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE KVM
        FOR ARM" <kvmarm@lists.cs.columbia.edu>, "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

commit 6840bdd73d07 upstream

Now that we have per-CPU vectors, let's plug then in the KVM/arm64 code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>

Conflicts:
	mv changes from virt/kvm/arm/arm.c to arch/arm/kvm/arm.c
---
 arch/arm/include/asm/kvm_mmu.h   | 10 ++++++++++
 arch/arm/kvm/arm.c               |  8 +++++++-
 arch/arm64/include/asm/kvm_mmu.h | 38 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c      |  2 +-
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a58bbaa..d10e362 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -223,6 +223,16 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+static inline void *kvm_get_hyp_vector(void)
+{
+	return kvm_ksym_ref(__kvm_hyp_vector);
+}
+
+static inline int kvm_map_vectors(void)
+{
+	return 0;
+}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c38bfbe..4e4ae07 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1088,7 +1088,7 @@ static void cpu_init_hyp_mode(void *dummy)
 	pgd_ptr = kvm_mmu_get_httbr();
 	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
 	hyp_stack_ptr = stack_page + PAGE_SIZE;
-	vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
+	vector_ptr = (unsigned long)kvm_get_hyp_vector();
 
 	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
 	__cpu_init_stage2();
@@ -1345,6 +1345,12 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
+	err = kvm_map_vectors();
+	if (err) {
+		kvm_err("Cannot map vectors\n");
+		goto out_err;
+	}
+
 	/*
 	 * Map the Hyp stack pages
 	 */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6d22017..80bf337 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -313,5 +313,43 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+#include <asm/mmu.h>
+
+static inline void *kvm_get_hyp_vector(void)
+{
+	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
+	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
+
+	if (data->fn) {
+		vect = __bp_harden_hyp_vecs_start +
+		       data->hyp_vectors_slot * SZ_2K;
+
+		if (!cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
+			vect = lm_alias(vect);
+	}
+
+	return vect;
+}
+
+static inline int kvm_map_vectors(void)
+{
+	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
+				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
+				   PAGE_HYP_EXEC);
+}
+
+#else
+static inline void *kvm_get_hyp_vector(void)
+{
+	return kvm_ksym_ref(__kvm_hyp_vector);
+}
+
+static inline int kvm_map_vectors(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 0c848c1..cf6d962 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -50,7 +50,7 @@ static void __hyp_text __activate_traps_vhe(void)
 	val &= ~CPACR_EL1_FPEN;
 	write_sysreg(val, cpacr_el1);
 
-	write_sysreg(__kvm_hyp_vector, vbar_el1);
+	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
 }
 
 static void __hyp_text __activate_traps_nvhe(void)
-- 
2.7.4
