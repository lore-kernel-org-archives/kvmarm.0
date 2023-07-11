Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56131E508
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 18:04:33 +0000 (UTC)
Date: Tue, 11 Jul 2023 11:04:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689098671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CCTVD9YswXR/J3CAXMSX6YUf1qY7Da7neiX5xY2+9ZI=;
	b=xqOFfRQ8zcZePJRpzJXUvOaGMByb4Nl4u+m0/KmqKDars1WLsLKhEPhur/cooVt7tGE5bB
	qxRwMRa0+dFejYDkJRe5izywQk1z6wy7GFCdJnUw/sAbup+WBaaX5egt65qJQWKZMfEhpQ
	awT1AEllwpFVHskR2SUTaRqtXBVWeD8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Correctly handle page aging notifiers for
 unaligned memslot
Message-ID: <ZK2Zq9YbN4G/Pf0+@linux.dev>
References: <20230627235405.4069823-1-oliver.upton@linux.dev>
 <86edlewyh2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86edlewyh2.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Tue, Jul 11, 2023 at 11:10:01AM +0100, Marc Zyngier wrote:
> On Wed, 28 Jun 2023 00:54:05 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > +static int stage2_age_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +			     enum kvm_pgtable_walk_flags visit)
> >  {
> > -	kvm_pte_t pte = 0;
> > -	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
> > -				 &pte, NULL, 0);
> > +	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > +	struct stage2_age_data *data = ctx->arg;
> > +
> > +	if (!kvm_pte_valid(ctx->old) || new == ctx->old)
> > +		return 0;
> > +
> > +	data->young = true;
> > +
> > +	if (data->mkold && !stage2_try_set_pte(ctx, new))
> > +		return -EAGAIN;
> > +
> >  	/*
> >  	 * "But where's the TLBI?!", you scream.
> >  	 * "Over in the core code", I sigh.
> >  	 *
> >  	 * See the '->clear_flush_young()' callback on the KVM mmu notifier.
> >  	 */
> > -	return pte;
> > +	return 0;
> >  }
> >  
> > -bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> > +bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
> > +					 u64 size, bool mkold)
> >  {
> > -	kvm_pte_t pte = 0;
> > -	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> > -	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > +	struct stage2_age_data data = {
> > +		.mkold		= mkold,
> > +	};
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb		= stage2_age_walker,
> > +		.arg		= &data,
> > +		.flags		= KVM_PGTABLE_WALK_LEAF,
> > +	};
> > +
> > +	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
> 
> Do we really want a WARN_ON() here? From what I can tell, it can be
> (trivially?) triggered by the previous function returning -EAGAIN if
> the pte update fails in the case of a shared walk.

I threw the -EAGAIN in there just due to reflexes, we're holding the MMU
write lock at this point so stage2_try_set_pte() will always succeed. A
tad fragile, but wanted to make it trivial to change the locking around
stage2_age_walker() in the future.

The reason I wanted to have a WARN here is because we're unable to
return an error on the MMU notifier and might need some breadcrumbs to
debug any underlying issues in the table walker. I'd really like to keep
it in some form.

I can either replace stage2_try_set_pte() with a direct WRITE_ONCE()
(eliminating the error path) or leave it as-is. Which do you prefer?

--
Thanks,
Oliver
