Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B0A2FDC20
	for <kvmarm@lists.linux.dev>; Mon, 29 Sep 2025 10:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759143464; cv=none; b=k01sENlNHRiV4Ld9eL4EqlJvg5qIdGisN5qWm2ihMyZADbuW7btcCTUt+QOy8GbaxAF2yVhTd+qTQ/SqXNpSxKtO8kz5rdahwKA/LuC/kJZNNPY8TfSMMcHPqiyGS6BqCEpzTK4h4zV4wdrSGbKIphgYpInLK5U9MVinRUSWr60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759143464; c=relaxed/simple;
	bh=4tYuwQTrO9BTMWGb6gaK1mGhCxypY1uT9TTbquG0wME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FejG2OWz4IVFbEty2GVGr2bWsAJei4d1WrhYN/rcqXnil0HtIrMzmVMDYZ4z7vROBxi+cVTx4qwAcNkKwqSB2C+feFA6oj+MjQXjPXNZt3tkvqIjoKu6kebaqD++RdKxDspSmMWt1hun4EP3q0X3bpH2cPjywoTr+Rf4C5Wz+Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V4UrP5Jr; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V4UrP5Jr"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e3bcf272aso119985e9.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Sep 2025 03:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759143461; x=1759748261; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O8UnufLq/Mcz1Rl9avuBFpaPVNHTq+GFP8JL6IXXjIo=;
        b=V4UrP5JrfjFbWRqFNOUoAnnrHV6abh+tO5uPm8F63vQsHrfZ2EjvGIXDCMGkoCnZL7
         IaFxGcTiPLd7vACzd0y1EYNF2CC3rhhZATyUfLNXKyyF+rQrjDWtvlLmhXbfGgE9pc5k
         le+345EQThv/XBWdr5K3SaUkhSZ8kuj/FLHO0sNdMRfv8DMQOPNbrnJJSm2h3wikWhTW
         fXHO0Jsj+OjYccad1zUDCwv6Nb4+EH9MfRBCQnK5zN6wyNPLBeUJzDsMsMrY3jF/hHJa
         UEreqhfZy9mkT/H41ZEPnjLt0eAo/+11riYfPSlvujnS1tVvleCFuytk8chN8dn+OFXn
         1GYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759143461; x=1759748261;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8UnufLq/Mcz1Rl9avuBFpaPVNHTq+GFP8JL6IXXjIo=;
        b=xQ/AegWOlScDH7O000lvpNLJvS1loaTOCCL5N90MtLQGqEChpmd4t5Y6d0GKXzfurJ
         Ye1CVwZPhAXceHBJ+5VoVz0Maqn/3cAcQE9JxdJ8wa9mMKSuIKXNh/EBx/rh/MJRS14o
         +oXqmzmSYQM0BQ8WrVPg4HjH+yx2XsQmCEgQM1nlNngWSUH81LPoII/dcY0ARLc9ToR4
         uyAAUT5y6JlVAwqx97Yhvs0zmBUpuPuab1VTzTmXh/1/dAz23Sx3UTHXFW38hu3uvq8/
         DgeGYq+1/Xzg2H8wb2YY5sg5btRlCBxyoOkEmSb8CNEydZsYNWKM5hl0F1wVScVOFrdG
         xNNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZm331WInO4Kb2suPjDJm1Bprttip4jJc9ToxWRVGIBXEZJ3gz4j6cDGuEdzeoF2rqQJ9zgy8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMSJZXgCv9QtxW7xAOiXQlzxoYKhEC+dYjzbE2Yd7Nabv37Rh2
	aoM2Z84LZnYk4FYYzOeqEstQdWhUdq/lk7ky4R/6DdVAQGRUjRpA3XQ+TZeBL2adcw==
X-Gm-Gg: ASbGncsXaofMqowwyVp/KMk/+Q0OGPJFsyYx2Id+6bo574XHbzCgGmEhzKG7HX6ZO0E
	syztzwHUvY44iyTaMGtuYSkfkhunw05fQsIUBD7kJTkHSu/R5lNoJnYpAQwxKYs31wRvnZiJt3F
	O53+WgfPcz19q+wId3j7dRAcH3M3VHfEcflLUT6Fsu7TIQqXJ9VcZrZxGV/hyUNpjVMtcYZRkpG
	7yUg9Tfx0gDo0lhtb/wnxc9/fk4kMfbmcjYruZKFSqZH06+3eTGo7RDof6bQsyFX8Qlnt0gMeOc
	z1q6etRUlXYuh2/Scx7qHGuoKhuek2SWlRS5SvUkQMmNp83aUowYL1/KMmm+3X83+cq9SxL+Yz8
	JYM775GlpvDn5LpU5N4TgJNl2PHu8T0C4KZuJ0Sy+5ipPKNqnNqsAgx7MR4RljVjfxxc2vwKq0R
	eDlXbnkh5S6fZg
