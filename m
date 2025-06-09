Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16967253933
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749478880; cv=none; b=Z6ycu1LthFLvuPtXgJr1IPLwrLHDTZYAN1nyHFMVPMtC1RA2npHYOZD5SKe35l0AuF5fa+pUW1E7q/ELWnz89x4xDmOkAkFfjKZLrevZD+rQTieP25Zmb3SVcovdSyucZncTKZVOzbeLyDddRgp1dxKQYOuu2GAk5INAGb9vktE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749478880; c=relaxed/simple;
	bh=wNCK673TSNOcz+SGKsVUt9JPBx+XFVGFRTrhCpLO0Lk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TtxtgmzLUT+eUrK9/Kq36m2R4usspTKZ+99YoHAhZmtLMeBCplPRSoXiSfGpdBF2XUbpdUsUcvT9S4OVTCyWqC2U5wyAYpD5xxjtu35AXUc3QqQrcjH6eQM4bBTN3+oaULms9Ozj0AeUV8J+KGbvsd13D3J4Klb+/dZSHHOtCxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QJLWYofg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QJLWYofg"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26db9af463so4002091a12.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 07:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749478877; x=1750083677; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LSIEw/2MydfV3kI4WHDS//5IkvGuSP6WLCIhrE/jR14=;
        b=QJLWYofglVfKYMgkP0dlwrDbKN7yjvRwItPrbb/2i+go0OWtkGjQDrCwi0/sg3b8RF
         kdw58DT8lel7ERZJBzfk39P6F6cJ7OXA8nUJZsHtRk5hKhaIfyY8qfVOcCGpC8tlXjjy
         l9SP4oTnu767lUZj+ZnjgwRueIRQY8q3wJ1yyVCQUdLqcmYkwM5Ct3jR+9jZdug1q5ee
         9giGkc7ybRQO8qHzdRnmC6HJTgBcLY98g2TmmepXZUu01S8zmTOOGdkNo45vpiQSaHQi
         8EcQpFP5fcOGLwqKMZBz+1FWA95A03v7zW/oF51BV0XnQSQpyNvGE5RrqgOwcjrPkg5F
         bT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749478877; x=1750083677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSIEw/2MydfV3kI4WHDS//5IkvGuSP6WLCIhrE/jR14=;
        b=qsmCUmbWDl2zrGEWdGIy8s++x+6npeNQtTplc07J7Jrn6By0PClX/SOEjMlKI8a3yN
         yIye7F+PKpz29Ra5OnfyqsGxOP/YGshPRBfHs2brLC8qgwkj/MD0P2u38juiG+EaW5DI
         OMEZgp6HVEBysohtVbXq8eZBM6AOy3JUYrAxFVSFWMc4UEx4Lmc+t5xhRUCgSo0GI/n6
         gg0JnIwQQDkpaRyKrSyzO3bwSn7wqB6KBLSgiVlR5fmhnq7564JJ6bebydgf4jVLQ/lo
         4OEfLck/NeQnUl2MyCkDFGNUb1r+AMbltht+q42oIanGfwUR2Y1UYua9YQ/LLRDOElvq
         eWGw==
X-Forwarded-Encrypted: i=1; AJvYcCVFMhbpdfE6H8haYvjQms+t87/l8CzeEcFQQ2gnoYJDjhlwohyLywibdD0YNOY/V9ccKjtZlus=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXum/cVxf1TNBz3mDx64rrFDEjKced7U0h4AGB77ZQUwjX1cTZ
	A5Pipf5IB/5gu1CyzHdVGloqYZh39LGH92Ng3hCOsFmL8oe8SRp6str9jNY3PKc3ed17G+yT4y0
	rX0vvmg==
