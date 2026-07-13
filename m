Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222F3437112
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951242; cv=none; b=b7va0TRI9B+nnQPFy7TdNO5g2PdgBpMcLMEUhKlhxITjb8Pfxz6BHNTUOKu3wtXfQLumwp+rev608cz3sp4MIN8Ms4AsXxGCI6QJWFDapxCsSNkanvosvJ1Rj9mb6vY51gi3bKvz88X1Tz8lxTrj3++kS2yVrW1ccvQ3ySAjwpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951242; c=relaxed/simple;
	bh=bMIBopPRKUwgx4lNvc1cfKNevynafbW2a4cGAOw5U/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzpGrohz2VZzTQFEbcYDtTggrPtvaYf9gTysLTvd4dhzx9TMeTlziV3KHoMPPptg357MP0ytjFcahePKc83HY6liFJMXJlU3x3jSZDQCnpCR0+EfaztTINVjNVZ4vWxNMzoyPdDWJMv+zkaojix3DWWXg5dpV0topDQ9KJ+2P1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGDTlhJ0; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGDTlhJ0"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c556ada3so102605e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 07:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783951238; x=1784556038; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FSjsOyZhkm+OarIp2DDhMFpCZd5ArExcqSVv0NgiTKM=;
        b=vGDTlhJ06Suuo+sqld5UfHA2/p+ARRdSjHDXP5iegJfx+/slPNz2NKuVTCxGLT9C9a
         fotlMSUKGkfro+nWteCb418avDNRKc79oeUZ2DlX2y7oeHDj6v9hwp4j0aYGkA3d6sOe
         /Z8P0N8dNDwFFeCUr5jvEeuYUS1wj8a/PZ64pg4NRvHd/DcG3E0J8E4PO0tqeDT3V2U1
         3yhKgD7vH080PfxtNVlhxIP5At6ocJMb9i628OiZnm6PKtKld7vaNblnpd7L6tsacfRe
         O+klwEQw/OJbl6quu860VyrGFZHAVZPhbNNX2g1y5oVz5qrz2bZw6C0UTn2I+lCgaFeQ
         +Gzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783951238; x=1784556038;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FSjsOyZhkm+OarIp2DDhMFpCZd5ArExcqSVv0NgiTKM=;
        b=ktLQyI6cMNDLUDmLR9tBh3LMPjx76R9rMliRaKms0f/f3/+5pSC6tBBa9S/zRQSMuD
         XCWOSNVN8LTk5K017kZd7iZ6lgwcDaz5WijtsgsFrtPccHhVb6mtZO/JkDVjZPKNxueX
         /JQw4O+uDJtOeETSv23/4dGedZxzvS7Zn65ghG02w7kY1JdeeohNvuPbm9g68M1Z+uEI
         B+8VfN/eHMfr1F6C0PEHkb5sVJ+gC1XoyEu2VIy6JLhWPjOInDnsl2WH6yf+jqS+x5Pc
         B73jvr3dg2R7OrPjqX+ABnndAeoekLmj8sIX1O94443RpF5EJQbuLlD0lZAu/eoTzttH
         Hn/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrT42XYbLLsAjLWmVbEjF9c7ijszgP/RlDk3sDV+KAEZpJPHyG0rSlYvPqDNIKgo/EEqhN1gZw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFZy6cJzMnutgQFC7aoCDfBa0KeGs750O6o7a5Q8Iq4hhJ07kn
	EDahrb06U2o2O/WzqDcRzb55MCidTfayMbhggFX1CF2/IXtXDWw5ao91lRqSpAfz0g==
X-Gm-Gg: AfdE7clqmHb972PIbC+/YWYD6JOrQjpTZ5mKMsbFlX6Zj4Aac57nnwlav+xI2desJ20
	g67r8DThSkstse/YSaatuhfTpWMkLhvI6t6E3UcqllbTTABW/jL6MtW+Pfu4afJnAL6J/I5uH6D
	hEoIxzZ0FTvPLsrMz1LY9h11NhXWjPIcnYiOWmg6lpZxjB2uY/jTOZq5I9wEeHWVezZ0scQpvcK
	N2315cbkCyJDU+kQ2zjS1h6/UUOMBmFA43sXt5aY1a+HFtS6zz0NQXvvmEI2aSBxx8r2pbYMcJo
	D6OctCDfApbZOilp4p0lODAr3aZpwpZivzMzSyCvyhPTJLfR5xqRaRALyTHg3vqzfX0MMiutEgK
	Gur44MH54WE4omIWKAwZ0GkGbBovi1JPL1LHXr7KUFVnruyZL0ccklfcMFHs6H9DmnMlJMbUr/r
	YzoZ6gPVMkRr9Vf0vZVkmLXQkUVta+N0SlsIL8z8mOyWYbgayQ
