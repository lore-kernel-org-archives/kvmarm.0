Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9E4632
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753453883; cv=none; b=bOmmkub9xz/wI7AUBzWS1wd4huC2jKdGBSQsToteiUr5yIfOuRYFqxjLf96O9Hv1uQsdL/5pnj1h8+GpaPxg9Xj4LWg6uX6QA2DZURqVPBTiPuGECXDO3pb8YEh2VFbUTH+bAwMTpdDFZC4wsC9nMVqhMUIqQWZz4I0yzLdfrlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753453883; c=relaxed/simple;
	bh=hdTHRGzuOh2e7oTuO84AHI/Xh/FB6b40cEq3EBdmGL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QwD6fGS2NIxb4t0nKTElrm/tiBd7bKoqvO8gTJcLdFiCvodJV0hNXSXRyqNF0/m/nge79Uhwjh5Z8QYzsM/iRdmVEuDKg1grj0i4YWNhuVgNj4HvMbRWt/PTL9p4KqiTHFA+Jj4fcoiUp4bRIGpBYRNnf9hjqCkXtWh4qr7P1eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G7/T4JYj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G7/T4JYj"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so3431860a91.2
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753453879; x=1754058679; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
        b=G7/T4JYjYxcxQmJo50UF4GScYD7Uo+UBv/uH/D0OPPkzqEp3rD8uqN6YDArFI4AsN7
         onJXb1cRm1XMIaIsuiGf2WSfjSjXX4k8RaCdRVXlTvwIqaNyHxmV1RgtB5TX6SejtY1v
         bl2b5if4Pb3gU3l9WjSLZ9/SHxxreVIz9PQl9xjrGkEwhNgSHKcqz3/JImJL3Za62jcU
         5XyfyRCd9P0ivhudv6AH2Y3Ou9Bd3b740bIuzxBWw3zd+R6HbY3vGZK6gsL336xGhRcK
         NofjdwftCz1kg5NskUF6XSn9yemGVK3QWSWUYb75HVAS85TzIYXjNxrUXwFOIxHzqrMr
         eeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753453879; x=1754058679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
        b=CaD3oTsbSQajZniwN5uxI84AZ7z/7IjLJ82cSecaUZjTSC0okuyFG/zI3hKNMMF+0f
         1iAW+JZ7gqX+4yNFu+YJM1hdWTPA+0PjZ0I3+dqAEcWHVHzi8YTO4MXSPQu0FiG0Dk/U
         I5Z5w022SgV6arHuOxXE3NOBNNe37PwKgNo6ati8RRAEwPZHB1+vL5V/u7Yh4NkHwV/d
         lk38pnnyDavICo/052ByqAHEkXaREJ35uTqZFlSxv+HIQSJNT4i0zFtsrBl7IkSqU03N
         N8mgdblIGoL2lazMO7OxnI+jCZFBvaFAB71ukkHqwkhgo2VTHgcwT1fAiUcDxqS5uQ1Z
         3alQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5oQ/n5eVXrS4VYnKI/PIaWTOXXe/wQfZNKcb5YX1wz7jb1cZPyC4j3IF8RTHLTs8Kv1XF8yw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSZYmJL2r94L08iM16iv1AY0AQmn2SJhvH6A55VhoSS1NeDVfN
	ey+F2Igvad3tVLgnj8whtVImdGr7T0C0LU91a+jyMJENm14+doowIcugfMdgQbZNuwJZDZw5B9T
	HqCYa6A==
X-Google-Smtp-Source: AGHT+IE8bQ5HIcB35TZztW6FFUKXkhZH35KfVngtYR8izSfmiidEbwmwtOeAPOCK2rACB2xK1aj7frwF+1I=
X-Received: from pjbnr22.prod.google.com ([2002:a17:90b:2416:b0:31e:780c:e3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:554d:b0:31e:3848:c9ee
 with SMTP id 98e67ed59e1d1-31e77a2f69emr3502891a91.9.1753453879518; Fri, 25
 Jul 2025 07:31:19 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:31:17 -0700
In-Reply-To: <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIOVNcp7p2hU-YHM@google.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Sean Christopherson <seanjc@google.com> writes:
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 20dd9f64156e..c4ff8b4028df 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
> >>  	return PG_LEVEL_4K;
> >>  }
> >>  
> >> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> >> -					u8 max_level, int gmem_order)
> >> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> >> +					const struct kvm_memory_slot *slot, gfn_t gfn)
> >
> > Would you consider renaming this kvm_max_gmem_mapping_level()? Or
> > something that doesn't limit the use of this function to private memory?

