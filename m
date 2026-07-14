Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05AE3D413F
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 08:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017002; cv=none; b=NscKUbfH5je2APrCfwH0RKGslUaisSvSFGy0hj/CF/aEPC0KSdC1/ioKtdFAvii3olUDjAnOYcKKWYJhoRUg16/NnNf/mfx+YwUCxnXYcX7jXXA3l37IEDVtUmOiWWHUTURwrAXrfcfCyvB8AbumXT+EaWH0da67hpBxRNS9J6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017002; c=relaxed/simple;
	bh=pIW3GEM7Pv83J4SSwpowDE6gv+CtyxVPLgQIaLaNnVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSW5O6xr8TjidyTdCRdqYkKuoUoDL5+sO8kpLTVfW4oGxsOmshRNhlAMbqeOHWu4XN3RymtWlZ2t06dD2Vp73kCIAy1/SZsYeK+TcHsdB8qQ4QTXBriAKXOh30NPFljTx4OMXyk56wub61CDu3TaV81GCq3YEjCP8ZM8Ph4lyJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wTm4M9cD; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wTm4M9cD"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-471eeac43bfso3927589f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 01:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784016995; x=1784621795; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SnpHLlkQxy9SlCZj1TgoiRuRQAs8jFdoKCgVX9dwPjA=;
        b=wTm4M9cDncIjo5l/Wmb2rvuZwp3uae7+YTIDA1wfHA5zOicwuo9+enKpF/gz22MU/w
         wex/dVwBDvKzPU3EXplUNL58xUP9imGlDJbvGflQcBzTaF5P6fu5LjGD5mAeYxAWthp+
         TcbQPxsykE1xahDsyzq0I8+/VDiwaOkAAfvtedz1JJs3PvQqlWNoOnbLVbFGDarOf90p
         7ZXkOpUUoM/G/3zPcKkKk4hAc3G21KfbLs3Sbz9txS4JXPk/qNPt/V2odSC3HdxSGGn5
         co9aFXd6MBGHF9h7U7QyKt4OPeE/zO+MBgJcXa2mG1QjgGC4PdBOzrIdy23q7Cb3t/wo
         ZFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784016995; x=1784621795;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SnpHLlkQxy9SlCZj1TgoiRuRQAs8jFdoKCgVX9dwPjA=;
        b=nC6FoyGAdDC5D6YhtUzLKrka2iMoWvkdSLltxoRx4ddeIqtDknBdlQJ389h1tB6PSj
         +I2qAUJrAgLkhtaEv3kqBudK8EqOczVbtXfl6dPZpxaRdIhpHZelx5AE9BbsvNKAlKMM
         OR0eMFWV6demNHlaAlZ4FS1gASdAtWAXsExQI5fY9zDVFncc+jQj/PCswzvqbNZIYGuQ
         SzSq+dVEXlDAoHzie4FpCwR2zxb6ZpsK57EobpUTIqFrjPVm+92twunDArmjl2G8C34K
         u2LBuABhaw3HRnXer0n1tAWy/TTk01/qqgcIivPJirnZPGK8B0RgBjV4x/PWmaFSxli+
         9oYg==
X-Forwarded-Encrypted: i=1; AHgh+RoTS5fx5FIqXVbf2s7bG6f+MboFIHlwUHV9/220MewdW8byPU0xMwgXz+Luvu1HbsvqDezrqeU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+39nRFDYHZZA0G6Y4q1KqOfBWj22a7qqEhWwWUybq1fVKhQBo
	/5bUn5042tcEcUspdMs4GjCeuxFF1uJC/XO7qEBfOLMOhc5fJvE4ID/88jOsFhMKBg==
