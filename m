Received: from out-225.mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56605C8E3
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 08:01:51 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695196909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xfbh8qQL9QW5BcJKxEDXewQuyfv4M5lak2q1jy6348Q=;
	b=kJfWlYzUpeP9zIU/DMOihsHo4wNb5lISvzWIPxEGTfLtXeW7QzzHIIFQUt9VdXyBJ1qfNl
	XiaSonGNvCmM14etc2Y/yw2NIdjgpfkvUQetSAj2KPbk3CxgvpQSN8SiJ0Wq53/yyOAWAy
	WmgKUWt8goAWcxpo1wvmmhksbPK/EN8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] arm64: tlbflush: Rename MAX_TLBI_OPS
Date: Wed, 20 Sep 2023 08:01:32 +0000
Message-ID: <20230920080133.944717-2-oliver.upton@linux.dev>
In-Reply-To: <20230920080133.944717-1-oliver.upton@linux.dev>
References: <20230920080133.944717-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Perhaps unsurprisingly, I-cache invalidations suffer from performance
issues similar to TLB invalidations on certain systems. TLB and I-cache
maintenance all result in DVM on the mesh, which is where the real
bottleneck lies.

Rename the heuristic to point the finger at DVM, such that it may be
reused for limiting I-cache invalidations.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/tlbflush.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b149cf9f91bc..3431d37e5054 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -333,7 +333,7 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  * This is meant to avoid soft lock-ups on large TLB flushing ranges and not
  * necessarily a performance improvement.
  */
-#define MAX_TLBI_OPS	PTRS_PER_PTE
+#define MAX_DVM_OPS	PTRS_PER_PTE
 
 /*
  * __flush_tlb_range_op - Perform TLBI operation upon a range
@@ -413,12 +413,12 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 
 	/*
 	 * When not uses TLB range ops, we can handle up to
-	 * (MAX_TLBI_OPS - 1) pages;
+	 * (MAX_DVM_OPS - 1) pages;
 	 * When uses TLB range ops, we can handle up to
 	 * (MAX_TLBI_RANGE_PAGES - 1) pages.
 	 */
 	if ((!system_supports_tlb_range() &&
-	     (end - start) >= (MAX_TLBI_OPS * stride)) ||
+	     (end - start) >= (MAX_DVM_OPS * stride)) ||
 	    pages >= MAX_TLBI_RANGE_PAGES) {
 		flush_tlb_mm(vma->vm_mm);
 		return;
@@ -451,7 +451,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 {
 	unsigned long addr;
 
-	if ((end - start) > (MAX_TLBI_OPS * PAGE_SIZE)) {
+	if ((end - start) > (MAX_DVM_OPS * PAGE_SIZE)) {
 		flush_tlb_all();
 		return;
 	}
-- 
2.42.0.459.ge4e396fd5e-goog

