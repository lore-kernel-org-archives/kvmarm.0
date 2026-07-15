Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7E33D9029
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 08:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105914; cv=none; b=lYQi2JRTOt2QpZ27IC88sk8hQfTnJa4oJa21rtPDaV/6h078OqoIIsz7m1LvHr2+DNhhVTgYJisXBc3JHRD7IHm4JEOF6TtR8/7t2kuY0GTWnnBMovKUehdoa7qV8jc7GHLaU1aiTry6goY+hXUveGSKF4yLgpvfQVFtKycO4MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105914; c=relaxed/simple;
	bh=Iwsfs2b84NS195cr/SU6ss4Hoz79Im5kadywNGZOKyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDMkAZhMaALPG2S+7eMb+j8fNtUAFd9d2wP9fWgvBpgv5YXYxSpHcPUl+cX69rM1NYvoKajV1PCm/yXemOTfNrY2qL5Qarq8x8DseKftHGlaV7qpHshC9lMIq3inGTeq3CyBtzhSUeU4G/MYMFPLdgL2qzl2YXSJNgiLk+l7H2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KlF5gAxX; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KlF5gAxX"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493f25d47dcso10068285e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 01:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784105909; x=1784710709; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kIeWr4qWe0Ig+GOra4mnZ6mrW3E9gxiXXny9RK2rdMU=;
        b=KlF5gAxXRr58BjSGsNx4mqO5EZeJO3zkTQcJcrNGpSwjYlM/M/b3Ke0I8vLonXzKUd
         9fqSyNtqgni8HK8Ry86uyiFpciDwm79iwlHcMhCt9h1GQpD5WV3HE514IA2WUx6aP3Zz
         zEar21qhi+mkmw+KR2ooIqqe4dmV9nXwHxIC8w7hQ+QUXp1N16a7GUv9CoLRBNb3CQ7C
         T31HNluM2/iJ7wuUaYYFz9zlBPKNsBhzk7PkycJijeAhmIW/2MPZUxWhnfMdq9AkiP0B
         UbHggVmVmNQ4Qb0plEk68QV+CRo0MynUfOJoNJCmLojLJcbOVxLmhzm4Sga2fkUEbwma
         O83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784105909; x=1784710709;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kIeWr4qWe0Ig+GOra4mnZ6mrW3E9gxiXXny9RK2rdMU=;
        b=WIX99GuFxJF9y1LhgSZJnHIga1hXqkKEKgfovWCM6nR2Ysvm6xL/qHL6+yUIh19kjt
         ESSZx/Vj2/qXNTTZfJ5/9v52sjX3/WHvF4mV3bK2IwJJY6+bW5XdcMF9Ask/iyZ6IbCm
         N+xEp36ewlSRCe1MdMsvsypTveDesNXO5sS4dTOvJRR4OMVZpMj3+MQKUHiCqIp1tprk
         GtgzpT/9r4ey/csi1zIT6YAtpUMZ+EscRw/IUymOtjF8DGyCYYrw/TGp2d7D8AXG3L3C
         UZc3X1ih4KvtZafaK78YafCm/XJvorDJm4TR6BUWt7mVgb6q8h3s/IwdryVCpbCZ1wqv
         HJ/A==
X-Forwarded-Encrypted: i=1; AHgh+RpT73xut3DG4qyQ8bdLWR17bwfSChuh70sEgASiR3WCiGEYZa96dMRAN6OebqcprfnnsmTIsxI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxrpQEMvRmStQg+pemWy9H5MlCxZtgGJZX8HwlhnARzz9+7neH
	jLKcnbhMMZzaw3/3ilhaqz/xGjhKFs+pzB3+2mXP1Vuji2WIBxkQ3LZ3itzhAgj4tA==
