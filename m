Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970FE54CF6C
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087359; cv=none; b=VDKmOTCR0c/+djD2VRsXdB6HC3SrCUesmSz4E/OOPCe22Gj1FQ2arvEsUUyq3vtHvB1zxeLQDOKkFiS4MVtv7XwaZ4HahVXKxaeBqhT+Ow/zYGTFUCwDsyYY0MeSYbEERPOii7/Ey0msXi3kPJkjN8Wm9GDHafBl+GA/xheifK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087359; c=relaxed/simple;
	bh=OpHY4NXD+atdw7gjGIar2AdTVmoZTKzjqsFs3l0/n1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8bSnNJUn10rtJ7gMrP4XoGdBDxdTe7yZ57b8A+4SNmWnOGFat7/PKg5QE8xUDjkAmvC+D3O9B1QC4iamT6hSfvZFP4f7IjikpW3vCpYtUYX4yb7agyuFygoTGy3JarpYST3ZlU1R66txtEAB0IWmEDk+hgU4hKhmFAA/7Kdhfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TO9wIkjC; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TO9wIkjC"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-498012a61f6so43315e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790087356; x=1790692156; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5d8FCrARkicIkXoFfwK1llal0qOCc070vJfaXSpy94Q=;
        b=TO9wIkjCGVzFJsrY5uSFS0ZrhbcATKGdV/R2E0LOWJs3IEUYgMluv6ysssJ+HmsZf8
         s19AMi8o0VqTTEGKXrhvtmE3noQ3S596b6EnEeUklU4LpNTPPzaBJ8g5wIFtWentOxwJ
         LaG96r0uCbY1YvWA5Q0noOK2uZ+opZRajTkPuf6y0CIfAtwCt41AYLvNSi03g+W504ox
         krNZl6AlHDxAgGh+90+iXwr9O+Gqz4XE17nygUlLczGPEPbaabo6jp+EZcUfIsM56HD6
         mfMRyUTcdECGPGvoiZRtYg0aGn9iqg5hmeaD8hSiJgEO5XQ2T1C546OgZA49YfAPvS1E
         /G4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790087356; x=1790692156;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5d8FCrARkicIkXoFfwK1llal0qOCc070vJfaXSpy94Q=;
        b=ZT/r8QePFN5xVDllG//SYwBIwdWs3q4F9NxlWoKX/oofJoWg6N/C7/38rzIynWbOPm
         gN+PhOeMrTyKscCMKS58bsYGNwFvoBf+jIm7nhfK0G0gP0Ix8EkrhG5R4hKxZ2mOIznS
         itoCRm47dfMgvgNxdrYNpsNlCBvsFtD3IS8+SdTt4BhH5lnJcKLsHF4wkfJgviK2Bzl5
         Qhd+ewcw6ZbieIA8/nx8Y/QHSTdiYDbVV7t8OE9zakboF3xBMdeT+fcvj2wXq4997F7W
         Y7gQmsKt7sJ3JG4oNlJKUfH9f97ALu1+aSxMeFlXMxOkLCwi7vEoLjcuACP3Kehs8ett
         ORGg==
X-Gm-Message-State: AFuF++lhoncMgkw8HAI/6zfSqHiWNr1ROM1I4dyRlxiiDEI2p2n3RtCv
	pr0LFydcXNY7si4A7hHv0qYDJTS7FWSDY+7BEXHkVVZpXh/w3lZES+/mlA0cWN5j8A==
X-Gm-Gg: AYBFou3lQqG79pYH0a95B+4oDXSTHAQ3srtHDzhH99Nz0QzuvqUUeJQq94QA5XI19Sb
	DBtcHc5o28mquCXUWLS7CJ3I5upEmrgPp8S99mLrsyfMndiEfax/OB+SyLg6eXmWfhXX5gQl+tL
	S8IXJD3vkzRd/s2w26QapQ83/C7Sf25FTh99atxQNkDF5nEwxSHkFcVcOx7DAey1vq4dpyLT7XY
	cg9iw/o6Mr0YWzEYHDS8FT9QmmGQZgIL0P0k77//mYl4QtnQAuwb3wfwnnwyLuTT2qUeRFeNdSw
	gh21QN2jJn0fCMCoBILTl0WFk43aubqPS7US6C/cqBfPcSNMjW4X2UgjVqWJfN/gr6EFtFe7rtI
	KG37P9Obo49outP4fARNUG46XdxFENAYAfKZZw7dOFnaBncrO73xOnuzoPwsuH4NHu6iX1wV46F
	1Q0DtOiJ5BhZD4g5izmatPZlzQ3FI6ghwKrWjNqPiFmcQbHSCYNa6wjTVnmXtJDvRXD8+P4esNx
	ejYdW+D/mwWQNADC0fGzsH8nfPSlAyOPhbau+lW
