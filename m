Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6D9352032
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783966773; cv=none; b=iOdlCQbFJjR6EgRS+ngDsd2HmVj+LpwBFKZBzGucRirnA8/Dn5NKfVEsyUireBjORX/M08+oQ2cishITxk4GWHPV9KH8r4IMcgCNLSpRN3ApR+jeolmUN80WFoYAw9At4b77AN3s95gLfDn02a1i7s+5Hsb2Zf3Bq6ZwbvYLEOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783966773; c=relaxed/simple;
	bh=XcDcA4ks+cWLMqfNxD6uU8FdP6C/NUsSvAF8nhH1dgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWeI8C8rMEhsGsqFqMG4QgfxjGxkxuj4heze2KVF3qgdj9avdD2IWzVF7f79TUi+E0fGOaTdPnaYXQ9jbHg0rBtnHs1ImT/n+25Ump+hfhDqEkYcIyqE6xvUVPEl0oHQfpEQDUDgNDzIqESfa3JNGJw8NfM+88bxnanO9mR1YHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m+Lwq6Gk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m+Lwq6Gk"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so8005e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 11:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783966770; x=1784571570; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TRa3gkBurBR7N5v7ETtohTvNPFwYZWxGltJdYj43XxQ=;
        b=m+Lwq6Gk7VPqcSJAD8yKKnllb7yIZUIAMABfgEnZQDmfDXh3zhyViA0pgkTQQHsug4
         kr4kk2PLUm0PLE4p2baK9ZPc15Nc4NUy6ArC/+2ujdWYGcYrJ3eJZ8vHL1YW1S/kNLRK
         hb9kl3xkjiWxituPt0ljzcpUSDEMOqgR/W5sP4hHprjULFemtO5AJWuNSBR4cFSdEViM
         CqCdqXijQwS0eX4x+6OBKNXpHlyuyOjDiy64lhYH5TEYOLoMqJC/Qh3qAwHDdC8EsWet
         MQTdoiTV9+mOkhUhVmWJ4/ojKlDmdm5X3JntaiVQypb3cqBlfwiD0bY+5qq5uMOl4kLf
         qxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783966770; x=1784571570;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TRa3gkBurBR7N5v7ETtohTvNPFwYZWxGltJdYj43XxQ=;
        b=nkyGV+5/LKXWeibi5g64FnTUmmfVh7AIZ3+vdvTA86slBniP1sbGYY66AIMluxmD+j
         zLSSbCTO2bAhdoJjgyCWSssXJxdftNQ2zCZlOySdlhXT7lJlK2jO0BlX4SJd0qpjFoA8
         Tja5k4qWPV1OvAJgy0tEJUsMJgSemCm8iJVH3WGNLT8+SvXyillghrg/AXJkmOzlXan1
         CXh7cCAxP6wMuIzGNylv9edUaTWo1Ennf/y8YMLTh+RKJUvKdpmzTkMZOQLx0mHmxzdH
         Lgc3XlVdxt/rC6GsN1QEO2WDjnDHz+tkFaOPJGU6UG5wvE5FgMsS6ckoh/cIcNAeZppu
         C+tw==
X-Forwarded-Encrypted: i=1; AHgh+RobJ0EtcGEG3CW3raNTrENGwFhxktuvlqVews8cykj1EJtF79R/QlYxr8HH2VpqzzvG4M27pog=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm57VHva4tSmhzkcIyWjVU1yaDg+NH7D3SLrdTfO88oyB0skTV
	cqfONxnk2ao/a99VYJwWoY7CcMtrwWZbk9EEbGlDb455r4V5t5XDpKeFz0dVmGxivw==
X-Gm-Gg: AfdE7cm4RbMTM3IL32rcw0ftFzlchPqpGphMT6EIbcGb4yoL0GG7XQLApgIG3xijVbf
	bNeSvc8jCjT+1d4u86eEk6t8Q54S04LC2gN3l/eo6eY0+qkcopMy3qVtJwlsl9mMoblFcezpI9y
	Q4GfqGjVroi4jRVdKD20B54qYlnE3Rwp9OVMm7SwS66kjR1fOvG9Qqgjo+ybqfnTFmkYrBfLlMm
	xTwLZQAgS1CGHmfE9o4/hPuHPOakcKECOPnEAykg4Zs/GWx3LVrEUjEoMqwEUDNdgJnRY5iFpFG
	whBcJx07/YmXn0UaBxP3+vuLReF3vpUUKDdFKKJjOQfgpmRb8yKf+f9I8fA7uONBIcv9ZeXxoWd
	GazcRsLE5jrFdtdOD5Vhgp+2nuU4RU2hAnDzQhmdW/vY+ZG41YcU3Tb+u43JLAEbOiQrU9x/w3C
	3LATOoOHT1xAYlHbF2ayPTwYIS3sMALs8z4IYD822fXWMgz/bN
