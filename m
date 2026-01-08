Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61292FA0C6
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897086; cv=none; b=KETAUWb05ZJpzMtrrv5WG1jqYtG+Ji1G3IpweWqiWhuTWaTr/HoGcVdbzX7+qFb8dzr47VyfJiHOSd05WaQQmy16Rx4ZzQcCcRpDK54xsWGtJtzq7ZrWkHu8dQmcG1lBy4556wnDe8gYTVx9kL8i59Zg0FZfBTUUhM9NL/RYxk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897086; c=relaxed/simple;
	bh=HiZzKC6IpEiXD+YG7Xq5JdCfDWfJLzGMhECalIcNpBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lifUdc5vGUZEIzcpUhggK9OdXwEyJ4WH+z5aCyepEAokPgMWzIT22PvHOX6904LsgPEdYBjrNLkSHuzfDvnDGs80PoLxYAJPI8AZkJLrQNIZxJEw1SoVPn4HF+QXOUTm5gxSF3RThCeSFgp9QH1dEkaYJk/3oMG6OFN7Gs1bSYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M1iKyuMV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M1iKyuMV"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so7845909a91.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 10:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767897084; x=1768501884; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nY/l54WU76DsZYqDI43j/uSoqA/+4oD9QHehzkck2fM=;
        b=M1iKyuMViBxJejpHmLtu8hIy1ZKVHbNoIgeBaU/IEBk7xYB6ailRSQEWo/UUHieOfC
         wyi+050o6TianzOfoM5r/20DB8ix77oSS11kvRI4brXPcn9hqfNjk0xGbUq/miuvWbEd
         p4EkSkEi5g3xFK124rB8D6vkEpMrNfSZ2SGiT/zd8w1ntQhON0zPndkTuTBWka2QBIe/
         kL90pYb4TjlNuIcjwsVI+q54swOXwL1KfuLkkrkQyu5CB9KLPwDhkRH7pqr6+pW/Zl7l
         5rqnHxivDbyNfAMKTWuLMx+00iIoqF73vGQsi2B8w+huIwmkiCX5RoHl0PzgQ1+XQzMD
         zJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767897084; x=1768501884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nY/l54WU76DsZYqDI43j/uSoqA/+4oD9QHehzkck2fM=;
        b=VUDcCWryTT0pMMZ2dmdk4zpgKO6CSvjv28ZjOEdgJmvxYvbrxL+6wyE+Qc64wCXORM
         Q3UUqkZ2riYlOjYDrC1zWLaj53l6s5o36q0dQrMEHiz4Ng7DwMFTj4bSs44Wvzwlxems
         jf2+HMAxDp3D0Q9NG+OTLfccg14TDg3seWLGAvapY+j4ULSzAcajNy3VsrZWdM9eSgiQ
         3tSrwwpa3QQ84AEmLX1rptHzmg95R7LSd29fy8dkttvlhDtwaKuvDsP0AZY53OQV9esP
         lPSh++NLZ2b/AEQayUNvf/m9/FceGhdnUyR95T0oBmlnwxW3GufyeQjHLhOllhhrVmuz
         ChVA==
X-Forwarded-Encrypted: i=1; AJvYcCWUvgT+iHotyoTCfottqDBp1blWB0w89uddbUvmDtXmpN9gRwJe1m90pZnSgSBDmXdBJlIzR+M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6dYPFO0ccWD6p8nDw+DRFgwJGePu74jylE96zBO+oAX85jwoi
	EDuImX+eRJz3FpsjwKwndg0JS2u4NveVsPixjgpDULLPAB4Zm8GmQwHWjnyrCBBIMVFgXR3111Y
	SOqbaeQ==
X-Google-Smtp-Source: AGHT+IHEOdI4r0O9pcHM188bqvdusRA2ROI4oJ6wpZajhgwchTGU2kxOjQW3XQ2z18n6bt3vYCQzcYAxHoc=
X-Received: from pjrx16.prod.google.com ([2002:a17:90a:bc90:b0:34c:6f7a:2ab8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c09:b0:349:2154:eef4
 with SMTP id 98e67ed59e1d1-34f68b83d71mr6555128a91.5.1767897083980; Thu, 08
 Jan 2026 10:31:23 -0800 (PST)
Date: Thu, 8 Jan 2026 10:31:22 -0800
In-Reply-To: <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com> <20251230230150.4150236-22-seanjc@google.com>
 <t7dcszq3quhqprdcqz7keykxbmqf62pdelqrkeilpbmsrnuji5@a3lplybmlbwf>
 <aV_cLAlz4v1VOkDt@google.com> <gzyjze3wszmrwxdwnudij6nfqdxzihm37uappfqxorfjy5vatf@hffzaobbm3g7>
Message-ID: <aV_3-lhnZ-MoKnjv@google.com>
Subject: Re: [PATCH v4 21/21] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> On Thu, Jan 08, 2026 at 08:32:44AM -0800, Sean Christopherson wrote:
> > On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> > index ab869a98bbdc..fab18e9be66c 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> > @@ -390,6 +390,13 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
> >  	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
> >  }
> >  
> > +uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa)
> 
> nested_paddr is the name used by tdp_map(), maybe use that here as well
> (and in the header)?

