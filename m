Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4B8377016
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 06:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772433894; cv=none; b=OVwBbWeLkaZ0dz5gCTy6Ie4LKJMxCwYfT2VSZNgiZ52ARCBBxucPsrnxEksrsL1+eWylmTcwTh4Q6n6qKCnAdqeIGOdQf3AnoI2oLbnmc4+l/8s+rGCnUkcWfqVaF4ABGgC9iHChi8MpQdPmJwlKwvFLd24J+B886fyRxnskIkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772433894; c=relaxed/simple;
	bh=UN3pyCCU7wkNfIR0JWZbTPuMXE5bTPcsbWaItp10y4U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VvnGo34wwoD16pM/Gt64sc9v8wcdS5o4vhDo5dGSdKSTYkssxUEvFvIiYak8RGJl7rJ9tFlu0utGT0XaenamoFeS9cFz/MJuXHa30qVTiUzcCTusJUfG9B0n4cA8hcp16CEjJyIn6c/h2aC/socSVyFvGjvNbVVqK0s3Is5A0qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A1DB1596;
	Sun,  1 Mar 2026 22:44:45 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C2EF63F7BD;
	Sun,  1 Mar 2026 22:44:49 -0800 (PST)
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
Subject: [PATCH V2 2/2] arm64/mm: Directly use TTBRx_EL1_CnP
Date: Mon,  2 Mar 2026 06:44:37 +0000
Message-Id: <20260302064437.2791034-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260302064437.2791034-1-anshuman.khandual@arm.com>
References: <20260302064437.2791034-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace all TTBR_CNP_BIT macro instances with TTBRx_EL1_CNP_BIT which
is a standard field from tools sysreg format. Drop the now redundant
custom macro TTBR_CNP_BIT. No functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 2 --
 arch/arm64/kernel/mte.c                | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S     | 4 ++--
 arch/arm64/mm/context.c                | 2 +-
 arch/arm64/mm/mmu.c                    | 2 +-
 5 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index d49180bb7cb3..5e6809a462c7 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -223,8 +223,6 @@
  */
 #define S1_TABLE_AP		(_AT(pmdval_t, 3) << 61)
 
-#define TTBR_CNP_BIT		(UL(1) << 0)
-
 /*
  * TCR flags.
  */
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 32148bf09c1d..eceead1686f2 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -315,8 +315,8 @@ void mte_cpu_setup(void)
 	 * CnP is not a boot feature so MTE gets enabled before CnP, but let's
 	 * make sure that is the case.
 	 */
-	BUG_ON(read_sysreg(ttbr0_el1) & TTBR_CNP_BIT);
-	BUG_ON(read_sysreg(ttbr1_el1) & TTBR_CNP_BIT);
+	BUG_ON(read_sysreg(ttbr0_el1) & TTBRx_EL1_CnP);
+	BUG_ON(read_sysreg(ttbr1_el1) & TTBRx_EL1_CnP);
 
 	/* Normal Tagged memory type at the corresponding MAIR index */
 	sysreg_clear_set(mair_el1,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 0d42eedc7167..445eb0743af2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -130,7 +130,7 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
 	phys_to_ttbr x2, x1
 alternative_if ARM64_HAS_CNP
-	orr	x2, x2, #TTBR_CNP_BIT
+	orr	x2, x2, #TTBRx_EL1_CnP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x2
 
@@ -291,7 +291,7 @@ SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Install the new pgtables */
 	phys_to_ttbr x5, x0
 alternative_if ARM64_HAS_CNP
-	orr	x5, x5, #TTBR_CNP_BIT
+	orr	x5, x5, #TTBRx_EL1_CnP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x5
 
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 718c495832d0..0f4a28b87469 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -354,7 +354,7 @@ void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm)
 
 	/* Skip CNP for the reserved ASID */
 	if (system_supports_cnp() && asid)
-		ttbr0 |= TTBR_CNP_BIT;
+		ttbr0 |= TTBRx_EL1_CnP;
 
 	/* SW PAN needs a copy of the ASID in TTBR0 for entry */
 	if (IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN))
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a6a00accf4f9..c22678769c37 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2188,7 +2188,7 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 	phys_addr_t ttbr1 = phys_to_ttbr(virt_to_phys(pgdp));
 
 	if (cnp)
-		ttbr1 |= TTBR_CNP_BIT;
+		ttbr1 |= TTBRx_EL1_CnP;
 
 	replace_phys = (void *)__pa_symbol(idmap_cpu_replace_ttbr1);
 
-- 
2.30.2

