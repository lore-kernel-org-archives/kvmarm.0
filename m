Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD055505CB
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087122; cv=none; b=hKBy3mD5GBu7JATkIVBCijbt4cprhoaY38WojCJ1DbD9C21YgAe+aepC/AYVuuDHmXKYRVQ1qmT++lJ8He8WyAtYs5EpbdBOLmcmlcmwt9Apy75U2u21URh83PocSHcGi+vyTP564myPGrF0ZL89MSB4YWbxMttTrwpN4limAl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087122; c=relaxed/simple;
	bh=1TSNOM1E6eZCB3afZ7ek5M3QtD+WO8seJv1O7keDluI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PSs9sJ1CFgj3uCHuESpdtt+lJecNuEUmtRpVpv1CS8kjStDGLvxzF0Fo6Rs5PR9oqFMmztedyM9/yalGMTj5c617GSvn4nbQvnvPWNhbFDfeBex6cVrDZ3aBwZx8jz+GEWFgUVpnewUS/S14ZeJ7vg5IPnvGp+oO+xdPkVDbqzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NTnA3BJ7; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NTnA3BJ7"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso7035e87.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790087118; x=1790691918; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=APD/P/JN3bqXzCWI++nlW2aPVxv9tzFzKtSO5OwlkpM=;
        b=NTnA3BJ7hb/z9qwJKGUW6JhPinWc+CNllPbXAhsu7wRotDwjLSKC9DgBGmxbW2uMbn
         4Mqjspx1svJ2itHmX9iDi15zbFEH4f8SRDdrqjOUm+dfhZaGKWC5W2iCtCfr0YYsUT3P
         UXlB8isHgFWmywCIB9s37BYfqIlDXeCbwcKQ37nifxsiO/KockXmS8TEUsRy/xltTL7R
         fuQwy1iMu0vYI8D/x9FY5IZZf0MwOUMOG1IwHUUuSLORQbtgOQyYyDQH3lUze31G6Sjy
         3qtoONTaG5VGRiaDw1NFB9OJM9ytta/VUkl/tfk8Aa0BxNenIsBJ/+o+CjD4LuNxE4tf
         6IOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790087118; x=1790691918;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=APD/P/JN3bqXzCWI++nlW2aPVxv9tzFzKtSO5OwlkpM=;
        b=uoN00pEs7D2KTJ7M1rfx/mAnpeoiOFqWQjDAJ46sUCd+NWt9+udXZg1REqLFUcxAAK
         g+vFUE9VEu+Yg6zD/DoP2Wz0iRIn6WwTOwn8CRca2SO6sHempLF6TWD/fJK4G9hjJmgi
         wuQK7iYMsdCZUjvyuCd2WX9Ne+5M2TR1G9BcJ2lJf+4HMKU/6fwdLsGdLswUF35c7x9a
         M4IZ+XHuqC8ARkk9T91NSlBL0lLf3BxhKDprQTz+De3Cfabz8Q3wwR57uq3heKySmIGi
         AcOGoLI9VwK513vyQzGVg3HXyoyOY7bj/r7J5eaRWHl8VylQHdTaT9q5ys8Vy99QzisY
         RKEw==
X-Forwarded-Encrypted: i=1; AKwUvBw02jPDoXgRy7TKm7gSksFvssuz4CZRnVrBMIQRoEXfggZ3kCHvM+P8ui1zLs+w5CqyGdh+IOM=@lists.linux.dev
X-Gm-Message-State: AFuF++kkRPHi7ZfF306RppaenMZyLXTmSwuLreFBSXx9Qop0z2pkyJZY
	v3+tvZe7CctH4fbexCXw7WDz11T1qYYG67RyqHiATvpKB3aCLQo/TwmfeKg7cTcgJZ6Pkzzi/I2
	tmLOEbQ==
