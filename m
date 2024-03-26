Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D88345C18
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711445662; cv=none; b=WlECDlt9ROgg86lNTysQUqb7QvKwdIDBkygpS4ZB3/GicPPMe9IdpCsk45KTZyXfpDnIVBRH5mWKgW5DgEy4pwHP4x7aJfWfKNphAfg54SG3YZnZdRyOnYZCp/QINVR5JprCUAr37ktWvTWjigeDfAaZ0oL5+s3NL66Ff+4gk5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711445662; c=relaxed/simple;
	bh=AZ7WhVjfVF9+3PXLZJemfpeJ0K4DmTvVso6Twrnixps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGPNyBQktMMMTiY3VniaOrNQFcjrpBBGbBFDRzvXr2v3b51TQnJ/81O6jyWxGkS6t7nPk0t+NvlT9+tZHKA3EBnbKJ1VqH8vMV4R/TulgghfbKvZe6gSpAReE8TE/rHa+rMs3zE7YMXqGgynmLw5gQngtWqssjLUrfRn0mfcCjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2aSG/SN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2aSG/SN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB4C433F1;
	Tue, 26 Mar 2024 09:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711445662;
	bh=AZ7WhVjfVF9+3PXLZJemfpeJ0K4DmTvVso6Twrnixps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P2aSG/SNF26qR8hi6z+BJidIN+uX4e0bgXQvmftxmQgYQ60S4N/CPMeggw2N4kNaU
	 cvdJuJflQrdv7QnAQ11I98AcZ878fT3PBwZhlbyebgbBpylLeIUUgLJn67wyscgtOf
	 7id6ta27MYJ4SW8PurdqMSFZj0TyuXXYSgj6OZ5YJgx/8pcxB4uvg0ZYBKGz7ivKeW
	 igJi4dtA3FnUJZZN9k2DRWJ6Qo7lSQm96NWS0oWx2JrNz2loVLnZe254n+k5WjnddS
	 6IeBA5jzhfPxW2M2FCEMCoXW5+R9+pBizGaEsF2X51nQYSEiQ9M4lBoSTJrduSAjUV
	 B+ehmrZLcBtog==
Date: Tue, 26 Mar 2024 09:34:16 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
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
Message-ID: <20240326093415.GA9216@willie-the-truck>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-3-will@kernel.org>
 <ZgKJV-smLaMnapV3@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgKJV-smLaMnapV3@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 26, 2024 at 01:37:43AM -0700, Oliver Upton wrote:
> On Mon, Mar 25, 2024 at 06:51:57PM +0000, Will Deacon wrote:
> > The TLBI level hints are for leaf entries only, so take care not to pass
> > them incorrectly after clearing a table entry.
> > 
> > Cc: Gavin Shan <gshan@redhat.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
> > Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index de0b667ba296..a40dafc43bb6 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -528,7 +528,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >  
> >  		kvm_clear_pte(ctx->ptep);
> >  		dsb(ishst);
> > -		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
> > +		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), TLBI_TTL_UNKNOWN);
> >  	} else {
> >  		if (ctx->end - ctx->addr < granule)
> >  			return -EINVAL;
> > @@ -896,10 +896,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >  	if (kvm_pte_valid(ctx->old)) {
> >  		kvm_clear_pte(ctx->ptep);
> >  
> > -		if (!stage2_unmap_defer_tlb_flush(pgt) ||
> > -		    kvm_pte_table(ctx->old, ctx->level)) {
> > -			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > -					ctx->addr, ctx->level);
> > +		if (kvm_pte_table(ctx->old, ctx->level)) {
> > +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
> > +				     TLBI_TTL_UNKNOWN);
> 
> Ah, here it is! Can you add this invalidation to patch #1? Otherwise the
> fix will intermediately introduce another bug, AFAICT.

Heh, well I'd argue that bug already exists in the case that TLB
invalidation isn't deferred, so that's why I kept them separate.

But happy to fold in if you prefer. Main thing is to get it fixed!

Will