X-Received: by 2002:a05:600c:2942:b0:493:a96b:f9fe with SMTP id 5b1f17b1804b1-4945e4218c8mr367445e9.4.1783951237852;
        Mon, 13 Jul 2026 07:00:37 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2e0f165sm211046175e9.0.2026.07.13.07.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 07:00:36 -0700 (PDT)
Date: Mon, 13 Jul 2026 14:00:31 +0000
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
Message-ID: <alTvf7iiOWn4PKE8@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTnAy7jvjUamwUA@google.com>

On Mon, Jul 13, 2026 at 02:24:19PM +0100, Vincent Donnefort wrote:
> On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > to establish DMA isolation.
> > 
> > An initial snapshot is created after the driver init, then
> > on every permission change a callback would be called for
> > the IOMMU driver to update the page table.
> > 

[...]

> > +	 */
> > +	if (pte && !kvm_pte_valid(pte))
> > +		return 0;
> > +
> > +	if (kvm_pte_valid(pte)) {
> > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > +		/* If the range is mapped in a single PTE, it must be the same type.*/
> > +		if (!addr_is_memory(start))
> > +			prot |= IOMMU_MMIO;
> > +
> > +		return kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> 
> Do we really need to do that when is_memory()? 
> 
> fix_host_ownership_walker() by calling host_stage2_idmap_locked() and
> host_stage2_set_owner_locked() should already handle the memory region. That
> would also get rid of kvm_idmap_initialized.
> 
> So this one here could only take care of the MMIO?
> 
> Overall we would have a common point of synchro which is
> fix_host_ownership_walker() after which the host ownership is ready for both
> CPU stage-2 and the IOMMU?
> 

I am not sure I understand, this is another empty page table, so we
have to walk all of the host CPU stage-2 page table to shadow it in the
IOMMU. if you are refering to the case where it handle zero ptes for
memory, I can drop that but it will not change much in this logic.

> > +	}
> > +
> > +	/* In case of invalid PTE, we need to figure out which part of it is MMIO */

[...]

> >  #include <nvhe/mm.h>
> > @@ -481,6 +482,14 @@ static int check_range_allowed_memory(u64 start, u64 end)
> >  	return 0;
> >  }
> >  
> > +u64 find_mem_range_from(u64 start, bool *is_memory)
> > +{
> > +	struct kvm_mem_range r;
> > +
> > +	*is_memory = !!find_mem_range(start, &r);
> > +	return r.end;
> > +}
> > +
> >  static bool range_is_memory(u64 start, u64 end)
> >  {
> >  	struct kvm_mem_range r;
> > @@ -577,8 +586,34 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> >  
> >  static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
> 
> I would really split this. I know that this is convinient, but as the function
> says, it only update the page state so it shouldn't hide an update to the IOMMU.

I mention a couple of alternatives in the commit message, I tried to
implement it differently which was harder to reason about as the calls
was scattered everywhere and any small refactor will possibly break it.

Did you have a split in my mind? I open to rework it.

> 
> Beside, we have examples already in Android where we want to update the
> page-state but not the IOMMU, so it doesn't feel future-proof...
> 
> >  {
> > +	enum pkvm_page_state old = get_host_state(hyp_phys_to_page(addr));
> > +	enum kvm_pgtable_prot prot = 0;
> > +
> >  	for_each_hyp_page(page, addr, size)
> >  		set_host_state(page, state);
> > +
> > +	/*
> > +	 * Any transition to PKVM_NOPAGE, unmaps the page from the host
> > +	 * Any transition to PKVM_PAGE_SHARED_BORROWED, maps the page in the host
> > +	 * Any transition to PKVM_PAGE_SHARED_OWNED is ignored as page is already mapped.
> > +	 * Transitions to PKVM_PAGE_OWNED from anything but PKVM_NOPAGE are ignored.
> > +	 * Transitions to PKVM_PAGE_OWNED from PKVM_NOPAGE will map the page.
> > +	 */
> > +	if ((state == PKVM_PAGE_SHARED_OWNED) ||
> > +		((state == PKVM_PAGE_OWNED) && (old != PKVM_NOPAGE)))
> > +		return;
> > +
> > +	if ((state == PKVM_PAGE_SHARED_BORROWED) ||
> > +		(state == PKVM_PAGE_OWNED))
> > +		prot = PKVM_HOST_MEM_PROT;
> 
> ... and that would avoid that sort of things here. The caller decides if the IOMMU
> is updated or not.

Typically, the IOMMU is updated if the CPU is.

> 
> And as the patch says, we "shadow" the host stage2. So probably modifying
> host_stage2_idmap and host_stage2_set_owner_metdata() sounds really a better
> approach.

Initially, before the pKVM merge upstream I was doing something similar
as that only required one hook [1]. However, after rebasing I found that
would be too complicated and I have to add many more (as mentioned in
the commit message). But I can re-visit this approach in v7.

[1] https://lore.kernel.org/all/20250819215156.2494305-11-smostafa@google.com/

Thanks,
Mostafa

