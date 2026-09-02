Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BB2427FA0;
	Wed,  2 Sep 2026 23:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390440; cv=none; b=t+dQQI1UjfUfqEffi2NL7TZdbA1a07lgTumHuIm3JiugCeCN/DrZJqmg+z/WJOfbI0Yezytv/EFWTACImrRUI/l+EJiNPuTkIzzIwyZUh/iLZ9WnklTiMNNIxKnS5rpIYMf6buPAsfQz6i64nBjxLzmn2KBrddeog+llKRJROTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390440; c=relaxed/simple;
	bh=DGhH14+yE9nyt5xO4fYtNZdDfh3D8lYk97bpxGHpfRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTE203pQW/7UVOuOrUZs0Xz6Oa5g5nKo6tDngvrAI/zgaxeAxiDqsLavEDLJjE4Tjh+CT0sDO2cFuyT4MJQIdK2nfC61tXgn36+fMWlEPiw3YODfGuM0DXL28aDMQw+4WSCzkSrVtwhevN7NggGaJw56FR0lIVQgus8KUhHfJWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=t5dNdh6q; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="t5dNdh6q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1788390438; x=1819926438;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DGhH14+yE9nyt5xO4fYtNZdDfh3D8lYk97bpxGHpfRM=;
  b=t5dNdh6qef8rjrmdmA0TuPE5wuyxk+sYrgnYft3yj9tEw3DjKOBdrGtL
   hU4/LslmQSSpTrJBM05FvRcVKbV1qf19zReL1yvVy6CjLZjfPDzXirWcr
   eEIw87VOCqb9NrW5a3ksj/QHNhm46aB2Ezb5Y6Dz0TDFYdfn/yqtJ4HXN
   wHxNZY7PAzs5RySNrGWsWZMYwLMH7ZMQD0Vs/b1vzmDe4t8YWRlLiYdja
   UB9iapTMI1pEGVjT4+pxQ/cSCMZj0CLN9rDrRePFSMuxVFqyXf5uERtOH
   aE5PRb3MtJexIrp7Mma0iB3Hwpkee1Ny/fMw2PUcv8hcTu7QfLtCr6XbM
   Q==;
X-CSE-ConnectionGUID: OEHQqluPRyWjBP8Jt6ZXZg==
X-CSE-MsgGUID: Fn/56boBToijD0wpLfRSEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="253617835"
X-IronPort-AV: E=Sophos;i="6.25,258,1779116400"; 
   d="scan'208";a="253617835"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 08:07:08 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id CBC661002BA5;
	Wed,  2 Sep 2026 23:07:07 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 7A94B18000DC;
	Wed,  2 Sep 2026 23:07:07 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 9805E18021BF;
	Wed,  2 Sep 2026 23:06:57 +0000 (UTC)
Date: Thu, 3 Sep 2026 08:06:54 +0900
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
Subject: Re: [PATCH v2 00/20] KVM: selftests: PPC pre-enabling
Message-ID: <apisDlhdG7xNDVyl@sm-arm-grace07>
References: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>

On Wed, Sep 02, 2026 at 09:41:03AM -0700, Sean Christopherson wrote:
> This is a big pile of cleanups and refactoring to prepare for PPC support in
> KVM selftests.  PPC has paging modes that require multi-page page tables, and
> those page tables need to be naturally aligned.  The original proposal was to
> plumb in an @align param to the page allocators[*], but I didn't love the idea
> of adding another rarely used param to the allocators.
> 
> v2:
>  - Collect tags. [Itaru, Bibo]

I ran kvm_page_table_test for arm64 again it went ok on HW.

Tested-by: Itaru Kitayam <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.
>  - Use 0x180000 as the min GPA for page table pages on LoongArch, instead of
>    changing every other arch to use 0x200000. [Sashiko, Bibo]
>  - Opportunistically move the vGIC LPI stress test's global "gpa_base" variable
>    into setup_memslot(). [Sashiko]
> 
> v1: https://lore.kernel.org/all/20260826230511.972824-1-seanjc@google.com
> 
> [*] https://lore.kernel.org/all/df86b5ccdbdafc3509d9538bd5e6796737bab2db.1781093720.git.ritesh.list@gmail.com
> 
> Nicholas Piggin (1):
>   KVM: selftests: Use goto instead of do-while to retry finding unused
>     physical pages
> 
> Sean Christopherson (19):
>   KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390
>     regions/segments
>   KVM: selftests: Use the common minimum GPA for page tables on
>     LoongArch
>   KVM: selftests: Use vm_alloc_page_table() to allocate LoongArch page
>     tables
>   KVM: selftests: Rename "num" param to "nr_pages" for physical page
>     allocators
>   KVM: selftests: Extend page allocator to support naturally aligned
>     allocations
>   KVM: selftests: Make the single-page allocator APIs static inline
>   KVM: selftests: Use the innermost page allocator API in the memslot
>     perf test
>   KVM: selftests: Use the innermost page allocator API in s390's IRQ
>     routing test
>   KVM: selftests: Add a wrapper API to allocate multiple page table
>     pages
>   KVM: selftests: Initialize vm->memslots[] with invalid memslots during
>     creation
>   KVM: selftests: Add APIs to override memory region types with custom
>     memslots
>   KVM: selftests: Add TEST_EXTRA memory region type for "special"
>     memslots
>   KVM: selftests: Use TEST_EXTRA region in arm64's vGIC LPI stress test
>   KVM: selftests: Use TEST_EXTRA region in x86's smaller MAXPHYADDR test
>   KVM: selftests: Use TEST_EXTRA region in set memory region test
>   KVM: selftests: Take the memory region type, not memslot, in page
>     allocators
>   KVM: selftests: Use TEST_ASSERT(), not assert(), in
>     vm_get_mem_region()
>   KVM: selftests: Automatically pick min_gpa for allocations based on
>     region type
>   KVM: selftests: Add arch hook to force page tables to be naturally
>     aligned
> 
>  .../selftests/kvm/arm64/page_fault_test.c     |  18 ++-
>  .../selftests/kvm/arm64/vgic_lpi_stress.c     |  21 ++-
>  .../testing/selftests/kvm/include/kvm_util.h  | 106 +++++++++++++--
>  tools/testing/selftests/kvm/include/x86/smm.h |   2 +-
>  .../selftests/kvm/lib/arm64/processor.c       |   4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 127 +++++++++++-------
>  .../selftests/kvm/lib/loongarch/processor.c   |   5 +-
>  .../selftests/kvm/lib/riscv/processor.c       |   4 +-
>  .../selftests/kvm/lib/s390/processor.c        |   7 +-
>  .../testing/selftests/kvm/lib/x86/processor.c |  15 ++-
>  .../testing/selftests/kvm/memslot_perf_test.c |   3 +-
>  tools/testing/selftests/kvm/s390/cmma_test.c  |  19 +--
>  .../testing/selftests/kvm/s390/irq_routing.c  |   2 +-
>  .../selftests/kvm/set_memory_region_test.c    |   8 +-
>  .../x86/smaller_maxphyaddr_emulation_test.c   |   9 +-
>  15 files changed, 221 insertions(+), 129 deletions(-)
> 
> 
> base-commit: 76671054f9a1ff6abb976583cd8da37650acdc97
> -- 
> 2.55.0.966.g6673acef38-goog
> 
