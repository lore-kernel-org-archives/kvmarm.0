Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA24035EDDB
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969363; cv=none; b=CxRHkTAzOnkRDL5RfRymCSQX6LXvEcOwi727c/4zcHlaACQcnSVHkD1h5UOPtvzJ3tNTAmYI+eDP1f6PLE1SFpZmk22xuY5Fn3fFz/Lu/TRSsdDikWs0oAxcIEIfee5vZDADknXO6TgTReuswOIGpUS+L+ZTFZDTGpDWgp5UE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969363; c=relaxed/simple;
	bh=XyFQSkYbtQZx84gbWtGBs7EA771y4SuSKEiWeOXYfb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pl+1xJUdEy8A0DKgTJlKWEjgkRKrc3gKChDugpgzT9Z3Nd2nWan4HXU5wV16hwoEIjz+iJRo+0yTCnQ2DxJz1P02sMS6pOM+IB86YJXXFvO/j/LFlIjDNRMxNWzs21kguGoavH6CsUpcXI9WoJPk66qb5EDfZSAnhBBNBUv0Lco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmP0HPFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmP0HPFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9607C4CEF1;
	Fri,  9 Jan 2026 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767969363;
	bh=XyFQSkYbtQZx84gbWtGBs7EA771y4SuSKEiWeOXYfb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VmP0HPFfnWuSjkE7BBPHx2XBCZ2sQMrSsaXFYAJV4OAQnKcIF8D2wu+6yK3t/xrFn
	 zZ1jd8xcoaU2BbGKBQPdHo3xAr+fwrqrj2jouKYqmVpmyqgnAKDZ7a8nT1kav6k4mk
	 zC3hxdWKGP8NnCOyRIvxgHKjoytoytTKt7VXO+nNEEpqVSuSXZ0GZ10GCaCd804cd8
	 WSWZCIhDISZVwvwQgD9LIXTFrHi2DgwIOVZ9zTjoCVEEFSxT4CQy628iJbMnfY0Dia
	 NW3tMQ30uNgkvmV8+qyq3uskGYsESYD1fmOoJRfgYo50lbnGGmZJhO4/PmIvyez8Oz
	 dd+e2N9wY4HXg==
Date: Fri, 9 Jan 2026 14:35:57 +0000
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
Subject: Re: [PATCH 14/30] KVM: arm64: Hook up reclaim hypercall to
 pkvm_pgtable_stage2_destroy()
Message-ID: <aWESTd5Scyna_3nc@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-15-will@kernel.org>
 <bc246bvbf3cg7scut2dcey7tynxqzclyceqv4hhooqacsdzti7@hcaqfbnvebt2>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc246bvbf3cg7scut2dcey7tynxqzclyceqv4hhooqacsdzti7@hcaqfbnvebt2>

On Tue, Jan 06, 2026 at 02:59:19PM +0000, Quentin Perret wrote:
> On Monday 05 Jan 2026 at 15:49:22 (+0000), Will Deacon wrote:
> > During teardown of a protected guest, its memory pages must be reclaimed
> > from the hypervisor by issuing the '__pkvm_reclaim_dying_guest_page'
> > hypercall.
> > 
> > Add a new helper, __pkvm_pgtable_stage2_reclaim(), which is called
> > during the VM teardown operation to reclaim pages from the hypervisor
> > and drop the GUP pin on the host.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/pkvm.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 1814e17d600e..8be91051699e 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -322,6 +322,32 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >  	return 0;
> >  }
> >  
> > +static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64 end)
> > +{
> > +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> > +	struct pkvm_mapping *mapping;
> > +	int ret;
> > +
> > +	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
> > +		struct page *page;
> > +
> > +		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
> > +					handle, mapping->gfn);
> > +		if (WARN_ON(ret))
> > +			return ret;
> > +
> > +		page = pfn_to_page(mapping->pfn);
> > +		WARN_ON_ONCE(mapping->nr_pages != 1);
> > +		unpin_user_pages_dirty_lock(&page, 1, true);
> > +		account_locked_vm(current->mm, 1, false);
> > +		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> > +		kfree(mapping);
> 
> Nit: this might take a while, worth adding a cond_resched() in here?

Commit 4ddfab5436b6 ("KVM: arm64: Reschedule as needed when destroying
the stage-2 page-tables") breaks the destruction operation up into
chunks so we now reschedule from the caller in stage2_destroy_range().

Do you think we need an additional reschedule?

Will
