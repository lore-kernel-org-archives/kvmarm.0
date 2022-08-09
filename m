Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578E1C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:16:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14D3D4C497;
	Tue,  9 Aug 2022 05:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xc4+-qyF8hfV; Tue,  9 Aug 2022 05:16:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AFE14CBE7;
	Tue,  9 Aug 2022 05:15:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABF864C99A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id twVTDxs9gMJK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B264C4B4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D392623A;
 Tue,  9 Aug 2022 02:15:51 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F232E3F67D;
 Tue,  9 Aug 2022 02:15:49 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 17/19] arm/arm64: Configure secondaries'
 stack before enabling the MMU
Date: Tue,  9 Aug 2022 10:15:56 +0100
Message-Id: <20220809091558.14379-18-alexandru.elisei@arm.com>
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

Now that the secondaries' stack is linearly mapped, we can set it before
turning the MMU on. This makes the entry code for the secondaries
consistent with the entry code for the boot CPU.

To keep it simple, the struct secondary_data, which is now read with the
MMU off by the secondaries, is cleaned to PoC.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S   | 20 ++++++++++----------
 arm/cstart64.S | 16 ++++++++--------
 lib/arm/smp.c  |  5 +++++
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 096a77c454f4..877559b367de 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -134,16 +134,6 @@ get_mmu_off:
 
 .global secondary_entry
 secondary_entry:
-	/* enable the MMU unless requested off */
-	bl	get_mmu_off
-	cmp	r0, #0
-	bne	1f
-	mov	r1, #0
-	ldr	r0, =mmu_idmap
-	ldr	r0, [r0]
-	bl	asm_mmu_enable
-
-1:
 	/*
 	 * Set the stack, and set up vector table
 	 * and exception stacks. Exception stacks
@@ -161,6 +151,16 @@ secondary_entry:
 	bl	exceptions_init
 	bl	enable_vfp
 
+	/* enable the MMU unless requested off */
+	bl	get_mmu_off
+	cmp	r0, #0
+	bne	1f
+	mov	r1, #0
+	ldr	r0, =mmu_idmap
+	ldr	r0, [r0]
+	bl	asm_mmu_enable
+
+1:
 	/* finish init in C code */
 	bl	secondary_cinit
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 7cc90a9fa13f..face185a7781 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -138,6 +138,14 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	/* set the stack */
+	adrp	x0, secondary_data
+	ldr	x0, [x0, :lo12:secondary_data]
+	and	x1, x0, #THREAD_MASK
+	add	x2, x1, #THREAD_SIZE
+	zero_range x1, x2
+	mov	sp, x0
+
 	/* Enable FP/ASIMD */
 	mov	x0, #(3 << 20)
 	msr	cpacr_el1, x0
@@ -153,14 +161,6 @@ secondary_entry:
 	bl	asm_mmu_enable
 
 1:
-	/* set the stack */
-	adrp	x0, secondary_data
-	ldr	x0, [x0, :lo12:secondary_data]
-	and	x1, x0, #THREAD_MASK
-	add	x2, x1, #THREAD_SIZE
-	zero_range x1, x2
-	mov	sp, x0
-
 	/* finish init in C code */
 	bl	secondary_cinit
 
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 89e44a172c15..9c49bc3dec61 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -7,6 +7,8 @@
  */
 #include <libcflat.h>
 #include <auxinfo.h>
+
+#include <asm/cacheflush.h>
 #include <asm/thread_info.h>
 #include <asm/spinlock.h>
 #include <asm/cpumask.h>
@@ -62,6 +64,9 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
 
 	secondary_data.stack = thread_stack_alloc();
 	secondary_data.entry = entry;
+	dcache_clean_poc((unsigned long)&secondary_data,
+			 (unsigned long)&secondary_data + sizeof(secondary_data));
+
 	mmu_mark_disabled(cpu);
 	ret = cpu_psci_cpu_boot(cpu);
 	assert(ret == 0);
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