X-Gm-Gg: AYBFou2mIVEkZ7ayHNCoMt95bZC0wZHn4bHXl0GaVficSfKMw/sCDXharA2aYuzYLD7
	nVVezo3AMadIj9DB8Fjby7bZb3RlvtEm33VftdH3VTSQtR7qlmr4Srv8hMec+1+D7eM3O9bnikq
	ZRj0rCj/mkKmVPAN3OK17JfrfDG11HbCFmP3n3ST+P5827R/wlEZadlqcaB8PzZSydl60H0orl3
	BeKliLohfcZ2yPL8IYb8ZJHstWCoRUmZYig5hv+xbjqZ00NbUI/EiAJZTIEECKvdoV5XhAfMVzc
	JEIRjEV0sh9QS+owW7wKzwdxrzYdwbUR7jw/tecHyPHcHKhD/Ali//EPogUAXD76k70h1Hn8cAk
	0gt70O9kvwwdO9FMoIIuoHCpC/B9z92oZW6UTx5T4aPqWzAor465+zrE8BLDjbmT/uo0+24biwE
	qYsk7h2Wuw4dh1pXADARIuzf0W7JPvqSLIkR1mryABu5+urfhjYvfFujjvlQhK6BjviuOQSFvfs
	Lcbrj/o+dwD/EXdVVqk5Hx6+edaL62FUiUp081J
X-Received: by 2002:a05:6512:3d08:b0:5b8:c230:1241 with SMTP id 2adb3069b0e04-5b8d756f723mr21662e87.10.1790087117884;
        Tue, 22 Sep 2026 07:25:17 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e8bebsm574512e87.64.2026.09.22.07.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:25:16 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:25:11 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 01/25] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <arKPx3W5LORqKizu@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-2-smostafa@google.com>
 <20260922132915.911161F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922132915.911161F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:29:15PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] kvm: arm64: resource leak and memory attribute mismatch on MMIO donation error path
> --
> 
> commit 96c49002ec46fcffdec0cb75c633309cd148cad6
> Author: Mostafa Saleh <smostafa@google.com>
> 
> KVM: arm64: Donate MMIO to the hypervisor
> 
> This commit introduces functions to donate MMIO memory between the host and
> hypervisor. It enables IOMMU hypervisor drivers to protect and access the
> MMIO of IOMMUs by mapping the MMIO range in the hypervisor's private range
> and unmapping it from the host stage-2.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> 
> [ ... ]
> 
> > +int __pkvm_host_donate_hyp_mmio(u64 pfn, u64 nr_pages, unsigned long *haddr)
> > +{
> > +	u64 phys = hyp_pfn_to_phys(pfn);
> > +	u64 size = PAGE_SIZE * nr_pages;
> > +	kvm_pte_t pte;
> > +	u64 offset;
> > +	int ret;
> > +
> > +	/* Only before de-privilege. */
> > +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > +		return -EPERM;
> > +
> > +	if (!pfn_range_is_valid(pfn, nr_pages))
> > +		return -EINVAL;
> > +
> > +	ret = __pkvm_create_private_mapping(phys, size, PAGE_HYP_DEVICE, haddr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	host_lock_component();
> > +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> > +		if (addr_is_memory(phys + offset)) {
> > +			ret = -EINVAL;
> > +			goto unlock;
> > +		}
> > +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys + offset, &pte, NULL);
> > +		if (ret)
> > +			goto unlock;
> > +		if (pte && !kvm_pte_valid(pte)) {
> > +			ret = -EPERM;
> > +			goto unlock;
> > +		}
> > +	}
> 
> [Severity: Medium]
> Does this leak the hypervisor private mapping and leave a mismatched memory
> attribute if validation fails?
> 
> In __pkvm_host_donate_hyp_mmio(), the PAGE_HYP_DEVICE mapping is created
> before the physical address is validated against addr_is_memory() or the
> page tables. If the validation fails, the function exits via the unlock
> label and returns an error without rolling back the private mapping.

Yes, in that case the private mapping is leaked, as there is no function
to remove private mappings. This a pattern in the hypervisor in similar
error cases during init.

> 
> If the host firmware provides an invalid physical address (like a RAM
> address) for MMIO donation, this leaves the virtual address space leaked
> in EL2. Additionally, keeping RAM mapped as PAGE_HYP_DEVICE creates a
> mismatched memory attribute (Device vs Normal) for RAM in the hypervisor
> translation regime, which can cause unpredictable behavior.
> 

pKVM has to trust the firmware, otherwise much bigger problems can
happen. So this check is mainly added for very unlikely conditions
(firmware is really busted or during development)

Thanks,
Mostafa

> > +	/*
> > +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> > +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> > +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> > +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> > +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> > +	 */
> > +	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> > +			      phys, size, &host_s2_pool,
> > +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> > +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> > +unlock:
> > +	host_unlock_component();
> > +	return ret;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=1
