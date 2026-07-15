Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36DE3F9F50
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 09:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107517; cv=none; b=mNBv1PdouCOC9FtN3hSPz47dYBTDItxgMnpNZjOWT05fB2T9qpEpwYZytn6O31GEsmJwPfM76BKwkly9xKlRzh8lbNB3xPzk/YgPYEnbI+xAyJAaWuvVPewRZDopgZpwgVgUE/2e2hs1aTPwXEf7Af+7TBkNm2nOxXUIY/nIjzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107517; c=relaxed/simple;
	bh=bipou2n4Ny3s/PmOdgBrIIOpkUOIAkXsNkhFJKAjA/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gCu1wAsqmhqjqP1BNwtyEHVI7ruAzXfLR6ZmT+8irpe15fYYerz70N3izeXrTF1fVnSe4wuEse13rsTYaFEMHtK0h9P/5R7ZP9UXYJp4BDmFbWHHvj8PqD4gRpp3LgLYGPjmBH4DwtYm5CkuTNptmvXJwvZOpVqsfzrMUiBxUX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wR2yQTgP; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wR2yQTgP"
X-Forwarded-Encrypted: i=1; AHgh+RpbXF9qRZehG7Fhd4SoLWazbnATIo9iZ9+8bDIglZjLmZ17FGi2cKNk3qBIrtSxdbJ2S7sr60s=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784107512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D8L3uGHgLcf/igUtWS55TK+4P/oGWvA3mv3iBU6z/Aw=;
	b=wR2yQTgPSNlRKoNPUq73WYDZsWal6C7XWPUF7IXkxBISJK4hp765zNSZSAMuEP95tGLCA9
	aCiiMUQWUdf/HkBU/Fnk7amZMz3WLyunZVvOg7Ye7zDXYe9U25m5dJAF/0+biVw3yckYqE
	35+k43nEgu6lDJg/9FbUY07iApEVziA=
X-Gm-Message-State: AOJu0YzdVv9Bqqa8jgVylSPkipuMhb1+D5XQUoKr2zal4SLq37nTLvZe
	Y/QD6+e8QPCmC0u0dUyj3EKqrk6NT4P3M2LyelwRnRSWNwwcQp0sR7M2jkwDHBy4DTRtWBgdj+T
	Grk0aL6iJEZdoHp0YGupBwOqc4GRAhU2IdKNik7lO
X-Received: by 2002:a05:622a:1b1e:b0:51c:e80:9e88 with SMTP id
 d75a77b69052e-51d7bdcb646mr22804061cf.16.1784107508780; Wed, 15 Jul 2026
 02:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-4-vdonnefort@google.com> <CA+EHjTwMz+Ojq18Fq9USJqz_pZmemryNhy99Sw36sOejtpaf4w@mail.gmail.com>
 <aldLr8Q8ovbwJn65@google.com>
In-Reply-To: <aldLr8Q8ovbwJn65@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 10:24:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyGvdtdRxg26vn=Q+WmvD_SbtGv8k16n4cmjj5F=iA16A@mail.gmail.com>
X-Gm-Features: AUfX_mzCdU7u3cBE7CE0uYYU76Eti9noWqGhANeOIbGRQdNqLbyidXbeHXiJ9DA
Message-ID: <CA+EHjTyGvdtdRxg26vn=Q+WmvD_SbtGv8k16n4cmjj5F=iA16A@mail.gmail.com>
Subject: Re: [PATCH v2 03/18] KVM: arm64: Add __hyp_allocator_map for the pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Wed, 15 Jul 2026 at 09:58, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Tue, Jul 14, 2026 at 06:53:55PM +0100, Fuad Tabba wrote:
> > On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> > >
> > > In preparation for the pKVM heap allocator, introduce __hyp_allocator_map()
> > > to map a single physical page to a given virtual address in the hypervisor
> > > stage-1 page-table.
> > >
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > > index 725bb0fb941d..98a7774b541c 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > > @@ -32,5 +32,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
> > >  int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
> > >  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
> > >  phys_addr_t __pkvm_private_range_pa(void *va);
> > > +int __hyp_allocator_map(void *va, phys_addr_t phys);
> > >
> > >  #endif /* __KVM_HYP_MM_H */
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > index ec59da1322a7..c1c01f81ac5f 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > @@ -160,6 +160,11 @@ void pkvm_remove_mappings(void *from, void *to)
> > >         hyp_spin_unlock(&pkvm_pgd_lock);
> > >  }
> > >
> > > +int __hyp_allocator_map(void *va, phys_addr_t phys)
> > > +{
> > > +       return __pkvm_create_mappings((unsigned long)va, PAGE_SIZE, phys, PAGE_HYP);
> > > +}
> > > +
> >
> > nit: __hyp_allocator_map() is named for its caller rather than what it does
> > (map a single hyp page). Its siblings here (pkvm_create_mappings,
> > pkvm_remove_mappings) are named for the operation. Consider a name like
> > pkvm_map_page() so it reads as a generic primitive.
>
> IIRC (it was a few years ago) this was a suggestion from Quentin who didn't want
> to expose too much of mm and suggested to make it clear that was a function
> private to the allocator.
>
> But looking at what we have now. perhaps
>
> int __pkvm_map_private_pages(phys_addr_t phys, void *addr, size_t size);
>
> And this could verify that addr is actually aprt of the private range
>
> WDYS?

I think this sounds better. That was a nit, so up to you.

Thanks,
/fuad

>
> >
> > That said, naming is hard:
> >
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> >
> > Cheers,
> > /fuad
> >
> > >  int hyp_back_vmemmap(phys_addr_t back)
> > >  {
> > >         unsigned long i, start, size, end = 0;
> > > --
> > > 2.55.0.rc2.803.g1fd1e6609c-goog
> > >
