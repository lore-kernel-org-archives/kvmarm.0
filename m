Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879B8C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:16:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437B24C411;
	Tue,  9 Aug 2022 05:16:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DD-jxOaLXogC; Tue,  9 Aug 2022 05:16:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63CDE4C99A;
	Tue,  9 Aug 2022 05:16:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 113214C49F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qZyOYdP1maGM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDDB4C460
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3AEF23A;
 Tue,  9 Aug 2022 02:15:54 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E372C3F67D;
 Tue,  9 Aug 2022 02:15:52 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 19/19] arm/arm64: Rework the cache
 maintenance in asm_mmu_disable
Date: Tue,  9 Aug 2022 10:15:58 +0100
Message-Id: <20220809091558.14379-20-alexandru.elisei@arm.com>
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

asm_mmu_disable is overly ambitious and provably incorrect:

1. It tries to clean and invalidate the data caches for the *entire*
memory, which is highly unnecessary, as it's very unlikely that a test
will write to the entire memory, and even more unlikely that a test will
modify the text section of the test image.

2. There is no corresponding dcache invalidate command for the entire
memory in asm_mmu_enable, leaving it up to the test that disabled the
MMU to do the cache maintenance in an asymmetrical fashion: only for
re-enabling the MMU, but not for disabling it.

3. It's missing the DMB SY memory barrier to ensure that the dcache
maintenance is performed after the last store executed in program order
before calling asm_mmu_disable.

Fix all of the issues in one go, by doing the cache maintenance only for
the stack, as that is out of the control of the C code, and add the missing
memory barrier.

The code used to test that mmu_disable works correctly is similar to the
code used to test commit 410b3bf09e76 ("arm/arm64: Perform dcache clean
+ invalidate after turning MMU off"), with extra cache maintenance
added:

+#include <alloc_page.h>
+#include <asm/cacheflush.h>
+#include <asm/mmu.h>
 int main(int argc, char **argv)
 {
+       int *x = alloc_page();
+       bool pass = true;
+       int i;
+
+       for  (i = 0; i < 1000000; i++) {
+               *x = 0x42;
+               dcache_clean_addr_poc((unsigned long)x);
+               mmu_disable();
+               if (*x != 0x42) {
+                       pass = false;
+                       break;
+               }
+               *x = 0x50;
+               /* Needed for the invalidation only. */
+               dcache_clean_inval_addr_poc((unsigned long)x);
+               mmu_enable(current_thread_info()->pgtable);
+               if (*x != 0x50) {
+                       pass = false;
+                       break;
+               }
+       }
+       report(pass, "MMU disable cache maintenance");

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S   | 11 ++++++-----
 arm/cstart64.S | 11 +++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index fc7c558802f1..b27de44f30a6 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -242,11 +242,12 @@ asm_mmu_disable:
 	mcr	p15, 0, r0, c1, c0, 0
 	isb
 
-	ldr	r0, =__phys_offset
-	ldr	r0, [r0]
-	ldr	r1, =__phys_end
-	ldr	r1, [r1]
-	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
+	dmb	sy
+	mov	r0, sp
+	lsr	r0, #THREAD_SHIFT
+	lsl	r0, #THREAD_SHIFT
+	add	r1, r0, #THREAD_SIZE
+	dcache_by_line_op dccmvac, sy, r0, r1, r3, r4
 
 	mov     pc, lr
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 1ce6b9e14d23..af4970775298 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -283,12 +283,11 @@ asm_mmu_disable:
 	msr	sctlr_el1, x0
 	isb
 
-	/* Clean + invalidate the entire memory */
-	adrp	x0, __phys_offset
-	ldr	x0, [x0, :lo12:__phys_offset]
-	adrp	x1, __phys_end
-	ldr	x1, [x1, :lo12:__phys_end]
-	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	dmb	sy
+	mov	x9, sp
+	and	x9, x9, #THREAD_MASK
+	add	x10, x9, #THREAD_SIZE
+	dcache_by_line_op cvac, sy, x9, x10, x11, x12
 
 	ret
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
