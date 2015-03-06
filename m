From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH roundup 4/4] arm64: KVM: use ID map with increased VA range if
 required
Date: Fri,  6 Mar 2015 15:34:42 +0100
Message-ID: <1425652482-31411-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F2647E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:29:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gCz+lXBv1vwt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 09:29:07 -0500 (EST)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CC5C47DCB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:29:07 -0500 (EST)
Received: by widem10 with SMTP id em10so3843380wid.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Mar 2015 06:35:14 -0800 (PST)
In-Reply-To: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch modifies the HYP init code so it can deal with system
RAM residing at an offset which exceeds the reach of VA_BITS.

Like for EL1, this involves configuring an additional level of
translation for the ID map. However, in case of EL2, this implies
that all translations use the extra level, as we cannot seamlessly
switch between translation tables with different numbers of
translation levels.

So add an extra translation table at the root level. Since the
ID map and the runtime HYP map are guaranteed not to overlap, they
can share this root level, and we can essentially merge these two
tables into one.

Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h   | 10 ++++++++++
 arch/arm/kvm/mmu.c               | 27 +++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_mmu.h | 33 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp-init.S        | 26 ++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 37ca2a4c6f09..617a30d00c1d 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -270,6 +270,16 @@ static inline void __kvm_flush_dcache_pud(pud_t pud)
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
 void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
 
+static inline bool __kvm_cpu_uses_extended_idmap(void)
+{
+	return false;
+}
+
+static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
+				       pgd_t *hyp_pgd,
+				       pgd_t *merged_hyp_pgd,
+				       unsigned long hyp_idmap_start) { }
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 42a24d6b003b..69c2b4ce6160 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -35,6 +35,7 @@ extern char  __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 
 static pgd_t *boot_hyp_pgd;
 static pgd_t *hyp_pgd;
+static pgd_t *merged_hyp_pgd;
 static DEFINE_MUTEX(kvm_hyp_pgd_mutex);
 
 static unsigned long hyp_idmap_start;
@@ -434,6 +435,11 @@ void free_hyp_pgds(void)
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
 	}
+	if (merged_hyp_pgd) {
+		clear_page(merged_hyp_pgd);
+		free_page((unsigned long)merged_hyp_pgd);
+		merged_hyp_pgd = NULL;
+	}
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
@@ -1473,12 +1479,18 @@ void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 
 phys_addr_t kvm_mmu_get_httbr(void)
 {
-	return virt_to_phys(hyp_pgd);
+	if (__kvm_cpu_uses_extended_idmap())
+		return virt_to_phys(merged_hyp_pgd);
+	else
+		return virt_to_phys(hyp_pgd);
 }
 
 phys_addr_t kvm_mmu_get_boot_httbr(void)
 {
-	return virt_to_phys(boot_hyp_pgd);
+	if (__kvm_cpu_uses_extended_idmap())
+		return virt_to_phys(merged_hyp_pgd);
+	else
+		return virt_to_phys(boot_hyp_pgd);
 }
 
 phys_addr_t kvm_get_idmap_vector(void)
@@ -1521,6 +1533,17 @@ int kvm_mmu_init(void)
 		goto out;
 	}
 
+	if (__kvm_cpu_uses_extended_idmap()) {
+		merged_hyp_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!merged_hyp_pgd) {
+			kvm_err("Failed to allocate extra HYP pgd\n");
+			goto out;
+		}
+		__kvm_extend_hypmap(boot_hyp_pgd, hyp_pgd, merged_hyp_pgd,
+				    hyp_idmap_start);
+		return 0;
+	}
+
 	/* Map the very same page at the trampoline VA */
 	err = 	__create_hyp_mappings(boot_hyp_pgd,
 				      TRAMPOLINE_VA, TRAMPOLINE_VA + PAGE_SIZE,
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6458b5373142..edfe6864bc28 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -68,6 +68,8 @@
 #include <asm/pgalloc.h>
 #include <asm/cachetype.h>
 #include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
 
 #define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
 
@@ -305,5 +307,36 @@ static inline void __kvm_flush_dcache_pud(pud_t pud)
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
 void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
 
+static inline bool __kvm_cpu_uses_extended_idmap(void)
+{
+	return __cpu_uses_extended_idmap();
+}
+
+static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
+				       pgd_t *hyp_pgd,
+				       pgd_t *merged_hyp_pgd,
+				       unsigned long hyp_idmap_start)
+{
+	int idmap_idx;
+
+	/*
+	 * Use the first entry to access the HYP mappings. It is
+	 * guaranteed to be free, otherwise we wouldn't use an
+	 * extended idmap.
+	 */
+	VM_BUG_ON(pgd_val(merged_hyp_pgd[0]));
+	merged_hyp_pgd[0] = __pgd(__pa(hyp_pgd) | PMD_TYPE_TABLE);
+
+	/*
+	 * Create another extended level entry that points to the boot HYP map,
+	 * which contains an ID mapping of the HYP init code. We essentially
+	 * merge the boot and runtime HYP maps by doing so, but they don't
+	 * overlap anyway, so this is fine.
+	 */
+	idmap_idx = hyp_idmap_start >> VA_BITS;
+	VM_BUG_ON(pgd_val(merged_hyp_pgd[idmap_idx]));
+	merged_hyp_pgd[idmap_idx] = __pgd(__pa(boot_hyp_pgd) | PMD_TYPE_TABLE);
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index c3191168a994..e7e75bea3fa6 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -20,6 +20,7 @@
 #include <asm/assembler.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/pgtable-hwdef.h>
 
 	.text
 	.pushsection	.hyp.idmap.text, "ax"
@@ -65,6 +66,26 @@ __do_hyp_init:
 	and	x4, x4, x5
 	ldr	x5, =TCR_EL2_FLAGS
 	orr	x4, x4, x5
+
+#ifndef CONFIG_ARM64_VA_BITS_48
+	/*
+	 * If we are running with VA_BITS < 48, we may be running with an extra
+	 * level of translation in the ID map. This is only the case if system
+	 * RAM is out of range for the currently configured page size and number
+	 * of translation levels, in which case we will also need the extra
+	 * level for the HYP ID map, or we won't be able to enable the EL2 MMU.
+	 *
+	 * However, at EL2, there is only one TTBR register, and we can't switch
+	 * between translation tables *and* update TCR_EL2.T0SZ at the same
+	 * time. Bottom line: we need the extra level in *both* our translation
+	 * tables.
+	 *
+	 * So use the same T0SZ value we use for the ID map.
+	 */
+	adrp	x5, idmap_t0sz			// get ID map TCR.T0SZ
+	ldr	x5, [x5, :lo12:idmap_t0sz]
+	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+#endif
 	msr	tcr_el2, x4
 
 	ldr	x4, =VTCR_EL2_FLAGS
@@ -91,6 +112,10 @@ __do_hyp_init:
 	msr	sctlr_el2, x4
 	isb
 
+	/* Skip the trampoline dance if we merged the boot and runtime PGDs */
+	cmp	x0, x1
+	b.eq	merged
+
 	/* MMU is now enabled. Get ready for the trampoline dance */
 	ldr	x4, =TRAMPOLINE_VA
 	adr	x5, target
@@ -105,6 +130,7 @@ target: /* We're now in the trampoline code, switch page tables */
 	tlbi	alle2
 	dsb	sy
 
+merged:
 	/* Set the stack and new vectors */
 	kern_hyp_va	x2
 	mov	sp, x2
-- 
1.8.3.2
