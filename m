Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E36C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12F84B2BA;
	Sat,  7 May 2022 05:14:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3em7cqvHjXHP; Sat,  7 May 2022 05:14:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E894B2C0;
	Sat,  7 May 2022 05:14:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0818C4B186
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kf4NViVf502 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 10:09:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D584B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 373A31595;
 Fri,  6 May 2022 07:09:16 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com
 [10.7.66.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47BAC3F885;
 Fri,  6 May 2022 07:09:15 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 12/23] arm/arm64: mmu_disable: Clean and
 invalidate before disabling
Date: Fri,  6 May 2022 15:08:44 +0100
Message-Id: <20220506140855.353337-13-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
X-Mailman-Approved-At: Sat, 07 May 2022 05:14:38 -0400
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, jade.alglave@arm.com
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

From: Andrew Jones <drjones@redhat.com>

The commit message of commit 410b3bf09e76 ("arm/arm64: Perform dcache
clean + invalidate after turning MMU off") justifies cleaning and
invalidating the dcache after disabling the MMU by saying it's nice
not to rely on the current page tables and that it should still work
(per the spec), as long as there's an identity map in the current
tables. Doing the invalidation after also somewhat helped with
reenabling the MMU without seeing stale data, but the real problem
with reenabling was because the cache needs to be disabled with
the MMU, but it wasn't.

Since we have to trust/validate that the current page tables have an
identity map anyway, then there's no harm in doing the clean
and invalidate first (it feels a little better to do so, anyway,
considering the cache maintenance instructions take virtual
addresses). Then, also disable the cache with the MMU to avoid
problems when reenabling. We invalidate the Icache and disable
that too for good measure. And, a final TLB invalidation ensures
we're crystal clean when we return from asm_mmu_disable().

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart.S   | 28 +++++++++++++++++++++-------
 arm/cstart64.S | 21 ++++++++++++++++-----
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 7036e67..dc324c5 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -179,6 +179,7 @@ halt:
 .globl asm_mmu_enable
 asm_mmu_enable:
 	/* TLBIALL */
+	mov	r2, #0
 	mcr	p15, 0, r2, c8, c7, 0
 	dsb	nsh
 
@@ -211,12 +212,7 @@ asm_mmu_enable:
 
 .globl asm_mmu_disable
 asm_mmu_disable:
-	/* SCTLR */
-	mrc	p15, 0, r0, c1, c0, 0
-	bic	r0, #CR_M
-	mcr	p15, 0, r0, c1, c0, 0
-	isb
-
+	/* Clean + invalidate the entire memory */
 	ldr	r0, =__phys_offset
 	ldr	r0, [r0]
 	ldr	r1, =__phys_end
@@ -224,7 +220,25 @@ asm_mmu_disable:
 	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
 
-	mov     pc, lr
+	/* Invalidate Icache */
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c5, 0
+	isb
+
+	/*  Disable cache, Icache and MMU */
+	mrc	p15, 0, r0, c1, c0, 0
+	bic	r0, #CR_C
+	bic	r0, #CR_I
+	bic	r0, #CR_M
+	mcr	p15, 0, r0, c1, c0, 0
+	isb
+
+	/* Invalidate TLB */
+	mov	r0, #0
+	mcr	p15, 0, r0, c8, c7, 0
+	dsb	nsh
+
+	mov	pc, lr
 
 /*
  * Vectors
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d0..390feb9 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -246,11 +246,6 @@ asm_mmu_enable:
 
 .globl asm_mmu_disable
 asm_mmu_disable:
-	mrs	x0, sctlr_el1
-	bic	x0, x0, SCTLR_EL1_M
-	msr	sctlr_el1, x0
-	isb
-
 	/* Clean + invalidate the entire memory */
 	adrp	x0, __phys_offset
 	ldr	x0, [x0, :lo12:__phys_offset]
@@ -259,6 +254,22 @@ asm_mmu_disable:
 	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 
+	/* Invalidate Icache */
+	ic	iallu
+	isb
+
+	/* Disable cache, Icache and MMU */
+	mrs	x0, sctlr_el1
+	bic	x0, x0, SCTLR_EL1_C
+	bic	x0, x0, SCTLR_EL1_I
+	bic	x0, x0, SCTLR_EL1_M
+	msr	sctlr_el1, x0
+	isb
+
+	/* Invalidate TLB */
+	tlbi	vmalle1
+	dsb	nsh
+
 	ret
 
 /*
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
