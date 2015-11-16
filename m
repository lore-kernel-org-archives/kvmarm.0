From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 3/3] arm64: KVM: Add support for 16-bit VMID
Date: Mon, 16 Nov 2015 11:28:18 +0000
Message-ID: <1447673298-25503-4-git-send-email-vladimir.murzin@arm.com>
References: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F31EC49786
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 06:28:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rWHiwOOKgpJK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 06:28:20 -0500 (EST)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [207.82.80.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E427449630
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 06:28:19 -0500 (EST)
In-Reply-To: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The ARMv8.1 architecture extension allows to choose between 8-bit and
16-bit of VMID, so use this capability for KVM.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/kvm_arm.h   |    2 +-
 arch/arm/include/asm/kvm_mmu.h   |    5 +++++
 arch/arm/kvm/arm.c               |   10 ++++++++--
 arch/arm64/include/asm/kvm_arm.h |    3 ++-
 arch/arm64/include/asm/kvm_mmu.h |    8 ++++++++
 arch/arm64/kvm/hyp-init.S        |    9 +++++++++
 6 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 01d4d7a..e22089f 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -164,7 +164,7 @@
 #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
 #define VTTBR_BADDR_MASK  (((_AC(1, ULL) << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
 #define VTTBR_VMID_SHIFT  _AC(48, ULL)
-#define VTTBR_VMID_MASK	  (_AC(0xff, ULL) << VTTBR_VMID_SHIFT)
+#define VTTBR_VMID_MASK(size)	(_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
 
 /* Hyp Syndrome Register (HSR) bits */
 #define HSR_EC_SHIFT	(26)
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 405aa18..9203c21 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -279,6 +279,11 @@ static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
 				       pgd_t *merged_hyp_pgd,
 				       unsigned long hyp_idmap_start) { }
 
+static inline unsigned int kvm_get_vmid_bits(void)
+{
+	return 8;
+}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index eab83b2..055980d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -58,7 +58,8 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
-static u8 kvm_next_vmid;
+static u32 kvm_next_vmid;
+static unsigned int kvm_vmid_bits __read_mostly;
 static DEFINE_SPINLOCK(kvm_vmid_lock);
 
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
@@ -433,11 +434,12 @@ static void update_vttbr(struct kvm *kvm)
 	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
 	kvm->arch.vmid = kvm_next_vmid;
 	kvm_next_vmid++;
+	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
 
 	/* update vttbr to be used with the new vmid */
 	pgd_phys = virt_to_phys(kvm_get_hwpgd(kvm));
 	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
-	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK;
+	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
 	kvm->arch.vttbr = pgd_phys | vmid;
 
 	spin_unlock(&kvm_vmid_lock);
@@ -1132,6 +1134,10 @@ static int init_hyp_mode(void)
 
 	kvm_perf_init();
 
+	/* set size of VMID supported by CPU */
+	kvm_vmid_bits = kvm_get_vmid_bits();
+	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
+
 	kvm_info("Hyp mode initialized successfully\n");
 
 	return 0;
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5e6857b..738a95f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -125,6 +125,7 @@
 #define VTCR_EL2_SL0_LVL1	(1 << 6)
 #define VTCR_EL2_T0SZ_MASK	0x3f
 #define VTCR_EL2_T0SZ_40B	24
+#define VTCR_EL2_VS		19
 
 /*
  * We configure the Stage-2 page tables to always restrict the IPA space to be
@@ -169,7 +170,7 @@
 #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
 #define VTTBR_BADDR_MASK  (((UL(1) << (PHYS_MASK_SHIFT - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
 #define VTTBR_VMID_SHIFT  (UL(48))
-#define VTTBR_VMID_MASK	  (UL(0xFF) << VTTBR_VMID_SHIFT)
+#define VTTBR_VMID_MASK(size) (_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
 
 /* Hyp System Trap Register */
 #define HSTR_EL2_T(x)	(1 << x)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 54cba80..0bf8b43 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -20,6 +20,7 @@
 
 #include <asm/page.h>
 #include <asm/memory.h>
+#include <asm/cpufeature.h>
 
 /*
  * As we only have the TTBR0_EL2 register, we cannot express
@@ -301,5 +302,12 @@ static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
 	merged_hyp_pgd[idmap_idx] = __pgd(__pa(boot_hyp_pgd) | PMD_TYPE_TABLE);
 }
 
+static inline unsigned int kvm_get_vmid_bits(void)
+{
+	int reg = read_system_reg(SYS_ID_AA64MMFR1_EL1);
+
+	return (cpuid_feature_extract_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 178ba22..3e568dc 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -94,6 +94,15 @@ __do_hyp_init:
 	 */
 	mrs	x5, ID_AA64MMFR0_EL1
 	bfi	x4, x5, #16, #3
+	/*
+	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
+	 * VTCR_EL2.
+	 */
+	mrs	x5, ID_AA64MMFR1_EL1
+	ubfx	x5, x5, #5, #1
+	lsl	x5, x5, #VTCR_EL2_VS
+	orr	x4, x4, x5
+
 	msr	vtcr_el2, x4
 
 	mrs	x4, mair_el1
-- 
1.7.9.5
