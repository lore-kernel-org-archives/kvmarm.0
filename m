Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F3A1361
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 18:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754679403; cv=none; b=u3WyMyyEiGIfDoKnseWBSbOPbdolR1BSIkxEIL1LLzzpJ/TiA8eAaiub5cV0a6LehEiiy847KmF9LOU9kcYBGr2ezsvikkft8myaRN5lYGGt96fanUwHe4vVybXzbIKMRuNawwwLy9yiJd7pLlgqaH7An0y96rZiFGqjdRRk+SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754679403; c=relaxed/simple;
	bh=d7RKzM3PHZ4V28N9/tZDIrTV+QQRyM6Rsb+C60eYCOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qsx6URL2fxt88TnTnjrXZyRTZLaUt/V/kA94xCKAdichvhASR0QieJvkHtU1G+qn5+/WCiXxbtWKoXgb/qoP9OjI0AXh6177WW+fGhiJ9WbStm7hHwN4OtNXzko5ChSUV4y14K8dGJ+uk87emFm+QgiZyOKfAIstedLv6dg01OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gAw17mz4; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gAw17mz4"
Date: Fri, 8 Aug 2025 11:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754679398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQEweAiTXl7uCYmBR+Y/7n2oQdebFZHZYTNv96/JjXY=;
	b=gAw17mz4oym/aoBhLbPmslP80ZAYkNfurE+ctVswd2okrrijXyrbToCAVNrAAe8fdhfyzj
	imtF5PVuDWTUpkJCeACSS2BvlIGjH1LG9ampjXkJMrYpTanhieeCrPPoxznQXRLHVuKFIq
	mtuUzh5uO+R121iAWR5z4IHVfd1reB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table
 periodically
Message-ID: <aJZIXGDWxD1U0axK@linux.dev>
References: <20250724235144.2428795-1-rananta@google.com>
 <20250724235144.2428795-3-rananta@google.com>
 <aIjwalITY6CAj7TO@linux.dev>
 <CAJHc60wBNTP9SSt_skEXXv9N+tF_1RoV6vcQQx4hWphJF6EmkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60wBNTP9SSt_skEXXv9N+tF_1RoV6vcQQx4hWphJF6EmkQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 07, 2025 at 11:58:01AM -0700, Raghavendra Rao Ananta wrote:
> Hi Oliver,
> 
> >
> > Protected mode is affected by the same problem, potentially even worse
> > due to the overheads of calling into EL2. Both protected and
> > non-protected flows should use stage2_destroy_range().
> >
> I experimented with this (see diff below), and it looks like it takes
> significantly longer to finish the destruction even for a very small
> VM. For instance, it takes ~140 seconds on an Ampere Altra machine.
> This is probably because we run cond_resched() for every breakup in
> the entire sweep of the possible address range, 0 to  ~(0ULL), even
> though there are no actual mappings there, and we context switch out
> more often.

This seems more like an issue with the upper bound on a pKVM walk rather
than a problem with the suggestion. The information in pgt->ia_bits is
actually derived from the VTCR value of the owning MMU.

Even though we never use the VTCR value in hardware, pKVM MMUs have a
valid VTCR value that encodes the size of the IPA space and we use that
in the common stage-2 abort path.

I'm attaching some fixups that I have on top of your series that'd allow
the resched logic to remain common, like it is in other MMU flows.

From 421468dcaa4692208c3f708682b058cfc072a984 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oliver.upton@linux.dev>
Date: Fri, 8 Aug 2025 11:43:12 -0700
Subject: [PATCH 4/4] fixup! KVM: arm64: Destroy the stage-2 page-table
 periodically

---
 arch/arm64/kvm/mmu.c | 60 ++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b82412323054..fc93cc256bd8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -383,40 +383,6 @@ static void stage2_flush_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-/*
- * Assume that @pgt is valid and unlinked from the KVM MMU to free the
- * page-table without taking the kvm_mmu_lock and without performing any
- * TLB invalidations.
- *
- * Also, the range of addresses can be large enough to cause need_resched
- * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
- * cond_resched() periodically to prevent hogging the CPU for a long time
- * and schedule something else, if required.
- */
-static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
-			      phys_addr_t end)
-{
-	u64 next;
-
-	do {
-		next = stage2_range_addr_end(addr, end);
-		kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
-
-		if (next != end)
-			cond_resched();
-	} while (addr = next, addr != end);
-}
-
-static void kvm_destroy_stage2_pgt(struct kvm_pgtable *pgt)
-{
-	if (!is_protected_kvm_enabled()) {
-		stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
-		kvm_pgtable_stage2_destroy_pgd(pgt);
-	} else {
-		pkvm_pgtable_stage2_destroy(pgt);
-	}
-}
-
 /**
  * free_hyp_pgds - free Hyp-mode page tables
  */
@@ -938,11 +904,35 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	return 0;
 }
 
+/*
+ * Assume that @pgt is valid and unlinked from the KVM MMU to free the
+ * page-table without taking the kvm_mmu_lock and without performing any
+ * TLB invalidations.
+ *
+ * Also, the range of addresses can be large enough to cause need_resched
+ * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
+ * cond_resched() periodically to prevent hogging the CPU for a long time
+ * and schedule something else, if required.
+ */
+static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
+				 phys_addr_t end)
+{
+	u64 next;
+
+	do {
+		next = stage2_range_addr_end(addr, end);
+		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr, next - addr);
+
+		if (next != end)
+			cond_resched();
+	} while (addr = next, addr != end);
+}
+
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
 
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, 0, BIT(ia_bits));
+	stage2_destroy_range(pgt, 0, BIT(ia_bits));
 	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
 }
 
-- 
2.39.5