X-Received: by 2002:a05:600c:3f19:b0:493:adf3:d892 with SMTP id 5b1f17b1804b1-49462146d30mr789945e9.3.1783966770170;
        Mon, 13 Jul 2026 11:19:30 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2a38b19sm215129925e9.0.2026.07.13.11.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 11:19:29 -0700 (PDT)
Date: Mon, 13 Jul 2026 18:19:24 +0000
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
Message-ID: <alUsLFBQ5qKFOgwQ@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
 <alUA7zsJO1FGnss-@google.com>
 <alUJa5cbjjqZ8n72@google.com>
 <alUMVU7DYcrvgAYi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alUMVU7DYcrvgAYi@google.com>

On Mon, Jul 13, 2026 at 05:03:33PM +0100, Vincent Donnefort wrote:
> On Mon, Jul 13, 2026 at 03:51:07PM +0000, Mostafa Saleh wrote:
> > On Mon, Jul 13, 2026 at 04:14:55PM +0100, Vincent Donnefort wrote:
> > > On Mon, Jul 13, 2026 at 02:00:31PM +0000, Mostafa Saleh wrote:
> > > > On Mon, Jul 13, 2026 at 02:24:19PM +0100, Vincent Donnefort wrote:
> > > > > On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> > > > > > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > > > > > to establish DMA isolation.
> > > > > > 
> > > > > > An initial snapshot is created after the driver init, then
> > > > > > on every permission change a callback would be called for
> > > > > > the IOMMU driver to update the page table.
> > > > > > 
> > > > 
> > > > [...]
> > > > 
> > > > > > +	 */
> > > > > > +	if (pte && !kvm_pte_valid(pte))
> > > > > > +		return 0;
> > > > > > +
> > > > > > +	if (kvm_pte_valid(pte)) {
> > > > > > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > > > > > +		/* If the range is mapped in a single PTE, it must be the same type.*/
> > > > > > +		if (!addr_is_memory(start))
> > > > > > +			prot |= IOMMU_MMIO;
> > > > > > +
> > > > > > +		return kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > > > > 
> > > > > Do we really need to do that when is_memory()? 
> > > > > 
> > > > > fix_host_ownership_walker() by calling host_stage2_idmap_locked() and
> > > > > host_stage2_set_owner_locked() should already handle the memory region. That
> > > > > would also get rid of kvm_idmap_initialized.
> > > > > 
> > > > > So this one here could only take care of the MMIO?
> > > > > 
> > > > > Overall we would have a common point of synchro which is
> > > > > fix_host_ownership_walker() after which the host ownership is ready for both
> > > > > CPU stage-2 and the IOMMU?
> > > > > 
> > > > 
> > > > I am not sure I understand, this is another empty page table, so we
> > > > have to walk all of the host CPU stage-2 page table to shadow it in the
> > > > IOMMU. if you are refering to the case where it handle zero ptes for
> > > > memory, I can drop that but it will not change much in this logic.
> > > 
> > > In fixup_host_ownership() we already walk the hyp pgtable to know what needs to be
> > > map/unmapped from the host stage-2. Can't we rely on that for the IOMMU
> > > page-table as well?
> > > 
> > > As of, fix_host_ownership() could handle the host stage-2 __and__ the iommu? 
> > 
> > fix_host_ownership() only walks the hypervisor page table, and fixes the
> > hypervisor pages in the host.
> 
> Yeah, Looking closer I don't think my proposal simplify things so much in the
> end.
> 
> > That means that the IOMMU page table has
> > to  be fully populated first, then we unmap the donated pages.
> > That seems more complicated and it feels that decoupling the IOMMU
> > logic outside of this would be better.
> 
> Why more complicated? That's actually another solution I was thinking about, to
> just map everything as soon as possible and let host_stage2_idmap_locked() and
> host_stage2_set_owner_locked() unmap what is needed here. (and also in
> __pkvm_host_donate_hyp_mmio())
> 
> We wouldn't need any specific setup walker for the iommu at all.

That would walk the table twice, first time with a massive map, then
to unmap the pages that was just mapped, issuing TLB invalidations
for all of those, also as the IOMMU page table code never frees tables
that means we would immediately exahust the IOMMU pool.

Also, I believe that it is better to isolate the IOMMU page table
shadowing logic from the core hypervisor page table setup, specially
AFAICT, that was not what fix_host_ownership() was designed for, and
seems the IOMMU will just piggyback on a existing walker.

> 
> > 
> > Also, I rely on the IOMMU init to be done at the end of setup, so we
> > do not have to clean the IOMMU init if any other part of KVM fails.
> 
> We could just leak those pages if it fails?

It is not just about pages, the hypervisor will also configure the SMMU
registers. Ideally, we would need a remove() driver ops for such cases
but I added the IOMMU init call at the end to avoid making this series
any bigger.

Thanks,
Mostafa

