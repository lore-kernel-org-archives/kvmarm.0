Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7F236B1D
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i6D0O3Rv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oJ2WRGg6a4FrOXCy7k3lvqpweTX6omo+sELBwPPyOE=;
	b=i6D0O3Rvg7Hd4xpsGoBhS1L3eC6SiEPGxgxSxxeHMULe/FhEK9M7Fdyfq76cILwW6qI11g
	PrAbEepHdshiVY3QHI0Zy90iUo5eR5s2CDTXYqfqlqJ4blxdh8V42CRIHH+qtM/cBmg66f
	31npB4PsKRVDMQqNIedA+kDGcRL8gvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-EchLaSp1NiKqTgIJ2oC2VQ-1; Thu, 30 Nov 2023 04:07:58 -0500
X-MC-Unique: EchLaSp1NiKqTgIJ2oC2VQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CA8B811E86;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 801191C060AE;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 18/18] arm/arm64: Rework the cache maintenance in asm_mmu_disable
Date: Thu, 30 Nov 2023 04:07:20 -0500
Message-Id: <20231130090722.2897974-19-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

asm_mmu_disable is overly ambitious and provably incorrect:

1. It tries to clean and invalidate the data caches for the **entire**
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
memory barrier. A test that disables the MMU is now expected to do whatever
cache maintenance is necessary to execute correctly after the MMU is
disabled.

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
+                       mmu_enable(current_thread_info()->pgtable);
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
 arm/cstart.S   | 19 +++++++++++++------
 arm/cstart64.S | 19 ++++++++++++-------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 48dc87f5..3950e45e 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -240,18 +240,25 @@ asm_mmu_enable:
 
 .globl asm_mmu_disable
 asm_mmu_disable:
+	/*
+	 * A test can change the memory attributes for a memory location to
+	 * Device or Inner Non-cacheable, which makes the barrier required to
+	 * avoid reordering of previous memory accesses with respect to the
+	 * cache maintenance.
+	 */
+	dmb	sy
+	mov	r0, sp
+	lsr	r0, #THREAD_SHIFT
+	lsl	r0, #THREAD_SHIFT
+	add	r1, r0, #THREAD_SIZE
+	dcache_by_line_op dccmvac, sy, r0, r1, r2, r3
+
 	/* SCTLR */
 	mrc	p15, 0, r0, c1, c0, 0
 	bic	r0, #CR_M
 	mcr	p15, 0, r0, c1, c0, 0
 	isb
 
-	ldr	r0, =__phys_offset
-	ldr	r0, [r0]
-	ldr	r1, =__phys_end
-	ldr	r1, [r1]
-	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
-
 	mov     pc, lr
 
 /*
diff --git a/arm/cstart64.S b/arm/cstart64.S
index d8200ea2..af56186c 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -288,18 +288,23 @@ asm_mmu_enable:
 
 .globl asm_mmu_disable
 asm_mmu_disable:
+	/*
+	 * A test can change the memory attributes for a memory location to
+	 * Device or Inner Non-cacheable, which makes the barrier required to
+	 * avoid reordering of previous memory accesses with respect to the
+	 * cache maintenance.
+	 */
+	dmb	sy
+	mov	x9, sp
+	and	x9, x9, #THREAD_MASK
+	add	x10, x9, #THREAD_SIZE
+	dcache_by_line_op cvac, sy, x9, x10, x11, x12
+
 	mrs	x0, sctlr_el1
 	bic	x0, x0, SCTLR_EL1_M
 	msr	sctlr_el1, x0
 	isb
 
-	/* Clean + invalidate the entire memory */
-	adrp	x0, __phys_offset
-	ldr	x0, [x0, :lo12:__phys_offset]
-	adrp	x1, __phys_end
-	ldr	x1, [x1, :lo12:__phys_end]
-	dcache_by_line_op civac, sy, x0, x1, x2, x3
-
 	ret
 
 /*
-- 
2.40.1

