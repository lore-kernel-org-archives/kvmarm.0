Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360852638BC
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839669; cv=none; b=DFtenmGRquPGzjPMbm4RL7Pauw5GNcK8scUPmYjhVX/tpSVL9uhDMDHag59rSNK2abNLisSPJcFIcXU2NOpz7R9bmKQVOhxIILVxDkic/5DiVdU7JgRDW7vn9B1Fy2qrLV1WbPW/Zyk1r9/13moRcYJ0jH2dNhjNySJjb6SQBY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839669; c=relaxed/simple;
	bh=gvQ8rMV/nb8TfMKY/OICnkCcrY8IEDx2ni4D9u6xW5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivBsIEk/BGdWF4p7XJwXQ2MiTC/xh3iSEb7SDKTfnmEEEIK5U/VxRyJzDkVhvazWhIfvhCPQ5ufJ4rXb5FKug8hbUoNGvnKwuDqOw41nP7AcRvDiQ9pkjXGt0hlATfQiqvvNdI57R5XdHTLP3SkJ0QmP7uge/+eDiue2//imgNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LBr1PAtn; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LBr1PAtn"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-429bccca1e8so85563f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 08:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761839665; x=1762444465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7c6+XrmoyFowwhGbEiLq66X/torWpHDQ+1RsFmcHlWE=;
        b=LBr1PAtnp4PdH3qPXJdDqhuLhGmeOsSZ2OKm+2CcTIpRaEKTdSMtxMnLZ6gvtxBWLL
         77u5ao61HkVlEIfhs7y8e7wpj+yW9S8WHWMAktLEtPBDld1PAiOJ3pcJW6hmWChxg1MA
         ORLhKLcVQgyL/eCdqldOPqsNDQq7MAdc29/jy4HGadpYCp6aoDegON53XpUBuSmeyQ//
         4C4TO3Nk6qTgPT/oH9naEmJmbxVw7+5RzPhIQtMw1j1vMNjwHckJn/MLLQJj5lDugLIa
         Y3DcBPyNPmNEjWChl9g7PeWHUm2n3iUOjJqi/+Hj86jxAWD2/27muOxKg+Vplit9it+Y
         mEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761839665; x=1762444465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7c6+XrmoyFowwhGbEiLq66X/torWpHDQ+1RsFmcHlWE=;
        b=ICzDLbt/MAHbfYrT5o4hYAEVc0Tjxub9wABhh0Z9XFX//H0c8E9yUnx7GXtF0Umha4
         tenCx6LYjyIPlOzuGH8tuUKeJp9ZYjzQgdyrfCp5ifdxJTjHzCkVR3bT8bB6l2UlwAab
         tyM/YF6Nk65OoeEbco2p0ZGIXSFlHt/ABA1zIPh57ND9Qf8BzH8dGo5l4mzEWwqcl+iF
         OC47Pfz9lr3vgNYkdRogI25AduXPd4EVAWTs1fhlXEGiSYG+b2O5tH2yzpniIHv5SLVs
         LhMHSfaBwAfzP2lC8vMmjjpk1HF2iSIIsRoKd5pNIG3dm+10kDOa5FKowVXSn9TCcaAB
         6vOA==
X-Forwarded-Encrypted: i=1; AJvYcCWP+E9dD8A86KCUBgthqsOG/FyxPDNb1dErR7mLAMbVtChN6y63kMNx0Ol/KN857y6BNMPlzC0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6NOAWl1C9rqtE6qxr97FqwXjQGlCbfXCwytXKj1mMdXZr+HdL
	UtKZXvo49BoP03j4E/kX/JdriEjADYmQ8VrazGR9xp+RESx30JBCoIYur5nwZC6xpA==
X-Gm-Gg: ASbGncvTBJccrxVg0nkSmaBMxJ4mimVqsvZPP+oLK1UnyVgztby7WRp4d0BsvkS11pg
	aMGRch2rENsaFvtN3u4eVGcjfTnvhZ1DWxcsFG5oJhhj08FD8BaFPwdii1GL0r6G57dOHV96t7f
	s6Uql4AVTtePfhwpfyKL+NhRkjeAOwxgw0mMWBdDtDmEd/4e3Z8F+/tusSZZMjGVaxft0Vz6sav
	SbZ91hJJTfu9Ldf1BKL3qIzXa6+0rFQo3ihnTmk1bPU33dz2WOvic66ATM1MLeoWTgD/QbQ9L3d
	OS24/AvOTzt96sWsZbKajwFOfzudjIs1ywjkj9Eygh3Kfsc3dDOmdOr/DDD/QQ/0oR43HrRhqbU
	CFqq29MNBHOwLVWNfscRSFVCVTzumDK1bI0MmInmE7Oyd700xNB2D6EtW8lYhx7IdI9UWawt9MR
	xbzOyMMiBwRodasq49R5/Xt0ezpyPx60OnRI6soUWFtcX2dyLh+aE=
