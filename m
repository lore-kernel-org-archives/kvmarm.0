Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D3E2C0F6D
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783957876; cv=none; b=pZMGp1zbKBqf7rdrhGKaPw1wG3NrOiGSXqyQKbOD+F2MuF8PbwbG4429dB4CYOy3I8jBMq7WmzOfpFNrXDlLvn4VEuqqcX0WA9TvBv4njOVs18NuMDlOiDL2HBwNRpbucIbpCxBNONSWSjJ01JS58+PWMXsibelbY0F6gWNXqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783957876; c=relaxed/simple;
	bh=9cRPOmjUzRi8pWzUogk0ZC72f2jO7AIYlCNov/QU61c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUGxC0QPe51MptmvgiZwnD/f5Vgn/5Rd3uJ8kr+Q9eB8NYfI5/KifqNalUkJIauLP3biLp/RzLeqGERtY9WjsPhIKQZGNvpyxx4jCzsYxYEMpObwRuU9wZt4QUmGQljy4RZM9hepkC8Al4xOv/1UFn310AKDJjvYTiPtVzD6LR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=acJXsGDb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="acJXsGDb"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c556ada3so111605e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783957873; x=1784562673; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c+u4wOosch17douWjmqLZ5xq3MbumbBJVHk1MNjePoo=;
        b=acJXsGDbMzcbroqMwwmTlomR56DemcyJO08Ig4bNkQxgqupDgl5y1es5KsjGfZ8Ezb
         t23ZIR8Z2hXHjH+I9FK3qauuFAv/I56IxfystuiccapPbi9bipUXIJIECS0i3SCE43KK
         rLGhAlIXzhx9c2j4mzj2JP93pNBhiuiM9dOsP6pGOniiyizl54DktG4IJtB4IgbMM7KM
         O0ViVzv0bUDH1EKuYf7u3Oh0T4EFbrbf47pTGGG44dQ4cNonn3bKQY/zGB/hgDDe4PNt
         p6jQ95MH0cdMypmaRrXYLc3DFAm+322uhBAyvBAgAIp6Zlb14bsN6mPIJW3CAk65wqtM
         z40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783957873; x=1784562673;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c+u4wOosch17douWjmqLZ5xq3MbumbBJVHk1MNjePoo=;
        b=C9/AlH6z9TeFcdgSsq4h85MpyrVSB+Tg+f95r0B+u7teq8O3S2GCw/uiydQ0Gg/ejY
         h++q/cgIm/HVu7Ui2AeTehgxJgtlPukW8Kq7yMcQcrQlw98hwKLi2/Lum3zFNz7rJh+G
         O7URPgX4QHmkfJaMjB8szgV/6/apnfnf9oEf2q0wNG1kbfO+ovsY+lSkJpi1B9QXaIZR
         gjjWzvQZZuPl5RgNIUbsuPULMHx7uc3f+sdgPE+rDFLT6eleW+hs0Tg1BGCYvB/Aabuu
         12RyZ/d/kGL2iwK3wnRY7H0i+9fY5iTsoXc2XWfLjfoYNiTKjX9Ysli1yhK92lp/ycEU
         OuQg==
X-Forwarded-Encrypted: i=1; AHgh+RqU8/0GLUF0fLVykUXzH4I6l9BiisW2SrUqlnVAtW73P4HkPJim1S7R8PysZh/uUTUy8xWbWV4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuTqfFbMdfTbaJ0olDTFIPLhINlHZna0Pr6ui/IwTmmJP5e7Pp
	Mgz1Ycs8Hnk7XgM/p/w++uv2zaQsMMkraNs1Hbx2oqhUNSszUbdJvac96oF0DbSPuQ==
