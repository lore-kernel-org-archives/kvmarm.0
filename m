Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5CE33A029
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783955705; cv=none; b=OIZcVI73mw1PEjpS+rs9959pvQHYbzs/Rpbw7cv+HTBg3vfjMLWHoSJnNmKJdBC855acZtiHHyM481+yCaFKJCS4EJa7e9NZ/FgZdUonBdbwriY6JPLFkVKYyn6dvn3/ItRZVGtk1YLWfqA5sdnzTecw9JAZdtIcz3jecXqN0F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783955705; c=relaxed/simple;
	bh=eo3Gk0sg4HBpFkRyTtettI73qSTpNfjBrKAN8O4o0Fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JixQL7FecYaTuBQ7lZ00eUXi98XoRCNTMx+Ki1f2fphZwh//XhYve5nTQoTNoGnpsJiTbG6riCq48Fhe9gN32FscNZBVUj8IOsDMDrVm5KkwuyjbUO2K4xg/JGyXHfRz3YPXltPjNXloAVa/YvO57wwwcs7/HQWNZqf6a6kkHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YhPQqklV; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YhPQqklV"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47defd0c1c5so2184760f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783955702; x=1784560502; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P15DWYQO7QDzTQoPbuyf65oQTF47QNr5bOsQquOeepQ=;
        b=YhPQqklVkOKL9XxMyUpScm6pujViGEIQMqlq4Efqv01FE2UYPQKuhIxWw3CnzxuKQM
         plOQ/S/I1Rn7utOOmSL85OmzouVZMLgrpF10E5JUyVglndaTdBOo3fBlhCvPyDSVkk/o
         4dnT2FS+mCyAlpqchECmu4u+8QrP6YGUMYzCC85/7wvhNqpJWqpElp7Sdm37QvmADKgr
         swV7uYxhrID+zG41crLUP0JkwYxhCxebYx+gaCzCSIIXrA+Xu4z+VgfXg8lOkoDx0wNs
         EPVcV3kMZSTes6YNrtSc4j/+haobL3X9xELF2xyhAmuLigFyHeRxTSmZwDSGUWcbU5PT
         E5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783955702; x=1784560502;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P15DWYQO7QDzTQoPbuyf65oQTF47QNr5bOsQquOeepQ=;
        b=HcL63ny25aLgBlvo/QA67LALpkyDEGC5CclNIMIlksv4S5fM8VYurm/+YRg0hs1uwY
         0hyxm+zm56ssWC0alx4KAKXTFY6ACtdfQPMxrFQsq2LjMjnYZUENnCHLtKEi5KCcBYCO
         /3x2ZkbenKmCWfUyCuDGjWeuqomWyIdXD1C9Niv14So/sR8h0uY5gid2kLUHa/1h/1Tu
         NNSS/pbZTpQuZW0ZYB/hr8z5yctIQa+MipOhYRapmpLNsUhR1Je9FQ/GiLmYPXaIXgqG
         mYIoNPWgv07AgcqxXr85XyLW05dsnoqpRekraizAGEHXUSWtxKCZXQ8FTgb/bnYAv33X
         2QSg==
X-Forwarded-Encrypted: i=1; AHgh+RoqAajFK8ncH9t3Dqyx6h3f0nXSyo825L+3IdQwkI+Fo/wP11JCQI6OoEpmrSWhNK49y2f+dX0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxquELikjrCEw/gBqL1U5C86yA4JWPqnd8Uxa2tbQToU5kCYn+J
	XHseqSBEcDzL3P8oZapMnVmCTU1XA7DWqK5OwJV0HfrYJe3yzcHfyDzaHl1b3cdPGQ==
X-Gm-Gg: AfdE7cl0cffbewKIlwHCKCsw2B6gEniDpLzy6Qmba5Nwd0rLP8pnAGJfNIzotzb8EML
	8Y9HBp9xaGCGM5UZT4/x2ehXEiWb2IxtYGo/EdkYJk7biWGr2iUVY6OmFsabpuBmkhL90VV28g1
	PR49ipJGYd04w+ruM5pjLURXkD++JokUbQDlkYmUBHO24NweBoWqPwRVD8CrgQZhvdxaP5YA57I
	rAIJ/1W2yJ+EWnj8sf2LRJwAy8SV25ugoOXbIU1ANGJ/9hCqXqt7FSQo5Cf08+jBjFjlrgUCYNz
	6oH6Z63/c/ZVqPmkaBC4kOxfpPtblJVbbPRZLjkTk/xEGxCyD9akN3AQdxErdvgX+EcRs7kjWDD
	VMAY9c2vj5RSpSSGptK9vg8A4QWUFfOt9kdi/RAlp6aqi6HFamQPw47y/OZrAMT8GgFEHuqh2Oo
	plGKbp9IVbg4T73nVfibAXUknVWEwnZpEWNYpiy0pZBcc1qUDJYpo=
X-Received: by 2002:a5d:5f88:0:b0:47d:d812:e03b with SMTP id ffacd0b85a97d-47f2dce302amr10841669f8f.43.1783955701310;
        Mon, 13 Jul 2026 08:15:01 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a9cesm64944f8f.14.2026.07.13.08.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 08:14:59 -0700 (PDT)
Date: Mon, 13 Jul 2026 16:14:55 +0100
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
Message-ID: <alUA7zsJO1FGnss-@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTvf7iiOWn4PKE8@google.com>

