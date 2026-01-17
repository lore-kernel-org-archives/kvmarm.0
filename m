Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73471500941
	for <kvmarm@lists.linux.dev>; Sat, 17 Jan 2026 00:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768608245; cv=none; b=gyGPgBO3Cq7wrEoa1EMLklJD4nDMJvKu3+pGCe0ZAU0QJBhOL83Uzop0JgSAIgwXW/27ktAngfr6TA5JGEMY0BvvVUXd81es6S0ELcTXVeuG+AK8+z1QMug4q+7t5dA5w+I83gJV5qGz6vgSxLbk3bIEegyhUF6IL7ke0NN7koA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768608245; c=relaxed/simple;
	bh=gQ49HnwgetN2nDbDg2sBxHse+CaBcYv4VByJE8oyVFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OuL032Er2DP6tYxL0wPSyw+crjnd+9DhD7QxaJ08pWyPAvYRtOREEiDf5YjLIqoVI3iz/RNgXT6BxVjqVV16+NBO/K2fcfgMuE9+C7Ft9PnR5L8rYbSr8Yr3CAto+Wk+EKOJkgkRBjcqcZSKZt+TfX9s8URuCe/j22G6wL77mlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJs6dRFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJs6dRFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967C8C116C6;
	Sat, 17 Jan 2026 00:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768608245;
	bh=gQ49HnwgetN2nDbDg2sBxHse+CaBcYv4VByJE8oyVFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJs6dRFsROanapwatHjpvVgku2MWedGCtQ1cs2kaQANdqrg4n9m66oQWx5FzHX+d4
	 2Xw9jWFWM1JdgBiBM2j2mnd5QlOKBef4E5WqDwC6ibMwip1UlBb8jRGktmKQqOG6v+
	 x9L4v+4fsrMvjM55h72ODVW+gC/JR1/2Wme7y4cNvsob3k6NaWQ+1jmCOV8aMj7uN8
	 ZYc+b4eDH4wfaStI7uPLksgTHnyr59bkF2WuOm7sg/LGxjU+F09BTGFMxeApkB+9Uo
	 sf2rwvocPWnR7/R/LZnBfx0go6Lm4BEhhQ5B1fhRVnp6vBdJBEAzD/sj00w3I19GgB
	 rZCzKFL13+hnA==
Date: Sat, 17 Jan 2026 00:03:59 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 17/30] KVM: arm64: Generalise
 kvm_pgtable_stage2_set_owner()
Message-ID: <aWrR700urENbFLcW@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-18-will@kernel.org>
 <rm55zbvakwmh5ny25bosf3jjiehfubcm2st5q4porsmnffuod5@edygmhqq2ckn>
 <aWFM7NnBkRiM4OQI@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWFM7NnBkRiM4OQI@willie-the-truck>

On Fri, Jan 09, 2026 at 06:46:04PM +0000, Will Deacon wrote:
> On Tue, Jan 06, 2026 at 03:20:15PM +0000, Quentin Perret wrote:
> > On Monday 05 Jan 2026 at 15:49:25 (+0000), Will Deacon wrote:
> > >  /**
> > > - * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
> > > - *				    track ownership.
> > > + * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
> > > + *				   to track ownership (and more).
> > >   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > >   * @addr:	Base intermediate physical address to annotate.
> > >   * @size:	Size of the annotated range.
> > >   * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > >   *		page-table pages.
> > > - * @owner_id:	Unique identifier for the owner of the page.
> > > + * @annotation:	A 62-bit value that will be stored in the page tables.
> > > + *		@annotation[0] and @annotation[63] must be 0.
> > > + * 		@annotation[62:1] is stored in the page tables.
> > >   *
> > >   * By default, all page-tables are owned by identifier 0. This function can be
> > >   * used to mark portions of the IPA space as owned by other entities. When a
> > > @@ -673,8 +678,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > >   *
> > >   * Return: 0 on success, negative error code on failure.
> > >   */
> > > -int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > -				 void *mc, u8 owner_id);
> > > +int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > +				void *mc, kvm_pte_t annotation);
> > 
> > While we're on this topic, perhaps we could go one step further and 'type'
> > the annotation itself? For instance have a 'type' and 'meta' parameter
> > directly at the kvm_pgatble_stage2_annotate() level instead of leaving
> > that up to the callers. This would allow to have one place to allocate
> > annotation 'types' (donated pages, locked PTE, MMIO guard, ...) and one
> > way to serialize/deserialize them. That 'type' would be stored in top 2
> > or 3 bits of the PTE for instance, and decoding of the 'meta' field would
> > be dependant on the type value. Thoughts?
> 
> I don't think a global 'type' space is particularly beneficial, as most
> annotations (with the exception of PTE_LOCKED) are specific to the owner
> and putting them into a single number space will just waste bits.
> 
> But I do like the idea of encoding an annotation type in the pte and
> defining those per-owner. I think it would also make some of the code
> more robust; for example, I noticed that __pkvm_guest_unshare_host()
> isn't putting back the right annotation with my series when I started
> looking at implementing your idea.
> 
> I'll come back with a diff. It won't be quite what you're suggesting,
> but let's see what you think.

Ok, so this took a fair bit longer than I initially thought it would.

In the end, I've ended up with something closer to what you seem to have
in mind: kvm_pgtable_stage2_annotate() now takes both a 'type' and an
annotation but it's not without complexity:

  * We're extremely short on bits when endoding the guest gfn + handle.
    The gfn can be 40 bits with LPA2 and 4k pages, so with the 16-bit
    handle and a 4-bit type, that leaves only 3 bits for the owner.

  * Non-zero invalid ptes are 'counted', so I've had to adjust the
    reclaim path to map pages back into the host immediately rather than
    go via a typed annotation.

Despite that, I think it's a slight improvement for now. We may end up
revisiting it if we want to squeeze more bits out of the host
annotations, but I'll include it in v2 for you to have a look at.

Will