X-Gm-Gg: AfdE7cn3eOAi7pc4UyE6a8toxvgnsXU2Wa/htG0FmDe4T3pT3SNb962dghieHVhSYJR
	mq79AL06DNW2PamnpHvjWYB85emo6bZJgjEqvB9rvRrQ8FjcSoiofayytIXCmmFbydVjOoFr+Wq
	BxK8Q4LAZftw0KbEcDHQ7floiKmOMuocckXRj4ie+QiSCyfskIVD40sPTd/JKCV+5EMwBb1jS07
	9N6GEVwKQT4vJOeZ8IcFky1+It2UrvmPlMldTYH/oWGzFsMcSiacyG/stva95LHWzUj/DQAdHLs
	qxTaeSbuBtByGY8F0/uE1wN8RG+Sf2y6AdqdqmYBGTMqRxgaom+zpw9t1164tX8niZL3P6Tcy47
	LqfzK+GBHNXAic78rnYvhoE0wzfxC/LN4VkzO6vDqsvRzme+3DJwFK6OwB3F5vZRaolVUjUl+Ig
	sdOPm15yFDzuNjLO+WnAS+96yQSNncyvk+zd34XjwrtiwuuoLlY58=
X-Received: by 2002:a05:600c:34d0:b0:493:ee2b:c876 with SMTP id 5b1f17b1804b1-494eb1b6de3mr83415115e9.35.1784105908213;
        Wed, 15 Jul 2026 01:58:28 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953df0fc6esm25752265e9.9.2026.07.15.01.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 01:58:27 -0700 (PDT)
Date: Wed, 15 Jul 2026 09:58:23 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 03/18] KVM: arm64: Add __hyp_allocator_map for the
 pKVM hyp
Message-ID: <aldLr8Q8ovbwJn65@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-4-vdonnefort@google.com>
 <CA+EHjTwMz+Ojq18Fq9USJqz_pZmemryNhy99Sw36sOejtpaf4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwMz+Ojq18Fq9USJqz_pZmemryNhy99Sw36sOejtpaf4w@mail.gmail.com>

On Tue, Jul 14, 2026 at 06:53:55PM +0100, Fuad Tabba wrote:
> On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > In preparation for the pKVM heap allocator, introduce __hyp_allocator_map()
> > to map a single physical page to a given virtual address in the hypervisor
> > stage-1 page-table.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > index 725bb0fb941d..98a7774b541c 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > @@ -32,5 +32,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
> >  int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
> >  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
> >  phys_addr_t __pkvm_private_range_pa(void *va);
> > +int __hyp_allocator_map(void *va, phys_addr_t phys);
> >
> >  #endif /* __KVM_HYP_MM_H */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index ec59da1322a7..c1c01f81ac5f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -160,6 +160,11 @@ void pkvm_remove_mappings(void *from, void *to)
> >         hyp_spin_unlock(&pkvm_pgd_lock);
> >  }
> >
> > +int __hyp_allocator_map(void *va, phys_addr_t phys)
> > +{
> > +       return __pkvm_create_mappings((unsigned long)va, PAGE_SIZE, phys, PAGE_HYP);
> > +}
> > +
> 
> nit: __hyp_allocator_map() is named for its caller rather than what it does
> (map a single hyp page). Its siblings here (pkvm_create_mappings,
> pkvm_remove_mappings) are named for the operation. Consider a name like
> pkvm_map_page() so it reads as a generic primitive.

IIRC (it was a few years ago) this was a suggestion from Quentin who didn't want
to expose too much of mm and suggested to make it clear that was a function
private to the allocator.

But looking at what we have now. perhaps 

int __pkvm_map_private_pages(phys_addr_t phys, void *addr, size_t size);

And this could verify that addr is actually aprt of the private range

WDYS?

> 
> That said, naming is hard:
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad
> 
> >  int hyp_back_vmemmap(phys_addr_t back)
> >  {
> >         unsigned long i, start, size, end = 0;
> > --
> > 2.55.0.rc2.803.g1fd1e6609c-goog
> >