X-Gm-Gg: AfdE7cl6rTGW9pHrMy0Dwg4ZnEAIkuh9avt+kJy0nMXyOJAM09jGMShTtoDyAYni4xr
	BaQcJrw5VmE8TMfdLQs5rPj1o8OYAEFZgvXLmsNduOawteWl+JY9qFadDBWOxUBg5OEv9bW/F1X
	ukQ6EIDHkc/g7+eaZ1dFkbIiQdrLfwL9pP0bSH/EQaX+JUAGf8WP2pINyG2a8Y4m0kuKg+GkrQl
	7tl6OEC+Hi5J3ESQe/HQEta1bnRNh7D9qFjvN9Bq4cfpnPgZ0ZK/ij0ILvaUBpP2DPTFyz0BKci
	CoozpqRpR/tH4HqKIpDACARjfaJNsvgtPXNmPFzTnqqrFA6+kKyBZecbkfFmRVBnvvM/PVmCyNA
	FW+WrrCo9uatKhwv32XfWUWBXXLm02g95KdYi1grzeGT8cAirdaPmg4NR4Vgi+qIUd/sp8V9A1/
	GkIL435tACsUjuPhH9MCwP1x66AY7zqH8D44Ba3+RewmZji8GUQ3CHoqmKnhaBog==
X-Received: by 2002:a05:6000:2907:b0:470:2fb1:3dbc with SMTP id ffacd0b85a97d-47f2dce7c3emr14605080f8f.35.1784016994090;
        Tue, 14 Jul 2026 01:16:34 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a63esm6159416f8f.9.2026.07.14.01.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 01:16:33 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:16:29 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alXwXRGqECTUZ3ou@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
 <alUA7zsJO1FGnss-@google.com>
 <alUJa5cbjjqZ8n72@google.com>
 <alUMVU7DYcrvgAYi@google.com>
 <alUsLFBQ5qKFOgwQ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alUsLFBQ5qKFOgwQ@google.com>