X-Google-Smtp-Source: AGHT+IFGle5uSDx6pJtL9z0dOczocAV6Sw1uDcPJYNHRfsKx0x2lgw6GyR50H0eIdWA6EZ8zfTw+TA==
X-Received: by 2002:a05:600c:a413:b0:45d:f6a6:a13e with SMTP id 5b1f17b1804b1-46e57589541mr240935e9.1.1759143460763;
        Mon, 29 Sep 2025 03:57:40 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab61eecsm220878875e9.20.2025.09.29.03.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 03:57:40 -0700 (PDT)
Date: Mon, 29 Sep 2025 10:57:36 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 02/28] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <aNpmIC-ywzIJCTAq@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-3-smostafa@google.com>
 <aMA13Sowq91XEqP9@willie-the-truck>
 <aMlly_9kDE04Inn2@google.com>
 <aNakIop0jdz9gH-t@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aNakIop0jdz9gH-t@willie-the-truck>

On Fri, Sep 26, 2025 at 03:33:06PM +0100, Will Deacon wrote:
> On Tue, Sep 16, 2025 at 01:27:39PM +0000, Mostafa Saleh wrote:
> > On Tue, Sep 09, 2025 at 03:12:45PM +0100, Will Deacon wrote:
> > > On Tue, Aug 19, 2025 at 09:51:30PM +0000, Mostafa Saleh wrote:
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > index 861e448183fd..c9a15ef6b18d 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > @@ -799,6 +799,70 @@ int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +int __pkvm_host_donate_hyp_mmio(u64 pfn)
> > > > +{
> > > > +	u64 phys = hyp_pfn_to_phys(pfn);
> > > > +	void *virt = __hyp_va(phys);
> > > > +	int ret;
> > > > +	kvm_pte_t pte;
> > > > +
> > > > +	host_lock_component();
> > > > +	hyp_lock_component();
> > > > +
> > > > +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> > > > +	if (ret)
> > > > +		goto unlock;
> > > > +
> > > > +	if (pte && !kvm_pte_valid(pte)) {
> > > > +		ret = -EPERM;
> > > > +		goto unlock;
> > > > +	}
> > > 
> > > Shouldn't we first check that the pfn is indeed MMIO? Otherwise, testing
> > > the pte for the ownership information isn't right.
> > 
> > I will add it, although the input should be trusted as it comes from the
> > hypervisor SMMUv3 driver.
> 
> (more on this below)
> 
> > > > +int __pkvm_hyp_donate_host_mmio(u64 pfn)
> > > > +{
> > > > +	u64 phys = hyp_pfn_to_phys(pfn);
> > > > +	u64 virt = (u64)__hyp_va(phys);
> > > > +	size_t size = PAGE_SIZE;
> > > > +
> > > > +	host_lock_component();
> > > > +	hyp_lock_component();
> > > 
> > > Shouldn't we check that:
> > > 
> > >   1. pfn is mmio
> > >   2. pfn is owned by hyp
> > >   3. The host doesn't have something mapped at pfn already
> > > 
> > > ?
> > > 
> > 
> > I thought about this initially, but as
> > - This code is only called from the hypervisor with trusted
> >   inputs (only at boot)
> > - Only called on error path
> > 
> > So WARN_ON in case of failure to unmap MMIO pages seemed is good enough,
> > to avoid extra code.
> > 
> > But I can add the checks if you think they are necessary, we will need
> > to add new helpers for MMIO state though.
> 
> I'd personally prefer to put the checks here so that callers don't have
> to worry (or forget!) about them. That also means that the donation
> function can be readily reused in the same way as the existing functions
> which operate on memory pages.
> 
> How much work is it to add the MMIO helpers?

It's not much work I guess, I was just worried about adding new helpers
just to use in a rare error path.
I will add them for v5.

Thanks,
Mostafa

> 
> > > > +	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
> > > > +	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys,
> > > > +				PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
> > > > +	hyp_unlock_component();
> > > > +	host_unlock_component();
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> > > >  {
> > > >  	return ___pkvm_host_donate_hyp(pfn, nr_pages, PAGE_HYP);
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > index c351b4abd5db..ba06b0c21d5a 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -1095,13 +1095,8 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > >  	kvm_pte_t *childp = NULL;
> > > >  	bool need_flush = false;
> > > >  
> > > > -	if (!kvm_pte_valid(ctx->old)) {
> > > > -		if (stage2_pte_is_counted(ctx->old)) {
> > > > -			kvm_clear_pte(ctx->ptep);
> > > > -			mm_ops->put_page(ctx->ptep);
> > > > -		}
> > > > -		return 0;
> > > > -	}
> > > > +	if (!kvm_pte_valid(ctx->old))
> > > > +		return stage2_pte_is_counted(ctx->old) ? -EPERM : 0;
> > > 
> > > Can this code be reached for the guest? For example, if
> > > pkvm_pgtable_stage2_destroy() runs into an MMIO-guarded pte on teardown?
> > 
> > AFAICT, VMs page table is destroyed from reclaim_pgtable_pages() =>
> > kvm_pgtable_stage2_destroy() => kvm_pgtable_stage2_destroy_range() ... =>
> > stage2_free_walker()
> > 
> > Which doesn't interact with “stage2_unmap_walker”, so that should be
> > fine.
> 
> Fair enough. I feel like this might bite us later on but, with what you
> have, we'll see the -EPERM and then we can figure out what to do then.
> 
> Will