X-Google-Smtp-Source: AGHT+IFcl4Bo2iRnn9SQ4R5pthHC8V2HygnH866pn1+ULEALSY6EUZm9nBo5CT91dKPigulLVZJWlg==
X-Received: by 2002:a05:6000:2485:b0:426:d82f:889e with SMTP id ffacd0b85a97d-429bd67c45dmr79155f8f.14.1761839665373;
        Thu, 30 Oct 2025 08:54:25 -0700 (PDT)
Received: from google.com (218.131.22.34.bc.googleusercontent.com. [34.22.131.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952db9c6sm33378016f8f.36.2025.10.30.08.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 08:54:24 -0700 (PDT)
Date: Thu, 30 Oct 2025 15:54:21 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
	keirf@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v3] KVM: arm64: Check range args for pKVM mem transitions
Message-ID: <aQOKLaCKUDcqIZeM@google.com>
References: <20251016164541.3771235-1-vdonnefort@google.com>
 <aQMBG0SUlNWuQQFZ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQMBG0SUlNWuQQFZ@google.com>

On Thu, Oct 30, 2025 at 06:09:31AM +0000, Sebastian Ene wrote:
> On Thu, Oct 16, 2025 at 05:45:41PM +0100, Vincent Donnefort wrote:
> > There's currently no verification for host issued ranges in most of the
> > pKVM memory transitions. The end boundary might therefore be subject to
> > overflow and later checks could be evaded.
> > 
> > Close this loophole with an additional pfn_range_is_valid() check on a
> > per public function basis. Once this check has passed, it is safe to
> > convert pfn and nr_pages into a phys_addr_t and a size.
> > 
> > host_unshare_guest transition is already protected via
> > __check_host_shared_guest(), while assert_host_shared_guest() callers
> > are already ignoring host checks.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > ---
> > 
> > v2 -> v3: 
> >    * Test range against PA-range and make the func phys specific.
> > 
> > v1 -> v2:
> >    * Also check for (nr_pages * PAGE_SIZE) overflow. (Quentin)
> >    * Rename to check_range_args().
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index ddc8beb55eee..49db32f3ddf7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -367,6 +367,19 @@ static int host_stage2_unmap_dev_all(void)
> >  	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
> >  }
> 
> Hello Vincent,
> 
> >  
> > +/*
> > + * Ensure the PFN range is contained within PA-range.
> > + *
> > + * This check is also robust to overflows and is therefore a requirement before
> > + * using a pfn/nr_pages pair from an untrusted source.
> > + */
> > +static bool pfn_range_is_valid(u64 pfn, u64 nr_pages)
> > +{
> > +	u64 limit = BIT(kvm_phys_shift(&host_mmu.arch.mmu) - PAGE_SHIFT);
> > +
> > +	return pfn < limit && ((limit - pfn) >= nr_pages);
> > +}
> > +
> 
> This newly introduced function is probably fine to be called without the host lock held as long
> as no one modifies the vtcr field from the host.mmu structure. While
> searching I couldn't find a place where this is directly modified so
> this is probably fine. 
> 
> >  struct kvm_mem_range {
> >  	u64 start;
> >  	u64 end;
> > @@ -776,6 +789,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> >  	void *virt = __hyp_va(phys);
> >  	int ret;
> >  
> > +	if (!pfn_range_is_valid(pfn, nr_pages))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	hyp_lock_component();
> >  
> > @@ -804,6 +820,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
> >  	u64 virt = (u64)__hyp_va(phys);
> >  	int ret;
> >  
> > +	if (!pfn_range_is_valid(pfn, nr_pages))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	hyp_lock_component();
> >  
> > @@ -887,6 +906,9 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
> >  	u64 size = PAGE_SIZE * nr_pages;
> >  	int ret;
> >  
> > +	if (!pfn_range_is_valid(pfn, nr_pages))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
> >  	if (!ret)
> > @@ -902,6 +924,9 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
> >  	u64 size = PAGE_SIZE * nr_pages;
> >  	int ret;
> >  
> > +	if (!pfn_range_is_valid(pfn, nr_pages))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
> >  	if (!ret)
> > @@ -945,6 +970,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
> >  	if (prot & ~KVM_PGTABLE_PROT_RWX)
> >  		return -EINVAL;
> >  
> > +	if (!pfn_range_is_valid(pfn, nr_pages))
> > +		return -EINVAL;
> > +
> 
> I think we don't need it here because __pkvm_host_share_guest has the
> __guest_check_transition_size verification in place which limits
> nr_pages.  

__guest_check_transition size will only limit to PMD_SIZE, which can be quite a
big number if you consider > 4KiB pages systems. So I believe this is still a loophole
worth fixing.

> 
> >  	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
> >  	if (ret)
> >  		return ret;
> > 
> > base-commit: 7ea30958b3054f5e488fa0b33c352723f7ab3a2a
> > -- 
> > 2.51.0.869.ge66316f041-goog
> >
> 
> Other than that this looks good, thanks
> Sebastian

Thanks for having a look at the patch.
