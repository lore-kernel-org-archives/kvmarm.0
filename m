Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590CC1A2C0B
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 03:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991530; cv=none; b=AMEakax4kKCZA2NtJd+B8D9bPtCPJqnP/tYzFh1pvyQee/L9X2rSafj68Hn8u3MSBwBb/nYwylIIzcU/pNxbD06iqt+Gill31hHUQLLtSJA7aj22jXti1CTxUHu4KGO26N7797v80hMNRApd1qogEBF8f1AX+pZCEkAf/P8qauk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991530; c=relaxed/simple;
	bh=/Aos0U+WI3bcMGAKCDIUBTe7/JmFl6MlJJpcL+aaK6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jsremdxRovE0mnXkXdpcvSDIWqDQ1JeptWm0uWo21RNm5BKjksnrStj94bpTtEO/W30E74C47kPC+ffnfqHaf0wupNJJk8g6K09fXh8zsu2QjFhN534MPHg7RqfJpV3FaEPBrUqT7nRi/MUiFiZTlF83PXnoBF5YCJcfEmbpqcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 834C11691;
	Tue, 24 Feb 2026 19:52:01 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1BF7A3F7BD;
	Tue, 24 Feb 2026 19:52:05 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/2] arm64/mm: Directly use TTBRx_EL1_ASID_MASK
Date: Wed, 25 Feb 2026 03:51:56 +0000
Message-Id: <20260225035157.1159962-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260225035157.1159962-1-anshuman.khandual@arm.com>
References: <20260225035157.1159962-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace all TTBR_ASID_MASK macro instances with TTBRx_EL1_ASID_MASK which
is a standard field mask from tools sysreg format. Drop the now redundant
custom macro TTBR_ASID_MASK. No functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/asm-uaccess.h | 2 +-
 arch/arm64/include/asm/mmu.h         | 1 -
 arch/arm64/include/asm/mmu_context.h | 2 +-
 arch/arm64/include/asm/uaccess.h     | 6 +++---
 arch/arm64/kernel/entry.S            | 2 +-
 arch/arm64/kvm/at.c                  | 2 +-
 arch/arm64/kvm/nested.c              | 4 ++--
 arch/arm64/mm/context.c              | 6 +++---
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index 9148f5a31968..12aa6a283249 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -15,7 +15,7 @@
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	.macro	__uaccess_ttbr0_disable, tmp1
 	mrs	\tmp1, ttbr1_el1			// swapper_pg_dir
-	bic	\tmp1, \tmp1, #TTBR_ASID_MASK
+	bic	\tmp1, \tmp1, #TTBRx_EL1_ASID_MASK
 	sub	\tmp1, \tmp1, #RESERVED_SWAPPER_OFFSET	// reserved_pg_dir
 	msr	ttbr0_el1, \tmp1			// set reserved TTBR0_EL1
 	add	\tmp1, \tmp1, #RESERVED_SWAPPER_OFFSET
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 137a173df1ff..019b36cda380 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -10,7 +10,6 @@
 #define MMCF_AARCH32	0x1	/* mm context flag for AArch32 executables */
 #define USER_ASID_BIT	48
 #define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
-#define TTBR_ASID_MASK	(UL(0xffff) << 48)
 
 #ifndef __ASSEMBLER__
 
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index cc80af59c69e..5b1ecde9f14b 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -210,7 +210,7 @@ static inline void update_saved_ttbr0(struct task_struct *tsk,
 	if (mm == &init_mm)
 		ttbr = phys_to_ttbr(__pa_symbol(reserved_pg_dir));
 	else
-		ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) | ASID(mm) << 48;
+		ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) | ASID(mm) << TTBRx_EL1_ASID_SHIFT;
 
 	WRITE_ONCE(task_thread_info(tsk)->ttbr0, ttbr);
 }
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 9810106a3f66..86dfc356ee6e 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -62,7 +62,7 @@ static inline void __uaccess_ttbr0_disable(void)
 
 	local_irq_save(flags);
 	ttbr = read_sysreg(ttbr1_el1);
-	ttbr &= ~TTBR_ASID_MASK;
+	ttbr &= ~TTBRx_EL1_ASID_MASK;
 	/* reserved_pg_dir placed before swapper_pg_dir */
 	write_sysreg(ttbr - RESERVED_SWAPPER_OFFSET, ttbr0_el1);
 	/* Set reserved ASID */
@@ -85,8 +85,8 @@ static inline void __uaccess_ttbr0_enable(void)
 
 	/* Restore active ASID */
 	ttbr1 = read_sysreg(ttbr1_el1);
-	ttbr1 &= ~TTBR_ASID_MASK;		/* safety measure */
-	ttbr1 |= ttbr0 & TTBR_ASID_MASK;
+	ttbr1 &= ~TTBRx_EL1_ASID_MASK;		/* safety measure */
+	ttbr1 |= ttbr0 & TTBRx_EL1_ASID_MASK;
 	write_sysreg(ttbr1, ttbr1_el1);
 
 	/* Restore user page table */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f8018b5c1f9a..9e1bcc821a16 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -473,7 +473,7 @@ alternative_else_nop_endif
 	 */
 SYM_CODE_START_LOCAL(__swpan_entry_el1)
 	mrs	x21, ttbr0_el1
-	tst	x21, #TTBR_ASID_MASK		// Check for the reserved ASID
+	tst	x21, #TTBRx_EL1_ASID_MASK	// Check for the reserved ASID
 	orr	x23, x23, #PSR_PAN_BIT		// Set the emulated PAN in the saved SPSR
 	b.eq	1f				// TTBR0 access already disabled
 	and	x23, x23, #~PSR_PAN_BIT		// Clear the emulated PAN in the saved SPSR
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 885bd5bb2f41..d5c342ccf0f9 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -560,7 +560,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			BUG();
 		}
 
-		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
+		wr->asid = FIELD_GET(TTBRx_EL1_ASID_MASK, asid_ttbr);
 		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
 		    !(tcr & TCR_ASID16))
 			wr->asid &= GENMASK(7, 0);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 620126d1f0dc..82558fb2685f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1343,7 +1343,7 @@ static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
 			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
 		u16 asid;
 
-		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
+		asid = FIELD_GET(TTBRx_EL1_ASID_MASK, ttbr);
 		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
 		    !(tcr & TCR_ASID16))
 			asid &= GENMASK(7, 0);
@@ -1459,7 +1459,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
 		u16 asid;
 
-		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
+		asid = FIELD_GET(TTBRx_EL1_ASID_MASK, ttbr);
 		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
 		    !(tcr & TCR_ASID16))
 			asid &= GENMASK(7, 0);
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index b2ac06246327..718c495832d0 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -358,11 +358,11 @@ void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm)
 
 	/* SW PAN needs a copy of the ASID in TTBR0 for entry */
 	if (IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN))
-		ttbr0 |= FIELD_PREP(TTBR_ASID_MASK, asid);
+		ttbr0 |= FIELD_PREP(TTBRx_EL1_ASID_MASK, asid);
 
 	/* Set ASID in TTBR1 since TCR.A1 is set */
-	ttbr1 &= ~TTBR_ASID_MASK;
-	ttbr1 |= FIELD_PREP(TTBR_ASID_MASK, asid);
+	ttbr1 &= ~TTBRx_EL1_ASID_MASK;
+	ttbr1 |= FIELD_PREP(TTBRx_EL1_ASID_MASK, asid);
 
 	cpu_set_reserved_ttbr0_nosync();
 	write_sysreg(ttbr1, ttbr1_el1);
-- 
2.30.2