Oh hell no :-)  nested_paddr is a terrible name (I was *very* tempted to change
it on the fly, but restrained myself).  "nested" is far too ambigous, e.g. without
nested virtualization, "nested_paddr" arguably refers to _L1_ physical addresses
(SVM called 'em Nested Page Tables after all).

> > +	int level = PG_LEVEL_4K;
> > +
> > +	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
> > +}
> > +
> >  uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
> >  {
> >  	int level = PG_LEVEL_4K;
> [..]
> > @@ -133,35 +220,50 @@ static void test_dirty_log(bool nested_tdp)
> >  
> >  	/* Add an extra memory slot for testing dirty logging */
> >  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> > -				    GUEST_TEST_MEM,
> > +				    TEST_MEM_BASE,
> >  				    TEST_MEM_SLOT_INDEX,
> >  				    TEST_MEM_PAGES,
> >  				    KVM_MEM_LOG_DIRTY_PAGES);
> >  
> >  	/*
> > -	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
> > +	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
> >  	 * affects both L1 and L2.  However...
> >  	 */
> > -	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
> > +	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
> >  
> >  	/*
> > -	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
> > -	 * 0xc0000000.
> > +	 * ... pages in the L2 GPA ranges [0xc0001000, 0xc0002000) and
> > +	 * [0xc0003000, 0xc0004000) will map to 0xc0000000 and 0xc0001000
> > +	 * respectively.
> 
> Are these ranges correct? I thought L2 GPA range [0xc0002000,
> 0xc0004000) will map to [0xc0000000, 0xc0002000).

Gah, no.  I looked at the comments after changing things around, but my eyes had
glazed over by that point.

> Also, perhaps it's better to express those in terms of the macros?
> 
> L2 GPA range [TEST_MEM_ALIAS_BASE, TEST_MEM_ALIAS_BASE + 2*PAGE_SIZE)
> will map to [TEST_MEM_BASE, TEST_MEM_BASE + 2*PAGE_SIZE)?

Hmm, no, at some point we need to concretely state the addresses, so that people
debugging this know what to expect, i.e. don't have to manually compute the
addresses from the macros in order to debug.

> >  	 *
> >  	 * When TDP is disabled, the L2 guest code will still access the same L1
> >  	 * GPAs as the TDP enabled case.
> > +	 *
> > +	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
> > +	 * writable SPTEs when handling read faults (if the Dirty bit isn't
> > +	 * set, KVM must intercept the next write to emulate the Dirty bit
> > +	 * update).
> >  	 */
> >  	if (nested_tdp) {
> > +		vm_vaddr_t gva0 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 0);
> > +		vm_vaddr_t gva1 = TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, 1);
> 
> Why are these gvas? Should these be L2 GPAs?

Pure oversight.

> Maybe 'uint64_t l2_gpa0' or 'uint64_t nested_paddr0'?

For better of worse, vm_paddr_t is the typedef in selftests.  Hmm, if/when we go
with David M's proposal to switch to u64 (from e.g. uint64_t), it'd probably be
a good time to switch to KVM's gva_t and gpa_t as well.

> Also maybe add TEST_ALIAS_GPA() macro to keep things consistent?

Ya, then the line lengths are short enough to omit the local variables.  How's
this look?

	/*
	 * ... pages in the L2 GPA address range [0xc0002000, 0xc0004000) will
	 * map to [0xc0000000, 0xc0002000) when TDP is enabled (for L2).
	 *
	 * When TDP is disabled, the L2 guest code will still access the same L1
	 * GPAs as the TDP enabled case.
	 *
	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
	 * writable SPTEs when handling read faults (if the Dirty bit isn't
	 * set, KVM must intercept the next write to emulate the Dirty bit
	 * update).
	 */
	if (nested_tdp) {
		tdp_identity_map_default_memslots(vm);
		tdp_map(vm, TEST_ALIAS_GPA(0), TEST_GPA(0), PAGE_SIZE);
		tdp_map(vm, TEST_ALIAS_GPA(1), TEST_GPA(1), PAGE_SIZE);

		*tdp_get_pte(vm, TEST_ALIAS_GPA(0)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
		*tdp_get_pte(vm, TEST_ALIAS_GPA(1)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
	} else {
		*vm_get_pte(vm, TEST_GVA(0)) |= PTE_DIRTY_MASK(&vm->mmu);
		*vm_get_pte(vm, TEST_GVA(1)) |= PTE_DIRTY_MASK(&vm->mmu);
	}
