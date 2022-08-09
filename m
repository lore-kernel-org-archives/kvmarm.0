Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2F9C25B06
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B064C497;
	Tue,  9 Aug 2022 05:15:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BP2xq2YLBwTd; Tue,  9 Aug 2022 05:15:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7424CBBA;
	Tue,  9 Aug 2022 05:15:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 929424C6A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1nprFxrm6faR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BC54CB00
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8F431477;
 Tue,  9 Aug 2022 02:15:44 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02C813F67D;
 Tue,  9 Aug 2022 02:15:42 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 12/19] arm/arm64: assembler.h: Replace size
 with end address for dcache_by_line_op
Date: Tue,  9 Aug 2022 10:15:51 +0100
Message-Id: <20220809091558.14379-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Commit b5f659be4775 ("arm/arm64: Remove dcache_line_size global
variable") moved the dcache_by_line_op macro to assembler.h and changed
it to take the size of the regions instead of the end address as
parameter. This was done to keep the file in sync with the upstream
Linux kernel implementation at the time.

But in both places where the macro is used, the code has the start and
end address of the region, and it has to compute the size to pass it to
dcache_by_line_op. Then the macro itsef computes the end by adding size
to start.

Get rid of this massaging of parameters and change the macro to the end
address as parameter directly.

Besides slightly simplyfing the code by remove two unneeded arithmetic
operations, this makes the macro compatible with the current upstream
version of Linux (which was similarly changed to take the end address in
commit 163d3f80695e ("arm64: dcache_by_line_op to take end parameter
instead of size")), which will allow us to reuse (part of) the Linux C
wrappers over the assembly macro.

The change has been tested with the same snippet of code used to test
commit 410b3bf09e76 ("arm/arm64: Perform dcache clean + invalidate after
turning MMU off").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S              |  1 -
 arm/cstart64.S            |  1 -
 lib/arm/asm/assembler.h   | 11 +++++------
 lib/arm64/asm/assembler.h | 11 +++++------
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 39e70f40986a..096a77c454f4 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -226,7 +226,6 @@ asm_mmu_disable:
 	ldr	r0, [r0]
 	ldr	r1, =__phys_end
 	ldr	r1, [r1]
-	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
 
 	mov     pc, lr
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 54773676d1d5..7cc90a9fa13f 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -258,7 +258,6 @@ asm_mmu_disable:
 	ldr	x0, [x0, :lo12:__phys_offset]
 	adrp	x1, __phys_end
 	ldr	x1, [x1, :lo12:__phys_end]
-	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 
 	ret
diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
index 4200252dd14d..db5f0f55027c 100644
--- a/lib/arm/asm/assembler.h
+++ b/lib/arm/asm/assembler.h
@@ -25,17 +25,16 @@
 
 /*
  * Macro to perform a data cache maintenance for the interval
- * [addr, addr + size).
+ * [addr, end).
  *
  * 	op:		operation to execute
  * 	domain		domain used in the dsb instruction
  * 	addr:		starting virtual address of the region
- * 	size:		size of the region
- * 	Corrupts:	addr, size, tmp1, tmp2
+ * 	end:		the end of the region (non-inclusive)
+ * 	Corrupts:	addr, tmp1, tmp2
  */
-	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	.macro dcache_by_line_op op, domain, addr, end, tmp1, tmp2
 	dcache_line_size \tmp1, \tmp2
-	add	\size, \addr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\addr, \addr, \tmp2
 9998:
@@ -45,7 +44,7 @@
 	.err
 	.endif
 	add	\addr, \addr, \tmp1
-	cmp	\addr, \size
+	cmp	\addr, \end
 	blo	9998b
 	dsb	\domain
 	.endm
diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
index aa8c65a2bb4a..1e09d65af4a7 100644
--- a/lib/arm64/asm/assembler.h
+++ b/lib/arm64/asm/assembler.h
@@ -28,25 +28,24 @@
 
 /*
  * Macro to perform a data cache maintenance for the interval
- * [addr, addr + size). Use the raw value for the dcache line size because
+ * [addr, end). Use the raw value for the dcache line size because
  * kvm-unit-tests has no concept of scheduling.
  *
  * 	op:		operation passed to dc instruction
  * 	domain:		domain used in dsb instruction
  * 	addr:		starting virtual address of the region
- * 	size:		size of the region
- * 	Corrupts:	addr, size, tmp1, tmp2
+ * 	end:		the end of the region (non-inclusive)
+ * 	Corrupts:	addr, tmp1, tmp2
  */
 
-	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	.macro dcache_by_line_op op, domain, addr, end, tmp1, tmp2
 	raw_dcache_line_size \tmp1, \tmp2
-	add	\size, \addr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\addr, \addr, \tmp2
 9998:
 	dc	\op, \addr
 	add	\addr, \addr, \tmp1
-	cmp	\addr, \size
+	cmp	\addr, \end
 	b.lo	9998b
 	dsb	\domain
 	.endm
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