X-Google-Smtp-Source: AGHT+IERysFaxhAHifqxHTi2VcbI8oY5rYOLco6ZrI9WGaP0rXEe5OjT6M/29a/9l0QmkI+VOJHg1ucx2CE=
X-Received: from plbju5.prod.google.com ([2002:a17:903:4285:b0:234:45eb:5e18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f544:b0:235:f3e6:467f
 with SMTP id d9443c01a7336-23601cf6bd8mr192715225ad.2.1749478877172; Mon, 09
 Jun 2025 07:21:17 -0700 (PDT)
Date: Mon, 9 Jun 2025 07:21:16 -0700
In-Reply-To: <20250609122402.GM19710@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250524013943.2832-1-ankita@nvidia.com> <20250524013943.2832-2-ankita@nvidia.com>
 <aEMvbIu530nCqwhG@google.com> <20250609122402.GM19710@nvidia.com>
Message-ID: <aEbm64VUr_GmBFzI@google.com>
Subject: Re: [PATCH v6 1/5] KVM: arm64: Block cacheable PFNMAP mapping
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com, 
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com, 
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, kjaju@nvidia.com, 
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, 
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, 
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com, 
	alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com, 
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org, 
	ddutile@redhat.com, tabba@google.com, qperret@google.com, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 09, 2025, Jason Gunthorpe wrote:
> On Fri, Jun 06, 2025 at 11:11:56AM -0700, Sean Christopherson wrote:
> > > @@ -1612,6 +1624,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >  
> > >  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> > >  
> > > +	if ((vma->vm_flags & VM_PFNMAP) &&
> > > +	    !mapping_type_noncacheable(vma->vm_page_prot))
> > 
> > I don't think this is correct, and there's a very real chance this will break
> > existing setups.  PFNMAP memory isn't strictly device memory, and IIUC, KVM
> > force DEVICE/NORMAL_NC based on kvm_is_device_pfn(), not based on VM_PFNMAP.
> 
> kvm_is_device_pfn() effecitvely means KVM can't use CMOs on that
> PFN. It doesn't really mean anything more..

Ah, kvm_is_device_pfn() isn't actually detecting device memory, it's simply
detecting memory that isn't in the direct map.

> PFNMAP says the same thing, or at least from a mm perspective we don't
> want drivers taking PFNMAP memory and then trying to guess if there
> are struct pages/KVAs for it. PFNMAP memory is supposed to be fully
> opaque.
> 
> Though that confusion seems to be a separate issue from this patch.
> 
> > 	if (kvm_is_device_pfn(pfn)) {
> > 		/*
> > 		 * If the page was identified as device early by looking at
> > 		 * the VMA flags, vma_pagesize is already representing the
> > 		 * largest quantity we can map.  If instead it was mapped
> > 		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
> > 		 * and must not be upgraded.
> > 		 *
> > 		 * In both cases, we don't let transparent_hugepage_adjust()
> > 		 * change things at the last minute.
> > 		 */
> > 		device = true;
> 
> "device" here is sort of a mis-nomer, it is really just trying to
> setup the S2 so that CMOs are not going go to be done.
> 
> Calling it 'disable_cmo' would sure make this code clearer..
> 
> > @@ -1639,6 +1653,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                 return -EFAULT;
> >  
> >         if (kvm_is_device_pfn(pfn)) {
> > +               if (is_vma_cacheable)
> > +                       return -EINVAL;
> > +
> 
> eg
> 
> if (!kvm_can_use_cmo_pfn(pfn)) {
>                if (is_vma_cacheable)
>                        return -EINVAL;
> 
> >                  * If the page was identified as device early by looking at
> >                  * the VMA flags, vma_pagesize is already representing the
> > @@ -1722,6 +1739,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                 prot |= KVM_PGTABLE_PROT_X;
> >  
> >         if (device) {
> > +               if (is_vma_cacheable) {
> > +                       ret = -EINVAL;
> > +                       goto out;
> > +               }
> 
> if (disable_cmo) {
>                if (is_vma_cacheable)
>                        return -EINVAL;
> 
> Makes alot more sense, right? If KVM can't do CMOs then it should not
> attempt to use memory mapped into the VMA as cachable.

Yes, for sure.

> >                 if (vfio_allow_any_uc)
> >                         prot |= KVM_PGTABLE_PROT_NORMAL_NC;
> >                 else
> > 
> 
> Regardless, this seems good for this patch at least.
> 
> Jason
