Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659FEC1975A
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:52:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32D3220736
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32D3220736
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=remlab.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D846D4A4A3;
	Thu, 12 Mar 2020 05:52:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w4oh8KyP9cAu; Thu, 12 Mar 2020 05:52:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9394A5A6;
	Thu, 12 Mar 2020 05:52:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEFF24A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gu-oWnJ-4y03 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 05:40:15 -0400 (EDT)
Received: from ns207790.ip-94-23-215.eu (poy.remlab.net [94.23.215.26])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9614A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:40:15 -0400 (EDT)
Received: from basile.remlab.net (ip6-localhost [IPv6:::1])
 by ns207790.ip-94-23-215.eu (Postfix) with ESMTP id C0BB35FE21;
 Thu, 12 Mar 2020 10:40:14 +0100 (CET)
From: =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm64: use mov_q instead of literal ldr
Date: Thu, 12 Mar 2020 11:40:14 +0200
Message-Id: <20200312094014.153356-1-remi@remlab.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 12 Mar 2020 05:52:50 -0400
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Remi Denis-Courmont <remi.denis.courmont@huawei.com>

In practice, this requires only 2 instructions, or even only 1 for
the idmap_pg_dir size (with 4 or 64 KiB pages). Only the MAIR values
needed more than 2 instructions and it was already converted to mov_q
by 95b3f74bec203804658e17f86fe20755bb8abcb9.

Signed-off-by: Remi Denis-Courmont <remi.denis.courmont@huawei.com>
---
 arch/arm64/kernel/cpu-reset.S       |  2 +-
 arch/arm64/kernel/hyp-stub.S        |  2 +-
 arch/arm64/kernel/relocate_kernel.S |  4 +---
 arch/arm64/kvm/hyp-init.S           | 10 ++++------
 arch/arm64/mm/proc.S                |  2 +-
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
index 32c7bf858dd9..38087b4c0432 100644
--- a/arch/arm64/kernel/cpu-reset.S
+++ b/arch/arm64/kernel/cpu-reset.S
@@ -32,7 +32,7 @@
 ENTRY(__cpu_soft_restart)
 	/* Clear sctlr_el1 flags. */
 	mrs	x12, sctlr_el1
-	ldr	x13, =SCTLR_ELx_FLAGS
+	mov_q	x13, SCTLR_ELx_FLAGS
 	bic	x12, x12, x13
 	pre_disable_mmu_workaround
 	msr	sctlr_el1, x12
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 73d46070b315..e473ead806ed 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -63,7 +63,7 @@ el1_sync:
 	beq	9f				// Nothing to reset!
 
 	/* Someone called kvm_call_hyp() against the hyp-stub... */
-	ldr	x0, =HVC_STUB_ERR
+	mov_q	x0, HVC_STUB_ERR
 	eret
 
 9:	mov	x0, xzr
diff --git a/arch/arm64/kernel/relocate_kernel.S b/arch/arm64/kernel/relocate_kernel.S
index c1d7db71a726..c40ce496c78b 100644
--- a/arch/arm64/kernel/relocate_kernel.S
+++ b/arch/arm64/kernel/relocate_kernel.S
@@ -41,7 +41,7 @@ ENTRY(arm64_relocate_new_kernel)
 	cmp	x0, #CurrentEL_EL2
 	b.ne	1f
 	mrs	x0, sctlr_el2
-	ldr	x1, =SCTLR_ELx_FLAGS
+	mov_q	x1, SCTLR_ELx_FLAGS
 	bic	x0, x0, x1
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x0
@@ -113,8 +113,6 @@ ENTRY(arm64_relocate_new_kernel)
 
 ENDPROC(arm64_relocate_new_kernel)
 
-.ltorg
-
 .align 3	/* To keep the 64-bit values below naturally aligned. */
 
 .Lcopy_end:
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 84f32cf5abc7..6e6ed5581eed 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -60,7 +60,7 @@ alternative_else_nop_endif
 	msr	ttbr0_el2, x4
 
 	mrs	x4, tcr_el1
-	ldr	x5, =TCR_EL2_MASK
+	mov_q	x5, TCR_EL2_MASK
 	and	x4, x4, x5
 	mov	x5, #TCR_EL2_RES1
 	orr	x4, x4, x5
@@ -102,7 +102,7 @@ alternative_else_nop_endif
 	 * as well as the EE bit on BE. Drop the A flag since the compiler
 	 * is allowed to generate unaligned accesses.
 	 */
-	ldr	x4, =(SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
+	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
 CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	msr	sctlr_el2, x4
 	isb
@@ -142,7 +142,7 @@ reset:
 	 * case we coming via HVC_SOFT_RESTART.
 	 */
 	mrs	x5, sctlr_el2
-	ldr	x6, =SCTLR_ELx_FLAGS
+	mov_q	x6, SCTLR_ELx_FLAGS
 	bic	x5, x5, x6		// Clear SCTL_M and etc
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x5
@@ -155,11 +155,9 @@ reset:
 	eret
 
 1:	/* Bad stub call */
-	ldr	x0, =HVC_STUB_ERR
+	mov_q	x0, HVC_STUB_ERR
 	eret
 
 SYM_CODE_END(__kvm_handle_stub_hvc)
 
-	.ltorg
-
 	.popsection
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 1b871f141eb4..6bd228067ebc 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -411,7 +411,7 @@ SYM_FUNC_START(__cpu_setup)
 	 * Set/prepare TCR and TTBR. We use 512GB (39-bit) address range for
 	 * both user and kernel.
 	 */
-	ldr	x10, =TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
+	mov_q	x10, TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_ASID16 | \
 			TCR_TBI0 | TCR_A1 | TCR_KASAN_FLAGS
 	tcr_clear_errata_bits x10, x9, x5
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
