From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 07/18] kvm: arm64: Configure VTCR_EL2 per VM
Date: Mon, 17 Sep 2018 11:41:29 +0100
Message-ID: <20180917104144.19188-8-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D61DA4A242
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:42:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vKu1-thyNyaf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Sep 2018 06:42:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 602274A27B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:42:42 -0400 (EDT)
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add support for setting the VTCR_EL2 per VM, rather than hard
coding a value at boot time per CPU. This would allow us to tune
the stage2 page table parameters per VM in the later changes.

We compute the VTCR fields based on the system wide sanitised
feature registers, except for the hardware management of Access
Flags (VTCR_EL2.HA). It is fine to run a system with a mix of
CPUs that may or may not update the page table Access Flags.
Since the bit is RES0 on CPUs that don't support it, the bit
should be ignored on them.

Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h  |  3 +-
 arch/arm64/include/asm/kvm_asm.h  |  2 -
 arch/arm64/include/asm/kvm_host.h | 12 ++++--
 arch/arm64/include/asm/kvm_hyp.h  |  1 +
 arch/arm64/kvm/hyp/Makefile       |  1 -
 arch/arm64/kvm/hyp/s2-setup.c     | 72 -------------------------------
 arch/arm64/kvm/reset.c            | 30 +++++++++++++
 7 files changed, 40 insertions(+), 81 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/s2-setup.c

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5f807b680a5f..14317b3a1820 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -135,8 +135,7 @@
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
  * not known to exist and will break with this configuration.
  *
- * VTCR_EL2.PS is extracted from ID_AA64MMFR0_EL1.PARange at boot time
- * (see hyp-init.S).
+ * The VTCR_EL2 is configured per VM and is initialised in kvm_arm_config_vm().
  *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together. With 16K pages, we concatenate 16 first level page tables.
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 102b5a5c47b6..0b53c72e7591 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -72,8 +72,6 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
-extern u32 __init_stage2_translation(void);
-
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b04280ae1be0..5ecd457bce7d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -61,11 +61,13 @@ struct kvm_arch {
 	u64    vmid_gen;
 	u32    vmid;
 
-	/* 1-level 2nd stage table, protected by kvm->mmu_lock */
+	/* stage2 entry level table */
 	pgd_t *pgd;
 
 	/* VTTBR value associated with above pgd and vmid */
 	u64    vttbr;
+	/* VTCR_EL2 value for this VM */
+	u64    vtcr;
 
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
@@ -442,10 +444,12 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 static inline void __cpu_init_stage2(void)
 {
-	u32 parange = kvm_call_hyp(__init_stage2_translation);
+	u32 ps;
 
-	WARN_ONCE(parange < 40,
-		  "PARange is %d bits, unsupported configuration!", parange);
+	/* Sanity check for minimum IPA size support */
+	ps = id_aa64mmfr0_parange_to_phys_shift(read_sysreg(id_aa64mmfr0_el1) & 0x7);
+	WARN_ONCE(ps < 40,
+		  "PARange is %d bits, unsupported configuration!", ps);
 }
 
 /* Guest/host FPSIMD coordination helpers */
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index d1bd1e0f14d7..23aca66767f9 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -161,6 +161,7 @@ void __noreturn __hyp_do_panic(unsigned long, ...);
  */
 static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
 {
+	write_sysreg(kvm->arch.vtcr, vtcr_el2);
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 }
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 2fabc2dc1966..82d1904328ad 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -19,7 +19,6 @@ obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
-obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
deleted file mode 100644
index e1ca672e937a..000000000000
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * Copyright (C) 2016 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/types.h>
-#include <asm/kvm_arm.h>
-#include <asm/kvm_asm.h>
-#include <asm/kvm_hyp.h>
-#include <asm/cpufeature.h>
-
-u32 __hyp_text __init_stage2_translation(void)
-{
-	u64 val = VTCR_EL2_FLAGS;
-	u64 parange;
-	u32 phys_shift;
-	u64 tmp;
-
-	/*
-	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS
-	 * bits in VTCR_EL2. Amusingly, the PARange is 4 bits, but the
-	 * allocated values are limited to 3bits.
-	 */
-	parange = read_sysreg(id_aa64mmfr0_el1) & 7;
-	if (parange > ID_AA64MMFR0_PARANGE_MAX)
-		parange = ID_AA64MMFR0_PARANGE_MAX;
-	val |= parange << VTCR_EL2_PS_SHIFT;
-
-	/* Compute the actual PARange... */
-	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
-
-	/*
-	 * ... and clamp it to 40 bits, unless we have some braindead
-	 * HW that implements less than that. In all cases, we'll
-	 * return that value for the rest of the kernel to decide what
-	 * to do.
-	 */
-	val |= VTCR_EL2_T0SZ(phys_shift > 40 ? 40 : phys_shift);
-
-	/*
-	 * Check the availability of Hardware Access Flag / Dirty Bit
-	 * Management in ID_AA64MMFR1_EL1 and enable the feature in VTCR_EL2.
-	 */
-	tmp = (read_sysreg(id_aa64mmfr1_el1) >> ID_AA64MMFR1_HADBS_SHIFT) & 0xf;
-	if (tmp)
-		val |= VTCR_EL2_HA;
-
-	/*
-	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS
-	 * bit in VTCR_EL2.
-	 */
-	tmp = (read_sysreg(id_aa64mmfr1_el1) >> ID_AA64MMFR1_VMIDBITS_SHIFT) & 0xf;
-	val |= (tmp == ID_AA64MMFR1_VMIDBITS_16) ?
-			VTCR_EL2_VS_16BIT :
-			VTCR_EL2_VS_8BIT;
-
-	write_sysreg(val, vtcr_el2);
-
-	return phys_shift;
-}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b0c07dab5cb3..e0c49377b771 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -26,6 +26,7 @@
 
 #include <kvm/arm_arch_timer.h>
 
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
@@ -134,9 +135,38 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	return kvm_timer_vcpu_reset(vcpu);
 }
 
+/*
+ * Configure the VTCR_EL2 for this VM. The VTCR value is common
+ * across all the physical CPUs on the system. We use system wide
+ * sanitised values to fill in different fields, except for Hardware
+ * Management of Access Flags. HA Flag is set unconditionally on
+ * all CPUs, as it is safe to run with or without the feature and
+ * the bit is RES0 on CPUs that don't support it.
+ */
 int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
 {
+	u64 vtcr = VTCR_EL2_FLAGS;
+	u64 parange;
+
 	if (type)
 		return -EINVAL;
+
+	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
+	if (parange > ID_AA64MMFR0_PARANGE_MAX)
+		parange = ID_AA64MMFR0_PARANGE_MAX;
+	vtcr |= parange << VTCR_EL2_PS_SHIFT;
+
+	/*
+	 * Enable the Hardware Access Flag management, unconditionally
+	 * on all CPUs. The features is RES0 on CPUs without the support
+	 * and must be ignored by the CPUs.
+	 */
+	vtcr |= VTCR_EL2_HA;
+
+	/* Set the vmid bits */
+	vtcr |= (kvm_get_vmid_bits() == 16) ?
+		VTCR_EL2_VS_16BIT :
+		VTCR_EL2_VS_8BIT;
+	kvm->arch.vtcr = vtcr;
 	return 0;
 }
-- 
2.19.0