Heh, see the next patch, which does exactly that and is appropriately titled
"KVM: x86/mmu: Extend guest_memfd's max mapping level to shared mappings".

> >> -	u8 req_max_level;
> >> +	u8 max_level, coco_level;
> >> +	struct page *page;
> >> +	kvm_pfn_t pfn;
> >>  
> >> -	if (max_level == PG_LEVEL_4K)
> >> -		return PG_LEVEL_4K;
> >> +	/* For faults, use the gmem information that was resolved earlier. */
> >> +	if (fault) {
> >> +		pfn = fault->pfn;
> >> +		max_level = fault->max_level;
> >> +	} else {
> >> +		/* TODO: Constify the guest_memfd chain. */
> >> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
> >> +		int max_order, r;
> >> +
> >> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
> >> +		if (r)
> >> +			return PG_LEVEL_4K;
> >> +
> >> +		if (page)
> >> +			put_page(page);
> >
> > When I was working on this, I added a kvm_gmem_mapping_order() [1] where
> > guest_memfd could return the order that this gfn would be allocated at
> > without actually doing the allocation. Is it okay that an
> > allocation may be performed here?

No, it's not.  From a guest_memfd semantics perspective, it'd be ok.  But allocating
can block, and mmu_lock is held here.

I routed this through kvm_gmem_get_pfn(), because for this code to do the right
thing, KVM needs to the PFN.  That could be plumbed in from the existing SPTE, but
I don't love the idea of potentially mixing the gmem order for pfn X with pfn Y
from the SPTE, e.g. if the gmem backing has changed and an invalidation  is pending.

KVM kinda sorta has such races with non-gmem memory, but for non-gmem KVM will never
fully consume a "bad" PFN, whereas for this path, KVM could (at least in theory)
immediately consume the pfn via an RMP lookup.  Which is probably fine?  but I
don't love it.

I assume getting the order will basically get the page/pfn as well, so plumbing
in the pfn from the SPTE, *knowing* that it could be stale, feels all kinds of
wrong.

I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?

	/* For faults, use the gmem information that was resolved earlier. */
	if (fault) {
		pfn = fault->pfn;
		max_level = fault->max_level;
	} else {
		/* TODO: Call into guest_memfd once hugepages are supported. */
		pfn = KVM_PFN_ERR_FAULT;
		max_level = PG_LEVEL_4K;
	}

	if (max_level == PG_LEVEL_4K)
		return max_level;

or alternatively:

	/* For faults, use the gmem information that was resolved earlier. */
	if (fault) {
		pfn = fault->pfn;
		max_level = fault->max_level;
	} else {
		/* TODO: Call into guest_memfd once hugepages are supported. */
		return PG_LEVEL_4K;
	}

	if (max_level == PG_LEVEL_4K)
		return max_level;

Functionally, it's 100% safe, even if/when guest_memfd supports hugepages.  E.g.
if we fail/forget to update this code, the worst case scneario is that KVM will
neglect to recover hugepages.

While it's kinda weird/silly, I'm leaning toward the first option of setting
max_level and relying on the common "max_level == PG_LEVEL_4K" check to avoid
doing an RMP looking with KVM_PFN_ERR_FAULT.  I like that it helps visually
captures that KVM needs to get both the max_level *and* the pfn from guest_memfd.

> > [1] https://lore.kernel.org/all/20250717162731.446579-13-tabba@google.com/
> >
> >> +
> >> +		max_level = kvm_max_level_for_order(max_order);
> >> +	}
> >>  
> >> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> >>  	if (max_level == PG_LEVEL_4K)
> >> -		return PG_LEVEL_4K;
> >> +		return max_level;
> >
> > I think the above line is a git-introduced issue, there probably
> > shouldn't be a return here.
> >
> 
> My bad, this is a correct short-circuiting of the rest of the function
> since there's no smaller PG_LEVEL than PG_LEVEL_4K.

Off topic: please trim your replies.
