Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560F2C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1301B4C918;
	Tue,  9 Aug 2022 05:15:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tl0bqC2FR0JC; Tue,  9 Aug 2022 05:15:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CD644CB6D;
	Tue,  9 Aug 2022 05:15:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AA874C982
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4AYawX18GB10 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 221154C491
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 861FF15BF;
 Tue,  9 Aug 2022 02:15:40 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5E803F67D;
 Tue,  9 Aug 2022 02:15:38 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 09/19] arm/arm64: Zero secondary CPUs' stack
Date: Tue,  9 Aug 2022 10:15:48 +0100
Message-Id: <20220809091558.14379-10-alexandru.elisei@arm.com>
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

For the boot CPU, the entire stack is zeroed in the entry code. For the
secondaries, only struct thread_info, which lives at the bottom of the
stack, is zeroed in thread_info_init().

Be consistent and zero the entire stack for the secondaries. This should
also improve reproducibility of the testsuite, as all the stacks now start
with the same contents, which is zero. And now that all the stacks are
zeroed in the entry code, there is no need to explicitely zero struct
thread_info in thread_info_init().

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S          | 6 ++++++
 arm/cstart64.S        | 3 +++
 lib/arm/processor.c   | 1 -
 lib/arm64/processor.c | 1 -
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 39260e0fa470..39e70f40986a 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -151,7 +151,13 @@ secondary_entry:
 	 */
 	ldr	r1, =secondary_data
 	ldr	r0, [r1]
+	mov	r2, r0
+	lsr	r2, #THREAD_SHIFT
+	lsl	r2, #THREAD_SHIFT
+	add	r3, r2, #THREAD_SIZE
+	zero_range r2, r3, r4, r5
 	mov	sp, r0
+
 	bl	exceptions_init
 	bl	enable_vfp
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index d62360cf3859..54773676d1d5 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -156,6 +156,9 @@ secondary_entry:
 	/* set the stack */
 	adrp	x0, secondary_data
 	ldr	x0, [x0, :lo12:secondary_data]
+	and	x1, x0, #THREAD_MASK
+	add	x2, x1, #THREAD_SIZE
+	zero_range x1, x2
 	mov	sp, x0
 
 	/* finish init in C code */
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 9d5759686b73..ceff1c0a1bd2 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -117,7 +117,6 @@ void do_handle_exception(enum vector v, struct pt_regs *regs)
 
 void thread_info_init(struct thread_info *ti, unsigned int flags)
 {
-	memset(ti, 0, sizeof(struct thread_info));
 	ti->cpu = mpidr_to_cpu(get_mpidr());
 	ti->flags = flags;
 }
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 831207c16587..268b2858f0be 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -232,7 +232,6 @@ void install_vector_handler(enum vector v, vector_fn fn)
 
 static void __thread_info_init(struct thread_info *ti, unsigned int flags)
 {
-	memset(ti, 0, sizeof(struct thread_info));
 	ti->cpu = mpidr_to_cpu(get_mpidr());
 	ti->flags = flags;
 }
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
