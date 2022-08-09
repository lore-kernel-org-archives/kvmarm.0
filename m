Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A90C25B06
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:16:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C88E04C4EE;
	Tue,  9 Aug 2022 05:16:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lGa5w1mZxN9M; Tue,  9 Aug 2022 05:16:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 329394CC40;
	Tue,  9 Aug 2022 05:15:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEF084C974
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J+ZF7AsAShXC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F281A4C994
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72131143D;
 Tue,  9 Aug 2022 02:15:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 925CF3F67D;
 Tue,  9 Aug 2022 02:15:48 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 16/19] arm/arm64: Allocate secondaries'
 stack using the page allocator
Date: Tue,  9 Aug 2022 10:15:55 +0100
Message-Id: <20220809091558.14379-17-alexandru.elisei@arm.com>
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

The vmalloc allocator returns non-id mapped addresses, where the virtual
address is different than the physical address. This makes it impossible
to access the stack of the secondary CPUs while the MMU is disabled.

On arm, THREAD_SIZE is 16K and PAGE_SIZE is 4K, which makes THREAD_SIZE
a power of two multiple of PAGE_SIZE. On arm64, THREAD_SIZE is 16 when
PAGE_SIZE is 4K or 16K, and 64K when PAGE_SIZE is 64K. In all cases,
THREAD_SIZE is a power of two multiple of PAGE_SIZE. As a result, using
memalign_pages() for the stack won't lead to wasted memory.

memalign_pages() allocates memory in chunks of power of two number of
pages, aligned to the allocation size, which makes it a drop-in
replacement for vm_memalign (which is the value for alloc_ops->memalign
when the stack is allocated).

Using memalign_pages() has two distinct benefits:

1. The secondary CPUs' stack can be used with the MMU off.

2. The secondary CPUs' stack is identify mapped similar to the stack for
the primary CPU, which makes the configuration of the CPUs consistent.

memalign_pages_flags() has been used instead of memalign_pages() to
instruct the allocator not to zero the stack, as it's already zeroed in the
entry code.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/thread_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
index eaa72582af86..190e082cbba0 100644
--- a/lib/arm/asm/thread_info.h
+++ b/lib/arm/asm/thread_info.h
@@ -25,6 +25,7 @@
 #ifndef __ASSEMBLY__
 #include <asm/processor.h>
 #include <alloc.h>
+#include <alloc_page.h>
 
 #ifdef __arm__
 #include <asm/ptrace.h>
@@ -40,7 +41,7 @@
 
 static inline void *thread_stack_alloc(void)
 {
-	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
+	void *sp = memalign_pages_flags(THREAD_ALIGNMENT, THREAD_SIZE, FLAG_DONTZERO);
 	return sp + THREAD_START_SP;
 }
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