On Mon, Jul 13, 2026 at 02:00:31PM +0000, Mostafa Saleh wrote:
> On Mon, Jul 13, 2026 at 02:24:19PM +0100, Vincent Donnefort wrote:
> > On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> > > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > > to establish DMA isolation.
> > > 
> > > An initial snapshot is created after the driver init, then
> > > on every permission change a callback would be called for
> > > the IOMMU driver to update the page table.
> > > 
> 
> [...]
> 
> > > +	 */
> > > +	if (pte && !kvm_pte_valid(pte))
> > > +		return 0;
> > > +
> > > +	if (kvm_pte_valid(pte)) {
> > > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > > +		/* If the range is mapped in a single PTE, it must be the same type.*/
> > > +		if (!addr_is_memory(start))
> > > +			prot |= IOMMU_MMIO;
> > > +
> > > +		return kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > 
> > Do we really need to do that when is_memory()? 
> > 
> > fix_host_ownership_walker() by calling host_stage2_idmap_locked() and
> > host_stage2_set_owner_locked() should already handle the memory region. That
> > would also get rid of kvm_idmap_initialized.
> > 
> > So this one here could only take care of the MMIO?
> > 
> > Overall we would have a common point of synchro which is
> > fix_host_ownership_walker() after which the host ownership is ready for both
> > CPU stage-2 and the IOMMU?
> > 
> 
> I am not sure I understand, this is another empty page table, so we
> have to walk all of the host CPU stage-2 page table to shadow it in the
> IOMMU. if you are refering to the case where it handle zero ptes for
> memory, I can drop that but it will not change much in this logic.

In fixup_host_ownership() we already walk the hyp pgtable to know what needs to be
map/unmapped from the host stage-2. Can't we rely on that for the IOMMU
page-table as well?

As of, fix_host_ownership() could handle the host stage-2 __and__ the iommu? 

> 
> > > +	}
> > > +
> > > +	/* In case of invalid PTE, we need to figure out which part of it is MMIO */
> 
> [...]
> 
> > >  #include <nvhe/mm.h>
> > > @@ -481,6 +482,14 @@ static int check_range_allowed_memory(u64 start, u64 end)
> > >  	return 0;
> > >  }
> > >  
> > > +u64 find_mem_range_from(u64 start, bool *is_memory)
> > > +{
> > > +	struct kvm_mem_range r;
> > > +
> > > +	*is_memory = !!find_mem_range(start, &r);
> > > +	return r.end;
> > > +}
> > > +
> > >  static bool range_is_memory(u64 start, u64 end)
> > >  {
> > >  	struct kvm_mem_range r;
> > > @@ -577,8 +586,34 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> > >  
> > >  static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
> > 
> > I would really split this. I know that this is convinient, but as the function
> > says, it only update the page state so it shouldn't hide an update to the IOMMU.
> 
> I mention a couple of alternatives in the commit message, I tried to
> implement it differently which was harder to reason about as the calls
> was scattered everywhere and any small refactor will possibly break it.
> 
> Did you have a split in my mind? I open to rework it.

Yes, I meant the option #2.

> 
> > 
> > Beside, we have examples already in Android where we want to update the
> > page-state but not the IOMMU, so it doesn't feel future-proof...
> > 
> > >  {
> > > +	enum pkvm_page_state old = get_host_state(hyp_phys_to_page(addr));
> > > +	enum kvm_pgtable_prot prot = 0;
> > > +
> > >  	for_each_hyp_page(page, addr, size)
> > >  		set_host_state(page, state);
> > > +
> > > +	/*
> > > +	 * Any transition to PKVM_NOPAGE, unmaps the page from the host
> > > +	 * Any transition to PKVM_PAGE_SHARED_BORROWED, maps the page in the host
> > > +	 * Any transition to PKVM_PAGE_SHARED_OWNED is ignored as page is already mapped.
> > > +	 * Transitions to PKVM_PAGE_OWNED from anything but PKVM_NOPAGE are ignored.
> > > +	 * Transitions to PKVM_PAGE_OWNED from PKVM_NOPAGE will map the page.
> > > +	 */
> > > +	if ((state == PKVM_PAGE_SHARED_OWNED) ||
> > > +		((state == PKVM_PAGE_OWNED) && (old != PKVM_NOPAGE)))
> > > +		return;
> > > +
> > > +	if ((state == PKVM_PAGE_SHARED_BORROWED) ||
> > > +		(state == PKVM_PAGE_OWNED))
> > > +		prot = PKVM_HOST_MEM_PROT;
> > 
> > ... and that would avoid that sort of things here. The caller decides if the IOMMU
> > is updated or not.
> 
> Typically, the IOMMU is updated if the CPU is.
> 
> > 
> > And as the patch says, we "shadow" the host stage2. So probably modifying
> > host_stage2_idmap and host_stage2_set_owner_metdata() sounds really a better
> > approach.
> 
> Initially, before the pKVM merge upstream I was doing something similar
> as that only required one hook [1]. However, after rebasing I found that
> would be too complicated and I have to add many more (as mentioned in
> the commit message). But I can re-visit this approach in v7.

What bit would be more complicated? As you've wrote in the commit message, in
option#2 you only need two calls really:

  * host_stage2_set_owner_locked()
  * host_stage2_set_owner_metadata_locked().

This fits better the narative for the "shadow" page-table: when we map the host
stage-2, we map the iommu and when we unmap the host stage-2, we unmap the
iommu.

> 
> [1] https://lore.kernel.org/all/20250819215156.2494305-11-smostafa@google.com/
> 
> Thanks,
> Mostafa
> 