On Mon, Jul 13, 2026 at 06:19:24PM +0000, Mostafa Saleh wrote:
> On Mon, Jul 13, 2026 at 05:03:33PM +0100, Vincent Donnefort wrote:
> > On Mon, Jul 13, 2026 at 03:51:07PM +0000, Mostafa Saleh wrote:
> > > On Mon, Jul 13, 2026 at 04:14:55PM +0100, Vincent Donnefort wrote:
> > > > On Mon, Jul 13, 2026 at 02:00:31PM +0000, Mostafa Saleh wrote:
> > > > > On Mon, Jul 13, 2026 at 02:24:19PM +0100, Vincent Donnefort wrote:
> > > > > > On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> > > > > > > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > > > > > > to establish DMA isolation.
> > > > > > > 
> > > > > > > An initial snapshot is created after the driver init, then
> > > > > > > on every permission change a callback would be called for
> > > > > > > the IOMMU driver to update the page table.
> > > > > > > 
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > > +	 */
> > > > > > > +	if (pte && !kvm_pte_valid(pte))
> > > > > > > +		return 0;
> > > > > > > +
> > > > > > > +	if (kvm_pte_valid(pte)) {
> > > > > > > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > > > > > > +		/* If the range is mapped in a single PTE, it must be the same type.*/
> > > > > > > +		if (!addr_is_memory(start))
> > > > > > > +			prot |= IOMMU_MMIO;
> > > > > > > +
> > > > > > > +		return kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > > > > > 
> > > > > > Do we really need to do that when is_memory()? 
> > > > > > 
> > > > > > fix_host_ownership_walker() by calling host_stage2_idmap_locked() and
> > > > > > host_stage2_set_owner_locked() should already handle the memory region. That
> > > > > > would also get rid of kvm_idmap_initialized.
> > > > > > 
> > > > > > So this one here could only take care of the MMIO?
> > > > > > 
> > > > > > Overall we would have a common point of synchro which is
> > > > > > fix_host_ownership_walker() after which the host ownership is ready for both
> > > > > > CPU stage-2 and the IOMMU?
> > > > > > 
> > > > > 
> > > > > I am not sure I understand, this is another empty page table, so we
> > > > > have to walk all of the host CPU stage-2 page table to shadow it in the
> > > > > IOMMU. if you are refering to the case where it handle zero ptes for
> > > > > memory, I can drop that but it will not change much in this logic.
> > > > 
> > > > In fixup_host_ownership() we already walk the hyp pgtable to know what needs to be
> > > > map/unmapped from the host stage-2. Can't we rely on that for the IOMMU
> > > > page-table as well?
> > > > 
> > > > As of, fix_host_ownership() could handle the host stage-2 __and__ the iommu? 
> > > 
> > > fix_host_ownership() only walks the hypervisor page table, and fixes the
> > > hypervisor pages in the host.
> > 
> > Yeah, Looking closer I don't think my proposal simplify things so much in the
> > end.
> > 
> > > That means that the IOMMU page table has
> > > to  be fully populated first, then we unmap the donated pages.
> > > That seems more complicated and it feels that decoupling the IOMMU
> > > logic outside of this would be better.
> > 
> > Why more complicated? That's actually another solution I was thinking about, to
> > just map everything as soon as possible and let host_stage2_idmap_locked() and
> > host_stage2_set_owner_locked() unmap what is needed here. (and also in
> > __pkvm_host_donate_hyp_mmio())
> > 
> > We wouldn't need any specific setup walker for the iommu at all.
> 
> That would walk the table twice, first time with a massive map, then
> to unmap the pages that was just mapped, issuing TLB invalidations
> for all of those, also as the IOMMU page table code never frees tables
> that means we would immediately exahust the IOMMU pool.

Well the massive map is pretty quick we would mostly just allocate the PGD? And
then it would be just for the subsequent unmaps to split the blocks. So nothing
to be freed really and no risk to exhaust the pool. But if you put the calls to
the host_stage2_* functions that's pretty transparent.

Just to make sure I am clear. Here's what it could look like:

in iommu.c:

int kvm_iommu_stage2_idmap_init(struct kvm_s2_mmu *host_mmu)
{
	u64 addr = 0;

	for (i = 0; i < hyp_memblock_nr; i++) { 
		kvm_iommu_stage2_idmap(addr, reg->start, IOMMU_MMIO);

		addr = reg->start + reg->size;
		kvm_iommu_stage2_idmap(reg->start, addr, IOMMU_READ | IOMMU_WRITE);
	}

	kvm_iommu_stage2_idmap(addr, kvm_phys_size(host_mmu), IOMMU_MMIO);
}

in mem_protect.c:

int kvm_host_prepare_stage2(void *pgt_pool_base)
{
	...

	return kvm_iommu_stage2_idmap_init(mmu);

	/* 
	 * From here, all the changes to the host stage-2 will be reported to
	 * the iommu driver
	 */
}

On the pro side: no custom walker and we really couple the iommu idmap to the
host stage-2 map.

On the con side: As you've pointed out, we'd need indeed the iommu to be ready
early enough.

If you want to stick to the snapshot function, could we have the walker to
first walk the hyp_memblock? the .arg could just pass if we are walking a MMIO
region? That would avoid that find_mem_range_from() and I believe would
massively simplify the snapshot walker.

> 
> Also, I believe that it is better to isolate the IOMMU page table
> shadowing logic from the core hypervisor page table setup, specially
> AFAICT, that was not what fix_host_ownership() was designed for, and
> seems the IOMMU will just piggyback on a existing walker.
> 
> > 
> > > 
> > > Also, I rely on the IOMMU init to be done at the end of setup, so we
> > > do not have to clean the IOMMU init if any other part of KVM fails.
> > 
> > We could just leak those pages if it fails?
> 
> It is not just about pages, the hypervisor will also configure the SMMU
> registers. Ideally, we would need a remove() driver ops for such cases
> but I added the IOMMU init call at the end to avoid making this series
> any bigger.
> 
> Thanks,
> Mostafa
> 
