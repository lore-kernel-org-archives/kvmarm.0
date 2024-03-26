Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C2A5A0FA
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 13:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711458791; cv=none; b=JHDFn5skzARgGDcOcfuUsp7YDtQm1k1XWvRwORLFOefwBE0c0mQ51eCw7NnXeTLijgeZjAVW4wMC8Y1GxxphtOTuKO8Vw2VQeQNEvgglkAE0DAtIMiRHjjypT+5MKaqX8oa/LpePkY1W39XcQgs9BG3crJNSJMepzZBBzY8OK6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711458791; c=relaxed/simple;
	bh=1FVociGSdmAfDHBJLMbNpOFiMsH7a9HomD3Km+yURSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4kNY/W3iXa5piWYknQNvWLAuR9BXu+6NLCpllnGKzZCNtuaV3u1F5F8XARsOTeev1YEOgJocO3wE3ytJ2+j3VUcdKv1UKnpI+a9e1SXrvZmNdy7HY+ntq4VwAPQOag9+yTLoQ+SviK12wpmJXqh1XT7k1hF3BW1W5gpsyB5lvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JHKs+qgc; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JHKs+qgc"
Date: Tue, 26 Mar 2024 06:12:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711458786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5suALL5bYJBXW2Jp0/15k9lhoJmOs5VMMCmUrHyEkD4=;
	b=JHKs+qgcDn7cmoqUcn4GpkP3j/RnmWSuEVHBiWOz/USEz5snhkdm0GCqKoC7095L6z4qte
	XFGN9Bm6bN5F/XPgSIMd/JIlHpzofls2DMegQuxILpLRQDRbEZsRmgJ0kvISYJBVgTbFQq
	Bow5YKYslVo8chZ8S1U+RcpExoAagPQ=
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
Subject: Re: [PATCH 2/3] KVM: arm64: Don't pass a TLBI level hint when
 zapping table entries
Message-ID: <ZgLJ1_in2Vpm7LNZ@linux.dev>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-3-will@kernel.org>
 <ZgKJV-smLaMnapV3@linux.dev>
 <20240326093415.GA9216@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326093415.GA9216@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 09:34:16AM +0000, Will Deacon wrote:
> On Tue, Mar 26, 2024 at 01:37:43AM -0700, Oliver Upton wrote:
> > On Mon, Mar 25, 2024 at 06:51:57PM +0000, Will Deacon wrote:
> > > The TLBI level hints are for leaf entries only, so take care not to pass
> > > them incorrectly after clearing a table entry.
> > > 
> > > Cc: Gavin Shan <gshan@redhat.com>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Quentin Perret <qperret@google.com>
> > > Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
> > > Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index de0b667ba296..a40dafc43bb6 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -528,7 +528,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > >  
> > >  		kvm_clear_pte(ctx->ptep);
> > >  		dsb(ishst);
> > > -		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
> > > +		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), TLBI_TTL_UNKNOWN);
> > >  	} else {
> > >  		if (ctx->end - ctx->addr < granule)
> > >  			return -EINVAL;
> > > @@ -896,10 +896,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> > >  	if (kvm_pte_valid(ctx->old)) {
> > >  		kvm_clear_pte(ctx->ptep);
> > >  
> > > -		if (!stage2_unmap_defer_tlb_flush(pgt) ||
> > > -		    kvm_pte_table(ctx->old, ctx->level)) {
> > > -			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > > -					ctx->addr, ctx->level);
> > > +		if (kvm_pte_table(ctx->old, ctx->level)) {
> > > +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
> > > +				     TLBI_TTL_UNKNOWN);
> > 
> > Ah, here it is! Can you add this invalidation to patch #1? Otherwise the
> > fix will intermediately introduce another bug, AFAICT.
> 
> Heh, well I'd argue that bug already exists in the case that TLB
> invalidation isn't deferred, so that's why I kept them separate.

Ah, that's fine, when I was looking at this earlier I thought this
patch was getting blamed on LPA2, although patch #1 needs to go a bit
further back.

I'm fine with this as is, but maybe add a blurb to the changelog hinting
that the level hint is BS but will be fixed in a future change.

-- 
Thanks,
Oliver
