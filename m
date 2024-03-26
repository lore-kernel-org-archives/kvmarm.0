Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9223613AA32
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711463505; cv=none; b=jxMgoyf1VULMvv5f3Ojp3J415KW54jaw+cMVZLJ79u3+RzcpR+bmYh/bcltFH2pdc5doIJQcC3uH1km2sP07Vs8aLMp2KPzxIlkn0O+Cv6aLg0MjzBrMmbX39Fx8Q5vlSXzeu/DB+ZuO+izsPbQD2nAw/wSZ8xGieyFbpZzuzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711463505; c=relaxed/simple;
	bh=wMpAvqd+cet65/FXIl2rCWgM+Jg59V3xEmUnFA4i//M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+ZM+XCGsR8Um9jDdLPqj06P0mgaA+YTpXTd3MlCv//L6mjWsjeEiYGCEJlmDXdrDnEu8c0Ys+u2pA7shchPZnJnlhRBeeE8rUAfwVdqxEUeobg3jdianlmLxEAb42ayTt2tZKjeYUgH2C7QC6OuxxVhPyWBxX/3jk1SfjgERks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nHdp8Hhw; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nHdp8Hhw"
Date: Tue, 26 Mar 2024 07:31:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711463500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7iS7lQs00EYF2SDJRYWc2FNwHrQZRrb8S4189WW3Ng=;
	b=nHdp8HhwkY8EXBBwMVosXje3TaAumgW1CQ8Q6MYLL8VPd+TWTljKc+cnv/66RekIX8jG5T
	2QLiQ9Y0VXh29z+j0OCJ0Jpk3T6njuZP6b8NbaqUT/Sv2Biv2e3e9hmK3pBekdbPVjoBer
	oWeUu4rp0W7Ooa4vfg8atnsM1imA+gA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't defer TLB invalidation when
 zapping table entries
Message-ID: <ZgLcP9TfMwhfbnEK@linux.dev>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-2-will@kernel.org>
 <ZgKIides0YAA2j5Y@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgKIides0YAA2j5Y@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 01:34:17AM -0700, Oliver Upton wrote:
> >  	}
> >  
> >  	mm_ops->put_page(ctx->ptep);
> 
> At least for the 'normal' MMU where we use RCU, this could be changed to
> ->free_unlinked_table() which would defer the freeing of memory til
> after the invalidation completes. But that still hoses pKVM's stage-2
> MMU freeing in-place.

How about this (untested) diff? I _think_ it should address the
invalidation issue while leaving the performance optimization in place
for a 'normal' stage-2.

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3fae5830f8d2..896fdc0d157d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -872,14 +872,19 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
 {
 	/*
-	 * If FEAT_TLBIRANGE is implemented, defer the individual
-	 * TLB invalidations until the entire walk is finished, and
-	 * then use the range-based TLBI instructions to do the
-	 * invalidations. Condition deferred TLB invalidation on the
-	 * system supporting FWB as the optimization is entirely
-	 * pointless when the unmap walker needs to perform CMOs.
+	 * It is possible to use FEAT_TLBIRANGE to do TLB invalidations at the
+	 * end of the walk if certain conditions are met:
+	 *
+	 *  - The stage-2 is for a 'normal' VM (i.e. managed in the kernel
+	 *    context). RCU provides sufficient guarantees to ensure that all
+	 *    hardware and software references on the stage-2 page tables are
+	 *    relinquished before freeing a table page.
+	 *
+	 *  - The system supports FEAT_FWB. Otherwise, KVM needs to do CMOs
+	 *    during the page table table walk.
 	 */
-	return system_supports_tlb_range() && stage2_has_fwb(pgt);
+	return !is_hyp_code() && system_supports_tlb_range() &&
+		stage2_has_fwb(pgt);
 }
 
 static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
@@ -1163,7 +1168,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 					       kvm_granule_size(ctx->level));
 
 	if (childp)
-		mm_ops->put_page(childp);
+		mm_ops->free_unlinked_table(childp, ctx->level);
 
 	return 0;
 }
