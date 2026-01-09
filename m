Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBC830AAB8
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767970674; cv=none; b=SLONBitEe7cROFwGLJ5qUTW3wuPU6zBMlfY+cHzVFj9wEuWJXkO54Bg+JrHSr8Vro1kiPhof5ihVKaacGSJk7xcSVsc5wWRYBzKEg0EcZEK17WWpoYaoN2dHdrMhtlj09fn/yXxQt/+HyvkJtruWpEP0aMD60lxisEIVctNghf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767970674; c=relaxed/simple;
	bh=tjkSki7t+MDCuNV3NXKsspfUt/ZEfvjWzYHjSN+AKkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5pYVCBNjqOgt0BgwXBn17N/9r4Tjy3m+WT/IOXWJQFUuWuZOFzMs7QEd1a8EH05toHV4Ju7l1bQNMxngfDLERXB8DqkKGs0PIH5Za/KwWqmpg9dGgqvoR5jLB71JW1zLs0ycluXrAFDDwNdubwo4AyJdG92XE0qtTRyIwNp/eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iyoj7mRi; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iyoj7mRi"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59b76c092acso1767645e87.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 06:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767970671; x=1768575471; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0PnH1kznkVXMxfKGNOYS4D3+d5D2CLopDWhz5IX94ds=;
        b=iyoj7mRijqtRJTFNOJLAa45E9f3V91YhFqx+6XUJxDWQcO7sQGaD0Uopv5vWv4wvTh
         30nKfi5AqZB0oVCjicDAoWmVrWHXIojXzGuVbaiqXA0Yko6Wz3jz9CXWiKEUUUijsxRL
         6F/GPJ267TPOaTKECJ7XN9b9di0/HSQE6lx9tJcVnB/RGX8jG8f78ntNkuePanz/7XTK
         xbc9wkrVoKuKCsuvFq/KOfvfo2eShvTcblHo/egy3/Gui4Q2LJ254QRg7ps0GTUXzun3
         Xycy6VNy7VnTWYEBS0HP4xywnbfVTHvTByFHUrb/0e04jXuvrka4wJ1TO9xt0fwLrpHy
         8RMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767970671; x=1768575471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PnH1kznkVXMxfKGNOYS4D3+d5D2CLopDWhz5IX94ds=;
        b=IOZvyYjCRoafT7uWVwuzXxlZ2ZYsIw6LnSSz4NahpdRZg4LAiW5qCOBBfwn4RLRD7d
         Ra0D8siXaWBBfCtS6TyWx7I8xgQP2mo6bDItQGT6zIlExw2wVAPCvPK63NGAMuML5anE
         PEjO0eeNcgQo7CtE7uWdJHfrYTNquO/qz1KvYBh/JY1R61mFu+uneoppqa+OUwAFWFnC
         /aRQje2CZAVpJrXOB5wjnPZIpPqXBiMdwJdyEV/dT2S9Ghfh9IZWh+OWe+c5PvEVGpLa
         GIAitV/laAlFlBClJ9TThf4hs4Dfv2nyWrYjOw+U1V1djgXaWipteGyKgdiTgqCuDO7M
         pCng==
X-Gm-Message-State: AOJu0YzF3JXFIBc0yQNg3dQjTAp+5oOpUkbU64q9UkQWlWmGBBJ9dq1U
	SkGyMjmhh2b8EhXjOyQdTvzrrPh7ACRfbCzxzJvfXHhwkBNcXVqUdYyb+wtzMOv8pw==
X-Gm-Gg: AY/fxX6vbE+v7P1jMm9wzZGhtLZVeOBbU8jQByXH9L0K46YkV/+ePvaidb+5p0iv1lS
	Ckvm2+CP8AoeSQQZB9o4KUpjOmxmzzyuDN0vyp5z/GRudfMb2hlYA++RekDr0OHnZ2p4OMABy/V
	FBZRNgJBfRWyFeDxiwNtz03nhjuuwrvJVq+cf5fnDCMAIzCYua4sVKNdXd8KqEJrItuPYhLuZZS
	Lw2aG/yQb4MwbAtljwoheAJX8OEXNJGbBtZvdv/4og9r9pUxQCXEyTKEmONLIyNUdm5+QG7LlVu
	JpZwtEMTY7NVqtSIQCDu2vDb7Cd4lzZd15hmLb8NHs9Ip1Ao8xsBcj5DrJtNb7K0LMbB7XPqU8e
	sgE/uOR1uql1Qfrd/XBEGcQc3hxeNXbjJHyYOpLlfZC98qN96bTyxZaXQ5oPDmaCDsyyeHT9zLl
	wmu7ZY5UdPhxiI7vtBplNU8HBFbljrZmwbHWAIgb+YUCqRmuif