X-Received: by 2002:a05:600c:22d2:b0:49c:fee1:5095 with SMTP id 5b1f17b1804b1-49fdd9c6041mr107385e9.16.1790087355306;
        Tue, 22 Sep 2026 07:29:15 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdab0c240sm38368285e9.4.2026.09.22.07.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:29:14 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:29:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 07/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <arKQttZkiX-kqMZN@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-8-smostafa@google.com>
 <20260922132359.BB0381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922132359.BB0381F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:23:59PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: arm64: pkvm: guest-triggerable hyp panic due to WARN_ON misuse
> --
> 
> commit 68e26689446b14f6e5c91a79e4493c62586f9fb4
> Author: Mostafa Saleh <smostafa@google.com>
> Subject: KVM: arm64: iommu: Shadow host stage-2 page table
> 
> This commit creates a page-table for the IOMMU that shadows the host CPU
> stage-2 to establish DMA isolation. An initial snapshot is created after
> the driver init, and on permission changes, a callback updates the IOMMU
> page table.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
> > index ef456eff42d29..3637b0327d9e8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
> 
> [ ... ]
> 
> > @@ -4,16 +4,138 @@
> >  int pkvm_iommu_init(void)
> >  {
> > +	int ret;
> > +
> >  	/* Keep DMA isolation optional. */
> > -	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init)
> > +	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init ||
> > +	    !pkvm_iommu_ops->host_stage2_idmap)
> >  		return 0;
> >  
> > -	return pkvm_iommu_ops->init();
> > +	ret = pkvm_iommu_ops->init();
> > +	if (ret)
> > +		return ret;
> > +
> > +	return WARN_ON(pkvm_iommu_snapshot_host_stage2());
> 
> [Severity: High]
> Does this unintentionally cause a hypervisor panic if the snapshot fails?
> 
> At EL2 (nVHE/pKVM), WARN_ON expands to a fatal BRK instruction rather than
> a warn-and-continue. Wrapping a fallible operation like this triggers a
> panic during initialization instead of returning the error.

That is intentional as there is no roll-back beyond this point, this
pattern is commonly used with pKVM.

> 
> > +}
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index c1a8fd811c0fa..da5014e4e96b6 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> 
> [ ... ]
> 
> > @@ -603,16 +604,15 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
> >  	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> >  			      addr, size, &host_s2_pool,
> >  			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> > -	if (!ret) {
> > -		/*
> > -		 * After stage2 maintenance has happened, but before the page
> > -		 * owner has changed.
> > -		 */
> > -		pkvm_sme_dvmsync_fw_call();
> > -		__host_update_page_state(addr, size, PKVM_NOPAGE);
> > -	}
> > -
> > -	return ret;
> > +	if (ret)
> > +		return ret;
> > +	/*
> > +	 * After stage2 maintenance has happened, but before the page
> > +	 * owner has changed.
> > +	 */
> > +	pkvm_sme_dvmsync_fw_call();
> > +	__host_update_page_state(addr, size, PKVM_NOPAGE);
> > +	return WARN_ON(pkvm_iommu_host_stage2_idmap(addr, addr + size, 0));
> 
> [Severity: High]
> Does this create a dead-branch trap that skips rolling back the page state?
> 
> Since WARN_ON acts as a panic at EL2, any failure in the IOMMU mapping call
> will immediately crash the hypervisor. It also leaves the earlier mutation
> from __host_update_page_state without a rollback path on failure.

This is added for readability, not really a problem.

> 
> >  }
> >  
> >  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> > @@ -625,8 +625,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> >  			return -EPERM;
> >  
> >  		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
> > -		if (!ret)
> > -			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> > +		if (ret)
> > +			break;
> > +		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> > +		ret = WARN_ON(pkvm_iommu_host_stage2_idmap(addr, addr + size, PKVM_HOST_MEM_PROT));
> 
> [Severity: High]
> Is it intentional that a failure here panics instead of returning the error?
> 
> Assigning WARN_ON to a variable suggests an expectation that it returns,
> but at EL2 it triggers a fatal BRK instruction. This also leaves the prior
> page state update without a rollback.

No need for rollback as it panics.

> 
> >  		break;
> 
> [ ... ]
> 
> > @@ -1029,6 +1031,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
> >  				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
> >  				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> >  	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
> > +	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_MEM_PROT));
> 
> [Severity: High]
> Can an untrusted guest intentionally trigger a host denial of service here?
> 
> By triggering memory sharing hypercalls, a guest might exhaust the IOMMU
> page pool, forcing an allocation failure in pkvm_iommu_host_stage2_idmap.
> Wrapping this fallible outcome in WARN_ON will trigger a hypervisor panic.
> 

The IOMMU can't be exhasuted by design, the same WARN_ON() exist in the
line above for the CPU page table update also.

Thanks,
Mostafa

> >  unlock:
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=7