X-Gm-Gg: AfdE7cnVJZOPhpyn4zXCdryXHXHb8L0LxKO3JO5106ix/cuue7OxP8FEGj5vB9eRs/e
	LQhi2z4+xqKrbDI4SUqIvjrE7DhoXUTj7eMJb7abh+GdUZS0KEcsffNPvw1XPKPT2rZtecvOVlG
	OhKsmJiLyzU5cnAgH3iNyvuIWEotPCOXybj1BkZEMIBu/TN5VAPRjBBm3BuqRbwAHmyTIuEvmwf
	AJvKq7UCrD4XjuMhoDNQKbjP991pMjUriEDxX23ICOkOSjbcu5EAgWydu+xmyUB8TSoCabXTBEq
	Ii9iXNmQeshOn01UVe9bSaF0iuYoLWoSWPHeQNuy8asvAzG3NRc4S39SQODw9vag12yd+b27SSQ
	VzdiZf6kLLVbK4aeRRvAXhNtfnptszWwTV/LKF7UXHp2DCfgMmWetZL9JGufOtxhmzywQrmnIFJ
	Q7cEq++pV30CDt1S134CiPrD1kA6fgnlR6LaDY6Qi8QAGFN1i9
X-Received: by 2002:a05:600c:6d85:b0:493:be38:fa5a with SMTP id 5b1f17b1804b1-49462179b27mr415675e9.10.1783957872819;
        Mon, 13 Jul 2026 08:51:12 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f462e0cb2sm400519f8f.0.2026.07.13.08.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 08:51:10 -0700 (PDT)
Date: Mon, 13 Jul 2026 15:51:07 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alUJa5cbjjqZ8n72@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
 <alUA7zsJO1FGnss-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alUA7zsJO1FGnss-@google.com>