X-Google-Smtp-Source: AGHT+IGe9QuDt1/NJDvUYE/tjx2via43ds8qBVHWx3t/0Dqv3eSdih6PDSJnuV+jJVbn7hXnVy62Fg==
X-Received: by 2002:a05:6512:68b:b0:59b:79e8:248d with SMTP id 2adb3069b0e04-59b79e826aemr1791074e87.38.1767970670434;
        Fri, 09 Jan 2026 06:57:50 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382eb7a50c7sm23096221fa.15.2026.01.09.06.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 06:57:49 -0800 (PST)
Date: Fri, 9 Jan 2026 14:57:46 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 14/30] KVM: arm64: Hook up reclaim hypercall to
 pkvm_pgtable_stage2_destroy()
Message-ID: <lbidorn37ndyu22bg4zjbcqcsrmbyrakcqml2yts4z6uriyno2@ftmjy7dguf6g>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-15-will@kernel.org>
 <bc246bvbf3cg7scut2dcey7tynxqzclyceqv4hhooqacsdzti7@hcaqfbnvebt2>
 <aWESTd5Scyna_3nc@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWESTd5Scyna_3nc@willie-the-truck>

On Friday 09 Jan 2026 at 14:35:57 (+0000), Will Deacon wrote:
> On Tue, Jan 06, 2026 at 02:59:19PM +0000, Quentin Perret wrote:
> > On Monday 05 Jan 2026 at 15:49:22 (+0000), Will Deacon wrote:
> > > During teardown of a protected guest, its memory pages must be reclaimed
> > > from the hypervisor by issuing the '__pkvm_reclaim_dying_guest_page'
> > > hypercall.
> > > 
> > > Add a new helper, __pkvm_pgtable_stage2_reclaim(), which is called
> > > during the VM teardown operation to reclaim pages from the hypervisor
> > > and drop the GUP pin on the host.
> > > 
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/kvm/pkvm.c | 31 ++++++++++++++++++++++++++++++-
> > >  1 file changed, 30 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > index 1814e17d600e..8be91051699e 100644
> > > --- a/arch/arm64/kvm/pkvm.c
> > > +++ b/arch/arm64/kvm/pkvm.c
> > > @@ -322,6 +322,32 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> > >  	return 0;
> > >  }
> > >  
> > > +static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64 end)
> > > +{
> > > +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > > +	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> > > +	struct pkvm_mapping *mapping;
> > > +	int ret;
> > > +
> > > +	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
> > > +		struct page *page;
> > > +
> > > +		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
> > > +					handle, mapping->gfn);
> > > +		if (WARN_ON(ret))
> > > +			return ret;
> > > +
> > > +		page = pfn_to_page(mapping->pfn);
> > > +		WARN_ON_ONCE(mapping->nr_pages != 1);
> > > +		unpin_user_pages_dirty_lock(&page, 1, true);
> > > +		account_locked_vm(current->mm, 1, false);
> > > +		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> > > +		kfree(mapping);
> > 
> > Nit: this might take a while, worth adding a cond_resched() in here?
> 
> Commit 4ddfab5436b6 ("KVM: arm64: Reschedule as needed when destroying
> the stage-2 page-tables") breaks the destruction operation up into
> chunks so we now reschedule from the caller in stage2_destroy_range().
> 
> Do you think we need an additional reschedule?

I would intuitively think so, but I've also just realized we already
don't have that resched for np guests, so this patch is absolutely fine
as-is.

It's just that knocking down a whole 1G (assuming 4K pages) will be
significantly faster for normal KVM than for pKVM. It's one call in
pgtable.c with possibly a single deferred TLBI vs 1 hcall and 1 TLBI per
4K page. But I guess this is really performance tuning, so this can
always come later. Feel free to ignore :)
