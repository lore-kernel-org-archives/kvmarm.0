Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4834EF1F;
	Thu, 27 Aug 2026 04:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787805469; cv=none; b=AS+y7UubvGw5YJ5sWoleCM2K0ruHwj8+OhNxC5Uer7qiaLFtvjUMDGmFxfdIEuf7jJSnd4asb0wFUHOYUitawQaHkQK1hmXOnt6V2E03kwsfqE2I24dTK/9MIanMa6Ck+fpH2aoGUYANLDRpy9hMsnib1QXEpCEX/CsKLZ6NBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787805469; c=relaxed/simple;
	bh=NjWJ6dMRbw0kkXr/0njtHxbP59W1uKKAQPA07UgnXFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apMQ4yDCX6hlF67Tl+RCPrrl5B3r/DweXyrDManCnbWWkomS81FxB93LrnZJduWf5RzwY8U2RIX0c9xWDmDLtUoWAGVRmFheSq1op09cDLUJDbx9yut8SsXDOu6i+lTXhEvm/l/JDmPNtOTCvhbLinWxMqYHYS9rTfiHaXs3Kdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=KnDZ+++M; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="KnDZ+++M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1787805467; x=1819341467;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NjWJ6dMRbw0kkXr/0njtHxbP59W1uKKAQPA07UgnXFc=;
  b=KnDZ+++MkPRcut4SAFG7vQ6PTg4XPmUXxxuQ7OEn9L6as3g4WvF1BkXT
   zA5e7x2iRycuJgy4uQ1oLrAykU4+01ptqg/0HiDdd3dnvp0yz6CBdXAD5
   08iz6YK0vXRikdBBevVe142JynzR58vBpnitx4gcyNnDPfyWfO0lDQfXZ
   oqmth4TfH2oqDY6dlgid/z66XjZbTBEajzmuaIWFS/zBZaLydHWBA6YmL
   KGi4fheWpjoW8Fg6yqr5aQEAXbDr3SNrooppyEVGtU/hMbDebK1JH0Pjo
   52PeU/ln7Esh6Ii2hbBQN7VUBSJT+1e+V1ATV187ufLdcrIPCnVRJDAJX
   g==;
X-CSE-ConnectionGUID: s2v0QaYbRAGYZcFEsd/acQ==
X-CSE-MsgGUID: vg0sPBsHS8aLo7STeWntZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="256508511"
X-IronPort-AV: E=Sophos;i="6.25,246,1779116400"; 
   d="scan'208";a="256508511"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 13:37:40 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 353B85504;
	Thu, 27 Aug 2026 04:37:40 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id D79A61C4B52A;
	Thu, 27 Aug 2026 04:37:39 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 17B3F405EDE;
	Thu, 27 Aug 2026 04:37:20 +0000 (UTC)
Date: Thu, 27 Aug 2026 13:37:18 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Atish Patra <atish.patra@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 13/20] KVM: selftests: Add TEST_EXTRA memory region type
 for "special" memslots
Message-ID: <ao--_gaqpfWir9v4@sm-arm-grace07>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826230511.972824-14-seanjc@google.com>