On Mon, Jul 13, 2026 at 04:14:55PM +0100, Vincent Donnefort wrote:
> On Mon, Jul 13, 2026 at 02:00:31PM +0000, Mostafa Saleh wrote:
> > On Mon, Jul 13, 2026 at 02:24:19PM +0100, Vincent Donnefort wrote:
> > > On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> > > > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > > > to establish DMA isolation.
> > > > 
> > > > An initial snapshot is created after the driver init, then
> > > > on every permission change a callback would be called for
> > > > the IOMMU driver to update the page table.
> > > > 
> > 
> > [...]
> > 
> > > > +	 */
> > > > +	if (pte && !kvm_pte_valid(pte))
> > > > +		return 0;
> > > > +
> > > > +	if (kvm_pte_valid(pte)) {
> > > > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > > > +		/* If the range is mapped in a single PTE, it must be the same type.*/
> > > > +		if (!addr_is_memory(start))
> > > > +			prot |= IOMMU_MMIO;
> > > > +
> > > > +		return kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > > 
> > > Do we really need to do that when is_memory()? 
> > > 
> > > fix_host_ownership_walker() by calling host_stage2_idmap_locked() and
> > > host_stage2_set_owner_locked() should already handle the memory region. That
> > > would also get rid of kvm_idmap_initialized.
> > > 
> > > So this one here could only take care of the MMIO?
> > > 
> > > Overall we would have a common point of synchro which is
> > > fix_host_ownership_walker() after which the host ownership is ready for both
> > > CPU stage-2 and the IOMMU?
> > > 
> > 
> > I am not sure I understand, this is another empty page table, so we
> > have to walk all of the host CPU stage-2 page table to shadow it in the
> > IOMMU. if you are refering to the case where it handle zero ptes for
> > memory, I can drop that but it will not change much in this logic.
> 
> In fixup_host_ownership() we already walk the hyp pgtable to know what needs to be
> map/unmapped from the host stage-2. Can't we rely on that for the IOMMU
> page-table as well?
> 
> As of, fix_host_ownership() could handle the host stage-2 __and__ the iommu? 

fix_host_ownership() only walks the hypervisor page table, and fixes the
hypervisor pages in the host. That means that the IOMMU page table has
to  be fully populated first, then we unmap the donated pages.
That seems more complicated and it feels that decoupling the IOMMU
logic outside of this would be better.

Also, I rely on the IOMMU init to be done at the end of setup, so we
do not have to clean the IOMMU init if any other part of KVM fails.

> 
> > 
> > > > +	}
> > > > +
> > > > +	/* In case of invalid PTE, we need to figure out which part of it is MMIO */
> > 
> > [...]
> > 
> > > >  #include <nvhe/mm.h>
> > > > @@ -481,6 +482,14 @@ static int check_range_allowed_memory(u64 start, u64 end)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +u64 find_mem_range_from(u64 start, bool *is_memory)
> > > > +{
> > > > +	struct kvm_mem_range r;
> > > > +
> > > > +	*is_memory = !!find_mem_range(start, &r);
> > > > +	return r.end;
> > > > +}
> > > > +
> > > >  static bool range_is_memory(u64 start, u64 end)
> > > >  {
> > > >  	struct kvm_mem_range r;
> > > > @@ -577,8 +586,34 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> > > >  
> > > >  static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
> > > 
> > > I would really split this. I know that this is convinient, but as the function
> > > says, it only update the page state so it shouldn't hide an update to the IOMMU.
> > 
> > I mention a couple of alternatives in the commit message, I tried to
> > implement it differently which was harder to reason about as the calls
> > was scattered everywhere and any small refactor will possibly break it.
> > 
> > Did you have a split in my mind? I open to rework it.
> 
> Yes, I meant the option #2.
> 
> > 
> > > 
> > > Beside, we have examples already in Android where we want to update the
> > > page-state but not the IOMMU, so it doesn't feel future-proof...
> > > 
> > > >  {
> > > > +	enum pkvm_page_state old = get_host_state(hyp_phys_to_page(addr));
> > > > +	enum kvm_pgtable_prot prot = 0;
> > > > +
> > > >  	for_each_hyp_page(page, addr, size)
> > > >  		set_host_state(page, state);
> > > > +
> > > > +	/*
> > > > +	 * Any transition to PKVM_NOPAGE, unmaps the page from the host
> > > > +	 * Any transition to PKVM_PAGE_SHARED_BORROWED, maps the page in the host
> > > > +	 * Any transition to PKVM_PAGE_SHARED_OWNED is ignored as page is already mapped.
> > > > +	 * Transitions to PKVM_PAGE_OWNED from anything but PKVM_NOPAGE are ignored.
> > > > +	 * Transitions to PKVM_PAGE_OWNED from PKVM_NOPAGE will map the page.
> > > > +	 */
> > > > +	if ((state == PKVM_PAGE_SHARED_OWNED) ||
> > > > +		((state == PKVM_PAGE_OWNED) && (old != PKVM_NOPAGE)))
> > > > +		return;
> > > > +
> > > > +	if ((state == PKVM_PAGE_SHARED_BORROWED) ||
> > > > +		(state == PKVM_PAGE_OWNED))
> > > > +		prot = PKVM_HOST_MEM_PROT;
> > > 
> > > ... and that would avoid that sort of things here. The caller decides if the IOMMU
> > > is updated or not.
> > 
> > Typically, the IOMMU is updated if the CPU is.
> > 
> > > 
> > > And as the patch says, we "shadow" the host stage2. So probably modifying
> > > host_stage2_idmap and host_stage2_set_owner_metdata() sounds really a better
> > > approach.
> > 
> > Initially, before the pKVM merge upstream I was doing something similar
> > as that only required one hook [1]. However, after rebasing I found that
> > would be too complicated and I have to add many more (as mentioned in
> > the commit message). But I can re-visit this approach in v7.
> 
> What bit would be more complicated? As you've wrote in the commit message, in
> option#2 you only need two calls really:
> 
>   * host_stage2_set_owner_locked()
>   * host_stage2_set_owner_metadata_locked().
> 
> This fits better the narative for the "shadow" page-table: when we map the host
> stage-2, we map the iommu and when we unmap the host stage-2, we unmap the
> iommu.

I see, looking again it does not seem as complicated as I was imagining,
I will try that for v7.

Thanks,
Mostafa

> 
> > 
> > [1] https://lore.kernel.org/all/20250819215156.2494305-11-smostafa@google.com/
> > 
> > Thanks,
> > Mostafa
> > 
