Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870B421F12
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772470692; cv=none; b=RYfCmaL9ZrVNgCUdrW7NKxfMU26c1qyH8DHxNCZFjLVgbxa8zKvYE5mKPvGgBzNADjCnPb218u7eq73uH3oLpHKKgSkKhTAvqcYbRCNx2f2SEXy9+iMNprpZBYxf2+5Dnp1dkUmczuKV0xvVtenC57jmTttvNrUDrvhY+M+cJAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772470692; c=relaxed/simple;
	bh=nmgSfDbuBbgWGY7RRKrz8/mbzP9qPHgkLBe1dOod06k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOChRoV5k8dk51tJsYE7XQ9i6QcVlNgSPn6ZkplUo7vgIRwaxeFsNwN92Tz74s8iUzVJfSOIH2s9NxSQdlpftVLk99gdajljhRi+tg787tZyBcx1EIaaLr2gOiFDUeijVfZnK5UGhONyr4EzeTCrbParQy9hiVeA+6w9EO3VErw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0297DC19423;
	Mon,  2 Mar 2026 16:58:09 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: [PATCH 2/4] arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()
Date: Mon,  2 Mar 2026 16:57:55 +0000
Message-ID: <20260302165801.3014607-3-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302165801.3014607-1-catalin.marinas@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mm structure will be used for workarounds that need limiting to
specific tasks.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 10 +++++-----
 arch/arm64/kernel/sys_compat.c    |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 19be0f7bfca5..14f116bfec73 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -185,7 +185,7 @@ do {										\
  * Complete broadcast TLB maintenance issued by the host which invalidates
  * stage 1 information in the host's own translation regime.
  */
-static inline void __tlbi_sync_s1ish(void)
+static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
@@ -317,7 +317,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	asid = __TLBI_VADDR(0, ASID(mm));
 	__tlbi(aside1is, asid);
 	__tlbi_user(aside1is, asid);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(mm);
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
 
@@ -371,7 +371,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
 				  unsigned long uaddr)
 {
 	flush_tlb_page_nosync(vma, uaddr);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(vma->vm_mm);
 }
 
 static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
@@ -391,7 +391,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
  */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(NULL);
 }
 
 /*
@@ -526,7 +526,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 {
 	__flush_tlb_range_nosync(vma->vm_mm, start, end, stride,
 				 last_level, tlb_level);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish(vma->vm_mm);
 }
 
 static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index b9d4998c97ef..03fde2677d5b 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -37,7 +37,7 @@ __do_compat_cache_op(unsigned long start, unsigned long end)
 			 * We pick the reserved-ASID to minimise the impact.
 			 */
 			__tlbi(aside1is, __TLBI_VADDR(0, 0));
-			__tlbi_sync_s1ish();
+			__tlbi_sync_s1ish(current->mm);
 		}
 
 		ret = caches_clean_inval_user_pou(start, start + chunk);