On Wed, Aug 26, 2026 at 04:05:04PM -0700, Sean Christopherson wrote:
> And another memory region type to deal with extra, one-off memory regions,
> and use the new type to manage x86's SMRAM memslot, as another step towards
> taking the region type instead of the raw memslot in the physical page
> allocator APIs.
> 
> Alternatively, SMRAM setup could simply use the quad-underscore API to
> continue passing in the memslot, but a surprising number of tests use an
> "extra" memslot for a variety of reasons.  I.e. allocating memory from one
> (and exactly one) extra memslot isn't all that rare, and so should be
> treated as normal behavior, not as something extraordinary, as
> quad-underscore functions typically suggest.
> 
> Opportunistically add comments to document the intended usage of the types,
> as the difference between DATA, TEST_DATA, and TEST_EXTRA in particular
> isn't exactly obvious.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++++++++++++---
>  tools/testing/selftests/kvm/include/x86/smm.h |  2 +-
>  .../testing/selftests/kvm/lib/x86/processor.c |  7 ++--
>  3 files changed, 37 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 14f87c8a00ec..f4f4f360a10b 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -82,11 +82,43 @@ struct userspace_mem_regions {
>  	DECLARE_HASHTABLE(slot_hash, 9);
>  };
>  
> +/*
> + * Memory region types are passed to various page allocators to communicate
> + * various properties and metadata related to the allocation.  Note, the
> + * descriptions below described the primary usage of each type.  Individual
> + * tests may allocate memory for other purposes.
> + *
> + * By default, all regions are mapped to memslot '0'.  Tests can override the
> + * memslot for any or all types, e.g. so that all test data is allocated from a
> + * curated memslot.
> + */

This is helpful as it wasn't so obvious to me. Thanks for adding the comments 
on the default behaviour.

Thanks,
Itaru.

>  enum kvm_mem_region_type {
> +	/*
> +	 * The CODE region is used by lib/elf when loading the test's code into
> +	 * guest memory.
> +	 */
>  	MEM_REGION_CODE,
> +	/*
> +	 * The DATA region is used to allocate core data structures, e.g. vCPU
> +	 * stacks, VM exception tables, x86's TSS, etc.
> +	 */
>  	MEM_REGION_DATA,
> +	/*
> +	 * The PT region, a.k.a. Page Table region, is used to allocate page
> +	 * table pages.
> +	 */
>  	MEM_REGION_PT,
> +	/*
> +	 * The TEST_DATA region is used for allocating test data that is either
> +	 * test specific, and/or isn't considered a "core" data structure.
> +	 */
>  	MEM_REGION_TEST_DATA,
> +	/*
> +	 * The TEST_EXTRA region is for special snowflakes, where a test wants
> +	 * to create and use a one-off memslot, without impacting "normal" test
> +	 * data allocations.
> +	 */
> +	MEM_REGION_TEST_EXTRA,
>  	NR_MEM_REGIONS,
>  };
>  
> @@ -129,11 +161,6 @@ struct kvm_vm {
>  
>  	struct kvm_binary_stats stats;
>  
> -	/*
> -	 * KVM region slots. These are the default memslots used by page
> -	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
> -	 * memslot.
> -	 */
>  	u32 memslots[NR_MEM_REGIONS];
>  };
>  
> diff --git a/tools/testing/selftests/kvm/include/x86/smm.h b/tools/testing/selftests/kvm/include/x86/smm.h
> index 2d1afa09819b..15faaa060126 100644
> --- a/tools/testing/selftests/kvm/include/x86/smm.h
> +++ b/tools/testing/selftests/kvm/include/x86/smm.h
> @@ -8,7 +8,7 @@
>  #define SMRAM_MEMSLOT	((1 << 16) | 1)
>  #define SMRAM_PAGES	(SMRAM_SIZE / PAGE_SIZE)
>  
> -void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, u64 smram_gpa,
> +void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, gpa_t smram_gpa,
>  		 const void *smi_handler, size_t handler_size);
>  
>  void inject_smi(struct kvm_vcpu *vcpu);
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index ea5fa59888af..b988eea373ad 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -1468,11 +1468,12 @@ bool kvm_arch_has_default_irqchip(void)
>  	return true;
>  }
>  
> -void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, u64 smram_gpa,
> +void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, gpa_t smram_gpa,
>  		 const void *smi_handler, size_t handler_size)
>  {
> -	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, smram_gpa,
> -				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
> +	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS,
> +			       smram_gpa, SMRAM_MEMSLOT, SMRAM_PAGES);
> +
>  	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, smram_gpa,
>  				       SMRAM_MEMSLOT) == smram_gpa,
>  		    "Could not allocate guest physical addresses for SMRAM");
> -- 
> 2.55.0.887.g758fc8c411-goog
> 
